--[[
    WipeGuide — English Locale (Fallback)
]]

local L = {}

-- General
L["loaded"] = "loaded!"
L["no_guides"] = "No guides loaded."
L["guides_count"] = "%d guide(s) available."
L["guide_loaded"] = "Guide loaded: |cFF00CCFF%s|r"
L["guide_not_found"] = "Guide not found: |cFFFF0000%s|r"
L["guide_complete"] = "|cFF00FF00Guide completed!|r"
L["guide_complete_msg"] = "All steps completed! GG!"
L["guide_available"] = "Guide available for this zone: |cFF00CCFF%s|r — /wipe load %s"
L["no_guide_active"] = "No guide active"
L["use_wipe_load"] = "Use /wipe list and /wipe load <name>"
L["arrived"] = "Arrived!"
L["position_reset"] = "Window position reset."

-- Slash Commands
L["show_guide"] = "Show/hide guide window"
L["open_settings"] = "Open settings"
L["list_guides"] = "List available guides"
L["load_guide"] = "Load a guide"
L["reset_position"] = "Reset window position"

-- Settings
L["auto_quest_header"] = "Auto-Quest"
L["auto_accept"] = "Automatically accept quests"
L["auto_accept_tip"] = "Automatically accepts quests that are in the current guide."
L["auto_turnin"] = "Automatically turn in quests"
L["auto_turnin_tip"] = "Automatically turns in completed quests (except when choosing rewards)."
L["waypoint_header"] = "Waypoint Arrow"
L["waypoint_toggle"] = "Show direction arrow"
L["waypoint_toggle_tip"] = "Shows a direction arrow pointing to the next target."
L["ui_header"] = "User Interface"
L["lock_frame"] = "Lock guide window"
L["lock_frame_tip"] = "Prevents moving the guide window."

-- Fallback: Setze als globale Locale-Table
WipeGuide = WipeGuide or {}
WipeGuide.L = L
