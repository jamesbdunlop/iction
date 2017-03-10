local localizedClass, _, _ = UnitClass("Player")
local iction = iction
----------------------------------------------------------------------------------------------
--- CREATE TARGET SPELLS UI  ---
function iction.createSpellFrame(guid)
    local freeSlot, colID = iction.findSlot(guid)
    if not freeSlot then return false end --- return early

    if not iction.targetFrames[guid] then --- Build a new frame
        local frmData = iction.ictSpellFrameData
        local fw, fh = iction.calcFrameSize(iction.getAllSpells()[1]['spells'])
        frmData['w'] = fw
        frmData['h'] = fh
        local f = iction.UIElement
        iction.targetFrames[guid] = f.create(f, iction.ictSpellFrameData)

        -- Set frame to be an active column in the debuff columns table
        iction.targetCols[colID]['guid'] = guid
        iction.targetCols[colID]['active'] = true
        iction.targetFrames[guid]:SetPoint("CENTER", iction.debuffColumns[colID])
        iction.targetFrames[guid]:SetPoint("BOTTOM", iction.debuffColumns[colID])
        return iction.targetFrames[guid]
    else
        return false
    end
end

----------------------------------------------------------------------------------------------
--- CREATE PLAYER BUFF UI  ---
function iction.createPlayerBuffFrame()
    -- work out h w from active buff count
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