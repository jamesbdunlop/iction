----------------------------------------------------------------------------------------------
--- UI INFO  ---
function iction.calcFrameSize(Tbl)
    local cfh, cfw
    local fsize = iction.ictionButtonFramePad *2

    for key, value in pairs(Tbl) do
        if value['vis'] then
            fsize = fsize + iction.bw + iction.ictionButtonFramePad
        end
    end
    cfh = fsize
    cfw = iction.bh + 5 -- frame edge padding
    return cfw, cfh
end
