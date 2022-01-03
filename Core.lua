-- Declare AceAddon
CTT = LibStub("AceAddon-3.0"):NewAddon("CTT", "AceConsole-3.0", "AceEvent-3.0")


--|-------------------------|
--| Variable Declarations   |
--|-------------------------|

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

local defaults = {
    profile = {
        minimap = {
            hide = false,
        },
        cttMenuOptions = {
            soundName = "",
            instanceType = 4,
            textFrameSizeSlider = 1,
            timeValues = {"00","00","00","00","00"},
            raidKey = 1,
            alerts = {},
            difficultyDropDown = 2,
            raidDropdown = "Castle Nathria",
            textColorPicker = {255,255,255,1},
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
            timeTrackerSize = {200,80},
            uiReset = false,
            lastVersion = "test",
            togglePrint = true,
            cttTextFormatOptions = {"(SS)", "(MM:SS)", "(HH:MM:SS)", "(MM:SS.MS)", "(MM:SS:MS)"},
            framePoint = "CENTER",
            frameRelativePoint = "CENTER",
            xOfs = 0,
            yOfs = 0
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

local instanceZones = {
    "De Other Side",
    "Halls of Atonement",  
    "Miss of Tirna Scithe",
    "Plaguefall", 
    "Sanguine Depths", 
    "Spires of Ascension", 
    "The Necrotic Wake", 
    "Theater of Pain",
    "Tazavesh, the Veiled Market"
}

-- local instanceZones = {
--     "Atal'Dazar",
--     "Freehold",  
--     "King's Rest",
--     "Shrine of the Storm", 
--     "Siege of Boralus", 
--     "Temple of Sethraliss", 
--     "The Motherload!!", 
--     "The Underrot", 
--     "Tol Dagor", 
--     "Waycrest Manor"
-- }

local raidInstanceZones = {
    "Castle Nathria",
    "Sanctum of Domination"
}

local bosses = {
    "Shriekwing",
    "Huntsman Altimor",
    "Sun King's Salvation",
    "Artificer Xy'mox",
    "Hungering Destroyer",
    "Lady Inerva Darkvein",
    "The Council of Blood",
    "Sludgefist",
    "Stone Legion Generals",
    "Sire Denathrius"
}

local bossesSOD = {
    "The Tarragrue",
    "The Eye of the Jailer",
    "The Nine",
    "Remnat of Ner'zhul",
    "Soulrender Dormazain",
    "Painsmith Raznal",
    "Guardian of the First Ones",
    "Fatescribe Roh-Kalo",
    "Kel'Thuzad",
    "Sylvanas Windrunner"
}

local bossEncounterID = {
    2398,
    2418,
    2402,
    2405,
    2383,
    2406,
    2412,
    2399,
    2417,
    2407
}

local EcounterIdSOD = {
    2423,
    2433,
    2429,
    2432,
    2434,
    2430,
    2436,
    2431,
    2422,
    2435
}

-- local raidInstanceZones = {
--     "Uldir",
--     "Battle of Dazar'alor",
--     "Crucible of Storms",
--     "The Eternal Palace",
--     "Ny'alotha, the Waking City"
-- }

local backdropSettings = {
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
    tile = true,
    tileSize = 16
}

-- Get encounter ID's 
--/run local i=1 while EJ_GetInstanceByIndex(i,true)do local a1,a2=EJ_GetInstanceByIndex(i,true)print(a1,a2)EJ_SelectInstance(a1)i=i+1 local j=1 while EJ_GetEncounterInfoByIndex(j,a1)do local b1,_,b2=EJ_GetEncounterInfoByIndex(j,a1)print(b2,b1)j=j+1 end end

local BoDBosses = {
-- 9 bosses
    2265,
    2263,
    2266,
    2271,
    2268,
    2272,
    2276,
    2280,
    2281
}

local CoSBosses = {
-- 2 bosses
    2269,
    2273
}

local TEPBosses = {
-- 8 bosses
    2298,
    2289,
    2305,
    2304,
    2303,
    2311,
    2293,
    2299
}

local NTWCBosses = {

}

local difficultyList = {
    "LFR",
    "Normal",
    "Heroic",
    "Mythic"
}


--|----------------------------|
--| Ace Library Declarations   |
--|----------------------------|

local L = LibStub("AceLocale-3.0"):GetLocale("cttTranslations")
local AceGUI = LibStub("AceGUI-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local db
local icon = LibStub("LibDBIcon-1.0")
local cttLBD = LibStub("LibDataBroker-1.1"):NewDataObject("CombatTimeTracker", {
	type = "data source",
	text = "Combat Time Tracker",
	icon = "Interface\\Icons\\inv_belt_armor_waistoftime_d_01",
    OnClick = function(button, buttonPressed)
        if buttonPressed == "RightButton" then
            if db.minimap.lock then
                icon:Unlock("CombatTimeTracker")
            else
                icon:Lock("CombatTimeTracker")
            end
        elseif buttonPressed == "MiddleButton" then
            icon:Hide("CombatTimeTracker")
            db.minimap.hide = true
            db.profile.cttMenuOptions.minimapIconCheckButton = true
            CTT.menu.minimapIconCheckButton:SetValue(true)
        else
            CTT_ToggleMenu()
        end
    end,
    OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then return end
		tooltip:AddLine("|cffff930fCombat Time Tracker|r")
        tooltip:AddLine("Click to open Options Menu")
        tooltip:AddLine("Middle-Click to hide minimap Button")
        tooltip:AddLine("Right-click to lock Minimap Button")
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
end

-- Register slash commands for addon.
function CTT:OnInitialize()
    self:RegisterChatCommand('ctt', 'SlashCommands')
    LSM.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateUsedMedia")
    db = LibStub("AceDB-3.0"):New("cttDB", defaults)
    icon:Register("CombatTimeTracker", cttLBD, db.minimap)
    if not db.profile.minimap.hide then
        icon:Show("CombatTimeTracker")
    end

    if activeProfile == nil and activeProfileKey == nil then
        db:SetProfile(UnitName("player") .. ' - ' .. GetRealmName())
        for k,v in ipairs(db:GetProfiles()) do
            if v == UnitName("player") .. ' - ' .. GetRealmName() then
                activeProfile = v
                activeProfileKey = k
            end
        end
    end

    db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end

-- Handle profile callbacks
function CTT:RefreshConfig()
    CTT_SetTrackerSizeOnLogin()
    CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2], db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5], db.profile.cttMenuOptions.dropdownValue,1)
    for k,v in ipairs(db:GetProfiles()) do
        if activeProfile == v and activeProfileKey ~=nil and activeProfile ~= nil then
            activeProfileKey = k
        end
    end
end

-- Handle the initialization of values from nil to 0 first time addon is loaded.
function CTT:ADDON_LOADED()
    if longestMin == nil then
        longestMin = 0
    end

    if longestSec == nil then
        longestSec = 0
    end

    CTT_CheckForReload()
    if GetAddOnMetadata("CombatTimeTracker", "Version") >= db.profile.cttMenuOptions.lastVersion and db.profile.cttMenuOptions.uiReset then
        CTT_PopUpMessage()
    end

--     local i = 1
--     while EJ_GetInstanceByIndex(i, true) do
--     local instanceId, name = EJ_GetInstanceByIndex(i, true)
--     print(instanceId, name)
--     EJ_SelectInstance(instanceId)
--     i = i+1
    
--     local j = 1
--     while EJ_GetEncounterInfoByIndex(j, instanceId) do
--         local _,_,_,_,_,_,id,_ = EJ_GetEncounterInfoByIndex(j, instanceId)
--         print(id)
--         j = j+1
--     end
-- 

-- git tag -am "Tag v2.0" v2.0 && git push origin master --tags
    cttStopwatchGui.elapsed = .05
    cttStopwatchGui:SetScript("OnUpdate", function(self, elapsed)
        cttElapsedSeconds = cttElapsedSeconds + elapsed
        self.elapsed = self.elapsed - elapsed
        if self.elapsed > 0 then return end
        self.elapsed = 0.05
        -- rest of the code here
        -- print(cttStopwatchGuiTargetText:GetText())
        if UnitAffectingCombat("player") or bossEncounter then
            --CTT:Print(cttElapsedSeconds)
            CTT_CheckForTarget()
            local times = GetTime() - time
            local time = cttElapsedSeconds
            totalSeconds = floor(time)
            hours = floor(time/3600)
            minutes = floor((time-floor(time/3600)*3600)/60)
            seconds = floor(time-floor(time/3600)*3600-floor((time-floor(time/3600)*3600)/60)*60)
            miliseconds = floor((time-floor(time/3600)*3600-floor((time-floor(time/3600)*3600)/60)*60-floor(time-floor(time/3600)*3600-floor((time-floor(time/3600)*3600)/60)*60))*100)

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
            if miliseconds < 10 then
                miliseconds = "0" .. miliseconds
            end

            --db.profile.cttMenuOptions.timeValues = {hours, minutes, seconds, tonumber(string.format("%02.f", math.floor(times)))}
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
        time = GetTime()
        cttElapsedSeconds = 0
        CTT_InstanceTypeDisplay(db.profile.cttMenuOptions.instanceType)
        --self:Print(L["Entering Combat!"])
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
        --self:Print(L["Leaving Combat!"])
        db.profile.cttMenuOptions.timeValues = {hours, minutes, seconds, totalSeconds, miliseconds}
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

-- Hook function into ENCOUNTER_START to handle getting the data stored.
function CTT:Encounter_Start(...)
    if db.profile.cttMenuOptions.instanceType == 5 and not cttStopwatchGui:IsShown() then cttStopwatchGui:Show() end
    bossEncounter = true
    local arg1, arg2, arg3, arg4, arg5 = ...
    bossEncounterName = arg2
    --CTT:Print(L["Encounter Started!"])
    -- local members = {}
    -- local numMembers = GetNumGroupMembers()
    -- if numMembers > 1 then
    --     for i=1,GetNumGroupMembers(),1 do
    --         members[i] = select(1, GetRaidRosterInfo(i))
    --     end
    -- else
    --     members = {UnitName("player")}
    -- end

    --table.insert(fightLogs, {arg2, arg3, arg4, arg5, members, false})
    time = GetTime()
    cttElapsedSeconds = 0
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
    --CTT:Print(L["Encounter Ended!"])
    local arg1, arg2, arg3, arg4, arg5, arg6 = ...
    local diffIDKey = 0
    if arg6 == 1 then
        CTT_DisplayResultsBosses(arg3, true)
    else
        CTT_DisplayResultsBosses(arg3, false)
    end
end


-- event function to handle persistence on the settings of the tracker when the player enters the world
function CTT:PLAYER_ENTERING_WORLD()
    --CTT:Print(GetAddOnMetadata("CombatTimeTracker", "Version"))
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
        CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2], db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5], db.profile.cttMenuOptions.dropdownValue,1)
    else
        CTT_UpdateText("00","00","00","00",1,1)
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
    for k,v in pairs(fontTableOptions) do
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
        db.profile.cttMenuOptions.timeValues = {"00","00","00","00"}
        activeProfile = nil
        activeProfileKey = nil
        CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2], db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5],db.profile.cttMenuOptions.dropdownValue,1)
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
        db.profile.cttMenuOptions.alerts = {}
        db:ResetDB(Default)
        activeProfile = nil
        activeProfileKey = nil
        CTT:Print(L["Combat Time Tracker has been reset to default settings!"])
    elseif command == "longest" then
        CTT:Print("Your longest fight took (MM:SS): "..longestMin..":"..longestSec..".")
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
    --@end-debug@
    end
    
