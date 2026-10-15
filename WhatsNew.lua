--|------------------------|
--| What's New Window      |
--|------------------------|
-- Shows the in-game changelog (CTT_Changelog, see Changelog.lua) and, once per account, prompts
-- the user when a release flagged as breaking is loaded for the first time.
-- The last version the user was shown is stored in CTT.db.global.whatsNewLastVersion; a session
-- flag (CTT.whatsNewChecked) stops the check from repeating on every loading screen.

local FRAME_WIDTH   = 640
local FRAME_HEIGHT  = 560
local DATE_WIDTH    = 110
local CONTENT_WIDTH = FRAME_WIDTH - 70 -- frame insets + scrollbar

local GOLD  = { 1, 0.82, 0 }
local CYAN  = { 0.25, 0.78, 1 }
local WHITE = { 1, 1, 1 }
local ALERT = { 1, 0.45, 0.2 }
local IMPORTANT_TAG = "|cffff4040%s|r"
local ICON_ALERT = "|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16:16:0:0|t"

local ICON_EXPANDED  = "|TInterface\\Buttons\\UI-MinusButton-Up:16:16:0:0|t"
local ICON_COLLAPSED = "|TInterface\\Buttons\\UI-PlusButton-Up:16:16:0:0|t"

-- Expanded/collapsed state per version for the current session; the newest entry starts expanded.
CTT.whatsNewExpanded = CTT.whatsNewExpanded or {}

--|------------------------|
--| Version helpers        |
--|------------------------|

-- Returns the addon version from the TOC ("vX.Y.Z" for packaged releases, "@project-version@" in dev)
function CTT_GetAddonVersion()
    return C_AddOns.GetAddOnMetadata("CombatTimeTracker", "Version") or ""
end

-- True for empty strings and unreplaced packager keywords such as "@project-version@"
local function IsPlaceholder(value)
    return type(value) ~= "string" or value == "" or value:sub(1, 1) == "@"
end

-- "v12.0.22" / "12.0.22" -> { 12, 0, 22 }; nil for placeholders or non-numeric strings
local function VersionTuple(version)
    if IsPlaceholder(version) then return nil end
    local parts = {}
    for n in version:gmatch("%d+") do
        tinsert(parts, tonumber(n))
    end
    if #parts == 0 then return nil end
    return parts
end

