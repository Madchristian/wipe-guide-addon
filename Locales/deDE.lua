--[[
    WipeGuide — Deutsche Lokalisierung (Primärsprache)
]]

-- Nur überschreiben wenn Client deutsch ist
local locale = GetLocale and GetLocale() or "deDE"
if locale ~= "deDE" then return end

local L = WipeGuide and WipeGuide.L or {}

-- Allgemein
L["loaded"] = "geladen!"
L["no_guides"] = "Keine Guides geladen."
L["guides_count"] = "%d Guide(s) verfügbar."
L["guide_loaded"] = "Guide geladen: |cFF00CCFF%s|r"
L["guide_not_found"] = "Guide nicht gefunden: |cFFFF0000%s|r"
L["guide_complete"] = "|cFF00FF00Guide abgeschlossen!|r"
L["guide_complete_msg"] = "Alle Schritte abgeschlossen! GG!"
L["guide_available"] = "Guide verfügbar für diese Zone: |cFF00CCFF%s|r — /wipe load %s"
L["no_guide_active"] = "Kein Guide aktiv"
L["use_wipe_load"] = "Nutze /wipe list und /wipe load <name>"
L["arrived"] = "Angekommen!"
L["position_reset"] = "Fenster-Position zurückgesetzt."

-- Slash Commands
L["show_guide"] = "Guide-Fenster anzeigen/verstecken"
L["open_settings"] = "Einstellungen öffnen"
L["list_guides"] = "Verfügbare Guides auflisten"
L["load_guide"] = "Guide laden"
L["reset_position"] = "Fenster-Position zurücksetzen"

-- Einstellungen
L["auto_quest_header"] = "Auto-Quest"
L["auto_accept"] = "Quests automatisch annehmen"
L["auto_accept_tip"] = "Nimmt Quests automatisch an, die im aktuellen Guide stehen."
L["auto_turnin"] = "Quests automatisch abgeben"
L["auto_turnin_tip"] = "Gibt erledigte Quests automatisch ab (außer bei Belohnungsauswahl)."
L["waypoint_header"] = "Wegpunkt-Pfeil"
L["waypoint_toggle"] = "Richtungspfeil anzeigen"
L["waypoint_toggle_tip"] = "Zeigt einen Richtungspfeil zum nächsten Ziel an."
L["ui_header"] = "Benutzeroberfläche"
L["lock_frame"] = "Guide-Fenster fixieren"
L["lock_frame_tip"] = "Verhindert das Verschieben des Guide-Fensters."

WipeGuide.L = L
