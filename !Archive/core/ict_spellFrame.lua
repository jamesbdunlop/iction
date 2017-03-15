local iction = iction
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
        iction.buffFrameBldr = iction.UIFrameElement
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