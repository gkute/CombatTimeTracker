-- Declare AceAddon
CTT = LibStub("AceAddon-3.0"):NewAddon("CTT", "AceConsole-3.0", "AceEvent-3.0")


--|-------------------------|
--| Shared State            |
--|-------------------------|

CTT.isTBC             = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
CTT.isClassic         = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
CTT.isRetail          = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
CTT.zone              = GetRealZoneText()
CTT.profileList       = {}
CTT.newProfileName    = ""
CTT.time              = 0
CTT.fontTableOptions  = {}
CTT.soundTableOptions = {}
CTT.bossEncounter     = false
CTT.bossEncounterName = ""
CTT.lastBossSoundPlayed  = ""
CTT.loadOptionsAfterCombat = false
CTT.hours             = "00"
CTT.minutes           = "00"
CTT.seconds           = "00"
CTT.totalSeconds      = "00"
CTT.miliseconds       = "00"
CTT.fontDropDownMorpheus = 0
CTT.cttElapsedSeconds = 0

local defaults = {
    global = {
        useSharedDefaultProfile = false,
        sharedProfileName = nil,
    },
    profile = {
        minimap = {
            hide = false,
        },
        RaidKills = {},
        DungeonKills = {},
        cttMenuOptions = {
            soundName = "",
            instanceType = 4,
            textFrameSizeSlider = 1,
            timeValues = { "00", "00", "00", "00", "00" },
            raidKey = 1,
            alerts = {},
            difficultyDropDown = 2,
            raidDropdown = "Castle Nathria",
            textColorPicker = { 255, 255, 255, 1 },
            fontVal = 32,
            localStore = "",
            toggleTarget = true,
            fontName = "Fonts\\MORPHEUS_CYR.TTF",
            dropdownValue = 1,
            dropdownValue2 = 1,
            dropdownValue3 = 1,
            soundDropDownValue = 1,
            lockFrameCheckButton = false,
            bossDropdown = "Shriekwing",
            bossDropDownkey = 1,
            backDropAlphaSlider = 1,
            timeTrackerSize = { 200, 80 },
            uiReset = false,
            lastVersion = "test",
            togglePrint = true,
            cttTextFormatOptions = { "(SS)", "(MM:SS)", "(HH:MM:SS)", "(MM:SS.MS)", "(MM:SS:MS)" },
            framePoint = "CENTER",
            frameRelativePoint = "CENTER",
            xOfs = 0,
            yOfs = 0,
            fontFlags = "",
            textFlags = false,
            xpacKey = 1,
            expansion = "Classic",
            resetCounterOnEndOfCombat = true,
            selectedTab = "settings",
            clickThrough = true,
            menuWidth = 750,
            menuHeight = 600,
            dungeonFilterKey = 1,
            dungeonFilterName = "All",
            dungeonExpansionKey = 1,
            dungeonExpansionName = "All",
            dungeonSeasonKey = 1,
            dungeonSeasonName = "All"
        }
    }
}

local backdropSettings = {
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
    tile = true,
    tileSize = 16
}


--|----------------------------|
--| Ace Library Declarations   |
--|----------------------------|

CTT.L      = LibStub("AceLocale-3.0"):GetLocale("cttTranslations")
CTT.AceGUI = LibStub("AceGUI-3.0")
CTT.LSM    = LibStub("LibSharedMedia-3.0")
CTT.icon   = LibStub("LibDBIcon-1.0")

local cttLBD = LibStub("LibDataBroker-1.1"):NewDataObject("CombatTimeTracker", {
    type = "data source",
    text = "Combat Time Tracker",
    icon = "Interface\\AddOns\\CombatTimeTracker\\Assets\\CombatTimeTracker",
    OnClick = function(button, buttonPressed)
        if buttonPressed == "RightButton" then
            if CTT.db.profile.minimap and CTT.db.profile.minimap.lock then
                CTT.icon:Unlock("CombatTimeTracker")
            else
                CTT.icon:Lock("CombatTimeTracker")
            end
        elseif buttonPressed == "MiddleButton" then
            CTT.icon:Hide("CombatTimeTracker")
            CTT.db.profile.minimap.hide = true
            CTT.db.profile.cttMenuOptions.minimapIconCheckButton = true
        else
            CTT_ToggleMenu()
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("|cffff930fCombat Time Tracker|r")
        tooltip:AddLine(CTT.L["Click to open Options Menu"])
        tooltip:AddLine(CTT.L["Middle-Click to hide minimap Button"])
        tooltip:AddLine(CTT.L["Right-click to lock Minimap Button"])
    end,
})


