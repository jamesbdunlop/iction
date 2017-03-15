local iction = iction
----------------------------------------------------------------------------------------------
--- UI ACTIONS  ---
function iction.unlockUIElements(unlock)
    if unlock then
        for _, frameBldr in pairs(iction.moveableUIFrames) do
            print("lockState change for " .. frameBldr.frame:GetAttribute("name"))
            frameBldr.setFrameLockState(frameBldr, "unlocked")
        end
    else
        for _, frameBldr in pairs(iction.moveableUIFrames) do
            frameBldr.setFrameLockState(frameBldr, "locked")
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
    if iction.soulShards then
        for x = 1, 5 do
            iction.soulShards[x]:SetVertexColor(1, 1, 1, 0)
        end
        for x = 1, shards do
            if iction.soulShards[x] ~= nil then
                iction.soulShards[x]:SetVertexColor(1, 1, 1, 1)
    end end end
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

