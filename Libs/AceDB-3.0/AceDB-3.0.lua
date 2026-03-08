--[[
    AceDB-3.0 — Stub
    STUB: Echte Version von CurseForge/WoWAce laden!
    https://www.curseforge.com/wow/addons/ace3

    AceDB-3.0 bietet persistente Datenbank-Verwaltung über SavedVariables
    mit Profil-Support und Default-Werten.
]]

local MAJOR, MINOR = "AceDB-3.0", 27
local AceDB = LibStub:NewLibrary(MAJOR, MINOR)
if not AceDB then return end

--- Deep-Copy einer Table (für Defaults)
local function deepCopy(src, dest)
    dest = dest or {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = deepCopy(v, dest[k])
        elseif dest[k] == nil then
            dest[k] = v
        end
    end
    return dest
end

--- Erstellt eine neue Datenbank
---@param svName string Name der SavedVariable (aus .toc)
---@param defaults table Default-Werte
---@param defaultProfile boolean|string Default-Profil verwenden
---@return table db Datenbank-Objekt
function AceDB:New(svName, defaults, defaultProfile)
    -- SavedVariable laden oder erstellen
    if not _G[svName] then
        _G[svName] = {}
    end

    local sv = _G[svName]
    local db = {}

    -- Profil-Name bestimmen
    local profileName = "Default"
    if type(defaultProfile) == "string" then
        profileName = defaultProfile
    end

    -- Profil-Storage initialisieren
    if not sv.profiles then sv.profiles = {} end
    if not sv.profiles[profileName] then sv.profiles[profileName] = {} end

    -- Defaults einmischen
    local profile = sv.profiles[profileName]
    if defaults and defaults.profile then
        deepCopy(defaults.profile, profile)
    end

    -- DB-Objekt zusammenbauen
    db.profile = profile
    db.sv = sv
    db.profileName = profileName

    --- Profil zurücksetzen
    function db:ResetProfile()
        wipe(self.profile)
        if defaults and defaults.profile then
            deepCopy(defaults.profile, self.profile)
        end
    end

    return db
end
