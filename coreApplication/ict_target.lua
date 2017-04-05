local iction = iction
local UnitDebuff, GetSpellInfo = UnitDebuff, GetSpellInfo
----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET CACHE ENTRY  ---
function iction.createTarget(guid)
    if not guid then return end

    --- If we have this target already exit early
    iction.targetExists = false
    local tgDItr = iction.list_iter(iction.targetData)
    while true do
        local target = tgDItr()
        if target == nil then break end
        if target["guid"] == guid then iction.targetExists = true break end
    end

    if iction.targetExists then return end

    --- Do we have a free colum to use?
    if iction.debuffColumns_GUIDExists(guid) then return end

    local freeCol, colID = iction.debuffColumns_nextAvailable(guid)
    if not freeCol then return end --- return early

    --- Create New target
    local targetData = {}
          targetData["guid"] = guid
          targetData["dead"] = false
          targetData["spellData"] = {}
          targetData["colID"] = {}
          targetData["colID"]['id'] = colID
          targetData["colID"]['guid'] = guid
          targetData["colID"]['active'] = true
          if iction.debugUITargetSpell then print("NEW TARGET TABLE ENTRY: " .. tostring(guid)) end
          if iction.debugUITargetSpell then print("NEW TARGET COLID: " .. tostring(colID)) end

    --- Build frame
    local fh
    local curSpells = ictionValidSpells[iction.class][iction.spec]["spells"]
    if curSpells then
        fh = iction.tablelength(curSpells)
    else
        fh = 0
    end

    local frmData = iction.ictSpellFrameData
          frmData['w'] = iction.bw + iction.ictionButtonFramePad
          frmData['h'] = fh * iction.bh
          frmData['pointPosition']["point"] = "BOTTOM"
          frmData['pointPosition']['relativeTo'] = iction.debuffColumns[colID].frame
          frmData['uiParentFrame'] = iction.debuffColumns[colID].frame

    local targetFrameBldr = {}
          setmetatable(targetFrameBldr, {__index = iction.UIFrameElement})
          targetFrameBldr.create(targetFrameBldr, iction.ictSpellFrameData)
          targetFrameBldr.frame:SetPoint("CENTER", iction.debuffColumns[colID].frame)
          targetFrameBldr.frame:SetPoint("BOTTOM", iction.debuffColumns[colID].frame)

    targetData["frame"] = targetFrameBldr
    targetData["buttons"] = iction.createButtons(targetFrameBldr.frame)
    iction.targetData[guid] = targetData
end

local padX, padY
function iction.createButtons(frm)
    local buttons = {}
    local itr = iction.list_iter(iction.getAllSpells())
    padX = 0
    padY = iction.ictionButtonFramePad
    while true do
        local spellData = itr()
        if spellData == nil then break end
        local id = spellData['id']
        if not id then break end
        if iction.validSpellID(id) then
            local butFrameBldr = {}
                  setmetatable(butFrameBldr, {__index = iction.UIButtonElement})
                  butFrameBldr.create(butFrameBldr, frm, spellData, "BOTTOM", padX, padY)
                  butFrameBldr.addCountFontString(butFrameBldr, "THICKOUTLINE", "OVERLAY", false, "LEFT", 0, -(iction.bh/2), 12, 1, 0, 0, 1)
            buttons[id] = butFrameBldr
            padY = padY + iction.bh + iction.ictionButtonFramePad
    end end
    return buttons
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE CACHE TABLE ENTRY  ---
function iction.createTargetSpellData(guid, spellType, spellID, spellName)
    local function isSpellActive(spellTable, spellID)
        for tspellID, spellData in pairs(spellTable) do
            if spellData == nil then break end
            if tspellID == spellID then
                return true
            end
        end
        return false
    end
    local function getExpiresInfo(spellName, guid)
        local expiresData = {}
              expiresData['endTime'] = 0
              expiresData['isChanneled'] = false
              expiresData['count'] = 0
        if not spellName then return expiresData end
        if iction.debugUITimers then print("...FETCHING ENDTIME...") end
        if iction.debugRunningTimers then print('Clearning all channeled spells but target...') end

        -- EXPIRES
        local channelSpellID, cexpires = iction.blizz_getChannelSpellInfo()
        local nme, _, _, count, _, duration, expires, _, _, _, _, _, _, _, _, _, _, _, _  = UnitDebuff("TARGET", spellName, nil, "PLAYER")

        if channelSpellID == spellID then
            expiresData['endTime'] = cexpires
            expiresData['isChanneled'] = true
        else
            expiresData['endTime'] = expires
            expiresData['count'] = count
        end
        if iction.debugUITargetSpell then print("nme: " .. tostring(nme)) end
        if iction.debugUITargetSpell then print("expires: " .. tostring(expires)) end
        if iction.debugUITargetSpell then print("duration: " .. tostring(duration)) end
        if iction.debugUITargetSpell then print("#############") end
        return expiresData
    end

    if not spellType then return end
    if not iction.debuffColumns_GUIDExists(guid) then return end

    for tguid, targetData in pairs(iction.targetData) do
        local targetData = targetData
        if targetData == nil then break end
        if tguid == guid then
            local active = isSpellActive(targetData["spellData"], spellID)
            local spellName, _, _, _, _, _, _  = GetSpellInfo(spellID)
            if not active then
                local spellInfo = {}
                      spellInfo['guid'] = guid
                      spellInfo['spellType'] = spellType
                      spellInfo['spellName'] = spellName
                      spellInfo['id'] = spellID
                      spellInfo['count'] = 0
                      spellInfo['expires'] = getExpiresInfo(spellName, guid)
                targetData["spellData"][spellID] = spellInfo
            else
                if guid == UnitGUID("Target") then
                    local nme, _, _, count, _, duration, expires, _, _, _, _, _, _, _, _, _, _, _, _  = UnitDebuff("TARGET", spellName, nil, "PLAYER")
                    targetData["spellData"][spellID]["expires"]['endTime'] = expires
                    targetData["spellData"][spellID]["expires"]['count'] = count
                end
            end
        end
    end
end
