function iction.ictionPriestFrameWatcher(mainFrame)
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
            local function specChanged()
                local spec = GetSpecialization()
                if iction.spec ~= spec then
                    iction.spec = spec
                    DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionInfo] Iction has detected a spec change. If you find things going a bit weird. Reload the ui using /reload ui!", 15, 25, 35)
                    -- Cleanup various elements now.
                    if iction.targetFrames[iction.playerGUID] ~= nil then
                        for i=1, iction.tablelength(iction.targetButtons[iction.playerGUID]["buttonFrames"]) do
                            if iction.targetButtons[iction.playerGUID]["buttonFrames"][i] ~= nil then
                                iction.targetButtons[iction.playerGUID]["buttonFrames"][i]:Hide()
                                iction.targetButtons[iction.playerGUID]["buttonFrames"][i] = nil
                            end
                        end
                        for i=1, iction.tablelength(iction.targetButtons[iction.playerGUID]["buttonText"]) do
                            if iction.targetButtons[iction.playerGUID]["buttonText"][i] ~= nil then
                                iction.targetButtons[iction.playerGUID]["buttonText"][i]:Hide()
                                iction.targetButtons[iction.playerGUID]["buttonText"][i] = nil
                            end
                        end
                        iction.targetFrames[iction.playerGUID]:Hide()
                        iction.targetFrames[iction.playerGUID] = nil
                    end

                    iction.shardFrame = nil
                    iction.highlightFrameTexture = nil

                    -- Now recreate the button libs
                    iction.setDebuffButtonLib()
                    iction.setBuffButtonLib()
                    -- Conflag frame for destro spec
                    if iction.spec == 3 then
                        iction.createConflagFrame()
                    else
                        if iction.conflagFrame ~= nil then
                            iction.conflagFrame:Hide()
                        end
                    end
                    -- Reset all soul shard images to 0 as the shard count resets on spec change
                    for i = 1, iction.tablelength(iction.soulShards) do
                        if iction.soulShards[i] ~= nil then
                            iction.soulShards[i]:Hide()
                        end
                    end
                    iction.createShardFrame()
                    local shards = UnitPower("Player", 7)
                    iction.setSoulShards(shards)
                    -- Change the artifact frame
                    iction.createArtifactFrame()
                    -- Reset highlightframe size for buttons changes
                    iction.highlightFrameTexture = iction.createHighlightFrame()
                end
            end
            specChanged()
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
                    if eventName == "SPELL_AURA_APPLIED_DOSE" then
                        if iction.spellIDActive(mobGUID, spellID) then
                            if spellID == 205372 then
                                iction.targetData[mobGUID]['spellData'][spellID]['count'] = sufx7
                                iction.targetData[mobGUID]['spellData'][spellID]['endTime'] = GetTime() + 5
                            end
                        end
                    end

                    --- SPELL AURA APPLIED
                    if eventName == "SPELL_AURA_APPLIED" then --- ignore channelDemonfire here
                        if spellID == 15407 then iction.clearChannelData() end      --- MindFlay
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

                    elseif eventName == "SPELL_ENERGIZE" then
                        --- MindBlast OPENING CAST
                        if spellID == 8092 then                                     --- MindBlast
                            iction.createTarget(UnitGUID("Target"), mobName, spellName, "DEBUFF", spellID)
                        end
                    elseif eventName == "SPELL_AURA_REFRESH" then
                        iction.clearChannelData()
                        iction.createTarget(mobGUID, mobName, spellName, spellType, spellID)

--                    elseif eventName == "SPELL_CAST_SUCCESS" then
--                        print("")
--
--                    elseif eventName == "SPELL_PERIODIC_DAMAGE" then
--                        print("")

                    elseif eventName == "SPELL_AURA_REMOVED" then
                        local channeledSpellID, cexpires = iction.getChannelSpell()
                        local isChannelActive, channelguid = iction.channelActive(channeledSpellID)
                        if not isChannelActive then
                            iction.clearChannelData()
                        end

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
    local function _onUpdate()
        iction.oocCleanup()
        iction.setMTapBorder()
        iction.currentTargetDebuffExpires()
        iction.currentBuffExpires()
        iction.updateTimers()
    end
    mainFrame:SetScript("OnUpdate", _onUpdate)
    mainFrame:UnregisterEvent("ADDON_LOADED")
end