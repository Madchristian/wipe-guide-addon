--[[
    WipeGuide — Settings Module
    Options Panel mit Toggles für Blizzard Interface Options
]]

local WG = WipeGuide
local L

local Settings = {}
WG.Settings = Settings

-- Checkbox-Referenzen für spätere Updates
local checkboxes = {}

--------------------------------------------------------------------------------
-- Helper: Checkbox erstellen
--------------------------------------------------------------------------------

--- Erstellt eine Checkbox im Settings-Panel
---@param parent Frame Parent-Frame
---@param name string Eindeutiger Name
---@param label string Anzeige-Text
---@param tooltip string Tooltip-Text
---@param y number Y-Offset
---@param getValue function Getter für den aktuellen Wert
---@param setValue function Setter für den neuen Wert
---@return CheckButton
local function CreateCheckbox(parent, name, label, tooltip, y, getValue, setValue)
    local cb = CreateFrame("CheckButton", "WipeGuide" .. name .. "Check", parent, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, y)

    -- Text setzen (WoW nutzt den globalen String "WipeGuide<Name>CheckText")
    local text = _G[cb:GetName() .. "Text"]
    if text then
        text:SetText(label)
    end

    cb.tooltipText = label
    cb.tooltipRequirement = tooltip

    cb:SetChecked(getValue())
    cb:SetScript("OnClick", function(self)
        local checked = self:GetChecked()
        setValue(checked)
        PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    checkboxes[name] = cb
    return cb
end

--------------------------------------------------------------------------------
-- Panel aufbauen
--------------------------------------------------------------------------------

function Settings:Initialize()
    L = WG.L or {}

    local panel = WipeGuideSettingsPanel
    if not panel then return end

    -- Version anzeigen
    panel.version:SetText("v" .. WG.version)

    -- Panel-Name für Settings API
    panel.name = "WipeGuide"

    local yOffset = -60

    -- === Auto-Quest Sektion ===
    local sectionTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    sectionTitle:SetPoint("TOPLEFT", 16, yOffset)
    sectionTitle:SetText("|cFFFFCC00" .. (L["auto_quest_header"] or "Auto-Quest") .. "|r")
    yOffset = yOffset - 30

    CreateCheckbox(panel, "AutoAccept",
        L["auto_accept"] or "Quests automatisch annehmen",
        L["auto_accept_tip"] or "Nimmt Quests automatisch an, die im aktuellen Guide stehen.",
        yOffset,
        function() return WG.db.profile.autoQuest.acceptEnabled end,
        function(v) WG.db.profile.autoQuest.acceptEnabled = v end
    )
    yOffset = yOffset - 30

    CreateCheckbox(panel, "AutoTurnin",
        L["auto_turnin"] or "Quests automatisch abgeben",
        L["auto_turnin_tip"] or "Gibt erledigte Quests automatisch ab (außer bei Belohnungsauswahl).",
        yOffset,
        function() return WG.db.profile.autoQuest.turninEnabled end,
        function(v) WG.db.profile.autoQuest.turninEnabled = v end
    )
    yOffset = yOffset - 40

    -- === Waypoint Sektion ===
    local waypointTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    waypointTitle:SetPoint("TOPLEFT", 16, yOffset)
    waypointTitle:SetText("|cFFFFCC00" .. (L["waypoint_header"] or "Wegpunkt-Pfeil") .. "|r")
    yOffset = yOffset - 30

    CreateCheckbox(panel, "WaypointEnabled",
        L["waypoint_toggle"] or "Richtungspfeil anzeigen",
        L["waypoint_toggle_tip"] or "Zeigt einen Richtungspfeil zum nächsten Ziel an.",
        yOffset,
        function() return WG.db.profile.waypoint.enabled end,
        function(v)
            WG.db.profile.waypoint.enabled = v
            if not v and WG.Waypoint then
                WG.Waypoint:ClearTarget()
            end
        end
    )
    yOffset = yOffset - 40

    -- === UI Sektion ===
    local uiTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    uiTitle:SetPoint("TOPLEFT", 16, yOffset)
    uiTitle:SetText("|cFFFFCC00" .. (L["ui_header"] or "Benutzeroberfläche") .. "|r")
    yOffset = yOffset - 30

    CreateCheckbox(panel, "LockFrame",
        L["lock_frame"] or "Guide-Fenster fixieren",
        L["lock_frame_tip"] or "Verhindert das Verschieben des Guide-Fensters.",
        yOffset,
        function() return WG.db.profile.guideViewer.locked end,
        function(v) WG.db.profile.guideViewer.locked = v end
    )

    -- Panel bei Blizzard registrieren (Retail 11.0+ API)
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, "WipeGuide")
        Settings.RegisterAddOnCategory(category)
    elseif InterfaceOptions_AddCategory then
        -- Fallback für ältere Versionen
        InterfaceOptions_AddCategory(panel)
    end
end

-- Settings beim Addon-Load initialisieren
WG.RegisterMessage(WG, "WIPEGUIDE_GUIDE_LOADED", function()
    -- Lazy init: Erst beim ersten Guide-Load
    if not Settings._initialized then
        Settings:Initialize()
        Settings._initialized = true
    end
end)

-- Auch direkt beim Enable initialisieren
local origEnable = WG.OnEnable
function WG:OnEnable()
    if origEnable then origEnable(self) end
    Settings:Initialize()
    Settings._initialized = true
end
