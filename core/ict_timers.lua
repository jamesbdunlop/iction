----------------------------------------------------------------------------------------------
--- MAIN TIMER UPDATE ------------------------------------------------------------------------
function iction.updateTimers()
    local next = next
    -- {GUID = {name = creatureName, dead = false, spellData = {spellName = {name=spellName, endtime=float}}}}
    for guid, data in pairs(iction.targetData) do
        if data['spellData'] ~= nil then
            local creatureName = data['name']
            local isDead = data['dead']
            local spells = data['spellData']
            if not isDead then
                for spellName, spellData in pairs(spells) do
                    local endTime = spellData['endTime']
                    --- Infinite spell timers
                    iction.infinite = false
                    if endTime == 0 then
                        iction.infinite = true
                    end
                    if iction.infinite then
                        if iction.targetButtons[guid] and iction.targetButtons[guid]['buttonFrames'] then -- fucking target dummies
                            iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                            iction.setButtonText("∞", false, iction.targetButtons[guid]['buttonText'][spellName])
                        end
                    end
                    --- All other timers
                    if endTime ~= nil and not iction.infinite then
                        if endTime < GetTime() or endTime == GetTime() then
                            if iction.targetButtons[guid] and iction.targetButtons[guid]['buttonFrames'] then -- fucking target dummies
                                iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                                iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
                                iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
                            end
                        elseif endTime > GetTime() then
                            if iction.targetButtons[guid] then -- fxcking target dummies
                                local remainingT = tonumber(string.format("%.1f", (endTime - GetTime())))
                                if remainingT < 3 then
                                    remainingT = tonumber(string.format("%.1f", (endTime - GetTime())))
                                    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName], true)
                                    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellName])
                                else
                                    remainingT = tonumber(string.format("%.1d", (endTime - GetTime())))
                                    iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName], false)
                                    iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellName])
                                end
                            end
                        end
                    end

                    --- Timers that have ended
                    if endTime == nil then
                        if iction.targetButtons[guid] and iction.targetButtons[guid]['buttonFrames'] then
                            iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                            iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
                            iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
                        end
                    end

                    --- Drain life and drain soul that have ended on current target.
                    if spellName == 'Drain Soul' or spellName == "Drain Life" then
                        local _, _, _, _, _, _, expirationTime, _, _, _, _ = UnitDebuff("Target", spellName, nil, "player")
                        if not expirationTime and iction.targetButtons[guid] then
                            iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                            iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
                            iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
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