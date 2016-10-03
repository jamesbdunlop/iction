----------------------------------------------------------------------------------------------
--- CREATE TARGET SPELLS UI  ---
function iction.createSpellFrame(creatureName, guid, bgFile)
    if iction.debug then print("Dbg: iction.createSpellFrame for " .. tostring(creatureName)) end
    local freeSlot, colID = iction.findSlot(guid)
    if freeSlot and not iction.targetFrames[guid] then
        iction.targetFrames[guid] = CreateFrame("Frame", nil)
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
        fw, fh = iction.calcFrameSize(iction.uiPlayerBuffButtons)

        local butCount = iction.tablelength(iction.uiPlayerBuffButtons)
        if butCount > 1 then offset = -(fh/butCount) else offset = 0 end

        iction.targetFrames[iction.playerGUID] = CreateFrame("Frame", nil, iction.buffFrame)
        iction.targetFrames[iction.playerGUID]:EnableMouse(false)
        iction.targetFrames[iction.playerGUID]:SetClampedToScreen(true)
        iction.targetFrames[iction.playerGUID]:SetFrameStrata("MEDIUM")
        iction.targetFrames[iction.playerGUID]:SetBackdropColor(1,1,1, 1)
        iction.targetFrames[iction.playerGUID]:SetWidth(fw)
        iction.targetFrames[iction.playerGUID]:SetHeight(fh)
        iction.targetFrames[iction.playerGUID]:SetPoint("BOTTOM", "iction_buffFrame", 0, offset)
        iction.targetFrames[iction.playerGUID]:SetPoint("CENTER", "iction_buffFrame", 0, 0)

        return iction.targetFrames[iction.playerGUID]
    else
        return false
    end
end