-- Declare AceAddon
CTT = LibStub("AceAddon-3.0"):NewAddon("CTT", "AceConsole-3.0", "AceEvent-3.0")


--|-------------------------|
--| Variable Declarations   |
--|-------------------------|

local isTBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
local isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
local isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
local zone = GetRealZoneText()
local profileList = {}
local newProfileName = ""
local time = 0
local fontTableOptions = {}
local soundTableOptions = {}
local bossEncounter = false
local bossEncounterName = ""
local lastBossSoundPlayed = ""
local loadOptionsAfterCombat = false
local hours = "00"
local minutes = "00"
local seconds = "00"
local totalSeconds = "00"
local miliseconds = "00"
local fontDropDownMorpheus = 0
local cttElapsedSeconds = 0
local globalMenu
local db
local CTT_GetCharacterProfileName
local CTT_ProfileExists
local CTT_GetSharedProfileName
local CTT_SetActiveProfile
local CTT_GetProfileKey
local CTT_ApplyConfiguredProfile

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

local instanceTypes = {
    "Dungeons Only",
    "Raids Only",
    "Dungons and Raids Only",
    "Everywhere",
    "Combat Only"
}

local backdropSettings = {
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
    tile = true,
    tileSize = 16
}

local NonHearthstones = {
    "Autographed Hearthstone Card",
    "Hearthstone Board"
}


--|----------------------------|
--| Ace Library Declarations   |
--|----------------------------|

local L = LibStub("AceLocale-3.0"):GetLocale("cttTranslations")
local AceGUI = LibStub("AceGUI-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local icon = LibStub("LibDBIcon-1.0")
local cttLBD = LibStub("LibDataBroker-1.1"):NewDataObject("CombatTimeTracker", {
    type = "data source",
    text = "Combat Time Tracker",
    icon = "Interface\\AddOns\\CombatTimeTracker\\Assets\\CombatTimeTracker",
    OnClick = function(button, buttonPressed)
        if buttonPressed == "RightButton" then
            if db.profile.minimap and db.profile.minimap.lock then
                icon:Unlock("CombatTimeTracker")
            else
                icon:Lock("CombatTimeTracker")
            end
        elseif buttonPressed == "MiddleButton" then
            icon:Hide("CombatTimeTracker")
            db.profile.minimap.hide = true
            db.profile.cttMenuOptions.minimapIconCheckButton = true
        else
            CTT_ToggleMenu()
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("|cffff930fCombat Time Tracker|r")
        tooltip:AddLine(L["Click to open Options Menu"])
        tooltip:AddLine(L["Middle-Click to hide minimap Button"])
        tooltip:AddLine(L["Right-click to lock Minimap Button"])
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
    LSM.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateUsedMedia")
    db = LibStub("AceDB-3.0"):New("cttDB", defaults)
    CTT_ApplyConfiguredProfile()
    icon:Register("CombatTimeTracker", cttLBD, db.profile.minimap)
    icon:RemoveButtonBorder("CombatTimeTracker")
    if not db.profile.minimap.hide then
        icon:Show("CombatTimeTracker")
    end

    db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    CTT_CreateStopwatchFrame()
end

-- Handle profile callbacks
function CTT:RefreshConfig()
    CTT_SetTrackerSizeOnLogin()
    CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2],
        db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5],
        db.profile.cttMenuOptions.dropdownValue, 1)
    CTT_SetActiveProfile(db:GetCurrentProfile())
end

-- Handle the initialization of values from nil to 0 first time addon is loaded.
function CTT:ADDON_LOADED()
    if longestMin == nil then
        longestMin = 0
    end

    if longestSec == nil then
        longestSec = 0
    end

    if db.profile.RaidKills == nil then
        db.profile.RaidKills = {}
    end

    local validTabs = { settings=true, profiles=true, dungeons=true, raids=true, alerts=true }
    -- migrate any old per-section tab values to the combined settings tab
    local legacyTabs = { general=true, display=true, visibility=true, sound=true }
    if legacyTabs[db.profile.cttMenuOptions.selectedTab] then
        db.profile.cttMenuOptions.selectedTab = "settings"
    end
    if db.profile.cttMenuOptions.selectedTab == nil or not validTabs[db.profile.cttMenuOptions.selectedTab] then
        db.profile.cttMenuOptions.selectedTab = "settings"
    end

    CTT_CheckForReload()
    if C_AddOns.GetAddOnMetadata("CombatTimeTracker", "Version") >= db.profile.cttMenuOptions.lastVersion and
        db.profile.cttMenuOptions.uiReset then
        CTT_PopUpMessage()
    end

    cttStopwatchGui.elapsed = .05
    cttStopwatchGui:SetScript("OnUpdate", function(self, elapsed)
        cttElapsedSeconds = cttElapsedSeconds + elapsed
        self.elapsed = self.elapsed - elapsed
        if self.elapsed > 0 then return end
        self.elapsed = 0.05
        if UnitAffectingCombat("player") or bossEncounter or not db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
            CTT_CheckForTarget()
            hours, minutes, seconds, totalSeconds, miliseconds = CalculateTimeParts(cttElapsedSeconds)
            CTT_UpdateText(hours, minutes, seconds, miliseconds, db.profile.cttMenuOptions.dropdownValue, 1)
            if (lastBossSoundPlayed ~= totalSeconds) then
                CTT_CheckToPlaySound()
            end
        end
    end)
end

-- Handle the stopwatch when entering combat.
function CTT:PLAYER_REGEN_DISABLED()
    if db.profile.cttMenuOptions.instanceType == 5 and (not cttStopwatchGui:IsShown()) then cttStopwatchGui:Show() end
    if not bossEncounter then
        if db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
            time = GetTime()
            cttElapsedSeconds = 0
        end
        CTT_InstanceTypeDisplay(db.profile.cttMenuOptions.instanceType)
    else
        return
    end
end

-- Handle the stopwatch when leaving combat.
function CTT:PLAYER_REGEN_ENABLED()
    if db.profile.cttMenuOptions.instanceType == 5 and cttStopwatchGui:IsShown() then cttStopwatchGui:Hide() end
    if not bossEncounter then
        if loadOptionsAfterCombat then
            CTT_ToggleMenu()
            loadOptionsAfterCombat = false
        end
        db.profile.cttMenuOptions.timeValues = { hours, minutes, seconds, totalSeconds, miliseconds }
        local min = 0
        local sec = 0
        local temp = GetTime() - time
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
    if db.profile.cttMenuOptions.instanceType == 5 and not cttStopwatchGui:IsShown() then cttStopwatchGui:Show() end
    bossEncounter = true
    local eventName, encounterID, encounterName, difficultyID, groupSize = ...

    bossEncounterName = encounterID

    if db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
        time = GetTime()
        cttElapsedSeconds = 0
    end
    CTT_InstanceTypeDisplay(db.profile.cttMenuOptions.instanceType)
end

-- Hook function into ENOUNTER_END to handle storing the data after a fight ends.
function CTT:Encounter_End(...)
    if db.profile.cttMenuOptions.instanceType == 5 and cttStopwatchGui:IsShown() then cttStopwatchGui:Hide() end
    bossEncounter = false
    bossEncounterName = ""
    if loadOptionsAfterCombat then
        loadOptionsAfterCombat = false
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

    if db.profile.cttMenuOptions.togglePrint then
        local timedStr = onTime and "timed" or "depleted"
        CTT:Print(string.format("Completed %s +%d in %s (%s)!", dungeonName, level, CTT_FormatRunTime(runTimeMs), timedStr))
    end
end

-- event function to handle starting m+ dungeon
function CTT:CHALLENGE_MODE_START(mapID)
    if db.profile.cttMenuOptions.resetCounterOnEndOfCombat then
        time = GetTime()
    end
end

function CTT:CHALLENGE_MODE_RESET(mapID)

end

-- event function to handle persistence on the settings of the tracker when the player enters the world
function CTT:PLAYER_ENTERING_WORLD()
    CTT_InstanceTypeDisplay(db.profile.cttMenuOptions.instanceType)
    if db.profile.cttMenuOptions.timeTrackerSize then
        CTT_SetTrackerSizeOnLogin()
    end
    if db.profile.cttMenuOptions.lockFrameCheckButton then
        cttStopwatchGui:EnableMouse(false)
    else
        cttStopwatchGui:EnableMouse(true)
    end
    if db.profile.cttMenuOptions.timeValues then
        hours = db.profile.cttMenuOptions.timeValues[1]
        minutes = db.profile.cttMenuOptions.timeValues[2]
        seconds = db.profile.cttMenuOptions.timeValues[3]
        totalSeconds = db.profile.cttMenuOptions.timeValues[4]
        miliseconds = db.profile.cttMenuOptions.timeValues[5]
        CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2],
            db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5],
            db.profile.cttMenuOptions.dropdownValue, 1)
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
            -- print(cttStopwatchGui:GetPoint(1))
            local point, relativeTo, relativePoint, xOfs, yOfs = cttStopwatchGui:GetPoint()
            db.profile.cttMenuOptions.framePoint = point
            db.profile.cttMenuOptions.frameRelativePoint = relativePoint
            db.profile.cttMenuOptions.xOfs = xOfs
            db.profile.cttMenuOptions.yOfs = yOfs
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

    zone = GetRealZoneText()
    CTT_InstanceTypeDisplay(db.profile.cttMenuOptions.instanceType)
