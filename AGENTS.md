# Agent Instructions for CombatTimeTracker

## After Making Any Changes

After completing any code change, bug fix, or new feature, you **must**:

### 1. Update `CHANGELOG.md`

`CHANGELOG.md` is structured by version. The top section is always `## @project-version@` for the current working changes, followed by the last 5 tagged versions below it.

**Before making any CHANGELOG edit, always:**
1. Run `git tag --sort=-version:refname | head -1` to find the latest tag.
2. Run `git describe --exact-match HEAD 2>$null` to check if HEAD is itself tagged.
   - If HEAD **is** tagged: the unreleased section must be promoted to that tag (see below) before adding any new entry.
   - If HEAD **is not** tagged: add your entry under `## @project-version@` normally.

**When adding a new entry:**
- Read the file first.
- Add your bullet under `## @project-version@` only.
- Do **not** create a new heading, duplicate the unreleased section, or modify past version sections.
- Do **not** re-add entries that are already listed.

**When the unreleased section feels stale or incomplete:**
- Run `git log <latest-tag>..HEAD --pretty=format:"* %s" --no-merges` to see all commits since the last tag.
- Reconcile: add any missing commit summaries into the unreleased section, consolidating duplicates into clean user-facing descriptions.

**When a new tag/release is made (or HEAD is already tagged):**
1. Rename `## @project-version@ (Unreleased)` → `## vX.Y.Z` using the tag name.
2. Add a fresh `## @project-version@` section at the very top for the next cycle.
3. Keep only the last 5 tagged sections below the unreleased section — remove anything older.
4. The `.github/workflows/discord-notify.yml` workflow will automatically post the release notes to Discord when the tag is pushed.

**Entry style:**
- One bullet per logical change.
- Past tense for fixes, present tense for features.
- Examples:
  - `* Fixed scroll position resetting when deleting an alert`
  - `* Added option to display target name inside the tracker frame`

### 2. Update `Changelog.lua` (in-game What's New window)

`Changelog.lua` holds `CTT_Changelog`, the data behind the in-game **What's New** window (`/ctt whatsnew`, `WhatsNew.lua`). It mirrors `CHANGELOG.md` and must be updated in the same commit as any `CHANGELOG.md` change.

**Structure:** newest release first, at most **10** releases. Each entry is:
```lua
{
    version = "v12.0.21",          -- git tag name
    date = "2026-07-25",           -- tag date, YYYY-MM-DD
    breaking = true,               -- optional, see below
    actions = { "..." },          -- required when breaking: what the player must do
    sections = {
        { title = "Added",   items = { "..." } },
        { title = "Fixed",   items = { "..." } },
        { title = "Changed", items = { "..." } },
    },
},
```
- Section titles must be exactly `Added`, `Fixed` or `Changed` (they are localized). Only include sections that have items.
- Items are player-facing sentences that mirror the `CHANGELOG.md` bullets for that version. Leave out developer-only items (CI, .gitignore, refactors with no user impact).

**Unreleased entry:** the top entry uses the packager keywords `version = "@project-version@"` and `date = "@project-date-iso@"`; the release packager substitutes the tag name and date. Add your items to this entry whenever you add a bullet under `## @project-version@` in `CHANGELOG.md`.

**When HEAD is tagged (same check as for `CHANGELOG.md`):**
1. Replace the keywords in the top entry with the tag name and the tag date (`git log -1 --format=%as <tag>`).
2. Add a fresh top entry with the keywords and `sections = {}`.
3. Remove entries beyond the 10 most recent.

**Deciding `breaking`:** set `breaking = true` on the unreleased entry when the release contains anything the player needs to know about before they keep playing. On first login after updating, such a release shows a popup offering to open What's New; regular releases only print a chat hint. Mark a release as breaking when it:
- changes which dungeons/raids/seasons are tracked (new season pools, new expansion data, renamed instances)
- changes the shape or meaning of saved data (kill logs, run logs, alerts, profiles) or migrates/clears it
- removes, renames or relocates a feature, option, slash command or tab
- requires the player to redo setup (reset the tracker, re-add alerts, re-pick a font)

Every breaking entry **must** also have `actions`: one to three plain sentences telling the player exactly what to do (e.g. "Use Clear All on the Raids tab if you want a clean Season 2 log", "Re-add your boss alerts"). Say what is kept and what is not. These lines are shown first in the entry under **What you need to do** and repeated in the update popup, so keep them short and concrete.

Do **not** mark bug fixes, translations, cosmetic tweaks or purely additive options as breaking.

### 3. Update `README.md`

- If the change introduces a new feature, slash command, or meaningfully changes user-facing behavior, update the relevant section:
  - **What's New** — top 4–6 highlights of the current release cycle (most important changes)
  - **Features** — add or update a bullet if a new capability was added
  - **Slash Commands** — add or update if a new `/ctt` command was introduced
- Do not add changelog-style noise (e.g., bug fix details) to the README. Only include things that matter to a new user reading about the addon for the first time.

---

## Localization Rules

Any time you add or modify a UI element in `Core.lua`, `UI.lua` or `WhatsNew.lua` — menu labels, tooltips, popup dialogs, printed messages, or any text visible to the user — you **must** localize it using AceLocale-3.0. Changelog item text in `Changelog.lua` is the one exception: it stays in English. See `.github/instructions/localization.instructions.md` for full details.