end


--|--------------------------|
--| Non AceAddon functions --|
--|--------------------------|

-- function to check if a ui reset is needed.
function CTT_CheckForReload()
    if db.profile.cttMenuOptions.lastVersion == nil then db.profile.cttMenuOptions.uiReset = true db.profile.cttMenuOptions.lastVersion = GetAddOnMetadata("CombatTimeTracker", "Version") else db.profile.cttMenuOptions.uiReset = false end
end

function isInt(n)
    return (type(tonumber(n)) == "number" and (math.floor( (tonumber(n)) ) == tonumber(n)))
end

-- Function To check for players current target
function CTT_CheckForTarget()
    if not db.profile.cttMenuOptions.toggleTarget then return end
    local target = GetUnitName("Target", false)
    local raidMarkerIcon = target ~= nil and GetRaidTargetIndex("Target") or nil
    if target ~= nil then
        cttStopwatchGuiTargetText:SetText(target)
        cttStopwatchGuiTargetText:Show()
        if raidMarkerIcon ~= nil then
            cttStopwatchGuiTargetIcon:SetTexture("Interface/TargetingFrame/UI-RaidTargetingIcon_"..raidMarkerIcon, true)
            cttStopwatchGuiTargetIcon:Show()
            cttStopwatchGuiTargetIcon2:SetTexture("Interface/TargetingFrame/UI-RaidTargetingIcon_"..raidMarkerIcon, true)
            cttStopwatchGuiTargetIcon2:Show()
        else
            cttStopwatchGuiTargetIcon:Hide()
            cttStopwatchGuiTargetIcon2:Hide()
        end
    else
        cttStopwatchGuiTargetText:Hide()
        if cttStopwatchGuiTargetIcon:IsShown() then cttStopwatchGuiTargetIcon:Hide() cttStopwatchGuiTargetIcon2:Hide() end
    end
end

