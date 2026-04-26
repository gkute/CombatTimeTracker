--|------------------------|
--| UI Helpers & Menu      |
--|------------------------|

local instanceTypes = {
    "Dungeons Only",
    "Raids Only",
    "Dungons and Raids Only",
    "Everywhere",
    "Combat Only"
}

--|------------------------|
--| AceGUI Widget Factories|
--|------------------------|

local function CreateCheckBox(container, opts)
    local cb = CTT.AceGUI:Create("CheckBox")
    cb:SetLabel(opts.label)
    if opts.fullWidth then cb:SetFullWidth(true)
    elseif opts.width then cb:SetWidth(opts.width) end
    if opts.height then cb:SetHeight(opts.height) end
    cb:SetType("checkbox")
    cb:ClearAllPoints()
    if opts.value ~= nil then cb:SetValue(opts.value) end
    if opts.point then cb:SetPoint(unpack(opts.point)) end
    if opts.callback then cb:SetCallback("OnValueChanged", opts.callback) end
    container:AddChild(cb)
    if opts.name then container[opts.name] = cb end
    return cb
end

local function CreateDropdown(container, opts)
    local dd = CTT.AceGUI:Create("Dropdown")
    dd:SetLabel(opts.label)
    if opts.width then dd:SetWidth(opts.width) end
    dd:SetMultiselect(false)
    dd:ClearAllPoints()
    if opts.disabled ~= nil then dd:SetDisabled(opts.disabled) end
    if opts.list then dd:SetList(opts.list) end
    if opts.text then dd:SetText(opts.text) end
    if opts.value then dd:SetValue(opts.value) end
    if opts.point then dd:SetPoint(unpack(opts.point)) end
    if opts.callback then dd:SetCallback("OnValueChanged", opts.callback) end
    container:AddChild(dd)
    if opts.name then container[opts.name] = dd end
    return dd
end

local function CreateButton(container, opts)
    local btn = CTT.AceGUI:Create("Button")
    btn:SetText(opts.text)
    if opts.width then btn:SetWidth(opts.width) end
    btn:ClearAllPoints()
    if opts.point then btn:SetPoint(unpack(opts.point)) end
    if opts.callback then btn:SetCallback("OnClick", opts.callback) end
    container:AddChild(btn)
    if opts.name then container[opts.name] = btn end
    return btn
end

local function CreateColorPicker(container, opts)
    local cp = CTT.AceGUI:Create("ColorPicker")
    if opts.color then cp:SetColor(unpack(opts.color)) end
    cp:SetLabel(opts.label)
    if opts.width then cp:SetWidth(opts.width) end
    cp:ClearAllPoints()
    if opts.point then cp:SetPoint(unpack(opts.point)) end
    if opts.callback then cp:SetCallback("OnValueChanged", opts.callback) end
    container:AddChild(cp)
    if opts.name then container[opts.name] = cp end
    return cp
end

local function CreateSlider(container, opts)
    local slider = CTT.AceGUI:Create("Slider")
    slider:SetLabel(opts.label)
    if opts.width then slider:SetWidth(opts.width) end
    if opts.isPercent then slider:SetIsPercent(true) end
    if opts.value ~= nil then slider:SetValue(opts.value) end
    if opts.sliderValues then slider:SetSliderValues(unpack(opts.sliderValues)) end
    slider:ClearAllPoints()
    if opts.point then slider:SetPoint(unpack(opts.point)) end
    if opts.onValueChanged then slider:SetCallback("OnValueChanged", opts.onValueChanged) end
    if opts.onMouseUp then slider:SetCallback("OnMouseUp", opts.onMouseUp) end
    container:AddChild(slider)
    if opts.name then container[opts.name] = slider end
    return slider
end

--|------------------------|
--| UI Callback Handlers   |
--|------------------------|

function CTT_ToggleMenu()
    if UnitAffectingCombat("player") or CTT.bossEncounter then
        CTT.loadOptionsAfterCombat = true
        CTT:Print(CTT.L["Options menu cannot be loaded while in combat, try again after combat has ended!"])
    else
        if CTT.menu == nil then
            CTT:CreateOptionsMenu()
        end
        if CTT.menu:IsShown() then
            CTT.menu:Hide()
            CTT:Print(CTT.L["Options menu hidden, for other commands use /ctt help!"])
        else
            CTT.menu:Show()
            CTT:Print(CTT.L["Options menu loaded, for other commands use /ctt help!"])
        end
    end
end

function CTT_LockFrameCheckBoxState(widget, event, value)
    CTT.db.profile.cttMenuOptions.lockFrameCheckButton = value
    if CTT.db.profile.cttMenuOptions.lockFrameCheckButton then
        cttStopwatchGui:EnableMouse(false)
        CTT:Print(CTT.L["Tracker has been locked!"])
    else
        cttStopwatchGui:EnableMouse(true)
        CTT:Print(CTT.L["Tracker has been unlocked!"])
    end
end

function CTT_ColorPickerConfirmed(widget, event, r, g, b, a)
    CTT.db.profile.cttMenuOptions.textColorPicker = { r, g, b, a }
    cttStopwatchGuiTimeText:SetTextColor(r, g, b, a)
end

