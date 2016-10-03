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
                    if endTime ~= nil then
                        if endTime < GetTime() or endTime == GetTime() then
                            if iction.targetButtons[guid] then -- fucking target dummies
                                iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                                iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
                                iction.targetData[guid]['spellData'][spellName]['endTime'] = nil
                            end
                        elseif endTime > GetTime() then
                            local remainingT = tonumber(string.format("%.2d", (endTime - GetTime())))
                            if iction.targetButtons[guid] then -- fucking target dummies
                                iction.setButtonState(true, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                                iction.setButtonText(remainingT, false, iction.targetButtons[guid]['buttonText'][spellName])
                            end
                        end
                    else
                        if iction.targetButtons[guid] then
                            iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][spellName])
                            iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][spellName])
                        end
                    end
                end
            else
                for spellName, _ in pairs(spells) do
                    iction.targetData[guid]['spellData'][spellName]['endTime'] = nil -- changed from 0
                end
            end
        end
    end
end