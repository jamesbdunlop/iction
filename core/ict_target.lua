local next = next
----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET ------------------------------------------------------------------
function iction.createTarget(guid, creatureName, spellName, spellType, spellID)
    local frm
    if guid ~= nil then
        if guid ~= iction.playerGUID then
            frm = iction.createSpellFrame(creatureName, guid, "Interface\\ChatFrame\\ChatFrameBackground")
        elseif guid == iction.playerGUID then
            frm = iction.createPlayerBuffFrame() end

        if iction.debug then print("\tfrm: "  .. tostring(frm)) end
        if frm then iction.createButtons(frm, guid, spellType) end
        iction.createTargetData(guid, creatureName)
        iction.createTargetSpellData(guid, spellName, spellType, spellID)
        iction.createExpiresData(guid, spellName, spellType, spellID)

        --- This is necesssary for making sure a cast spell with a target switched lands with correct duration
        if spellType == 'DEBUFF' then
            iction.currentTargetDebuffExpires()
        else
            iction.currentBuffExpires()
        end
        if iction.debug then print("Target successfully created") end
    end
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE TABLE ENTRY ------------------------------------------------------------------
function iction.createTargetData(guid, creatureName)
    --- Create the base target info tables if they don't exist
    if iction.targetData[guid] then
        return
    else
        iction.targetData[guid] = {}
        iction.targetData[guid]['guid'] = guid
        iction.targetData[guid]['name'] = creatureName
        iction.targetData[guid]['dead'] = false
        iction.targetData[guid]['spellData'] = {}
    end
end

function iction.createTargetSpellData(guid, spellName, spellType, spellID)
    --- Create the base target spell timer tables for the spell cast if they don't exist
    if iction.spellIDActive(guid, spellID) then
        return
    else
        iction.targetData[guid]['spellData'][spellID] = {}
        iction.targetData[guid]['spellData'][spellID]['spellType'] = spellType
        iction.targetData[guid]['spellData'][spellID]['spellName'] = spellName
        iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
        iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
        iction.targetData[guid]['spellData'][spellID]['count'] = 0
        iction.targetData[guid]['spellData'][spellID]['isChanneled'] = false
        iction.targetData[guid]['spellData'][spellID]['id'] = spellID
    end
end

function iction.createExpiresData(guid, spellName, spellType, spellID)
    --- This is the inital setup for the spell data heading into the timers. Once this has fired
    --- the rest is taken care of by iction_utils.currentTargetDebuffExpires on update.
    if iction.targetData[guid]['spellData'] ~= nil then -- death handler as this freaks on res
        if spellType == 'BUFF' then
            local _, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("Player", spellName)
            iction.targetData[iction.playerGUID]['spellData'][spellID]['endTime'] = expires

        elseif spellType == 'DEBUFF' then
            local channelSpellID, cexpires = iction.getChannelSpell()
            if cexpires then
                if iction.isValidButtonFrame(guid) then
                    if iction.targetData[guid]['spellData'][channelSpellID] then
                        iction.targetData[guid]['spellData'][channelSpellID]['endTime'] = cexpires
                        iction.targetData[guid]['spellData'][channelSpellID]['isChanneled'] = true
                    end
                end
            end
            -- Adding this as a clean run through due to casting drain soul which seeding which will ignite into corruptions.
            local _, _, _, count, _, _, expires, _, _, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff("Target", spellName, nil, "PLAYER")
            if expires then
                iction.targetData[guid]['spellData'][spellID]['endTime'] = expires
            else
                -- pull from the spellList instead, cause the API sucks and is returning nil (agony or sow the seeds, rof)
                for i = 1, iction.tablelength(iction.uiPlayerSpellButtons) do
                    if iction.uiPlayerSpellButtons[i]['id'] == spellID then
                        expires = iction.uiPlayerSpellButtons[i]['duration'] + GetTime()
                        iction.targetData[guid]['spellData'][spellID]['endTime'] = expires
                    end
                end
            end

--            if spellID == 233490 then
--                if iction.isValidButtonFrame(guid) then
--                    count = iction.targetData[guid]['spellData'][spellID]['count'] + 1
--                end
--            end

            if count and count ~= 0 then
                if iction.isValidButtonFrame(guid) then
                    if iction.targetData[guid]['spellData'][spellID]['count'] ~= nil then
                        iction.targetData[guid]['spellData'][spellID]['count'] = count
                    end
                end
            end
        end
    end
end

function iction.createButtons(frm, guid, spellType)
    --- If we've created a new frame add the buttons
    iction.targetButtons[guid] = {}
    local padX, padY
    local b, fnt
    if spellType == 'DEBUFF' then
        padX = 0
        padY = iction.ictionButtonFramePad
        if frm:GetAttribute("name") == 'ictionDeBuffFrame' then
            b, fnt = iction.buttonBuild(frm, guid, iction.uiPlayerSpellButtons, padX, padY, false)
        end
    else
        padX = iction.ictionButtonFramePad
        padY = 0
        if frm:GetAttribute("name") == 'ictionBuffFrame' then
            b, fnt = iction.buttonBuild(frm, guid, iction.uiPlayerBuffButtons, padX, padY, true)
        end
    end
    iction.targetButtons[guid]["buttonFrames"] = b
    iction.targetButtons[guid]["buttonText"] = fnt
end