--|----------------------|
--| AceAddon Functions   |
--|----------------------|

function CTT:OnEnable()
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("ENCOUNTER_START", "Encounter_Start")
    self:RegisterEvent("ENCOUNTER_END", "Encounter_End")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("ZONE_CHANGED_INDOORS")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    self:RegisterEvent("CHALLENGE_MODE_START")
    self:RegisterEvent("CHALLENGE_MODE_RESET")
end

-- Register slash commands for addon.
function CTT:OnInitialize()
    self:RegisterChatCommand('ctt', 'SlashCommands')
    CTT.LSM.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateUsedMedia")
    CTT.db = LibStub("AceDB-3.0"):New("cttDB", defaults)
    CTT_ApplyConfiguredProfile()
    CTT.icon:Register("CombatTimeTracker", cttLBD, CTT.db.profile.minimap)
    CTT.icon:RemoveButtonBorder("CombatTimeTracker")
    if not CTT.db.profile.minimap.hide then
        CTT.icon:Show("CombatTimeTracker")
    end

    CTT.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    CTT.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    CTT.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    CTT_CreateStopwatchFrame()
end

-- Handle profile callbacks
function CTT:RefreshConfig()
    CTT_SetTrackerSizeOnLogin()
    CTT_UpdateText(CTT.db.profile.cttMenuOptions.timeValues[1], CTT.db.profile.cttMenuOptions.timeValues[2],
        CTT.db.profile.cttMenuOptions.timeValues[3], CTT.db.profile.cttMenuOptions.timeValues[5],
        CTT.db.profile.cttMenuOptions.dropdownValue, 1)
    CTT_SetActiveProfile(CTT.db:GetCurrentProfile())
end

-- Handle the initialization of values from nil to 0 first time addon is loaded.
function CTT:ADDON_LOADED()
    if longestMin == nil then
        longestMin = 0
    end

    if longestSec == nil then
        longestSec = 0
    end

    if CTT.db.profile.RaidKills == nil then
        CTT.db.profile.RaidKills = {}
    end

    local validTabs = { settings=true, profiles=true, dungeons=true, raids=true, alerts=true }
    -- migrate any old per-section tab values to the combined settings tab
    local legacyTabs = { general=true, display=true, visibility=true, sound=true }
    if legacyTabs[CTT.db.profile.cttMenuOptions.selectedTab] then
        CTT.db.profile.cttMenuOptions.selectedTab = "settings"
    end
    if CTT.db.profile.cttMenuOptions.selectedTab == nil or not validTabs[CTT.db.profile.cttMenuOptions.selectedTab] then
        CTT.db.profile.cttMenuOptions.selectedTab = "settings"
    end

    CTT_CheckForReload()
    if C_AddOns.GetAddOnMetadata("CombatTimeTracker", "Version") >= CTT.db.profile.cttMenuOptions.lastVersion and
        CTT.db.profile.cttMenuOptions.uiReset then
        CTT_PopUpMessage()
    end

    cttStopwatchGui.elapsed = .05
    cttStopwatchGui:SetScript("OnUpdate", function(self, elapsed)
        CTT.cttElapsedSeconds = CTT.cttElapsedSeconds + elapsed
        self.elapsed = self.elapsed - elapsed
        if self.elapsed > 0 then return end
        self.elapsed = 0.05
        if UnitAffectingCombat("player") or CTT.bossEncounter or not CTT.db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
            CTT_CheckForTarget()
            CTT.hours, CTT.minutes, CTT.seconds, CTT.totalSeconds, CTT.miliseconds = CalculateTimeParts(CTT.cttElapsedSeconds)
            CTT_UpdateText(CTT.hours, CTT.minutes, CTT.seconds, CTT.miliseconds, CTT.db.profile.cttMenuOptions.dropdownValue, 1)
            if (CTT.lastBossSoundPlayed ~= CTT.totalSeconds) then
                CTT_CheckToPlaySound()
            end
        end
    end)
