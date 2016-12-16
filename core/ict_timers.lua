----------------------------------------------------------------------------------------------
--- MAIN TIMER UPDATE ------------------------------------------------------------------------

function iction.spellActiveCooldown(guid, spellName, remainingT, spellID)
    if iction.debugTimers then print("spellActiveCooldown") end
    local TL = tonumber(string.format("%.1f", (remainingT)))
    if TL > 60.0 then
        remainingT = tostring(tonumber(string.format("%.1d", remainingT/60.0))) .. "m"
    else
        remainingT = tonumber(string.format("%.1d", remainingT))
    end
    if guid then
        iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellID], true)
        iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellID], true, {1,.8,.8, 1})
    else
        return remainingT
    end
end

function iction.spellInfinite(guid, spellName, infinite, spellID)
    if iction.debugTimers then print("spellInfinite") end
    if infinite then
        iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellID])
        iction.setButtonText("∞", false, iction.targetButtons[guid]['buttonText'][spellID])
    else
        iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellID])
        iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellID])
    end
end

function iction.spellActiveTimer(guid, spellName, remainingT, spellID)
    if iction.debugTimers then print("spellActiveTimer") end
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
    if iction.debugTimers then print("spellFadingTimer") end
    local remainingT = tonumber(string.format("%.1f", remainingT))
    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellID], true)
    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellID], true, {1,0,0,1})
end

function iction.isValidButtonFrame(guid)
    if iction.debugTimers then print("isValidButtonFrame") end
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
    if iction.debugTimers then print("isSpellOnCooldown") end
    if spellID ~= nil then
        local start, duration, enabled = GetSpellCooldown(spellID)
        if enabled == 0 then
            return false
        elseif ( start > 0 and duration > 1.5) then
            return true
        end
    else return false
    end
end

function iction.fetchCooldownET(spellID)
    if iction.debugTimers then print("fetchCooldownET") end
    local start, duration, _ = GetSpellCooldown(spellID)
    local actualFinish = start+duration
    local et = (actualFinish - GetTime()) + GetTime()
    if start == 0 then
        return false
    else
        return et
    end
end

function iction.spellHasEnded(guid, spellName, spellID)
    if iction.debugTimers then print("spellHasEnded") end
    iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellID])
    iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellID])
    iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
    iction.targetData[guid]['spellData'][spellID]['count'] = nil
    --- Set the cooldown
    if not iction.isSpellOnCooldown(spellID) then
        iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
    end
end

function iction.createStackFrame(guid, spellName, count, timerText, timerButtonFrame, spellID, w, h, px, py)
    local localizedClass, _, _ = UnitClass("Player")
    if not iction.stackFrames[guid] then
        iction.stackFrames[guid] = {}
    end
    if not px then
        px = 15
    end
    if not py then
        py =  22
    end
    if not iction.stackFrames[guid][spellID] and count then
        local stackFrameData = iction.ictStackFrameData
        stackFrameData['uiParentFrame'] = timerButtonFrame
        stackFrameData['point']['p'] = timerButtonFrame
        stackFrameData['w'] = w
        stackFrameData['h'] = h
        local stackFrameBldr = iction.UIElement
        local stackFrame = stackFrameBldr.create(stackFrameBldr, stackFrameData)
        stackFrame.text = stackFrameBldr.addFontSring(stackFrame, "THICKOUTLINE", "OVERLAY", true, nil, nil, nil, 10, 1, 1, 1, 1)
        if localizedClass == iction.L['priest'] then
            stackFrame:SetPoint("TOP", timerButtonFrame, 0, py)
            stackFrame:SetPoint("RIGHT", timerButtonFrame, px, 0)
        else
            stackFrame:SetPoint("BOTTOM", timerButtonFrame, px, py)
        end

        iction.stackFrames[guid][spellID] = {frame = stackFrame, font = stackFrame.text}
        iction.setButtonText(count, false, stackFrame.text)
        if timerText ~= nil and timerButtonFrame ~= nil then
            timerText:SetPoint("BOTTOM", timerButtonFrame, 0, 3)
        end
    elseif count then
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
    elseif count  == nil then
        if iction.stackFrames[guid][spellID] ~= nil then
            local stackFrame = iction.stackFrames[guid][spellID]['frame']
            local stackFrametext = iction.stackFrames[guid][spellID]['font']
            stackFrame.texture:SetVertexColor(0,0,0,0)
            stackFrametext:SetText("")
        end
    end
end