-- Returns true when version a is newer than version b.
-- Unparseable (development) versions count as newer than any tagged version.
function CTT_IsVersionNewer(a, b)
    local ta, tb = VersionTuple(a), VersionTuple(b)
    if not ta and not tb then return a ~= b end
    if not ta then return true end
    if not tb then return false end
    for i = 1, math.max(#ta, #tb) do
        local x, y = ta[i] or 0, tb[i] or 0
        if x ~= y then return x > y end
    end
    return false
end

-- Version text for display; development builds show a localized placeholder instead of the keyword
function CTT_GetDisplayVersion(version)
    if IsPlaceholder(version) then
        return CTT.L["Unreleased (development build)"]
    end
    return version
end

-- Returns the changelog entries newer than lastSeenVersion (every entry when lastSeenVersion is nil)
function CTT_GetNewChangelogEntries(lastSeenVersion)
    local entries = {}
    for _, entry in ipairs(CTT_Changelog) do
        if lastSeenVersion == nil or CTT_IsVersionNewer(entry.version, lastSeenVersion) then
            tinsert(entries, entry)
        end
    end
    return entries
end

--|------------------------|
--| Popups                 |
--|------------------------|

-- Popup with a copyable URL (WoW cannot open links directly)
function CTT_ShowLinkPopup(title, url)
    local L = CTT.L
    StaticPopupDialogs["CTT_LINK"] = {
        text = title .. "\n" .. L["Press Ctrl+C to copy the link"],
        button1 = L["Close"],
        hasEditBox = true,
        editBoxWidth = 350,
        OnShow = function(self)
            local editBox = self.editBox or self.EditBox
            editBox:SetText(url)
            editBox:HighlightText()
            editBox:SetFocus()
        end,
        EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
        EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
        EditBoxOnTextChanged = function(self)
            -- Keep the link intact if the user types over it
            if self:GetText() ~= url then
                self:SetText(url)
                self:HighlightText()
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("CTT_LINK")
end

-- Collects the "what you need to do" lines from every breaking entry in the list
function CTT_GetActionLines(entries)
    local lines = {}
    for _, entry in ipairs(entries) do
        if entry.breaking then
            for _, action in ipairs(entry.actions or {}) do
                tinsert(lines, action)
            end
        end
    end
    return lines
end

-- Popup shown once when a release with breaking changes is loaded for the first time.
-- actionLines (optional) are listed in the popup so the player knows what to do right away.
function CTT_ShowWhatsNewPopup(version, actionLines)
    local L = CTT.L
    local text = string.format(L["Combat Time Tracker %s includes important changes:"], CTT_GetDisplayVersion(version))
    for _, line in ipairs(actionLines or {}) do
        text = text .. "\n\n\226\128\162 " .. line
    end
    text = text .. "\n\n" .. L["Would you like to see what's new?"]
    StaticPopupDialogs["CTT_WHATS_NEW"] = {
        text = text,
        button1 = L["What's New"],
        button2 = L["Later"],
        OnAccept = function() CTT_ToggleWhatsNew(true) end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("CTT_WHATS_NEW")
end

-- Called once per session after login. Records the version the user has now seen and either
-- prompts (breaking release) or prints a hint (regular release) when the version changed.
function CTT_CheckWhatsNew()
    if CTT.whatsNewChecked then return end
    CTT.whatsNewChecked = true

    local current = CTT_GetAddonVersion()
    local lastSeen = CTT.db.global.whatsNewLastVersion
    if lastSeen == current then return end

    local newEntries = CTT_GetNewChangelogEntries(lastSeen)
    local hasBreaking = false
    for _, entry in ipairs(newEntries) do
        if entry.breaking then
            hasBreaking = true
            break
        end
    end

    CTT.db.global.whatsNewLastVersion = current

    if hasBreaking then
        CTT_ShowWhatsNewPopup(current, CTT_GetActionLines(newEntries))
    elseif lastSeen ~= nil then
        CTT:Print(string.format(CTT.L["Combat Time Tracker has been updated to %s! Type /ctt whatsnew to see what changed."], CTT_GetDisplayVersion(current)))
    end
end

--|------------------------|
--| Window                 |
--|------------------------|

local function RenderChangelog(scroll)
    local L = CTT.L
    local AceGUI = CTT.AceGUI
    scroll:ReleaseChildren()

    for index, entry in ipairs(CTT_Changelog) do
        local expanded = CTT.whatsNewExpanded[entry.version]
        if expanded == nil then
            expanded = (index == 1)
        end

        local header = AceGUI:Create("InteractiveLabel")
        local headerText = (expanded and ICON_EXPANDED or ICON_COLLAPSED) .. " " .. string.format(L["Version %s"], CTT_GetDisplayVersion(entry.version))
        if entry.breaking then
            headerText = headerText .. "  " .. string.format(IMPORTANT_TAG, L["Important"])
        end
        header:SetText(headerText)
        header:SetFontObject(GameFontNormalLarge)
        header:SetColor(unpack(GOLD))
        header:SetWidth(CONTENT_WIDTH - DATE_WIDTH)
        header:SetHighlight("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        header:SetCallback("OnClick", function()
            CTT.whatsNewExpanded[entry.version] = not expanded
            RenderChangelog(scroll)
        end)
        scroll:AddChild(header)

        local dateLabel = AceGUI:Create("Label")
        dateLabel:SetText(IsPlaceholder(entry.date) and "" or entry.date)
        dateLabel:SetFontObject(GameFontNormalLarge)
        dateLabel:SetColor(unpack(GOLD))
        dateLabel:SetJustifyH("RIGHT")
        dateLabel:SetWidth(DATE_WIDTH)
        scroll:AddChild(dateLabel)

        if expanded then
            -- Breaking release: say plainly what the player needs to do before anything else
            if entry.breaking and entry.actions and #entry.actions > 0 then
                local actionTitle = AceGUI:Create("Label")
                actionTitle:SetText(ICON_ALERT .. " " .. L["What you need to do"])
                actionTitle:SetFontObject(GameFontNormal)
                actionTitle:SetColor(unpack(ALERT))
                actionTitle:SetFullWidth(true)
                scroll:AddChild(actionTitle)

                for _, action in ipairs(entry.actions) do
                    local line = AceGUI:Create("Label")
                    line:SetText("    \226\128\162 " .. action)
                    line:SetFontObject(GameFontHighlight)
                    line:SetColor(1, 0.85, 0.7)
                    line:SetFullWidth(true)
                    scroll:AddChild(line)
                end
            end

            for _, section in ipairs(entry.sections or {}) do
                local title = AceGUI:Create("Label")
                title:SetText(L[section.title] or section.title)
                title:SetFontObject(GameFontNormal)
                title:SetColor(unpack(CYAN))
                title:SetFullWidth(true)
                scroll:AddChild(title)

                for _, item in ipairs(section.items or {}) do
                    local line = AceGUI:Create("Label")
                    line:SetText("    \226\128\162 " .. item) -- bullet
                    line:SetFontObject(GameFontHighlight)
                    line:SetColor(unpack(WHITE))
                    line:SetFullWidth(true)
                    scroll:AddChild(line)
                end
            end

            local separator = AceGUI:Create("Heading")
            separator:SetText("")
            separator:SetFullWidth(true)
            scroll:AddChild(separator)
        end
    end

    scroll:DoLayout()
end

local function CreateWhatsNewFrame()
    local L = CTT.L
    local AceGUI = CTT.AceGUI

    local frame = AceGUI:Create("Frame")
    frame:SetTitle(L["Combat Time Tracker - What's New"])
    frame:SetStatusText(CTT_GetDisplayVersion(CTT_GetAddonVersion()))
    frame:SetWidth(FRAME_WIDTH)
    frame:SetHeight(FRAME_HEIGHT)
    frame:EnableResize(false)
    frame:SetLayout("Flow")
    frame.frame:SetFrameStrata("HIGH")
    frame:Hide()

    -- Community & Support row
    local linkGroup = AceGUI:Create("SimpleGroup")
    linkGroup:SetFullWidth(true)
    linkGroup:SetLayout("Flow")
    frame:AddChild(linkGroup)

    local linkLabel = AceGUI:Create("Label")
    linkLabel:SetText(L["Community & Support:"])
    linkLabel:SetFontObject(GameFontNormalLarge)
    linkLabel:SetColor(unpack(GOLD))
    linkLabel:SetWidth(180)
    linkGroup:AddChild(linkLabel)

    for _, link in ipairs(CTT_ChangelogLinks) do
        if link.url then
            local button = AceGUI:Create("Button")
            button:SetText(L[link.label] or link.label)
            button:SetWidth(140)
            button:SetCallback("OnClick", function()
                CTT_ShowLinkPopup(L[link.title] or link.title, link.url)
            end)
            linkGroup:AddChild(button)
        end
    end

    local separator = AceGUI:Create("Heading")
    separator:SetText("")
    separator:SetFullWidth(true)
    frame:AddChild(separator)

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetFullWidth(true)
    scroll:SetFullHeight(true)
    scroll:SetLayout("Flow")
    frame:AddChild(scroll)
    frame.scroll = scroll

    -- Let Escape close the window like the options menu
    _G["CombatTimeTrackerWhatsNew"] = frame.frame
    tinsert(UISpecialFrames, "CombatTimeTrackerWhatsNew")

    CTT.whatsNew = frame
end

-- Opens the What's New window (toggles unless forceShow is true)
function CTT_ToggleWhatsNew(forceShow)
    if CTT.whatsNew == nil then
        CreateWhatsNewFrame()
    end
    if CTT.whatsNew:IsShown() and not forceShow then
        CTT.whatsNew:Hide()
        return
    end
    CTT.whatsNew:Show()
    RenderChangelog(CTT.whatsNew.scroll)
end
