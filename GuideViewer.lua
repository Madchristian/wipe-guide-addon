--[[
    WipeGuide — Guide Viewer Module
    Hauptfenster für Step-by-Step Anzeige
]]

local WG = WipeGuide
local L

-- Step-Type Icons (Unicode / Textbasiert)
local STEP_ICONS = {
    accept  = "|cFF00FF00[!]|r",  -- Quest annehmen (grün)
    turnin  = "|cFFFFFF00[?]|r",  -- Quest abgeben (gelb)
    goto    = "|cFF00CCFF[→]|r",  -- Laufen (blau)
    kill    = "|cFFFF0000[✕]|r",  -- Töten (rot)
    collect = "|cFFFF8800[◆]|r",  -- Sammeln (orange)
    use     = "|cFFCC00FF[✦]|r",  -- Benutzen (lila)
    talk    = "|cFFFFFFFF[💬]|r", -- Sprechen (weiß)
    flyto   = "|cFF00CCFF[✈]|r", -- Fliegen (blau)
}

--------------------------------------------------------------------------------
-- GuideViewer "Module" (einfache Table, kein AceAddon-Modul)
--------------------------------------------------------------------------------

local GuideViewer = {}
WG.GuideViewer = GuideViewer

local frame -- Referenz auf das XML-Frame

function GuideViewer:Enable()
    L = WG.L or {}
    frame = WipeGuideViewerFrame
    if not frame then return end

    -- Button-Handler setzen
    frame.closeButton:SetScript("OnClick", function() GuideViewer:Hide() end)
    frame.minimizeButton:SetScript("OnClick", function() GuideViewer:ToggleMinimize() end)
    frame.prevButton:SetScript("OnClick", function() WG:PrevStep() end)
    frame.nextButton:SetScript("OnClick", function() WG:NextStep() end)
    frame.skipButton:SetScript("OnClick", function() WG:NextStep() end)

    -- Nachrichten abonnieren
    WG.RegisterMessage(WG, "WIPEGUIDE_GUIDE_LOADED", function(_, _, guidePath)
        GuideViewer:OnGuideLoaded(guidePath)
    end)
    WG.RegisterMessage(WG, "WIPEGUIDE_STEP_CHANGED", function(_, _, stepIdx)
        GuideViewer:UpdateStep()
    end)
    WG.RegisterMessage(WG, "WIPEGUIDE_GUIDE_COMPLETE", function()
        GuideViewer:OnGuideComplete()
    end)

    -- Position wiederherstellen
    self:RestorePosition()

    -- Wenn ein Guide aktiv ist, anzeigen
    if WG.db.profile.activeGuide then
        self:Show()
        self:UpdateStep()
    end
end

function GuideViewer:RestorePosition()
    if not frame then return end
    local cfg = WG.db.profile.guideViewer
    frame:ClearAllPoints()
    frame:SetPoint(cfg.point or "RIGHT", UIParent, cfg.point or "RIGHT", cfg.x or -50, cfg.y or 0)
    frame:SetAlpha(cfg.alpha or 0.9)
    frame:SetSize(cfg.width or 300, cfg.height or 400)
end

function GuideViewer:Show()
    if frame then
        frame:Show()
        self:UpdateStep()
    end
end

function GuideViewer:Hide()
    if frame then frame:Hide() end
end

function GuideViewer:Toggle()
    if frame and frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function GuideViewer:ToggleMinimize()
    if not frame then return end
    local cfg = WG.db.profile.guideViewer
    cfg.minimized = not cfg.minimized

    if cfg.minimized then
        frame.stepFrame:Hide()
        frame.progressBar:Hide()
        frame.prevButton:Hide()
        frame.nextButton:Hide()
        frame.skipButton:Hide()
        frame:SetHeight(55)
    else
        frame.stepFrame:Show()
        frame.progressBar:Show()
        frame.prevButton:Show()
        frame.nextButton:Show()
        frame.skipButton:Show()
        frame:SetHeight(cfg.height or 400)
    end
end

--------------------------------------------------------------------------------
-- Step-Anzeige aktualisieren
--------------------------------------------------------------------------------

function GuideViewer:UpdateStep()
    if not frame then return end

    local guide, step, stepIdx = WG:GetCurrentStep()
    if not guide or not step then
        frame.guideHeader.guideTitle:SetText(L["no_guide_active"] or "Kein Guide aktiv")
        frame.stepFrame.stepNumber:SetText("")
        frame.stepFrame.stepType:SetText("")
        frame.stepFrame.stepText:SetText(L["use_wipe_load"] or "Nutze /wipe list und /wipe load <name>")
        frame.stepFrame.coords:SetText("")
        frame.progressBar:SetValue(0)
        frame.progressBar.text:SetText("0%")
        return
    end

    -- Guide-Titel
    local title = string.format("%s (Lv %d-%d)", guide.zone or "?", guide.startLevel or 0, guide.endLevel or 0)
    frame.guideHeader.guideTitle:SetText("|cFF00CCFF" .. title .. "|r")

    -- Step-Nummer
    local totalSteps = #guide.steps
    frame.stepFrame.stepNumber:SetText(string.format("Step %d/%d", stepIdx, totalSteps))

    -- Step-Type Icon
    local icon = STEP_ICONS[step.type] or "[·]"
    local typeName = (step.type or ""):upper()
    frame.stepFrame.stepType:SetText(icon .. " " .. typeName)

    -- Step-Text
    frame.stepFrame.stepText:SetText(step.text or "")

    -- Koordinaten
    if step.coords then
        local x, y = step.coords[1], step.coords[2]
        frame.stepFrame.coords:SetText(string.format("%.1f, %.1f", x, y))
    else
        frame.stepFrame.coords:SetText("")
    end

    -- Fortschrittsbalken
    local progress = (stepIdx / totalSteps) * 100
    frame.progressBar:SetValue(progress)
    frame.progressBar.text:SetText(string.format("%d%%", progress))

    -- Button-States
    frame.prevButton:SetEnabled(stepIdx > 1)
    frame.nextButton:SetEnabled(stepIdx < totalSteps)

    -- Waypoint aktualisieren
    if WG.Waypoint and step.coords then
        WG.Waypoint:SetTarget(step.coords[1], step.coords[2], step.coords[3])
    end
end

--------------------------------------------------------------------------------
-- Callbacks
--------------------------------------------------------------------------------

function GuideViewer:OnGuideLoaded(guidePath)
    self:Show()
    self:UpdateStep()
end

function GuideViewer:OnGuideComplete()
    if not frame then return end
    frame.stepFrame.stepText:SetText("|cFF00FF00" .. (L["guide_complete_msg"] or "Alle Schritte abgeschlossen! GG!") .. "|r")
    frame.stepFrame.stepType:SetText("|cFF00FF00[✓]|r FERTIG")
    frame.progressBar:SetValue(100)
    frame.progressBar.text:SetText("100%")
    frame.nextButton:SetEnabled(false)
end
