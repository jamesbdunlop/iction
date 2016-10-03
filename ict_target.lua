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
        elseif guid == iction.playerGUID then
            if iction.debug then print("\t bff frm: " .. tostring(frm)) end
            frm = iction.createPlayerBuffFrame()
        end

        if frm then
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
    -- Add the base target deets into the table
    iction.createFreshTarget(guid, creatureName)
    iction.createTargetSpellData(guid, spellName, spellType)
    iction.createSpellData(guid, spellName, spellType)
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE TABLE ENTRY ------------------------------------------------------------------
function iction.createFreshTarget(guid, creatureName)
    if iction.debug then print("Dbg iction.createFreshTarget") end
    if iction.targetData[guid] then
        return
    else
        -- If the creatureGUID isn't in the table consider it a fresh target.
        if iction.debug then print("\t NEW TARGET") end
        iction.targetData[guid] = {}
        iction.targetData[guid]['name'] = creatureName
        iction.targetData[guid]['dead'] = false
        iction.targetData[guid]['spellData'] = {}
    end
end

function iction.createTargetSpellData(guid, spellName, spellType)
    if iction.spellActive(guid, spellName) ~= true then
        -- We have the creature being tracked already, just not this spell. Add it now
        if iction.debug then print("\t Adding spell " .. spellName .. " to table now.") end
        iction.targetData[guid]['spellData'][spellName] = {}
        iction.targetData[guid]['spellData'][spellName]['spellType'] = spellType
        iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
    else
        print('Spell was currently active!')
    end
end

function iction.createSpellData(guid, spellName, spellType)
    if iction.debug then print("Dbg iction.createSpellData: ") end
    if iction.targetData[guid]['spellData'] ~= nil then -- death handler as this freaks on res
        if iction.debug then print("\t Have table adding data now...") end
        if spellType == 'BUFF' then
            --- UNITBUFF
            local _, _, _, _, _, _, expires, _, _, _, _  = UnitBuff("Player", spellName)
            if iction.debug then print("\t Adding buff expires " .. tostring(expires)) end
            if expires ~= nil then
                iction.targetData[guid]['spellData'][spellName]['endTime'] = expires
            end
        else
            --- UNITDEBUFF
            local _, _, _, _, _, _, expires, _, _, _, _  = UnitDebuff("Target", spellName)
            if iction.debug then print("\t Adding debuff expires " .. tostring(expires)) end
            if expires ~= nil then
                iction.targetData[guid]['spellData'][spellName]['endTime'] = expires
                if iction.debug then print("expires: " .. expires) end
            end
        end
    end
end
