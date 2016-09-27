local next = next
----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET ------------------------------------------------------------------
function iction.createTarget(guid, creatureName, spellName, spellType)
    if guid ~= nil then
        if iction.debug then print("Dbg iction.createTarget: ") end
        if iction.debug then print("\t guid: " .. tostring(guid)) end
        if iction.debug then print("\t creatureName: " .. tostring(creatureName)) end
        if iction.debug then print("\t spellName: " .. tostring(spellName)) end
        if iction.debug then print("\t spellType: " .. tostring(spellType)) end
        local frm
        -- Create the base spell button frame for the target
        if guid ~= iction.playerGUID then
            if iction.debug then print("\t tgt frm: " .. tostring(frm)) end
            frm = iction.createSpellFrame(creatureName, guid, "Interface\\ChatFrame\\ChatFrameBackground")
        else
            if iction.debug then print("\t bff frm: " .. tostring(frm)) end
            frm = iction.createPlayerBuffFrame()
        end

        if frm and guid ~= iction.playerGUI then
            -- If we've created a new frame add the buttons
            iction.targetButtons[guid] = {}
            local tgF = iction.targetButtons[guid]
            if iction.debug then print("\t tgF: " .. tostring(tgF)) end
            local padX, padY
            padX = iction.ictionButtonFramePad
            padY = 0
            if not iction.ictionHorizontal then
                padX = 0
                padY = iction.ictionButtonFramePad
            end

            if iction.debug then print("\t padX: " .. padX) end
            if iction.debug then print("\t padY: " .. padY) end
            local b, fnt
            if spellType == 'DEBUFF' then
                b, fnt = iction.addButtons(frm, guid, iction.uiPlayerSpellButtons, padX, padY, false)
            else
                b, fnt = iction.addButtons(frm, guid, iction.uiPlayerBuffButtons, padX, padY, true)
            end
            if iction.debug then print("\t b: " .. tostring(b)) end
            if iction.debug then print("\t fnt: " .. tostring(fnt)) end
            tgF["buttonFrames"] = b
            tgF["buttonText"] = fnt
        end
    end
    -- Add the target details into the table
    iction.createTargetData(guid, creatureName, spellName, spellType)
end

----------------------------------------------------------------------------------------------
--- CREATE SPELL TIMER DATA ------------------------------------------------------------------
function iction.createTargetData(guid, creatureName, spellName, spellType)
    if iction.debug then print("Dbg iction.createTargetData") end
    if iction.targetData[guid] then
        if iction.debug then for k, v in pairs(iction.targetData[guid]) do print("\t k: " .. tostring(k), "\t v: " .. tostring(v)) end end
    end

    if not iction.targetData[guid] then
        -- If the creatureGUID isn't in the table consider it a fresh target.
        if iction.debug then print("\t new target") end
        iction.targetData[guid] = {}
        iction.targetData[guid]['name'] = creatureName
        iction.targetData[guid]['spellData'] = {}
        iction.targetData[guid]['spellData'][spellName] = {}
        iction.targetData[guid]['spellData'][spellName]['spellType'] = spellType
        iction.targetData[guid]['spellData'][spellName]['endTime'] = 0
        iction.targetData[guid]['dead'] = false

    elseif iction.spellActive(guid, spellName) ~= true then
        if iction.debug then print("\t updating spell") end
        -- We have the creature being tracked already, just not this spell. Add it now
        if iction.targetData[guid]['spellData'] ~= nil then -- death handler as this freaks on res
            iction.targetData[guid]['spellData'][spellName] = {}
            iction.targetData[guid]['spellData'][spellName]['spellType'] = spellType
            iction.targetData[guid]['spellData'][spellName]['endTime'] = 0
        else
            iction.targetData[guid]['spellData'][spellName] = {}
            iction.targetData[guid]['spellData'][spellName]['spellType'] = spellType
            iction.targetData[guid]['spellData'][spellName]['endTime'] = 0
        end
    end

    if iction.targetData[guid]['spellData'] ~= nil then -- death handler as this freaks on res
        -- we have an active creature and an active spell. Update the spelltimers endTime now
        if iction.targetData[guid]['spellData'][spellName]['endTime'] ~= 0 then
            if spellType == 'BUFF' then
                iction.currentTargetBuffExpires()
            end
        else
            if spellType == 'BUFF' then
                --- UNITBUFF for Mana Tap
                local name, rank, icon, count, debuffType, duration, expires, unitCaster, isStealable, shouldConsolidate, spellId  = UnitBuff("Player", spellName)
                if expires ~= nil then
                    iction.targetData[guid]['spellData'][spellName]['endTime'] = expires
                end
            else
                --- UnitDebuff
                local name, rank, icon, count, debuffType, duration, expires, unitCaster, isStealable, shouldConsolidate, spellId  = UnitDebuff("Target", spellName)
                -- VERY ANNOYING to have to duplicate this code!
                if expires ~= nil then
                    iction.targetData[guid]['spellData'][spellName]['endTime'] = expires
                end
            end
        end
    end
end