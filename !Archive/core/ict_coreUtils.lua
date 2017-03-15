local iction = iction
----------------------------------------------------------------------------------------------
--- APPLICATION  ---
--function ictionlist_iter(t)
--  local i = 0
--  local n = table.getn(t)
--  return function ()
--       i = i + 1
--       if i <= n then return t[i] end
--     end
--end
function iction.getSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
    return currentSpecName
end

function iction.tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

----------------------------------------------------------------------------------------------
--- DEBUFF COLUMNS ---
function iction.debuffColumns_setMax()
    for i=1, iction.ict_maxTargets, 1 do
        iction.targetCols['col_'.. i] = {guid = '', colID = 'col_'.. i, active = false}
    end
end

function iction.debuffColumns_GUIDExists(guid)
    local exists = false
    for colID, colData in pairs(iction.targetCols) do
        if colData["guid"] == guid then
            exists = true
    end end
    return exists
end

function iction.debuffColumns_slotAvailable()
    local emptyColExists = false

    for _, columnData in pairs(iction.targetCols) do
        if columnData["active"] == false then
            emptyColExists = true
    end end

    return emptyColExists
end

function iction.debuffColumns_nextAvailable(guid)
    --- Do we already have a debuff column for the guid?
    local hasActiveCol = iction.debuffColumns_GUIDExists(guid)
    if hasActiveCol then return false, false end

    --- We don't have this guid as a column but do we have a slot available?
    local hasEmptyCol = iction.debuffColumns_slotAvailable()
    if not hasEmptyCol then return false, false end

    --- Add to available column now.
    local orderCol = {}
    for x = 1, iction.ict_maxTargets do
        table.insert(orderCol, "col_" .. x)
    end

    for i = 1, iction.ict_maxTargets do
        local colID = orderCol[i]
        if not iction.targetCols[colID]["active"] then
            iction.targetCols[colID]["guid"] = guid
            iction.targetCols[colID]["active"] = true
            if iction.debugUI then print("Active colmun set to: " .. tostring(colID)) end
            return true, colID
    end end
end

----------------------------------------------------------------------------------------------
--- CACHE DATA ---
function iction.targetTableExists()
    if iction.targetData then
        if next(iction.targetData) ~= nil then
            return true
        else return false
    end end
end

function iction.targetFramesTableExists()
    if next(iction.targetFrames) ~= nil then return true end
    return false
end

function iction.clearChannelData()
    for guid, data in pairs(iction.targetData) do
        if iction.isValidButtonFrame(guid) then
            local spellData = data['spellData']
            for spellID, spellInfo in pairs(spellData) do
                if spellInfo['isChanneled'] then
                    iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellID])
                    iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellID])
                    iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
                    iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
                    iction.targetData[guid]['spellData'][spellID]['isChanneled'] = false
                end
            end
        end
    end
end

function iction.tagDeadTarget(guid)
    -- Fix the current tracked targets state
    if iction.targetData[guid] then
        iction.targetData[guid]['frame'].setVisibilty(false)
        -- Now remove all the data
        iction.targetData[guid] = nil
    end

    -- Make the column available
    local found, id = iction.debuffColumns_GUIDExists(guid)
    if found == true then
        iction.targetCols[id]['active'] = false
        iction.targetCols[id]['guid'] = ''
    end
end

function iction.spellIDActive(guid, spellID)
    --- Returns if we have an active spell in the tables or if the target is no longer valid to the addon
    local next = next
    -- {GUID = {name = creatureName, spellData = {spellName = {name=spellName, endtime=float}}}}
    if iction.targetData[guid] ~= nil then
        if iction.targetData[guid]["spellData"] ~= nil then
            if next(iction.targetData[guid]["spellData"]) ~= nil then
                if iction.targetData[guid]["spellData"][spellID] ~= nil then
                    return true
                else return false end
            else return false end
        else return false end
    else return false end
end

function iction.channelActive(spellID)
    if spellID == nil then return false, nil end
    local found = false
    local changuid = nil
    for guid, data in pairs(iction.targetData) do
        if iction.spellIDActive(guid, spellID) then
            local spellData = data['spellData']
            if iction.targetData[guid]['spellData'][spellID]['isChanneled'] then
                found = true
                changuid = iction.targetData[guid]['guid']
            end
        end
    end
    return found, changuid
end

----------------------------------------------------------------------------------------------
--- SPELL INFO ---
function iction.getConflagCharges()
    local currentCharges, maxCharges = GetSpellCharges("Conflagrate")
    return currentCharges, maxCharges
end

----------------------------------------------------------------------------------------------
--- BLIZZARD API ---
function iction.blizz_getChannelSpellInfo()
    local name, _, _, _, _, endTime, _, _ = UnitChannelInfo("Player")
    local sname, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(name)
    if endTime ~= nil then
        local cexpires, dur
        dur = endTime/1000.0 - GetTime()
        cexpires =  GetTime() + dur
        return spellID, cexpires, name
    else
        return nil, nil, nil
    end