function CTT_CheckToPlaySound()
    if not bossEncounter then return end
    for k,v in pairs(db.profile.cttMenuOptions.alerts) do
        if (zone ~= "Sanctum of Domination") then
            if k ~= "scrollvalue" and k ~= "offset" and bossEncounterID[db.profile.cttMenuOptions.alerts[k][4]] == bossEncounterName and tonumber(totalSeconds) == db.profile.cttMenuOptions.alerts[k][1] then
                lastBossSoundPlayed = totalSeconds
                PlaySoundFile(LSM:Fetch("sound", soundTableOptions[db.profile.cttMenuOptions.soundDropDownValue]), "Master")
            end
        else
            if k ~= "scrollvalue" and k ~= "offset" and EcounterIdSOD[db.profile.cttMenuOptions.alerts[k][4]] == bossEncounterName and tonumber(totalSeconds) == db.profile.cttMenuOptions.alerts[k][1] then
                lastBossSoundPlayed = totalSeconds
                PlaySoundFile(LSM:Fetch("sound", soundTableOptions[db.profile.cttMenuOptions.soundDropDownValue]), "Master")
            end
        end
    end
end

-- function to handle showing the tracker based on instance type settings
function CTT_InstanceTypeDisplay(key)
    local zone = GetRealZoneText()
    local subZone = GetSubZoneText()

    if key == 1 then
        --Handle dungeons
        for k,v in pairs(instanceZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then
                    cttStopwatchGui:Show()
                end
                break
            else
                cttStopwatchGui:Hide()
            end
        end
    elseif key == 2 then
        -- handle raid stuff
        for k,v in pairs(raidInstanceZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then
                    cttStopwatchGui:Show()
                end
                break
            else
                cttStopwatchGui:Hide()
            end
        end
    elseif key == 3 then
        -- handle both dungeon and raid stuff

        --Handle dungeons
        for k,v in pairs(instanceZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then
                    cttStopwatchGui:Show()
                end
                return
            else
                cttStopwatchGui:Hide()
            end
        end
        -- handle raid stuff
        for k,v in pairs(raidInstanceZones) do
            if zone == v then
                if not cttStopwatchGui:IsShown() then
                    cttStopwatchGui:Show()
                end
                return
            else
                cttStopwatchGui:Hide()
            end
        end
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
        text = "Combat Time Tracker has been updated, the tracker needs to be reset to work properly!",
        button1 = "Reset Now",
        button2 = "Reset Later",
        OnAccept = function()
            fightLogs = {}
            for i=1,36 do
                fightLogs[i] = "00:00"
            end
            db.profile.cttMenuOptions.uiReset = false
            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show ("NEW_VERSION")
end

-- function to display results on ecounter end or regen enabled
function CTT_DisplayResults(newRecord)
    if not db.profile.cttMenuOptions.togglePrint then return end
    if db.profile.cttMenuOptions.dropdownValue == 1 then
        if newRecord then 
            CTT:Print(L["New Record! Fight ended in "] .. db.profile.cttMenuOptions.timeValues[4] .. "." .. db.profile.cttMenuOptions.timeValues[5] .. " " .. L["seconds"] .. "!")
        else
            CTT:Print(L["Fight ended in "] .. db.profile.cttMenuOptions.timeValues[4] .. "." .. db.profile.cttMenuOptions.timeValues[5] .. " ".. L["seconds"] .. ".")
        end
    elseif db.profile.cttMenuOptions.dropdownValue == 2 then
        if newRecord then
            CTT:Print(L["New Record! Fight ended in "] .. "(MM:SS.MS): " .. db.profile.cttMenuOptions.timeValues[2] .. ":" .. db.profile.cttMenuOptions.timeValues[3] .. "." .. db.profile.cttMenuOptions.timeValues[5] .. "!")
        else
            CTT:Print(L["Fight ended in "] .. "(MM:SS.MS): " .. db.profile.cttMenuOptions.timeValues[2] .. ":" .. db.profile.cttMenuOptions.timeValues[3] .. "." .. db.profile.cttMenuOptions.timeValues[5] .. ".")
        end
    else
        if newRecord then
            CTT:Print(L["New Record! Fight ended in "] .. "(HH:MM:SS.MS): " .. db.profile.cttMenuOptions.timeValues[1] .. ":" .. db.profile.cttMenuOptions.timeValues[2] .. ":" .. db.profile.cttMenuOptions.timeValues[3] .. "." .. db.profile.cttMenuOptions.timeValues[5] .. "!")
        else
            CTT:Print(L["Fight ended in "] .. "(HH:MM:SS.MS): " .. db.profile.cttMenuOptions.timeValues[1] .. ":" .. db.profile.cttMenuOptions.timeValues[2] .. ":" .. db.profile.cttMenuOptions.timeValues[3] .. "." .. db.profile.cttMenuOptions.timeValues[5] .. ".")
        end
    end
end

-- function to fix display results on a boss encounter ending
function CTT_DisplayResultsBosses(bossEncounter, wasAKill)
    if not db.profile.cttMenuOptions.togglePrint then return end
    if db.profile.cttMenuOptions.dropdownValue == 1 then
        if wasAKill then
            CTT:Print(L["You have successfully killed "] .. bossEncounter .. " " .. L["after"] .. " " .. totalSeconds .. "." .. miliseconds .. " " .. L["seconds"] .. "!")
        else
            CTT:Print(L["You have wiped on "] .. bossEncounter .. L["after"] .. " " .. totalSeconds .. "." .. miliseconds ..".")
        end
    elseif db.profile.cttMenuOptions.dropdownValue == 2 then
        if wasAKill then
            CTT:Print(L["You have successfully killed "] .. bossEncounter .. " " .. L["after"] .. " " .. minutes .. ":" .. seconds .. "." .. miliseconds .. "!")
        else
            CTT:Print(L["You have wiped on "] .. bossEncounter .. " " .. L["after"] .. " " .. minutes .. ":" .. seconds .. "." .. miliseconds .. ".")
        end
    else
        if wasAKill then
            CTT:Print(L["You have successfully killed "] .. bossEncounter .. " " .. L["after"] .. " " .. hours .. ":" .. minutes .. ":" .. seconds .. "." .. miliseconds .. ".")
        else
            CTT:Print(L["You have wiped on "] .. bossEncounter .. " " .. L["after"] .. " " .. hours .. ":" .. minutes .. ":" .. seconds .. "." .. miliseconds .. ".")
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
            cttStopwatchGuiTimeText:SetText(totalSeconds)-- .. "." .. miliseconds)
        else
            cttStopwatchGuiTimeText:SetText(seconds)-- .. "." .. miliseconds)
        end
    elseif textFormat == 2 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds)-- .. "." .. miliseconds)
    elseif textFormat == 4 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds .. "." .. miliseconds)
    elseif textFormat == 5 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds .. ":" .. miliseconds)
    else
        cttStopwatchGuiTimeText:SetText(hours .. ":" .. minutes .. ":" .. seconds)-- .. "." .. miliseconds)
    end
end

