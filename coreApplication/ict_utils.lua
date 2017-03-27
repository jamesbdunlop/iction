local iction = iction
local next = next
----------------------------------------------------------------------------------------------
--- LUA APPLICATION  ---
function iction.list_iter(t)
  local i = 0
  local n = table.getn(t)
  return function ()
       i = i + 1
       if i <= n then return t[i], i end
     end
end

function iction.getSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
    return currentSpecName
end

function iction.tablelength(T)
  local count = 0
  local itr = iction.list_iter(T)
  while true do
      local t = itr()
      if not t then break end
      count = count + 1
  end
  return count
end

function iction.validSpellID(id)
    if ictionValidSpells[iction.class][iction.spec]["spells"] then
        local validIter = iction.list_iter(ictionValidSpells[iction.class][iction.spec]["spells"])
        while true do
            local spellID = validIter()
            if not spellID then break end
            if id == spellID then return true end
        end
    end
    return false
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

function iction.blizz_fetchCooldownET(spellID)
    if iction.debugTimers then print("fetchCooldownET") end
    local start, duration, _ = GetSpellCooldown(spellID)
    local actualFinish = start+duration
    local et = (actualFinish - GetTime()) + GetTime()
    if start == 0 then
        return false
    else
        return et
    end
end

function iction.blizz_fetchRemainingT(remainingT)
    local rt = remainingT
    local TL = tonumber(string.format("%.1f", (rt)))
    if TL > 60.0 then
        rt = tostring(tonumber(string.format("%.1f", rt/60.0))) .. "m"
    else
        rt = tonumber(string.format("%.1d", rt))
    end
    return rt
end

function iction.isReaperActive()
    for x=1, 7 do
        for c=1, 3 do
            local _, name, _, selected, _, spellid = GetTalentInfo(x, c, 1)
            --- how is it that ShadowyInsight talent and buff applied have different id's argh
            if spellid == 199853 and selected then
                return .35
    end end end
    return .20
end

function iction.blizz_getTargetHP()
    local isDead = UnitIsDead("target")
    if UnitName("target") then
        local health = UnitHealth("target")
        local max_health = UnitHealthMax("target")
        local percent = (max_health * iction.isReaperActive())
        if health <= percent and not isDead then
            return true
        else
            return false
    end end
end

----------------------------------------------------------------------------------------------
--- SPELL INFO ---
function iction.getConflagCharges()
    local currentCharges, maxCharges = GetSpellCharges("Conflagrate")
    return currentCharges, maxCharges
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
    for _, colData in pairs(iction.targetCols) do
        if colData["guid"] == guid then
            exists = true
    end end
    return exists
end

function iction.debuffColumns_currentTargetFrameBldr(guid)
    local tgIter = iction.list_iter(iction.targetData)
    while true do
        local target = tgIter()
        if not target then break end

        if target["guid"] == guid and target["colID"]['active'] then
            return target['frame']
    end end
    return nil
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
    local orderCol = iction.debuffColumns_createOrderColTable()
    for i = 1, iction.ict_maxTargets do
        local colID = orderCol[i]
        iction.targetCols[colID]["active"] = false
        iction.targetCols[colID]["guid"] = false
    end
end

----------------------------------------------------------------------------------------------
--- CACHE DATA COMBAT STUFF ---
function iction.oocCleanup()
    if UnitAffectingCombat("player") then return end
    if iction.class == iction.L['Priest'] and iction.spec == 3 then
        if ict_UnlockCBx then
            if not ict_UnlockCBx:GetChecked() then return end
        end
        iction.voidFrameBldr.frame:Hide()
        iction.SWDFrameBldr.frame:Hide()
    end
    local itr = iction.list_iter(iction.targetData)
    while true do
        local target = itr()
        if target == nil then break end
        target['frame'].setVisibility(target['frame'], false)
        target = nil
    end
    iction.targetData = {}
    iction.activeSpellTable = {}
    iction.debuffColumns_clearAll()
    if iction.debugUITimers then print("EXIT COMBAT DETECTED. TABLES CLEANED!") end
end

function iction.targetsColumns_clearAllChanneled(guid)
    local itr  = iction.list_iter(iction.activeSpellTable)
    while true do
        local spellData = itr()
        if not spellData then break end
        if spellData['expires']['isChanneled'] and spellData['guid'] ~= guid then
            spellData['expires']['endTime']= 0
    end end
end

function iction.targetsColumns_tagDead(guid)
    local itr  = iction.list_iter(iction.targetData)
    while true do
        local targetData = itr()
        if not targetData then break end
        if targetData["guid"] == guid then
            targetData["dead"] = false
            targetData["frame"].setVisibility(targetData['frame'], false)
            targetData = nil
            if iction.debugWatcher then print("Removed targetData: " .. tostring(guid)) end
    end end

    local itr  = iction.list_iter(iction.activeSpellTable)
    while true do
        local spellData = itr()
        if not spellData then break end
        if spellData["guid"] == guid then
            spellData = nil
            if iction.debugWatcher then print("Removed activeSpell Data: " .. tostring(guid)) end
    end end
end

function iction.isBuffInCacheData(spellName)
    local itr  = iction.list_iter(iction.buffButtons)
    while true do
        local spellData = itr()
        if not spellData then break end
        if spellData['uiName'] == spellName then
            return true, spellData
    end end
    return false, nil
end

function iction.clearBuffButtons()
    local itr  = iction.list_iter(iction.buffButtons)
    while true do
        local spellData = itr()
        if not spellData then break end
        spellData['frame'].setVisibility(spellData['frame'], false)
        ictionBuffPadX = ictionBuffPadX - iction.bw - iction.ictionButtonFramePad
    end
    iction.buffButtons = {}
end

