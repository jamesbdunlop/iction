----------------------------------------------------------------------------------------------
--- CREATE TARGET SPELLS UI  ---
function iction.createSpellFrame(creatureName, guid, bgFile)
    if iction.debug then print("Dbg: iction.createSpellFrame") end
    local freeSlot, colID, xPos, yPos = iction.findSlot(guid)
    if iction.debug then print("\t freeSlot: " .. tostring(freeSlot)) end
    if iction.debug then print("\t colID: " .. tostring(colID)) end

    if freeSlot then
        if iction.debug then print("\t creating tgt frame...") end
        if not iction.targetFrames[guid] then
            iction.targetFrames[guid] = CreateFrame("Frame", nil)
            iction.targetFrames[guid]:EnableMouse(false)
            iction.targetFrames[guid]:SetFrameStrata("HIGH")
            -- Set draw for frame
            local bg = iction.targetFrames[guid]:CreateTexture(nil, "ARTWORK")
                  bg:SetAllPoints(true)
                  bg:SetTexture(bgFile)
                  bg:SetVertexColor(0, 0, 0, 0)
            -- Set the height of the frame based on the number of buttons
            local fw, fh
            fw, fh = iction.calcFrameSize(iction.uiPlayerSpellButtons)
            iction.targetFrames[guid]:SetWidth(fw)
            iction.targetFrames[guid]:SetHeight(fh)
            iction.targetCols[colID]['guid'] = guid
            iction.targetCols[colID]['active'] = true
            if not iction.ictionHorizontal then
                iction.targetFrames[guid]:SetPoint("LEFT", "iction_colAnchor", xPos, yPos);
                iction.targetFrames[guid]:SetPoint("CENTER", "iction_colAnchor", 0, 0);
            else
                iction.targetFrames[guid]:SetPoint("BOTTOM", "iction_colAnchor", xPos, yPos);
                iction.targetFrames[guid]:SetPoint("CENTER", "iction_colAnchor", 0, 0);
            end
            iction.targetFrames[guid]:SetParent("iction_colAnchor")
            return iction.targetFrames[guid]
        else
            return false
        end
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
        fw, fh = iction.calcFrameSize(iction.uiPlayerBuffButtons)
        if iction.debug then print("\t fw: " .. fw) end
        if iction.debug then print("\t fh: " .. fh) end
        local butCount = iction.tablelength(iction.uiPlayerBuffButtons)
        if iction.debug then print("\t butCount: " .. butCount) end
        local offset
        if butCount > 1 then
            offset = -(fh/butCount)
        else
            offset = 0
        end
        iction.targetFrames[iction.playerGUID] = CreateFrame("Frame", nil, iction.buffFrame)
        iction.targetFrames[iction.playerGUID]:EnableMouse(false)
        iction.targetFrames[iction.playerGUID]:SetClampedToScreen(true)
        iction.targetFrames[iction.playerGUID]:SetFrameStrata("MEDIUM")
        iction.targetFrames[iction.playerGUID]:SetBackdropColor(1,1,1, 0);
        iction.targetFrames[iction.playerGUID]:SetWidth(fw)
        iction.targetFrames[iction.playerGUID]:SetHeight(fh)
        iction.targetFrames[iction.playerGUID]:SetPoint("BOTTOM", "iction_buffFrame", 0, offset);
        iction.targetFrames[iction.playerGUID]:SetPoint("CENTER", "iction_buffFrame", 0, 0);
        if iction.debug then print("\? targetFrame: " .. tostring(iction.targetFrames[iction.playerGUID])) end
        return iction.targetFrames[iction.playerGUID]
    else
        return false
    end
end