end

-- Handle Player Target Swaps
function CTT:PLAYER_TARGET_CHANGED()
    CTT_CheckForTarget()
end

-- function to get the position of morpheus font
function CTT:UpdateUsedMedia(event, mediatype, key)
    fontTableOptions = LSM:List("font")
    for k, v in pairs(fontTableOptions) do
        if v == "Morpheus" then
            fontDropDownMorpheus = k
            break
        end
    end

    soundTableOptions = LSM:List("sound")
end

-- Slash Command function
function CTT:SlashCommands(input)
    input = string.lower(input)
    local command, value, _ = strsplit(" ", input)
    if command == "" then
        CTT_ToggleMenu()
    elseif command == "help" then
        CTT:Print("======== Combat Time Tracker ========")
        CTT:Print(L["/ctt - to open the options menu!"])
        CTT:Print(L["/ctt show - to show the tracker if hidden!"])
        CTT:Print(L["/ctt hide - to hide the tracker if shown!"])
        CTT:Print(L["/ctt reset - reset the time on the tracker(done automatically)!"])
        CTT:Print(L["/ctt longest - print longest fight!"])
        CTT:Print(L["/ctt lock -  to lock or unlock the window!"])
        CTT:Print(L["/ctt resetfull - restore addon to default settings."])
        CTT:Print("=================================")
    elseif command == "reset" then
        db.profile.cttMenuOptions.timeValues = { "00", "00", "00", "00" }
        activeProfile = nil
        activeProfileKey = nil
        CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2],
            db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5],
            db.profile.cttMenuOptions.dropdownValue, 1)
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
        db.profile.cttMenuOptions.alerts = {}
        db:ResetDB(Default)
        activeProfile = nil
        activeProfileKey = nil
        CTT:Print(L["Combat Time Tracker has been reset to default settings!"])
    elseif command == "longest" then
        CTT:Print(L["Your longest fight took (MM:SS): "] .. longestMin .. ":" .. longestSec .. ".")
    elseif command == "lock" then
        if db.profile.cttMenuOptions.lockFrameCheckButton then
            db.profile.cttMenuOptions.lockFrameCheckButton = false
            cttStopwatchGui:EnableMouse(true)
            CTT:Print(L["Tracker has been unlocked!"])
        else
            db.profile.cttMenuOptions.lockFrameCheckButton = true
            cttStopwatchGui:EnableMouse(false)
            CTT:Print(L["Tracker has been locked!"])
        end
        --@debug@
    elseif command == "debug" then
        CallSimulateBossKill()
    elseif command == "resetbosskills" then
        db.profile.RaidKills = nil
        --@end-debug@
    end
end

--|--------------------------|
--| Non AceAddon functions --|
--|--------------------------|

-- Helper to calculate time parts from elapsed seconds
function CalculateTimeParts(elapsed)
    local total = math.floor(elapsed)
    local h = math.floor(total / 3600)
    local m = math.floor((total % 3600) / 60)
    local s = total % 60
    local ms = math.floor((elapsed - total) * 100)
    return string.format("%02d", h), string.format("%02d", m), string.format("%02d", s), tostring(total), string.format("%02d", ms)
end

-- function to check if a ui reset is needed.
function CTT_CheckForReload()
    if db.profile.cttMenuOptions.lastVersion == nil then
        db.profile.cttMenuOptions.uiReset = true
        db.profile.cttMenuOptions.lastVersion = C_AddOns.GetAddOnMetadata("CombatTimeTracker", "Version")
    else
        db.profile.cttMenuOptions.uiReset = false
    end
end

function CTT_TableContainsValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function IsInt(n)
    return (type(tonumber(n)) == "number" and (math.floor((tonumber(n))) == tonumber(n)))
end

-- Function To check for players current target
function CTT_CheckForTarget()
    if not db.profile.cttMenuOptions.toggleTarget then return end
    local target = GetUnitName("Target", false)
    if target ~= nil then
        cttStopwatchGuiTargetText:SetText(target)
        cttStopwatchGuiTargetText:Show()
    else
        cttStopwatchGuiTargetText:Hide()
    end
end

function CTT_CheckToPlaySound()
    if not bossEncounter then return end
    for k, v in pairs(db.profile.cttMenuOptions.alerts) do
        if k ~= "scrollvalue" and k ~= "offset" and
            db.profile.cttMenuOptions.alerts[k][4] == bossEncounterName and
            tonumber(totalSeconds) == db.profile.cttMenuOptions.alerts[k][1] then
            lastBossSoundPlayed = totalSeconds
            PlaySoundFile(LSM:Fetch("sound", soundTableOptions[db.profile.cttMenuOptions.soundDropDownValue]), "Master")
        end
    end
end

