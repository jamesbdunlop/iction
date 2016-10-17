local next = next
----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET ------------------------------------------------------------------
function iction.createTarget(guid, creatureName, spellName, spellType)
    if iction.debug then print("Dbg: iction.createTarget..") end
    local frm
    if guid ~= nil then
        if guid ~= iction.playerGUID then
            frm = iction.createSpellFrame(creatureName, guid, "Interface\\ChatFrame\\ChatFrameBackground")
        elseif guid == iction.playerGUID then frm = iction.createPlayerBuffFrame() end

        if iction.debug then print("Creating buttons.") end
        if frm then iction.createButtons(frm, guid, spellType) end

        if iction.debug then print("Target Data") end
        iction.createTargetData(guid, creatureName)

        if iction.debug then print("Target SpellData") end
        iction.createTargetSpellData(guid, spellName, spellType)

        if iction.debug then print("Target createTargetSpellData") end
        iction.createExpiresData(guid, spellName, spellType, nil)

        if iction.debug then print("Target created successfully") end
    end
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE TABLE ENTRY ------------------------------------------------------------------
function iction.createTargetData(guid, creatureName)
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

function iction.createTargetSpellData(guid, spellName, spellType)
    if not iction.spellActive(guid, spellName) then
        iction.targetData[guid]['spellData'][spellName] = {}
        iction.targetData[guid]['spellData'][spellName]['spellType'] = spellType
        iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
    end
end

function iction.createExpiresData(guid, spellName, spellType, customExpires)
    local expires, finExpires
    if iction.targetData[guid]['spellData'] ~= nil then -- death handler as this freaks on res
        if spellType == 'BUFF' then
            --- UNITBUFF
            local _, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("Player", spellName)
            iction.targetData[guid]['spellData'][spellName]['endTime'] = expires

        else
            --- UNITDEBUFF
            -- Get UnitDebuff info and cache it into the table
            if customExpires == nil then
                local _, _, _, _, _, _, expiresOnTarget, _, _, _, _ = UnitDebuff("Target", spellName)
                if not expiresOnTarget then -- Handle for  demonfire channeling
                    local _, _, _, _, _, endTime, _, _ = UnitChannelInfo("Player")
                    if endTime ~= nil then
                        dur = endTime/1000.0 - GetTime()
                        finExpires =  GetTime() + dur
                    end
                else
                    finExpires = expiresOnTarget
                end
            else
                finExpires = customExpires
            end
            if iction.debug then print("expires: " .. tostring(expires) .. ' for spell: ' .. spellName) end
            iction.targetData[guid]['spellData'][spellName]['endTime'] = finExpires
            iction.updateTimers()
        end
    end
end

function iction.createButtons(frm, guid, spellType)
    -- If we've created a new frame add the buttons
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