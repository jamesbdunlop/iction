local iction = iction
----------------------------------------------------------------------------------------------
--- UI ACTIONS  ---
function iction.unlockUIElements(unlock)
    if unlock then
        for _, frameBldr in pairs(iction.moveableUIFrames) do
            print("frameName: " .. frameBldr.frameName)
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

function iction.setMTapBorder(color)
    local mt
    for x=1, 4 do
        local f = iction.uiBotBarArt[x]
        if f then
            f.setTextureVertexColor( f, color[0], color[1],color[2], color[3] )
    end end
end

function iction.setSoulShards(shards)
    iction.shardFrameBldr.setTextureVertexColor(iction.shardFrameBldr, 1, 1, 1, 0)
    for x = 1, shards do
        iction.shardFrameBldr.textures[x]:SetVertexColor(1, 1, 1, 1)
    end
end

function iction.setConflagCount()
    if iction.class == iction.L['Warlock'] then
        if iction.spec == 3 then
            local confCount = iction.getConflagCharges() or 0
            for x = 1, 2 do
                iction.conflags[x]:SetVertexColor(0, 0, 0, 0)
            end
            for x = 1, confCount do
                iction.conflags[x]:SetVertexColor(1, 1, 1, 1)
    end end end
end

function iction.specChanged()
    local spec = GetSpecialization()
    if not iction.mainFrameBldr then iction.initMainUI() end

    if iction.spec ~= spec then
        iction.spec = spec
        DEFAULT_CHAT_FRAME:AddMessage(iction.L['specChangeMSG'], 15, 25, 35)
        iction.shardFrameBldr = nil
        iction.highlightFrameTexture = nil
        if iction.class == iction.L['Warlock'] then
            -- Conflag frame for destro spec
            if iction.spec == 3 then
                iction.createConflagFrame()
            else
                if iction.conflagFrameBldr ~= nil then
                    iction.conflagFrameBldr.frame:Hide()
            end end
            -- Reset all soul shard images to 0 as the shard count resets on spec change
            for i = 1, iction.tablelength(iction.soulShards) do
                if iction.soulShards[i] ~= nil then
                    iction.soulShards[i].frame:Hide()
            end end
            iction.createShardFrame()
            local shards = UnitPower("Player", 7)
            iction.setSoulShards(shards)
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