-- function to handle showing the tracker based on instance type settings
function CTT_InstanceTypeDisplay(key)
    local zone = GetRealZoneText()
    local subZone = GetSubZoneText()

    if key == 1 then
        -- Handle dungeons
        local dungeonZones = CTT_GetAllDungeonZoneNames()
        for _, v in ipairs(dungeonZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then cttStopwatchGui:Show() end
                return
            end
        end
        cttStopwatchGui:Hide()
    elseif key == 2 then
        -- Handle raids
        local raidZones = CTT_GetAllRaidZoneNames()
        for _, v in ipairs(raidZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then cttStopwatchGui:Show() end
                return
            end
        end
        cttStopwatchGui:Hide()
    elseif key == 3 then
        -- Handle both dungeons and raids
        local dungeonZones = CTT_GetAllDungeonZoneNames()
        for _, v in ipairs(dungeonZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then cttStopwatchGui:Show() end
                return
            end
        end
        local raidZones = CTT_GetAllRaidZoneNames()
        for _, v in ipairs(raidZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then cttStopwatchGui:Show() end
                return
            end
        end
        cttStopwatchGui:Hide()
    elseif key == 5 then
        if not (UnitAffectingCombat("player") or bossEncounter) and cttStopwatchGui:IsShown() then cttStopwatchGui:Hide() end
    else
        -- always show
        if not cttStopwatchGui:IsShown() then
            cttStopwatchGui:Show()
        end
        return
    end
end

-- display a popup message
function CTT_PopUpMessage()
    StaticPopupDialogs["NEW_VERSION"] = {
        text = L["Combat Time Tracker has been updated, the tracker needs to be reset to work properly!"],
        button1 = L["Reset Now"],
        button2 = L["Reset Later"],
        OnAccept = function()
            db.profile.cttMenuOptions.uiReset = false
            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("NEW_VERSION")
end

-- function to display results on ecounter end or regen enabled
function CTT_DisplayResults(newRecord)
    if not db.profile.cttMenuOptions.togglePrint then return end
    local t = db.profile.cttMenuOptions.timeValues or {"00", "00", "00", "00", "00"}
    local h = tostring(t[1] or "00")
    local m = tostring(t[2] or "00")
    local s = tostring(t[3] or "00")
    local ts = tostring(t[4] or "00")
    local ms = tostring(t[5] or "00")
    if db.profile.cttMenuOptions.dropdownValue == 1 then
        if newRecord then
            CTT:Print(L["New Record! Fight ended in "] .. ts .. "." .. ms .. " " .. L["seconds"] .. "!")
        else
            CTT:Print(L["Fight ended in "] .. ts .. "." .. ms .. " " .. L["seconds"] .. ".")
        end
    elseif db.profile.cttMenuOptions.dropdownValue == 2 then
        if newRecord then
            CTT:Print(L["New Record! Fight ended in "] .. "(MM:SS.MS): " .. m .. ":" .. s .. "." .. ms .. "!")
        else
            CTT:Print(L["Fight ended in "] .. "(MM:SS.MS): " .. m .. ":" .. s .. "." .. ms .. ".")
        end
    else
        if newRecord then
            CTT:Print(L["New Record! Fight ended in "] .. "(HH:MM:SS.MS): " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. "!")
        else
            CTT:Print(L["Fight ended in "] .. "(HH:MM:SS.MS): " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. ".")
        end
    end
end

-- Get Bossname
function CTT_GetDifficultyById(id)
    local name, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID, isLFR, minPlayers, maxPlayers = GetDifficultyInfo(id)
    return name
end

-- Format milliseconds into MM:SS string
function CTT_FormatRunTime(ms)
    local totalSec = math.floor(ms / 1000)
    local minutes = math.floor(totalSec / 60)
    local seconds = totalSec % 60
    return string.format("%02d:%02d", minutes, seconds)
end

-- Store a completed M+ dungeon run
function CTT_StoreDungeonRun(dungeonName, mapID, keyLevel, runTimeMs, onTime, difficulty)
    local seasonID = (isRetail and C_MythicPlus and C_MythicPlus.GetCurrentSeason()) or 0
    local data = {
        Dungeon           = dungeonName,
        MapID             = mapID,
        KeyLevel          = keyLevel,
        RunTime           = CTT_FormatRunTime(runTimeMs),
        RunTimeMs         = runTimeMs,
        OnTime            = onTime,
        Difficulty        = difficulty,
        SeasonID          = seasonID,
        LocalCompletionTime = date("%m/%d/%Y %I:%M%p")
    }
    if db.profile.DungeonKills == nil then
        db.profile.DungeonKills = {}
    end
    tinsert(db.profile.DungeonKills, data)
end

-- Store boss kills after a kill
function CTT_StoreBossKills(expansion, raidInstance, bossName, groupSize, difficulty, success)
    if expansion == nil or raidInstance == nil or bossName == nil or groupSize == nil or difficulty == nil or success == nil then return end
    local data = {
        Expansion = expansion,
        RaidInstance = raidInstance,
        BossName = bossName,
        KillTime = cttStopwatchGuiTimeText:GetText(),
        Success = success,
        Difficulty = difficulty,
        GroupSize = groupSize,
        LocalKillTime = date("%m/%d/%Y %I:%M%p")
    }

    local key = 0

    if db.profile.RaidKills ~= nil then
        key = #db.profile.RaidKills + 1
        db.profile.RaidKills[key] = data
    else
        db.profile.RaidKills = {}
        db.profile.RaidKills[1] = data
    end
end

-- function to fix display results on a boss encounter ending
function CTT_DisplayResultsBosses(bossEncounter, wasAKill)
    if not db.profile.cttMenuOptions.togglePrint then return end
    local ms = tostring(miliseconds or "00")
    local s = tostring(seconds or "00")
    local m = tostring(minutes or "00")
    local h = tostring(hours or "00")
    local ts = tostring(totalSeconds or "00")
    if db.profile.cttMenuOptions.dropdownValue == 1 then
        if wasAKill then
            CTT:Print(L["You have successfully killed "] .. bossEncounter .. " " .. L["after"] .. " " .. ts .. "." .. ms .. " " .. L["seconds"] .. "!")
        else
            CTT:Print(L["You have wiped on "] .. bossEncounter .. L["after"] .. " " .. ts .. "." .. ms .. ".")
        end
    elseif db.profile.cttMenuOptions.dropdownValue == 2 then
        if wasAKill then
            CTT:Print(L["You have successfully killed "] .. bossEncounter .. " " .. L["after"] .. " " .. m .. ":" .. s .. "." .. ms .. "!")
        else
            CTT:Print(L["You have wiped on "] .. bossEncounter .. " " .. L["after"] .. " " .. m .. ":" .. s .. "." .. ms .. ".")
        end
    else
        if wasAKill then
            CTT:Print(L["You have successfully killed "] .. bossEncounter .. " " .. L["after"] .. " " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. ".")
        else
            CTT:Print(L["You have wiped on "] .. bossEncounter .. " " .. L["after"] .. " " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. ".")
        end
    end
end

-- function to update the text on the tracker frame
function CTT_UpdateText(hours, minutes, seconds, miliseconds, textFormat, fontUpdate)
    if fontUpdate == 2 then
        cttStopwatchGuiTimeText:SetText("")
    end
    if textFormat == 1 then
        if db.profile.cttMenuOptions.timeValues then
            cttStopwatchGuiTimeText:SetText(totalSeconds) -- .. "." .. miliseconds)
        else
            cttStopwatchGuiTimeText:SetText(seconds)      -- .. "." .. miliseconds)
        end
    elseif textFormat == 2 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds) -- .. "." .. miliseconds)
    elseif textFormat == 4 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds .. "." .. miliseconds)
    elseif textFormat == 5 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds .. ":" .. miliseconds)
    else
        cttStopwatchGuiTimeText:SetText(hours .. ":" .. minutes .. ":" .. seconds) -- .. "." .. miliseconds)
    end
end

function CTT_UpdateMenuTexts(container, difficultyNumber)
    if difficultyNumber == 1 then
        difficultyNumber = 0
    elseif difficultyNumber == 2 then
        difficultyNumber = 9
    elseif difficultyNumber == 3 then
        difficultyNumber = 18
    else
        difficultyNumber = 27
    end
end

function CTT_CoSUpdateMenuTexts(container, difficultyNumber)
    if difficultyNumber == 1 then
        difficultyNumber = 0
    elseif difficultyNumber == 2 then
        difficultyNumber = 2
    elseif difficultyNumber == 3 then
        difficultyNumber = 4
    else
        difficultyNumber = 6
    end

    container.CabalTime:SetText(cosFightLogs[1 + difficultyNumber])
    container.UunatTime:SetText(cosFightLogs[2 + difficultyNumber])
end

function CTT_tepUpdateMenuTexts(container, difficultyNumber)
    if difficultyNumber == 1 then
        difficultyNumber = 0
    elseif difficultyNumber == 2 then
        difficultyNumber = 8
    elseif difficultyNumber == 3 then
        difficultyNumber = 16
    else
        difficultyNumber = 24
    end

    container.ACSTime:SetText(tepFightLogs[1 + difficultyNumber])
    container.BBTime:SetText(tepFightLogs[2 + difficultyNumber])
    container.RoATime:SetText(tepFightLogs[3 + difficultyNumber])
    container.LATime:SetText(tepFightLogs[4 + difficultyNumber])
    container.OTime:SetText(tepFightLogs[5 + difficultyNumber])
    container.TQCTime:SetText(tepFightLogs[6 + difficultyNumber])
    container.ZHoNTime:SetText(tepFightLogs[7 + difficultyNumber])
    container.QATime:SetText(tepFightLogs[8 + difficultyNumber])
end

function CTT_GetCharacterProfileName()
    return UnitName("player") .. ' - ' .. GetRealmName()
end

function CTT_ProfileExists(profileName)
    for _, existingProfileName in ipairs(db:GetProfiles()) do
        if existingProfileName == profileName then
            return true
        end
    end

    return false
end

function CTT_GetSharedProfileName()
    if db.global.sharedProfileName == nil or db.global.sharedProfileName == "" then
        db.global.sharedProfileName = CTT_GetCharacterProfileName()
    end

    return db.global.sharedProfileName
end

function CTT_SetActiveProfile(profileName)
    activeProfile = profileName
    activeProfileKey = nil

    for k, existingProfileName in ipairs(db:GetProfiles()) do
        if existingProfileName == profileName then
            activeProfileKey = k
            break
        end
    end
end

function CTT_GetProfileKey(profileName)
    for k, existingProfileName in ipairs(db:GetProfiles()) do
        if existingProfileName == profileName then
            return k
        end
    end
end

function CTT_ApplyConfiguredProfile()
    local profileName = CTT_GetCharacterProfileName()

    if db.global.useSharedDefaultProfile then
        profileName = CTT_GetSharedProfileName()
    end

    db:SetProfile(profileName)
    CTT_SetActiveProfile(profileName)
end

function CTT_CreateStopwatchFrame()
    local f = CreateFrame("Frame", "cttStopwatchGui", UIParent, "BackdropTemplate")
    f:SetSize(100, 40)
    f:SetPoint("RIGHT")
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:Show()

    local bg= f:CreateTexture(nil, "BACKGROUND")
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

--|-----------------------|
--| AceGUI Options Menu --|
--|-----------------------|

-- Helper function to create a checkbox
local function CreateCheckBox(container, opts)
    local cb = AceGUI:Create("CheckBox")
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

-- Helper function to create a dropdown
local function CreateDropdown(container, opts)
    local dd = AceGUI:Create("Dropdown")
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

