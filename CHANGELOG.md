# Changelog

## v1.0.0.3 – War Within BR + Menu polish
- Updated TOC for War Within (11.x) and Titan dependency using `## RequiredDeps: Titan`.
- Fixed media paths so icon and banner load from `Interface/AddOns/TitanPanelRaidTools/media/...`.
- Reordered file load to ensure core modules initialize before the Titan plugin.
- Reworked Battle Rez tracking into a single source of truth (`ns.BR:GetCounts()`), with safe fallbacks when `C_Encounter.GetBattleResurrections` is unavailable and guaranteed numeric `avail, total` (default `0, 0`).
- Expanded BR event handling to refresh on encounter, group, and spell events, and to request a Titan button update when counts change.
- Updated Titan button text to show: `Raid Tools` label plus a rez icon and `BR x/y` in the value field, always visible even when 0/0.
- Enhanced the BR tooltip to clearly explain encounter-based behavior, cooldowns, and the source of counts (encounter pool vs class spell charges).
- Tightened Ready Check behavior: only runs when in group and the player is leader/assistant, with graceful fallbacks from `DoReadyCheck()` to `/readycheck` and clear chat messages otherwise.
- Updated World Marker handling to prefer Blizzard APIs (`PlaceRaidMarker`, `ClearRaidMarker`) when available, fall back to `/wm` and `/cwm 0`, respect leader/assistant status, and safely no-op in combat.
- Kept the Titan right-click menu stable with the expected structure: `RaidTools` → `ReadyCheck` and `World Markers` (Star…Skull, Clear All), and auto-disables World Markers when marker APIs/macros are unavailable.
- Added a small debug framework (`ns.debug`) with guarded prints and a single fatal-style startup warning if Titan’s API is missing.
- Documented usage in the README: install path, permissions needed for ready checks/markers, and that BR counts are encounter-based and may show `0/0` outside bosses.

## v1.0.0 – Initial Release
- Added Ready Check tracking
- Added Battle Rez tracking via C_Encounter API
- Added Raid Icon support (1–8)
- Added World Marker support (1–8 + clear)
- Added Titan Panel plugin button
- Added full tooltip system
- Added Display Mode system (charges, cooldown, auto)
- Added Blizzard Options panel for settings
- Added SavedVariables
- Added permission checks for markers
- Added event-driven refresh system
