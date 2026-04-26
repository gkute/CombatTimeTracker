--|------------------------|
--| Utility Functions      |
--|------------------------|

-- Helper to calculate time parts from elapsed seconds
function CalculateTimeParts(elapsed)
    local totalCs = math.floor(elapsed * 100)  -- centiseconds, integer from here down
    local total   = math.floor(totalCs / 100)
    local ms = totalCs % 100
    local s  = total % 60
    local m  = math.floor(total / 60) % 60
    local h  = math.floor(total / 3600)
    return string.format("%02d", h), string.format("%02d", m), string.format("%02d", s), tostring(total), string.format("%02d", ms)
end

-- function to check if a ui reset is needed.
function CTT_CheckForReload()
    if CTT.db.profile.cttMenuOptions.lastVersion == nil then
        CTT.db.profile.cttMenuOptions.uiReset = true
        CTT.db.profile.cttMenuOptions.lastVersion = C_AddOns.GetAddOnMetadata("CombatTimeTracker", "Version")
    else
        CTT.db.profile.cttMenuOptions.uiReset = false
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
    local num = tonumber(n)
    return num ~= nil and math.floor(num) == num
end

-- Function To check for players current target
function CTT_CheckForTarget()
    if not CTT.db.profile.cttMenuOptions.toggleTarget then return end
    local target = GetUnitName("Target", false)
    if target ~= nil then
        cttStopwatchGuiTargetText:SetText(target)
        cttStopwatchGuiTargetText:Show()
    else
        cttStopwatchGuiTargetText:Hide()
    end
end

function CTT_CheckToPlaySound()
    if not CTT.bossEncounter then return end
    for k, v in pairs(CTT.db.profile.cttMenuOptions.alerts) do
        if k ~= "scrollvalue" and k ~= "offset" and
            CTT.db.profile.cttMenuOptions.alerts[k][4] == CTT.bossEncounterName and
            tonumber(CTT.totalSeconds) == CTT.db.profile.cttMenuOptions.alerts[k][1] then
            CTT.lastBossSoundPlayed = CTT.totalSeconds
            PlaySoundFile(CTT.LSM:Fetch("sound", CTT.soundTableOptions[CTT.db.profile.cttMenuOptions.soundDropDownValue]), "Master")
        end
    end
end

-- function to handle showing the tracker based on instance type settings
function CTT_InstanceTypeDisplay(key)
    local zone = GetRealZoneText()

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
        if not (UnitAffectingCombat("player") or CTT.bossEncounter) and cttStopwatchGui:IsShown() then cttStopwatchGui:Hide() end
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
        text = CTT.L["Combat Time Tracker has been updated, the tracker needs to be reset to work properly!"],
        button1 = CTT.L["Reset Now"],
        button2 = CTT.L["Reset Later"],
        OnAccept = function()
            CTT.db.profile.cttMenuOptions.uiReset = false
            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("NEW_VERSION")
end

-- function to display results on encounter end or regen enabled
function CTT_DisplayResults(newRecord)
    if not CTT.db.profile.cttMenuOptions.togglePrint then return end
    local t = CTT.db.profile.cttMenuOptions.timeValues or {"00", "00", "00", "00", "00"}
    local h  = t[1] or "00"
    local m  = t[2] or "00"
    local s  = t[3] or "00"
    local ts = t[4] or "00"
    local ms = t[5] or "00"
    if CTT.db.profile.cttMenuOptions.dropdownValue == 1 then
        if newRecord then
            CTT:Print(CTT.L["New Record! Fight ended in "] .. ts .. "." .. ms .. " " .. CTT.L["seconds"] .. "!")
        else
            CTT:Print(CTT.L["Fight ended in "] .. ts .. "." .. ms .. " " .. CTT.L["seconds"] .. ".")
        end
    elseif CTT.db.profile.cttMenuOptions.dropdownValue == 2 then
        if newRecord then
            CTT:Print(CTT.L["New Record! Fight ended in "] .. "(MM:SS.MS): " .. m .. ":" .. s .. "." .. ms .. "!")
        else
            CTT:Print(CTT.L["Fight ended in "] .. "(MM:SS.MS): " .. m .. ":" .. s .. "." .. ms .. ".")
        end
    else
        if newRecord then
            CTT:Print(CTT.L["New Record! Fight ended in "] .. "(HH:MM:SS.MS): " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. "!")
        else
            CTT:Print(CTT.L["Fight ended in "] .. "(HH:MM:SS.MS): " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. ".")
        end
    end
end

-- Get difficulty name by ID
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
    local seasonID = (CTT.isRetail and C_MythicPlus and C_MythicPlus.GetCurrentSeason()) or 0
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
    if CTT.db.profile.DungeonKills == nil then
        CTT.db.profile.DungeonKills = {}
    end
    tinsert(CTT.db.profile.DungeonKills, data)
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

    if CTT.db.profile.RaidKills == nil then
        CTT.db.profile.RaidKills = {}
    end
    tinsert(CTT.db.profile.RaidKills, data)