-- Helper function to create a button
local function CreateButton(container, opts)
    local btn = AceGUI:Create("Button")
    btn:SetText(opts.text)
    if opts.width then btn:SetWidth(opts.width) end
    btn:ClearAllPoints()
    if opts.point then btn:SetPoint(unpack(opts.point)) end
    if opts.callback then btn:SetCallback("OnClick", opts.callback) end
    container:AddChild(btn)
    if opts.name then container[opts.name] = btn end
    return btn
end

-- Helper function to create a color picker
local function CreateColorPicker(container, opts)
    local cp = AceGUI:Create("ColorPicker")
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

-- Helper function to create a slider
local function CreateSlider(container, opts)
    local slider = AceGUI:Create("Slider")
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

-- function to toggle the options menu
function CTT_ToggleMenu()
    if UnitAffectingCombat("player") or bossEncounter then
        loadOptionsAfterCombat = true
        CTT:Print(L["Options menu cannot be loaded while in combat, try again after combat has ended!"])
    else
        if CTT.menu == nil then
            CTT:CreateOptionsMenu()
        end
        if CTT.menu:IsShown() then
            CTT.menu:Hide()
            CTT:Print(L["Options menu hidden, for other commands use /ctt help!"])
        else
            CTT.menu:Show()
            CTT:Print(L["Options menu loaded, for other commands use /ctt help!"])
        end
    end
end

function CTT_LockFrameCheckBoxState(widget, event, value)
    db.profile.cttMenuOptions.lockFrameCheckButton = value
    if db.profile.cttMenuOptions.lockFrameCheckButton then
        cttStopwatchGui:EnableMouse(false)
        CTT:Print(L["Tracker has been locked!"])
    else
        cttStopwatchGui:EnableMouse(true)
        CTT:Print(L["Tracker has been unlocked!"])
    end
end

function CTT_ColorPickerConfirmed(widget, event, r, g, b, a)
    db.profile.cttMenuOptions.textColorPicker = { r, g, b, a }
    cttStopwatchGuiTimeText:SetTextColor(r, g, b, a)
end

function CTT_DropdownState(widget, event, key, checked)
    db.profile.cttMenuOptions.dropdownValue = key
    CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2],
        db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5],
        db.profile.cttMenuOptions.dropdownValue, 1)
end

-- function to handle the sliding of the slider, this fires anytime the slider moves
function CTT_ResizeFrameSliderUpdater(widget, event, value)
    db.profile.cttMenuOptions.textFrameSizeSlider = value
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
    if db.profile.cttMenuOptions.toggleTarget then
        cttStopwatchGuiTargetText:SetSize(targetSizeWidth, targetSizeHeight)
        cttStopwatchGuiTargetIcon:SetSize(iconSize, iconSize)
        cttStopwatchGuiTargetIcon2:SetSize(iconSize, iconSize)
    end
    -- TODO add target text to ctt db for persistence
    -- TODO add dynamic absolute offset for target raid icons
    if db.profile.cttMenuOptions.fontName then
        cttStopwatchGuiTimeText:SetFont(db.profile.cttMenuOptions.fontName, fontVal, db.profile.cttMenuOptions.fontFlags)
        if db.profile.cttMenuOptions.toggleTarget then
            cttStopwatchGuiTargetText:SetFont(db.profile.cttMenuOptions.fontName
            , fontVal / 2, db.profile.cttMenuOptions.fontFlags)
        end
        db.profile.cttMenuOptions.fontVal = fontVal
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf", fontVal, db.profile.cttMenuOptions.fontFlags)
        if db.profile.cttMenuOptions.toggleTarget then
            cttStopwatchGuiTargetText:SetFont("Fonts\\MORPHEUS.ttf",
                fontVal /
                2, db.profile.cttMenuOptions.fontFlags)
        end
        db.profile.cttMenuOptions.fontVal = fontVal
    end
end

-- function to update the tracker size from user settings on login
function CTT_SetTrackerSizeOnLogin()
    if #db.profile.cttMenuOptions.timeTrackerSize == 2 and db.profile.cttMenuOptions.fontVal and
        db.profile.cttMenuOptions.fontName and db.profile.cttMenuOptions.backDropAlphaSlider then
        cttStopwatchGui:SetWidth(db.profile.cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(db.profile.cttMenuOptions.timeTrackerSize[1],
            db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(db.profile.cttMenuOptions.fontName, db.profile.cttMenuOptions.fontVal,
            db.profile.cttMenuOptions.fontFlags)
        cttStopwatchGui:SetBackdrop(backdropSettings)
        cttStopwatchGui:SetBackdropColor(0, 0, 0, db.profile.cttMenuOptions.backDropAlphaSlider)
        cttStopwatchGui:SetBackdropBorderColor(255, 255, 255, db.profile.cttMenuOptions.backDropAlphaSlider)
        cttStopwatchGuiTimeText:SetTextColor(db.profile.cttMenuOptions.textColorPicker[1],
            db.profile.cttMenuOptions.textColorPicker[2], db.profile.cttMenuOptions.textColorPicker[3],
            db.profile.cttMenuOptions.textColorPicker[4])
        cttStopwatchGui:ClearAllPoints()
        cttStopwatchGui:SetPoint(db.profile.cttMenuOptions.framePoint, nil, db.profile.cttMenuOptions.frameRelativePoint
        , db.profile.cttMenuOptions.xOfs, db.profile.cttMenuOptions.yOfs)
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf", 16, db.profile.cttMenuOptions.fontFlags)
        db.profile.cttMenuOptions.fontVal = fontVal
    end
end

-- SetCallBack function that handles when the person stops sliding the slider
function CTT_ResizeFrameSliderDone(widget, event, value)
    db.profile.cttMenuOptions.textFrameSizeSlider = value
    db.profile.cttMenuOptions.timeTrackerSize = { cttStopwatchGui:GetWidth(), cttStopwatchGui:GetHeight() }
end

-- Callback function for the font picker dropdown
function CTT_FontPickerDropDownState(widget, event, key, checked)
    db.profile.cttMenuOptions.fontPickerDropDown = key
    db.profile.cttMenuOptions.fontName = LSM:Fetch("font", fontTableOptions[key])
    if #db.profile.cttMenuOptions.timeTrackerSize == 2 and db.profile.cttMenuOptions.fontVal and
        db.profile.cttMenuOptions.fontName then
        cttStopwatchGui:SetWidth(db.profile.cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(db.profile.cttMenuOptions.timeTrackerSize[1],
            db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(db.profile.cttMenuOptions.fontName, db.profile.cttMenuOptions.fontVal,
            db.profile.cttMenuOptions.fontFlags)
        CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2],
            db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5],
            db.profile.cttMenuOptions.dropdownValue, 2)
    end
end

-- callback for the backdrop opacity slider while moving
function CTT_BackDropSliderOnValueChanged(widget, event, value)
    db.profile.cttMenuOptions.backDropAlphaSlider = value
    cttStopwatchGui:SetBackdropColor(0, 0, 0, value)
    cttStopwatchGui:SetBackdropBorderColor(255, 255, 255, value)
end

-- callback for the backdrop opacity slider when dont moving
function CTT_BackDropSliderDone(widget, event, value)
    db.profile.cttMenuOptions.backDropAlphaSlider = value
end

function CTT_MinimapIconCheckButton(widget, event, value)
    db.profile.minimap.hide = value
    db.profile.cttMenuOptions.minimapIconCheckButton = value
    if db.profile.cttMenuOptions.minimapIconCheckButton then
        icon:Hide("CombatTimeTracker")
    else
        icon:Show("CombatTimeTracker")
    end
end

function CTT_ToggleTargetCheckButton(widget, event, value)
    db.profile.cttMenuOptions.toggleTarget = value
    if db.profile.cttMenuOptions.toggleTarget then
        cttStopwatchGuiTargetText:Show()
    else
        cttStopwatchGuiTargetText:Hide()
    end
end

function CTT_ToggleClickThroughCheckButton(widget, event, value)
    db.profile.cttMenuOptions.clickThrough = value
    if db.profile.cttMenuOptions.clickThrough then
        cttStopwatchGui:EnableMouse(value)
    else
        cttStopwatchGui:EnableMouse(value)
    end
end

function CTT_TogglePrintCheckButton(widget, event, value)
    db.profile.cttMenuOptions.togglePrint = value;
end

function CTT_ToggleTextFlagsButton(widget, event, value)
    db.profile.cttMenuOptions.textFlags = value
    if value then
        db.profile.cttMenuOptions.fontFlags = "OUTLINE, THICKOUTLINE, MONOCHROME"
    else
        db.profile.cttMenuOptions
        .fontFlags = ""
    end
    CTT_SetTrackerSizeOnLogin()
end

function CTT_InstanceTypeDropDown(widget, event, key, checked)
    local zone = GetRealZoneText()
    db.profile.cttMenuOptions.instanceType = key
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

function CTT_DifficultyDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.difficultyDropDown = key
    if key == 1 then
        -- TODO LFR times
        CTT_UpdateMenuTexts(menu.tree, key)
    elseif key == 2 then
        -- TODO normal times
        CTT_UpdateMenuTexts(menu.tree, key)
    elseif key == 3 then
        -- TODO heroic times
        CTT_UpdateMenuTexts(menu.tree, key)
    else
        -- TODO mythic times
        CTT_UpdateMenuTexts(menu.tree, key)
    end
end

function CTT_cosDifficultyDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.difficultyDropDown2 = key
    if key == 1 then
        -- TODO LFR times
        CTT_CoSUpdateMenuTexts(menu.tree, key)
    elseif key == 2 then
        -- TODO normal times
        CTT_CoSUpdateMenuTexts(menu.tree, key)
    elseif key == 3 then
        -- TODO heroic times
        CTT_CoSUpdateMenuTexts(menu.tree, key)
    else
        -- TODO mythic times
        CTT_CoSUpdateMenuTexts(menu.tree, key)
    end
end

function CTT_tepDifficultyDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.difficultyDropDown3 = key
    if key == 1 then
        -- TODO LFR times
        CTT_tepUpdateMenuTexts(menu.tree, key)
    elseif key == 2 then
        -- TODO normal times
        CTT_tepUpdateMenuTexts(menu.tree, key)
    elseif key == 3 then
        -- TODO heroic times
        CTT_tepUpdateMenuTexts(menu.tree, key)
    else
        -- TODO mythic times
        CTT_tepUpdateMenuTexts(menu.tree, key)
    end
end

function CTT_PlaySoundOnDropDownSelect(widget, event, key, checked)
    db.profile.cttMenuOptions.soundDropDownValue = key
    local soundPath = LSM:Fetch("sound", soundTableOptions[key])
    db.profile.cttMenuOptions.soundName = soundPath
    if soundPath then
        PlaySoundFile(soundPath, "Master")
    end
end

function CTT_AlertTimeOnEnterPressed(widget, event, text)
    db.profile.cttMenuOptions.localStore = text
end

function CTT_AlertRaidDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.raidKey = key
    db.profile.cttMenuOptions.raidDropdown = CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey)[key]
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_AlertRaidDropDownForRaidTab(widget, event, key, checked)
    db.profile.cttMenuOptions.raidKey = key
    db.profile.cttMenuOptions.raidDropdown = CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey)[key]
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_ExpansionDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.xpacKey = key
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_ExpansionDropDownForRaidTab(widget, event, key, checked)
    db.profile.cttMenuOptions.xpacKey = key
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_AlertBossDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.bossDropdown = CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey)[key]
    db.profile.cttMenuOptions.bossDropDownkey = key
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_AlertBossDropDownForRaidTab(widget, event, key, checked)
    db.profile.cttMenuOptions.bossDropdown = CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey)[key]
    db.profile.cttMenuOptions.bossDropDownkey = key
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_ClearAlertBossRaidTab()
    if db.profile.RaidKills ~= nil then
        db.profile.RaidKills = {}
    end
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_AlertAddButtonClicked(widget, event)
    local timeInSeconds = IsInt(db.profile.cttMenuOptions.localStore)
    if db.profile.cttMenuOptions.alerts == nil then
        db.profile.cttMenuOptions.alerts = {}
    end
    local alerts = db.profile.cttMenuOptions.alerts
    local canAdd = db.profile.cttMenuOptions.localStore ~= nil and timeInSeconds and db.profile.cttMenuOptions.raidDropdown ~= nil
        and db.profile.cttMenuOptions.bossDropdown ~= nil
    if canAdd then
        alerts[#alerts + 1] = {
            tonumber(db.profile.cttMenuOptions.localStore),
            CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey)[db.profile.cttMenuOptions.raidKey],
            CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey)[db.profile.cttMenuOptions.bossDropDownkey],
            CTT_GetRaidEncounterID(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey, db.profile.cttMenuOptions.bossDropDownkey)
        }
        CTT.menu.tree:SelectByValue("alerts")
    else
        if not timeInSeconds then
            CTT_AlertsErrorPopup(1)
        elseif db.profile.cttMenuOptions.raidDropdown == nil then
            CTT_AlertsErrorPopup(2)
        elseif db.profile.cttMenuOptions.bossDropdown == nil then
            CTT_AlertsErrorPopup(3)
        end
    end
