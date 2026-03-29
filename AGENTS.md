# Agent Instructions for CombatTimeTracker

## After Making Any Changes

After completing any code change, bug fix, or new feature, you **must**:

### 1. Update `CHANGELOG.md`

`CHANGELOG.md` is structured by version. The top section is always `## @project-version@ (Unreleased)` for the current working changes, followed by the last 5 tagged versions below it.

**When adding a new entry:**
- Read the file first.
- Add your bullet under `## @project-version@ (Unreleased)` only.
- Do **not** create a new heading, duplicate the unreleased section, or modify past version sections.
- Do **not** re-add entries that are already listed.

**When the unreleased section feels stale or incomplete:**
- Run `git log <latest-tag>..HEAD --pretty=format:"* %s" --no-merges` to see all commits since the last tag.
- Reconcile: add any missing commit summaries into the unreleased section, consolidating duplicates into clean user-facing descriptions.

**When a new tag/release is made:**
- Rename `## @project-version@ (Unreleased)` to `## vX.Y.Z - YYYY-MM-DD` (the new tag and date).
- Add a fresh `## @project-version@ (Unreleased)` section at the top for the next cycle.
- Keep only the last 5 tagged versions below the unreleased section — remove anything older.

**Entry style:**
- One bullet per logical change.
- Past tense for fixes, present tense for features.
- Examples:
  - `* Fixed scroll position resetting when deleting an alert`
  - `* Added option to display target name inside the tracker frame`

### 2. Update `README.md`

- If the change introduces a new feature, slash command, or meaningfully changes user-facing behavior, update the relevant section:
  - **What's New** — top 4–6 highlights of the current release cycle (most important changes)
  - **Features** — add or update a bullet if a new capability was added
  - **Slash Commands** — add or update if a new `/ctt` command was introduced
- Do not add changelog-style noise (e.g., bug fix details) to the README. Only include things that matter to a new user reading about the addon for the first time.

---

## Localization Rules

Any time you add or modify a UI element in `Core.lua` — menu labels, tooltips, popup dialogs, printed messages, or any text visible to the user — you **must** localize it using AceLocale-3.0. See `.github/instructions/localization.instructions.md` for full details.
