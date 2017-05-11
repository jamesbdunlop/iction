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

function iction.fetchCooldownET(spellID)
    local start, duration, _ = GetSpellCooldown(spellID)
    local actualFinish = start+duration
    if not start then return nil end
    return actualFinish
end

function iction.targetChanged(guid)
    if iction.debugUI then print('Target changed') end
    if UnitAffectingCombat("player") then
        local prev = iction.hlGuid
        if prev ~= guid then
            for guid, targetData in pairs(iction.targetData) do
                if not targetData then break end
                targetData['frame'].setTextureVertexColor(targetData['frame'], 0,0,0,0)
            end

            local activeFrameBldr = iction.debuffColumns_currentTargetFrameBldr(guid)
            if activeFrameBldr then
                iction.hlGuid = guid
                activeFrameBldr.textures[1]:SetVertexColor(0, 1, 0, .35)
                activeFrameBldr.textures[1]:SetGradientAlpha("VERTICAL", .1, 1, .1, .8, .1, .5, .1, .1)
                activeFrameBldr.textures[1]:SetAllPoints(true)
    end end end
end
