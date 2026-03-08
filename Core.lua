--[[
    WipeGuide Core
    Addon-Initialisierung, Event-System, Slash-Commands
    WIPE AG © 2026
]]

-- Globaler Namespace
WipeGuide = LibStub("AceAddon-3.0"):NewAddon("WipeGuide", "AceEvent-3.0", "AceConsole-3.0")

-- Lokale Referenzen für Performance
local WG = WipeGuide
local L -- Locale-Table, wird in OnInitialize gesetzt

-- Versionsinformationen
WG.version = "0.1.0"
WG.guides = {} -- Registrierte Guides: key = guidePath, value = guideData

-- Default-Einstellungen für AceDB
local defaults = {
    profile = {
        -- Guide Viewer
        guideViewer = {
            point = "RIGHT",
            x = -50,
            y = 0,
            width = 300,
            height = 400,
            alpha = 0.9,
            locked = false,
            minimized = false,
        },
        -- Waypoint Arrow
        waypoint = {
            enabled = true,
            scale = 1.0,
            alpha = 1.0,
        },
        -- Auto-Quest
        autoQuest = {
            acceptEnabled = false,
            turninEnabled = false,
        },
        -- Aktiver Guide
        activeGuide = nil,
        activeStep = 1,
        completedSteps = {},
    },
}

--------------------------------------------------------------------------------
-- Addon Lifecycle
--------------------------------------------------------------------------------

function WG:OnInitialize()
    -- Datenbank laden/erstellen
    self.db = LibStub("AceDB-3.0"):New("WipeGuideDB", defaults, true)

    -- Locale laden
    L = WG.L or {}

    -- Slash-Commands registrieren
    self:RegisterChatCommand("wipe", "SlashCommand")
    self:RegisterChatCommand("wipeguide", "SlashCommand")

    self:Print(string.format("|cFF00FF00WipeGuide v%s|r %s", self.version, L["loaded"] or "geladen!"))
end

function WG:OnEnable()
    -- Quest-Events registrieren
    self:RegisterEvent("QUEST_ACCEPTED", "OnQuestAccepted")
    self:RegisterEvent("QUEST_TURNED_IN", "OnQuestTurnedIn")
    self:RegisterEvent("QUEST_LOG_UPDATE", "OnQuestLogUpdate")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnZoneChanged")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")

    -- Module aktivieren
    if self.GuideViewer then self.GuideViewer:Enable() end
    if self.Waypoint then self.Waypoint:Enable() end
    if self.AutoQuest then self.AutoQuest:Enable() end
end

function WG:OnDisable()
    self:UnregisterAllEvents()
end

--------------------------------------------------------------------------------
-- Slash-Command Handler
--------------------------------------------------------------------------------

function WG:SlashCommand(input)
    input = (input or ""):trim():lower()

    if input == "" or input == "help" then
        self:Print("|cFF00FF00/wipe|r — " .. (L["show_guide"] or "Guide-Fenster anzeigen/verstecken"))
        self:Print("|cFF00FF00/wipe config|r — " .. (L["open_settings"] or "Einstellungen öffnen"))
        self:Print("|cFF00FF00/wipe list|r — " .. (L["list_guides"] or "Verfügbare Guides auflisten"))
        self:Print("|cFF00FF00/wipe load <name>|r — " .. (L["load_guide"] or "Guide laden"))
        self:Print("|cFF00FF00/wipe reset|r — " .. (L["reset_position"] or "Fenster-Position zurücksetzen"))
    elseif input == "config" or input == "settings" then
        self:OpenSettings()
    elseif input == "list" then
        self:ListGuides()
    elseif input:find("^load ") then
        local guideName = input:sub(6)
        self:LoadGuide(guideName)
    elseif input == "reset" then
        self:ResetFramePositions()
    else
        -- Ohne Argument: Guide-Fenster togglen
        self:ToggleGuideViewer()
    end
end

--------------------------------------------------------------------------------
-- Guide Management
--------------------------------------------------------------------------------

--- Registriert einen neuen Guide (wird von Guide-Dateien aufgerufen)
---@param path string Guide-Pfad z.B. "Leveling\\Duskwood\\Duskwood_20_25"
---@param data table Guide-Daten mit steps, author, zone etc.
function WG:RegisterGuide(path, data)
    if not path or not data or not data.steps then
        self:Print("|cFFFF0000Fehler:|r Ungültiger Guide: " .. tostring(path))
        return
    end
    data.path = path
    self.guides[path] = data
end

--- Registriert eine Kampagne (Sammlung von Guide-Kapiteln)
WG.campaigns = {}
function WG:RegisterCampaign(path, data)
    if not path or not data then return end
    data.path = path
    self.campaigns[path] = data
end

