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
            local buttonTable = targetTable['buttons']
            local spellButton
            spellButton = iction.fetchButtonByID(buttonTable, spellID)
            if not spellButton then
                spellButton = iction.fetchButtonBySpellName(buttonTable, spellData['spellName'])
            end
            local endTime = spellData['expires']['endTime']
            local count = spellData['expires']['count']
            if count and count ~= 0 then
                spellButton.count:SetText(tostring(count))
            end

            local CD
            CD = false
            if not endTime then
                endTime = iction.fetchCooldownET(spellID)
                CD = true
            end
            local bgCol, vertCol, textCol, gameFont
            if endTime and spellButton then
                local remainingT = (endTime - GetTime())
                local bgCol, vertCoil, textCol, gameFont
                bgCol = {1,1,1,.5}
                vertCol = {1,1,1,.5}
                textCol = {1,1,0,1}
                gameFont = "GameFontWhite"
                if remainingT > 60 then
                    remainingT = tonumber(string.format("%.1d m", remainingT/60.0))
                    bgCol = {.5,.5,.5, .85}
                    vertCol = {.5,.5,.5, .85}
                    textCol = {.5,.5,.5, 1}
                    gameFont = "GameFontDarkGraySmall"
                elseif remainingT < 60.0 and remainingT > 5.0 then
                    remainingT = tonumber(string.format("%.1f", remainingT))
                    bgCol = {1,1,1,.85}
                    vertCol = {1,1,1,.85}
                    if CD then
                        textCol = {1,1,0,1}
                        gameFont = "NumberFontNormalYellow"
                    end
                elseif remainingT <= 5.0 and remainingT > 1.1 then
                    remainingT = tonumber(string.format("%.1f", remainingT))
                    bgCol = {1,.1,.1, 1}
                    vertCol = {1,.1,.1,1}
                    if CD then
                        textCol = {1,1,0,1}
                        gameFont = "NumberFontNormalYellow"
                    else
                        textCol = {1,0,0,1}
                        gameFont = "GameFontRedLarge"
                    end
                elseif remainingT <= 1.1 and remainingT >= 0.1 then
                    remainingT = tonumber(string.format("%.1f", remainingT))
                    vertCol = {1,.1,.1, 1}
                    textCol = {1,1,0,1}
                    gameFont = "NumberFontNormalYellow"
                elseif remainingT <= 0.1 then
                    remainingT = ""
                    if CD then
                        vertCol = {1,1,1,1}
                        gameFont = "NumberFontNormalYellow"
                    end
                end
                spellButton.setButtonState(spellButton, bgCol, vertCol, textCol, gameFont)
                spellButton.text:SetText(remainingT)
            elseif not endTime and spellButton then
                spellButton.text:SetText("")
                bgCol = {1,1,1,0}
                vertCol = {1,1,1,0}
                textCol = {1,1,1,0}
                gameFont = "GameFontWhite"
                spellButton.setButtonState(spellButton, bgCol, vertCol, textCol, gameFont)
            end
        end
    end
    if iction.class == iction.L['Priest'] and iction.spec == 3 then
        iction.swdFrameUpdate()
        iction.voidFrameUpdate()
    end
end

function iction.fetchButtonByID(buttonTable, spellID)
    for bSpellID, buttonBldr in pairs(buttonTable) do
        if buttonBldr == nil then break end
        if bSpellID == spellID then
            return buttonBldr
    end end
    return nil
end

function iction.fetchButtonBySpellName(buttonTable, spellName)
    for _, buttonBldr in pairs(buttonTable) do
        if buttonBldr == nil then break end
        if buttonBldr.frameName == spellName then
            return buttonBldr
    end end
    return nil
end