end

function CTT_AlertDeleteButtonClicked(widget, event, key)
    if db.profile.cttMenuOptions.alerts ~= nil then
        table.remove(db.profile.cttMenuOptions.alerts, key)
    end
    CTT.menu.tree:SelectByValue("alerts")
end

function CTT_AlertDeleteButtonClickedForRaidTab(widget, event, key)
    if db.profile.RaidKills ~= nil then
        table.remove(db.profile.RaidKills, key)
    end
    CTT.menu.tree:SelectByValue("raids")
end

function CTT_DeleteDungeonRun(widget, event, key)
    if db.profile.DungeonKills ~= nil then
        table.remove(db.profile.DungeonKills, key)
    end
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_DungeonFilterDropDown(widget, event, key, checked)
    local expansionName = db.profile.cttMenuOptions.dungeonExpansionName or "All"
    local seasonName = db.profile.cttMenuOptions.dungeonSeasonName or "All"
    local staticList = CTT_GetDungeonDropdownList(expansionName, seasonName)
    local dungeonNames = staticList or CTT_BuildDungeonFilterList()
    db.profile.cttMenuOptions.dungeonFilterKey = key
    db.profile.cttMenuOptions.dungeonFilterName = dungeonNames[key] or "All"
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_DungeonExpansionDropDown(widget, event, key, checked)
    local expansionList = CTT_GetMPlusExpansionFilterList()
    db.profile.cttMenuOptions.dungeonExpansionKey = key
    db.profile.cttMenuOptions.dungeonExpansionName = expansionList[key] or "All"
    -- Changing expansion resets both the season and dungeon filter
    db.profile.cttMenuOptions.dungeonSeasonKey = 1
    db.profile.cttMenuOptions.dungeonSeasonName = "All"
    db.profile.cttMenuOptions.dungeonFilterKey = 1
    db.profile.cttMenuOptions.dungeonFilterName = "All"
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_DungeonSeasonDropDown(widget, event, key, checked)
    local expansionName = db.profile.cttMenuOptions.dungeonExpansionName or "All"
    local seasonList = CTT_GetMPlusSeasonFilterList(expansionName)
    db.profile.cttMenuOptions.dungeonSeasonKey = key
    db.profile.cttMenuOptions.dungeonSeasonName = seasonList[key] or "All"
    -- Changing season resets the dungeon name filter
    db.profile.cttMenuOptions.dungeonFilterKey = 1
    db.profile.cttMenuOptions.dungeonFilterName = "All"
    CTT.menu.tree:SelectByValue("dungeons")
end

