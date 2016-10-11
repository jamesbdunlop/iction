----------------------------------------------------------------------------------------------
--- CREATE TARGET SPELLS UI  ---
function iction.createSpellFrame(creatureName, guid, bgFile)
    if iction.debug then print("Dbg: iction.createSpellFrame for " .. tostring(creatureName)) end
    local freeSlot, colID = iction.findSlot(guid)
    if freeSlot and not iction.targetFrames[guid] then
        local fw, fh
        fw, fh = iction.calcFrameSize(iction.uiPlayerSpellButtons)

        local spellFrameData = iction.ictSpellFrameData
        spellFrameData["uiParentFrame"] = nil --"iction_"..colID
        spellFrameData["point"]['p'] = "iction_"..colID
        spellFrameData['w'] = fw
        spellFrameData['h'] = fh
        iction.spellFrameBldr = iction.UIElement
        iction.targetFrames[guid] = iction.spellFrameBldr.create(iction.spellFrameBldr, spellFrameData)
        iction.targetFrames[guid]:SetParent("iction_"..colID)
        iction.spellFrameBldr.addTexture(iction.targetFrames[guid], "iction_"..colID, 32, 28, "ARTWORK", true, nil, nil, nil, bgFile, .2, .1, .1, 1)
        -- Set frame to be an active column in the debuff columns table
        iction.targetCols[colID]['guid'] = guid
        iction.targetCols[colID]['active'] = true

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