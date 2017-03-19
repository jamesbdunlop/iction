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
        local prev = iction.hlGuid
        if prev ~= guid then
            local tgIter = iction.list_iter(iction.targetData)
            while true do
                local target = tgIter()
                if not target then break end
                target['frame'].setTextureVertexColor(target['frame'], 0,0,0,0)
            end
            local activeFrameBldr = iction.debuffColumns_currentTargetFrameBldr(guid)
            if activeFrameBldr then
                iction.hlGuid = guid
                activeFrameBldr.textures[1]:SetVertexColor(0, 1, 0, .15)
                activeFrameBldr.textures[1]:SetAllPoints(true)
    end end end
end
