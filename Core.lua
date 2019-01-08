CTT = LibStub("AceAddon-3.0"):NewAddon("CTT", "AceConsole-3.0", "AceEvent-3.0")

-- grab localization if available
local L = LibStub("AceLocale-3.0"):GetLocale("cttTranslations")

-- extra Ace libs
local AceGUI = LibStub("AceGUI-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

-- local values used throughout the addon
local time = 0
local fontTableOptions = {}
local bossEncounter = false
local hours = "00"
local minutes = "00"
local seconds = "00"
local totalSeconds = "00"
local fontDropDownMorpheus = 0
local cttElapsedSeconds = 0

function CTT:OnEnable()
    self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("ENCOUNTER_START", "Encounter_Start")
    self:RegisterEvent("ENCOUNTER_END", "Encounter_End")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

-- Register slash commands for addon.
function CTT:OnInitialize()
    self:RegisterChatCommand('ctt', 'SlashCommands')
    LSM.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateUsedMedia")
end

function CTT:OnDisable()
    -- Called when the addon is disabled
end

function CTT:UpdateUsedMedia(event, mediatype, key)
    fontTableOptions = LSM:List("font")
    for k,v in pairs(fontTableOptions) do
        if v == "Morpheus" then
            fontDropDownMorpheus = k
            break
        end
    end
end

-- Handle the initialization of values from nil to 0 first time addon is loaded.
function CTT:ADDON_LOADED()
    if GetAddOnMetadata("CombatTimeTracker", "Version") == "2.0.2" and cttMenuOptions == nil then
        CTT_PopUpMessage()
    end
    if longestMin == nil then
        longestMin = 0
    end

    if longestSec == nil then
        longestSec = 0
    end
    if cttMenuOptions == nil then
        cttMenuOptions = {}
        cttMenuOptions.dropdownValue = 1
        cttMenuOptions.lockFrameCheckButton = true
        cttMenuOptions.fontVal = 16
        cttMenuOptions.fontName = "Fonts\\MORPHEUS_CYR.TTF"
        cttMenuOptions.timeTrackerSize = {100,40}
        cttMenuOptions.textFrameSizeSlider = 0
        cttMenuOptions.backDropAlphaSlider = 1
        cttMenuOptions.timeValues = {"00","00","00","00"}
    end
    if cttTextFormatOptions == nil or table.getn(cttTextFormatOptions) > 1 then
        cttTextFormatOptions = {"(SS)", "(MM:SS)", "(HH:MM:SS)"}
    end
    if fightLogs == nil then
        fightLogs = {}
    end
    cttStopwatchGui.elapsed = .125
    cttStopwatchGui:SetScript("OnUpdate", function(self, elapsed)
        cttElapsedSeconds = cttElapsedSeconds + elapsed
        self.elapsed = self.elapsed - elapsed
        if self.elapsed > 0 then return end
        self.elapsed = 0.125
        -- rest of the code here
        if UnitAffectingCombat("player") or bossEncounter then
            --CTT:Print(cttElapsedSeconds)
            --updateStopwatchGui()
            local times = GetTime() - time
            local time = cttElapsedSeconds
            totalSeconds = floor(time)
            hours = floor(time/3600)
            minutes = floor((time-floor(time/3600)*3600)/60)
            seconds = floor(time-floor(time/3600)*3600-floor((time-floor(time/3600)*3600)/60)*60)
            -- mili = floor((time-floor(time/3600)*3600-floor((time-floor(time/3600)*3600)/60)*60-floor(time-floor(time/3600)*3600-floor((time-floor(time/3600)*3600)/60)*60))*100)

            if seconds < 10 then
                --local temp = tostring(seconds)
                seconds = "0" .. seconds
            end
            if minutes < 10 then
                --local temp = tostring(minutes)
                minutes = "0" .. minutes
            end
            if hours < 10 then
                --local temp = tostring(hours)
                hours = "0" .. hours
            end
            if totalSeconds < 10 then
                --local temp = tostring(totalSeconds)
                totalSeconds = "0" .. totalSeconds
            end
            --cttMenuOptions.timeValues = {hours, minutes, seconds, tonumber(string.format("%02.f", math.floor(times)))}
            CTT_UpdateText(hours, minutes, seconds, cttMenuOptions.dropdownValue, 1)
        end
    end)
end

-- display a popup message
function CTT_PopUpMessage()
    StaticPopupDialogs["NEW_VERSION"] = {
        text = "Combat Time Tracker has been updated, the tracker needs to be reset.",
        button1 = "Reset Now",
        button2 = "Reset Later",
        OnAccept = function()
            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show ("NEW_VERSION")
end

-- Hook function into ENCOUNTER_START to handle getting the data stored.
function CTT:Encounter_Start(...)
    bossEncounter = true
    local arg1, arg2, arg3, arg4, arg5 = ...
    CTT:Print(L["Encounter Started!"])
    local members = {}
    local numMembers = GetNumGroupMembers()
    if numMembers > 1 then
        for i=1,GetNumGroupMembers(),1 do
            members[i] = select(1, GetRaidRosterInfo(i))
        end
    else
        members = {UnitName("player")}
    end

    CTT:Print(members[1])
    table.insert(fightLogs, {arg2, arg3, arg4, arg5, members, false})
    time = GetTime()
    cttElapsedSeconds = 0
    cttStopwatchGui:Show()
end

-- Hook function into ENOUNTER_END to handle storing the data after a fight ends.
function CTT:Encounter_End(...)
    bossEncounter = false
    CTT:Print(L["Encounter Ended!"])
    local args = select(6, ...)
    if args == 1 then
        local index = table.getn(fightLogs)
        fightLogs[index][6] = true
        fightLogs[index][7] = totalSeconds
        CTT:Print(L["You have successfully killed "] .. fightLogs[index][2] .. " " .. L["after"] .. " " .. minutes .. ":" .. seconds .. ".")
    else
        local index = table.getn(fightLogs)
        fightLogs[index][7] = totalSeconds
        cttMenuOptions.timeValues = {hours, minutes, seconds, totalSeconds}
        CTT:Print(L["You have wiped on "] .. fightLogs[index][2] .. L["after"] .. " " .. minutes .. ":" .. seconds ..".")
    end
end

-- event function to handle persistence on the settings of the tracker when the player enters the world
function CTT:PLAYER_ENTERING_WORLD()
    --CTT:Print(GetAddOnMetadata("CombatTimeTracker", "Version"))
    if cttMenuOptions.timeTrackerSize then
        CTT_SetTrackerSizeOnLogin()
    end
    if cttMenuOptions.textColorPicker then
        cttStopwatchGuiTimeText:SetTextColor(cttMenuOptions.textColorPicker[1], cttMenuOptions.textColorPicker[2], cttMenuOptions.textColorPicker[3], cttMenuOptions.textColorPicker[4])
    else
        cttStopwatchGuiTimeText:SetTextColor(255,255,255)
    end
    if cttMenuOptions.lockFrameCheckButton then
        cttStopwatchGui:EnableMouse(false)
    else
        cttStopwatchGui:EnableMouse(true)
    end
    if cttMenuOptions.timeValues then
        hours = cttMenuOptions.timeValues[1]
        minutes = cttMenuOptions.timeValues[2]
        seconds = cttMenuOptions.timeValues[3]
        totalSeconds = cttMenuOptions.timeValues[4]
        CTT_UpdateText(cttMenuOptions.timeValues[1], cttMenuOptions.timeValues[2], cttMenuOptions.timeValues[3], cttMenuOptions.dropdownValue,1)
    else
        CTT_UpdateText("00","00","00",1,1)
    end
end

-- Handle the stopwatch when entering combat.
function CTT:PLAYER_REGEN_DISABLED()
    if not bossEncounter then
        time = GetTime()
        cttElapsedSeconds = 0
        cttStopwatchGui:Show()
        self:Print(L["Entering Combat!"])
    else
        return
    end
end

-- Handle the stopwatch when leaving combat.
function CTT:PLAYER_REGEN_ENABLED()
    if not bossEncounter then
        self:Print(L["Leaving Combat!"])
        cttMenuOptions.timeValues = {hours, minutes, seconds, totalSeconds}
        local min = 0
        local sec = 0
        local temp = GetTime() - time
        local tempSec = temp % 60
        if tempSec > 0 then
            sec = tonumber(math.floor(tempSec))
        end
        min = tonumber(string.format("%02.f", math.floor(temp/60)))

        if sec < 10 then
            local temp = tostring(sec)
            sec = "0" .. temp
        end
        if min < 10 then
            local temp = tostring(min)
            min = "0" .. temp
        end
        if tonumber(min) > longestMin then
            longestMin = tonumber(min)
            longestSec = tonumber(sec)
            CTT_DisplayResults(true)
        elseif tonumber(min) == longestMin then
            if tonumber(sec) > longestSec then
                longestMin = tonumber(min)
                longestSec = tonumber(sec)
                CTT_DisplayResults(true)
            else
                CTT_DisplayResults(false)
            end
        else
            CTT_DisplayResults(false)
        end
    else
        return 
    end
end

-- function to display results on ecounter end or regen enabled
function CTT_DisplayResults(newRecord)
    if cttMenuOptions.dropdownValue == 1 then
        if newRecord then 
            CTT:Print(L["New Record! Fight ended in "] .. cttMenuOptions.timeValues[4] .. " " .. L["seconds"] .. "!")
        else
            CTT:Print(L["Fight ended in "] .. cttMenuOptions.timeValues[4] .. " " .. L["seconds"] .. ".")
        end
    elseif cttMenuOptions.dropdownValue == 2 then
        if newRecord then
            CTT:Print(L["New Record! Fight ended in "] .. "(MM:SS): " .. cttMenuOptions.timeValues[2] .. ":" .. cttMenuOptions.timeValues[3] .. "!")
        else
            CTT:Print(L["Fight ended in "] .. "(MM:SS): " .. cttMenuOptions.timeValues[2] .. ":" .. cttMenuOptions.timeValues[3] .. ".")
        end
    else
        if newRecord then
            CTT:Print(L["New Record! Fight ended in "] .. "(HH:MM:SS): " .. cttMenuOptions.timeValues[1] .. ":" .. cttMenuOptions.timeValues[2] .. ":" .. cttMenuOptions.timeValues[3] .. "!")
        else
            CTT:Print(L["Fight ended in "] .. "(HHMM:SS): " .. cttMenuOptions.timeValues[1] .. ":" .. cttMenuOptions.timeValues[2] .. ":" .. cttMenuOptions.timeValues[3] .. ".")
        end
    end
end

-- function to update the text on the tracker frame
function CTT_UpdateText(hours, minutes, seconds, textFormat, fontUpdate)
    if fontUpdate == 2 then
        cttStopwatchGuiTimeText:SetText("")
    end
    if textFormat == 1 then
        if cttMenuOptions.timeValues then
            cttStopwatchGuiTimeText:SetText(totalSeconds)
        else
            cttStopwatchGuiTimeText:SetText(seconds)
        end
    elseif textFormat == 2 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds)
    else
        cttStopwatchGuiTimeText:SetText(hours .. ":" .. minutes .. ":" .. seconds)
    end
end

-- Slash Command function
function CTT:SlashCommands(input)
	input = string.lower(input)
    local command,value,_ = strsplit(" ", input)
    if command == "" then 
        CTT_ToggleMenu()
	elseif command == "help" then
        CTT:Print("======== Combat Time Tracker ========")
        CTT:Print(L["/ctt - to open the options menu!"])
        CTT:Print(L["/ctt show - to show the tracker if hidden!"])
        CTT:Print(L["/ctt hide - to hide the tracker if shown!"])
        CTT:Print("/ctt reset - reset the time on the tracker(done automatically)!")
        CTT:Print("/ctt longest - print longest fight!")
        CTT:Print(L["/ctt lock -  to lock or unlock the window!"])
        CTT:Print("/ctt resetfull - restore addon to default settings.")
        CTT:Print("=================================")
    elseif command == "reset" then
        cttMenuOptions.timeValues = {"00","00","00","00"}
        CTT_UpdateText(cttMenuOptions.timeValues[1], cttMenuOptions.timeValues[2], cttMenuOptions.timeValues[3], cttMenuOptions.dropdownValue,1)
		CTT:Print(L["Stopwatch has been reset!"])
	elseif command == "show" then
        cttStopwatchGui:Show()
		CTT:Print(L["Stopwatch is now being shown!"])
    elseif command == "hide" then
        cttStopwatchGui:Hide()
        CTT:Print(L["Stopwatch is now being hidden!"])
    elseif command == "resetfull" then
        longestMin = 0
        longestSec = 0
        fightLogs = {}
        cttMenuOptions.dropdownValue = 1
        CTT.menu.textStyleDropDown:SetText(cttTextFormatOptions[cttMenuOptions.dropdownValue])
        CTT.menu.textStyleDropDown:SetValue(1)
        cttMenuOptions.timeValues = {"00","00","00","00"}
        cttMenuOptions.lockFrameCheckButton = true
        CTT.menu.lockFrameCheckButton:SetValue(true)
        cttMenuOptions.fontVal = 16
        cttMenuOptions.fontName = "Fonts\\MORPHEUS_CYR.TTF"
        CTT.menu.fontPickerDropDown:SetText("Morpheus")
        cttMenuOptions.timeTrackerSize = {100,40}
        cttMenuOptions.textColorPicker = {1,1,1,1}
        CTT.menu.textColorPicker:SetColor(255,255,255)
        cttMenuOptions.textFrameSizeSlider = 0
        CTT.menu.textFrameSizeSlider:SetValue(0)
        cttMenuOptions.backDropAlphaSlider = 1
        CTT.menu.backDropAlphaSlider:SetValue(1)
        cttMenuOptions.fontPickerDropDown = false
        CTT_SetTrackerSizeOnLogin()
        cttStopwatchGuiTimeText:SetTextColor(255,255,255)
        CTT_UpdateText(cttMenuOptions.timeValues[1], cttMenuOptions.timeValues[2], cttMenuOptions.timeValues[3], cttMenuOptions.dropdownValue,1)
        CTT:Print(L["Combat Time Tracker has been reset to default settings!"])
    elseif command == "longest" then
        CTT:Print("Your longest fight took (MM:SS): "..longestMin..":"..longestSec..".")
    elseif command == "lock" then
        if cttMenuOptions.lockFrameCheckButton then
            cttMenuOptions.lockFrameCheckButton = false
            cttStopwatchGui:EnableMouse(true)
            CTT:Print(L["Tracker has been unlocked!"])
        else
            cttMenuOptions.lockFrameCheckButton = true
            cttStopwatchGui:EnableMouse(false)
            CTT:Print(L["Tracker has been locked!"])
        end
    end
end

-- function to toggle the options menu
function CTT_ToggleMenu()
    if not CTT.menu then CTT:CreateOptionsMenu() end
    if CTT.menu:IsShown() then
        CTT.menu:Hide()
        CTT:Print(L["Options menu hidden, for other commands use /ctt help!"])
    else
        CTT.menu:Show()
        CTT:Print(L["Options menu loaded, for other commands use /ctt help!"])
    end
end

function CTT_LockFrameCheckBoxState(widget, event, value)
    cttMenuOptions.lockFrameCheckButton = value
    if cttMenuOptions.lockFrameCheckButton then
        cttStopwatchGui:EnableMouse(false)
        CTT:Print(L["Tracker has been locked!"])
    else
        cttStopwatchGui:EnableMouse(true)
        CTT:Print(L["Tracker has been unlocked!"])
    end
end

function CTT_ColorPickerConfirmed(widget, event, r, g, b, a)
    cttMenuOptions.textColorPicker = {r,g,b,a}
    cttStopwatchGuiTimeText:SetTextColor(r,g,b,a)
end

function CTT_DropdownState(widget, event, key, checked)
    cttMenuOptions.dropdownValue = key
    CTT_UpdateText(cttMenuOptions.timeValues[1], cttMenuOptions.timeValues[2], cttMenuOptions.timeValues[3], cttMenuOptions.dropdownValue,1)
end

-- function to handle the sliding of the slider, this fires anytime the slider moves
function CTT_ResizeFrameSliderUpdater(widget, event, value)
    cttMenuOptions.textFrameSizeSlider = value
    local multiplier = value
    local width = 100 + (multiplier * 100)
    local height = 40 + (multiplier * 40)
    local fontVal = 16 + (multiplier * 16)
    cttStopwatchGui:SetWidth(width)
    cttStopwatchGui:SetHeight(height)
    cttStopwatchGuiTimeText:SetSize(width, height)
    if cttMenuOptions.fontName then
        cttStopwatchGuiTimeText:SetFont(cttMenuOptions.fontName,fontVal)
        cttMenuOptions.fontVal = fontVal
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf",fontVal)
        cttMenuOptions.fontVal = fontVal
    end
end

-- function to update the tracker size from user settings on login
function CTT_SetTrackerSizeOnLogin()
    if table.getn(cttMenuOptions.timeTrackerSize) == 2 and cttMenuOptions.fontVal and cttMenuOptions.fontName and cttMenuOptions.backDropAlphaSlider then
        cttStopwatchGui:SetWidth(cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(cttMenuOptions.timeTrackerSize[1], cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(cttMenuOptions.fontName,cttMenuOptions.fontVal)
        cttStopwatchGui:SetBackdropColor(0,0,0,cttMenuOptions.backDropAlphaSlider)
        cttStopwatchGui:SetBackdropBorderColor(255,255,255,cttMenuOptions.backDropAlphaSlider)
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf", 16)
        cttMenuOptions.fontVal = fontVal
    end
end

-- SetCallBack function that handles when the person stops sliding the slider
function CTT_ResizeFrameSliderDone(widget, event, value)
    cttMenuOptions.textFrameSizeSlider = value
    cttMenuOptions.timeTrackerSize = {cttStopwatchGui:GetWidth(), cttStopwatchGui:GetHeight()}
end

-- Callback function for the font picker dropdown
function CTT_FontPickerDropDownState(widget, event, key, checked)
    cttMenuOptions.fontPickerDropDown = key
    cttMenuOptions.fontName = LSM:Fetch("font", fontTableOptions[key])
    if table.getn(cttMenuOptions.timeTrackerSize) == 2 and cttMenuOptions.fontVal and cttMenuOptions.fontName then
        cttStopwatchGui:SetWidth(cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(cttMenuOptions.timeTrackerSize[1], cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(cttMenuOptions.fontName,cttMenuOptions.fontVal)
        cttStopwatchGui:Hide()
        cttStopwatchGui:Show()
        CTT_UpdateText(cttMenuOptions.timeValues[1], cttMenuOptions.timeValues[2], cttMenuOptions.timeValues[3], cttMenuOptions.dropdownValue, 2)
    end
end

-- callback for the backdrop opacity slider while moving
function CTT_BackDropSliderOnValueChanged(widget, event, value)
    cttMenuOptions.backDropAlphaSlider = value
    cttStopwatchGui:SetBackdropColor(0,0,0,value)
    cttStopwatchGui:SetBackdropBorderColor(255,255,255,value)
end

-- callback for the backdrop opacity slider when dont moving
function CTT_BackDropSliderDone(widget, event, value)
    cttMenuOptions.backDropAlphaSlider = value
end

-- create options menu
function CTT:CreateOptionsMenu()
    -- main menu frame
    local menu = AceGUI:Create("Frame")
    menu:SetTitle("Combat Time Tracker Options")
    menu:SetStatusText("v"..GetAddOnMetadata("CombatTimeTracker", "Version"))
    menu:SetWidth(250)
    menu:SetHeight(300)
    menu:SetLayout("Flow")
    menu:Hide()
    CTT.menu = menu

    CTT_menu = menu.frame
    menu.frame:SetMaxResize(250, 300)
    menu.frame:SetMinResize(250,300)
    menu.frame:SetFrameStrata("HIGH")
    menu.frame:SetFrameLevel(1)

    -- frame lock button
    local lockFrameCheckButton = AceGUI:Create("CheckBox")
    lockFrameCheckButton:SetLabel(L["Lock"])
    lockFrameCheckButton:SetWidth(80)
    lockFrameCheckButton:SetHeight(22)
    lockFrameCheckButton:SetType("checkbox")
    lockFrameCheckButton:ClearAllPoints()
    if cttMenuOptions.lockFrameCheckButton then lockFrameCheckButton:SetValue(cttMenuOptions.lockFrameCheckButton)end
    lockFrameCheckButton:SetPoint("TOPLEFT", menu.frame, "TOPLEFT",6, 0)
    lockFrameCheckButton:SetCallback("OnValueChanged",CTT_LockFrameCheckBoxState)
    menu:AddChild(lockFrameCheckButton)
    menu.lockFrameCheckButton = lockFrameCheckButton

    -- color picker
    local textColorPicker = AceGUI:Create("ColorPicker")
    if cttMenuOptions.textColorPicker then 
        textColorPicker:SetColor(cttMenuOptions.textColorPicker[1], cttMenuOptions.textColorPicker[2], cttMenuOptions.textColorPicker[3], cttMenuOptions.textColorPicker[4]) 
    else
        textColorPicker:SetColor(255,255,255)
    end
    textColorPicker:SetLabel(L["Text Color"])
    textColorPicker:ClearAllPoints()
    textColorPicker:SetPoint("TOPLEFT", menu.frame, "TOPLEFT", 6, 0)
    textColorPicker:SetCallback("OnValueConfirmed", CTT_ColorPickerConfirmed)
    menu:AddChild(textColorPicker)
    menu.textColorPicker = textColorPicker

    -- different text options
    local textStyleDropDown = AceGUI:Create("Dropdown")
    textStyleDropDown:SetLabel(L["Text Format"])
    textStyleDropDown:SetWidth(125)
    textStyleDropDown:SetMultiselect(false)
    textStyleDropDown:ClearAllPoints()
    textStyleDropDown:SetList(cttTextFormatOptions)
    textStyleDropDown:SetText(cttTextFormatOptions[cttMenuOptions.dropdownValue])
    textStyleDropDown:SetValue(cttMenuOptions.dropdownValue)
    textStyleDropDown:SetPoint("LEFT", menu.frame, "LEFT", 6, 0)
    textStyleDropDown:SetCallback("OnValueChanged", CTT_DropdownState)
    menu:AddChild(textStyleDropDown)
    menu.textStyleDropDown = textStyleDropDown

    -- slider for changing the size of the tracker and text
    local textFrameSizeSlider = AceGUI:Create("Slider")
    textFrameSizeSlider:SetLabel(L["Tracker Size"])
    textFrameSizeSlider:SetWidth(150)
    textFrameSizeSlider:SetIsPercent(true)
    if cttMenuOptions.textFrameSizeSlider then textFrameSizeSlider:SetValue(cttMenuOptions.textFrameSizeSlider) end
    textFrameSizeSlider:SetSliderValues(0,1,.01)
    textFrameSizeSlider:ClearAllPoints()
    textFrameSizeSlider:SetPoint("LEFT", menu.frame, "LEFT", 6, 0)
    textFrameSizeSlider:SetCallback("OnValueChanged", CTT_ResizeFrameSliderUpdater)
    textFrameSizeSlider:SetCallback("OnMouseUp", CTT_ResizeFrameSliderDone)
    menu:AddChild(textFrameSizeSlider)
    menu.textFrameSizeSlider = textFrameSizeSlider

    -- Slider for the opacity of the backdrop and/or border
    local backDropAlphaSlider = AceGUI:Create("Slider")
    backDropAlphaSlider:SetLabel(L["Backdrop Opacity"])
    backDropAlphaSlider:SetWidth(150)
    backDropAlphaSlider:SetIsPercent(true)
    if cttMenuOptions.backDropAlphaSlider then backDropAlphaSlider:SetValue(cttMenuOptions.backDropAlphaSlider) else backDropAlphaSlider:SetValue(1) end
    backDropAlphaSlider:SetSliderValues(0,1,.01)
    backDropAlphaSlider:ClearAllPoints()
    backDropAlphaSlider:SetPoint("LEFT", menu.frame, "LEFT", 6, 0)
    backDropAlphaSlider:SetCallback("OnValueChanged", CTT_BackDropSliderOnValueChanged)
    backDropAlphaSlider:SetCallback("OnMouseUp", CTT_BackDropSliderDone)
    menu:AddChild(backDropAlphaSlider)
    menu.backDropAlphaSlider = backDropAlphaSlider

    -- Dropdown for different font options
    local fontPickerDropDown = AceGUI:Create("Dropdown")
    fontPickerDropDown:SetLabel(L["Choose Font"])
    fontPickerDropDown:SetWidth(250)
    fontPickerDropDown:SetMultiselect(false)
    fontPickerDropDown:ClearAllPoints()
    fontPickerDropDown:SetList(LSM:List("font"))
    if cttMenuOptions.fontName and cttMenuOptions.fontPickerDropDown then 
        fontPickerDropDown:SetText(fontTableOptions[cttMenuOptions.fontPickerDropDown])
        fontPickerDropDown:SetValue(cttMenuOptions.fontPickerDropDown)
    else
        fontPickerDropDown:SetText("Morpheus")
        fontPickerDropDown:SetValue(fontDropDownMorpheus)
    end
    fontPickerDropDown:SetPoint("LEFT", menu.frame, "LEFT", 6, 0)
    fontPickerDropDown:SetCallback("OnValueChanged", CTT_FontPickerDropDownState)
    menu:AddChild(fontPickerDropDown)
    menu.fontPickerDropDown = fontPickerDropDown
end