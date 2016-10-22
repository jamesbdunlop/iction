----------------------------------------------------------------------------------------------
--- MAIN TIMER UPDATE ------------------------------------------------------------------------

function iction.spellActiveCooldown(guid, spellName, remainingT)
    local remainingT = tonumber(string.format("%.1d", remainingT))
    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName], true)
    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellName], true, {1,.8,.8, 1})
end

function iction.spellInfinite(guid, spellName, infinite)
    if infinite then
        iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName])
        iction.setButtonText("∞", false, iction.targetButtons[guid]['buttonText'][spellName])
    else
        iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
        iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
    end
end

function iction.spellActiveTimer(guid, spellName, remainingT)
    local remainingT = tonumber(string.format("%.1d", remainingT))
    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName], false)
    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellName])
end

function iction.spellFadingTimer(guid, spellName, remainingT)
    local remainingT = tonumber(string.format("%.1f", remainingT))
    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName], true)
    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellName])
end

function iction.isValidButtonFrame(guid)
    if iction.targetButtons[guid] and iction.targetButtons[guid]['buttonFrames'] then
        return true
    else
        return false
    end
end

function iction.isSpellOnCooldown(spellName)
    local start, duration, enable = GetSpellCooldown(spellName)
    if start == 0 then
        return false
    elseif start == nil then
        return false
    else
        return true
    end
end

function iction.fetchCooldownET(spellName)
    local start, duration, _ = GetSpellCooldown(spellName)
    local actualFinish = start+duration
    local et = (actualFinish - GetTime()) + GetTime()

    if start == 0 then
        return false
    else
        return et
    end
end

function iction.spellHasEnded(guid, spellName)
    iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
    iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
    iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
    -- Set the cooldown
    if not iction.isSpellOnCooldown(spellName) then
        iction.targetData[guid]['spellData'][spellName]['coolDown'] = nil
    end
end

function iction.createStackFrame(guid, spellName, count, timerText, timerButtonFrame)
    if not iction.stackFrames[guid] then
        iction.stackFrames[guid] = {}
    end

    if not iction.stackFrames[guid][spellName] then
        local stackFrameData = iction.ictStackFrameData
        stackFrameData['uiParentFrame'] = iction.targetButtons[guid]['buttonFrames'][spellName]
        stackFrameData['point']['p'] = iction.targetButtons[guid]['buttonFrames'][spellName]
        stackFrameData['point']['x'] = 19
        stackFrameData['point']['y'] = 2
        stackFrameData['w'] = 20
        stackFrameData['h'] = 15
        local stackFrameBldr = iction.UIElement
        local stackFrame = stackFrameBldr.create(stackFrameBldr, stackFrameData)
        stackFrame.text = stackFrameBldr.addFontSring(stackFrame, "THICKOUTLINE", "OVERLAY", true, nil, nil, nil, 12, 1, 1, 1, 1)

        iction.stackFrames[guid][spellName] = {frame = stackFrame, font = stackFrame.text}
        iction.setButtonText(count, false, stackFrame.text)
        if timerText ~= nil and timerButtonFrame ~= nil then
            timerText:SetPoint("TOP", timerButtonFrame, 0, -3)
        end
    else
        local stackFrame = iction.stackFrames[guid][spellName]['frame']
        local stackFrametext = iction.stackFrames[guid][spellName]['font']
        stackFrame.texture:SetVertexColor(0,0,0,1)
        stackFrame:SetPoint("BOTTOM", timerButtonFrame, 19, 2)
        iction.setButtonText(count, false, stackFrametext)

        if timerText ~= nil and timerButtonFrame ~= nil then
            timerText:SetPoint("TOP", timerButtonFrame, 0, -3)
        end
    end
end

function iction.updateTimers()
    local next = next
    -- {GUID = {name = creatureName, dead = false, spellData = {spellName = {name=spellName, endtime=float}}}}
    for guid, data in pairs(iction.targetData) do
        if data['spellData'] ~= nil then
            local isDead = data['dead']
            local spells = data['spellData']
            if not isDead then
                for spellName, spellData in pairs(spells) do
                    if not iction.isValidButtonFrame(guid) then return end
                    local endTime = spellData['endTime']
                    local coolDown = spellData['coolDown']
                    local count = spellData['count']

                    --- Infinite spell timers
                    iction.infinite = false
                    if endTime == 0 then iction.infinite = true else iction.infinite = false end
                    --- Set infinite and return
                    if iction.infinite and iction.isValidButtonFrame(guid) then
                        iction.spellInfinite(guid, spellName, true)
                    elseif not iction.infinite then
                        iction.spellInfinite(guid, spellName, false)
                    end

                    --- Currently active states
                    if endTime ~= nil and not iction.infinite then
                        if coolDown == nil then
                            if endTime < GetTime() or endTime == GetTime() then
                                --- Spell has ended
                                iction.spellHasEnded(guid, spellName)
                            elseif endTime > GetTime() then
                                --- Spell is still active
                                --- Fetch the remaining time for the spell now
                                local remainingT = tonumber(string.format("%.1f", (endTime - GetTime())))
                                if count and count ~= 0 then
                                    --- Set the current stack count for active
                                    local timerText = iction.targetButtons[guid]["buttonText"][spellName]
                                    local timerButtonFrame = iction.targetButtons[guid]["buttonFrames"][spellName]
                                    iction.createStackFrame(guid, spellName, count, timerText, timerButtonFrame)
                                end

                                if remainingT <= 3 then
                                    --- Set to decimal and red color as a refresh warning
                                    remainingT = endTime - GetTime()
                                    iction.spellFadingTimer(guid, spellName, remainingT)
                                else
                                    --- Set to regular count style
                                    remainingT = endTime - GetTime()
                                    iction.spellActiveTimer(guid, spellName, remainingT)
                                end
                            end
                        end
                    --- Timers that have ended
                    elseif endTime == nil and coolDown ~= nil and not iction.infinite then
                        --- Spell On Cooldown. We have an active cooldown set in the tables already
                        if coolDown > GetTime() then
                            local remainingT = coolDown - GetTime()
                            iction.spellActiveCooldown(guid, spellName, remainingT)
                        else
                            iction.spellHasEnded(guid, spellName)
                        end
                    elseif endTime == nil and iction.isSpellOnCooldown(spellName) and not iction.infinite then
                        local _, duration, _ = GetSpellCooldown(spellName)
                        if duration > 1.5 then
                            local remainingT = iction.fetchCooldownET(spellName)
                            iction.targetData[guid]['spellData'][spellName]['coolDown'] = remainingT
                            iction.spellActiveCooldown(guid, spellName, remainingT)
                        end
                    end
                    --- Drain life and drain soul that have ended on current target.
                    if spellName == 'Drain Soul' or spellName == "Drain Life" then
                        local _, _, _, _, _, _, expirationTime, _, _, _, _ = UnitDebuff("Target", spellName, nil, "player")
                        if not expirationTime then
                            iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                            iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
                            iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
                            iction.targetData[guid]['spellData'][spellName]['coolDown'] = nil
                        end
                    end
                end
            else
                for spellName, _ in pairs(spells) do
                    iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
                end
            end
        end
    end
end