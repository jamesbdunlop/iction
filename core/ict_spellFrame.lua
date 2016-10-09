----------------------------------------------------------------------------------------------
--- CREATE TARGET SPELLS UI  ---
function iction.createSpellFrame(creatureName, guid, bgFile)
    if iction.debug then print("Dbg: iction.createSpellFrame for " .. tostring(creatureName)) end
    local freeSlot, colID = iction.findSlot(guid)
    if freeSlot and not iction.targetFrames[guid] then
        iction.targetFrames[guid] = CreateFrame("Frame", nil)
        iction.targetFrames[guid]:SetAttribute("name", 'ictionDeBuffFrame')
        iction.targetFrames[guid]:EnableMouse(false)
        iction.targetFrames[guid]:SetFrameStrata("HIGH")
        iction.targetFrames[guid]:SetBackdropColor(0, 0, 0, 0)
        -- Set draw for frame
        local bg = iction.targetFrames[guid]:CreateTexture(nil, "ARTWORK")
              bg:SetAllPoints(true)
              bg:SetTexture(bgFile)
              bg:SetVertexColor(0, 0, 0, 0)
        iction.targetFrames[guid].texture = bg
        -- Set the height of the frame based on the number of buttons
        local fw, fh
        fw, fh = iction.calcFrameSize(iction.uiPlayerSpellButtons)
        iction.targetFrames[guid]:SetWidth(fw)
        iction.targetFrames[guid]:SetHeight(fh)

        -- Set frame to be an active column in the debuff columns table
        iction.targetCols[colID]['guid'] = guid
        iction.targetCols[colID]['active'] = true

        iction.targetFrames[guid]:SetPoint("CENTER", "iction_"..colID)
        iction.targetFrames[guid]:SetPoint("BOTTOM", "iction_"..colID)
        iction.targetFrames[guid]:SetParent("iction_"..colID)
        return iction.targetFrames[guid]
    else
        return false
    end
end


----------------------------------------------------------------------------------------------
--- CREATE PLAYER BUFF UI  ---
function iction.createPlayerBuffFrame()
    if iction.debug then print("Dbg: iction.createPlayerBuffFrame") end
    if not iction.targetFrames[iction.playerGUID] then
        local fw, fh
        local offset
        if iction.buffFrameHorizontal then
            fw, _ = iction.calcFrameSize(iction.uiPlayerBuffButtons)
        else
            fh, fw = iction.calcFrameSize(iction.uiPlayerBuffButtons)
        end
        local butCount = iction.tablelength(iction.uiPlayerBuffButtons)
        iction.targetFrames[iction.playerGUID] = CreateFrame("Frame", nil, iction.buffFrame)
        iction.targetFrames[iction.playerGUID]:SetAttribute("name", 'ictionBuffFrame')
        iction.targetFrames[iction.playerGUID]:EnableMouse(false)
        iction.targetFrames[iction.playerGUID]:SetClampedToScreen(true)
        iction.targetFrames[iction.playerGUID]:SetFrameStrata("MEDIUM")
        iction.targetFrames[iction.playerGUID]:SetBackdropColor(1,1,1, 1)
        iction.targetFrames[iction.playerGUID]:SetWidth(fw)
        iction.targetFrames[iction.playerGUID]:SetHeight(iction.bh+5)
        if iction.buffFrameHorizontal then
            iction.targetFrames[iction.playerGUID]:SetPoint("LEFT", iction.buffFrame, 0, 0)
        else
            iction.targetFrames[iction.playerGUID]:SetPoint("CENTER", iction.buffFrame, 0, 0)
        end
        return iction.targetFrames[iction.playerGUID]
    else
        return false
    end
end