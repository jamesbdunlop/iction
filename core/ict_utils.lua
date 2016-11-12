----------------------------------------------------------------------------------------------
--- MAIN FRAME UI STUFF ---
function iction.setMTapBorder()
    local mt
    local mtOpacity = .6
    mt = false

    if iction.buffActive(196104) == true or iction.buffActive(117828) == true or iction.buffActive(232698) then
        mt = true
    end

    if mt then
        for x=1, 4 do
            f = iction.uiBotBarArt[x]
            if f then
                f.texture:SetVertexColor(.1, 1, .1, 1)
            end
        end
    else
        for x=1, 4 do
            f = iction.uiBotBarArt[x]
            if f then
                f.texture:SetVertexColor(1, 1, 1, 1)
            end
        end
    end
end

function iction.buffActive(spellID)
    local next = next
    local found = false
    for x=1, 20, 1 do
        local _, _, _, count, _, _, _, _, _, _, spellId, _, _, _, _, _, _, _, _  = UnitBuff("Player", x)
        if spellId ~= nil and spellId == spellID then found = true end
    end
    return found
end

function iction.setSoulShards(shards)
    for x = 1, 5 do
        iction.soulShards[x]:SetVertexColor(1, 1, 1, 0)
    end
    for x = 1, shards do
        iction.soulShards[x]:SetVertexColor(1, 1, 1, 1)
    end
end

function iction.setConflagCount()
    if iction.spec == 3 then
        local confCount = iction.getConflagCharges() or 0
        for x = 1, 2 do
            iction.conflags[x]:SetVertexColor(1, 1, 1, 0)
        end
        for x = 1, confCount do
            iction.conflags[x]:SetVertexColor(1, 1, 1, 1)
        end
    end
end

----------------------------------------------------------------------------------------------
--- BUTTON UTILS -----------------------------------------------------------------------------
function iction.setButtonState(active, hidden, button, refresh)
    if button ~= nil then
        if active and not refresh then
            button:SetBackdropColor(1, 1, 1, 1)
            button.texture:SetVertexColor(0.9,0.9,0.9, .9)
        elseif hidden then
            button:SetBackdropColor(0,0,0, 0)
            button.texture:SetVertexColor(0,0,0, 0)
        elseif active and refresh then
            button:SetBackdropColor(1, 1, 1, 1)
            button.texture:SetVertexColor(1, 0, 0, 1)
        else
            button.texture:SetVertexColor(0.9,0.3,0.3, .5)
        end
    end
end

function iction.setButtonText(text, hidden, fontString, colorize, color)
    if fontString ~= nil then
        if hidden == true then
            fontString:SetText("")
        else
            fontString:SetText(text)
            if colorize then
                fontString:SetTextColor(color[1], color[2], color[3], color[4])
            else
                fontString:SetTextColor(.1, 1, .1, 1)
            end
        end
    end
end

----------------------------------------------------------------------------------------------
--- TIMERS UI MANAGE DEBUFF COLUMNS UI  ---
function iction.setMaxTargetTable()
    for i=1, iction.ict_maxTargets, 1 do
            iction.targetCols['col_'.. i] = {guid = '', colID = 'col_'.. i, active = false}
    end
end

function iction.colGUIDExists(guid)
    local found = false
    local id = ""
    --- look for existing first
    for colID, colData in pairs(iction.targetCols) do
        if colData["guid"] == guid then
            found = true
            id = colID
        end
    end
    return found, id
end

function iction.hasEmptyColumn()
    local emptyColExists = false
    for colID, columnData in pairs(iction.targetCols) do
        if columnData["active"] == false then
            emptyColExists = true
        end
    end
    return emptyColExists
end

function iction.findSlot(guid)
    local guidIsActiveFrame, id = iction.colGUIDExists(guid)
    if guidIsActiveFrame then
        return false, id
    else
        local emptyCExists = iction.hasEmptyColumn()
        if emptyCExists then
            local orderCol = {}
            for x = 1, iction.ict_maxTargets do
                table.insert(orderCol, "col_" .. x)
            end

            if not guidIsActiveFrame then
                for col = 1, iction.ict_maxTargets do
                    local colID = orderCol[col]
                    if not iction.targetCols[colID]["active"] then
                        iction.targetCols[colID]["active"] = true
                        iction.targetCols[colID]["guid"] = guid
                        return true, colID
                    end
                end
            end
        else
            return false
        end
    end