function CTT_AlertsErrorPopup(errorCode)
    local text = L["You must enter values!"]

    if errorCode == 1 then
        text = L["You must enter a valid time in seconds (no decimal values!!! e.g. 100 not 100.1)!"]
    elseif errorCode == 2 then
        text = L["You must select a raid!"]
    elseif errorCode == 3 then
        text = L["You must select a boss!"]
    end

    StaticPopupDialogs["AlertError"] = {
        text = text,
        button1 = L["Ok"],
        -- button2 = "Reset Later",
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
        newProfileName = text
    else
        StaticPopupDialogs["ProfileNameError"] = {
            text = L["You have entered an invalid profile name, please try again!"],
            button1 = L["Ok"],
            -- button2 = "Reset Later",
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
    db:SetProfile(db:GetProfiles()[key])
    CTT_SetActiveProfile(db:GetProfiles()[key])
    CTT.menu.tree:SelectByValue("settings")
    CTT:Print(activeProfile .. " profile is now the active profile!")
    CTT_SetTrackerSizeOnLogin()
end

function CTT_ProfileAddButton(widget, event)
    db:SetProfile(newProfileName)
    CTT_SetActiveProfile(newProfileName)
    CTT:Print(string.format(L["New profile '%s' has been created!"], newProfileName))
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_ProfileCopyDropdown(widget, event, key)
    CTT:Print(string.format(L["%s has been updated to a copy of %s!"], activeProfile, db:GetProfiles()[key]))
    db:CopyProfile(db:GetProfiles()[key], true)
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_ProfileDeleteDropdown(widget, event, key)
    local deletedProfileName = db:GetProfiles()[key]
    CTT:Print(string.format(L["%s profile has been deleted!"], deletedProfileName))
    db:DeleteProfile(deletedProfileName, true)
    if db.global.sharedProfileName == deletedProfileName then
        db.global.sharedProfileName = db:GetCurrentProfile()
    end
    CTT_SetActiveProfile(db:GetCurrentProfile())
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_UseSharedDefaultProfile(widget, event, value)
    local currentProfileName = db:GetCurrentProfile()
    db.global.useSharedDefaultProfile = value

    if value and (db.global.sharedProfileName == nil or db.global.sharedProfileName == "") then
        db.global.sharedProfileName = currentProfileName
    end

    local targetProfileName = CTT_GetCharacterProfileName()
    if value then
        targetProfileName = CTT_GetSharedProfileName()
    end

    local targetProfileExists = CTT_ProfileExists(targetProfileName)

    if currentProfileName ~= targetProfileName then
        db:SetProfile(targetProfileName)

        if not targetProfileExists then
            db:CopyProfile(currentProfileName, true)
        end
    end

    CTT_SetActiveProfile(targetProfileName)
    if value then
        CTT:Print(string.format(L["New characters will start on the %s profile."], targetProfileName))
    else
        CTT:Print(L["New characters will use character-specific profiles."])
    end
    CTT.menu.tree:SelectByValue("settings")
end

function CTT_SharedProfileDropDown(widget, event, key)
    local selectedProfileName = db:GetProfiles()[key]

    db.global.sharedProfileName = selectedProfileName
    CTT:Print(string.format(L["Shared profile is now set to %s."], selectedProfileName))

    if db.global.useSharedDefaultProfile then
        db:SetProfile(selectedProfileName)
        CTT_SetActiveProfile(selectedProfileName)
        CTT_SetTrackerSizeOnLogin()
        CTT.menu.tree:SelectByValue("settings")
    end
end

function CTT_ResetTrackerOnCombatEnding(widget, event, value)
    --@debug@
    CTT:Print(db.profile.cttMenuOptions.resetCounterOnEndOfCombat)
    CTT:Print(value)
    --@end-debug@
    if not value then
        time = GetTime()
        cttElapsedSeconds = 0
    end
    db.profile.cttMenuOptions.resetCounterOnEndOfCombat = value;
end

--|-----------------------|
--| AceGUI Raid Bosses  --|
--|-----------------------|


--function that draws the General section
local function General(container)
    -- Frame Controls
    local frameGroup = AceGUI:Create("InlineGroup")
    frameGroup:SetTitle(L["Frame"])
    frameGroup:SetFullWidth(true)
    frameGroup:SetLayout("Flow")
    container:AddChild(frameGroup)

    CreateCheckBox(frameGroup, {
        label = L["Lock"],
        fullWidth = true,
        height = 22,
        value = db.profile.cttMenuOptions.lockFrameCheckButton,
        callback = CTT_LockFrameCheckBoxState,
        name = "lockFrameCheckButton",
    })

    CreateCheckBox(frameGroup, {
        label = L["Show Target"],
        fullWidth = true,
        height = 22,
        value = db.profile.cttMenuOptions.toggleTarget,
        callback = CTT_ToggleTargetCheckButton,
        name = "toggleTarget",
    })

    -- Minimap
    local minimapGroup = AceGUI:Create("InlineGroup")
    minimapGroup:SetTitle(L["Minimap"])
    minimapGroup:SetFullWidth(true)
    minimapGroup:SetLayout("Flow")
    container:AddChild(minimapGroup)

    CreateCheckBox(minimapGroup, {
        label = L["Hide Minimap Icon"],
        fullWidth = true,
        height = 22,
        value = db.profile.cttMenuOptions.minimapIconCheckButton,
        callback = CTT_MinimapIconCheckButton,
        name = "minimapIconCheckButton",
    })

    -- Behavior
    local behaviorGroup = AceGUI:Create("InlineGroup")
    behaviorGroup:SetTitle(L["Behavior"])
    behaviorGroup:SetFullWidth(true)
    behaviorGroup:SetLayout("Flow")
    container:AddChild(behaviorGroup)

    CreateCheckBox(behaviorGroup, {
        label = L["Toggle Messages"],
        fullWidth = true,
        height = 22,
        value = db.profile.cttMenuOptions.togglePrint,
        callback = CTT_TogglePrintCheckButton,
        name = "togglePrint",
    })

    CreateCheckBox(behaviorGroup, {
        label = L["Reset After Combat"],
        fullWidth = true,
        height = 22,
        value = db.profile.cttMenuOptions.resetCounterOnEndOfCombat,
        callback = CTT_ResetTrackerOnCombatEnding,
        name = "resetTrackerOnCombatEnding",
    })
end

-- function that draws the Display section
local function Display(container)
    -- Text Appearance
    local textGroup = AceGUI:Create("InlineGroup")
    textGroup:SetTitle(L["Text Appearance"])
    textGroup:SetFullWidth(true)
    textGroup:SetLayout("Flow")
    container:AddChild(textGroup)

    CreateColorPicker(textGroup, {
        color = db.profile.cttMenuOptions.textColorPicker,
        label = L["Text Color"],
        width = 100,
        callback = CTT_ColorPickerConfirmed,
        name = "textColorPicker",
    })

    CreateCheckBox(textGroup, {
        label = L["TextOutline"],
        fullWidth = true,
        height = 22,
        value = db.profile.cttMenuOptions.textFlags,
        callback = CTT_ToggleTextFlagsButton,
        name = "textFlagsButton",
    })

    CreateDropdown(textGroup, {
        label = L["Text Format"],
        width = 200,
        list = db.profile.cttMenuOptions.cttTextFormatOptions,
        text = db.profile.cttMenuOptions.cttTextFormatOptions[db.profile.cttMenuOptions.dropdownValue],
        value = db.profile.cttMenuOptions.dropdownValue,
        callback = CTT_DropdownState,
        name = "textStyleDropDown",
    })

    -- Size
    local sizeGroup = AceGUI:Create("InlineGroup")
    sizeGroup:SetTitle(L["Size"])
    sizeGroup:SetFullWidth(true)
    sizeGroup:SetLayout("Flow")
    container:AddChild(sizeGroup)

    CreateSlider(sizeGroup, {
        label = L["Tracker Size"],
        width = 200,
        isPercent = true,
        value = db.profile.cttMenuOptions.textFrameSizeSlider,
        sliderValues = { 0, 1, .01 },
        onValueChanged = CTT_ResizeFrameSliderUpdater,
        onMouseUp = CTT_ResizeFrameSliderDone,
        name = "textFrameSizeSlider",
    })

    CreateSlider(sizeGroup, {
        label = L["Backdrop Opacity"],
        width = 200,
        isPercent = true,
        value = db.profile.cttMenuOptions.backDropAlphaSlider,
        sliderValues = { 0, 1, .01 },
        onValueChanged = CTT_BackDropSliderOnValueChanged,
        onMouseUp = CTT_BackDropSliderDone,
        name = "backDropAlphaSlider",
    })

    -- Font
    local fontGroup = AceGUI:Create("InlineGroup")
    fontGroup:SetTitle(L["Font"])
    fontGroup:SetFullWidth(true)
    fontGroup:SetLayout("Flow")
    container:AddChild(fontGroup)

    CreateDropdown(fontGroup, {
        label = L["Choose Font"],
        width = 270,
        list = LSM:List("font"),
        text = fontTableOptions[db.profile.cttMenuOptions.fontPickerDropDown],
        value = db.profile.cttMenuOptions.fontPickerDropDown,
        callback = CTT_FontPickerDropDownState,
        name = "fontPickerDropDown",
    })
end

-- function that draws the Visibility section
local function Visibility(container)
    local visGroup = AceGUI:Create("InlineGroup")
    visGroup:SetTitle(L["Settings"])
    visGroup:SetFullWidth(true)
    visGroup:SetLayout("Flow")
    container:AddChild(visGroup)

    CreateDropdown(visGroup, {
        label = L["Show Tracker When?"],
        width = 200,
        list = instanceTypes,
        text = instanceTypes[db.profile.cttMenuOptions.instanceType],
        value = db.profile.cttMenuOptions.instanceType,
        callback = CTT_InstanceTypeDropDown,
        name = "instanceType",
    })

    CreateCheckBox(visGroup, {
        label = L["Click Through"],
        fullWidth = true,
        height = 22,
        value = db.profile.cttMenuOptions.clickThrough,
        callback = CTT_ToggleClickThroughCheckButton,
        name = "clickThrough",
    })
end

-- function that draws the Sound section
local function Sound(container)
    local soundGroup = AceGUI:Create("InlineGroup")
    soundGroup:SetTitle(L["Settings"])
    soundGroup:SetFullWidth(true)
    soundGroup:SetLayout("Flow")
    container:AddChild(soundGroup)

    CreateDropdown(soundGroup, {
        label = L["Choose Sound"],
        width = 270,
        list = LSM:List("sound"),
        text = soundTableOptions[db.profile.cttMenuOptions.soundDropDownValue],
        value = db.profile.cttMenuOptions.soundDropDownValue,
        callback = CTT_PlaySoundOnDropDownSelect,
        name = "soundPickerDropDown",
    })
end

-- function that draws the Profiles section
local function Profiles(container)
    -- New Profile
    local newProfileGroup = AceGUI:Create("InlineGroup")
    newProfileGroup:SetTitle(L["New Profile"])
    newProfileGroup:SetFullWidth(true)
    newProfileGroup:SetLayout("Flow")
    container:AddChild(newProfileGroup)

    local profileName = AceGUI:Create("EditBox")
    profileName:SetLabel(L["New Profile Name"])
    profileName:ClearAllPoints()
    profileName:SetCallback("OnEnterPressed", CTT_ProfileNameOnEnterPressed)
    newProfileGroup:AddChild(profileName)
    container.profileName = profileName

    CreateButton(newProfileGroup, {
        text = L["Create Profile"],
        width = 150,
        callback = CTT_ProfileAddButton,
        name = "profileAddButton",
    })

    -- Manage Profiles
    local manageGroup = AceGUI:Create("InlineGroup")
    manageGroup:SetTitle(L["Manage Profiles"])
    manageGroup:SetFullWidth(true)
    manageGroup:SetLayout("Flow")
    container:AddChild(manageGroup)

    CreateDropdown(manageGroup, {
        label = L["Choose Profile"],
        multiselect = false,
        list = db:GetProfiles(),
        value = activeProfileKey,
        callback = CTT_ProfileDropDownPicker,
        name = "profileDropDownPicker",
    })

    CreateDropdown(manageGroup, {
        label = L["Copy Profile"],
        multiselect = false,
        list = db:GetProfiles(),
        callback = CTT_ProfileCopyDropdown,
        name = "profileCopyDropdown",
    })

    CreateDropdown(manageGroup, {
        label = L["Delete Profile"],
        multiselect = false,
        list = db:GetProfiles(),
        callback = CTT_ProfileDeleteDropdown,
        name = "profileDeleteDropdown",
    })

    -- Shared Profile
    local sharedGroup = AceGUI:Create("InlineGroup")
    sharedGroup:SetTitle(L["Shared Profile"])
    sharedGroup:SetFullWidth(true)
    sharedGroup:SetLayout("Flow")
    container:AddChild(sharedGroup)

    CreateCheckBox(sharedGroup, {
        label = L["Use Default For New Characters"],
        fullWidth = true,
        height = 22,
        value = db.global.useSharedDefaultProfile,
        callback = CTT_UseSharedDefaultProfile,
        name = "sharedDefaultProfile",
    })

    CreateDropdown(sharedGroup, {
        label = L["Shared Profile"],
        multiselect = false,
        list = db:GetProfiles(),
        value = CTT_GetProfileKey(CTT_GetSharedProfileName()),
        width = 200,
        disabled = not db.global.useSharedDefaultProfile,
        callback = CTT_SharedProfileDropDown,
        name = "sharedProfilePicker",
    })
end

-- function that draws the dungeons tab
-- Build a filter list of unique dungeon names from stored runs, prefixed with "All"
function CTT_BuildDungeonFilterList()
    local names = { "All" }
    local seen = {}
    if db.profile.DungeonKills then
        for _, v in ipairs(db.profile.DungeonKills) do
            if v.Dungeon and not seen[v.Dungeon] then
                seen[v.Dungeon] = true
                tinsert(names, v.Dungeon)
            end
        end
    end
    return names
end

local function Dungeons(container)
    -- Filter configuration
    local configGroup = AceGUI:Create("InlineGroup")
    configGroup:SetTitle(L["Filter"])
    configGroup:SetFullWidth(true)
    configGroup:SetLayout("Flow")
    container:AddChild(configGroup)

    -- Expansion filter
    local expansionList = CTT_GetMPlusExpansionFilterList()
    local savedExpKey = db.profile.cttMenuOptions.dungeonExpansionKey or 1
    if savedExpKey > #expansionList then
        savedExpKey = 1
        db.profile.cttMenuOptions.dungeonExpansionKey = 1
        db.profile.cttMenuOptions.dungeonExpansionName = "All"
    end
    local selectedExpansion = expansionList[savedExpKey]

    CreateDropdown(configGroup, {
        label = L["Expansion"],
        list = expansionList,
        text = expansionList[savedExpKey],
        value = savedExpKey,
        width = 200,
        callback = CTT_DungeonExpansionDropDown,
        name = "dungeonExpansionFilter"
    })

    -- Season filter (depends on selected expansion)
    local seasonList = CTT_GetMPlusSeasonFilterList(selectedExpansion)
    local savedSeaKey = db.profile.cttMenuOptions.dungeonSeasonKey or 1
    if savedSeaKey > #seasonList then
        savedSeaKey = 1
        db.profile.cttMenuOptions.dungeonSeasonKey = 1
        db.profile.cttMenuOptions.dungeonSeasonName = "All"
    end
    local selectedSeason = seasonList[savedSeaKey]

    CreateDropdown(configGroup, {
        label = L["Season"],
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
    local savedKey = db.profile.cttMenuOptions.dungeonFilterKey or 1
    if savedKey > #dungeonNames then
        savedKey = 1
        db.profile.cttMenuOptions.dungeonFilterKey = 1
        db.profile.cttMenuOptions.dungeonFilterName = "All"
    end

    CreateDropdown(configGroup, {
        label = L["Dungeon"],
        list = dungeonNames,
        text = dungeonNames[savedKey],
        value = savedKey,
        width = 275,
        callback = CTT_DungeonFilterDropDown,
        name = "dungeonFilter"
    })

    CreateButton(configGroup, {
        text = L["Clear All"],
        width = 125,
        callback = function()
            db.profile.DungeonKills = {}
            db.profile.cttMenuOptions.dungeonFilterKey = 1
            db.profile.cttMenuOptions.dungeonFilterName = "All"
            db.profile.cttMenuOptions.dungeonExpansionKey = 1
            db.profile.cttMenuOptions.dungeonExpansionName = "All"
            db.profile.cttMenuOptions.dungeonSeasonKey = 1
            db.profile.cttMenuOptions.dungeonSeasonName = "All"
            CTT.menu.tree:SelectByValue("dungeons")
        end,
        name = "clearDungeonsButton"
    })

    -- Run log
    local listGroup = AceGUI:Create("InlineGroup")
    listGroup:SetTitle(L["M+ Run Log"])
    listGroup:SetFullWidth(true)
    listGroup:SetLayout("Flow")
    container:AddChild(listGroup)

    local labelWidth = math.max(200, listGroup.frame:GetWidth() - 54)
    local dungeonFilter = db.profile.cttMenuOptions.dungeonFilterName or "All"

    -- Pre-compute matching season IDs for the current expansion/season selection
    local filterBySeasonID = (selectedExpansion ~= "All" or selectedSeason ~= "All")
    local matchingSeasonIDs = filterBySeasonID and CTT_GetMPlusSeasonIDs(selectedExpansion, selectedSeason) or nil

    if db.profile.DungeonKills ~= nil and #db.profile.DungeonKills > 0 then
        local anyShown = false
        for i, v in ipairs(db.profile.DungeonKills) do
            -- Season/expansion filter
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

            -- Dungeon name filter
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

                local label = AceGUI:Create("Label")
                label:SetText(text)
                label:SetColor(255, 255, 0)
                label:SetWidth(labelWidth)
                label:ClearAllPoints()
                listGroup:AddChild(label)

                local deleteBtn = AceGUI:Create("Icon")
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
            local noDataLabel = AceGUI:Create("Label")
            noDataLabel:SetText(L["No runs recorded for this dungeon."])
            noDataLabel:SetColor(200, 200, 200)
            noDataLabel:SetFullWidth(true)
            listGroup:AddChild(noDataLabel)
        end
    else
        local noDataLabel = AceGUI:Create("Label")
        noDataLabel:SetText(L["No M+ runs recorded yet. Complete a Mythic Keystone dungeon to see your run times here."])
        noDataLabel:SetColor(200, 200, 200)
        noDataLabel:SetFullWidth(true)
        listGroup:AddChild(noDataLabel)
    end
end

-- function that draws the raid tab
local function Raids(container)
    local configGroup = AceGUI:Create("InlineGroup")
    configGroup:SetTitle(L["Configuration"])
    configGroup:SetFullWidth(true)
    configGroup:SetLayout("Flow")
    container:AddChild(configGroup)

    --select xpac
    CreateDropdown(configGroup, {
        label = L["Expansion"],
        list = CTT_GetExpansionNames(),
        text = CTT_GetExpansionNames()[db.profile.cttMenuOptions.xpacKey],
        value = db.profile.cttMenuOptions.xpacKey,
        width = 125,
        callback = CTT_ExpansionDropDownForRaidTab,
        name = "xpacDropdown"
    })

    -- Select Raid
    CreateDropdown(configGroup, {
        label = L["Raid"],
        list = CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey),
        text = CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey)[db.profile.cttMenuOptions.raidKey],
        value = db.profile.cttMenuOptions.raidKey,
        width = 225,
        callback = CTT_AlertRaidDropDownForRaidTab,
        name = "raidDropdown"
    })

    -- Select Boss
    CreateDropdown(configGroup, {
        label = L["Boss"],
        list = CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey),
        text = CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey)[db.profile.cttMenuOptions.bossDropDownkey],
        value = db.profile.cttMenuOptions.bossDropDownkey,
        width = 250,
        callback = CTT_AlertBossDropDownForRaidTab,
        name = "bossDropdown"
    })

    -- Clear All button
    CreateButton(configGroup, {
        text = L["Clear All"],
        width = 125,
        callback = CTT_ClearAlertBossRaidTab,
        name = "deleteKillsButton"
    })

    -- handle the scrollable alerts.
    local listGroup = AceGUI:Create("InlineGroup")
    listGroup:SetTitle(L["Kill Log"])
    listGroup:SetFullWidth(true)
    listGroup:SetLayout("Flow")
    container:AddChild(listGroup)

    -- 20px = InlineGroup content inset (10px each side), 24px = icon, 10px = spacing
    local labelWidth = math.max(200, listGroup.frame:GetWidth() - 54)

    if db.profile.RaidKills ~= nil and #db.profile.RaidKills > 0 then
        for i, v in ipairs(db.profile.RaidKills) do
            if (v.Expansion == CTT_GetExpansionNames()[db.profile.cttMenuOptions.xpacKey]
                and v.RaidInstance == CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey)[db.profile.cttMenuOptions.raidKey]
                and v.BossName == CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey)[db.profile.cttMenuOptions.bossDropDownkey])
            then
                local label = AceGUI:Create("Label")
                label:SetText(string.format(L["%s was killed on: %s, with a Kill Time of: %s, raid difficulty: %s, with %s players, and was killed successfully: %s"], v.BossName, v.LocalKillTime, v.KillTime, v.Difficulty, v.GroupSize, tostring(v.Success)))
                label:SetColor(255, 255, 0)
                label:SetWidth(labelWidth)
                label:ClearAllPoints()
                listGroup:AddChild(label)

                local deleteBtn = AceGUI:Create("Icon")
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