ictionBuffPadX = 0
ictionBuffPadY = 0
function iction.updateBuffTimers()
    local function displayBuff(spellName, spellID, rank, count, expires ,icon)
        local bgCol, vertCol, textCol, gameFont
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
                  butFrameBldr.addCountFontString(butFrameBldr, "THICKOUTLINE", "OVERLAY", false, "LEFT", 0, -(iction.bh/2), 12, 1, 0, 0, 1)
            spellData['frame'] = butFrameBldr
            table.insert(iction.buffButtons, spellData)
            if iction.debugBuffs then print("Added buffButton spellID:" ..tostring(spellID)) end
            if iction.debugBuffs then print("Added buffButton spellName:" ..tostring(spellName)) end
            if iction.debugBuffs then print("-------") end
            if count and count ~= 0 then
                butFrameBldr.count:SetText(tostring(count))
            end
            ictionBuffPadX = ictionBuffPadX + iction.bw + iction.ictionButtonFramePad
        else
            local remainingT = (button['expires'] - GetTime())
            local bgCol, vertCol, textCol, gameFont, bText
            bgCol = {1,1,1,0}
            vertCol = {1,1,1,0}
            textCol = {1,1,0,0}
            gameFont = "NumberFontNormalYellow"
            bText = ""
            if remainingT and remainingT >= 60.0 then
                bText = string.format("%.1d m", remainingT/60.0)
            elseif remainingT and remainingT <= 60.0 and remainingT >= 5.0 then
                bText = tonumber(string.format("%.1f", remainingT))
                bgCol = {1,1,1,0.5}
                vertCol = {1,1,1,0.5}
                textCol = {1,1,0,1}
            elseif remainingT and remainingT <= 5.0 and remainingT >= 0.1 then
                bText = tonumber(string.format("%.1f", remainingT))
                bgCol = {1,0.2,0.2, 1}
                vertCol = {1,0.2,0.2, 1}
                textCol = {1,1,0, 1}
                gameFont = "GameFontRedLarge"
            end
            button['frame'].text:SetText(bText)
            button['frame'].setButtonState(button['frame'], bgCol, vertCol, textCol, gameFont)
        end
    end
    ---Now run through the buffs!
    for x = 1, ictionDisplayBuffLimit do
        local spellName, rank, icon, count, _, duration, expires, caster, _, _, spellID, _, _, _, _, _, _, _, _ = UnitAura("Player", x, "CANCELABLE|PLAYER|HELPFUL")
        if duration and duration ~= 0 then
            if not spellName then break end
            if not ictionDisplayOnlyPlayerBuffs then
                displayBuff(spellName, spellID, rank, count, expires, icon)
            elseif ictionDisplayOnlyPlayerBuffs then
                if caster == "player" then
                    displayBuff(spellName, spellID, rank, count, expires, icon)
                end
            end
        end
    end
end

--- PRIEST SPECIFIC HANDLERS (TO REMOVE)
function iction.voidFrameUpdate()
    --194249 is void eruption
    --- PRIEST VOID FRAME SPECIAL FRAME HANDLER
    local vbID = iction.vbID
    local bgCol, vertCol, textCol, gameFont
    bgCol = {0,0,0,0}
    vertCol = {0,0,0,0}
    textCol = {1,1,0,0}
    gameFont = "GameFontWhite"
    iction.voidButtonBldr.setButtonState(iction.voidButtonBldr, bgCol, vertCol, textCol, gameFont)
    if iction.blizz_buffActive(194249) and not iction.isSpellOnCooldown(vbID) then
        bgCol = {1,1,1,0}
        vertCol = {1,1,1,.5}
        textCol = {0,1,0,.5}
        gameFont = "GameFontWhite"
        iction.voidButtonBldr.setButtonState(iction.voidButtonBldr, bgCol, vertCol, textCol, gameFont)
        iction.voidButtonBldr.text:SetText("")

    elseif iction.blizz_buffActive(194249) and iction.isSpellOnCooldown(vbID) then
        bgCol = {1,1,1,0}
        vertCol = {1,1,1,1}
        textCol = {1,1,0,1}
        gameFont = "NumberFontNormalYellow"
        iction.voidButtonBldr.setButtonState(iction.voidButtonBldr, bgCol, vertCol, textCol, gameFont)
        local _, duration, _ = GetSpellCooldown(vbID)
        if duration > 1.5 then
            local remainingT = iction.blizz_fetchCooldownET(vbID)
            local rt = iction.blizz_fetchRemainingT(remainingT - GetTime())
            iction.voidButtonBldr.text:SetText(rt)
        end
    end
end

function iction.swdFrameUpdate()
    --- PRIEST SHADOW WORD DEATH SPECIAL FRAME HANDLER
    local tguid = UnitGUID("Target")
    local swdID = iction.swdID
    local charges, maxCharges, start, duration = GetSpellCharges(swdID)
    local bgCol, vertCol, textCol, gameFont


    if tguid and tguid ~= iction.playerGUID then
        if iction.blizz_getTargetHP() then
            if charges then iction.SWDButtonBldr.count:SetText(tostring(charges)) end
            bgCol = {1,1,1,1}
            vertCol = {1,1,1,1}
            textCol = {1,1,1,1}
            gameFont = "GameFontHighlightLarge"
            iction.SWDButtonBldr.setButtonState(iction.SWDButtonBldr, bgCol, vertCol, textCol, gameFont)
        else
            iction.SWDButtonBldr.count:SetText(tostring(""))
            bgCol = {1,.1,.1,.1}
            vertCol = {1,.1,.1,.1}
            textCol = {1,1,1,0}
            gameFont = "GameFontHighlightLarge"
            iction.SWDButtonBldr.setButtonState(iction.SWDButtonBldr, bgCol, vertCol, textCol, gameFont)
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