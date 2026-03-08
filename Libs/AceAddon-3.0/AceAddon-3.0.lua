--[[
    AceAddon-3.0 — Stub
    STUB: Echte Version von CurseForge/WoWAce laden!
    https://www.curseforge.com/wow/addons/ace3

    AceAddon-3.0 bietet ein Framework für Addon-Erstellung mit Modulen,
    Event-Handling und Lifecycle-Management.
]]

local MAJOR, MINOR = "AceAddon-3.0", 13
local AceAddon = LibStub:NewLibrary(MAJOR, MINOR)
if not AceAddon then return end

AceAddon.addons = AceAddon.addons or {}

--- Erstellt ein neues Addon
function AceAddon:NewAddon(name, ...)
    local addon = setmetatable({}, { __index = AceAddon })
    addon.name = name
    addon.modules = {}
    addon.orderedModules = {}
    addon.baseMixins = { ... }

    -- Mixin-Methoden (AceEvent, AceConsole etc.)
    for i = 1, select("#", ...) do
        local mixin = select(i, ...)
        local lib = LibStub(mixin, true)
        if lib then
            for k, v in pairs(lib) do
                if type(v) == "function" then
                    addon[k] = v
                end
            end
        end
    end

    -- Basis-Event-Methoden falls kein AceEvent
    if not addon.RegisterEvent then
        local events = {}
        local eventFrame = CreateFrame("Frame")
        eventFrame:SetScript("OnEvent", function(self, event, ...)
            if events[event] then
                for _, handler in ipairs(events[event]) do
                    handler(addon, event, ...)
                end
            end
        end)

        function addon:RegisterEvent(event, handler)
            if not events[event] then
                events[event] = {}
                eventFrame:RegisterEvent(event)
            end
            local fn = type(handler) == "string" and self[handler] or handler
            table.insert(events[event], fn)
        end

        function addon:UnregisterEvent(event)
            events[event] = nil
            eventFrame:UnregisterEvent(event)
        end

        function addon:UnregisterAllEvents()
            wipe(events)
            eventFrame:UnregisterAllEvents()
        end
    end

    -- AceConsole Stubs
    if not addon.RegisterChatCommand then
        function addon:RegisterChatCommand(cmd, handler)
            local fn = type(handler) == "string" and self[handler] or handler
            SlashCmdList[cmd:upper()] = function(msg)
                fn(self, msg)
            end
            _G["SLASH_" .. cmd:upper() .. "1"] = "/" .. cmd
        end

        function addon:Print(...)
            local prefix = "|cFF33FF99" .. (self.name or "Addon") .. "|r: "
            DEFAULT_CHAT_FRAME:AddMessage(prefix .. table.concat({...}, " "))
        end
    end

    -- Message-System (interne Addon-Events)
    local messages = {}
    function addon:RegisterMessage(msg, handler)
        if not messages[msg] then messages[msg] = {} end
        local fn = type(handler) == "function" and handler or self[handler]
        table.insert(messages[msg], fn)
    end

    function addon:SendMessage(msg, ...)
        if messages[msg] then
            for _, fn in ipairs(messages[msg]) do
                fn(self, msg, ...)
            end
        end
    end

    AceAddon.addons[name] = addon

    -- OnInitialize wird nach ADDON_LOADED aufgerufen
    local loader = CreateFrame("Frame")
    loader:RegisterEvent("ADDON_LOADED")
    loader:SetScript("OnEvent", function(self, event, addonName)
        if addonName == name or addonName == "WipeGuide" then
            if addon.OnInitialize then addon:OnInitialize() end
            if addon.OnEnable then addon:OnEnable() end
            self:UnregisterAllEvents()
        end
    end)

    return addon
end

function AceAddon:GetAddon(name)
    return self.addons[name]
end