--- Listet alle registrierten Guides im Chat auf
function WG:ListGuides()
    local count = 0
    for path, data in pairs(self.guides) do
        count = count + 1
        local info = string.format("  |cFF00CCFF%s|r — %s (Lv %d-%d, %d Steps)",
            path, data.zone or "?", data.startLevel or 0, data.endLevel or 0, #data.steps)
        self:Print(info)
    end
    if count == 0 then
        self:Print(L["no_guides"] or "Keine Guides geladen.")
    else
        self:Print(string.format(L["guides_count"] or "%d Guide(s) verfügbar.", count))
    end
end

--- Lädt einen Guide anhand seines Pfads
---@param path string Guide-Pfad
function WG:LoadGuide(path)
    -- Suche case-insensitive
    for guidePath, data in pairs(self.guides) do
        if guidePath:lower():find(path, 1, true) then
            self.db.profile.activeGuide = guidePath
            self.db.profile.activeStep = 1
            self.db.profile.completedSteps = {}
            self:Print(string.format(L["guide_loaded"] or "Guide geladen: |cFF00CCFF%s|r", guidePath))
            self:SendMessage("WIPEGUIDE_GUIDE_LOADED", guidePath)
            return
        end
    end
    self:Print(string.format(L["guide_not_found"] or "Guide nicht gefunden: |cFFFF0000%s|r", path))
end

--- Gibt den aktuellen Guide und Step zurück
---@return table|nil guideData
---@return table|nil stepData
---@return number stepIndex
function WG:GetCurrentStep()
    local guidePath = self.db.profile.activeGuide
    if not guidePath or not self.guides[guidePath] then
        return nil, nil, 0
    end
    local guide = self.guides[guidePath]
    local stepIdx = self.db.profile.activeStep or 1
    local step = guide.steps[stepIdx]
    return guide, step, stepIdx
end

--- Geht zum nächsten Step
function WG:NextStep()
    local guide, _, stepIdx = self:GetCurrentStep()
    if not guide then return end
    if stepIdx < #guide.steps then
        self.db.profile.activeStep = stepIdx + 1
        self:SendMessage("WIPEGUIDE_STEP_CHANGED", stepIdx + 1)
    else
        self:Print(L["guide_complete"] or "|cFF00FF00Guide abgeschlossen!|r")
        self:SendMessage("WIPEGUIDE_GUIDE_COMPLETE")
    end
end

--- Geht zum vorherigen Step
function WG:PrevStep()
    local guide, _, stepIdx = self:GetCurrentStep()
    if not guide then return end
    if stepIdx > 1 then
        self.db.profile.activeStep = stepIdx - 1
        self:SendMessage("WIPEGUIDE_STEP_CHANGED", stepIdx - 1)
    end
end

--- Springt zu einem bestimmten Step
---@param index number Step-Index
function WG:GoToStep(index)
    local guide = self:GetCurrentStep()
    if not guide then return end
    if index >= 1 and index <= #guide.steps then
        self.db.profile.activeStep = index
        self:SendMessage("WIPEGUIDE_STEP_CHANGED", index)
    end
end

--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------

function WG:OnQuestAccepted(event, questID)
    local guide, step, stepIdx = self:GetCurrentStep()
    if not step then return end
    -- Auto-Advance wenn der aktuelle Step eine accept-Quest ist
    if step.type == "accept" and step.quest == questID then
        self.db.profile.completedSteps[stepIdx] = true
        self:NextStep()
    end
end

function WG:OnQuestTurnedIn(event, questID, xpReward, moneyReward)
    local guide, step, stepIdx = self:GetCurrentStep()
    if not step then return end
    if step.type == "turnin" and step.quest == questID then
        self.db.profile.completedSteps[stepIdx] = true
        self:NextStep()
    end
end

function WG:OnQuestLogUpdate(event)
    -- Prüfe ob der aktuelle Kill/Collect-Step erledigt ist
    local guide, step, stepIdx = self:GetCurrentStep()
    if not step or not step.quest then return end

    if (step.type == "kill" or step.type == "collect") then
        if C_QuestLog.IsQuestFlaggedCompleted(step.quest) then
            self.db.profile.completedSteps[stepIdx] = true
            self:NextStep()
        end
    end
end

function WG:OnZoneChanged(event)
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return end
    -- Prüfe ob es einen Guide für die aktuelle Zone gibt
    for path, data in pairs(self.guides) do
        if data.mapID == mapID and path ~= self.db.profile.activeGuide then
            self:Print(string.format(
                L["guide_available"] or "Guide verfügbar für diese Zone: |cFF00CCFF%s|r — /wipe load %s",
                data.zone or path, path:lower()))
            break
        end
    end
end

function WG:OnPlayerEnteringWorld(event, isLogin, isReload)
    if isLogin or isReload then
        -- Guide Viewer wiederherstellen wenn ein Guide aktiv war
        if self.db.profile.activeGuide and self.guides[self.db.profile.activeGuide] then
            self:SendMessage("WIPEGUIDE_GUIDE_LOADED", self.db.profile.activeGuide)
        end
    end
end

--------------------------------------------------------------------------------
-- UI Helpers
--------------------------------------------------------------------------------

function WG:ToggleGuideViewer()
    if self.GuideViewer then
        self.GuideViewer:Toggle()
    end
end

function WG:OpenSettings()
    -- InterfaceOptionsFrame_OpenToCategory ist deprecated ab 11.0
    -- Settings.OpenToCategory ist der neue Weg
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory("WipeGuide")
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("WipeGuide")
    end
end

function WG:ResetFramePositions()
    self.db.profile.guideViewer.point = "RIGHT"
    self.db.profile.guideViewer.x = -50
    self.db.profile.guideViewer.y = 0
    if self.GuideViewer then
        self.GuideViewer:RestorePosition()
    end
    self:Print(L["position_reset"] or "Fenster-Position zurückgesetzt.")
end