end

-- function to display results on a boss encounter ending
function CTT_DisplayResultsBosses(bossEncounter, wasAKill)
    if not CTT.db.profile.cttMenuOptions.togglePrint then return end
    local ms = CTT.miliseconds or "00"
    local s  = CTT.seconds    or "00"
    local m  = CTT.minutes    or "00"
    local h  = CTT.hours      or "00"
    local ts = CTT.totalSeconds or "00"
    if CTT.db.profile.cttMenuOptions.dropdownValue == 1 then
        if wasAKill then
            CTT:Print(CTT.L["You have successfully killed "] .. bossEncounter .. " " .. CTT.L["after"] .. " " .. ts .. "." .. ms .. " " .. CTT.L["seconds"] .. "!")
        else
            CTT:Print(CTT.L["You have wiped on "] .. bossEncounter .. CTT.L["after"] .. " " .. ts .. "." .. ms .. ".")
        end
    elseif CTT.db.profile.cttMenuOptions.dropdownValue == 2 then
        if wasAKill then
            CTT:Print(CTT.L["You have successfully killed "] .. bossEncounter .. " " .. CTT.L["after"] .. " " .. m .. ":" .. s .. "." .. ms .. "!")
        else
            CTT:Print(CTT.L["You have wiped on "] .. bossEncounter .. " " .. CTT.L["after"] .. " " .. m .. ":" .. s .. "." .. ms .. ".")
        end
    else
        if wasAKill then
            CTT:Print(CTT.L["You have successfully killed "] .. bossEncounter .. " " .. CTT.L["after"] .. " " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. ".")
        else
            CTT:Print(CTT.L["You have wiped on "] .. bossEncounter .. " " .. CTT.L["after"] .. " " .. h .. ":" .. m .. ":" .. s .. "." .. ms .. ".")
        end
    end
end

-- function to update the text on the tracker frame
function CTT_UpdateText(hours, minutes, seconds, miliseconds, textFormat, fontUpdate)
    if fontUpdate == 2 then
        cttStopwatchGuiTimeText:SetText("")
    end
    if textFormat == 1 then
        if CTT.db.profile.cttMenuOptions.timeValues then
            cttStopwatchGuiTimeText:SetText(CTT.totalSeconds)
        else
            cttStopwatchGuiTimeText:SetText(seconds)
        end
    elseif textFormat == 2 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds)
    elseif textFormat == 4 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds .. "." .. miliseconds)
    elseif textFormat == 5 then
        cttStopwatchGuiTimeText:SetText(minutes .. ":" .. seconds .. ":" .. miliseconds)
    else
        cttStopwatchGuiTimeText:SetText(hours .. ":" .. minutes .. ":" .. seconds)
    end
end

function CTT_GetCharacterProfileName()
    return UnitName("player") .. ' - ' .. GetRealmName()
end

function CTT_ProfileExists(profileName)
    for _, existingProfileName in ipairs(CTT.db:GetProfiles()) do
        if existingProfileName == profileName then
            return true
        end
    end

    return false
end

function CTT_GetSharedProfileName()
    if CTT.db.global.sharedProfileName == nil or CTT.db.global.sharedProfileName == "" then
        CTT.db.global.sharedProfileName = CTT_GetCharacterProfileName()
    end

    return CTT.db.global.sharedProfileName
end

function CTT_SetActiveProfile(profileName)
    activeProfile = profileName
    activeProfileKey = nil

    for k, existingProfileName in ipairs(CTT.db:GetProfiles()) do
        if existingProfileName == profileName then
            activeProfileKey = k
            break
        end
    end
end

function CTT_GetProfileKey(profileName)
    for k, existingProfileName in ipairs(CTT.db:GetProfiles()) do
        if existingProfileName == profileName then
            return k
        end
    end
end

function CTT_ApplyConfiguredProfile()
    local profileName = CTT_GetCharacterProfileName()

    if CTT.db.global.useSharedDefaultProfile then
        profileName = CTT_GetSharedProfileName()
    end

    CTT.db:SetProfile(profileName)
    CTT_SetActiveProfile(profileName)
end

-- Build a filter list of unique dungeon names from stored runs, prefixed with "All"
function CTT_BuildDungeonFilterList()
    local names = { "All" }
    local seen = {}
    if CTT.db.profile.DungeonKills then
        for _, v in ipairs(CTT.db.profile.DungeonKills) do
            if v.Dungeon and not seen[v.Dungeon] then
                seen[v.Dungeon] = true
                tinsert(names, v.Dungeon)
            end
        end
    end
    return names
end
