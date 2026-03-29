---
applyTo: "Core.lua,Locales/*.lua"
---

# Localization Rules for CombatTimeTracker

Any time you add or modify a UI element in `Core.lua` — menu labels, tooltips, popup dialogs, printed messages, or any text visible to the user — you **must** localize it using AceLocale-3.0. Hardcoded strings are not acceptable.

## Step-by-step: adding a localized string

1. **Use `L[...]` in Core.lua** for every user-visible string:
   ```lua
   label = L["My Label"]
   CTT:Print(L["Something happened."])
   -- For dynamic values, use string.format:
   CTT:Print(string.format(L["Profile '%s' created!"], name))
   ```

2. **Add the key to `Locales\enUS.lua`** with `= true` (enUS is the default/fallback):
   ```lua
   L["My Label"] = true
   L["Profile '%s' created!"] = true
   ```

3. **Add `= true` to `Locales\enGB.lua`** (falls back to enUS automatically).

4. **Translate into all 10 remaining locales:**

   | File | Language |
   |------|----------|
   | `Locales\deDE.lua` | German |
   | `Locales\esES.lua` | Spanish (Spain) |
   | `Locales\esMX.lua` | Spanish (Mexico) |
   | `Locales\frFR.lua` | French |
   | `Locales\itIT.lua` | Italian |
   | `Locales\koKR.lua` | Korean |
   | `Locales\ptBR.lua` | Portuguese (Brazil) |
   | `Locales\ruRU.lua` | Russian |
   | `Locales\zhCN.lua` | Simplified Chinese |
   | `Locales\zhTW.lua` | Traditional Chinese |

## AceLocale-3.0 reference

- **Namespace:** `"cttTranslations"`
- `L` is retrieved in Core.lua via: `local L = LibStub("AceLocale-3.0"):GetLocale("cttTranslations")`
- `L["key"] = true` in a non-default locale means "fall back to enUS" — only acceptable in enGB.
- All locale files are loaded directly via `CombatTimeTracker.toc` — do **not** use a `Locales.xml`.

## What counts as user-facing text (must be localized)

- AceGUI widget fields: `label`, `text`, `desc`, `name`, `title`, `tooltiptext`
- `StaticPopupDialogs` fields: `text`, `button1`, `button2`
- Any `CTT:Print(...)` call
- Tooltip `AddLine` / `AddDoubleLine` content
- Minimap and LDB tooltip text

## What does NOT need localization

- Internal values used in logic comparisons (e.g., `filter == "All"`)
- The LDB broker `name` field (addon identifier)
- ASCII separator lines (e.g., `"========"`)
- Commented-out debug strings
