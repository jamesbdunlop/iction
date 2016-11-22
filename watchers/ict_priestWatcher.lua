local last = 0
function iction.ictionPriestFrameWatcher(mainFrame)
    mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
                end
            end
            removeDead()
            iction.highlightTargetSpellframe(UnitGUID("Target"))
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
                    if eventName == "SPELL_AURA_APPLIED_DOSE" then
                        if iction.spellIDActive(mobGUID, spellID) then
                            if spellID == 205372 then
                                iction.targetData[mobGUID]['spellData'][spellID]['count'] = sufx7
                                iction.targetData[mobGUID]['spellData'][spellID]['endTime'] = GetTime() + 5
                            end
                        end
                    end

                    --- SPELL AURA APPLIED
                    if eventName == "SPELL_AURA_APPLIED" then
                        if spellID == 15407 then iction.clearChannelData() end      --- MindFlay
                        if spellID == 124430 then
                            iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)
                        else
                            iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)
                        end


                    elseif eventName == "SPELL_ENERGIZE" then
                        --- MindBlast OPENING CAST
                        if spellID == 8092 then                                     --- MindBlast
                            iction.createTarget(UnitGUID("Target"), mobName, spellName, "DEBUFF", spellID)
                        end

                    elseif eventName == "SPELL_AURA_REFRESH" then
                        iction.clearChannelData()
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

                    elseif eventName == "SPELL_CAST_SUCCESS" then
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

                    elseif eventName == "SPELL_AURA_REMOVED" then
                        local channeledSpellID, cexpires = iction.getChannelSpell()
                        local isChannelActive, channelguid = iction.channelActive(channeledSpellID)
                        if not isChannelActive then
                            iction.clearChannelData()
                        end
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

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
            end
        end
    end

    mainFrame:SetScript("OnEvent", eventHandler)
    -- ON UPDATE CHECKS
    local function _onUpdate(self, elapsed)
        iction.getTargetHP()
        last = last + elapsed
        if last >= 1 then
            iction.oocCleanup()
            iction.setMTapBorder()
            iction.currentTargetDebuffExpires()
            iction.currentBuffExpires()
            iction.updateTimers()
        end
    end
    mainFrame:SetScript("OnUpdate", _onUpdate)
    mainFrame:UnregisterEvent("ADDON_LOADED")
end