end

----------------------------------------------------------------------------------------------
--- TIMERS UI UTILS --------------------------------------------------------------------------
function iction.calcFrameSize(Tbl)
    local cfh, cfw
    local fsize = iction.ictionButtonFramePad *2

    for key, value in pairs(Tbl) do
        if value['vis'] then
            fsize = fsize + iction.bw
        end
    end
    cfh = fsize
    cfw = iction.bh + 5 -- frame edge padding
    return cfw, cfh
end

function iction.hideFrame(guid, isDead, spName, spType)
    local alpha = .5
    if iction.targetFrames[guid] ~= nil and iction.targetButtons[guid] ~= nil then
        if isDead == true then
            -- set the backdrop to invis
            iction.targetFrames[guid]:SetBackdropColor(0,0,0, 0)
            iction.targetFrames[guid].texture:SetVertexColor(0,0,0, 0)
            -- set the buttons for this frame to invis
            -- {GUID = {buttonFrames = {spellName = ButtonFrame}, buttonText = {spellName = fontString}}}
            if iction.targetButtons[guid]['buttonFrames'] ~= nil then
                for spellName, buttonFrame in pairs(iction.targetButtons[guid]['buttonFrames']) do
                    iction.setButtonState(false, true, buttonFrame)
                end
                -- set text
                for spellName, buttonText in pairs(iction.targetButtons[guid]['buttonText']) do
                    buttonText:SetText("")
                end
            end
        end
    end
end

----------------------------------------------------------------------------------------------
--- TIMERS UTILS -----------------------------------------------------------------------------
function iction.oocCleanup()
    --- Clear target all data as we exited combat except buffs that might be running
    if not UnitAffectingCombat("player") then
        if iction.targetTableExists() then
            for guid, targets in pairs(iction.targetData) do
                if guid ~= iction.playerGUID then
                    --if iction.targetData[guid]['dead'] then
                    if iction.debug then print("Removing iction.targetData[guid]" .. tostring(guid)) end
                    if iction.targetFrames[guid] then iction.targetFrames[guid]:Hide() end
                    if iction.stackFrames[guid] then
                        -- hide all button stack frames that were build
                        for i = 1, iction.tablelength(iction.stackFrames[guid]) do
                            if iction.stackFrames[guid][i] ~= nil then
                                iction.stackFrames[guid][i]['frame']:Hide()
                                iction.stackFrames[guid][i]= nil
                            end
                        end
                    end
                    iction.targetData[guid] = nil
                    iction.targetFrames[guid] = nil
                    iction.targetButtons[guid] = nil
                    iction.stackFrames[guid] = nil
                end
            end
        end

        if iction.targetCols ~= nil then
            for k, v in pairs(iction.targetCols) do
                iction.targetCols[v['colID']]['active'] = false
                iction.targetCols[v['colID']]['guid'] = false
            end
        end

        if iction.targetFramesTableExists() then
            if iction.targetFrames ~= nil then
                for guid, targets in pairs(iction.targetFrames) do
                    if guid ~= iction.playerGUID then
                        if iction.targetFrames[guid] ~= nil then
                            if iction.debug then print("Removing iction.targetFrames[guid]" .. tostring(guid)) end
                            iction.targetFrames[guid]:Hide()
                        end
                        if iction.targetFrames[guid] then
                            iction.targetFrames[guid] = nil
                            iction.targetButtons[guid] = nil
                        end
                    end
                end
            end
        end
    end
end

function iction.highlightTargetSpellframe(guid)
    if UnitAffectingCombat("player") then
        if guid == nil then
            iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)
        elseif guid ~= iction.playerGUID then
            local prev = iction.hlGuid
            if prev ~= guid then
                local f = iction.targetFrames[guid] or nil
                local pf = iction.targetFrames[iction.hlGuid] or nil
                if iction.targetData[guid] ~= nil then
                    if f ~= nil and iction.targetData[guid]["dead"] ~= true then
                        iction.highlightFrameTexture:SetVertexColor(.1, .6, .1, .45)
                        iction.highlightFrame:SetParent(f)
                        iction.highlightFrame:SetPoint("CENTER", f, 0, 0)
                        iction.hlGuid = guid
                    else
                        iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)
                    end
                end
            end
        end
    end
end

