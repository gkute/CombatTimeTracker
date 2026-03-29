# Changelog

## @project-version@ (Unreleased)

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

## v12.0.7

* Updated changelog

## v12.0.6

* Restructured all options menu tabs to use labeled InlineGroup sections for better visual organization
* Consolidated General, Display, Visibility, and Sound tabs into a single "Settings" tree entry
* Wrapped all tab content in a ScrollFrame to prevent options being cut off at smaller frame sizes
* Fixed scroll position not being preserved when deleting alerts or raid kills (scroll now stays in place)
* Fixed scrolling not being active by default on first open without requiring a frame resize
* Labels in the Active Alerts and Kill Log lists now dynamically fill available width based on the menu frame size
* Added custom minimap icon using Assets/CombatTimeTracker.tga
* Removed circular border from the minimap icon
* Replaced text "X" delete buttons in Alert Times and Raids with icon buttons using Assets/DeleteIcon.tga
* Added frame resize support with bounds of 375x300 (minimum) to 1125x900 (maximum)
* Menu frame size is now saved to the database and restored on next open
* Fixed "Create Profile" button text being truncated (width increased to 150px)
* Fixed typo "Expasion" corrected to "Expansion" in raid configuration
* Migrated legacy selectedTab values (general/display/visibility/sound) to the new combined "settings" tab
* Removed unused XML templates

## v12.0.5

* Fixed function declaration issues

## v12.0.4

* Added option to make new characters use a selected shared default profile instead of auto-creating character-specific profiles