-- function that draws the Alert Times tab
local function Alerts(container)
    local addAlertGroup = AceGUI:Create("InlineGroup")
    addAlertGroup:SetTitle(L["Add Alert"])
    addAlertGroup:SetFullWidth(true)
    addAlertGroup:SetLayout("Flow")
    container:AddChild(addAlertGroup)

    --select xpac
    CreateDropdown(addAlertGroup, {
        label = L["Expansion"],
        list = CTT_GetExpansionNames(),
        text = CTT_GetExpansionNames()[db.profile.cttMenuOptions.xpacKey],
        value = db.profile.cttMenuOptions.xpacKey,
        width = 125,
        callback = CTT_ExpansionDropDown,
        name = "xpacDropdown"
    })

    -- Input field to get the time (in seconds)
    local timeInput = AceGUI:Create("EditBox")
    timeInput:SetLabel(L["Time(sec)"])
    timeInput:SetWidth(85)
    timeInput:ClearAllPoints()
    if db.profile.cttMenuOptions.localStore ~= nil then timeInput:SetText(db.profile.cttMenuOptions.localStore) end
    timeInput:SetCallback("OnEnterPressed", CTT_AlertTimeOnEnterPressed)
    addAlertGroup:AddChild(timeInput)
    container.timeInput = timeInput

    -- Select Raid
    CreateDropdown(addAlertGroup, {
        label = L["Raid"],
        list = CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey),
        text = CTT_GetRaidNames(db.profile.cttMenuOptions.xpacKey)[db.profile.cttMenuOptions.raidKey],
        value = db.profile.cttMenuOptions.raidKey,
        width = 225,
        callback = CTT_AlertRaidDropDown,
        name = "raidDropdown"
    })

    -- Select Boss
    CreateDropdown(addAlertGroup, {
        label = L["Boss"],
        list = CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey),
        text = CTT_GetRaidBossNames(db.profile.cttMenuOptions.xpacKey, db.profile.cttMenuOptions.raidKey)[db.profile.cttMenuOptions.bossDropDownkey],
        value = db.profile.cttMenuOptions.bossDropDownkey,
        width = 250,
        callback = CTT_AlertBossDropDown,
        name = "bossDropdown"
    })

    -- Add alert to list
    CreateButton(addAlertGroup, {
        text = L["Add"],
        width = 75,
        callback = CTT_AlertAddButtonClicked,
        name = "addAlertButton"
    })

    -- Clear All Alerts button
    CreateButton(addAlertGroup, {
        text = L["Clear All Alerts"],
        width = 140,
        callback = function()
            db.profile.cttMenuOptions.alerts = {}
            CTT.menu.tree:SelectByValue("alerts")
        end,
        name = "clearAllAlertsButton"
    })

    local listGroup = AceGUI:Create("InlineGroup")
    listGroup:SetTitle(L["Active Alerts"])
    listGroup:SetFullWidth(true)
    listGroup:SetLayout("Flow")
    container:AddChild(listGroup)

    -- 20px = InlineGroup content inset (10px each side), 24px = icon, 10px = spacing
    local labelWidth = math.max(200, listGroup.frame:GetWidth() - 54)

    for i, v in ipairs(db.profile.cttMenuOptions.alerts) do
        local label = AceGUI:Create("Label")
        label:SetText(string.format(L["Seconds into fight: %s, Raid: %s, Boss: %s"], v[1], v[2], v[3]))
        label:SetColor(255, 255, 0)
        label:SetWidth(labelWidth)
        label:ClearAllPoints()
        listGroup:AddChild(label)

        local deleteBtn = AceGUI:Create("Icon")
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
    db.profile.cttMenuOptions.selectedTab = group

    local scroll = AceGUI:Create("ScrollFrame")
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

