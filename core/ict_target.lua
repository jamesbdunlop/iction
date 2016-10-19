local next = next
----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET ------------------------------------------------------------------
function iction.createTarget(guid, creatureName, spellName, spellType)
    if iction.debug then print("Dbg: iction.createTarget: " .. tostring(creatureName)) end
    if iction.debug then print("Dbg: spellName: " .. tostring(spellName)) end
    local frm
    if guid ~= nil then
        if guid ~= iction.playerGUID then
            frm = iction.createSpellFrame(creatureName, guid, "Interface\\ChatFrame\\ChatFrameBackground")
        elseif guid == iction.playerGUID then frm = iction.createPlayerBuffFrame() end

        if frm then iction.createButtons(frm, guid, spellType) end

        iction.createTargetData(guid, creatureName)

        iction.createTargetSpellData(guid, spellName, spellType)

        iction.createExpiresData(guid, spellName, spellType)

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
    if iction.spellActive(guid, spellName) then
        return
    else iction.spellActive(guid, spellName)
        iction.targetData[guid]['spellData'][spellName] = {}
        iction.targetData[guid]['spellData'][spellName]['spellType'] = spellType
        iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
        iction.targetData[guid]['spellData'][spellName]['count'] = 0
    end
end

function iction.createExpiresData(guid, spellName, spellType)
    if iction.targetData[guid]['spellData'] ~= nil then -- death handler as this freaks on res
        if spellType == 'BUFF' then
            --- UNITBUFF
            local _, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("Player", spellName)
            iction.targetData[guid]['spellData'][spellName]['endTime'] = expires
        else
            --- UNITDEBUFF
            local _, _, _, _, _, endTime, _, _ = UnitChannelInfo("Player")
            if endTime ~= nil then
                local cexpires
                local dur = endTime/1000.0 - GetTime()
                local cexpires =  GetTime() + dur
                iction.targetData[guid]['spellData'][spellName]['endTime'] = cexpires
            else
                local _, _, _, count, _, _, expires, _, _, _, _, _, _, _, _, _, _, _, _ = UnitDebuff("Target", spellName, nil, "PLAYER")
                if expires then
                    iction.targetData[guid]['spellData'][spellName]['endTime'] = expires
                else
                    -- pull from the spellList instead, cause the API sucks and is returning nil (agony or sow the seeds, rof)
                    for i = 1, iction.tablelength(iction.uiPlayerSpellButtons) do
                        if iction.uiPlayerSpellButtons[i]['name'] == spellName then
                            expires = iction.uiPlayerSpellButtons[i]['duration'] + GetTime()
                            iction.targetData[guid]['spellData'][spellName]['endTime'] = expires
                        end
                    end
                end

                if spellName == "Unstable Affliction" then
                    count = iction.targetData[guid]['spellData'][spellName]['count'] + 1
                end

                if count and count ~= 0 then
                    iction.targetData[guid]['spellData'][spellName]['count'] = count
                end
            end
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