end

function iction.reaper_getTargetHP()
    ---- For Priest
    local isDead = UnitIsDead("target")
    if UnitName("target") then
        local health = UnitHealth("target")
        local max_health = UnitHealthMax("target")
        local percent = (max_health * iction.blizz_isSpellReaperActive())
        if health <= percent and not isDead then
            return true
        else
            return false
    end end
end

function iction.blizz_isSpellReaperActive()
    for x=1, 7 do
        for c=1, 3 do
            local _, name, _, selected, _, spellid = GetTalentInfo(x, c, 1)
            --- how is it that ShadowyInsight talent and buff applied have different id's argh
            if spellid == 199853 and selected then
                return .35
    end end end

    return .20
end

function iction.blizz_buffActive(spellID)
    local found = false
    for x=1, 20, 1 do
        local _, _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, _, _, _, _  = UnitBuff("Player", x)
        if spellId ~= nil and spellId == spellID then
            found = true
    end end

    return found
end

----------------------------------------------------------------------------------------------
--- TIMERS UTILS -----------------------------------------------------------------------------
function iction.oocCleanup()
    --- Clear target all data as we exited combat except buffs that might be running
    if UnitAffectingCombat("player") then return end
    if iction.targetTableExists() then
    end
end

function iction.highlightTargetSpellframe(guid)
    if UnitAffectingCombat("player") then
        if guid == nil or not (UnitName("target")) or guid == "" then
            --- Hide the frame
            iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)

        elseif guid ~= iction.playerGUID then
            local stashedGuid = iction.hightlghtFrameGuid

            if stashedGuid ~= guid then
                local f = iction.targetFrames[guid] or nil
                local pf = iction.targetFrames[iction.hlGuid] or nil

                if iction.targetData[guid] ~= nil then
                    if f ~= nil and iction.targetData[guid]["dead"] ~= true then
                        iction.highlightFrameTexture:SetAllPoints(true)
                        iction.highlightFrameTexture:SetVertexColor(.1, .6, .1, .45)
                        iction.highlightFrame:SetParent(f)
                        iction.highlightFrame:SetFrameStrata("BACKGROUND")
                        iction.highlightFrame:SetPoint("BOTTOM", f, 0, 0)
                        iction.highlightFrame:SetPoint("CENTER", f, 0, 0)
                        iction.hightlghtFrameGuid = guid
                    else
                        iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)
                    end
                end

            else
                if iction.targetData[guid] ~= nil then
                    if iction.targetData[guid]['dead'] then
                        iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)
                    end
                end
            end
        end
    end
end

function iction.clearAllSeeds(guid)
    if iction.targetTableExists() then
        if iction.targetButtons[guid] and iction.targetButtons[guid]['buttonFrames'] and iction.targetButtons[guid]['buttonFrames'][27243] and iction.targetData[guid]['spellData'][27243] ~= nil then
            iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][27243])
            iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][27243])
            iction.targetData[guid]['spellData'][27243]['endTime'] = nil
        end
    end
end

function iction.addSeeds(guid, spellName, spellType, spellID)
    -- now check we have it in a column
    if not iction.debuffColumns_GUIDExists(guid) then -- it isn't present as an active target column so try to make one now.
        iction.createTarget(guid, 'nil', spellName, spellType, spellID)
    end
    if iction.debuffColumns_GUIDExists(guid) then
        iction.createTargetSpellData(guid, spellName, spellType, spellID)
        iction.createExpiresData(guid, spellName, spellType, spellID)
    end
end

function iction.updateUACount(guid)
    --- UA COUNT
    local UACount = 0
    for x = 1, 15 do
        local  _, _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, _ = UnitAura("target", x, "PLAYER HARMFUL")
        if spellId == 233490 or spellId == 233496 or spellId ==  233497 or spellId == 233498 or spellId ==  233499 then
            UACount = UACount + 1
        end
    end
    if UACount ~= 0 then
        if iction.targetData[guid] ~= nil then
            if iction.targetData[guid]['spellData'] == nil then
                iction.createTarget(guid, "aMob", "Unstable Afflction", "DEBUFF", 233490)
            end
            if iction.targetData[guid]['spellData'] ~= nil then
                if iction.targetData[guid]['spellData'][233490] ~= nil then
                    iction.targetData[guid]['spellData'][233490]['count'] = UACount
                end
            end
        end
    end
end