function CTT_DropdownState(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.dropdownValue = key
    CTT_UpdateText(CTT.db.profile.cttMenuOptions.timeValues[1], CTT.db.profile.cttMenuOptions.timeValues[2],
        CTT.db.profile.cttMenuOptions.timeValues[3], CTT.db.profile.cttMenuOptions.timeValues[5],
        CTT.db.profile.cttMenuOptions.dropdownValue, 1)
end

-- fires any time the slider moves
function CTT_ResizeFrameSliderUpdater(widget, event, value)
    CTT.db.profile.cttMenuOptions.textFrameSizeSlider = value
    local multiplier = value
    local width = 100 + (multiplier * 100)
    local height = 40 + (multiplier * 40)
    local targetSizeHeight = 12.5 + (multiplier * 12.5)
    local targetSizeWidth = 50 + (multiplier * 50)
    local fontVal = 16 + (multiplier * 16)
    local iconSize = 7.5 + (multiplier * 7.5)
    cttStopwatchGui:SetWidth(width)
    cttStopwatchGui:SetHeight(height)
    cttStopwatchGuiTimeText:SetSize(width, height)
    if CTT.db.profile.cttMenuOptions.toggleTarget then
        cttStopwatchGuiTargetText:SetSize(targetSizeWidth, targetSizeHeight)
        cttStopwatchGuiTargetIcon:SetSize(iconSize, iconSize)
        cttStopwatchGuiTargetIcon2:SetSize(iconSize, iconSize)
    end
    if CTT.db.profile.cttMenuOptions.fontName then
        cttStopwatchGuiTimeText:SetFont(CTT.db.profile.cttMenuOptions.fontName, fontVal, CTT.db.profile.cttMenuOptions.fontFlags)
        if CTT.db.profile.cttMenuOptions.toggleTarget then
            cttStopwatchGuiTargetText:SetFont(CTT.db.profile.cttMenuOptions.fontName, fontVal / 2, CTT.db.profile.cttMenuOptions.fontFlags)
        end
        CTT.db.profile.cttMenuOptions.fontVal = fontVal
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf", fontVal, CTT.db.profile.cttMenuOptions.fontFlags)
        if CTT.db.profile.cttMenuOptions.toggleTarget then
            cttStopwatchGuiTargetText:SetFont("Fonts\\MORPHEUS.ttf", fontVal / 2, CTT.db.profile.cttMenuOptions.fontFlags)
        end
        CTT.db.profile.cttMenuOptions.fontVal = fontVal
    end
end

-- fires when the slider is released
function CTT_ResizeFrameSliderDone(widget, event, value)
    CTT.db.profile.cttMenuOptions.textFrameSizeSlider = value
    CTT.db.profile.cttMenuOptions.timeTrackerSize = { cttStopwatchGui:GetWidth(), cttStopwatchGui:GetHeight() }
end

function CTT_FontPickerDropDownState(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.fontPickerDropDown = key
    CTT.db.profile.cttMenuOptions.fontName = CTT.LSM:Fetch("font", CTT.fontTableOptions[key])
    if #CTT.db.profile.cttMenuOptions.timeTrackerSize == 2 and CTT.db.profile.cttMenuOptions.fontVal and
        CTT.db.profile.cttMenuOptions.fontName then
        cttStopwatchGui:SetWidth(CTT.db.profile.cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(CTT.db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(CTT.db.profile.cttMenuOptions.timeTrackerSize[1],
            CTT.db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(CTT.db.profile.cttMenuOptions.fontName, CTT.db.profile.cttMenuOptions.fontVal,
            CTT.db.profile.cttMenuOptions.fontFlags)
        CTT_UpdateText(CTT.db.profile.cttMenuOptions.timeValues[1], CTT.db.profile.cttMenuOptions.timeValues[2],
            CTT.db.profile.cttMenuOptions.timeValues[3], CTT.db.profile.cttMenuOptions.timeValues[5],
            CTT.db.profile.cttMenuOptions.dropdownValue, 2)
    end
end

function CTT_BackDropSliderOnValueChanged(widget, event, value)
    CTT.db.profile.cttMenuOptions.backDropAlphaSlider = value
    cttStopwatchGui:SetBackdropColor(0, 0, 0, value)
    cttStopwatchGui:SetBackdropBorderColor(255, 255, 255, value)
end

function CTT_BackDropSliderDone(widget, event, value)
    CTT.db.profile.cttMenuOptions.backDropAlphaSlider = value
end

function CTT_MinimapIconCheckButton(widget, event, value)
    CTT.db.profile.minimap.hide = value
    CTT.db.profile.cttMenuOptions.minimapIconCheckButton = value
    if CTT.db.profile.cttMenuOptions.minimapIconCheckButton then
        CTT.icon:Hide("CombatTimeTracker")
    else
        CTT.icon:Show("CombatTimeTracker")
    end
end

function CTT_ToggleTargetCheckButton(widget, event, value)
    CTT.db.profile.cttMenuOptions.toggleTarget = value
    if CTT.db.profile.cttMenuOptions.toggleTarget then
        cttStopwatchGuiTargetText:Show()
    else
        cttStopwatchGuiTargetText:Hide()
    end
end

function CTT_ToggleClickThroughCheckButton(widget, event, value)
    CTT.db.profile.cttMenuOptions.clickThrough = value
    if CTT.db.profile.cttMenuOptions.clickThrough then
        cttStopwatchGui:EnableMouse(value)
    else
        cttStopwatchGui:EnableMouse(value)
    end
end

function CTT_TogglePrintCheckButton(widget, event, value)
    CTT.db.profile.cttMenuOptions.togglePrint = value;
end

function CTT_ToggleTextFlagsButton(widget, event, value)
    CTT.db.profile.cttMenuOptions.textFlags = value
    if value then
        CTT.db.profile.cttMenuOptions.fontFlags = "OUTLINE, THICKOUTLINE, MONOCHROME"
    else
        CTT.db.profile.cttMenuOptions.fontFlags = ""
    end
    CTT_SetTrackerSizeOnLogin()
end

function CTT_InstanceTypeDropDown(widget, event, key, checked)
    local zone = GetRealZoneText()
    CTT.db.profile.cttMenuOptions.instanceType = key
    if key ~= 4 then
        CTT_InstanceTypeDisplay(key)
    elseif key == 5 then
        if cttStopwatchGui:IsShown() then
            return
        else
            cttStopwatchGui:Hide()
        end
    else
        if cttStopwatchGui:IsShown() then
            return
        else
            cttStopwatchGui:Show()
        end
    end
end

function CTT_PlaySoundOnDropDownSelect(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.soundDropDownValue = key
    local soundPath = CTT.LSM:Fetch("sound", CTT.soundTableOptions[key])
    CTT.db.profile.cttMenuOptions.soundName = soundPath
    if soundPath then
        PlaySoundFile(soundPath, "Master")
    end
end

function CTT_AlertTimeOnEnterPressed(widget, event, text)
    CTT.db.profile.cttMenuOptions.localStore = text
end

function CTT_AlertRaidDropDown(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.raidKey = key
    CTT.db.profile.cttMenuOptions.raidDropdown = CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey)[key]
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_AlertRaidDropDownForRaidTab(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.raidKey = key
    CTT.db.profile.cttMenuOptions.raidDropdown = CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey)[key]
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_ExpansionDropDown(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.xpacKey = key
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_ExpansionDropDownForRaidTab(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.xpacKey = key
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_AlertBossDropDown(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.bossDropdown = CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey)[key]
    CTT.db.profile.cttMenuOptions.bossDropDownkey = key
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_AlertBossDropDownForRaidTab(widget, event, key, checked)
    CTT.db.profile.cttMenuOptions.bossDropdown = CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey)[key]
    CTT.db.profile.cttMenuOptions.bossDropDownkey = key
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_ClearAlertBossRaidTab()
    if CTT.db.profile.RaidKills ~= nil then
        CTT.db.profile.RaidKills = {}
    end
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_AlertAddButtonClicked(widget, event)
    local timeInSeconds = IsInt(CTT.db.profile.cttMenuOptions.localStore)
    if CTT.db.profile.cttMenuOptions.alerts == nil then
        CTT.db.profile.cttMenuOptions.alerts = {}
    end
    local alerts = CTT.db.profile.cttMenuOptions.alerts
    local canAdd = CTT.db.profile.cttMenuOptions.localStore ~= nil and timeInSeconds and CTT.db.profile.cttMenuOptions.raidDropdown ~= nil
        and CTT.db.profile.cttMenuOptions.bossDropdown ~= nil
    if canAdd then
        alerts[#alerts + 1] = {
            tonumber(CTT.db.profile.cttMenuOptions.localStore),
            CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey)[CTT.db.profile.cttMenuOptions.raidKey],
            CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey)[CTT.db.profile.cttMenuOptions.bossDropDownkey],
            CTT_GetRaidEncounterID(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey, CTT.db.profile.cttMenuOptions.bossDropDownkey)
        }
        CTT.menu.tree:SelectByValue("alerts")
    else
        if not timeInSeconds then
            CTT_AlertsErrorPopup(1)
        elseif CTT.db.profile.cttMenuOptions.raidDropdown == nil then
            CTT_AlertsErrorPopup(2)
        elseif CTT.db.profile.cttMenuOptions.bossDropdown == nil then
            CTT_AlertsErrorPopup(3)
        end
    end
end

function CTT_AlertDeleteButtonClicked(widget, event, key)
    if CTT.db.profile.cttMenuOptions.alerts ~= nil then
        table.remove(CTT.db.profile.cttMenuOptions.alerts, key)
    end
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_AlertDeleteButtonClickedForRaidTab(widget, event, key)
    if CTT.db.profile.RaidKills ~= nil then
        table.remove(CTT.db.profile.RaidKills, key)
    end
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_DeleteDungeonRun(widget, event, key)
    if CTT.db.profile.DungeonKills ~= nil then
        table.remove(CTT.db.profile.DungeonKills, key)
    end
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_DungeonFilterDropDown(widget, event, key, checked)
    local expansionName = CTT.db.profile.cttMenuOptions.dungeonExpansionName or "All"
    local seasonName = CTT.db.profile.cttMenuOptions.dungeonSeasonName or "All"
    local staticList = CTT_GetDungeonDropdownList(expansionName, seasonName)
    local dungeonNames = staticList or CTT_BuildDungeonFilterList()
    CTT.db.profile.cttMenuOptions.dungeonFilterKey = key
    CTT.db.profile.cttMenuOptions.dungeonFilterName = dungeonNames[key] or "All"
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_DungeonExpansionDropDown(widget, event, key, checked)
    local expansionList = CTT_GetMPlusExpansionFilterList()
    CTT.db.profile.cttMenuOptions.dungeonExpansionKey = key
    CTT.db.profile.cttMenuOptions.dungeonExpansionName = expansionList[key] or "All"
    -- Changing expansion resets both the season and dungeon filter
    CTT.db.profile.cttMenuOptions.dungeonSeasonKey = 1
    CTT.db.profile.cttMenuOptions.dungeonSeasonName = "All"
    CTT.db.profile.cttMenuOptions.dungeonFilterKey = 1
    CTT.db.profile.cttMenuOptions.dungeonFilterName = "All"
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_DungeonSeasonDropDown(widget, event, key, checked)
    local expansionName = CTT.db.profile.cttMenuOptions.dungeonExpansionName or "All"
    local seasonList = CTT_GetMPlusSeasonFilterList(expansionName)
    CTT.db.profile.cttMenuOptions.dungeonSeasonKey = key
    CTT.db.profile.cttMenuOptions.dungeonSeasonName = seasonList[key] or "All"
    -- Changing season resets the dungeon name filter
    CTT.db.profile.cttMenuOptions.dungeonFilterKey = 1
    CTT.db.profile.cttMenuOptions.dungeonFilterName = "All"
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_AlertsErrorPopup(errorCode)
    local text = CTT.L["You must enter values!"]

    if errorCode == 1 then
        text = CTT.L["You must enter a valid time in seconds (no decimal values!!! e.g. 100 not 100.1)!"]
    elseif errorCode == 2 then
        text = CTT.L["You must select a raid!"]
    elseif errorCode == 3 then
        text = CTT.L["You must select a boss!"]
    end

    StaticPopupDialogs["AlertError"] = {
        text = text,
        button1 = CTT.L["Ok"],
        OnAccept = function()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("AlertError")
end

function CTT_ProfileNameOnEnterPressed(widget, event, text)
    local textToUse = string.gsub(text, "^%s*(.-)%s*$", "%1")
    if textToUse ~= nil and textToUse ~= "" then
        CTT.newProfileName = text
    else
        StaticPopupDialogs["ProfileNameError"] = {
            text = CTT.L["You have entered an invalid profile name, please try again!"],
            button1 = CTT.L["Ok"],
            OnAccept = function()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("ProfileNameError")
    end
end

function CTT_ProfileDropDownPicker(widget, event, key)
    CTT.db:SetProfile(CTT.db:GetProfiles()[key])
    CTT_SetActiveProfile(CTT.db:GetProfiles()[key])
    CTT.menu.tree:SelectByValue("settings")
    CTT:Print(activeProfile .. " profile is now the active profile!")
    CTT_SetTrackerSizeOnLogin()
end

function CTT_ProfileAddButton(widget, event)
    CTT.db:SetProfile(CTT.newProfileName)
    CTT_SetActiveProfile(CTT.newProfileName)
    CTT:Print(string.format(CTT.L["New profile '%s' has been created!"], CTT.newProfileName))
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_ProfileCopyDropdown(widget, event, key)
    CTT:Print(string.format(CTT.L["%s has been updated to a copy of %s!"], activeProfile, CTT.db:GetProfiles()[key]))
    CTT.db:CopyProfile(CTT.db:GetProfiles()[key], true)
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_ProfileDeleteDropdown(widget, event, key)
    local deletedProfileName = CTT.db:GetProfiles()[key]
    CTT:Print(string.format(CTT.L["%s profile has been deleted!"], deletedProfileName))
    CTT.db:DeleteProfile(deletedProfileName, true)
    if CTT.db.global.sharedProfileName == deletedProfileName then
        CTT.db.global.sharedProfileName = CTT.db:GetCurrentProfile()
    end
    CTT_SetActiveProfile(CTT.db:GetCurrentProfile())
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_UseSharedDefaultProfile(widget, event, value)
    local currentProfileName = CTT.db:GetCurrentProfile()
    CTT.db.global.useSharedDefaultProfile = value

    if value and (CTT.db.global.sharedProfileName == nil or CTT.db.global.sharedProfileName == "") then
        CTT.db.global.sharedProfileName = currentProfileName
    end

    local targetProfileName = CTT_GetCharacterProfileName()
    if value then
        targetProfileName = CTT_GetSharedProfileName()
    end

    local targetProfileExists = CTT_ProfileExists(targetProfileName)

    if currentProfileName ~= targetProfileName then
        CTT.db:SetProfile(targetProfileName)

        if not targetProfileExists then
            CTT.db:CopyProfile(currentProfileName, true)
        end
    end

    CTT_SetActiveProfile(targetProfileName)
    if value then
        CTT:Print(string.format(CTT.L["New characters will start on the %s profile."], targetProfileName))
    else
        CTT:Print(CTT.L["New characters will use character-specific profiles."])
    end
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_SharedProfileDropDown(widget, event, key)
    local selectedProfileName = CTT.db:GetProfiles()[key]

    CTT.db.global.sharedProfileName = selectedProfileName
    CTT:Print(string.format(CTT.L["Shared profile is now set to %s."], selectedProfileName))

    if CTT.db.global.useSharedDefaultProfile then
        CTT.db:SetProfile(selectedProfileName)
        CTT_SetActiveProfile(selectedProfileName)
        CTT_SetTrackerSizeOnLogin()
        CTT.menu.tree:SelectByValue("settings")
    end
end

function CTT_ResetTrackerOnCombatEnding(widget, event, value)
    --@debug@
    CTT:Print(CTT.db.profile.cttMenuOptions.resetCounterOnEndOfCombat)
    CTT:Print(value)
    --@end-debug@
    if not value then
        CTT.time = GetTime()
        CTT.cttElapsedSeconds = 0
    end
    CTT.db.profile.cttMenuOptions.resetCounterOnEndOfCombat = value;
end

--|------------------------|
--| Options Menu Sections  |
--|------------------------|

local function General(container)
    local frameGroup = CTT.AceGUI:Create("InlineGroup")
    frameGroup:SetTitle(CTT.L["Frame"])
    frameGroup:SetFullWidth(true)
    frameGroup:SetLayout("Flow")
    container:AddChild(frameGroup)

    CreateCheckBox(frameGroup, {
        label = CTT.L["Lock"],
        fullWidth = true,
        height = 22,
        value = CTT.db.profile.cttMenuOptions.lockFrameCheckButton,
        callback = CTT_LockFrameCheckBoxState,
        name = "lockFrameCheckButton",
    })

    CreateCheckBox(frameGroup, {
        label = CTT.L["Show Target"],
        fullWidth = true,
        height = 22,
        value = CTT.db.profile.cttMenuOptions.toggleTarget,
        callback = CTT_ToggleTargetCheckButton,
        name = "toggleTarget",
    })

    local minimapGroup = CTT.AceGUI:Create("InlineGroup")
    minimapGroup:SetTitle(CTT.L["Minimap"])
    minimapGroup:SetFullWidth(true)
    minimapGroup:SetLayout("Flow")
    container:AddChild(minimapGroup)

    CreateCheckBox(minimapGroup, {
        label = CTT.L["Hide Minimap Icon"],
        fullWidth = true,
        height = 22,
        value = CTT.db.profile.cttMenuOptions.minimapIconCheckButton,
        callback = CTT_MinimapIconCheckButton,
        name = "minimapIconCheckButton",
    })

    local behaviorGroup = CTT.AceGUI:Create("InlineGroup")
    behaviorGroup:SetTitle(CTT.L["Behavior"])
    behaviorGroup:SetFullWidth(true)
    behaviorGroup:SetLayout("Flow")
    container:AddChild(behaviorGroup)

    CreateCheckBox(behaviorGroup, {
        label = CTT.L["Toggle Messages"],
        fullWidth = true,
        height = 22,
        value = CTT.db.profile.cttMenuOptions.togglePrint,
        callback = CTT_TogglePrintCheckButton,
        name = "togglePrint",
    })

    CreateCheckBox(behaviorGroup, {
        label = CTT.L["Reset After Combat"],
        fullWidth = true,
        height = 22,
        value = CTT.db.profile.cttMenuOptions.resetCounterOnEndOfCombat,
        callback = CTT_ResetTrackerOnCombatEnding,
        name = "resetTrackerOnCombatEnding",
    })
end

local function Display(container)
    local textGroup = CTT.AceGUI:Create("InlineGroup")
    textGroup:SetTitle(CTT.L["Text Appearance"])
    textGroup:SetFullWidth(true)
    textGroup:SetLayout("Flow")
    container:AddChild(textGroup)

    CreateColorPicker(textGroup, {
        color = CTT.db.profile.cttMenuOptions.textColorPicker,
        label = CTT.L["Text Color"],
        width = 100,
        callback = CTT_ColorPickerConfirmed,
        name = "textColorPicker",
    })

    CreateCheckBox(textGroup, {
        label = CTT.L["TextOutline"],
        fullWidth = true,
        height = 22,
        value = CTT.db.profile.cttMenuOptions.textFlags,
        callback = CTT_ToggleTextFlagsButton,
        name = "textFlagsButton",
    })

    CreateDropdown(textGroup, {
        label = CTT.L["Text Format"],
        width = 200,
        list = CTT.db.profile.cttMenuOptions.cttTextFormatOptions,
        text = CTT.db.profile.cttMenuOptions.cttTextFormatOptions[CTT.db.profile.cttMenuOptions.dropdownValue],
        value = CTT.db.profile.cttMenuOptions.dropdownValue,
        callback = CTT_DropdownState,
        name = "textStyleDropDown",
    })

    local sizeGroup = CTT.AceGUI:Create("InlineGroup")
    sizeGroup:SetTitle(CTT.L["Size"])
    sizeGroup:SetFullWidth(true)
    sizeGroup:SetLayout("Flow")
    container:AddChild(sizeGroup)

    CreateSlider(sizeGroup, {
        label = CTT.L["Tracker Size"],
        width = 200,
        isPercent = true,
        value = CTT.db.profile.cttMenuOptions.textFrameSizeSlider,
        sliderValues = { 0, 1, .01 },
        onValueChanged = CTT_ResizeFrameSliderUpdater,
        onMouseUp = CTT_ResizeFrameSliderDone,
        name = "textFrameSizeSlider",
    })

    CreateSlider(sizeGroup, {
        label = CTT.L["Backdrop Opacity"],
        width = 200,
        isPercent = true,
        value = CTT.db.profile.cttMenuOptions.backDropAlphaSlider,
        sliderValues = { 0, 1, .01 },
        onValueChanged = CTT_BackDropSliderOnValueChanged,
        onMouseUp = CTT_BackDropSliderDone,
        name = "backDropAlphaSlider",
    })

    local fontGroup = CTT.AceGUI:Create("InlineGroup")
    fontGroup:SetTitle(CTT.L["Font"])
    fontGroup:SetFullWidth(true)
    fontGroup:SetLayout("Flow")
    container:AddChild(fontGroup)

    CreateDropdown(fontGroup, {
        label = CTT.L["Choose Font"],
        width = 270,
        list = CTT.LSM:List("font"),
        text = CTT.fontTableOptions[CTT.db.profile.cttMenuOptions.fontPickerDropDown],
        value = CTT.db.profile.cttMenuOptions.fontPickerDropDown,
        callback = CTT_FontPickerDropDownState,
        name = "fontPickerDropDown",
    })
end

local function Visibility(container)
    local visGroup = CTT.AceGUI:Create("InlineGroup")
    visGroup:SetTitle(CTT.L["Settings"])
    visGroup:SetFullWidth(true)
    visGroup:SetLayout("Flow")
    container:AddChild(visGroup)

    CreateDropdown(visGroup, {
        label = CTT.L["Show Tracker When?"],
        width = 200,
        list = instanceTypes,
        text = instanceTypes[CTT.db.profile.cttMenuOptions.instanceType],
        value = CTT.db.profile.cttMenuOptions.instanceType,
        callback = CTT_InstanceTypeDropDown,
        name = "instanceType",
    })

    CreateCheckBox(visGroup, {
        label = CTT.L["Click Through"],
        fullWidth = true,
        height = 22,
        value = CTT.db.profile.cttMenuOptions.clickThrough,
        callback = CTT_ToggleClickThroughCheckButton,
        name = "clickThrough",
    })
end

local function Sound(container)
    local soundGroup = CTT.AceGUI:Create("InlineGroup")
    soundGroup:SetTitle(CTT.L["Settings"])
    soundGroup:SetFullWidth(true)
    soundGroup:SetLayout("Flow")
    container:AddChild(soundGroup)

    CreateDropdown(soundGroup, {
        label = CTT.L["Choose Sound"],
        width = 270,
        list = CTT.LSM:List("sound"),
        text = CTT.soundTableOptions[CTT.db.profile.cttMenuOptions.soundDropDownValue],
        value = CTT.db.profile.cttMenuOptions.soundDropDownValue,
        callback = CTT_PlaySoundOnDropDownSelect,
        name = "soundPickerDropDown",
    })
end

local function Profiles(container)
    local newProfileGroup = CTT.AceGUI:Create("InlineGroup")
    newProfileGroup:SetTitle(CTT.L["New Profile"])
    newProfileGroup:SetFullWidth(true)
    newProfileGroup:SetLayout("Flow")
    container:AddChild(newProfileGroup)

    local profileName = CTT.AceGUI:Create("EditBox")
    profileName:SetLabel(CTT.L["New Profile Name"])
    profileName:ClearAllPoints()
    profileName:SetCallback("OnEnterPressed", CTT_ProfileNameOnEnterPressed)
    newProfileGroup:AddChild(profileName)
    container.profileName = profileName

    CreateButton(newProfileGroup, {
        text = CTT.L["Create Profile"],
        width = 150,
        callback = CTT_ProfileAddButton,
        name = "profileAddButton",
    })

    local manageGroup = CTT.AceGUI:Create("InlineGroup")
    manageGroup:SetTitle(CTT.L["Manage Profiles"])
    manageGroup:SetFullWidth(true)
    manageGroup:SetLayout("Flow")
    container:AddChild(manageGroup)

    CreateDropdown(manageGroup, {
        label = CTT.L["Choose Profile"],
        multiselect = false,
        list = CTT.db:GetProfiles(),
        value = activeProfileKey,
        callback = CTT_ProfileDropDownPicker,
        name = "profileDropDownPicker",
    })

    CreateDropdown(manageGroup, {
        label = CTT.L["Copy Profile"],
        multiselect = false,
        list = CTT.db:GetProfiles(),
        callback = CTT_ProfileCopyDropdown,
        name = "profileCopyDropdown",
    })

    CreateDropdown(manageGroup, {
        label = CTT.L["Delete Profile"],
        multiselect = false,
        list = CTT.db:GetProfiles(),
        callback = CTT_ProfileDeleteDropdown,
        name = "profileDeleteDropdown",
    })

    local sharedGroup = CTT.AceGUI:Create("InlineGroup")
    sharedGroup:SetTitle(CTT.L["Shared Profile"])
    sharedGroup:SetFullWidth(true)
    sharedGroup:SetLayout("Flow")
    container:AddChild(sharedGroup)

    CreateCheckBox(sharedGroup, {
        label = CTT.L["Use Default For New Characters"],
        fullWidth = true,
        height = 22,
        value = CTT.db.global.useSharedDefaultProfile,
        callback = CTT_UseSharedDefaultProfile,
        name = "sharedDefaultProfile",
    })

    CreateDropdown(sharedGroup, {
        label = CTT.L["Shared Profile"],
        multiselect = false,
        list = CTT.db:GetProfiles(),
        value = CTT_GetProfileKey(CTT_GetSharedProfileName()),
        width = 200,
        disabled = not CTT.db.global.useSharedDefaultProfile,
        callback = CTT_SharedProfileDropDown,
        name = "sharedProfilePicker",
    })
end

local function Dungeons(container)
    local configGroup = CTT.AceGUI:Create("InlineGroup")
    configGroup:SetTitle(CTT.L["Filter"])
    configGroup:SetFullWidth(true)
    configGroup:SetLayout("Flow")
    container:AddChild(configGroup)

    local expansionList = CTT_GetMPlusExpansionFilterList()
    local savedExpKey = CTT.db.profile.cttMenuOptions.dungeonExpansionKey or 1
    if savedExpKey > #expansionList then
        savedExpKey = 1
        CTT.db.profile.cttMenuOptions.dungeonExpansionKey = 1
        CTT.db.profile.cttMenuOptions.dungeonExpansionName = "All"
    end
    local selectedExpansion = expansionList[savedExpKey]

    CreateDropdown(configGroup, {
        label = CTT.L["Expansion"],
        list = expansionList,
        text = expansionList[savedExpKey],
        value = savedExpKey,
        width = 200,
        callback = CTT_DungeonExpansionDropDown,
        name = "dungeonExpansionFilter"
    })

    local seasonList = CTT_GetMPlusSeasonFilterList(selectedExpansion)
    local savedSeaKey = CTT.db.profile.cttMenuOptions.dungeonSeasonKey or 1
    if savedSeaKey > #seasonList then
        savedSeaKey = 1
        CTT.db.profile.cttMenuOptions.dungeonSeasonKey = 1
        CTT.db.profile.cttMenuOptions.dungeonSeasonName = "All"
    end
    local selectedSeason = seasonList[savedSeaKey]

    CreateDropdown(configGroup, {
        label = CTT.L["Season"],
        list = seasonList,
        text = seasonList[savedSeaKey],
        value = savedSeaKey,
        width = 175,
        callback = CTT_DungeonSeasonDropDown,
        name = "dungeonSeasonFilter"
    })

    -- Dungeon filter: use static season pool when expansion/season is selected,
    -- otherwise fall back to the run-based list.
    local staticDungeonList = CTT_GetDungeonDropdownList(selectedExpansion, selectedSeason)
    local dungeonNames = staticDungeonList or CTT_BuildDungeonFilterList()

    -- Clamp saved key — when switching to a new season pool the old index may be out of range
    local savedKey = CTT.db.profile.cttMenuOptions.dungeonFilterKey or 1
    if savedKey > #dungeonNames then
        savedKey = 1
        CTT.db.profile.cttMenuOptions.dungeonFilterKey = 1
        CTT.db.profile.cttMenuOptions.dungeonFilterName = "All"
    end

    CreateDropdown(configGroup, {
        label = CTT.L["Dungeon"],
        list = dungeonNames,
        text = dungeonNames[savedKey],
        value = savedKey,
        width = 275,
        callback = CTT_DungeonFilterDropDown,
        name = "dungeonFilter"
    })

    CreateButton(configGroup, {
        text = CTT.L["Clear All"],
        width = 125,
        callback = function()
            CTT.db.profile.DungeonKills = {}
            CTT.db.profile.cttMenuOptions.dungeonFilterKey = 1
            CTT.db.profile.cttMenuOptions.dungeonFilterName = "All"
            CTT.db.profile.cttMenuOptions.dungeonExpansionKey = 1
            CTT.db.profile.cttMenuOptions.dungeonExpansionName = "All"
            CTT.db.profile.cttMenuOptions.dungeonSeasonKey = 1
            CTT.db.profile.cttMenuOptions.dungeonSeasonName = "All"
            CTT.menu.tree:SelectByValue("dungeons")
        end,
        name = "clearDungeonsButton"
    })

    local listGroup = CTT.AceGUI:Create("InlineGroup")
    listGroup:SetTitle(CTT.L["M+ Run Log"])
    listGroup:SetFullWidth(true)
    listGroup:SetLayout("Flow")
    container:AddChild(listGroup)

    local labelWidth = math.max(200, listGroup.frame:GetWidth() - 54)
    local dungeonFilter = CTT.db.profile.cttMenuOptions.dungeonFilterName or "All"

    local filterBySeasonID = (selectedExpansion ~= "All" or selectedSeason ~= "All")
    local matchingSeasonIDs = filterBySeasonID and CTT_GetMPlusSeasonIDs(selectedExpansion, selectedSeason) or nil

    if CTT.db.profile.DungeonKills ~= nil and #CTT.db.profile.DungeonKills > 0 then
        local anyShown = false
        for i, v in ipairs(CTT.db.profile.DungeonKills) do
            local seasonMatch = true
            if filterBySeasonID then
                local runSeasonID = v.SeasonID
                if runSeasonID and runSeasonID > 0 then
                    seasonMatch = matchingSeasonIDs[runSeasonID] == true
                else
                    -- Legacy run with no SeasonID — only visible under All/All
                    seasonMatch = false
                end
            end

            local dungeonMatch = (dungeonFilter == "All") or (v.Dungeon == dungeonFilter)

            if seasonMatch and dungeonMatch then
                anyShown = true
                local timedText = v.OnTime and "|cff00ff00Timed|r" or "|cffff4444Depleted|r"
                local text = string.format(
                    "[%s]  %s  +%d  —  Run: %s  (%s)",
                    v.LocalCompletionTime or "?",
                    v.Dungeon or "Unknown",
                    v.KeyLevel or 0,
                    v.RunTime or "??:??",
                    timedText
                )

                local label = CTT.AceGUI:Create("Label")
                label:SetText(text)
                label:SetColor(255, 255, 0)
                label:SetWidth(labelWidth)
                label:ClearAllPoints()
                listGroup:AddChild(label)

                local deleteBtn = CTT.AceGUI:Create("Icon")
                deleteBtn:SetImage("Interface\\AddOns\\CombatTimeTracker\\Assets\\DeleteIcon")
                deleteBtn:SetImageSize(24, 24)
                deleteBtn:SetWidth(24)
                deleteBtn:SetLabel("")
                deleteBtn:ClearAllPoints()
                deleteBtn:SetCallback("OnClick", function(widget) CTT_DeleteDungeonRun(widget, event, i) end)
                listGroup:AddChild(deleteBtn)
            end
        end
        if not anyShown then
            local noDataLabel = CTT.AceGUI:Create("Label")
            noDataLabel:SetText(CTT.L["No runs recorded for this dungeon."])
            noDataLabel:SetColor(200, 200, 200)
            noDataLabel:SetFullWidth(true)
            listGroup:AddChild(noDataLabel)
        end
    else
        local noDataLabel = CTT.AceGUI:Create("Label")
        noDataLabel:SetText(CTT.L["No M+ runs recorded yet. Complete a Mythic Keystone dungeon to see your run times here."])
        noDataLabel:SetColor(200, 200, 200)
        noDataLabel:SetFullWidth(true)
        listGroup:AddChild(noDataLabel)
    end
end

local function Raids(container)
    local configGroup = CTT.AceGUI:Create("InlineGroup")
    configGroup:SetTitle(CTT.L["Configuration"])
    configGroup:SetFullWidth(true)
    configGroup:SetLayout("Flow")
    container:AddChild(configGroup)

    CreateDropdown(configGroup, {
        label = CTT.L["Expansion"],
        list = CTT_GetExpansionNames(),
        text = CTT_GetExpansionNames()[CTT.db.profile.cttMenuOptions.xpacKey],
        value = CTT.db.profile.cttMenuOptions.xpacKey,
        width = 125,
        callback = CTT_ExpansionDropDownForRaidTab,
        name = "xpacDropdown"
    })

    CreateDropdown(configGroup, {
        label = CTT.L["Raid"],
        list = CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey),
        text = CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey)[CTT.db.profile.cttMenuOptions.raidKey],
        value = CTT.db.profile.cttMenuOptions.raidKey,
        width = 225,
        callback = CTT_AlertRaidDropDownForRaidTab,
        name = "raidDropdown"
    })

    CreateDropdown(configGroup, {
        label = CTT.L["Boss"],
        list = CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey),
        text = CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey)[CTT.db.profile.cttMenuOptions.bossDropDownkey],
        value = CTT.db.profile.cttMenuOptions.bossDropDownkey,
        width = 250,
        callback = CTT_AlertBossDropDownForRaidTab,
        name = "bossDropdown"
    })

    CreateButton(configGroup, {
        text = CTT.L["Clear All"],
        width = 125,
        callback = CTT_ClearAlertBossRaidTab,
        name = "deleteKillsButton"
    })

    local listGroup = CTT.AceGUI:Create("InlineGroup")
    listGroup:SetTitle(CTT.L["Kill Log"])
    listGroup:SetFullWidth(true)
    listGroup:SetLayout("Flow")
    container:AddChild(listGroup)

    local labelWidth = math.max(200, listGroup.frame:GetWidth() - 54)

    if CTT.db.profile.RaidKills ~= nil and #CTT.db.profile.RaidKills > 0 then
        for i, v in ipairs(CTT.db.profile.RaidKills) do
            if (v.Expansion == CTT_GetExpansionNames()[CTT.db.profile.cttMenuOptions.xpacKey]
                and v.RaidInstance == CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey)[CTT.db.profile.cttMenuOptions.raidKey]
                and v.BossName == CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey)[CTT.db.profile.cttMenuOptions.bossDropDownkey])
            then
                local label = CTT.AceGUI:Create("Label")
                label:SetText(string.format(CTT.L["%s was killed on: %s, with a Kill Time of: %s, raid difficulty: %s, with %s players, and was killed successfully: %s"], v.BossName, v.LocalKillTime, v.KillTime, v.Difficulty, v.GroupSize, tostring(v.Success)))
                label:SetColor(255, 255, 0)
                label:SetWidth(labelWidth)
                label:ClearAllPoints()
                listGroup:AddChild(label)

                local deleteBtn = CTT.AceGUI:Create("Icon")
                deleteBtn:SetImage("Interface\\AddOns\\CombatTimeTracker\\Assets\\DeleteIcon")
                deleteBtn:SetImageSize(24, 24)
                deleteBtn:SetWidth(24)
                deleteBtn:SetLabel("")
                deleteBtn:ClearAllPoints()
                deleteBtn:SetCallback("OnClick", function(widget) CTT_AlertDeleteButtonClickedForRaidTab(widget, event, i) end)
                listGroup:AddChild(deleteBtn)
            end
        end
    end
end

local function Alerts(container)
    local addAlertGroup = CTT.AceGUI:Create("InlineGroup")
    addAlertGroup:SetTitle(CTT.L["Add Alert"])
    addAlertGroup:SetFullWidth(true)
    addAlertGroup:SetLayout("Flow")
    container:AddChild(addAlertGroup)

    CreateDropdown(addAlertGroup, {
        label = CTT.L["Expansion"],
        list = CTT_GetExpansionNames(),
        text = CTT_GetExpansionNames()[CTT.db.profile.cttMenuOptions.xpacKey],
        value = CTT.db.profile.cttMenuOptions.xpacKey,
        width = 125,
        callback = CTT_ExpansionDropDown,
        name = "xpacDropdown"
    })

    local timeInput = CTT.AceGUI:Create("EditBox")
    timeInput:SetLabel(CTT.L["Time(sec)"])
    timeInput:SetWidth(85)
    timeInput:ClearAllPoints()
    if CTT.db.profile.cttMenuOptions.localStore ~= nil then timeInput:SetText(CTT.db.profile.cttMenuOptions.localStore) end
    timeInput:SetCallback("OnEnterPressed", CTT_AlertTimeOnEnterPressed)
    addAlertGroup:AddChild(timeInput)
    container.timeInput = timeInput

    CreateDropdown(addAlertGroup, {
        label = CTT.L["Raid"],
        list = CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey),
        text = CTT_GetRaidNames(CTT.db.profile.cttMenuOptions.xpacKey)[CTT.db.profile.cttMenuOptions.raidKey],
        value = CTT.db.profile.cttMenuOptions.raidKey,
        width = 225,
        callback = CTT_AlertRaidDropDown,
        name = "raidDropdown"
    })

    CreateDropdown(addAlertGroup, {
        label = CTT.L["Boss"],
        list = CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey),
        text = CTT_GetRaidBossNames(CTT.db.profile.cttMenuOptions.xpacKey, CTT.db.profile.cttMenuOptions.raidKey)[CTT.db.profile.cttMenuOptions.bossDropDownkey],
        value = CTT.db.profile.cttMenuOptions.bossDropDownkey,
        width = 250,
        callback = CTT_AlertBossDropDown,
        name = "bossDropdown"
    })

    CreateButton(addAlertGroup, {
        text = CTT.L["Add"],
        width = 75,
        callback = CTT_AlertAddButtonClicked,
        name = "addAlertButton"
    })

    CreateButton(addAlertGroup, {
        text = CTT.L["Clear All Alerts"],
        width = 140,
        callback = function()
            CTT.db.profile.cttMenuOptions.alerts = {}
            CTT.menu.tree:SelectByValue("alerts")
        end,
        name = "clearAllAlertsButton"
    })

    local listGroup = CTT.AceGUI:Create("InlineGroup")
    listGroup:SetTitle(CTT.L["Active Alerts"])
    listGroup:SetFullWidth(true)
    listGroup:SetLayout("Flow")
    container:AddChild(listGroup)

    local labelWidth = math.max(200, listGroup.frame:GetWidth() - 54)

    for i, v in ipairs(CTT.db.profile.cttMenuOptions.alerts) do
        local label = CTT.AceGUI:Create("Label")
        label:SetText(string.format(CTT.L["Seconds into fight: %s, Raid: %s, Boss: %s"], v[1], v[2], v[3]))
        label:SetColor(255, 255, 0)
        label:SetWidth(labelWidth)
        label:ClearAllPoints()
        listGroup:AddChild(label)

        local deleteBtn = CTT.AceGUI:Create("Icon")
        deleteBtn:SetImage("Interface\\AddOns\\CombatTimeTracker\\Assets\\DeleteIcon")
        deleteBtn:SetImageSize(24, 24)
        deleteBtn:SetWidth(24)
        deleteBtn:SetLabel("")
        deleteBtn:ClearAllPoints()
        deleteBtn:SetCallback("OnClick", function(widget) CTT_AlertDeleteButtonClicked(widget, event, i) end)
        listGroup:AddChild(deleteBtn)
    end
end

local scrollStatusTables = {}

local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    CTT.db.profile.cttMenuOptions.selectedTab = group

    local scroll = CTT.AceGUI:Create("ScrollFrame")
    scroll:SetFullWidth(true)
    scroll:SetFullHeight(true)
    scroll:SetLayout("Flow")
    if not scrollStatusTables[group] then
        scrollStatusTables[group] = {}
    end
    scroll:SetStatusTable(scrollStatusTables[group])
    container:AddChild(scroll)

    if group == "settings" then
        General(scroll)
        Display(scroll)
        Visibility(scroll)
        Sound(scroll)
    elseif group == "profiles" then
        Profiles(scroll)
    elseif group == "dungeons" then
        Dungeons(scroll)
    elseif group == "raids" then
        Raids(scroll)
    elseif group == "alerts" then
        Alerts(scroll)
    end
    scroll:DoLayout()
end

-- Expose SelectGroup so CTT:CreateOptionsMenu() in Core.lua can wire the tree callback
CTT.SelectGroup = SelectGroup
