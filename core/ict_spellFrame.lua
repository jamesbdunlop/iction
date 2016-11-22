----------------------------------------------------------------------------------------------
--- CREATE TARGET SPELLS UI  ---
function iction.createSpellFrame(creatureName, guid, bgFile)
    local freeSlot, colID = iction.findSlot(guid)
    if freeSlot and not iction.targetFrames[guid] then
        iction.targetFrames[guid] = CreateFrame("Frame", nil)
        iction.targetFrames[guid]:SetAttribute("name", 'ictionDeBuffFrame')
        iction.targetFrames[guid]:EnableMouse(false)
        iction.targetFrames[guid]:SetFrameStrata("HIGH")
        iction.targetFrames[guid]:SetBackdropColor(0, 0, 0, 0)
        iction.targetFrames[guid]:SetClampedToScreen(true)
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
    local fw, fh
    if not iction.targetFrames[iction.playerGUID] then
        local offset
        if ictionBuffBarBarH == true then
            _, fw= iction.calcFrameSize(iction.uiPlayerBuffButtons)
            fh  = iction.bh+5
        else
            fw, fh = iction.calcFrameSize(iction.uiPlayerBuffButtons)
        end

        local buffFrameData = iction.ictSpellFrameData
        buffFrameData["uiParentFrame"] = iction.buffFrame
        buffFrameData["point"]['p'] = iction.buffFrame
        buffFrameData["nameAttr"] = "ictionBuffFrame"
        buffFrameData["strata"] = "MEDIUM"
        buffFrameData['w'] = fw
        buffFrameData['h'] = fh
        iction.buffFrameBldr = iction.UIElement
        iction.targetFrames[iction.playerGUID] = iction.buffFrameBldr.create(iction.buffFrameBldr, buffFrameData)
        if ictionBuffBarBarH then
            iction.targetFrames[iction.playerGUID]:SetPoint("CENTER", iction.buffFrame, 0, 0)
        else
            iction.targetFrames[iction.playerGUID]:SetPoint("CENTER", iction.buffFrame, 0, 0)
        end
        iction.targetFrames[iction.playerGUID]:Show()
        return iction.targetFrames[iction.playerGUID]
    else
        return false
    end
end