end

-- Handle the stopwatch when entering combat.
function CTT:PLAYER_REGEN_DISABLED()
    if CTT.db.profile.cttMenuOptions.instanceType == 5 and (not cttStopwatchGui:IsShown()) then cttStopwatchGui:Show() end
    if not CTT.bossEncounter then
        if CTT.db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
            CTT.time = GetTime()
            CTT.cttElapsedSeconds = 0
        end
        CTT_InstanceTypeDisplay(CTT.db.profile.cttMenuOptions.instanceType)
    else
        return
    end
end

-- Handle the stopwatch when leaving combat.
function CTT:PLAYER_REGEN_ENABLED()
    if CTT.db.profile.cttMenuOptions.instanceType == 5 and cttStopwatchGui:IsShown() then cttStopwatchGui:Hide() end
    if not CTT.bossEncounter then
        if CTT.loadOptionsAfterCombat then
            CTT_ToggleMenu()
            CTT.loadOptionsAfterCombat = false
        end
        CTT.db.profile.cttMenuOptions.timeValues = { CTT.hours, CTT.minutes, CTT.seconds, CTT.totalSeconds, CTT.miliseconds }
        local min = 0
        local sec = 0
        local temp = GetTime() - CTT.time
        local tempSec = temp % 60
        if tempSec > 0 then
            sec = tonumber(math.floor(tempSec))
        end
        min = tonumber(string.format("%02.f", math.floor(temp / 60)))

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

-- Hook function into ENCOUNTER_START to handle getting the data stored.
function CTT:Encounter_Start(...)
    if CTT.db.profile.cttMenuOptions.instanceType == 5 and not cttStopwatchGui:IsShown() then cttStopwatchGui:Show() end
    CTT.bossEncounter = true
    local eventName, encounterID, encounterName, difficultyID, groupSize = ...

    CTT.bossEncounterName = encounterID

    if CTT.db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
        CTT.time = GetTime()
        CTT.cttElapsedSeconds = 0
    end
    CTT_InstanceTypeDisplay(CTT.db.profile.cttMenuOptions.instanceType)
end

-- Hook function into ENCOUNTER_END to handle storing the data after a fight ends.
function CTT:Encounter_End(...)
    if CTT.db.profile.cttMenuOptions.instanceType == 5 and cttStopwatchGui:IsShown() then cttStopwatchGui:Hide() end
    CTT.bossEncounter = false
    CTT.bossEncounterName = ""
    if CTT.loadOptionsAfterCombat then
        CTT.loadOptionsAfterCombat = false
        CTT_ToggleMenu()
    end
    local eventName, encounterID, encounterName, difficultyID, groupSize, success = ...

    local xpacValue = CTT_GetExpansionByEncounterId(encounterID)
    local raidValue = CTT_GetRaidByZoneText()
    local difficultyValue = CTT_GetDifficultyById(difficultyID)

    if success == 1 then
        CTT_StoreBossKills(xpacValue, raidValue, encounterName, groupSize, difficultyValue, true)
        CTT_DisplayResultsBosses(encounterName, true)
    else
        CTT_DisplayResultsBosses(encounterName, false)
        CTT_StoreBossKills(xpacValue, raidValue, encounterName, groupSize, difficultyValue, false)
    end
end

-- event function for knowing when a m+ dungeon ends
function CTT:CHALLENGE_MODE_COMPLETED()
    local info = C_ChallengeMode.GetChallengeCompletionInfo()
    if not info or not info.mapChallengeModeID or not info.level then return end

    local mapID = info.mapChallengeModeID
    local level = info.level
    local runTimeMs = info.time
    local onTime = info.onTime

    local dungeonName = GetRealZoneText() or "Unknown Dungeon"
    local difficultyName = CTT_GetDifficultyById(8) or "Mythic Keystone"

    CTT_StoreDungeonRun(dungeonName, mapID, level, runTimeMs, onTime, difficultyName)

    if CTT.db.profile.cttMenuOptions.togglePrint then
        local timedStr = onTime and "timed" or "depleted"
        CTT:Print(string.format("Completed %s +%d in %s (%s)!", dungeonName, level, CTT_FormatRunTime(runTimeMs), timedStr))
    end
