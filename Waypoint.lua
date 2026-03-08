--[[
    WipeGuide — Waypoint Module
    3D-Richtungspfeil (HUD), Distanzanzeige, Koordinaten
    Nutzt HereBeDragons für Map-Koordinaten
]]

local WG = WipeGuide
local L
local HBD -- HereBeDragons Referenz

local Waypoint = {}
WG.Waypoint = Waypoint

-- Ziel-Koordinaten
local targetX, targetY, targetMapID = nil, nil, nil
local UPDATE_INTERVAL = 0.05 -- 20 FPS Update
local elapsed = 0

local frame -- Referenz auf WipeGuideWaypointFrame

--------------------------------------------------------------------------------
-- Lifecycle
--------------------------------------------------------------------------------

function Waypoint:Enable()
    L = WG.L or {}
    frame = WipeGuideWaypointFrame
    if not frame then return end

    -- HereBeDragons laden
    HBD = LibStub("HereBeDragons-2.0", true)
    if not HBD then
        WG:Print("|cFFFF8800Warnung:|r HereBeDragons nicht gefunden — Waypoint deaktiviert.")
        return
    end

    -- OnUpdate für Pfeil-Rotation
    frame:SetScript("OnUpdate", function(self, delta)
        Waypoint:OnUpdate(delta)
    end)

    -- Nachrichten abonnieren
    WG.RegisterMessage(WG, "WIPEGUIDE_STEP_CHANGED", function()
        Waypoint:OnStepChanged()
    end)
    WG.RegisterMessage(WG, "WIPEGUIDE_GUIDE_COMPLETE", function()
        Waypoint:ClearTarget()
    end)
end

--------------------------------------------------------------------------------
-- Ziel setzen / löschen
--------------------------------------------------------------------------------

--- Setzt das Waypoint-Ziel
---@param x number Map-X-Koordinate (0-100)
---@param y number Map-Y-Koordinate (0-100)
---@param mapID number|nil WoW Map-ID
function Waypoint:SetTarget(x, y, mapID)
    if not WG.db.profile.waypoint.enabled then return end
    if not x or not y then
        self:ClearTarget()
        return
    end

    targetX = x / 100 -- Normalisieren auf 0-1
    targetY = y / 100
    targetMapID = mapID

    if frame then
        frame:Show()
        frame:SetAlpha(WG.db.profile.waypoint.alpha or 1.0)
        local scale = WG.db.profile.waypoint.scale or 1.0
        frame:SetScale(scale)
    end
end

--- Löscht das aktuelle Ziel
function Waypoint:ClearTarget()
    targetX, targetY, targetMapID = nil, nil, nil
    if frame then frame:Hide() end
end

--------------------------------------------------------------------------------
-- OnUpdate — Pfeil-Rotation & Distanz
--------------------------------------------------------------------------------

function Waypoint:OnUpdate(delta)
    elapsed = elapsed + delta
    if elapsed < UPDATE_INTERVAL then return end
    elapsed = 0

    if not targetX or not targetY or not HBD then
        if frame then frame:Hide() end
        return
    end

    -- Spieler-Position holen
    local playerMapID = C_Map.GetBestMapForUnit("player")
    if not playerMapID then return end

    local playerPos = C_Map.GetPlayerMapPosition(playerMapID, "player")
    if not playerPos then return end
    local playerX, playerY = playerPos:GetXY()

    -- Ziel-Koordinaten auf gleiche Map konvertieren
    local destX, destY = targetX, targetY
    local destMap = targetMapID or playerMapID

    if destMap ~= playerMapID then
        -- HereBeDragons: Koordinaten zwischen Maps konvertieren
        local worldX, worldY = HBD:GetWorldCoordinatesFromZone(destX, destY, destMap)
        if worldX and worldY then
            destX, destY = HBD:GetZoneCoordinatesFromWorld(worldX, worldY, playerMapID)
        end
        if not destX or not destY then
            -- Kann nicht konvertieren — Pfeil verstecken
            frame:Hide()
            return
        end
    end

    -- Richtung berechnen
    local dx = destX - playerX
    local dy = destY - playerY
    local angle = math.atan2(-dx, dy) -- WoW-Koordinatensystem: Y zeigt nach Süden

    -- Spieler-Blickrichtung abziehen
    local facing = GetPlayerFacing()
    if facing then
        angle = angle - facing
    end

    -- Pfeil rotieren (SetRotation erwartet Radians)
    if frame.arrow.SetRotation then
        frame.arrow:SetRotation(angle)
    end

    -- Distanz berechnen (in Yards via HereBeDragons)
    local playerWorldX, playerWorldY = HBD:GetWorldCoordinatesFromZone(playerX, playerY, playerMapID)
    local destWorldX, destWorldY = HBD:GetWorldCoordinatesFromZone(
        targetX, targetY, targetMapID or playerMapID)

    local distance = 0
    if playerWorldX and destWorldX then
        local ddx = destWorldX - playerWorldX
        local ddy = destWorldY - playerWorldY
        distance = math.sqrt(ddx * ddx + ddy * ddy)
    end

    -- Distanz-Text
    local distText
    if distance >= 1000 then
        distText = string.format("%.1f km", distance / 1000)
    else
        distText = string.format("%d m", distance)
    end
    frame.distance:SetText("|cFFFFFFFF" .. distText .. "|r")

    -- Koordinaten-Text (Ziel)
    frame.coords:SetText(string.format("%.1f, %.1f", targetX * 100, targetY * 100))

    -- Pfeil-Farbe basierend auf Distanz
    if distance < 10 then
        frame.arrow:SetVertexColor(0, 1, 0, 1) -- Grün = nah
    elseif distance < 50 then
        frame.arrow:SetVertexColor(1, 1, 0, 1) -- Gelb = mittel
    else
        frame.arrow:SetVertexColor(1, 1, 1, 1) -- Weiß = weit
    end

    -- Wenn sehr nah: Pfeil pulsieren lassen
    if distance < 5 then
        local pulse = 0.5 + 0.5 * math.sin(GetTime() * 4)
        frame.arrow:SetAlpha(pulse)
        frame.distance:SetText("|cFF00FF00" .. (L["arrived"] or "Angekommen!") .. "|r")
    else
        frame.arrow:SetAlpha(1)
    end
end

--------------------------------------------------------------------------------
-- Callbacks
--------------------------------------------------------------------------------

function Waypoint:OnStepChanged()
    local guide, step = WG:GetCurrentStep()
    if step and step.coords then
        self:SetTarget(step.coords[1], step.coords[2], step.coords[3])
    else
        self:ClearTarget()
    end
end
