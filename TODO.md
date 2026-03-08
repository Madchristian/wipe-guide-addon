# WIPE Guide Addon — Projektplan

> WoW Quest Guide Addon für die WIPE AG Gilde
> Inspiriert von Zygor Guides — Open Source, KI-gestützte Route-Generierung
> KI-Backend: Ollama/Qwen3.5-8B auf TrueNAS (10.0.40.20:30068)

---

## Phase 1: Addon-Grundgerüst (Lua/XML)

- [ ] **1.1** Addon-Skeleton erstellen (`.toc`, Core-Lua, XML-Layout)
- [ ] **1.2** Guide Viewer Frame — verschiebbares, skalierbares Overlay-Fenster
  - [ ] Minimierbar/maximierbar
  - [ ] Transparenz einstellbar
  - [ ] Position wird gespeichert (SavedVariables)
- [ ] **1.3** Step-by-Step Navigation
  - [ ] Aktueller Schritt prominent anzeigen (Text + Icon)
  - [ ] Vor/Zurück/Skip Buttons
  - [ ] Fortschrittsbalken (Step X von Y)
  - [ ] Automatisches Weiterspringen bei Quest-Completion
- [ ] **1.4** Waypoint Arrow (3D)
  - [ ] Richtungspfeil zum nächsten Ziel (Minimap + HUD)
  - [ ] Distanzanzeige
  - [ ] Koordinaten-Display
  - [ ] Unterstützung für Wegpunkte (A → B → C)
- [ ] **1.5** Settings Panel
  - [ ] Slash-Command `/wipe` für Konfiguration
  - [ ] Toggle: Auto-Accept Quests
  - [ ] Toggle: Auto-Turn-in Quests
  - [ ] Toggle: Waypoint Arrow an/aus
  - [ ] Guide-Auswahl (Zone/Kategorie)
- [ ] **1.6** Event-System
  - [ ] QUEST_ACCEPTED / QUEST_TURNED_IN / QUEST_LOG_UPDATE hooks
  - [ ] Automatische Fortschrittserkennung
  - [ ] Zone-Change Detection → passenden Guide vorschlagen

## Phase 2: Quest-Datenbank & Guide-Format

- [ ] **2.1** Guide-Datenformat definieren (Lua-Tables)
  - [ ] Step-Types: accept, turnin, goto, kill, collect, use, talk, flyto
  - [ ] Felder: questID, npcID, coords {x, y, mapID}, text, note
  - [ ] Prerequisites & Conditions
- [ ] **2.2** Wowhead Quest-Data Scraper (Python)
  - [ ] Quest-IDs, Names, Objectives, NPC-IDs, Koordinaten extrahieren
  - [ ] Zone-Zuordnung
  - [ ] Prerequisite-Chains erkennen
  - [ ] Output als JSON (Zwischenformat)
- [ ] **2.3** Questie DB als Alternative/Ergänzung
  - [ ] Questie Lua-Tables parsen
  - [ ] Koordinaten + NPC-Daten extrahieren
- [ ] **2.4** Guide-Compiler: JSON → Lua-Tables
  - [ ] Validierung (alle Quest-IDs existieren, Coords plausibel)
  - [ ] Mehrere Guides pro Zone möglich
  - [ ] Versionierung der Guide-Daten

## Phase 3: KI Route-Generator

- [ ] **3.1** Route-Optimizer (Python + Ollama)
  - [ ] Input: Quest-Liste einer Zone mit Koordinaten + Prerequisites
  - [ ] Ollama/Qwen3.5-8B: Optimale Reihenfolge berechnen
  - [ ] Traveling-Salesman-Heuristik + Quest-Dependencies
  - [ ] Output: Sortierte Step-Liste mit Wegbeschreibungen
- [ ] **3.2** Step-Text-Generator
  - [ ] KI formuliert klare, knappe Anweisungen pro Step
  - [ ] Deutsch + Englisch
  - [ ] Berücksichtigt Klasse/Rasse wenn relevant
- [ ] **3.3** Batch-Pipeline
  - [ ] Alle Zonen einer Expansion automatisch durchlaufen
  - [ ] Guide-Files generieren und ins Addon-Verzeichnis kopieren
  - [ ] Quality-Check: Sind alle Quests abgedeckt?
- [ ] **3.4** Ollama-Integration
  - [ ] Endpoint: `http://10.0.40.20:30068` (TrueNAS)
  - [ ] Model: `qwen3.5:8b` (oder `qwen3:8b` als Fallback)
  - [ ] Prompt-Templates für Route-Optimization + Step-Generation
  - [ ] Retry-Logic + Timeout-Handling

## Phase 4: Auto-Quest Features