end

-- event function to handle starting m+ dungeon
function CTT:CHALLENGE_MODE_START(mapID)
    if CTT.db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
        CTT.time = GetTime()
    end
end

function CTT:CHALLENGE_MODE_RESET(mapID)

end

-- event function to handle persistence on the settings of the tracker when the player enters the world
function CTT:PLAYER_ENTERING_WORLD()
    CTT_InstanceTypeDisplay(CTT.db.profile.cttMenuOptions.instanceType)
    if CTT.db.profile.cttMenuOptions.timeTrackerSize then
        CTT_SetTrackerSizeOnLogin()
    end
    if CTT.db.profile.cttMenuOptions.lockFrameCheckButton then
        cttStopwatchGui:EnableMouse(false)
    else
        cttStopwatchGui:EnableMouse(true)
    end
    if CTT.db.profile.cttMenuOptions.timeValues then
        CTT.hours      = CTT.db.profile.cttMenuOptions.timeValues[1]
        CTT.minutes    = CTT.db.profile.cttMenuOptions.timeValues[2]
        CTT.seconds    = CTT.db.profile.cttMenuOptions.timeValues[3]
        CTT.totalSeconds = CTT.db.profile.cttMenuOptions.timeValues[4]
        CTT.miliseconds = CTT.db.profile.cttMenuOptions.timeValues[5]
        CTT_UpdateText(CTT.db.profile.cttMenuOptions.timeValues[1], CTT.db.profile.cttMenuOptions.timeValues[2],
            CTT.db.profile.cttMenuOptions.timeValues[3], CTT.db.profile.cttMenuOptions.timeValues[5],
            CTT.db.profile.cttMenuOptions.dropdownValue, 1)
    else
        CTT_UpdateText("00", "00", "00", "00", 1, 1)
    end

    cttStopwatchGui:SetScript("OnDragStart", function(self)
        if not self.isMoving then
            self:StartMoving();
            self.isMoving = true;
        end
    end)

    cttStopwatchGui:SetScript("OnDragStop", function(self)
        if self.isMoving then
            self:StopMovingOrSizing();
            self.isMoving = false;
            local point, relativeTo, relativePoint, xOfs, yOfs = cttStopwatchGui:GetPoint()
            CTT.db.profile.cttMenuOptions.framePoint = point
            CTT.db.profile.cttMenuOptions.frameRelativePoint = relativePoint
            CTT.db.profile.cttMenuOptions.xOfs = xOfs
            CTT.db.profile.cttMenuOptions.yOfs = yOfs
        end
    end)
end

function CTT:ZONE_CHANGED()
    --@debug@
    ---self:Print("Zone_Changed: " .. GetRealZoneText())
    --self:Print("Zone_Changed: " .. GetSubZoneText())
    --@end-debug@
end

function CTT:ZONE_CHANGED_INDOORS()
    --@debug@
    --self:Print("Zone_Changed_Indoors: " .. GetRealZoneText())
    --self:Print("Zone_Changed_Indoors: " .. GetSubZoneText())
    --@end-debug@
end

function CTT:ZONE_CHANGED_NEW_AREA()
    --@debug@
    --self:Print("Zone_Changed_New_Area: " .. GetRealZoneText())
    --self:Print("Zone_Changed_New_Area: " .. GetSubZoneText())
    --@end-debug@

    CTT.zone = GetRealZoneText()
    CTT_InstanceTypeDisplay(CTT.db.profile.cttMenuOptions.instanceType)
end

-- Handle Player Target Swaps
function CTT:PLAYER_TARGET_CHANGED()
    CTT_CheckForTarget()
end

-- function to get the position of morpheus font
function CTT:UpdateUsedMedia(event, mediatype, key)
    CTT.fontTableOptions = CTT.LSM:List("font")
    for k, v in pairs(CTT.fontTableOptions) do
        if v == "Morpheus" then
            CTT.fontDropDownMorpheus = k
            break
        end
    end

    CTT.soundTableOptions = CTT.LSM:List("sound")
end