------------------------------------------
--- Update current target debuffs
function iction.currentTargetDebuffExpires()
    if not (UnitName("target")) then return end

    if (UnitName("target")) then
        local guid = UnitGUID("Target")
        iction.updateUACount(guid)
        iction.setNonTargetCooldown(guid)
        iction.highlightTargetSpellframe(guid)
        --- Do a channelling check first as we may have flicked targets while channelling ready to cast on fresh target.
        local spellID, cexpires = iction.blizz_getChannelSpellInfo()
        if cexpires ~= nil then
            local isChannelActive, channelguid, spellName = iction.channelActive(spellID)
            if isChannelActive then
                iction.targetData[channelguid]['spellData'][spellID]['isChanneled'] = true
                iction.targetData[channelguid]['spellData'][spellID]['endTime'] = cexpires
            end
            local spec = GetSpecialization()
            if spec == 3 then return end
        end
        if iction.targetData[guid] ~= nil then
            local mobInfo = iction.targetData[guid]['spellData']
            if mobInfo ~= nil then
                iction.setTargetCooldown(guid)
                for spellID, spellDetails in pairs(mobInfo) do
                    if iction.spellIDActive(guid, spellDetails['id']) then
                        local _, _, _, count, _, duration, expirationTime, unitCaster, _, _, spellId = UnitDebuff("Target", spellDetails['spellName'], nil, "player")
                        if expirationTime ~= nil and unitCaster == 'player' and spellId ~= 216145 and spellId ~= 222074 then -- ritz follower immolate spell id
                            iction.targetData[guid]['spellData'][spellID]['endTime'] = expirationTime
                        elseif spellId == 27243 then --- duplicate seed for talent handling
                            iction.targetData[guid]['spellData'][spellID]['endTime'] = expirationTime
                        else
                            iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
                        end

                        if count and count ~= 0 then
                            iction.targetData[guid]['spellData'][spellID]['count'] = count
                        end
    end end end end end
end

function iction.setNonTargetCooldown(guidToIgnore)
    for _, data in pairs(iction.targetData) do
        if data['guid'] ~= guidToIgnore then
            if data['spellData'] ~= nil then
                local isDead = data['dead']
                local spells = data['spellData']
                if not isDead then
                    for _, spellData in pairs(iction.uiPlayerSpellButtons) do
                        local spellName = spellData['name']
                        local spellID = spellData['id']
                        if iction.isSpellOnCooldown(spellID) then
                            local start, duration, _ = GetSpellCooldown(spellID)
                            if duration > 1.5 then
                                local cdET = iction.fetchCooldownET(spellID)
                                iction.createTargetData(data['guid'], "AMob")
                                iction.createTargetSpellData(data['guid'], spellName, "DEBUFF", spellID)
                                iction.targetData[data['guid']]['spellData'][spellID]['coolDown'] = cdET
    end end end end end end end
end

function iction.setTargetCooldown(guid)
    if iction.targetData[guid] then
        local data = iction.targetData[guid]
        if data['spellData'] ~= nil then
            local isDead = data['dead']
            local spells = data['spellData']
            if not isDead then
                for _, spellData in pairs(iction.uiPlayerSpellButtons) do
                    local spellName = spellData['name']
                    local spellID = spellData['id']
                    if iction.isSpellOnCooldown(spellID) then
                        local start, duration, _ = GetSpellCooldown(spellID)
                        if duration > 1.5 then
                            local cdET = iction.fetchCooldownET(spellID)
                            if iction.targetData[guid]['spellData'][spellID] ~= nil then
                                iction.targetData[guid]['spellData'][spellID]['coolDown'] = cdET
                            else
                                iction.createTargetSpellData(guid, spellName, "DEBUFF", spellID)
                                iction.targetData[guid]['spellData'][spellID]['coolDown'] = cdET
    end end end end end end end
end

function iction.specChanged()
--    local spec = GetSpecialization()
--    if not iction.mainFrameBldr then iction.initMainUI() end
--
--    if iction.spec ~= spec then
--        iction.spec = spec
--        DEFAULT_CHAT_FRAME:AddMessage(iction.L['specChangeMSG'], 15, 25, 35)
--        iction.shardFrame = nil
--        iction.highlightFrameTexture = nil
--        if iction.class == iction.L['Warlock'] then
--            -- Conflag frame for destro spec
--            if iction.spec == 3 then
--                iction.createConflagFrame()
--            else
--                if iction.conflagFrame ~= nil then
--                    iction.conflagFrame:Hide()
--            end end
--            -- Reset all soul shard images to 0 as the shard count resets on spec change
--            for i = 1, iction.tablelength(iction.soulShards) do
--                if iction.soulShards[i] ~= nil then
--                    iction.soulShards[i]:Hide()
--            end end
--            iction.createShardFrame()
--            local shards = UnitPower("Player", 7)
--            iction.setSoulShards(shards)
--        end
--
--        if iction.class == iction.L['Priest'] then
--            if spec == 3 then
--                iction.createDebuffColumns()
--                iction.ictionMF:Show()
--            else
--                if iction.ictionMF then iction.ictionMF:Hide() end
--                iction.spec = spec
--                return
--        end end
--        -- Change the artifact frame
--        iction.createArtifactFrame()
--        -- Reset highlightframe size for buttons changes
--        iction.highlightFrameTexture = iction.createHighlightFrame()
--    end
end