function CTT_UpdateMenuTexts(container,difficultyNumber)
    if difficultyNumber == 1 then
        difficultyNumber = 0
    elseif difficultyNumber == 2 then
        difficultyNumber = 9
    elseif difficultyNumber == 3 then
        difficultyNumber = 18
    else
        difficultyNumber = 27
    end

    container.CoLTime:SetText(fightLogs[1+difficultyNumber])
    container.GrongTime:SetText(fightLogs[2+difficultyNumber])
    container.MonksTime:SetText(fightLogs[3+difficultyNumber])
    container.OpulenceTime:SetText(fightLogs[4+difficultyNumber])
    container.CouncilTime:SetText(fightLogs[5+difficultyNumber])
    container.KingTime:SetText(fightLogs[6+difficultyNumber])
    container.MekkaTime:SetText(fightLogs[7+difficultyNumber])
    container.StormwallTime:SetText(fightLogs[8+difficultyNumber])
    container.IceBitchTime:SetText(fightLogs[9+difficultyNumber])
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

    container.CabalTime:SetText(cosFightLogs[1+difficultyNumber])
    container.UunatTime:SetText(cosFightLogs[2+difficultyNumber])
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

    container.ACSTime:SetText(tepFightLogs[1+difficultyNumber])
    container.BBTime:SetText(tepFightLogs[2+difficultyNumber])
    container.RoATime:SetText(tepFightLogs[3+difficultyNumber])
    container.LATime:SetText(tepFightLogs[4+difficultyNumber])
    container.OTime:SetText(tepFightLogs[5+difficultyNumber])
    container.TQCTime:SetText(tepFightLogs[6+difficultyNumber])
    container.ZHoNTime:SetText(tepFightLogs[7+difficultyNumber])
    container.QATime:SetText(tepFightLogs[8+difficultyNumber])
end


--|-----------------------|
--| AceGUI Options Menu --|
--|-----------------------|

-- function to toggle the options menu
function CTT_ToggleMenu()
    if UnitAffectingCombat("player") or bossEncounter then
        loadOptionsAfterCombat = true
        CTT:Print("Options menu cannot be loaded while in combat, try again after combat has ended!")
    else
        if not CTT.menu then CTT:CreateOptionsMenu() end
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
    db.profile.cttMenuOptions.textColorPicker = {r,g,b,a}
    cttStopwatchGuiTimeText:SetTextColor(r,g,b,a)
end

function CTT_DropdownState(widget, event, key, checked)
    db.profile.cttMenuOptions.dropdownValue = key
    CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2], db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5], db.profile.cttMenuOptions.dropdownValue,1)
end

-- function to handle the sliding of the slider, this fires anytime the slider moves
function CTT_ResizeFrameSliderUpdater(widget, event, value)
    db.profile.cttMenuOptions.textFrameSizeSlider = value
    local multiplier = value
    local width = 100 + (multiplier * 100)
    local height = 40 + (multiplier * 40)
    local fontVal = 16 + (multiplier * 16)
    cttStopwatchGui:SetWidth(width)
    cttStopwatchGui:SetHeight(height)
    cttStopwatchGuiTimeText:SetSize(width, height)
    if db.profile.cttMenuOptions.fontName then
        cttStopwatchGuiTimeText:SetFont(db.profile.cttMenuOptions.fontName,fontVal)
        db.profile.cttMenuOptions.fontVal = fontVal
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf",fontVal)
        db.profile.cttMenuOptions.fontVal = fontVal
    end
end

