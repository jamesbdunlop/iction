local iction = iction
----------------------------------------------------------------------------------------------
--- UI ACTIONS  ---
function iction.unlockUIElements(unlock)
    if unlock then
        for _, frameBldr in pairs(iction.moveableUIFrames) do
            if iction.debugUI then print("frameName: ".. frameBldr.frameName) end
            frameBldr.setFrameLockState(frameBldr, false)
            frameBldr.text:SetText(frameBldr.frameName)
            frameBldr.setMoveScript(frameBldr)
            frameBldr.setMovedPosition(frameBldr)
            frameBldr.textures[1]:SetVertexColor(.1, 1, 0, .1)
        end
    else
        for _, frameBldr in pairs(iction.moveableUIFrames) do
            frameBldr.setFrameLockState(frameBldr, true)
            frameBldr.text:SetText("")
            frameBldr.textures[1]:SetVertexColor(.1, 1, 0, 0)
            frameBldr.setRemoveMoveScript(frameBldr)
    end end
end

function iction.setSoulShards(shards)
    if iction.class == iction.L['Warlock'] then
        iction.shardFrameBldr.setTextureVertexColor(iction.shardFrameBldr, 1, 1, 1, 0)
        for x = 2, shards do
            iction.shardFrameBldr.textures[x]:SetVertexColor(1, 1, 1, 1)
        end
    end
end

function iction.setConflagCount()
    if iction.class == iction.L['Warlock'] then
        if iction.spec == 3 then
            iction.conflagFrameBldr.setTextureVertexColor(iction.conflagFrameBldr, 1, 1, 1, 0)
            local confCount, _ = iction.getConflagCharges()
            if confCount then
                for x = 2, confCount+1 do -- wtf lua and your stupid default index 0
                    iction.conflagFrameBldr.textures[x]:SetVertexColor(1, 1, 1, 1)
                end
    end end end
end

function iction.specChanged()
    local spec = GetSpecialization()
    if not iction.mainFrameBldr then iction.initMainUI() end

    if iction.spec ~= spec then
        iction.spec = spec
        DEFAULT_CHAT_FRAME:AddMessage(iction.L['specChangeMSG'], 15, 25, 35)
        -- Reset the UI now
        iction.highlightFrameTexture = nil

        if iction.class == iction.L['Warlock'] then
            if spec == 3 then
                iction.conflagFrameBldr = nil
                iction.createConflagFrame()
            end
            iction.shardFrameBldr = nil
            iction.createShardFrame()
        end

        if iction.class == iction.L['Priest'] then
            if spec == 3 then
                iction.createDebuffColumns()
                iction.ictionMF:Show()
            else
                if iction.ictionMF then iction.ictionMF:Hide() end
                iction.spec = spec
                return
        end end

        -- Change the artifact frame
        iction.createArtifactFrame()

        -- Reset highlightframe size for buttons changes
        iction.highlightFrameTexture = iction.createHighlightFrame()
    end
end
