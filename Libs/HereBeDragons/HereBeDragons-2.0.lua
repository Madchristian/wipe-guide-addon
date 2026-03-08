--[[
    HereBeDragons-2.0 — Stub
    STUB: Echte Version von CurseForge laden!
    https://www.curseforge.com/wow/addons/herebedragons

    HereBeDragons ist eine Koordinaten-Library für WoW, die Map-Koordinaten
    in Welt-Koordinaten umrechnet und umgekehrt. Unverzichtbar für
    Waypoint-Systeme und Distanzberechnungen.
]]

local MAJOR, MINOR = "HereBeDragons-2.0", 12
local HBD = LibStub:NewLibrary(MAJOR, MINOR)
if not HBD then return end

-- Interne Map-Daten (werden von der echten Library befüllt)
HBD.mapData = {}

--- Konvertiert Zone-Koordinaten (0-1) in Welt-Koordinaten
---@param x number Zone-X (0-1)
---@param y number Zone-Y (0-1)
---@param zone number Map-ID
---@return number|nil worldX
---@return number|nil worldY
function HBD:GetWorldCoordinatesFromZone(x, y, zone)
    if not x or not y or not zone then return nil, nil end
    -- Stub: Gibt approximierte Werte zurück
    -- Die echte Library hat eine vollständige Datenbank aller Map-Dimensionen
    local data = self.mapData[zone]
    if data then
        local worldX = data.originX + x * data.width
        local worldY = data.originY + y * data.height
        return worldX, worldY
    end
    -- Fallback: Rohe Konvertierung (ungenau, aber funktional für Tests)
    return x * 1000, y * 1000
end

--- Konvertiert Welt-Koordinaten in Zone-Koordinaten (0-1)
---@param worldX number Welt-X
---@param worldY number Welt-Y
---@param zone number Ziel-Map-ID
---@return number|nil x Zone-X (0-1)
---@return number|nil y Zone-Y (0-1)
function HBD:GetZoneCoordinatesFromWorld(worldX, worldY, zone)
    if not worldX or not worldY or not zone then return nil, nil end
    local data = self.mapData[zone]
    if data and data.width > 0 and data.height > 0 then
        local x = (worldX - data.originX) / data.width
        local y = (worldY - data.originY) / data.height
        return x, y
    end
    return worldX / 1000, worldY / 1000
end

--- Gibt die Spieler-Weltposition zurück
---@return number|nil worldX
---@return number|nil worldY
---@return number|nil instanceID
function HBD:GetPlayerWorldPosition()
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return nil, nil, nil end

    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return nil, nil, nil end

    local x, y = pos:GetXY()
    local worldX, worldY = self:GetWorldCoordinatesFromZone(x, y, mapID)
    return worldX, worldY, mapID
end

--- Berechnet die Distanz zwischen zwei Weltpunkten (in Yards)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number distance
function HBD:GetWorldDistance(x1, y1, x2, y2)
    if not x1 or not y1 or not x2 or not y2 then return 0 end
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