local localizedClass, _, _ = UnitClass("Player")
function iction.updateTimers()
    local function swdupdate()
        --- PRIEST SHADOW WORD DEATH SPECIAL FRAME HANDLER
        local tguid = UnitGUID("Target")
        local swdID = iction.swdID
        local charges, maxCharges, start, duration = GetSpellCharges(swdID)
        local swdFrame = iction.SWDUIElements[1]
        local swdButtonFrame = iction.SWDUIElements[2][swdID]
        local swdButtonText = iction.SWDUIElements[3][swdID]
        if tguid and tguid ~= iction.playerGUID then
            if iction.getTargetHP() then
                iction.setButtonState(true, false, swdButtonFrame, false, true)
            else
                iction.setButtonState(false, false, swdButtonFrame, false, false)
            end
        elseif not tguid then
            iction.setButtonState(false, false, swdButtonFrame, false, false)
        end
        if charges and charges ~= 0 then
            iction.createStackFrame("666", "SWD", charges, swdButtonText, swdButtonFrame, swdID, iction.bw/2.5, iction.bh/2.5, 5, 0)
        else
            iction.createStackFrame("666", "SWD", nil, swdButtonText, swdButtonFrame, swdID, iction.bw/2.5, iction.bh/3, 5, 0)
        end
        ---  ON COOLDOWN
        if iction.isSpellOnCooldown(swdID) then
            local _, duration, _ = GetSpellCooldown(swdID)
            if duration > 1.5 then
                local remainingT = iction.fetchCooldownET(swdID)
                local rt = iction.spellActiveCooldown(nil, "Shadow Word:Death", remainingT - GetTime(), swdID)
                iction.setButtonText(rt, false, swdButtonText, true, {1,0,0,1})
            end
        else
            swdButtonText:SetText("")
        end
    end

    --- PRIEST VOIDFRAME HANDER
    local function vbupdate()
        local vbID = iction.vbID
        local vbFrame = iction.voidBoltUIElements[1]
        local vbButtonFrame = iction.voidBoltUIElements[2][vbID]
        local vbButtonText = iction.voidBoltUIElements[3][vbID]
        if iction.buffActive(194249) and not iction.isSpellOnCooldown(vbID) then
            iction.setButtonText("", false, vbButtonText, true, {0,0,0,0})
            iction.setButtonState(true, false, vbButtonFrame, false, true)
        elseif iction.isSpellOnCooldown(vbID) then
            local _, duration, _ = GetSpellCooldown(vbID)
            if duration > 1.5 then
                local remainingT = iction.fetchCooldownET(vbID)
                local rt = iction.spellActiveCooldown(nil, "VoidBolt", remainingT - GetTime(), vbID)
                iction.setButtonText(rt, false, vbButtonText, true, {1,0,0,1})
            end
            iction.setButtonState(false, false, vbButtonFrame, false, false)
        else
            iction.setButtonText("", false, vbButtonText, true, {0,0,0,0})
            iction.setButtonState(false, true, vbButtonFrame, false, false)
        end
    end


    if localizedClass == iction.L['priest'] then
        swdupdate()
        vbupdate()
    end

    local function runTimers()
        --- GENERAL SPELL TIMER
        if iction.targetData ~= nil then
            -- {GUID = {name = creatureName, dead = false, spellData = {spellName = {name=spellName, endtime=float}}}}
            for guid, data in pairs(iction.targetData) do
                if iction.isValidButtonFrame(guid) then
                    if data['spellData'] ~= nil then
                        local isDead = data['dead']
                        local spells = data['spellData']
                        if not isDead then
                        --- Now process the spells
                            for spellID, spellData in pairs(spells) do
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
                                            iction.createStackFrame(guid, spellName, nil, timerText, timerButtonFrame, spellID, iction.bw/2.5, iction.bh/2.5)
                                        elseif endTime > GetTime() then
                                            --- Spell is still active
                                            --- Fetch the remaining time for the spell now
                                            local remainingT = tonumber(string.format("%.1f", (endTime - GetTime())))
                                            if count and count ~= 0 then
                                                --- Set the current stack count for active
                                                iction.createStackFrame(guid, spellName, count, timerText, timerButtonFrame, spellID, iction.bw/2.5, iction.bh/2.5)
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
                                    if count and count ~= 0 then
                                        --- Set the current stack count for active
                                        iction.createStackFrame(guid, spellName, count, timerText, timerButtonFrame, spellID, iction.bw/2.5, iction.bh/2.5)
                                    else
                                        iction.createStackFrame(guid, spellName, nil, timerText, timerButtonFrame, spellID, iction.bw/2.5, iction.bh/2.5)
                                    end
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
                                    iction.createStackFrame(guid, spellName, nil, timerText, timerButtonFrame, spellID, iction.bw/2.5, iction.bh/2.5)
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
    end
    runTimers()

    --- PRIEST MINDBLAST PROCS
    if localizedClass == iction.L['priest'] then
        if iction.targetData ~= nil then
            for guid, data in pairs(iction.targetData) do
                if iction.isValidButtonFrame(guid) then
                    if data['spellData'] ~= nil then
                        local isDead = data['dead']
                        local spells = data['spellData']
                        if not isDead then
                            if iction.buffActive(124430) then
                                if iction.targetData[guid]['spellData'][8092] == nil then
                                    iction.createTarget(guid, "", "Mind Flay", "DEBUFF", 8092)
                                end
                                iction.spellHasEnded(guid, "Mind Flay", 8092)
                                iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][8092], false, true)
                            elseif iction.buffActive(194249) and not iction.isSpellOnCooldown(205448) then
                                iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][205448], false, true)
                            else
                                iction.setButtonState(false, true, iction.targetButtons[guid]['buttonFrames'][205448], false, false)
                            end
                        end
                    end
                end
            end
        end
    end
end