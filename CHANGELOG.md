# Changelog

## @project-version@

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

## v12.0.8

* Added localization skill instruction file (.github/instructions) for locale enforcement
* Updated all UI elements to use localized strings via AceLocale
* Expanded dungeon and raid configuration coverage
* Added all raid entries to raid configuration
