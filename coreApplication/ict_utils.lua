local iction = iction
local next = next
----------------------------------------------------------------------------------------------
--- LUA APPLICATION  ---
function iction.list_iter(t)
  local i = 0
  local n = table.getn(t)
  return function ()
       i = i + 1
       if i <= n then return t[i] end
     end
end

function iction.getSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
    return currentSpecName
end

function iction.tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

----------------------------------------------------------------------------------------------
--- BLIZZARD API ---
function iction.blizz_getChannelSpellInfo()
    local name, _, _, _, _, endTime, _, _ = UnitChannelInfo("Player")
    local sname, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(name)
    if endTime ~= nil then
        local cexpires, dur
        dur = endTime/1000.0 - GetTime()
        cexpires =  GetTime() + dur
        return spellID, cexpires, name
    else
        return nil, nil, nil
    end
end

function iction.reaper_getTargetHP()
    ---- For Priest
    local isDead = UnitIsDead("target")
    if UnitName("target") then
        local health = UnitHealth("target")
        local max_health = UnitHealthMax("target")
        local percent = (max_health * iction.blizz_isSpellReaperActive())
        if health <= percent and not isDead then
            return true
        else
            return false
    end end
end

function iction.blizz_isSpellReaperActive()
    for x=1, 7 do
        for c=1, 3 do
            local _, name, _, selected, _, spellid = GetTalentInfo(x, c, 1)
            --- how is it that ShadowyInsight talent and buff applied have different id's argh
            if spellid == 199853 and selected then
                return .35
    end end end

    return .20
end

function iction.blizz_buffActive(spellID)
    local found = false
    for x=1, 20, 1 do
        local _, _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, _, _, _, _  = UnitBuff("Player", x)
        if spellId ~= nil and spellId == spellID then
            found = true
    end end

    return found
end

----------------------------------------------------------------------------------------------
--- CACHE DATA ---
    --- CACHE DATA DEBUFF COLUMNS ---
function iction.debuffColumns_setMax()
    for i=1, iction.ict_maxTargets, 1 do
        iction.targetCols['col_'.. i] = {guid = '', colID = 'col_'.. i, active = false}
    end
end

function iction.debuffColumns_GUIDExists(guid)
    local exists = false
    for colID, colData in pairs(iction.targetCols) do
        if colData["guid"] == guid then
            exists = true
    end end
    return exists
end

function iction.debuffColumns_slotAvailable()
    local emptyColExists = false

    for _, columnData in pairs(iction.targetCols) do
        if columnData["active"] == false then
            emptyColExists = true
    end end

    return emptyColExists
end

function iction.debuffColumns_nextAvailable(guid)
    --- Do we already have a debuff column for the guid?
    local hasActiveCol = iction.debuffColumns_GUIDExists(guid)
    if hasActiveCol then return false, false end

    --- We don't have this guid as a column but do we have a slot available?
    local hasEmptyCol = iction.debuffColumns_slotAvailable()
    if not hasEmptyCol then return false, false end

    --- Add to available column now.
    local orderCol = iction.debuffColumns_createOrderColTable()
    for i = 1, iction.ict_maxTargets do
        local colID = orderCol[i]
        if not iction.targetCols[colID]["active"] then
            iction.targetCols[colID]["guid"] = guid
            iction.targetCols[colID]["active"] = true
            if iction.debugUI then print("Active colmun set to: " .. tostring(colID)) end
            return true, colID
    end end
end

function iction.debuffColumns_createOrderColTable()
    --- Add to available column now.
    local orderCol = {}
    for x = 1, iction.ict_maxTargets do
        table.insert(orderCol, "col_" .. x)
    end
    return orderCol
end

function iction.debuffColumns_clearAll()
    --- Add to available column now.
    local orderCol = iction.debuffColumns_createOrderColTable()
    for i = 1, iction.ict_maxTargets do
        local colID = orderCol[i]
        iction.targetCols[colID]["active"] = false
        iction.targetCols[colID]["guid"] = false
    end
