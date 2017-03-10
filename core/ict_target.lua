----------------------------------------------------------------------------------------------
--- CREATE AN ICTION TARGET ------------------------------------------------------------------
function iction.createTarget(guid, spellType, spellID)
    local frm
    if guid ~= nil then
        if guid ~= iction.playerGUID then
            frm = iction.createSpellFrame(guid)
        end
        --- Only create the buttons on frame creation
        if frm then iction.createButtons(frm, guid) frm:Show() end
        iction.createTargetData(guid)
        iction.createTargetSpellData(guid, spellType, spellID)
        iction.createExpiresData(guid, spellID)
    end
end
----------------------------------------------------------------------------------------------
--- CREATE CRETURE CACHE TABLE ENTRY ---------------------------------------------------------
function iction.createTargetData(guid)
    --- Create the base target info tables if they don't exist
    if iction.targetData[guid] then return end
    iction.targetData[guid] = {}
    iction.targetData[guid]['guid'] = guid
    iction.targetData[guid]['dead'] = false
    iction.targetData[guid]['spellData'] = {}
end

function iction.createTargetSpellData(guid, spellType, spellID)
    --- Create the base target spell cached timer tables for the spell cast on target if they don't exist in the guid table
    if iction.spellIDActive(guid, spellID) then return end
    local name, _, _, _, _, _, _ = GetSpellInfo(spellID)
    iction.targetData[guid]['spellData'][spellID] = {}
    iction.targetData[guid]['spellData'][spellID]['spellType'] = spellType
    iction.targetData[guid]['spellData'][spellID]['spellName'] = name
    iction.targetData[guid]['spellData'][spellID]['endTime'] = nil
    iction.targetData[guid]['spellData'][spellID]['coolDown'] = nil
    iction.targetData[guid]['spellData'][spellID]['count'] = 0
    iction.targetData[guid]['spellData'][spellID]['isChanneled'] = false
    iction.targetData[guid]['spellData'][spellID]['id'] = spellID
    local channelSpellID, cexpires, name = iction.getChannelSpell()
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
        local channelSpellID, cexpires = iction.getChannelSpell()
        if cexpires ~= nil then
            iction.targetData[guid]['spellData'][channelSpellID]['endTime'] = cexpires
            iction.targetData[guid]['spellData'][channelSpellID]['isChanneled'] = true
        else
            -- Adding this as a clean run through due to casting drain soul which seeding which will ignite into corruptions.
            local _, _, _, count, _, _, expires, _, _, _, _, _, _, _, _, _, _, _, _ = UnitDebuff("Target", spellID, nil, "PLAYER")
            iction.targetData[guid]['spellData'][spellID]['endTime'] = expires
            iction.targetData[guid]['spellData'][spellID]['count'] = count
        end
    end
end

function iction.createButtons(frm, guid)
    --- If we've created a new frame add the buttons
    iction.targetButtons[guid] = {}
    local padX, padY
    local b, fnt
    padX = 0
    padY = iction.ictionButtonFramePad
    --- Force check for debufFrame
    if frm:GetAttribute("name") == 'ictionDeBuffFrame' then
        local spells = iction.getAllSpells()
        for _, spellData in pairs(spells[1]['spells']) do
            local butFrame = iction.UIButtonElement
            b, fnt = butFrame.create(butFrame, frm, spellData, "BOTTOM", padX, padY)
            padY = padY + iction.bh + iction.ictionButtonFramePad
        end
    end
    iction.targetButtons[guid]["buttonFrames"] = b
    iction.targetButtons[guid]["buttonText"] = fnt
end