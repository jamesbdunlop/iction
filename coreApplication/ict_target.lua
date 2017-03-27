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
          targetData["colID"] = {}
          targetData["colID"]['id'] = colID
          targetData["colID"]['guid'] = guid
          targetData["colID"]['active'] = true
          if iction.debugUITimers then print("NEW TARGET TABLE ENTRY: " .. tostring(guid)) end
          if iction.debugUITimers then print("NEW TARGET COLID: " .. tostring(colID)) end

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
        local id = buttonData['id']
        if not id then break end

        if iction.validSpellID(id) then
            local butFrameBldr = {}
                  setmetatable(butFrameBldr, {__index = iction.UIButtonElement})
                  butFrameBldr.create(butFrameBldr, frm, buttonData, "BOTTOM", padX, padY)

            table.insert(buttons, butFrameBldr)
            padY = padY + iction.bh + iction.ictionButtonFramePad
        end
    end
    return buttons
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE CACHE TABLE ENTRY  ---
function iction.createTargetSpellData(guid, spellType, spellID)
    if not spellType then return end
    if iction.debugUITimers then print("createTargetSpellData: guid:"..tostring(guid)) end
    if iction.debugUITimers then print("createTargetSpellData: spellType:"..tostring(spellType)) end
    if iction.debugUITimers then print("createTargetSpellData: spellID:"..tostring(spellID)) end

    local targetDataTable = iction.list_iter(iction.targetData)

    while true do
        local targetData = targetDataTable()
        if targetData == nil then break end

        if targetData['guid'] == guid then
            local function isSpellActive(activeSpellTable, guid, spellID)
                if iction.debugUITimers then print("Checking guid table:"..tostring(guid)) end
                local activeSpellTables = iction.list_iter(activeSpellTable)
                while true do
                    local spellTable = activeSpellTables()
                    if spellTable == nil then break end
                    -- Check for id and guid match and return table associated with the spell
                    if spellTable['id'] == spellID and spellTable['guid'] == guid then
                        if iction.debugUITimers then print("SPELL IS ACTIVE: "..tostring(spellID)) end
                        return true, spellTable
                    end
                end
                if iction. debugUITimers then print("SPELL IS NOT ACTIVE: "..tostring(spellID)) end
                return false, nil
            end

            local function getExpiresInfo(spellName, guid)
                local expiresData = {}
                      expiresData['endTime'] = 0
                      expiresData['isChanneled'] = false
                      expiresData['count'] = 0
                if not spellName then return expiresData end

                if iction.debugUITimers then print("...FETCHING ENDTIME...") end
                if iction.debugRunningTimers then print('Clearning all channeled spells but target...') end
                iction.targetsColumns_clearAllChanneled(guid)
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
                      spellInfo['expires'] = getExpiresInfo(spellName, guid)
                table.insert(iction.activeSpellTable, spellInfo)
                if iction.debugUITimers then print("ADDED NEW SPELL TABLE: " .. tostring(spellName)) end
            else
                -- spell is active update the expires for timers
                -- Find the active spelltable for guid and update the expires
                activeTable['expires'] = getExpiresInfo(spellName, guid)
                if iction.debugUITimers then print("Updated Expires info: " .. tostring(activeTable['expires']['endTime'])) end
            end
            if iction.debugUITimers then print("#############") end
        end
    end
end
