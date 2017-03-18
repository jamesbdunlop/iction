local iction = iction
local GetTime = GetTime
----------------------------------------------------------------------------------------------
--- MAIN TIMER UPDATE ------------------------------------------------------------------------
function iction.runTimers()
    local activeSpellTables = iction.list_iter(iction.activeSpellTable)
    while true do
        local spellTable = activeSpellTables()
        if spellTable == nil then break end

        if spellTable['expires']["endTime"] then
            local remainingT = tonumber(string.format("%.1f", (spellTable['expires']["endTime"] - GetTime())))
            -- Find the button
            local function fetchButton(buttonTable)
                local buttonTable = iction.list_iter(buttonTable)
                while true do
                    local button = buttonTable()
                    if button == nil then break end

                    if button.name == spellTable['spellName'] then
                        return button
                    end
                end
                return false
            end

            local spellButton = fetchButton(spellTable['buttons'])
            if spellButton then
                if remainingT >= 0 then
                    spellButton.timerText:SetText(remainingT)
                    spellButton.setButtonState(spellButton, true, false, false, false)
                elseif remainingT <= 0.1 then
                    spellButton.timerText:SetText("")
                    spellButton.setButtonState(spellButton, false, false, false, false)
                end
            end
        end
    end
end