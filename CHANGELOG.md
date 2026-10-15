# Changelog

## @project-version@

* Added Midnight Season 2 to the Dungeons tab season filter with the full Season 2 M+ pool (Altar of Fangs, Murder Row, Den of Nalorakk, The Blinding Vale, Voidscar Arena, Kings' Rest, Temple of Sethraliss, Ruby Life Pools)
* Added a Season dropdown to the Raids and Alert Times tabs — selecting a season narrows the Raid list to that season's raids (Midnight Season 1: The Voidspire, March on Quel'Danas, The Dreamrift, Sporefall; Season 2: The Venomous Abyss, The Tidebound Grotto, The Unbinding of Kith'ix)
* Boss kills now record the season they were killed in, and the Raids kill log filters by the selected season (kills recorded before this update only appear under "All")
* Changing the expansion, season or raid on the Raids and Alert Times tabs now resets the raid/boss selection to a valid entry instead of leaving a stale index
* Added The Venomous Abyss, The Tidebound Grotto and Sporefall raids and the Altar of Fangs dungeon to the Midnight data
* Added The Unbinding of Kith'ix raid (Kith'ix), introduced in patch 12.1.5, to the Midnight Season 2 raid pool
* Updated the addon for patch 12.1.5
* Added an in-game What's New window (`/ctt whatsnew` or the new About tab) showing recent release notes with GitHub Issues and Discord links; releases with important changes show a popup once after updating and list what you need to do

## v12.0.21

* Fixed the font dropdown in the options menu showing a blank selection after the addon fell back to a default font because the saved font was missing
* Fixed the font dropdown selection drifting to the wrong font when other addons registered or removed shared media fonts — the menu now always reflects the font actually in use

## v12.0.20

* "Use Class Color" is now a button inside the color picker popup itself (instead of a separate button in the options panel) — click it while picking your text color to instantly apply your class color
* Shortened the "Use Class Color" button label to "Class Color" so it fits better in the color picker popup

## v12.0.19

* Split Core.lua into three focused files: Core.lua (addon lifecycle and events), Utils.lua (utility and calculation functions), and UI.lua (options menu, widget factories, and callbacks)
* Removed broken legacy raid difficulty functions that referenced undefined globals (CTT_UpdateMenuTexts, CTT_CoSUpdateMenuTexts, CTT_tepUpdateMenuTexts and their callers)
* Removed unused variables and dead forward declarations from Core.lua
* Fixed floating point precision issue in centisecond calculation — time display now uses integer arithmetic throughout to avoid rounding errors
* Fixed CTT_StoreBossKills using unnecessary branching and a dead variable; now consistent with CTT_StoreDungeonRun
* Added .claude/ to .gitignore
* Fixed a Lua error on login when a saved font (from a since-removed addon) could no longer be found — now falls back to a safe default font, with a hardcoded fallback if that also fails

## v12.0.18

* Fixed dungeon menu showing pre-Midnight expansions that have no defined season data

## v12.0.17

* Dungeon dropdown now populates with the static season pool when an expansion/season is selected, rather than only showing dungeons from recorded runs
* Dungeon runs now record the current M+ season ID alongside the dungeon name and key level
* Full localization support for all UI text using AceLocale-3.0
* Translated all menu labels, tooltips, popup dialogs, and printed messages into 12 languages: enUS, enGB, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW
* Replaced Locales.xml with direct TOC entries for cleaner locale loading
* Replaced deprecated `C_ChallengeMode.GetCompletionInfo()` with `C_ChallengeMode.GetChallengeCompletionInfo()`
