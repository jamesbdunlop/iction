local iction = iction
local UnitBuff, UnitDebuff, UnitGUID, GetSpellInfo = UnitBuff, UnitDebuff, UnitGUID, GetSpellInfo
----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET CACHE ENTRY  ---
function iction.createTarget(guid)
    --- If we have this target already exit early
    local tgtExists = false
    local tgDItr = iction.list_iter(iction.targetData)
    while true do
        local target = tgDItr()
        if target == nil then break end
        if target["guid"] == guid then tgtExists = true break end
    end

    if tgtExists then return end

    --- Do we have a free colum to use?
    if iction.debuffColumns_GUIDExists(guid) then return end

    local freeCol, colID = iction.debuffColumns_nextAvailable(guid)
    if not freeCol then return end --- return early

    --- Create New target
    local targetData = {}
          targetData["guid"] = guid
          targetData["dead"] = false
          targetData["colID"] = {}
          targetData["colID"]['id'] = colID
          targetData["colID"]['guid'] = guid
          targetData["colID"]['active'] = true
          if iction.debugUITimers then print("NEW TARGET TABLE ENTRY: " .. tostring(guid)) end
          if iction.debugUITimers then print("NEW TARGET COLID: " .. tostring(colID)) end

    --- Build frame
    local fh = iction.tablelength(iction.getAllSpells())
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
    table.insert(iction.targetData, targetData)
end

local padX, padY
function iction.createButtons(frm)
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
    local targetDataTable = iction.list_iter(iction.targetData)
    while true do
        local targetData = targetDataTable()
        if targetData == nil then break end

        if targetData['guid'] == guid then
            local function isSpellActive(activeSpellTable, guid, spellID)
                local activeSpellTables = iction.list_iter(activeSpellTable)
                while true do
                    local spellTable = activeSpellTables()
                    if spellTable == nil then break end
                    -- Check for id and guid match and return table associated with the spell
                    if spellTable['id'] == spellID and spellTable['guid'] == guid then
                        if iction.debugUITimers then print("SPELL IS ACTIVE...") end
                        return true, spellTable
                    end
                end
                if iction. debugUITimers then print("SPELL IS NOT ACTIVE...") end
                return false, nil
            end

            local function getExpiresInfo(spellName)
                local expiresData = {}
                      expiresData['endTime'] = 0
                      expiresData['isChanneled'] = false
                      expiresData['count'] = 0
                if not spellName then return expiresData end

                if iction.debugUITimers then print("...FETCHING ENDTIME...") end
                -- EXPIRES
                local channelSpellID, cexpires = iction.blizz_getChannelSpellInfo()
                if channelSpellID == spellID then
                    expiresData['endTime'] = cexpires
                    expiresData['isChanneled'] = true
                    if iction.debugUITargetSpell then print("cexpires: " .. tostring(cexpires)) end
                else
                    local nme, _, _, count, _, duration, expires, _, _, _, _, _, _, _, _, _, _, _, _  = UnitDebuff("TARGET", spellName, nil, "PLAYER")
                    if iction.debugUITargetSpell then print("nme: " .. tostring(nme)) end
                    if iction.debugUITargetSpell then print("expires: " .. tostring(expires)) end
                    if iction.debugUITargetSpell then print("duration: " .. tostring(duration)) end
                    expiresData['endTime'] = expires
                    expiresData['count'] = count
                end
                if iction.debugUITargetSpell then print("#############") end
                return expiresData
            end

            -- If the target has been marked as dead move on.
            if targetData["dead"] then return end
            if not targetData["colID"]['active'] then return end

            -- Is the spell cast in the currently active spell table?
            local active, activeTable = isSpellActive(iction.activeSpellTable, guid, spellID)
            local spellName, _, _, _, _, _, _  = GetSpellInfo(spellID)
            if not active then
                -- Create a new active spell in the activeSpellTable
                local spellInfo = {}
                      spellInfo['guid'] = guid
                      spellInfo['spellType'] = spellType
                      spellInfo['spellName'] = spellName
                      spellInfo['id'] = spellID
                      spellInfo['count'] = 0
                      spellInfo['buttons'] = targetData["buttons"]
                      spellInfo['expires'] = getExpiresInfo(spellName)
                table.insert(iction.activeSpellTable, spellInfo)
                if iction.debugUITimers then print("ADDED NEW SPELL TABLE: " .. tostring(name)) end
            else
                -- spell is active update the expires for timers
                -- Find the active spelltable for guid and update the expires
                activeTable['expires'] = getExpiresInfo(spellName)
            end
            if iction.debugUITimers then print("#############") end
        end
    end
end
