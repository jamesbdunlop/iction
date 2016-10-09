-- IN PROGRESS
-- Cleanup - base frame class for all frames to inherit

-- TO DO
-- Make it so when felflame is on cooldown the button is red
-- When locking the ui again the atrifact frame needs to restore it's color correctly
-- handle absolute corruption id change 146739
-- handle drainsoul talent switching to drain life 196098
-- Look for any other talent stuff that might need to be tracked
-- Make it so the buff bar can be horizontal as well as vertical
-- Sniff out that emtpy button table issue coming from the watcher changes
-- Add buff to destro for damage reduction procs
-- add hover info to buttons
-- add Agony charge counter 1 2 3 - 20
-- Add demo buttons?? boo hiss

--- version alpha0.0.3
local iction = iction
local sframe = CreateFrame("Frame", 'ictionRoot')
--- Triggers attached to dummy frame for intial load of addon
sframe:RegisterEvent("PLAYER_LOGIN")
sframe:SetScript("OnEvent", function(self, event, arg1)
    if( event == "PLAYER_LOGIN" ) then
        local localizedClass, _, _ = UnitClass("Player");
        iction.playerGUID = UnitGUID("Player")
        if localizedClass == 'Warlock' then
            iction.setDebuffButtonLib()
            iction.setBuffButtonLib()
            iction.setMaxTargetTable()
            iction.initMainUI()
            iction.highlightFrameTexture = iction.createHighlightFrame()
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionInfo] Loaded Iction UI. Use /iction options for option ui ", 15, 25, 35);
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionInfo] args: /iction unlock /iction lock  /iction max 1, 2, 3 or 4 ", 15, 25, 35);
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

----------------------------------------------------------------------------------------------
--- CAST BAR ---
function iction.setcastbar()
    if iction.setCastBar then
        CastingBarFrame:ClearAllPoints()
        CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", iction.cbX, iction.cbY)
        CastingBarFrame.SetPoint = function() end
        CastingBarFrame:SetScale(iction.cbScale)
    end
end

----------------------------------------------------------------------------------------------
--- REGISTER THE SLASH COMMAND ---
SLASH_ICTION1  = "/iction"
local function ictionArgs(arg, editbox)
    local split = split
    if not arg then iction.initMainUI()
    elseif arg == 'unlock' then
        DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44Unlocking iction ui elements.", 100, 35, 35);
        iction.unlockUIElements(true)
    elseif arg == 'lock' then
        DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44Locked iction ui elements.", 100, 35, 35);
        iction.unlockUIElements(false)
    elseif arg == 'options' then iction.setOptionsFrame()
    else
        local max, cnt =  strsplit(" ", arg)
        if max == 'max' then
            local count = tonumber(cnt)
            if count > 0 and count < 5 then
                ictionTargetCount = count
                ReloadUI()
            else
                DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44Max count too high. Use 1 2 3 or 4", 100, 35, 35);
            end
        end
    end
end
SlashCmdList["ICTION"] = ictionArgs

----------------------------------------------------------------------------------------------
--- BEGIN UI NOW ---
function iction.initMainUI()
    --- Setup the mainFrame and Eventwatcher ---
    local mainFrame = iction.UIElement
    iction.ictionMF = mainFrame.create(mainFrame, iction.ictMainFrameData)
    iction.ictionFrameWatcher(iction.ictionMF)
    --- Now fire off all the other build functions ---
    iction.createBottomBarArtwork()
    iction.setMTapBorder()
    iction.createShardFrame()
    iction.createConflagFrame()
    iction.createArtifactFrame()
    iction.createBuffFrame()
    iction.createDebuffColumns()
    iction.setcastbar()
end

----------------------------------------------------------------------------------------------
--- UI STUFF ---------------------------------------------------------------------------------
function iction.createBottomBarArtwork()
    local skin = iction.skinData[iction.skin]
    for x = 1, 4 do
        local barData = skin[x]
        barData["uiParentFrame"] = iction.ictionMF
        barData["point"]['p'] = iction.ictionMF
        iction.skinFrameBldr = iction.UIElement
        iction.skinFrame = iction.skinFrameBldr.create(iction.skinFrameBldr, barData)
        iction.skinFrameBldr.setMoveScript(iction.skinFrame, iction.ictionMF, UIParent)
    end
end

function iction.createBuffFrame()
    iction.ictBuffFrameData['uiParentFrame'] = iction.ictionMF
    iction.ictBuffFrameData['point']['p'] = iction.ictionMF
    local buffFrame = iction.UIElement
    iction.buffFrame = buffFrame.create(buffFrame, iction.ictBuffFrameData)
