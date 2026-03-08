--[[
    WipeGuide — Beispiel-Guide: Duskwood (Level 20-25)
    Zone: Duskwood (Map-ID 47)

    Dies ist ein Beispiel-Guide um das Format zu demonstrieren.
    Echte Guides werden später per KI generiert (Phase 3).

    Step-Types: accept, turnin, goto, kill, collect, use, talk, flyto
    Coords: { x, y, mapID } — x/y in Prozent (0-100), mapID = WoW Map-ID
]]

-- Warte bis WipeGuide geladen ist
local WG = WipeGuide
if not WG then return end

WG:RegisterGuide("Leveling\\Eastern Kingdoms\\Duskwood_20_25", {
    author  = "WIPE AG",
    zone    = "Duskwood",
    mapID   = 47, -- Duskwood Map-ID
    startLevel = 20,
    endLevel   = 25,
    faction    = "Alliance",

    steps = {
        -- Anreise
        {
            type   = "flyto",
            coords = {77.5, 44.3, 47},
            text   = "Fliege nach Dunkelhain (Duskwood).",
            note   = "Flugpunkt: Dunkelhain",
        },

        -- Quest-Kette: Das Dunkelhain-Problem
        {
            type   = "accept",
            quest  = 26618,
            npc    = 43730,
            coords = {75.2, 45.3, 47},
            text   = "Nimm 'Das Dunkelhain-Problem' an bei Calor in Dunkelhain.",
        },
        {
            type   = "goto",
            coords = {23.1, 56.7, 47},
            text   = "Geh zum Friedhof westlich von Dunkelhain.",
            note   = "Folge der Straße nach Westen.",
        },
        {
            type   = "kill",
            quest  = 26618,
            count  = 10,
            coords = {21.5, 57.2, 47},
            text   = "Töte 10 Nachtlauerer auf dem Friedhof.",
            note   = "Sie spawnen rund um die Gräber.",
        },
        {
            type   = "turnin",
            quest  = 26618,
            npc    = 43730,
            coords = {75.2, 45.3, 47},
            text   = "Gib 'Das Dunkelhain-Problem' ab bei Calor.",
        },

        -- Quest: Der legendäre Sensen-Mann
        {
            type   = "accept",
            quest  = 26620,
            npc    = 43730,
            coords = {75.2, 45.3, 47},
            text   = "Nimm 'Der legendäre Sensen-Mann' an.",
        },
        {
            type   = "goto",
            coords = {17.8, 29.4, 47},
            text   = "Geh zum Raven Hill Friedhof im Nordwesten.",
        },
        {
            type   = "kill",
            quest  = 26620,
            count  = 1,
            coords = {18.2, 31.1, 47},
            text   = "Besiege den Sensen-Mann am Mausoleum.",
            note   = "Elite-Mob! Gruppe empfohlen oder auf Abklingzeit warten.",
        },
        {
            type   = "turnin",
            quest  = 26620,
            npc    = 43730,
            coords = {75.2, 45.3, 47},
            text   = "Zurück nach Dunkelhain — Quest abgeben bei Calor.",
        },

        -- Darkshire Quests
        {
            type   = "accept",
            quest  = 26623,
            npc    = 43731,
            coords = {73.8, 46.8, 47},
            text   = "Nimm die nächste Quest an beim Bürgermeister.",
        },
        {
            type   = "collect",
            quest  = 26623,
            count  = 8,
            coords = {65.3, 38.2, 47},
            text   = "Sammle 8 Nachtschwinge-Federn nordöstlich von Dunkelhain.",
            note   = "Die Fledermäuse fliegen tief — einfach zu erwischen.",
        },
        {
            type   = "turnin",
            quest  = 26623,
            npc    = 43731,
            coords = {73.8, 46.8, 47},
            text   = "Gib die Quest ab beim Bürgermeister in Dunkelhain.",
        },

        -- Abschluss
        {
            type   = "talk",
            npc    = 43730,
            coords = {75.2, 45.3, 47},
            text   = "Sprich mit Calor für die nächste Quest-Kette.",
            note   = "Weiter geht's mit dem Duskwood-Storyline!",
        },
    },
})