function CTT:CreateOptionsMenu()
    menu = AceGUI:Create("Frame")
    menu:SetTitle(L["Combat Time Tracker Options"])
    menu:SetStatusText(C_AddOns.GetAddOnMetadata("CombatTimeTracker", "Version"))
    menu:SetWidth(db.profile.cttMenuOptions.menuWidth or 750)
    menu:SetHeight(db.profile.cttMenuOptions.menuHeight or 600)
    menu:SetLayout("Fill")
    menu:Hide()
    CTT.menu = menu

    menu.frame:SetResizeBounds(375, 300, 1125, 900)
    menu.frame:SetFrameStrata("HIGH")
    menu.frame:SetFrameLevel(1)

    menu.frame:SetScript("OnSizeChanged", function(self, width, height)
        db.profile.cttMenuOptions.menuWidth = math.floor(width)
        db.profile.cttMenuOptions.menuHeight = math.floor(height)
    end)

    local tree = AceGUI:Create("TreeGroup")
    tree:SetFullWidth(true)
    tree:SetFullHeight(true)
    tree:SetLayout("Flow")
    tree:SetTree({
        { value = "settings",  text = L["Settings"] },
        { value = "profiles",  text = L["Profiles"] },
        { value = "dungeons",  text = L["Dungeons"] },
        { value = "raids",     text = L["Raids"] },
        { value = "alerts",    text = L["Alert Times"] },
    })
    tree:SetCallback("OnGroupSelected", SelectGroup)
    tree:SelectByValue("settings")
    menu:AddChild(tree)
    menu.tree = tree

    _G["CombatTimeTrackerMenu"] = menu.frame
    tinsert(UISpecialFrames, "CombatTimeTrackerMenu")
end
