local last = 0
function iction.ictionPriestFrameWatcher(mainFrame)
    mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
--        if sourceGUID == iction.playerGUID and eventName == "SPELL_CAST_SUCCESS" then
--            print('spellType spellName: ' .. tostring(spellName))
--            print('spellType spcstSuc: ' .. tostring(sufx6))
--        end

        if sourceGUID == iction.playerGUID and eventName == "SPELL_CAST_SUCCESS" or eventName == "SPELL_PERIODIC_DAMAGE" or eventName == "SPELL_DAMAGE" then
            spellType = "DEBUFF"
        else
            spellType = sufx6
        end

--        if sourceGUID == iction.playerGUID and spellID == 32379 then
--            print("eventName: " .. tostring(eventName))
--            print("spellID: " .. tostring(spellID))
--            print("spellName: " .. tostring(spellName))
--            print("spellType: " .. tostring(spellType))
--            print("#####")
--        end
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
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

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
                    --- SWD
                    if mobGUID ~= iction.playerGUID and iction.targetData[mobGUID] then
                        local swdID = 32379
                        if iction.targetData[mobGUID]['spellData'][swdID] == nil then
                            iction.createTarget(mobGUID, "", "Shadow Word: Death", "DEBUFF", swdID)
                        end
                        if iction.isValidButtonFrame(mobGUID) then
                            local charges, _, _, _ = GetSpellCharges(swdID)
                            local timerText = iction.targetButtons[mobGUID]["buttonText"][swdID]
                            local timerButtonFrame = iction.targetButtons[mobGUID]["buttonFrames"][swdID]
                            local charges, _, _, _ = GetSpellCharges(swdID)
                            if charges ~= nil and charges ~= 0 then
                                iction.targetData[mobGUID]['spellData'][swdID]['count'] = charges
                                iction.createStackFrame(mobGUID, "SWD", charges, timerText, timerButtonFrame, swdID)
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
        last = last + elapsed
        if last >= .15 then
            iction.currentTargetDebuffExpires()
            iction.oocCleanup()
            iction.setMTapBorder()
            iction.currentBuffExpires()
        end
        iction.updateTimers()
    end
    mainFrame:SetScript("OnUpdate", _onUpdate)
    mainFrame:UnregisterEvent("ADDON_LOADED")
end