end

    --- CACHE DATA COMBAT STUFF ---
function iction.oocCleanup()
    if UnitAffectingCombat("player") then return end

    local itr = iction.list_iter(iction.targetData)
    while true do
        local target = itr()
        if target == nil then break end
        target['frame'].setVisibility(target['frame'], false)
        target = nil
    end
    iction.targetData = {}
    iction.debuffColumns_clearAll()
    if iction.debugUITimers then print("Cleaned tables due to exiting combat.") end
end

----------------------------------------------------------------------------------------------
--- TIMERS UTILS -----------------------------------------------------------------------------
function iction.highlightTargetSpellframe(guid)
    if UnitAffectingCombat("player") then
        if guid == nil or not (UnitName("target")) or guid == "" then
            --- Hide the frame
            iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)

        elseif guid ~= iction.playerGUID then
            local stashedGuid = iction.hightlghtFrameGuid

            if stashedGuid ~= guid then
                local f = iction.targetFrames[guid] or nil
                local pf = iction.targetFrames[iction.hlGuid] or nil

                if iction.targetData[guid] ~= nil then
                    if f ~= nil and iction.targetData[guid]["dead"] ~= true then
                        iction.highlightFrameTexture:SetAllPoints(true)
                        iction.highlightFrameTexture:SetVertexColor(.1, .6, .1, .45)
                        iction.highlightFrame:SetParent(f)
                        iction.highlightFrame:SetFrameStrata("BACKGROUND")
                        iction.highlightFrame:SetPoint("BOTTOM", f, 0, 0)
                        iction.highlightFrame:SetPoint("CENTER", f, 0, 0)
                        iction.hightlghtFrameGuid = guid
                    else
                        iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)
                    end
                end

            else
                if iction.targetData[guid] ~= nil then
                    if iction.targetData[guid]['dead'] then
                        iction.highlightFrameTexture:SetVertexColor(0, 0, 0, 0)
                    end
                end
            end
        end
    end
end

function iction.clearAllSeeds(guid)
    if iction.targetTableExists() then
        if iction.targetButtons[guid] and iction.targetButtons[guid]['buttonFrames'] and iction.targetButtons[guid]['buttonFrames'][27243] and iction.targetData[guid]['spellData'][27243] ~= nil then
            iction.setButtonState(false, false, iction.targetButtons[guid]['buttonFrames'][27243])
            iction.setButtonText("", false, iction.targetButtons[guid]['buttonText'][27243])
            iction.targetData[guid]['spellData'][27243]['endTime'] = nil
        end
    end
end

function iction.addSeeds(guid, spellName, spellType, spellID)
    -- now check we have it in a column
    if not iction.debuffColumns_GUIDExists(guid) then -- it isn't present as an active target column so try to make one now.
        iction.createTarget(guid, 'nil', spellName, spellType, spellID)
    end
    if iction.debuffColumns_GUIDExists(guid) then
        iction.createTargetSpellData(guid, spellName, spellType, spellID)
        iction.createExpiresData(guid, spellName, spellType, spellID)
    end
end

function iction.updateUACount(guid)
    --- UA COUNT
    local UACount = 0
    for x = 1, 15 do
        local  _, _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, _ = UnitAura("target", x, "PLAYER HARMFUL")
        if spellId == 233490 or spellId == 233496 or spellId ==  233497 or spellId == 233498 or spellId ==  233499 then
            UACount = UACount + 1
        end
    end
    if UACount ~= 0 then
        if iction.targetData[guid] ~= nil then
            if iction.targetData[guid]['spellData'] == nil then
                iction.createTarget(guid, "aMob", "Unstable Afflction", "DEBUFF", 233490)
            end
            if iction.targetData[guid]['spellData'] ~= nil then
                if iction.targetData[guid]['spellData'][233490] ~= nil then
                    iction.targetData[guid]['spellData'][233490]['count'] = UACount
                end
            end
        end
    end
end