----------------------------------------------------------------------------------------------
--- TARGET UTILS -----------------------------------------------------------------------------
function iction.getChannelSpell()
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

function iction.currentBuffExpires()
    if (UnitName("Player")) then
        if iction.targetData[iction.playerGUID] ~= nil then
            local mobInfo = iction.targetData[iction.playerGUID]['spellData']
            if mobInfo ~= nil then
                for spellID, spellDetails in pairs(mobInfo) do
                    if iction.spellIDActive(iction.playerGUID, spellDetails['id']) then
                        local _, _, _, count, _, _, expires, _, _, _, spellID, _, _, _, _, _, _, _, _  = UnitBuff("Player", spellDetails['spellName'])
                        if expires ~= nil then
                            iction.targetData[iction.playerGUID]['spellData'][spellID]['endTime'] = expires
                        end
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

function iction.addSeeds(guid, spellName, spellType)
    -- now check we have it in a column
    if not iction.colGUIDExists(guid) then -- it isn't present as an active target column so try to make one now.
        iction.createTarget(guid, 'nil', spellName, spellType)
    end
    if iction.colGUIDExists(guid) then
        iction.createTargetSpellData(guid, spellName, spellType)
        iction.createExpiresData(guid, spellName, spellType)
    end
end

function iction.targetTableExists()
    if iction.targetData then
        if next(iction.targetData) ~= nil then return true else return false end
end end

function iction.targetFramesTableExists()
    if next(iction.targetFrames) ~= nil then return true else return false end
end

function iction.getConflagCharges()
    local currentCharges, maxCharges = GetSpellCharges("Conflagrate")
    return currentCharges, maxCharges
end

function iction.tagDeadTarget(guid)
    -- Fix the current tracked targets state
    if guid ~= iction.playerGUI then
        if iction.targetData[guid] ~= nil then
            iction.hideFrame(guid, true)
            iction.targetData[guid]['dead'] = true
            iction.targetData[guid]['spellData'] = nil
            iction.highlightTargetSpellframe(guid)
        end
        -- Fix the display columns
        local found, id = iction.colGUIDExists(guid)
        if found == true then
            iction.targetCols[id]['active'] = false
            iction.targetCols[id]['guid'] = ''
        end
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
            iction.targetData[guid]['spellData'][233490]['count'] = UACount
        end
    end
end

------------------------------------------
--- Update current target debuffs
function iction.currentTargetDebuffExpires()
    if (UnitName("target")) then
        local guid = UnitGUID("Target")
        iction.updateUACount(guid)
        iction.setNonTargetCooldown(guid)
        iction.highlightTargetSpellframe(guid)
        --- Do a channelling check first as we may have flicked targets while channelling ready to cast on fresh target.
        local spellID, cexpires = iction.getChannelSpell()
        if cexpires ~= nil then
            local isChannelActive, channelguid, spellName = iction.channelActive(spellID)
            if isChannelActive then
                iction.targetData[channelguid]['spellData'][spellID]['isChanneled'] = true
                iction.targetData[channelguid]['spellData'][spellID]['endTime'] = cexpires
            end
            local spec = GetSpecialization()
            if spec == 3 then return end
        end
        -- Now handle UA cause it's a nightmare
        if iction.targetData[guid] ~= nil then
            local mobInfo = iction.targetData[guid]['spellData']
            if mobInfo ~= nil then
                iction.setTargetCooldown(guid)
                for spellID, spellDetails in pairs(mobInfo) do
                    if iction.spellIDActive(guid, spellDetails['id']) then
                        local _, _, _, count, _, duration, expirationTime, unitCaster, _, _, spellId = UnitDebuff("Target", spellDetails['spellName'], nil, "player")
                        if expirationTime ~= nil and unitCaster == 'player' and spellId ~= 216145 then -- ritz follower immolate spell id
                            iction.targetData[guid]['spellData'][spellID]['endTime'] = expirationTime
                        elseif spellId == 27243 then --- duplicate seed for talent handling
                            iction.targetData[guid]['spellData'][spellID]['endTime'] = expirationTime
                        else
                            iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
                        end

                        if count and count ~= 0 then
                            iction.targetData[guid]['spellData'][spellID]['count'] = count
                        end
                    end
                end
            end
        end
    end
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
                            end
                        end
                    end
                end
            end
        end
    end
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
                            end
                        end
                    end
                end
            end
        end
    end
end