- [ ] **4.1** Auto Quest Accept
  - [ ] Automatisch Quests annehmen die im Guide stehen
  - [ ] Blacklist für unerwünschte Quests
  - [ ] Toggle in Settings
- [ ] **4.2** Auto Quest Turn-in
  - [ ] Automatisch abgeben wenn alle Objectives erfüllt
  - [ ] Quest-Reward-Auswahl: Bestes Item für Klasse/Spec vorschlagen
- [ ] **4.3** Auto Dialogue Selection
  - [ ] Gossip-Options automatisch auswählen
  - [ ] Nur für Quests im aktiven Guide
- [ ] **4.4** NPC Quest Icons
  - [ ] Raid-Marker über Quest-relevante NPCs
  - [ ] ⭐ Talk, 🔲 Click, 💀 Kill
  - [ ] Nur für aktuellen Step

## Phase 5: Gilden-Features (WIPE AG Spezial)

- [ ] **5.1** Dungeon/Raid Prep Guides
  - [ ] Boss-Strategien als Guide-Steps
  - [ ] Trash-Routing
  - [ ] Wipe-Recovery-Tipps (passend zum Gildennamen 😄)
- [ ] **5.2** Guide-Sharing
  - [ ] Export/Import von Custom Guides
  - [ ] Guild-eigene Guides (z.B. Farm-Routen)
- [ ] **5.3** Profession-Guides
  - [ ] Leveling-Routen für Berufe
  - [ ] Materialien-Checklist
- [ ] **5.4** Achievement-Tracker
  - [ ] Achievement-Guides als Step-by-Step

## Phase 6: Polish & Release

- [ ] **6.1** Addon-Icon & Branding ("WIPE Guide" Logo)
- [ ] **6.2** Documentation (README, Installation, Usage)
- [ ] **6.3** CurseForge / WoWInterface Upload
- [ ] **6.4** GitLab CI/CD Pipeline (Packaging + Release)
- [ ] **6.5** Performance-Optimierung (Frame-Throttling, Lazy-Loading)

---

## Technische Details

### WoW API Referenz (wichtigste Funktionen)
```
C_QuestLog.GetInfo(questLogIndex)
C_QuestLog.IsQuestFlaggedCompleted(questID)
C_QuestLog.GetNumQuestLogEntries()
AcceptQuest()
CompleteQuest()
GetQuestReward(rewardIndex)
C_Map.GetPlayerMapPosition(mapID)
C_Map.GetBestMapForUnit("player")
C_Navigation.SetDestination(x, y, mapID)
```

### Guide-Format Beispiel
```lua
WipeGuide:RegisterGuide("Leveling\\Duskwood\\Duskwood_20_25", {
    author = "WIPE AG",
    startLevel = 20,
    endLevel = 25,
    zone = "Duskwood",
    steps = {
        { type = "accept", quest = 26618, npc = 43730,
          coords = {75.2, 45.3, 47}, -- x, y, mapID
          text = "Nimm die Quest 'Das Dunkelhain-Problem' an" },
        { type = "goto", coords = {23.1, 56.7, 47},
          text = "Geh zum Friedhof westlich von Dunkelhain" },
        { type = "kill", quest = 26618, count = 10,
          text = "Töte 10 Nachtlauerer" },
        { type = "turnin", quest = 26618, npc = 43730,
          coords = {75.2, 45.3, 47},
          text = "Gib die Quest ab bei Calor" },
    }
})
```

### Verzeichnisstruktur
```
WipeGuide/
├── WipeGuide.toc              # Addon Manifest
├── Core.lua                    # Addon-Init, Event-System
├── GuideViewer.lua             # Step-by-Step UI
├── GuideViewer.xml             # Frame-Layout
├── Waypoint.lua                # 3D Arrow + Minimap
├── Waypoint.xml                # Arrow-Textures
├── AutoQuest.lua               # Auto Accept/Turn-in
├── Settings.lua                # Options Panel
├── Settings.xml                # Settings UI
├── Libs/                       # Embedded Libraries
│   ├── LibStub/
│   ├── AceAddon-3.0/
│   ├── AceDB-3.0/
│   └── HereBeDragons/          # Koordinaten-Lib
├── Guides/                     # Generierte Guide-Daten
│   ├── Retail/
│   │   ├── Midnight/
│   │   ├── TheWarWithin/
│   │   └── Classic/
│   └── Dungeons/
├── Textures/                   # Icons, Arrow, UI-Elemente
│   ├── arrow.tga
│   ├── logo.tga
│   └── step_icons.tga
└── Locales/                    # Übersetzungen
    ├── deDE.lua
    └── enUS.lua
```
