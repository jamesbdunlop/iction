function iction.ictionFrameWatcher(mainFrame)
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
        mobGUID = prefix2 or UnitGUID("Target")
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
            iction.currentTargetDebuffExpires()
            return
        end

        --------------------------------------------------------------------------------------
        --- UNIT DIED
        if sourceGUID == iction.playerGUID and eventName == "UNIT_DIED" then
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
            local buttonTexts = iction.targetButtons[guid]["buttonText"]
            for i = 1, iction.tablelength(buttonTexts) do
                if buttonTexts[i] ~= nil then buttonTexts[i]:SetText("") end
            end
        end

        --------------------------------------------------------------------------------------
        if sourceGUID == iction.playerGUID then
            if event == "SPELL_CAST_FAILED" then
                iction.currentTargetDebuffExpires()
            elseif event == "PLAYER_REGEN_ENABLED" then iction.oocCleanup() return
            elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
                if spellName == 'Channel Demonfire' and eventName ~= "SPELL_PERIODIC_DAMAGE" then
                    print("#####################")
                    print('eventName: ' ..tostring(eventName))
                    print('spellID: ' ..tostring(spellID))
                    print('mobGUID: ' ..tostring(mobGUID))
                    print('spellType: ' ..tostring(spellType))
                    print("#####################")
                end
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
                        iction.createTarget(mobGUID, mobName, spellName, spellType)
                    end

                    --- UPDATE SPELL COUNT
                    if eventName == "SPELL_AURA_APPLIED_DOSE" and sufx6 == "DEBUFF" then
                        if iction.spellActive(mobGUID, spellName) then iction.targetData[mobGUID]['spellData'][spellName]['count'] = sufx7 end
                    end

                    --- SPELL AURA APPLIED
                    if eventName == "SPELL_AURA_APPLIED" and spellID ~= 196447 then --- ignore channelDemonfire here
                        iction.createTarget(mobGUID, mobName, spellName, spellType)

                    elseif eventName == "SPELL_ENERGIZE" then
                        --- CONFLAG OPENING CAST
                        if spellID == 17962 then
                            iction.createTarget(UnitGUID("Target"), mobName, spellName, "DEBUFF")
                        end

                    elseif eventName == "SPELL_CAST_SUCCESS" then
                        if spellID == 980 then                              --- AGONY
                            iction.createTarget(mobGUID, mobName, spellName, spellType)
                        elseif spellID == 196447 then                       --- CHANNEL DEMON FIRE
                            iction.createTarget(UnitGUID("Target"), mobName, spellName, spellType)
                        end

                    elseif eventName == "SPELL_AURA_REMOVED" then
                        iction.clearChannelData()
                        if spellID == 111400 then                           --- BURNING RUSH
                            iction.createTarget(mobGUID, mobName, spellName, "BUFF")
                        elseif spellID == 27243 then
                            iction.clearAllSeeds(mobGUID)
                        else
                            --- check for stack frames
                            if iction.stackFrames[mobGUID] and iction.stackFrames[mobGUID][spellName] then
                                iction.stackFrames[mobGUID][spellName]['font']:SetText("")
                                iction.stackFrames[mobGUID][spellName]['frame'].texture:SetVertexColor(0,0,0,0)
                                if iction.targetData[mobGUID]['spellData'] then
                                    if iction.targetData[mobGUID]['spellData'][spellName] and spellName == "Unstable Affliction" then
                                        iction.targetData[mobGUID]['spellData'][spellName]['count'] = 0
                                    end
                                end
                            end
                        end

                    elseif eventName == "SPELL_AURA_REFRESH" then
                        iction.setMTapBorder()
                        iction.createTarget(mobGUID, mobName, spellName, spellType)
                    end

                    --- DESTRO ARTIFACT OPENING CAST
                    if eventName == "SPELL_SUMMON" and spellName == 'ShadowyTear' or spellName == "Summon Darkglare" or spellName == "Chaos Tear" or spellName == "Unstable Tear" and event == "COMBAT_LOG_EVENT_UNFILTERED" then
                        iction.createTarget(UnitGUID("Target"), mobName, spellName, "DEBUFF") -- wow thte GUID for this isn't the freaking targeted mob.. wtf
                    end
                    iction.currentTargetDebuffExpires()
                end
            end
        end
    end
    mainFrame:SetScript("OnEvent", eventHandler)
    -- ON UPDATE CHECKS
    local function _onUpdate()
        local shards = UnitPower("Player", 7)
        iction.updateTimers()
        iction.setSoulShards(shards)
        iction.setConflagCount()
        iction.oocCleanup()
        iction.setMTapBorder()
    end
    mainFrame:SetScript("OnUpdate", _onUpdate)
    mainFrame:UnregisterEvent("ADDON_LOADED")
end