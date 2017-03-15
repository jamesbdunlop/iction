local last = 0
local iction = iction

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
    mainFrame:RegisterEvent("UNIT_DIED")
    local function eventHandler(self, event, currentTime, eventName, sourceFlags, sourceGUID, sourceName, flags, prefix1,
                                prefix2, prefix3, sufx1,  sufx2,  sufx3,  sufx4,  sufx5,  sufx6,  sufx7, sufx8,  sufx9, ...)
        --- CATCH REGEN AND EXIT EARLY
        if not sourceGUID == iction.playerGUID then return end
--        if not UnitAffectingCombat("player") then
--            iction.oocCleanup()
--            return
--        end
        local spellName, mobName, mobGUID, spellType, spellID
        spellName = sufx4
        mobName = prefix3
        mobGUID = prefix2
        spellType = sufx6
        spellID = sufx3
        if iction.debugUITimers then print("#############") end
        if iction.debugUITimers then print("event: " .. tostring(event)) end
        if iction.debugUITimers then print("eventName: " .. tostring(eventName)) end
        if iction.debugUITimers then print("sourceGUID: " .. tostring(sourceGUID)) end
        if iction.debugUITimers then print("spellName: " .. tostring(spellName)) end
        if iction.debugUITimers then print("mobName: " .. tostring(mobName)) end
        if iction.debugUITimers then print("mobGUID: " .. tostring(mobGUID)) end
        if iction.debugUITimers then print("spellType: " .. tostring(spellType)) end
        if iction.debugUITimers then print("spellID: " .. tostring(spellID)) end
        if iction.debugUITimers then print("prefix1: " .. tostring(spellID)) end
        if iction.debugUITimers then print("sufx1: " .. tostring(sufx1)) end
        if iction.debugUITimers then print("sufx2: " .. tostring(sufx2)) end
        if iction.debugUITimers then print("sufx3: " .. tostring(sufx3)) end
        if iction.debugUITimers then print("sufx4: " .. tostring(sufx4)) end
        if iction.debugUITimers then print("sufx5: " .. tostring(sufx5)) end
        if iction.debugUITimers then print("sufx6: " .. tostring(sufx6)) end
        if iction.debugUITimers then print("sufx7: " .. tostring(sufx7)) end
        if iction.debugUITimers then print("sufx8: " .. tostring(sufx8)) end
        if iction.debugUITimers then print("sufx9: " .. tostring(sufx9)) end
        if iction.debugUITimers then print("#############") end

        --- Ignore pet spells
        if mobGUID ~= nil then if string.find(mobGUID, "Pet", 1) then return end end

        if eventName == "SPELL_PERIODIC_DAMAGE" or eventName == "SPELL_DAMAGE" then
            spellType = "DEBUFF"
        end

        --------------------------------------------------------------------------------------
        --- COMBAT LOG USER CAST SPELLS ONLY
        if event == 'COMBAT_LOG_EVENT_UNFILTERED' and mobGUID ~= iction.playerGIUD then
            if eventName ~= "SPELL_CAST_SUCCESS" then
                local function createTarget(mobGUID, spellType, spellID)
                    iction.createTarget(mobGUID)
                    if iction.debuffColumns_GUIDExists(mobGUID) then
                        iction.createTargetSpellData(mobGUID, spellType, spellID)
                    end
                end

                if eventName == "SPELL_CAST_START" then
                    if iction.debugUITimers then
                        createTarget(mobGUID, spellType, spellID)
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
            local shards = UnitPower("Player", 7)
--            iction.setSoulShards(shards)
--            iction.setConflagCount()
--            iction.oocCleanup()
--            iction.currentTargetDebuffExpires()
--            iction.updateTimers()
        end
    end
    mainFrame:SetScript("OnUpdate", _onUpdate)
end