-- function to update the tracker size from user settings on login
function CTT_SetTrackerSizeOnLogin()
    if table.getn(db.profile.cttMenuOptions.timeTrackerSize) == 2 and db.profile.cttMenuOptions.fontVal and db.profile.cttMenuOptions.fontName and db.profile.cttMenuOptions.backDropAlphaSlider then
        cttStopwatchGui:SetWidth(db.profile.cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(db.profile.cttMenuOptions.timeTrackerSize[1], db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(db.profile.cttMenuOptions.fontName,db.profile.cttMenuOptions.fontVal)
        cttStopwatchGui:SetBackdrop(backdropSettings)
        cttStopwatchGui:SetBackdropColor(0,0,0,db.profile.cttMenuOptions.backDropAlphaSlider)
        cttStopwatchGui:SetBackdropBorderColor(255,255,255,db.profile.cttMenuOptions.backDropAlphaSlider)
        cttStopwatchGuiTimeText:SetTextColor(db.profile.cttMenuOptions.textColorPicker[1], db.profile.cttMenuOptions.textColorPicker[2], db.profile.cttMenuOptions.textColorPicker[3], db.profile.cttMenuOptions.textColorPicker[4])
        cttStopwatchGui:ClearAllPoints()
        cttStopwatchGui:SetPoint(db.profile.cttMenuOptions.framePoint, nil, db.profile.cttMenuOptions.frameRelativePoint, db.profile.cttMenuOptions.xOfs, db.profile.cttMenuOptions.yOfs)
    else
        cttStopwatchGuiTimeText:SetFont("Fonts\\MORPHEUS.ttf", 16)
        db.profile.cttMenuOptions.fontVal = fontVal
    end
end

-- SetCallBack function that handles when the person stops sliding the slider
function CTT_ResizeFrameSliderDone(widget, event, value)
    db.profile.cttMenuOptions.textFrameSizeSlider = value
    db.profile.cttMenuOptions.timeTrackerSize = {cttStopwatchGui:GetWidth(), cttStopwatchGui:GetHeight()}
end

-- Callback function for the font picker dropdown
function CTT_FontPickerDropDownState(widget, event, key, checked)
    db.profile.cttMenuOptions.fontPickerDropDown = key
    db.profile.cttMenuOptions.fontName = LSM:Fetch("font", fontTableOptions[key])
    if table.getn(db.profile.cttMenuOptions.timeTrackerSize) == 2 and db.profile.cttMenuOptions.fontVal and db.profile.cttMenuOptions.fontName then
        cttStopwatchGui:SetWidth(db.profile.cttMenuOptions.timeTrackerSize[1])
        cttStopwatchGui:SetHeight(db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetSize(db.profile.cttMenuOptions.timeTrackerSize[1], db.profile.cttMenuOptions.timeTrackerSize[2])
        cttStopwatchGuiTimeText:SetFont(db.profile.cttMenuOptions.fontName,db.profile.cttMenuOptions.fontVal)
        CTT_UpdateText(db.profile.cttMenuOptions.timeValues[1], db.profile.cttMenuOptions.timeValues[2], db.profile.cttMenuOptions.timeValues[3], db.profile.cttMenuOptions.timeValues[5], db.profile.cttMenuOptions.dropdownValue, 2)
    end
end

-- callback for the backdrop opacity slider while moving
function CTT_BackDropSliderOnValueChanged(widget, event, value)
    db.profile.cttMenuOptions.backDropAlphaSlider = value
    cttStopwatchGui:SetBackdropColor(0,0,0,value)
    cttStopwatchGui:SetBackdropBorderColor(255,255,255,value)
end

-- callback for the backdrop opacity slider when dont moving
function CTT_BackDropSliderDone(widget, event, value)
    db.profile.cttMenuOptions.backDropAlphaSlider = value
end

function CTT_MinimapIconCheckButton(widget, event, value)
    db.profile.cttMenuOptions.minimapIconCheckButton = value
    if db.profile.cttMenuOptions.minimapIconCheckButton then
        db.minimap.hide = true
        icon:Hide("CombatTimeTracker")
    else
        db.minimap.hide = false
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

function CTT_TogglePrintCheckButton(widget, event, value)
    db.profile.cttMenuOptions.togglePrint = value;
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
        CTT_UpdateMenuTexts(menu.tab,key)
    elseif key == 2 then
        -- TODO normal times
        CTT_UpdateMenuTexts(menu.tab,key)
    elseif key == 3 then
        -- TODO heroic times
        CTT_UpdateMenuTexts(menu.tab,key)
    else
        -- TODO mythic times
        CTT_UpdateMenuTexts(menu.tab,key)
    end
end

function CTT_cosDifficultyDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.difficultyDropDown2 = key
    if key == 1 then
        -- TODO LFR times
        CTT_CoSUpdateMenuTexts(menu.tab,key)
    elseif key == 2 then
        -- TODO normal times
        CTT_CoSUpdateMenuTexts(menu.tab,key)
    elseif key == 3 then
        -- TODO heroic times
        CTT_CoSUpdateMenuTexts(menu.tab,key)
    else
        -- TODO mythic times
        CTT_CoSUpdateMenuTexts(menu.tab,key)
    end
end

function CTT_tepDifficultyDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.difficultyDropDown3 = key
    if key == 1 then
        -- TODO LFR times
        CTT_tepUpdateMenuTexts(menu.tab,key)
    elseif key == 2 then
        -- TODO normal times
        CTT_tepUpdateMenuTexts(menu.tab,key)
    elseif key == 3 then
        -- TODO heroic times
        CTT_tepUpdateMenuTexts(menu.tab,key)
    else
        -- TODO mythic times
        CTT_tepUpdateMenuTexts(menu.tab,key)
    end
end

function CTT_PlaySoundOnDropDownSelect(widget, event, key, checked)
    db.profile.cttMenuOptions.soundDropDownValue = key
    db.profile.cttMenuOptions.soundName = LSM:Fetch("sound", soundTableOptions[key])
    PlaySoundFile(LSM:Fetch("sound", soundTableOptions[key]), "Master")
end

function CTT_AlertTimeOnEnterPressed(widget, event, text)
    db.profile.cttMenuOptions.localStore = text
end

function CTT_AlertRaidDropDown(widget, event, key, checked)
    db.profile.cttMenuOptions.raidKey = key
    db.profile.cttMenuOptions.raidDropdown = raidInstanceZones[key]
    CTT.menu.tab:SelectTab("alerts")
end

function CTT_AlertBossDropDown(widget, event, key, checked)
    CTT:Print(db.profile.cttMenuOptions.raidKey)
    if db.profile.cttMenuOptions.raidKey == 2 then
        db.profile.cttMenuOptions.bossDropdown = bossesSOD[key]
        db.profile.cttMenuOptions.bossDropDownkey = key
    else
        db.profile.cttMenuOptions.bossDropdown = bosses[key]
        db.profile.cttMenuOptions.bossDropDownkey = key
    end
end

function CTT_AlertAddButtonClicked(widget, event)
    local timeInSeconds = isInt(db.profile.cttMenuOptions.localStore)
    local key = 0
    if db.profile.cttMenuOptions.alerts[table.getn(db.profile.cttMenuOptions.alerts)] ~= {} then key = 1 end
    if db.profile.cttMenuOptions.localStore ~= nil and timeInSeconds and db.profile.cttMenuOptions.raidDropdown ~= nil and db.profile.cttMenuOptions.bossDropdown ~= nil then
        db.profile.cttMenuOptions.alerts[table.getn(db.profile.cttMenuOptions.alerts) + key] = { tonumber(db.profile.cttMenuOptions.localStore), db.profile.cttMenuOptions.raidDropdown, db.profile.cttMenuOptions.bossDropdown, db.profile.cttMenuOptions.bossDropDownkey }
        CTT.menu.tab:SelectTab("alerts")
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
    table.remove( db.profile.cttMenuOptions.alerts, key)
    CTT.menu.tab:SelectTab("alerts")
end

function CTT_AlertsErrorPopup(errorCode)
    local text = "You must enter values!"

    if errorCode == 1 then
        text = "You must enter a valid time in seconds (no decimal vaues!!! e.g. 100 not 100.1)!"
    elseif errorCode == 2 then
        text = "You must select a raid!"
    elseif errorCode == 3 then
        text = "You must select a boss!"
    end

    StaticPopupDialogs["AlertError"] = {
        text = text,
        button1 = "Ok",
        -- button2 = "Reset Later",
        OnAccept = function() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show ("AlertError")
end

function CTT_ProfileNameOnEnterPressed(widget, event, text)
    local textToUse = string.gsub( text, "^%s*(.-)%s*$", "%1")
    if textToUse ~= nil and textToUse ~= "" then
        newProfileName = text
    else
        StaticPopupDialogs["ProfileNameError"] = {
            text = "You have entered and invalid profile name, please try again!",
            button1 = "Ok",
            -- button2 = "Reset Later",
            OnAccept = function() end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show ("ProfileNameError")
    end
end

function CTT_ProfileDropDownPicker(widget, event, key)
    activeProfileKey = key
    activeProfile = db:GetProfiles()[key]
    db:SetProfile(db:GetProfiles()[key])
    CTT.menu.tab:SelectTab("options")
    CTT:Print(activeProfile .. " profile is now the active profile!")
    CTT_SetTrackerSizeOnLogin()
end

function CTT_ProfileAddButton(widget, event)
    activeProfile = newProfileName
    db:SetProfile(newProfileName)
    CTT:Print("New profile with the name of " .. newProfileName .. " has been created!")
    CTT.menu.tab:SelectTab("options")
end

function CTT_ProfileCopyDropdown(widget, event, key)
    CTT:Print(activeProfile .. " has been updated to a copy of " .. db:GetProfiles()[key] .. "!")
    db:CopyProfile(db:GetProfiles()[key], true)
    CTT.menu.tab:SelectTab("options")
end

function CTT_ProfileDeleteDropdown(widget, event, key)
    CTT:Print(db:GetProfiles()[key] .. " profile has been deleted!")
    db:DeleteProfile(db:GetProfiles()[key], true)
    CTT.menu.tab:SelectTab("options")
end

--|-----------------------|
--| AceGUI Raid Bosses  --|
--|-----------------------|


--function that draws the widgets for the first tab
local function OptionsMenu(container)
    -- frame lock button
    local lockFrameCheckButton = AceGUI:Create("CheckBox")
    lockFrameCheckButton:SetLabel(L["Lock"])
    lockFrameCheckButton:SetWidth(60)
    lockFrameCheckButton:SetHeight(22)
    lockFrameCheckButton:SetType("checkbox")
    lockFrameCheckButton:ClearAllPoints()
    if db.profile then lockFrameCheckButton:SetValue(db.profile.cttMenuOptions.lockFrameCheckButton) end
    lockFrameCheckButton:SetPoint("TOPLEFT", container.tab, "TOPLEFT", 6, 0)
    lockFrameCheckButton:SetCallback("OnValueChanged",CTT_LockFrameCheckBoxState)
    container:AddChild(lockFrameCheckButton)
    container.lockFrameCheckButton = lockFrameCheckButton

    local minimapIconCheckButton = AceGUI:Create("CheckBox")
    minimapIconCheckButton:SetLabel("Hide Minimap")
    minimapIconCheckButton:SetWidth(110)
    minimapIconCheckButton:SetHeight(22)
    minimapIconCheckButton:SetType("checkbox")
    minimapIconCheckButton:ClearAllPoints()
    if db.profile.cttMenuOptions.minimapIconCheckButton then 
        minimapIconCheckButton:SetValue(db.profile.cttMenuOptions.minimapIconCheckButton)
    else
        minimapIconCheckButton:SetValue(false)
    end
    minimapIconCheckButton:SetPoint("TOPLEFT", container.tab, "TOPLEFT", 6, 0)
    --minimapIconCheckButton:SetCallBack("OnValueChanged", CTT_MinimapIconCheckButton)
    minimapIconCheckButton:SetCallback("OnValueChanged",CTT_MinimapIconCheckButton)
    container:AddChild(minimapIconCheckButton)
    container.minimapIconCheckButton = minimapIconCheckButton

    local toggleTarget = AceGUI:Create("CheckBox")
    toggleTarget:SetLabel("Show Target")
    toggleTarget:SetWidth(100)
    toggleTarget:SetHeight(22)
    toggleTarget:SetType("checkbox")
    toggleTarget:ClearAllPoints()
    if db.profile.cttMenuOptions.toggleTarget then 
        toggleTarget:SetValue(db.profile.cttMenuOptions.toggleTarget)
    else
        toggleTarget:SetValue(true)
    end
    toggleTarget:SetPoint("TOPLEFT", container.tab, "TOPLEFT", 6, 0)
    toggleTarget:SetCallback("OnValueChanged",CTT_ToggleTargetCheckButton)
    container:AddChild(toggleTarget)
    container.toggleTarget = toggleTarget

    -- toggle printing
    local togglePrint = AceGUI:Create("CheckBox")
    togglePrint:SetLabel("Toggle Messages")
    togglePrint:SetWidth(140)
    togglePrint:SetHeight(22)
    togglePrint:SetType("checkbox")
    togglePrint:ClearAllPoints()
    if db.profile.cttMenuOptions.togglePrint then 
        togglePrint:SetValue(db.profile.cttMenuOptions.togglePrint)
    else
        togglePrint:SetValue(true)
    end
    togglePrint:SetPoint("TOPLEFT", container.tab, "TOPLEFT", 6, 0)
    togglePrint:SetCallback("OnValueChanged", CTT_TogglePrintCheckButton)
    container:AddChild(togglePrint)
    container.togglePrint = togglePrint

    -- color picker
    local textColorPicker = AceGUI:Create("ColorPicker")
    if db.profile.cttMenuOptions.textColorPicker then 
        textColorPicker:SetColor(db.profile.cttMenuOptions.textColorPicker[1], db.profile.cttMenuOptions.textColorPicker[2], db.profile.cttMenuOptions.textColorPicker[3], db.profile.cttMenuOptions.textColorPicker[4]) 
    else
        textColorPicker:SetColor(255,255,255)
    end
    textColorPicker:SetLabel(L["Text Color"])
    textColorPicker:ClearAllPoints()
    textColorPicker:SetPoint("TOPLEFT", container.tab, "TOPLEFT", 6, 0)
    textColorPicker:SetCallback("OnValueConfirmed", CTT_ColorPickerConfirmed)
    container:AddChild(textColorPicker)
    container.textColorPicker = textColorPicker

    -- different text options
    local textStyleDropDown = AceGUI:Create("Dropdown")
    textStyleDropDown:SetLabel(L["Text Format"])
    textStyleDropDown:SetWidth(125)
    textStyleDropDown:SetMultiselect(false)
    textStyleDropDown:ClearAllPoints()
    textStyleDropDown:SetList(db.profile.cttMenuOptions.cttTextFormatOptions)
    textStyleDropDown:SetText(db.profile.cttMenuOptions.cttTextFormatOptions[db.profile.cttMenuOptions.dropdownValue])
    textStyleDropDown:SetValue(db.profile.cttMenuOptions.dropdownValue)
    textStyleDropDown:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    textStyleDropDown:SetCallback("OnValueChanged", CTT_DropdownState)
    container:AddChild(textStyleDropDown)
    container.textStyleDropDown = textStyleDropDown

    -- slider for changing the size of the tracker and text
    local textFrameSizeSlider = AceGUI:Create("Slider")
    textFrameSizeSlider:SetLabel(L["Tracker Size"])
    textFrameSizeSlider:SetWidth(150)
    textFrameSizeSlider:SetIsPercent(true)
    if db.profile.cttMenuOptions.textFrameSizeSlider then textFrameSizeSlider:SetValue(db.profile.cttMenuOptions.textFrameSizeSlider) end
    textFrameSizeSlider:SetSliderValues(0,1,.01)
    textFrameSizeSlider:ClearAllPoints()
    textFrameSizeSlider:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    textFrameSizeSlider:SetCallback("OnValueChanged", CTT_ResizeFrameSliderUpdater)
    textFrameSizeSlider:SetCallback("OnMouseUp", CTT_ResizeFrameSliderDone)
    container:AddChild(textFrameSizeSlider)
    container.textFrameSizeSlider = textFrameSizeSlider

    -- Slider for the opacity of the backdrop and/or border
    local backDropAlphaSlider = AceGUI:Create("Slider")
    backDropAlphaSlider:SetLabel(L["Backdrop Opacity"])
    backDropAlphaSlider:SetWidth(150)
    backDropAlphaSlider:SetIsPercent(true)
    if db.profile.cttMenuOptions.backDropAlphaSlider then backDropAlphaSlider:SetValue(db.profile.cttMenuOptions.backDropAlphaSlider) else backDropAlphaSlider:SetValue(1) end
    backDropAlphaSlider:SetSliderValues(0,1,.01)
    backDropAlphaSlider:ClearAllPoints()
    backDropAlphaSlider:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    backDropAlphaSlider:SetCallback("OnValueChanged", CTT_BackDropSliderOnValueChanged)
    backDropAlphaSlider:SetCallback("OnMouseUp", CTT_BackDropSliderDone)
    container:AddChild(backDropAlphaSlider)
    container.backDropAlphaSlider = backDropAlphaSlider

    -- Dropdown for different font options
    local fontPickerDropDown = AceGUI:Create("Dropdown")
    fontPickerDropDown:SetLabel(L["Choose Font"])
    fontPickerDropDown:SetWidth(250)
    fontPickerDropDown:SetMultiselect(false)
    fontPickerDropDown:ClearAllPoints()
    fontPickerDropDown:SetList(LSM:List("font"))
    if db.profile.cttMenuOptions.fontName and db.profile.cttMenuOptions.fontPickerDropDown then 
        fontPickerDropDown:SetText(fontTableOptions[db.profile.cttMenuOptions.fontPickerDropDown])
        fontPickerDropDown:SetValue(db.profile.cttMenuOptions.fontPickerDropDown)
    else
        fontPickerDropDown:SetText("Morpheus")
        fontPickerDropDown:SetValue(fontDropDownMorpheus)
    end
    fontPickerDropDown:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    fontPickerDropDown:SetCallback("OnValueChanged", CTT_FontPickerDropDownState)
    container:AddChild(fontPickerDropDown)
    container.fontPickerDropDown = fontPickerDropDown

    -- Dropdown for different options to show the tracker
    local instanceType = AceGUI:Create("Dropdown")
    instanceType:SetLabel("Show Tracker When?")
    instanceType:SetWidth(150)
    instanceType:SetMultiselect(false)
    instanceType:ClearAllPoints()
    instanceType:SetList(instanceTypes)
    --TODO add conditionals to display the menu text as needed once list is made
    if db.profile.cttMenuOptions.instanceType then
        instanceType:SetText(instanceTypes[db.profile.cttMenuOptions.instanceType])
        instanceType:SetValue(db.profile.cttMenuOptions.instanceType)
    else
        instanceType:SetText(instanceType[4])
        instanceType:SetValue(4)
    end
    instanceType:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    instanceType:SetCallback("OnValueChanged", CTT_InstanceTypeDropDown)
    container:AddChild(instanceType)
    container.instanceType = instanceType

    -- Dropdown for different sound options
    local soundPickerDropDown = AceGUI:Create("Dropdown")
    soundPickerDropDown:SetLabel("Choose Sound")
    soundPickerDropDown:SetWidth(250)
    soundPickerDropDown:SetMultiselect(false)
    soundPickerDropDown:ClearAllPoints()
    soundPickerDropDown:SetList(LSM:List("sound"))
    if db.profile.cttMenuOptions.soundName and db.profile.cttMenuOptions.soundDropDownValue then 
        soundPickerDropDown:SetText(soundTableOptions[db.profile.cttMenuOptions.soundDropDownValue])
        soundPickerDropDown:SetValue(db.profile.cttMenuOptions.soundDropDownValue)
    else
        soundPickerDropDown:SetText("")
        soundPickerDropDown:SetValue(1)
    end
    soundPickerDropDown:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    soundPickerDropDown:SetCallback("OnValueChanged", CTT_PlaySoundOnDropDownSelect)
    container:AddChild(soundPickerDropDown)
    container.soundPickerDropDown = soundPickerDropDown

    local profileName = AceGUI:Create("EditBox")
    profileName:SetLabel("New Profile Name")
    profileName:ClearAllPoints()
    profileName:SetPoint("LEFT", container.tab, "LEFT", 10, 0)
    profileName:SetCallback("OnEnterPressed", CTT_ProfileNameOnEnterPressed)
    container:AddChild(profileName)
    container.profileName = profileName

    local profileAddButton = AceGUI:Create("Button")
    profileAddButton:SetText("Create Profile")
    profileAddButton:SetWidth(125)
    profileAddButton:ClearAllPoints()
    profileAddButton:SetPoint("LEFT", container.tab, "LEFT", 6, 10)
    profileAddButton:SetCallback("OnClick", CTT_ProfileAddButton)
    container:AddChild(profileAddButton)
    container.profileAddButton = profileAddButton

    local profileDropDownPicker = AceGUI:Create("Dropdown")
    profileDropDownPicker:SetLabel("Choose Profile")
    profileDropDownPicker:SetMultiselect(false)
    profileDropDownPicker:ClearAllPoints()
    profileDropDownPicker:SetList(db:GetProfiles())

    profileDropDownPicker:SetValue(activeProfileKey)
    profileDropDownPicker:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    profileDropDownPicker:SetCallback("OnValueChanged", CTT_ProfileDropDownPicker)
    container:AddChild(profileDropDownPicker)
    container.profileDropDownPicker = profileDropDownPicker

    local profileCopyDropdown = AceGUI:Create("Dropdown")
    profileCopyDropdown:SetLabel("Copy Profile")
    profileCopyDropdown:SetMultiselect(false)
    profileCopyDropdown:ClearAllPoints()
    profileCopyDropdown:SetList(db:GetProfiles())
    profileCopyDropdown:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    profileCopyDropdown:SetCallback("OnValueChanged", CTT_ProfileCopyDropdown)
    container:AddChild(profileCopyDropdown)
    container.profileCopyDropdown = profileCopyDropdown

    local profileDeleteDropdown = AceGUI:Create("Dropdown")
    profileDeleteDropdown:SetLabel("Delete Profile")
    profileDeleteDropdown:SetMultiselect(false)
    profileDeleteDropdown:ClearAllPoints()
    profileDeleteDropdown:SetList(db:GetProfiles())
    profileDeleteDropdown:SetPoint("LEFT", container.tab, "LEFT", 6, 0)
    profileDeleteDropdown:SetCallback("OnValueChanged", CTT_ProfileDeleteDropdown)
    container:AddChild(profileDeleteDropdown)
    container.profileDeleteDropdown = profileDeleteDropdown

end
    
-- function that draws the dungeons tab
local function Dungeons(container)
    local Label = AceGUI:Create("Label")
    Label:SetText("Feature Coming Soon!!")
    Label:SetColor(255,255,0)
    Label:SetFont("Fonts\\MORPHEUS_CYR.TTF", 12)
    Label:SetWidth(112)
    Label:ClearAllPoints()
    Label:SetPoint("LEFT", container.tab, "LEFT", 6, 10)
    container:AddChild(Label)
    container.Label = Label
end

-- function that draws the raid tab
local function Raids(container)
    local Label = AceGUI:Create("Label")
    Label:SetText("Feature Coming Soon!!")
    Label:SetColor(255,255,0)
    Label:SetFont("Fonts\\MORPHEUS_CYR.TTF", 12)
    Label:SetWidth(112)
    Label:ClearAllPoints()
    Label:SetPoint("LEFT", container.tab, "LEFT", 6, 10)
    container:AddChild(Label)
    container.Label = Label
end

-- function that draws the Alert Times tab
local function Alerts(container)
    -- db.profile.cttMenuOptions.bossDropdown = bosses[1]
    -- db.profile.cttMenuOptions.raidDropdown = raidInstanceZones[1]
    -- Input field to get the time (in seconds)
    local timeInput = AceGUI:Create("EditBox")
    timeInput:SetLabel("Alert Time(seconds)")
    timeInput:SetWidth(115)
    timeInput:ClearAllPoints()
    if db.profile.cttMenuOptions.localStore then timeInput:SetText(db.profile.cttMenuOptions.localStore) end
    timeInput:SetPoint("LEFT", container.tab, "LEFT", 6, 10)
    timeInput:SetCallback("OnEnterPressed", CTT_AlertTimeOnEnterPressed)
    container:AddChild(timeInput)
    container.timeInput = timeInput

    -- Select Raid
    local raidDropdown = AceGUI:Create("Dropdown")
    raidDropdown:SetLabel("Select Raid")
    raidDropdown:SetMultiselect(false)
    raidDropdown:SetList(raidInstanceZones)
    raidDropdown:SetText(raidInstanceZones[db.profile.cttMenuOptions.raidKey])
    raidDropdown:SetValue(db.profile.cttMenuOptions.raidKey)
    raidDropdown:SetWidth(125)
    raidDropdown:ClearAllPoints()
    raidDropdown:SetPoint("LEFT", container.tab, "LEFT", 6, 10)
    raidDropdown:SetCallback("OnValueChanged", CTT_AlertRaidDropDown)
    container:AddChild(raidDropdown)
    container.raidDropdown = raidDropdown

    -- Select Boss
    local bossDropdown = AceGUI:Create("Dropdown")
    bossDropdown:SetLabel("Select Boss")
    bossDropdown:SetMultiselect(false)
    if db.profile.cttMenuOptions.raidKey == 1 then
        bossDropdown:SetList(bosses)
        bossDropdown:SetText(bosses[db.profile.cttMenuOptions.bossDropDownkey])
        bossDropdown:SetValue(db.profile.cttMenuOptions.bossDropDownkey)
    else
        bossDropdown:SetList(bossesSOD)
        bossDropdown:SetText(bossesSOD[db.profile.cttMenuOptions.bossDropDownkey])
        bossDropdown:SetValue(db.profile.cttMenuOptions.bossDropDownkey)
    end
    bossDropdown:SetWidth(125)
    bossDropdown:ClearAllPoints()
    bossDropdown:SetPoint("LEFT", container.tab, "LEFT", 6, 10)
    bossDropdown:SetCallback("OnValueChanged", CTT_AlertBossDropDown)
    container:AddChild(bossDropdown)
    container.bossDropdown = bossDropdown

    -- Add alert to list
    local addAlertButton = AceGUI:Create("Button")
    addAlertButton:SetText("Add")
    addAlertButton:SetWidth(75)
    addAlertButton:ClearAllPoints()
    addAlertButton:SetPoint("LEFT", container.tab, "LEFT", 6, 10)
    addAlertButton:SetCallback("OnClick", CTT_AlertAddButtonClicked)
    container:AddChild(addAlertButton)
    container.addAlertButton = addAlertButton

    -- scroll frame for timers
    scrollcontainer = AceGUI:Create("InlineGroup") -- "InlineGroup" is also good
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetFullHeight(true) -- probably?
    scrollcontainer:SetLayout("Fill") -- important!

    container:AddChild(scrollcontainer)

    scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow") -- probably?
    scroll:SetStatusTable(db.profile.cttMenuOptions.alerts)
    scrollcontainer:AddChild(scroll)

    

    for i,v in ipairs(db.profile.cttMenuOptions.alerts) do
        local value = "value".. i
        value = AceGUI:Create("Label")
        value:SetText("Seconds into fight: " .. db.profile.cttMenuOptions.alerts[i][1] .. ", Raid: " .. db.profile.cttMenuOptions.alerts[i][2] .. ", Boss: " .. db.profile.cttMenuOptions.alerts[i][3])
        value:SetColor(255,255,0)
        value:SetFont("Fonts\\MORPHEUS_CYR.TTF", 10)
        if(table.getn(db.profile.cttMenuOptions.alerts) > 10) then
            value:SetWidth(350)
        else
            value:SetWidth(375)
        end
        value:ClearAllPoints()
        value:SetPoint("LEFT", nil, "LEFT", 6, 10)
        scroll:AddChild(value)

        local deleteBtn = "btn" .. i 
        deleteBtn = AceGUI:Create("Button")
        deleteBtn:SetText("X")
        deleteBtn:SetWidth(40)
        deleteBtn:ClearAllPoints()
        deleteBtn:SetPoint("LEFT", nil, "LEFT", 6, 10)
        deleteBtn:SetCallback("OnClick", function(widget) CTT_AlertDeleteButtonClicked(widget, event, i) end )
        scroll:AddChild(deleteBtn)
    end

    
end

local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "options" then
        OptionsMenu(container)
    elseif group == "dungeons" then
        Dungeons(container)
    elseif group == "raids" then
        Raids(container)
    elseif group == "alerts" then
        Alerts(container)
    end
end
function CTT:CreateOptionsMenu()
    -- main menu frame
    menu = AceGUI:Create("Frame")
    menu:SetTitle("Combat Time Tracker Options")
    menu:SetStatusText(GetAddOnMetadata("CombatTimeTracker", "Version"))
    menu:SetWidth(500)
    menu:SetHeight(500)
    menu:SetLayout("Fill")
    -- menu:SetCallBack("OnGroupSelected", CTT_SelectGroup)
    menu:Hide()
    CTT.menu = menu

    CTT_menu = menu.frame
    menu.frame:SetMaxResize(500, 500)
    menu.frame:SetMinResize(500, 500)
    menu.frame:SetFrameStrata("HIGH")
    menu.frame:SetFrameLevel(1)

    -- Create the TabGroup
    local tab =  AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    -- Setup which tabs to show
    tab:SetTabs({{text="Options", value="options"}, {text="Dungeons", value="dungeons"}, {text="Raids", value="raids"}, {text="Alert Times", value="alerts"}})
    -- Register callback
    tab:SetCallback("OnGroupSelected", SelectGroup)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("options")
    
    -- add to the frame container
    menu:AddChild(tab)
    menu.tab = tab

    -- Add frame to the global variable table so that pressing escape key closes the menu frame
    _G["CombatTimeTrackerMenu"] = menu.frame
    tinsert(UISpecialFrames, "CombatTimeTrackerMenu")
end


--|-----------------------|
--|  CTT Debug Functions  |
--|-----------------------|

--@debug@
--@end-debug@