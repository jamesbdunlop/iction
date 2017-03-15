local iction = iction
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
    iction.targetData[guid] = {}
    iction.targetData[guid]['spellData'] = {}
    iction.targetData[guid]['buttons'] = {}
    iction.targetData[guid]['dead'] = false
    iction.targetData[guid][colID] = {}
    iction.targetData[guid][colID]['guid'] = guid
    iction.targetData[guid][colID]['active'] = true
    if iction.debugUI then print("NEW TARGET COLID: " .. tostring(colID)) end

    --- Build frame
    local frmData = iction.ictSpellFrameData
    local fw, fh = iction.calcFrameSize(iction.getAllSpells()[1]['spells'])
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
    iction.createButtons(targetFrameBldr.frame, guid)
    iction.targetData[guid]['frame'] = targetFrameBldr
end

function iction.createButtons(frm, guid)
    --- If we've created a new frame add the buttons
    local spells = iction.getAllSpells()
    local padX, padY
    padX = 0
    padY = iction.ictionButtonFramePad

    if frm:GetAttribute("name") == 'ictionDeBuffFrame' then --- Force check for debufFrame
        for _, spellData in pairs(spells[1]['spells']) do
            local button, fontString
            local butFrameBldr = iction.UIButtonElement
            button, fontString = butFrameBldr.create(butFrameBldr, frm, spellData, "BOTTOM", padX, padY)
            padY = padY + iction.bh + iction.ictionButtonFramePad

            --- Add to cache for gui
            iction.targetData[guid]['buttons'][spellData['id']] = butFrameBldr
        end
    end
end

----------------------------------------------------------------------------------------------
--- CREATE CRETURE CACHE TABLE ENTRY  ---
function iction.createTargetSpellData(guid, spellType, spellID)
    --- If we have this target already exit early
    if iction.spellIDActive(guid, spellID) then return end

    --- New spell to track has been cast on this target. Create a table entry now
    local name, _, _, _, _, _, _ = GetSpellInfo(spellID)
    iction.targetData[guid]['spellData'][spellID] = {}
    iction.targetData[guid]['spellData'][spellID]['spellType'] = spellType
    iction.targetData[guid]['spellData'][spellID]['spellName'] = name
    iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
    iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
    iction.targetData[guid]['spellData'][spellID]['count'] = 0
    iction.targetData[guid]['spellData'][spellID]['isChanneled'] = false
    iction.targetData[guid]['spellData'][spellID]['id'] = spellID

    local channelSpellID, cexpires, name = iction.blizz_getChannelSpellInfo()
    if cexpires ~= nil then
        iction.targetData[guid]['spellData'][channelSpellID] = {}
        iction.targetData[guid]['spellData'][channelSpellID]['spellName'] = name
    end
end

function iction.createExpiresData(guid,  spellID)
    --- This is the inital setup for the spell data heading into the timers. Once this has fired
    --- the rest is taken care of by iction_utils.currentTargetDebuffExpires on update.
    --- This is used to catch a spell into the cache so if a target is changed during casting it lands in the right column
    -- Channels
    if iction.isValidButtonFrame(guid) then
        local channelSpellID, cexpires = iction.blizz_getChannelSpellInfo()
        if cexpires ~= nil then
            iction.targetData[guid]['spellData'][channelSpellID]['endTime'] = cexpires
            iction.targetData[guid]['spellData'][channelSpellID]['isChanneled'] = true
        else
            --- Adding this as a clean run through due to casting drain soul which seeding which will ignite into corruptions.
            local _, _, _, count, _, _, expires, _, _, _, _, _, _, _, _, _, _, _, _ = UnitDebuff("Target", spellID, nil, "PLAYER")
            iction.targetData[guid]['spellData'][spellID]['endTime'] = expires
            iction.targetData[guid]['spellData'][spellID]['count'] = count
        end
    end
end

