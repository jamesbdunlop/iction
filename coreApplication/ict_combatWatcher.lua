local last = 0
local iction = iction
ictonCombat = false
function iction.watcher(self)
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_LEAVE_COMBAT")
    self:RegisterEvent("SPELL_AURA_REMOVED")
    self:RegisterEvent("SPELL_AURA_APPLIED")
    self:RegisterEvent("SPELL_AURA_APPLIED_DOSE")
    self:RegisterEvent("SPELL_DAMAGE")
    self:RegisterEvent("SPELL_CAST_SUCCESS")
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    self:RegisterEvent("UNIT_DIED")
    self:RegisterEvent("COMPANION_UPDATE")
    local function eventHandler(self, event, currentTime, eventName, sourceFlags, sourceGUID, sourceName, flags, prefix1,
                                prefix2, prefix3, sufx1,  sufx2,  sufx3,  sufx4,  sufx5,  sufx6,  sufx7, sufx8,  sufx9, ...)
        local spellName, mobName, mobGUID, spellType, spellID
        mobGUID = prefix2
        spellType = sufx6
        spellID = sufx3
        spellName = sufx4
        if sourceGUID == iction.playerGUID then
            if iction.debugWatcher then print("#############") end
            if iction.debugWatcher then print("event: " .. tostring(event)) end
            if iction.debugWatcher then print("eventName: " .. tostring(eventName)) end
            if iction.debugWatcher then print("sourceGUID: " .. tostring(sourceGUID)) end
            if iction.debugWatcher then print("mobGUID: " .. tostring(prefix2)) end
            if iction.debugWatcher then print("spellID: " .. tostring(sufx3)) end
            if iction.debugWatcher then print("sourceGUID: " .. tostring(sourceGUID)) end
            if iction.debugWatcher then print("spellName: " .. tostring(spellName)) end
            if iction.debugWatcher then print("spellType: " .. tostring(spellType)) end
            if iction.debugWatcher then print("spellID: " .. tostring(spellID)) end
            if iction.debugWatcher then print("prefix1: " .. tostring(prefix1)) end
            if iction.debugWatcher then print("prefix2: " .. tostring(prefix2)) end
            if iction.debugWatcher then print("prefix3: " .. tostring(prefix3)) end
            if iction.debugWatcher then print("sufx1: " .. tostring(sufx1)) end
            if iction.debugWatcher then print("sufx2: " .. tostring(sufx2)) end
            if iction.debugWatcher then print("sufx3: " .. tostring(sufx3)) end
            if iction.debugWatcher then print("sufx4: " .. tostring(sufx4)) end
            if iction.debugWatcher then print("sufx5: " .. tostring(sufx5)) end
            if iction.debugWatcher then print("sufx6: " .. tostring(sufx6)) end
            if iction.debugWatcher then print("sufx7: " .. tostring(sufx7)) end
            if iction.debugWatcher then print("sufx8: " .. tostring(sufx8)) end
            if iction.debugWatcher then print("sufx9: " .. tostring(sufx9)) end
            if iction.debugWatcher then print("-------") end
        end
        local function createTarget(mobGUID, spellType, spellID, spellName)
            --- Create the frame and icons for the timers
            if mobGUID and not iction.debuffColumns_GUIDExists(mobGUID) then
                iction.createTarget(mobGUID)
            end
            --- Create the spellData for the target
            if mobGUID and iction.debuffColumns_GUIDExists(mobGUID) then
                iction.createTargetSpellData(mobGUID, spellType, spellID, spellName)
            end
        end

        --- Set if we're in combat or not
        if UnitAffectingCombat("player") then
            ictonCombat = true
        else
            ictonCombat = false
            iction.oocCleanup()
        end

        --- SPEC CHANGE
        if event == 'PLAYER_SPECIALIZATION_CHANGED' then iction.specChanged() end

        --- TARGET CHANGE
        if event == 'PLAYER_TARGET_CHANGED' then
            iction.targetChanged(UnitGUID("Target"))
        end

        --- MOUNTING OR DISMOUNTING
        if event == "COMPANION_UPDATE" then
            iction.clearBuffButtons()
        end

        --- COMBAT STUFF
        if ictonCombat then
            if iction.class == iction.L['Priest'] and iction.spec == 3 then
                iction.voidFrameBldr.frame:Show()
                iction.SWDFrameBldr.frame:Show()
            end
        else
            iction.oocCleanup()
        end
        if mobGUID == iction.playerGUID then
            iction.clearBuffButtons()
        end

        if event == "COMBAT_LOG_EVENT_UNFILTERED" then
            if eventName == 'UNIT_DIED' then
                iction.targetsColumns_tagDead(mobGUID)
            end

            if ictonCombat and sourceGUID == iction.playerGUID and mobGUID ~= iction.playerGUID and eventName ~= "SPELL_CAST_FAILED" and eventName ~= "SPELL_CAST_START" then
                --- Account for some bullshit in the API where some events return this data and some return that....
                if eventName == "SPELL_PERIODIC_DAMAGE" or eventName == "SPELL_DAMAGE" then spellType = "DEBUFF" end

                if eventName == 'SPELL_AURA_REMOVED' and mobGUID == iction.playerGUID then
                    iction.clearBuffButtons()
                    createTarget(mobGUID, spellType, spellID, spellName)
                end

                if mobGUID ~= nil and string.find(mobGUID, "Creature", 1) then
                    --------------------------------------------------------------------------------------
                    --- COMBAT LOG USER CAST SPELLS ONLY
                    createTarget(mobGUID, spellType, spellID, spellName)
                end
            elseif ictonCombat and sourceGUID == iction.playerGUID and mobGUID ~= iction.playerGUID and eventName == "SPELL_CAST_START" then
                if mobGUID ~= nil and string.find(mobGUID, "Creature", 1) then
                    --------------------------------------------------------------------------------------
                    --- COMBAT LOG USER CAST SPELLS ONLY
                    createTarget(mobGUID, spellType, spellID, spellName)
                end
            end
        end
    end
    self:SetScript("OnEvent", eventHandler)

    -- ON UPDATE CHECKS
    local function _onUpdate(self, elapsed)
        last = last + elapsed
        if last >= .5 then
            local shards = UnitPower("Player", 7)
            iction.setSoulShards(shards)
            iction.setConflagCount()
            iction.runTimers()
            iction.targetChanged(UnitGUID("Target"))
            iction.updateBuffTimers()
        end
    end
    self:SetScript("OnUpdate", _onUpdate)
end