end

function iction.createDebuffColumns()
    iction.debuffColumns = {}
    local x, y
    x = -(iction.bw*2 + iction.ictionMFW)
    y = -(iction.ictionMFH/2)
    for i = 1, 4 do
        if i == 3 then x = x + iction.ictionMFW+50 end
        local colData = iction.ictDeBuffColumnData
        colData["uiName"] = "iction_col_".. i
        colData["uiParentFrame"] = iction.ictionMF
        colData["nameAttr"] = "iction_col_".. i
        colData["point"]["pos"] = "CENTER"
        colData["point"]["p"] = iction.ictionMF
        colData["point"]["x"] = x
        colData["point"]["y"] = y
        local debuffColumn = iction.UIElement
        local deBfCol = debuffColumn.create(debuffColumn, colData)
        debuffColumn.addTexture(deBfCol, "iction_col" .. i .. '_bg', 32, 28, "ARTWORK", true, nil, nil, nil, "Interface/AddOns/iction/media/"..i, .1, .5, .1, 0)
        x = x + 75
        table.insert(iction.debuffColumns, deBfCol)
    end
end

function iction.createShardFrame()
    iction.soulShards = {}
    local shardData = iction.ictShardData
    shardData["uiParentFrame"] = iction.ictionMF
    shardData["point"]["p"] = iction.ictionMF
    iction.shardFrameBldr = iction.UIElement
    iction.shardFrame = iction.shardFrameBldr.create(iction.shardFrameBldr, shardData)
    table.insert(iction.soulShards, iction.shardFrameBldr.addTexture(iction.shardFrame, "shard-01", 32, 22, "ARTWORK", nil, "LEFT", 5, 0, "Interface/AddOns/iction/media/icons/soulShard", 1, 1, 1, 1))
    table.insert(iction.soulShards, iction.shardFrameBldr.addTexture(iction.shardFrame, "shard-02", 32, 28, "ARTWORK", nil, "LEFT", 28, 3, "Interface/AddOns/iction/media/icons/soulShard", 1, 1, 1, 1))
    table.insert(iction.soulShards, iction.shardFrameBldr.addTexture(iction.shardFrame, "shard-03", 32, 32, "ARTWORK", nil, "LEFT", 51, 5, "Interface/AddOns/iction/media/icons/soulShard", 1, 1, 1, 1))
    table.insert(iction.soulShards, iction.shardFrameBldr.addTexture(iction.shardFrame, "shard-04", 32, 36, "ARTWORK", nil, "LEFT", 74, 7, "Interface/AddOns/iction/media/icons/soulShard", 1, 1, 1, 1))
    table.insert(iction.soulShards, iction.shardFrameBldr.addTexture(iction.shardFrame, "shard-05", 32, 42, "ARTWORK", nil, "LEFT", 95, 9, "Interface/AddOns/iction/media/icons/soulShard", 1, 1, 1, 1))
end

function iction.createConflagFrame()
    iction.conflags = {}
    local conflagData = iction.ictConflagData
    conflagData["uiParentFrame"] = iction.ictionMF
    conflagData["point"]["p"] = iction.ictionMF
    iction.conflagFrameBldr = iction.UIElement
    iction.conflagFrame = iction.conflagFrameBldr.create(iction.conflagFrameBldr, conflagData)
    table.insert(iction.conflags, iction.conflagFrameBldr.addTexture(iction.conflagFrame, "conflag-01", 15, 15, "ARTWORK", nil, "LEFT", 15, 0, "Interface/AddOns/iction/media/icons/conflag", 1, 1, 1, 1))
    table.insert(iction.conflags, iction.conflagFrameBldr.addTexture(iction.conflagFrame, "conflag-02", 15, 15, "ARTWORK", nil, "LEFT", 35, 0, "Interface/AddOns/iction/media/icons/conflag", 1, 1, 1, 1))
end

