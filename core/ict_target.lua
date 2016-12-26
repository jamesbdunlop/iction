local next = next
local localizedClass, _, _ = UnitClass("Player")

----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET ------------------------------------------------------------------
function iction.createTarget(guid, creatureName, spellName, spellType, spellID)
    local frm
    if guid ~= nil then
        if guid ~= iction.playerGUID then
            frm = iction.createSpellFrame(creatureName, guid, "Interface\\ChatFrame\\ChatFrameBackground")
        elseif guid == iction.playerGUID then
            frm = iction.createPlayerBuffFrame() end

        if frm then iction.createButtons(frm, guid, spellType) frm:Show() end
        iction.createTargetData(guid, creatureName)
        iction.createTargetSpellData(guid, spellName, spellType, spellID)
        iction.createExpiresData(guid, spellName, spellType, spellID)
        if iction.debug then print("DONE") end
    end
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE TABLE ENTRY ------------------------------------------------------------------
function iction.createTargetData(guid, creatureName)
    if iction.debug then print("CreateTargetData") end
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
    if iction.debug then print("createTargetSpellData") end
    --- Create the base target spell timer tables for the spell cast if they don't exist
    if iction.spellIDActive(guid, spellID) then
        return
    else
        local name, _, _, _, _, _, _ = GetSpellInfo(spellID)
        iction.targetData[guid]['spellData'][spellID] = {}
        iction.targetData[guid]['spellData'][spellID]['spellType'] = spellType
        iction.targetData[guid]['spellData'][spellID]['spellName'] = name
        iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
        iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
        iction.targetData[guid]['spellData'][spellID]['count'] = 0
        iction.targetData[guid]['spellData'][spellID]['isChanneled'] = false
        iction.targetData[guid]['spellData'][spellID]['id'] = spellID
    end
end

function iction.createExpiresData(guid, spellName, spellType, spellID)
    if iction.debug then print("createExpiresData: " .. tostring(spellName)) end
    --- This is the inital setup for the spell data heading into the timers. Once this has fired
    --- the rest is taken care of by iction_utils.currentTargetDebuffExpires on update.
    if iction.targetData[guid]['spellData'] ~= nil then -- death handler as this freaks on res
        if spellType == 'BUFF' then
            local _, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("Player", spellName)
            if iction.targetData[iction.playerGUID]['spellData'] then
                if iction.targetData[iction.playerGUID]['spellData'][spellID] then
                    iction.targetData[iction.playerGUID]['spellData'][spellID]['endTime'] = expires
                end
            end

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
            local _, _, _, count, _, _, expires, _, _, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff("Target", spellID, nil, "PLAYER")
            local charges, maxCharges, start, duration = GetSpellCharges(spellID)
            if expires then
                iction.targetData[guid]['spellData'][spellID]['endTime'] = expires
            else
                -- pull from the spellList instead, cause the API sucks and is returning nil (agony or sow the seeds, rof)
                for i = 1, iction.tablelength(iction.uiPlayerSpellButtons) do
                    if iction.uiPlayerSpellButtons[i]['id'] == spellID then
                        if iction.uiPlayerSpellButtons[i]['duration'] ~= nil then
                            expires = iction.uiPlayerSpellButtons[i]['duration'] + GetTime()
                            iction.targetData[guid]['spellData'][spellID]['endTime'] = expires
                        end
                    end
                end
            end

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
    if iction.debug then print("createButtons") end
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
            b, fnt = iction.buttonBuild(frm, guid, iction.uiPlayerBuffButtons, padX, padY, true, 24)
        end
    end
    iction.targetButtons[guid]["buttonFrames"] = b
    iction.targetButtons[guid]["buttonText"] = fnt
end