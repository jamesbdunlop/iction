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
