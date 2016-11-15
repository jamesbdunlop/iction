----------------------------------------------------------------------------------------------
--- MAIN TIMER UPDATE ------------------------------------------------------------------------

function iction.spellActiveCooldown(guid, spellName, remainingT, spellID)
    local TL = tonumber(string.format("%.1f", (remainingT)))
    if TL > 60.0 then
        remainingT = tostring(tonumber(string.format("%.1d", remainingT/60.0))) .. "m"
    else
        remainingT = tonumber(string.format("%.1d", remainingT))
    end
    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellID], true)
    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellID], true, {1,.8,.8, 1})
end

function iction.spellInfinite(guid, spellName, infinite, spellID)
    if infinite then
        iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellID])
        iction.setButtonText("∞", false, iction.targetButtons[guid]['buttonText'][spellID])
    else
        iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellID])
        iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellID])
    end
end

function iction.spellActiveTimer(guid, spellName, remainingT, spellID)
    local TL = remainingT - GetTime()
    if TL > 60 then
        remainingT = tonumber(string.format("%.1d m", remainingT/60.0))
    else
        remainingT = tonumber(string.format("%.1d", remainingT))
    end
    --local remainingT = tonumber(string.format("%.1d", remainingT))
    if iction.targetButtons[guid]['buttonText'][spellID] then -- check for spec change with active buff timer
        iction.targetButtons[guid]['buttonText'][spellID]:SetText("")
        iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellID], false)
        iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellID])
    end
end

function iction.spellFadingTimer(guid, spellName, remainingT, spellID)
    local remainingT = tonumber(string.format("%.1f", remainingT))
    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellID], true)
    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellID], true, {1,0,0,1})
end

function iction.isValidButtonFrame(guid)
    if iction.targetButtons[guid] then
        if iction.targetButtons[guid]['buttonFrames'] then
            return true
        else
            return false
        end
    else
        return false
    end
end

function iction.isSpellOnCooldown(spellID)
    if spellID ~= nil then
        local start, duration, enable = GetSpellCooldown(spellID)
        if start == 0 then
            return false
        elseif start == nil then
            return false
        else
            return true
        end
    else return false
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

function iction.spellHasEnded(guid, spellName, spellID)
    iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellID])
    iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellID])
    iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
    iction.targetData[guid]['spellData'][spellID]['count'] = nil
    -- Set the cooldown
    if not iction.isSpellOnCooldown(spellID) then
        iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
    end
end

function iction.createStackFrame(guid, spellName, count, timerText, timerButtonFrame, spellID)
    local localizedClass, _, _ = UnitClass("Player")
    if not iction.stackFrames[guid] then
        iction.stackFrames[guid] = {}
    end

    if not iction.stackFrames[guid][spellID] then
        local buttonFrame = iction.targetButtons[guid]['buttonFrames'][spellID]
        local stackFrameData = iction.ictStackFrameData
        stackFrameData['uiParentFrame'] = buttonFrame
        stackFrameData['point']['p'] = buttonFrame
        stackFrameData['w'] = iction.bw/2.5
        stackFrameData['h'] = iction.bh/2.5

        local stackFrameBldr = iction.UIElement
        local stackFrame = stackFrameBldr.create(stackFrameBldr, stackFrameData)
        stackFrame.text = stackFrameBldr.addFontSring(stackFrame, "THICKOUTLINE", "OVERLAY", true, nil, nil, nil, 10, 1, 1, 1, 1)
        if localizedClass == iction.L['priest'] then
            stackFrame:SetPoint("BOTTOM", buttonFrame, 15, 22)
        else
            stackFrame:SetPoint("BOTTOM", buttonFrame, 15, 22)
        end

        iction.stackFrames[guid][spellID] = {frame = stackFrame, font = stackFrame.text}
        iction.setButtonText(count, false, stackFrame.text)
        if timerText ~= nil and timerButtonFrame ~= nil then
            timerText:SetPoint("BOTTOM", timerButtonFrame, 0, 3)
        end
    else
        local stackFrame = iction.stackFrames[guid][spellID]['frame']
        local stackFrametext = iction.stackFrames[guid][spellID]['font']
        stackFrame.texture:SetVertexColor(0,0,0,1)
        iction.setButtonText(count, false, stackFrametext)
        if count == nil then stackFrame.texture:SetVertexColor(0,0,0,0) end
        if timerText ~= nil and timerButtonFrame ~= nil then
            if count == nil then
                timerText:SetPoint("CENTER", timerButtonFrame, 0, 3)
            else
                timerText:SetPoint("BOTTOM", timerButtonFrame, 0, 3)
            end
        end
    end