-- Slash Command function
function CTT:SlashCommands(input)
    input = string.lower(input)
    local command, value, _ = strsplit(" ", input)
    if command == "" then
        CTT_ToggleMenu()
    elseif command == "help" then
        CTT:Print("======== Combat Time Tracker ========")
        CTT:Print(CTT.L["/ctt - to open the options menu!"])
        CTT:Print(CTT.L["/ctt show - to show the tracker if hidden!"])
        CTT:Print(CTT.L["/ctt hide - to hide the tracker if shown!"])
        CTT:Print(CTT.L["/ctt reset - reset the time on the tracker(done automatically)!"])
        CTT:Print(CTT.L["/ctt longest - print longest fight!"])
        CTT:Print(CTT.L["/ctt lock -  to lock or unlock the window!"])
        CTT:Print(CTT.L["/ctt resetfull - restore addon to default settings."])
        CTT:Print("=================================")
    elseif command == "reset" then
        CTT.db.profile.cttMenuOptions.timeValues = { "00", "00", "00", "00" }
        activeProfile = nil
        activeProfileKey = nil
        CTT_UpdateText(CTT.db.profile.cttMenuOptions.timeValues[1], CTT.db.profile.cttMenuOptions.timeValues[2],
            CTT.db.profile.cttMenuOptions.timeValues[3], CTT.db.profile.cttMenuOptions.timeValues[5],
            CTT.db.profile.cttMenuOptions.dropdownValue, 1)
        CTT:Print(CTT.L["Stopwatch has been reset!"])
    elseif command == "show" then
        cttStopwatchGui:Show()
        CTT:Print(CTT.L["Stopwatch is now being shown!"])
    elseif command == "hide" then
        cttStopwatchGui:Hide()
        CTT:Print(CTT.L["Stopwatch is now being hidden!"])
    elseif command == "resetfull" then
        longestMin = 0
        longestSec = 0
        CTT.db.profile.cttMenuOptions.alerts = {}
        CTT.db:ResetDB(Default)
        activeProfile = nil
        activeProfileKey = nil
        CTT:Print(CTT.L["Combat Time Tracker has been reset to default settings!"])
    elseif command == "longest" then
        CTT:Print(CTT.L["Your longest fight took (MM:SS): "] .. longestMin .. ":" .. longestSec .. ".")
    elseif command == "lock" then
        if CTT.db.profile.cttMenuOptions.lockFrameCheckButton then
            CTT.db.profile.cttMenuOptions.lockFrameCheckButton = false
            cttStopwatchGui:EnableMouse(true)
            CTT:Print(CTT.L["Tracker has been unlocked!"])
        else
            CTT.db.profile.cttMenuOptions.lockFrameCheckButton = true
            cttStopwatchGui:EnableMouse(false)
            CTT:Print(CTT.L["Tracker has been locked!"])
        end
        --@debug@
    elseif command == "debug" then
        CallSimulateBossKill()
    elseif command == "resetbosskills" then
        CTT.db.profile.RaidKills = nil
        --@end-debug@
    end
end

--|--------------------------|
--| Frame & UI Bootstrapping |
--|--------------------------|

function CTT_CreateStopwatchFrame()
    local f = CreateFrame("Frame", "cttStopwatchGui", UIParent, "BackdropTemplate")
    f:SetSize(100, 40)
    f:SetPoint("RIGHT")
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:Show()

    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(f)

    f:SetBackdrop(backdropSettings)
    f:SetBackdropBorderColor(LEGENDARY_ORANGE_COLOR.r, LEGENDARY_ORANGE_COLOR.g, LEGENDARY_ORANGE_COLOR.b, 0.25)

    local targetText = f:CreateFontString("cttStopwatchGuiTargetText", "OVERLAY", "GameFontNormalLarge")
    targetText:SetSize(100, 25)
    targetText:SetPoint("TOP")
    targetText:SetTextColor(1, 1, 1)
    targetText:SetText("")

    local timeText = f:CreateFontString("cttStopwatchGuiTimeText", "OVERLAY", "GameFontNormalLarge")
    timeText:SetSize(100, 25)
    timeText:SetPoint("CENTER")
    timeText:SetTextColor(1, 1, 1)
    timeText:SetText("00:00:00")

    local targetIcon = f:CreateTexture("cttStopwatchGuiTargetIcon", "OVERLAY")
    targetIcon:SetSize(7.5, 7.5)
    targetIcon:SetPoint("LEFT", targetText, "LEFT", -10, 0)

    local targetIcon2 = f:CreateTexture("cttStopwatchGuiTargetIcon2", "OVERLAY")
    targetIcon2:SetSize(7.5, 7.5)
    targetIcon2:SetPoint("RIGHT", targetText, "RIGHT", 10, 0)
