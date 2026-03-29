# Agent Instructions for CombatTimeTracker

## After Making Any Changes

After completing any code change, bug fix, or new feature, you **must**:

### 1. Update `CHANGELOG.md`

- Add a bullet point describing the change under the `## @project-version@` heading.
- Keep entries concise (one line per change).
- **Only the current unreleased version's entries belong in this file.** Do not include entries from previous releases. When a release ships, the section will be tagged — only maintain the current `@project-version@` block.
- Use past tense for fixes, present tense for features. Examples:
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
