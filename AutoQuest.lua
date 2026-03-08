--[[
    WipeGuide — AutoQuest Module
    Automatisches Quest Accept / Turn-in (togglebar)
]]

local WG = WipeGuide
local L

local AutoQuest = {}
WG.AutoQuest = AutoQuest

--------------------------------------------------------------------------------
-- Lifecycle
--------------------------------------------------------------------------------

function AutoQuest:Enable()
    L = WG.L or {}

    -- Events registrieren
    WG.RegisterEvent(WG, "QUEST_DETAIL", function() AutoQuest:OnQuestDetail() end)
    WG.RegisterEvent(WG, "QUEST_PROGRESS", function() AutoQuest:OnQuestProgress() end)
    WG.RegisterEvent(WG, "QUEST_COMPLETE", function() AutoQuest:OnQuestComplete() end)
    WG.RegisterEvent(WG, "QUEST_GREETING", function() AutoQuest:OnQuestGreeting() end)
    WG.RegisterEvent(WG, "GOSSIP_SHOW", function() AutoQuest:OnGossipShow() end)
end

--------------------------------------------------------------------------------
-- Auto Accept
--------------------------------------------------------------------------------

--- Prüft ob die aktuelle Quest im Guide ist
---@param questID number
---@return boolean
local function IsQuestInGuide(questID)
    if not questID then return false end
    local guide = WG:GetCurrentStep()
    if not guide or not guide.steps then return false end

    for _, step in ipairs(guide.steps) do
        if step.quest == questID then
            return true
        end
    end
    return false
end

function AutoQuest:OnQuestDetail()
    if not WG.db.profile.autoQuest.acceptEnabled then return end

    -- Quest-ID der angebotenen Quest
    local questID = GetQuestID()
    if not questID then return end

    -- Nur automatisch annehmen wenn im Guide
    if IsQuestInGuide(questID) then
        AcceptQuest()
    end
end

--------------------------------------------------------------------------------
-- Auto Turn-in
--------------------------------------------------------------------------------

function AutoQuest:OnQuestProgress()
    if not WG.db.profile.autoQuest.turninEnabled then return end

    -- Prüfen ob alle Objectives erfüllt sind
    if IsQuestCompletable() then
        CompleteQuest()
    end
end

function AutoQuest:OnQuestComplete()
    if not WG.db.profile.autoQuest.turninEnabled then return end

    local questID = GetQuestID()
    if not questID or not IsQuestInGuide(questID) then return end

    -- Wenn es Belohnungen zur Auswahl gibt, nicht automatisch abgeben
    local numChoices = GetNumQuestChoices()
    if numChoices and numChoices > 1 then
        -- Spieler muss selbst wählen
        return
    end

    -- Quest abgeben (ohne Belohnungsauswahl oder nur 1 Option)
    if numChoices == 1 then
        GetQuestReward(1)
    else
        GetQuestReward()
    end
end

--------------------------------------------------------------------------------
-- Auto Gossip / Greeting — Quests im NPC-Dialog automatisch auswählen
--------------------------------------------------------------------------------

function AutoQuest:OnQuestGreeting()
    if not WG.db.profile.autoQuest.acceptEnabled and
       not WG.db.profile.autoQuest.turninEnabled then
        return
    end

    -- Verfügbare Quests durchgehen
    local numAvailable = GetNumAvailableQuests()
    for i = 1, numAvailable do
        local questID = select(5, GetAvailableQuestInfo(i))
        if questID and IsQuestInGuide(questID) and WG.db.profile.autoQuest.acceptEnabled then
            SelectAvailableQuest(i)
            return
        end
    end

    -- Abgebbare Quests durchgehen
    local numActive = GetNumActiveQuests()
    for i = 1, numActive do
        local questID = select(5, GetActiveQuestInfo(i)) -- nicht immer verfügbar
        local _, isComplete = GetActiveTitle(i)
        if isComplete and WG.db.profile.autoQuest.turninEnabled then
            SelectActiveQuest(i)
            return
        end
    end
end

function AutoQuest:OnGossipShow()
    if not WG.db.profile.autoQuest.acceptEnabled and
       not WG.db.profile.autoQuest.turninEnabled then
        return
    end

    -- C_GossipInfo API (Retail)
    if C_GossipInfo then
        -- Verfügbare Quests
        if WG.db.profile.autoQuest.acceptEnabled then
            local availableQuests = C_GossipInfo.GetAvailableQuests() or {}
            for _, quest in ipairs(availableQuests) do
                if quest.questID and IsQuestInGuide(quest.questID) then
                    C_GossipInfo.SelectAvailableQuest(quest.questID)
                    return
                end
            end
        end

        -- Abgebbare Quests
        if WG.db.profile.autoQuest.turninEnabled then
            local activeQuests = C_GossipInfo.GetActiveQuests() or {}
            for _, quest in ipairs(activeQuests) do
                if quest.isComplete then
                    C_GossipInfo.SelectActiveQuest(quest.questID)
                    return
                end
            end
        end
    end
end