end

-- function to update the tracker size from user settings on login
function CTT_SetTrackerSizeOnLogin()
    if #CTT.db.profile.cttMenuOptions.timeTrackerSize == 2 and CTT.db.profile.cttMenuOptions.fontVal and
        CTT.db.profile.cttMenuOptions.fontName and CTT.db.profile.cttMenuOptions.backDropAlphaSlider then
        cttStopwatchGui:SetWidth(CTT.db.profile.cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(CTT.db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(CTT.db.profile.cttMenuOptions.timeTrackerSize[1],
            CTT.db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(CTT.db.profile.cttMenuOptions.fontName, CTT.db.profile.cttMenuOptions.fontVal,
            CTT.db.profile.cttMenuOptions.fontFlags)
        cttStopwatchGui:SetBackdrop(backdropSettings)
        cttStopwatchGui:SetBackdropColor(0, 0, 0, CTT.db.profile.cttMenuOptions.backDropAlphaSlider)
        cttStopwatchGui:SetBackdropBorderColor(255, 255, 255, CTT.db.profile.cttMenuOptions.backDropAlphaSlider)
        cttStopwatchGuiTimeText:SetTextColor(CTT.db.profile.cttMenuOptions.textColorPicker[1],
            CTT.db.profile.cttMenuOptions.textColorPicker[2], CTT.db.profile.cttMenuOptions.textColorPicker[3],
            CTT.db.profile.cttMenuOptions.textColorPicker[4])
        cttStopwatchGui:ClearAllPoints()
        cttStopwatchGui:SetPoint(CTT.db.profile.cttMenuOptions.framePoint, nil, CTT.db.profile.cttMenuOptions.frameRelativePoint
        , CTT.db.profile.cttMenuOptions.xOfs, CTT.db.profile.cttMenuOptions.yOfs)
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf", 16, CTT.db.profile.cttMenuOptions.fontFlags)
        CTT.db.profile.cttMenuOptions.fontVal = fontVal
    end
end

--|------------------------|
--| Options Menu           |
--|------------------------|

function CTT:CreateOptionsMenu()
    local menu = CTT.AceGUI:Create("Frame")
    menu:SetTitle(CTT.L["Combat Time Tracker Options"])
    menu:SetStatusText(C_AddOns.GetAddOnMetadata("CombatTimeTracker", "Version"))
    menu:SetWidth(CTT.db.profile.cttMenuOptions.menuWidth or 750)
    menu:SetHeight(CTT.db.profile.cttMenuOptions.menuHeight or 600)
    menu:SetLayout("Fill")
    menu:Hide()
    CTT.menu = menu

    menu.frame:SetResizeBounds(375, 300, 1125, 900)
    menu.frame:SetFrameStrata("HIGH")
    menu.frame:SetFrameLevel(1)

    menu.frame:SetScript("OnSizeChanged", function(self, width, height)
        CTT.db.profile.cttMenuOptions.menuWidth = math.floor(width)
        CTT.db.profile.cttMenuOptions.menuHeight = math.floor(height)
    end)

    local tree = CTT.AceGUI:Create("TreeGroup")
    tree:SetFullWidth(true)
    tree:SetFullHeight(true)
    tree:SetLayout("Flow")
    tree:SetTree({
        { value = "settings",  text = CTT.L["Settings"] },
        { value = "profiles",  text = CTT.L["Profiles"] },
        { value = "dungeons",  text = CTT.L["Dungeons"] },
        { value = "raids",     text = CTT.L["Raids"] },
        { value = "alerts",    text = CTT.L["Alert Times"] },
    })
    tree:SetCallback("OnGroupSelected", CTT.SelectGroup)
    tree:SelectByValue("settings")
    menu:AddChild(tree)
    menu.tree = tree

    _G["CombatTimeTrackerMenu"] = menu.frame
    tinsert(UISpecialFrames, "CombatTimeTrackerMenu")
end
