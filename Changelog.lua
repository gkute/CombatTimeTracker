-- CombatTimeTracker in-game changelog ("What's New" window, see WhatsNew.lua)
--
-- Rules (also described in AGENTS.md):
--   * Newest release first. Keep only the 10 most recent releases.
--   * The top entry is the unreleased/working entry. Its version and date use packager keywords
--     (@project-version@ / @project-date-iso@) which the release packager replaces with the tag
--     name and tag date. When a new tag is created, replace the keywords with the actual tag name
--     and date and start a fresh top entry.
--   * breaking = true when users must know about the release: season pools change, tracked data
--     or saved variables change shape, features are removed/renamed, or anything that alters what
--     the addon records. A breaking release shows a popup on first login after updating.
--   * actions (required when breaking = true) is a short list of plain sentences telling the
--     player what to do, e.g. clear old logs or re-add alerts. They are shown first in the entry
--     under "What you need to do" and repeated in the update popup.
--   * sections are shown in order. Use the titles "Added", "Fixed" and "Changed" (they are
--     localized). Items mirror the CHANGELOG.md bullets for that version, written for players.
--
-- Links shown in the window header. Set a url to nil to hide that button.
CTT_ChangelogLinks = {
    { key = "support", label = "Support",       title = "Support the addon",             url = nil }, -- Patreon / Buy Me a Coffee link goes here once set up
    { key = "github",  label = "GitHub Issues", title = "Report Bugs / Request Features", url = "https://github.com/gkute/CombatTimeTracker/issues" },
    { key = "discord", label = "Discord",       title = "Join the Discord",               url = "https://discord.gg/37CUxNn" },
}

CTT_Changelog = {
    {
        version = "@project-version@",
        date = "@project-date-iso@",
        breaking = true,
        actions = {
            "Your existing kill and run logs are kept, but entries recorded before this update only show when Season is set to \"All\". If you want to start Midnight Season 2 with a clean log, use Clear All on the Dungeons and Raids tabs.",
            "Pick Season 2 in the Season dropdown on the Dungeons, Raids and Alert Times tabs to see the Season 2 dungeon and raid pools. Your saved alerts still work and do not need to be re-added.",
        },
        sections = {
            { title = "Added", items = {
                "Midnight Season 2 in the Dungeons tab season filter with the full Season 2 M+ pool (Altar of Fangs, Murder Row, Den of Nalorakk, The Blinding Vale, Voidscar Arena, Kings' Rest, Temple of Sethraliss, Ruby Life Pools).",
                "Season dropdown on the Raids and Alert Times tabs. Selecting a season narrows the Raid list to that season's raids (Season 1: The Voidspire, March on Quel'Danas, The Dreamrift, Sporefall / Season 2: The Venomous Abyss, The Tidebound Grotto, The Unbinding of Kith'ix).",
                "Boss kills now record the season they were killed in, and the Raids kill log filters by the selected season. Kills recorded before this update only appear under \"All\".",
                "The Venomous Abyss, The Tidebound Grotto and Sporefall raids and the Altar of Fangs dungeon.",
                "The Unbinding of Kith'ix raid (Kith'ix) from patch 12.1.5, in the Midnight Season 2 raid pool.",
                "This What's New window. Open it any time with /ctt whatsnew or from the About tab in the options menu. Releases with important changes will prompt you once after updating.",
            } },
            { title = "Changed", items = {
                "Changing the expansion, season or raid on the Raids and Alert Times tabs now resets the raid/boss selection to a valid entry instead of leaving a stale index.",
                "Updated the addon for patch 12.1.5.",
            } },
        },
    },
    {
        version = "v12.0.21",
        date = "2026-07-25",
        sections = {
            { title = "Fixed", items = {
                "The font dropdown in the options menu showing a blank selection after the addon fell back to a default font because the saved font was missing.",
                "The font dropdown selection drifting to the wrong font when other addons registered or removed shared media fonts. The menu now always reflects the font actually in use.",
            } },
        },
    },
    {
        version = "v12.0.20",
        date = "2026-07-19",
        sections = {
            { title = "Changed", items = {
                "\"Use Class Color\" is now a button inside the color picker popup itself (instead of a separate button in the options panel). Click it while picking your text color to instantly apply your class color.",
                "Shortened the \"Use Class Color\" button label to \"Class Color\" so it fits better in the color picker popup.",
            } },
        },
    },
    {
        version = "v12.0.19",
        date = "2026-04-26",
        sections = {
            { title = "Fixed", items = {
                "Floating point precision issue in centisecond calculation. Time display now uses integer arithmetic throughout to avoid rounding errors.",
                "A Lua error on login when a saved font (from a since-removed addon) could no longer be found. The addon now falls back to a safe default font.",
                "Removed broken legacy raid difficulty functions that referenced undefined globals.",
            } },
            { title = "Changed", items = {
                "Split the addon code into focused files (Core, Utils and UI) for better maintainability.",
            } },
        },
    },
    {
        version = "v12.0.18",
        date = "2026-03-29",
        sections = {
            { title = "Fixed", items = {
                "Dungeon menu showing pre-Midnight expansions that have no defined season data.",
            } },
        },
    },
    {
        version = "v12.0.17",
        date = "2026-03-29",
        sections = {
            { title = "Added", items = {
                "Dungeon dropdown now populates with the static season pool when an expansion/season is selected, rather than only showing dungeons from recorded runs.",
                "Dungeon runs now record the current M+ season ID alongside the dungeon name and key level.",
                "Full localization support for all UI text in 12 languages: enUS, enGB, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW.",
            } },
            { title = "Changed", items = {
                "Replaced a deprecated Mythic+ completion API with its current equivalent.",
            } },
        },
    },
}