function iction.createArtifactFrame()
    local next = next
    local icon
    local artifact = iction.uiPlayerArtifact
    if next(artifact) ~= nil then
        iction.artifactFrame = CreateFrame("Button", "iction_artifactFrame", iction.ictionMF)
        iction.artifactFrame:SetAttribute('name', 'Artifact')
        iction.artifactFrame:SetFrameStrata("MEDIUM")
        iction.artifactFrame:SetMovable(true)
        iction.artifactFrame:EnableMouse(false)
        iction.artifactFrame:SetWidth(iction.bw)
        iction.artifactFrame:SetHeight(iction.bh)
        iction.artifactFrame:SetBackdropColor(1,1,1,1);
        if ictionFramePos['Artifact'] == nil then
            --iction.artifactFrame:SetPoint("BOTTOM", iction.ictionMF, 0, 20)
            iction.artifactFrame:SetPoint("CENTER", iction.ictionMF, -75, 20)
            ictionFramePos['Artifact'] = {x = -75, y = 20}
        else
            iction.artifactFrame:SetPoint('CENTER', iction.ictionMF, ictionFramePos['Artifact']['x'], ictionFramePos['Artifact']['y'])
        end
        local arti01 = iction.artifactFrame:CreateTexture("artifact-01", "ARTWORK")
              arti01:SetAllPoints(true)
              local file_id = GetSpellTexture(artifact['id'])
              arti01:SetTexture(file_id)--artifact['icon'])
              arti01:SetVertexColor(1, 1, 1, 1)
                -- Create the fontString for the button
        local fnt = iction.artifactFrame:CreateFontString(nil, "OVERLAY")
              fnt:SetFont(iction.font, 28, "OVERLAY", "THICKOUTLINE")
              fnt:SetPoint("CENTER", iction.artifactFrame, 8, -10)
              fnt:SetTextColor(.1, 1, .1, 1)
              fnt:SetFontObject("GameFontWhite")
        iction.artifactFrame.text = fnt
        iction.artifactFrame.texture = arti01
        local function _onUpdate()
            local _, _, _, count, _, _, _, _, _, _, _ = UnitBuff("Player", artifact['name'])
            local charges, _, _, _ = GetSpellCharges(artifact['name'])
            if count == nil and charges == nil then
                iction.setButtonText(0, true, fnt)
            elseif count then
                iction.setButtonText(count, false, fnt)
            else
                if charges then
                    iction.setButtonText(charges, false, fnt)
                end
            end
        end
        iction.artifactFrame:SetScript("OnUpdate", _onUpdate)
    end
end

function iction.createHighlightFrame()
    local fw, fh = iction.calcFrameSize(iction.uiPlayerSpellButtons)
    iction.highlightFrame = CreateFrame("Frame", "iction_highlightFrame", nil)
    iction.highlightFrame:EnableMouse(false)
    iction.highlightFrame:SetWidth(fw)
    iction.highlightFrame:SetHeight(fh)
    iction.highlightFrame:SetFrameStrata("HIGH")
    local bghl = iction.highlightFrame:CreateTexture('ict_highlightTexture', "ARTWORK")
          bghl:SetAllPoints(true)
          bghl:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
          bghl:SetVertexColor(.1, .6, .1, 0)
    iction.highlightFrame.texture = bghl
    iction.highlightFrame:SetPoint("CENTER", 0, 0)
    iction.highlightFrame:Show()
    return bghl
end

