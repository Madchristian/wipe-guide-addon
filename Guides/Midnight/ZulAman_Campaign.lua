-- =============================================================================
-- WipeGuide: Zul'Aman Campaign Guide (Midnight 12.0)
-- =============================================================================
-- HINWEIS: Quest-IDs und Koordinaten sind Platzhalter basierend auf PTR-Daten.
-- Werden beim Release mit finalen Werten aktualisiert.
--
-- Zul'Aman in Midnight: Die Amani-Trolle haben sich unter einem neuen Warlord
-- vereint. Die Kampagne führt durch das wiedererweckte Zul'Aman, von den
-- Außenbezirken bis zum Thron des Warlords.
-- =============================================================================

local WipeGuide = WipeGuide
if not WipeGuide then return end

-- =============================================================================
-- Kapitel 1: Ankunft in Zul'Aman
-- =============================================================================
WipeGuide:RegisterGuide("Campaign\\Midnight\\ZulAman\\01_Ankunft", {
    author = "WIPE AG",
    startLevel = 80,
    endLevel = 80,
    zone = "Zul'Aman",
    chapter = 1,
    chapterTitle = "Schatten über Zul'Aman",
    expansion = "Midnight",
    steps = {
        -- Einführungsquests: Ankunft und Orientierung
        { type = "accept", quest = 90001, npc = 220001,
          coords = {72.5, 31.2, 2380},
          text = "Sprich mit Erzmagier Khadgar am Versammlungspunkt" },
        { type = "goto", coords = {68.3, 28.7, 2380},
          text = "Folge dem Pfad zum Außenposten der Expedition" },
        { type = "talk", quest = 90001, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Sprich mit Leutnant Brightsword im Außenposten" },
        { type = "turnin", quest = 90001, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Gib die Quest ab" },

        -- Erkundung der Umgebung
        { type = "accept", quest = 90002, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Nimm 'Feindaufklärung' an" },
        { type = "kill", quest = 90002, count = 8,
          coords = {63.1, 25.4, 2380},
          text = "Töte 8 Amani-Späher im Außenbezirk" },
        { type = "collect", quest = 90002, count = 3,
          coords = {61.5, 24.8, 2380},
          text = "Sammle 3 Amani-Kriegspläne" },
        { type = "turnin", quest = 90002, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Bringe die Kriegspläne zu Leutnant Brightsword" },

        -- Verbündete finden
        { type = "accept", quest = 90003, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Nimm 'Alte Verbündete' an" },
        { type = "goto", coords = {55.2, 33.6, 2380},
          text = "Geh zum Lager der Revantusk-Trolle" },
        { type = "talk", quest = 90003, npc = 220003,
          coords = {55.2, 33.6, 2380},
          text = "Sprich mit Primal Torntusk" },
        { type = "turnin", quest = 90003, npc = 220003,
          coords = {55.2, 33.6, 2380},
          text = "Gib die Quest ab bei Primal Torntusk" },
    }
})

-- =============================================================================
-- Kapitel 2: Das Herz des Waldes
-- =============================================================================
WipeGuide:RegisterGuide("Campaign\\Midnight\\ZulAman\\02_HerzDesWaldes", {
    author = "WIPE AG",
    startLevel = 80,
    endLevel = 80,
    zone = "Zul'Aman",
    chapter = 2,
    chapterTitle = "Das Herz des Waldes",
    expansion = "Midnight",
    steps = {
        -- Waldgeister und verdorbene Natur
        { type = "accept", quest = 90010, npc = 220003,
          coords = {55.2, 33.6, 2380},
          text = "Nimm 'Verdorbene Wurzeln' von Primal Torntusk an" },
        { type = "goto", coords = {48.7, 40.2, 2380},
          text = "Geh zum Herzen des Waldes" },
        { type = "use", quest = 90010,
          coords = {48.7, 40.2, 2380},
          text = "Benutze das Reinigungstotem am verdorbenen Weltenbaum" },
        { type = "kill", quest = 90010, count = 1,
          coords = {48.7, 40.2, 2380},
          text = "Besiege den Verdorbenen Waldwächter" },
        { type = "turnin", quest = 90010, npc = 220004,
          coords = {48.7, 40.2, 2380},
          text = "Sprich mit dem befreiten Waldgeist" },

        -- Die Loa-Schreine
        { type = "accept", quest = 90011, npc = 220004,
          coords = {48.7, 40.2, 2380},
          text = "Nimm 'Segen der Loa' an" },
        { type = "goto", coords = {42.3, 36.8, 2380},
          text = "Geh zum Schrein des Bären-Loa" },
        { type = "use", quest = 90011,
          coords = {42.3, 36.8, 2380},
          text = "Entzünde die Opferflamme am Bären-Schrein" },
        { type = "goto", coords = {38.1, 42.5, 2380},
          text = "Geh zum Schrein des Adler-Loa" },
        { type = "use", quest = 90011,
          coords = {38.1, 42.5, 2380},
          text = "Entzünde die Opferflamme am Adler-Schrein" },
        { type = "goto", coords = {44.6, 48.3, 2380},
          text = "Geh zum Schrein des Luchs-Loa" },
        { type = "use", quest = 90011,
          coords = {44.6, 48.3, 2380},
          text = "Entzünde die Opferflamme am Luchs-Schrein" },
        { type = "goto", coords = {50.2, 44.1, 2380},
          text = "Geh zum Schrein des Dragonhawk-Loa" },
        { type = "use", quest = 90011,
          coords = {50.2, 44.1, 2380},
          text = "Entzünde die Opferflamme am Dragonhawk-Schrein" },
        { type = "turnin", quest = 90011, npc = 220004,
          coords = {48.7, 40.2, 2380},
          text = "Kehre zum Waldgeist zurück" },

        -- Konfrontation mit dem Hexendoktor
        { type = "accept", quest = 90012, npc = 220004,
          coords = {48.7, 40.2, 2380},
          text = "Nimm 'Der Hexendoktor' an" },
        { type = "goto", coords = {35.4, 38.9, 2380},
          text = "Betritt die Höhle des Hexendoktors" },
        { type = "kill", quest = 90012, count = 1,
          coords = {35.4, 38.9, 2380},
          text = "Besiege Hexendoktor Zul'mar" },
        { type = "collect", quest = 90012, count = 1,
          coords = {35.4, 38.9, 2380},
          text = "Nimm den Schlüssel des Hexendoktors" },
        { type = "turnin", quest = 90012, npc = 220003,
          coords = {55.2, 33.6, 2380},
          text = "Bringe den Schlüssel zu Primal Torntusk" },
    }
})

-- =============================================================================
-- Kapitel 3: Die Tore von Zul'Aman
-- =============================================================================
WipeGuide:RegisterGuide("Campaign\\Midnight\\ZulAman\\03_ToreVonZulAman", {
    author = "WIPE AG",
    startLevel = 80,
    endLevel = 80,
    zone = "Zul'Aman",
    chapter = 3,
    chapterTitle = "Die Tore von Zul'Aman",
    expansion = "Midnight",
    steps = {
        -- Vorbereitung auf den Sturm
        { type = "accept", quest = 90020, npc = 220003,
          coords = {55.2, 33.6, 2380},
          text = "Nimm 'Sturmvorbereitungen' an" },
        { type = "talk", quest = 90020, npc = 220005,
          coords = {58.4, 30.1, 2380},
          text = "Sprich mit Schmiedemeister Ironhide" },
        { type = "collect", quest = 90020, count = 5,
          coords = {60.2, 27.8, 2380},
          text = "Sammle 5 Amani-Eisenbarren" },
        { type = "turnin", quest = 90020, npc = 220005,
          coords = {58.4, 30.1, 2380},
          text = "Bringe die Barren zum Schmiedemeister" },

        -- Ablenkungsmanöver
        { type = "accept", quest = 90021, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Nimm 'Ablenkungsmanöver' an" },
        { type = "goto", coords = {45.8, 22.3, 2380},
          text = "Geh zur nördlichen Wachstellung" },
        { type = "use", quest = 90021,
          coords = {45.8, 22.3, 2380},
          text = "Platziere die Sprengladung am nördlichen Tor" },
        { type = "use", quest = 90021,
          coords = {40.2, 30.5, 2380},
          text = "Platziere die Sprengladung am westlichen Tor" },
        { type = "use", quest = 90021,
          coords = {42.1, 20.8, 2380},
          text = "Zünde das Signal" },
        { type = "turnin", quest = 90021, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Melde den Erfolg an Leutnant Brightsword" },

        -- Das Haupttor
        { type = "accept", quest = 90022, npc = 220001,
          coords = {72.5, 31.2, 2380},
          text = "Nimm 'Durch die Tore!' von Khadgar an" },
        { type = "goto", coords = {38.5, 35.2, 2380},
          text = "Stürme das Haupttor von Zul'Aman" },
        { type = "kill", quest = 90022, count = 1,
          coords = {38.5, 35.2, 2380},
          text = "Besiege Torwächter Zuljin" },
        { type = "goto", coords = {35.1, 35.2, 2380},
          text = "Betritt Zul'Aman" },
        { type = "turnin", quest = 90022, npc = 220001,
          coords = {35.1, 35.2, 2380},
          text = "Sprich mit Khadgar im Innenhof" },
    }
})

-- =============================================================================
-- Kapitel 4: Im Herzen von Zul'Aman
-- =============================================================================
WipeGuide:RegisterGuide("Campaign\\Midnight\\ZulAman\\04_ImHerzen", {
    author = "WIPE AG",
    startLevel = 80,
    endLevel = 80,
    zone = "Zul'Aman",
    chapter = 4,
    chapterTitle = "Im Herzen von Zul'Aman",
    expansion = "Midnight",
    steps = {
        -- Die vier Tier-Bosse (Loa-Avatare)
        { type = "accept", quest = 90030, npc = 220001,
          coords = {35.1, 35.2, 2380},
          text = "Nimm 'Die Macht der Loa' von Khadgar an" },

        -- Bären-Avatar
        { type = "goto", coords = {30.2, 28.4, 2380},
          text = "Geh zum Bären-Heiligtum" },
        { type = "kill", quest = 90030, count = 1,
          coords = {30.2, 28.4, 2380},
          text = "Besiege Nalorakk, den Bären-Avatar" },

        -- Adler-Avatar
        { type = "goto", coords = {25.8, 35.6, 2380},
          text = "Geh zum Adler-Heiligtum" },
        { type = "kill", quest = 90030, count = 1,
          coords = {25.8, 35.6, 2380},
          text = "Besiege Akil'zon, den Adler-Avatar" },

        -- Luchs-Avatar
        { type = "goto", coords = {30.5, 42.3, 2380},
          text = "Geh zum Luchs-Heiligtum" },
        { type = "kill", quest = 90030, count = 1,
          coords = {30.5, 42.3, 2380},
          text = "Besiege Halazzi, den Luchs-Avatar" },

        -- Dragonhawk-Avatar
        { type = "goto", coords = {22.1, 38.7, 2380},
          text = "Geh zum Dragonhawk-Heiligtum" },
        { type = "kill", quest = 90030, count = 1,
          coords = {22.1, 38.7, 2380},
          text = "Besiege Jan'alai, den Dragonhawk-Avatar" },

        { type = "turnin", quest = 90030, npc = 220001,
          coords = {28.3, 35.2, 2380},
          text = "Kehre zu Khadgar zurück" },

        -- Zugang zum Thron
        { type = "accept", quest = 90031, npc = 220001,
          coords = {28.3, 35.2, 2380},
          text = "Nimm 'Der Weg zum Thron' an" },
        { type = "goto", coords = {20.5, 35.2, 2380},
          text = "Öffne das versiegelte Tor zum Thronsaal" },
        { type = "talk", quest = 90031, npc = 220006,
          coords = {20.5, 35.2, 2380},
          text = "Konfrontiere den Geist von Zul'jin" },
        { type = "turnin", quest = 90031, npc = 220001,
          coords = {20.5, 35.2, 2380},
          text = "Sprich mit Khadgar" },
    }
})

-- =============================================================================
-- Kapitel 5: Der neue Warlord (Finale)
-- =============================================================================
WipeGuide:RegisterGuide("Campaign\\Midnight\\ZulAman\\05_Finale", {
    author = "WIPE AG",
    startLevel = 80,
    endLevel = 80,
    zone = "Zul'Aman",
    chapter = 5,
    chapterTitle = "Der Warlord von Zul'Aman",
    expansion = "Midnight",
    steps = {
        -- Finale Konfrontation
        { type = "accept", quest = 90040, npc = 220001,
          coords = {20.5, 35.2, 2380},
          text = "Nimm 'Das Ende des Warlords' von Khadgar an" },
        { type = "goto", coords = {15.3, 35.2, 2380},
          text = "Betritt den Thronsaal von Zul'Aman" },

        -- Endkampf
        { type = "kill", quest = 90040, count = 1,
          coords = {15.3, 35.2, 2380},
          text = "Besiege Warlord Dazar'khan (Solo-Szenario)" },

        -- Abschluss
        { type = "talk", quest = 90040, npc = 220001,
          coords = {15.3, 35.2, 2380},
          text = "Sprich mit Khadgar nach dem Sieg" },
        { type = "turnin", quest = 90040, npc = 220001,
          coords = {15.3, 35.2, 2380},
          text = "Schließe die Kampagne ab" },

        -- Epilog
        { type = "accept", quest = 90041, npc = 220001,
          coords = {15.3, 35.2, 2380},
          text = "Nimm 'Ein neuer Morgen' an" },
        { type = "goto", coords = {72.5, 31.2, 2380},
          text = "Kehre zum Expeditions-Außenposten zurück" },
        { type = "talk", quest = 90041, npc = 220003,
          coords = {55.2, 33.6, 2380},
          text = "Sprich mit Primal Torntusk (unterwegs)" },
        { type = "turnin", quest = 90041, npc = 220002,
          coords = {68.3, 28.7, 2380},
          text = "Melde den Sieg an Leutnant Brightsword" },
    }
})

-- Guide-Metadaten für die Kapitelübersicht
WipeGuide:RegisterCampaign("Midnight\\ZulAman", {
    title = "Zul'Aman Kampagne",
    titleDE = "Zul'Aman Kampagne",
    description = "Die komplette Kampagne durch das wiedererweckte Zul'Aman in Midnight",
    chapters = {
        "Campaign\\Midnight\\ZulAman\\01_Ankunft",
        "Campaign\\Midnight\\ZulAman\\02_HerzDesWaldes",
        "Campaign\\Midnight\\ZulAman\\03_ToreVonZulAman",
        "Campaign\\Midnight\\ZulAman\\04_ImHerzen",
        "Campaign\\Midnight\\ZulAman\\05_Finale",
    },
    totalQuests = 12,
    estimatedTime = "2-3 Stunden",
    note = "⚠️ Quest-IDs und Koordinaten sind PTR-basiert. Beim Live-Release aktualisieren!",
})
