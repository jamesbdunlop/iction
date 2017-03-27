local iction = iction
local GetTime = GetTime
----------------------------------------------------------------------------------------------
--- MAIN TIMER UPDATE ------------------------------------------------------------------------
function iction.runTimers()
    for guid, targetTable in pairs(iction.targetData) do
        if targetTable == nil then break end
        local spells = targetTable['spellData']
        if not spells then break end
        for spellID, spellData in pairs(spells) do
            if iction.validSpellID(spellID) then
                local buttonTable = targetTable['buttons']
                local spellButton = iction.fetchButton(buttonTable, spellID)
                local endTime = spellData['expires']['endTime']
                local count = spellData['expires']['count']
                if count and count ~= 0 then
                    spellButton.count:SetText(tostring(count))
                end

                if endTime then
                    local remainingT = (endTime - GetTime())
                    if remainingT > 60 then
                        remainingT = tonumber(string.format("%.1d m", remainingT/60.0))
                        spellButton.text:SetText(remainingT)
                        spellButton.setButtonState(spellButton, true, false, false, false)
                    elseif remainingT < 60 and remainingT > 0 then
                        remainingT = tonumber(string.format("%.1f", remainingT))
                        spellButton.text:SetText(remainingT)
                        spellButton.setButtonState(spellButton, true, false, false, false)
                    elseif remainingT <= 0 then
                        spellButton.text:SetText("")
                        spellButton.setButtonState(spellButton, false, false, false, false)
                    end
                else
                    spellButton.text:SetText("")
                    spellButton.setButtonState(spellButton, false, false, false, false)
                end
            end
        end
    end
    if iction.class == iction.L['Priest'] and iction.spec == 3 then
        iction.swdFrameUpdate()
        iction.voidFrameUpdate()
    end
end

function iction.fetchButton(buttonTable, spellID)
    for bSpellID, button in pairs(buttonTable) do
        if button == nil then break end
        if bSpellID == spellID then
            return button
    end end
    return nil
end

ictionBuffPadX = 0
ictionBuffPadY = 0
function iction.updateBuffTimers()
    for x = 1, 100 do
        local spellName, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitAura("Player", x, "CANCELABLE|PLAYER|HELPFUL")
        if not spellName then break end

        local active, button = iction.isBuffInCacheData(spellName)
        if not active then
            local spellData = {}
                  spellData['uiName'] = spellName
                  spellData['spellID'] = spellID
                  spellData['count'] = count
                  spellData['expires'] = expires
                  spellData['icon'] = icon
            local butFrameBldr = {}
                  setmetatable(butFrameBldr, {__index = iction.UIButtonElement})
                  butFrameBldr.create(butFrameBldr, iction.buffFrameBldr.frame, spellData, "LEFT", ictionBuffPadX, ictionBuffPadY)
            spellData['frame'] = butFrameBldr
            table.insert(iction.buffButtons, spellData)
            if iction.debugBuffs then print("Added buffButton spellID:" ..tostring(spellID)) end
            if iction.debugBuffs then print("Added buffButton spellName:" ..tostring(spellName)) end
            if iction.debugBuffs then print("-------") end

            ictionBuffPadX = ictionBuffPadX + iction.bw + iction.ictionButtonFramePad
            local remainingT = (expires - GetTime())
            if remainingT > 60 then
                remainingT = tonumber(string.format("%.1d m", remainingT/60.0))
                butFrameBldr.text:SetText(remainingT)
                butFrameBldr.setButtonState(butFrameBldr, true, false, false, false)
            elseif remainingT < 60 and remainingT > 0 then
                remainingT = tonumber(string.format("%.1f", remainingT))
                butFrameBldr.text:SetText(remainingT)
                butFrameBldr.setButtonState(butFrameBldr, true, false, false, false)
            else
                butFrameBldr.text:SetText("")
                butFrameBldr.setButtonState(butFrameBldr, false, false, false, false)
            end
        else
            local remainingT = tonumber(string.format("%.1f", (button['expires'] - GetTime())))
            if remainingT < 120 and remainingT > 0 then
                button['frame'].text:SetText(remainingT)
        end end end
end

--- PRIEST SPECIFIC HANDLERS (TO REMOVE)
function iction.voidFrameUpdate()
    --- PRIEST VOID FRAME SPECIAL FRAME HANDLER
    local vbID = iction.vbID
    if iction.blizz_buffActive(194249) and not iction.isSpellOnCooldown(vbID) then
        iction.voidButtonBldr.setButtonColor(iction.voidButtonBldr, {0,0,0,0})
        iction.voidButtonBldr.text:SetText("")
        iction.voidButtonBldr.setButtonState(iction.voidButtonBldr, true, false, false, true)

    elseif iction.blizz_buffActive(194249) and iction.isSpellOnCooldown(vbID) then
        local _, duration, _ = GetSpellCooldown(vbID)
        if duration > 1.5 then
            local remainingT = iction.blizz_fetchCooldownET(vbID)
            local rt = iction.blizz_fetchRemainingT(remainingT - GetTime())
            iction.voidButtonBldr.text:SetText(rt)
            iction.voidButtonBldr.setButtonColor(iction.voidButtonBldr, {1, 0, 0, 1})
        end
        iction.voidButtonBldr.setButtonState(iction.voidButtonBldr, false, false, false, false)
    else
        iction.voidButtonBldr.setButtonColor(iction.voidButtonBldr, {0,0,0,0})
        iction.voidButtonBldr.setButtonState(iction.voidButtonBldr, false, true, false, false)
    end
end

function iction.swdFrameUpdate()
    --- PRIEST SHADOW WORD DEATH SPECIAL FRAME HANDLER
    local tguid = UnitGUID("Target")
    local swdID = iction.swdID
    local charges, maxCharges, start, duration = GetSpellCharges(swdID)

    iction.SWDButtonBldr.setButtonState(iction.SWDButtonBldr, false, false, false, false)

    if tguid and tguid ~= iction.playerGUID then
        if iction.blizz_getTargetHP() then
            iction.SWDButtonBldr.setButtonState(iction.SWDButtonBldr, true, false, false, true)
        else
            iction.SWDButtonBldr.setButtonState(iction.SWDButtonBldr, false, false, false, false)
        end
    end
    ---  ON COOLDOWN
    if iction.isSpellOnCooldown(swdID) then
        local _, duration, _ = GetSpellCooldown(swdID)
        if duration > 1.5 then
            local remainingT = iction.blizz_fetchCooldownET(swdID)
            local rt = iction.blizz_fetchRemainingT(remainingT - GetTime())
            iction.SWDButtonBldr.text:SetText(rt)
        end
    else
        iction.SWDButtonBldr.text:SetText("")
    end
end