end

function iction.updateTimers()
    -- {GUID = {name = creatureName, dead = false, spellData = {spellName = {name=spellName, endtime=float}}}}
    for guid, data in pairs(iction.targetData) do
        if data['spellData'] ~= nil then
            local isDead = data['dead']
            local spells = data['spellData']
            if not isDead then
                for spellID, spellData in pairs(spells) do
                    if iction.isValidButtonFrame(guid) then
                        local endTime = spellData['endTime']
                        local coolDown = spellData['coolDown']
                        local count = spellData['count']
                        local spellName = spellData['spellName']
                        local timerText = iction.targetButtons[guid]["buttonText"][spellID]
                        local timerButtonFrame = iction.targetButtons[guid]["buttonFrames"][spellID]

                        --- Infinite spell timers
                        iction.infinite = false
                        if endTime == 0 then iction.infinite = true else iction.infinite = false end

                        --- Set infinite and return
                        if iction.infinite and iction.isValidButtonFrame(guid) then
                            iction.spellInfinite(guid, spellName, true, spellID)
                        elseif not iction.infinite then
                            iction.spellInfinite(guid, spellName, false, spellID)
                        end

                        --- Currently active states
                        if endTime ~= nil and not iction.infinite then
                            if coolDown == nil then
                                if endTime < GetTime() or endTime == GetTime() then
                                    --- Spell has ended
                                    iction.spellHasEnded(guid, spellName, spellID)
                                    iction.createStackFrame(guid, spellName, nil, timerText, timerButtonFrame, spellID)
                                elseif endTime > GetTime() then
                                    --- Spell is still active
                                    --- Fetch the remaining time for the spell now
                                    local remainingT = tonumber(string.format("%.1f", (endTime - GetTime())))
                                    if count and count ~= 0 then
                                        --- Set the current stack count for active
                                        iction.createStackFrame(guid, spellName, count, timerText, timerButtonFrame, spellID)
                                    end

                                    if remainingT <= 3 then
                                        --- Set to decimal and red color as a refresh warning
                                        remainingT = endTime - GetTime()
                                        iction.spellFadingTimer(guid, spellName, remainingT, spellID)
                                    else
                                        --- Set to regular count style
                                        remainingT = endTime - GetTime()
                                        iction.spellActiveTimer(guid, spellName, remainingT, spellID)
                                    end
                                end
                            end
                        --- Timers that have ended
                        elseif endTime == nil and coolDown ~= nil and not iction.infinite then
                            iction.createStackFrame(guid, spellName, nil, timerText, timerButtonFrame, spellID)
                            --- Spell On Cooldown. We have an active cooldown set in the tables already
                            if coolDown > GetTime() then
                                local remainingT = tonumber(string.format("%.1f", (coolDown - GetTime())))
                                if remainingT <= 3 then
                                    remainingT = coolDown - GetTime()
                                    iction.spellFadingTimer(guid, spellName, remainingT, spellID)
                                else
                                    remainingT = coolDown - GetTime()
                                    iction.spellActiveCooldown(guid, spellName, remainingT, spellID)
                                end
                            else
                                iction.spellHasEnded(guid, spellName, spellID)
                            end
                        elseif endTime == nil and iction.isSpellOnCooldown(spellID) and not iction.infinite then
                            local _, duration, _ = GetSpellCooldown(spellID)
                            if duration > 1.5 then
                                local remainingT = iction.fetchCooldownET(spellID)
                                iction.targetData[guid]['spellData'][spellID]['coolDown'] = remainingT
                                iction.spellActiveCooldown(guid, spellName, remainingT - GetTime(), spellID)
                            end
                        elseif endTime == nil then
                            iction.createStackFrame(guid, spellName, nil, timerText, timerButtonFrame, spellID)
                        end
                        --- Drain life and drain soul that have ended on current target.
                        if spellID == 198590 or spellID == 234153 or spellID == 689 then
                            local isChannelActive, cguid = iction.channelActive(spellID)
                            if isChannelActive and cguid ~= guid then
                                if iction.targetData[guid]['spellData'][spellID] ~= nil then
                                    iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellID])
                                    iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellID])
                                    iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
                                    iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
                                end
                            end
                        end
                    end
                end
            else
                for spellID, _ in pairs(spells) do
                    iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
                end
            end
        end
    end
end