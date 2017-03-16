local iction = iction
local GetTime = GetTime
----------------------------------------------------------------------------------------------
--- MAIN TIMER UPDATE ------------------------------------------------------------------------
function iction.runTimers()
    local itr = iction.list_iter(iction.targetData)
    while true do
        local creatureTable = itr()
        if creatureTable == nil then break end
        if creatureTable['spellData'] == nil then return end
        if creatureTable['dead'] then return end
        local spellTable = iction.list_iter(creatureTable['spellData'])
        local buttonTable = iction.list_iter(creatureTable["buttons"])

        while true do
            local spellInfo = spellTable()
            if spellInfo == nil then break end
            if spellInfo["endTime"] then
                local remainingT = tonumber(string.format("%.1f", (spellInfo["endTime"] - GetTime())))
                while true do
                    local button = buttonTable()
                    if button == nil then break end
                    if button.name == spellInfo['spellName'] then
                        if remainingT >= 0 then
                            button.timerText:SetText(remainingT)
                        else
                            button.timerText:SetText("")
                        end
                        break
                    end
                end
            end
        end
    end
end