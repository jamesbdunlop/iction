function iction.ictionLockFrameWatcher(mainFrame)
    mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    mainFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    mainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    mainFrame:RegisterEvent("SPELL_AURA_REMOVED")
    mainFrame:RegisterEvent("SPELL_AURA_APPLIED")
    mainFrame:RegisterEvent("SPELL_AURA_APPLIED_DOSE")
    mainFrame:RegisterEvent("SPELL_DAMAGE")
    mainFrame:RegisterEvent("SPELL_CAST_SUCCESS")
    mainFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    local function eventHandler(self, event, currentTime, eventName, sourceFlags, sourceGUID, sourceName, flags, prefix1, prefix2, prefix3, sufx1,  sufx2,  sufx3,  sufx4,  sufx5,  sufx6,  sufx7, sufx8,  sufx9, ...)
        local event = event
        local eventName = eventName
        local spellName, mobName, mobGUID, spellType, spellID
        local validSpell = false
        mobGUID = prefix2
        if mobGUID ~= nil then if string.find(mobGUID, "Pet", 1) then return end end
        mobName = prefix3
        spellName = sufx4
        spellID = sufx3
        if eventName == "SPELL_CAST_SUCCESS" or eventName == "SPELL_PERIODIC_DAMAGE" or eventName == "SPELL_DAMAGE" then
            spellType = "DEBUFF"
        else
            spellType = sufx6
        end
        --------------------------------------------------------------------------------------
        if event == "PLAYER_SPECIALIZATION_CHANGED" then
            iction.specChanged()
        end

        --------------------------------------------------------------------------------------
        if event == "PLAYER_TARGET_CHANGED" then
            iction.highlightTargetSpellframe(UnitGUID("Target"))
        end

        --------------------------------------------------------------------------------------
        --- UNIT DIED
        if eventName == "UNIT_DIED" then
            local function removeDead()
                --- Remove unit from the table if it died.
                if mobGUID ~= iction.playerGIUD then
                    iction.tagDeadTarget(mobGUID)
                    iction.targetData[mobGUID] = nil
                    --- Hide all button stack frames that were built
                    if iction.stackFrames[mobGUID] then
                        for k, v in pairs(iction.stackFrames[mobGUID]) do
                            for p, q in pairs(v) do
                                if p == 'frame' then
                                    q:SetBackdropColor(0,0,0,0)
                                    q.texture:SetVertexColor(0,0,0,0)
                                elseif p == 'font' then
                                    q:SetText("")
                                end
                            end
                        end
                    end
                    iction.highlightTargetSpellframe(UnitGUID("Target"))
                    return
                end
            end
            removeDead()
        --- PLAYER DIED
        elseif sourceGUID == iction.playerGUID and eventName == "PLAYER_DEAD" then
            local buttonTexts = iction.targetButtons[iction.playerGUID]["buttonText"]
            for i = 1, iction.tablelength(buttonTexts) do
                if buttonTexts[i] ~= nil then buttonTexts[i]:SetText("") end
            end
        end

        --------------------------------------------------------------------------------------
        if sourceGUID == iction.playerGUID then
            if event == "PLAYER_REGEN_ENABLED" then iction.oocCleanup() return
            elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
                --- Check for valid spell
                for _, v in pairs(iction.uiPlayerSpellButtons) do
                    if v['id'] == spellID then validSpell = true end
                end
                for _, v in pairs(iction.uiPlayerBuffButtons) do
                    if v['id'] == spellID then validSpell = true end
                end
                --- Exit early if it is not a valid spell
                if not validSpell then
                    return
                else
                    --- CANCEL CHANNEL DATA ON SPELL CAST START
                    if eventName == "SPELL_CAST_START" then
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)
                    end

                    --- UPDATE SPELL COUNT
                    if eventName == "SPELL_AURA_APPLIED_DOSE" and sufx6 == "DEBUFF" then
                        if iction.spellIDActive(mobGUID, spellID) then iction.targetData[mobGUID]['spellData'][spellID]['count'] = sufx7 end
                    end

                    --- SPELL AURA APPLIED
                    if eventName == "SPELL_AURA_APPLIED" and spellID ~= 196447 then --- ignore channelDemonfire here
                        if spellID == 234153 or spellID == 198590 or spellID == 689 then iction.clearChannelData() end
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

                    elseif eventName == "SPELL_ENERGIZE" then
                        --- CONFLAG OPENING CAST
                        if spellID == 17962 then
                            iction.createTarget(UnitGUID("Target"), mobName, spellName, "DEBUFF", spellID)
                        end
                    elseif eventName == "SPELL_AURA_REFRESH" then
                        iction.setMTapBorder()
                        iction.clearChannelData()
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

                    elseif eventName == "SPELL_CAST_SUCCESS" then
                        if spellID == 980 then                              --- AGONY
                            iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)
                        elseif spellID == 196447 then                       --- CHANNEL DEMON FIRE
                            iction.clearChannelData()
                            iction.createTarget(UnitGUID("Target"), mobName, spellName, spellType, spellID)
                        elseif spellID == 5782 then                       --- Fear
                            iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)
                        end

                    elseif eventName == "SPELL_PERIODIC_DAMAGE" then
                        if spellID == 233490 or spellID == 233496 or spellID == 233497 or spellID == 233498 or spellID ==  233499 then
                            iction.createTarget(mobGUID, mobName, spellName, spellType, 233490)
                        end

                    elseif eventName == "SPELL_AURA_REMOVED" then
                        local channeledSpellID, cexpires = iction.getChannelSpell()
                        local isChannelActive, channelguid = iction.channelActive(channeledSpellID)
                        if not isChannelActive then
                            iction.clearChannelData()
                        end

                        if spellID == 111400 then                           --- BURNING RUSH
                            iction.createTarget(mobGUID, mobName, spellName, "BUFF", spellID)
                        elseif spellID == 27243 then                        --- SEED
                            iction.clearAllSeeds(mobGUID)
                        elseif spellID == 118699 then
                            iction.targetData[mobGUID]['spellData'][spellID]['endTime'] = nil
                        elseif spellID == 233490 or spellID == 233496 or spellID == 233497 or spellID == 233498 or spellID == 233499 then --- UA
                            local count = iction.targetData[mobGUID]['spellData'][233490]['count']
                            if count and count > 1 then
                                count = count -1
                                iction.targetData[mobGUID]['spellData'][233490]['count'] = count
                            end
                        else
                            --- check for stack frames
                            if iction.stackFrames[mobGUID] and iction.stackFrames[mobGUID][spellID] then
                                iction.stackFrames[mobGUID][spellID]['font']:SetText("")
                                iction.stackFrames[mobGUID][spellID]['frame'].texture:SetVertexColor(0,0,0,0)
                                if iction.targetData[mobGUID]['spellData'] then
                                    if iction.targetData[mobGUID]['spellData'][spellID] and spellID == 233490 then
                                        iction.targetData[mobGUID]['spellData'][spellID]['count'] = 0
                                    end
                                end
                            end
                        end
                    end

                    --- DESTRO ARTIFACT OPENING CAST
                    if eventName == "SPELL_SUMMON" and spellName == 'ShadowyTear' or spellName == "Summon Darkglare" or spellName == "Chaos Tear" or spellName == "Unstable Tear" and event == "COMBAT_LOG_EVENT_UNFILTERED" then
                        iction.createTarget(UnitGUID("Target"), mobName, spellName, "DEBUFF", spellID) -- wow thte GUID for this isn't the freaking targeted mob.. wtf
                    end
                end
            end
        end
    end
    mainFrame:SetScript("OnEvent", eventHandler)
    -- ON UPDATE CHECKS
    local function _onUpdate()
        local shards = UnitPower("Player", 7)
        iction.setSoulShards(shards)
        iction.setConflagCount()
        iction.oocCleanup()
        iction.setMTapBorder()
        iction.currentTargetDebuffExpires()
        iction.updateTimers()
    end
    mainFrame:SetScript("OnUpdate", _onUpdate)
    mainFrame:UnregisterEvent("ADDON_LOADED")
end