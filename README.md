<p align="center">
  <img src="https://raw.githubusercontent.com/PhatZero/TitanPanel_RaidTools/main/banner.png" width="600"/>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/PhatZero/TitanPanel_RaidTools/main/icon.png" width="96"/>
</p>

<h1 align="center">TitanPanel_RaidTools</h1>

<p align="center"><i>A clean and powerful raid-utility addon for Titan Panel.</i></p>

# TitanPanel_RaidTools

A **Titan Panel plugin** providing raid utilities for *World of Warcraft: Midnight (11.0)* and *Dragonflight/War Within retail*, including:

- Ready Check
- Battle Resurrection Tracking (C_Encounter API)
- Raid Target Icons
- World Markers
- Tooltip-ready statuses
- Blizzard Options Panel
- Titan Panel right-click menu configuration
- Smart Display Modes (Charges / Cooldown / Auto)

(README content truncated here; expand in GitHub as needed.)

## Usage Notes (War Within / Retail)

- **Installation Path**  
  - Install into `_retail_/Interface/AddOns/TitanPanelRaidTools/`.  
  - The folder name **must** be `TitanPanelRaidTools` and the TOC file **must** be `TitanPanelRaidTools.toc` for Titan to detect the plugin correctly.

- **Ready Check & World Markers Permissions**  
  - Ready checks and world markers require you to be **group leader** or **assistant**.  
  - If you are not in a group, or you lack these permissions, the addon will print a short explanatory message instead of failing silently.  
  - World markers are safely **disabled in combat** and will no-op rather than taint.

- **Battle Res Tracking**  
  - Battle res charges are primarily based on the **encounter BR pool** via `C_Encounter.GetBattleResurrections` when available.  
  - Outside of boss encounters, the Titan button will still show `BR 0/0` – this is expected and indicates there is no active encounter pool.  
  - The tooltip explains whether counts are coming from the raid encounter pool or from your class’s spell charges (where applicable).