function iction.ictionFrameWatcher()
    iction.ictionMF:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    iction.ictionMF:RegisterEvent("PLAYER_TARGET_CHANGED")
    iction.ictionMF:RegisterEvent("PLAYER_REGEN_ENABLED")

    -- ON EVENT CHECKS
    local function eventHandler(self, event, currentTime, eventName, sourceFlags, sourceGUID, sourceName, flags, prefix1, prefix2, prefix3, sufx1,  sufx2,  sufx3,  sufx4,  sufx5,  sufx6,  sufx7, sufx8,  sufx9, ...)
        -- creatureGUID = prefix2, creatureName = prefix3
        -- curSpellName = sufx4, creatureGUID = prefix2, creatureName = prefix3
        --- START DOING COMBAT LOG STUFF NOW
        if event == "COMBAT_LOG_EVENT_UNFILTERED" then
            if eventName == "UNIT_DIED" then
                -- Remove unit from the table if it died.
                iction.tagDeadTarget(prefix2)
                iction.targetData[prefix2] = nil
            end
        end

        if sourceGUID == iction.playerGUID and eventName ~= "SPELL_HEAL" and eventName ~= "SPELL_PERIODIC_DAMAGE" and eventName ~= "SPELL_AURA_REMOVED" and eventName ~= "SPELL_AURA_APPLIED_DOSE" and eventName ~= "SPELL_AURA_REMOVED_DOSE" then
            if event == "COMBAT_LOG_EVENT_UNFILTERED" then
                if sourceGUID == iction.playerGUID then
                    if eventName == "SPELL_CAST_START" or eventName == "SPELL_AURA_APPLIED" or eventName == "SPELL_AURA_REFRESH" then --eventName == "SPELL_CAST_SUCCESS" or
                        -- Add Target
                        if sufx4 == "Unstable Affliction" or sufx4 == "Seed of Corruption" then
                            iction.createTarget(UnitGUID("Target"), prefix3, sufx4, "DEBUFF")
                        elseif sufx4 == 'Agony'  then -- seriously wtf Agony you SUCK
                            iction.createTarget(prefix2, prefix3, sufx4, "DEBUFF")
                        elseif sufx6 == 'DEBUFF' then
                            iction.createTarget(prefix2, prefix3, sufx4, "DEBUFF")
                            iction.highlightTargetSpellframe(prefix2)
                        elseif sufx6 == 'BUFF' then
                            iction.createTarget(prefix2, prefix3, sufx4, sufx6)
                        end
                    elseif eventName == "SPELL_AURA_REMOVED" then
                        -- Set frame accordingly
                        iction.hideFrame(prefix2, false, sufx4, sufx6)
                        iction.setMTapBorder()
                    elseif eventName == "SPELL_CAST_SUCCESS" then
                        if sufx4 == 'Channel Demonfire' then
                            iction.createTarget(UnitGUID("Target"), 'burp', sufx4, "DEBUFF")
                        end
                    end
                end
            end
        end
        if event == "PLAYER_REGEN_ENABLED" then iction.oocCleanup()end
        if event == "PLAYER_TARGET_CHANGED" then iction.highlightTargetSpellframe(UnitGUID("Target")) end
    end
    iction.ictionMF:SetScript("OnEvent", eventHandler)

    -- ON UPDATE CHECKS
    local function _onUpdate()
        local shards = UnitPower("Player", 7)
        local spec = GetSpecialization()
        iction.setSoulShards(shards)
        iction.setConflagCount()
        iction.setMTapBorder()
        iction.currentTargetDebuffExpires()
        iction.updateTimers()
        iction.oocCleanup()
    end
    iction.ictionMF:SetScript("OnUpdate", _onUpdate)
    iction.ictionMF:UnregisterEvent("ADDON_LOADED")
end

function iction.unlockUIElements(isMovable)
    ---Show the full iction frame---
    local cols = iction.debuffColumns
    if isMovable then
        iction.ictionMF.texture:SetVertexColor(.1, .1, .1, .3)
        iction.artifactFrame.texture:SetVertexColor(.1, .1, .1, 0)
        iction.setMovable(iction.artifactFrame, isMovable)
        iction.setMovable(iction.buffFrame, isMovable)
    else
        iction.setMovable(iction.artifactFrame, isMovable)
        iction.setMovable(iction.buffFrame, isMovable)
        iction.ictionMF.texture:SetVertexColor(.1, .1, .1, 0)
        iction.buffFrame.texture:SetVertexColor(.1, .1, .1, 0)
    end
    for f in list_iter(cols) do
        iction.setMovable(f, isMovable)
        if not isMovable then
            f.texture:SetVertexColor(1, 1, 1, 0)
        end
    end
end

function iction.setMovable(f, isMovable)
    local frameName = f:GetAttribute("name")
    if isMovable then
        f:SetParent(iction.ictionMF)
        f.texture:SetVertexColor(.1, 1, .1, .7)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:SetParent(iction.ictionMF)

        ---Scripts for moving---
        f:SetScript("OnMouseDown", function(self, button)
          if button == "LeftButton" and not f.isMoving then
           f:StartMoving();
           f.isMoving = true;
          end
        end)

        f:SetScript("OnMouseUp", function(self, button)
          if button == "LeftButton" and f.isMoving then
           f:StopMovingOrSizing()
           f.isMoving = false
           f:SetParent(iction.ictionMF)
           local point, relativeTo, relativePoint, xOffset, yOffset = f:GetPoint(1)
           local MFpoint, MFrelativeTo, MFrelativePoint, MFxOffset, MFyOffset = iction.ictionMF:GetPoint(1)
           ictionFramePos[frameName]['point']['x'] = xOffset-MFxOffset
           ictionFramePos[frameName]['point']['y'] = yOffset-MFyOffset
           f:SetPoint("CENTER", iction.ictionMF, ictionFramePos[frameName]['point']['x'], ictionFramePos[frameName]['point']['y'])
          end
        end)
    else
        f:EnableMouse(false)
        f:SetMovable(false)
        f:SetScript("OnMouseDown", nil)
        f:SetScript("OnMouseUp", nil)
    end
end

function list_iter(t)
  local i = 0
  local n = table.getn(t)
  return function ()
           i = i + 1
           if i <= n then return t[i] end
         end
end
