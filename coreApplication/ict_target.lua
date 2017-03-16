local iction = iction
local UnitBuff, UnitDebuff, UnitGUID = UnitBuff, UnitDebuff, UnitGUID
----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET CACHE ENTRY  ---
function iction.createTarget(guid)
    --- If we have this target already exit early
    if iction.targetData[guid] then return end

    --- Do we have a free colum to use?
    if iction.debuffColumns_GUIDExists(guid) then return end

    local freeCol, colID = iction.debuffColumns_nextAvailable(guid)
    if not freeCol then return end --- return early

    --- Create New target
    local newTargetData = {}
          newTargetData["guid"] = guid
          newTargetData["dead"] = false
          newTargetData["spellData"] = {}
          newTargetData["colID"] = {}
          newTargetData["colID"]['guid'] = guid
          newTargetData["colID"]['active'] = true
          if iction.debugUITimers then print("NEW TARGET TABLE ENTRY: " .. tostring(guid)) end
          if iction.debugUITimers then print("NEW TARGET COLID: " .. tostring(colID)) end

    --- Build frame
    local frmData = iction.ictSpellFrameData
    local fw, fh = iction.calcFrameSize(iction.getAllSpells())
          frmData['w'] = fw
          frmData['h'] = fh
          frmData['pointPosition']["point"] = "BOTTOM"
          frmData['pointPosition']['relativeTo'] = iction.debuffColumns[colID].frame
          frmData['uiParentFrame'] = iction.debuffColumns[colID].frame

    local targetFrameBldr = {}
          setmetatable(targetFrameBldr, {__index = iction.UIFrameElement})
          targetFrameBldr.create(targetFrameBldr, iction.ictSpellFrameData)
          targetFrameBldr.frame:SetPoint("CENTER", iction.debuffColumns[colID].frame)
          targetFrameBldr.frame:SetPoint("BOTTOM", iction.debuffColumns[colID].frame)

    newTargetData["frame"] = targetFrameBldr
    newTargetData["buttons"] = iction.createButtons(targetFrameBldr.frame, guid)
    table.insert(iction.targetData, newTargetData)
end

local padX, padY
function iction.createButtons(frm, guid)
    local buttons = {}
    local itr = iction.list_iter(iction.getAllSpells())
    padX = 0
    padY = iction.ictionButtonFramePad
    while true do
        local buttonData = itr()
        if buttonData == nil then break end
        if not buttonData['id'] then break end

        local butFrameBldr = {}
              setmetatable(butFrameBldr, {__index = iction.UIButtonElement})
              butFrameBldr.create(butFrameBldr, frm, buttonData, "BOTTOM", padX, padY)

        table.insert(buttons, butFrameBldr)
        padY = padY + iction.bh + iction.ictionButtonFramePad
    end
    return buttons
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE CACHE TABLE ENTRY  ---
function iction.createTargetSpellData(guid, spellType, spellID)
    --- Put the spell into the spell tables now
    local name, rank, icon, castingTime, minRange, maxRange, spellID2  = GetSpellInfo(spellID)

    local itr = iction.list_iter(iction.targetData)
    while true do
        local creatureTable = itr()
        if creatureTable == nil then break end
        if creatureTable['guid'] == guid then
            local function isSpellActive(spellData, spellID)
                local spells = iction.list_iter(spellData)
                while true do
                    local spellInfo = spells()
                    if spellInfo == nil then break end
                    if spellInfo['id'] == spellID then
                        return true
                    end
                end
                return false
            end

            local function updateExpiresInfo(table)
                if iction.debugUITimers then print("Updating endtime") end
                -- EXPIRES
                local channelSpellID, cexpires = iction.blizz_getChannelSpellInfo()
                if cexpires ~= nil then
                    table['endTime'] = cexpires
                    table['isChanneled'] = true
                    table['id'] = channelSpellID
                    if iction.debugUITargetSpell then print("cexpires: " .. tostring(cexpires)) end
                else
                    local nme, _, _, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellid, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3  = UnitDebuff("TARGET", name, nil, "PLAYER")
                    if iction.debugUITargetSpell then print("nme: " .. tostring(nme)) end
                    if iction.debugUITargetSpell then print("expires: " .. tostring(expires)) end
                    if iction.debugUITargetSpell then print("expires: " .. tostring(expires)) end
                    if iction.debugUITargetSpell then print("duration: " .. tostring(duration)) end
                    if iction.debugUITargetSpell then print("value1: " .. tostring(value1)) end
                    if iction.debugUITargetSpell then print("value2: " .. tostring(value2)) end
                    if iction.debugUITargetSpell then print("timeMod: " .. tostring(timeMod)) end
                    table['endTime'] = expires
                    table['count'] = count
                end
                return table
            end

            if not isSpellActive(creatureTable['spellData'], spellID) then
                if iction.debugUITimers then print("Adding NEW spell: " .. tostring(name)) end
                local spellInfo = {}
                      spellInfo['spellType'] = spellType
                      spellInfo['spellName'] = name
                      spellInfo['id'] = spellID
                      spellInfo['count'] = 0
                      spellInfo['isChanneled'] = false
                      updateExpiresInfo(spellInfo)
                      table.insert(creatureTable['spellData'], spellInfo)
            else
                updateExpiresInfo(creatureTable['spellData'])
            end

            if iction.debugUITimers then print("#############") end
            break
    end end
end