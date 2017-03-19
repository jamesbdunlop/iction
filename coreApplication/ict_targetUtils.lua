local iction = iction
------------------------------------------
--- Update current target debuffs
function iction.isSpellOnCooldown(spellID)
    if iction.debugTimers then print("isSpellOnCooldown") end
    if spellID ~= nil then
        local start, duration, enabled = GetSpellCooldown(spellID)
        if enabled == 0 then
            return false
        elseif ( start > 0 and duration > 1.5) then
            return true
        end
    else return false
    end
end

function iction.targetChanged(guid)
    if iction.debugUI then print('Target changed') end
    if UnitAffectingCombat("player") then
        if guid == nil or not (UnitName("target")) or guid == "" then
            --- Hide the frame
            iction.highlightFrameBldr.textures[2]:SetVertexColor(1, 0, 0, 0)
            iction.highlightFrameBldr.frame:SetHeight(0)
        else
            local prev = iction.hlGuid
            if prev ~= guid then
                iction.hlGuid = guid
                local activeCol = iction.debuffColumns_FetchGUIDCol(guid)
                if activeCol then
                    if iction.debugUI then print("Changed highlight parent to col: " .. tostring(activeCol)) end
                    iction.highlightFrameBldr.textures[2]:SetVertexColor(0, 1, 0, 1)
                    iction.highlightFrameBldr.textures[2]:SetAllPoints(true)
                    iction.highlightFrameBldr.frame:SetParent(iction.debuffColumns[activeCol].frame)
                    local fh = iction.tablelength(iction.getAllSpells())
                    if iction.debugUI then print("frameHeight: " ..tostring(fh)) end
                    iction.highlightFrameBldr.frame:SetHeight(fh)
                    iction.highlightFrameBldr.frame:SetPoint("BOTTOM", iction.debuffColumns[activeCol].frame, 0, 0)
                    iction.highlightFrameBldr.frame:SetPoint("CENTER", iction.debuffColumns[activeCol].frame, 0, 0)
    end end end end
end