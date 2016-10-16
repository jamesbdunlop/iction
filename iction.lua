-- TO DO
-- Make it so when felflame is on cooldown the button is red
-- Add Agony/UA charge counter 1 2 3 - 20 ??
-- Fix burning rush buff timer when turned off. As this remains as INF.
-- Add artifact power checker for Wrath of Consumption buff

-- Changelog beta1.0.2
-- Fixed bug with laggy target highlight frame
-- Fixed bug where local getGUID = UnitGUID("Target") was in the wrong place in the code
-- Fixed issue with seeds not being removed from all active frames with the sow the seed talent if they are showing as active timers
-- Fixed issue with drain life timer not ending correctly when cancelled mid channel
-- Moved the debuffExpires check to target changed not on update
-- Fixed the artwork to change color on backDraft or manaTap active buff
-- Added first pass for seed to be applied to all active frames for Sow The Seeds. This is flakey though, but they should show up on target changes correctly. WIP

--- version beta1.0.2
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
    if iction.debug then print('Shard frame created') end
    iction.createConflagFrame()
    if iction.debug then print('Conflag frame created') end
    iction.createArtifactFrame()
    if iction.debug then print('Artifact frame created') end
    iction.createBuffFrame()
    if iction.debug then print('Buff frame created') end
    iction.createDebuffColumns()
    if iction.debug then print('Debuff Column frames created') end
    iction.setcastbar()
end

----------------------------------------------------------------------------------------------
--- UI STUFF ---------------------------------------------------------------------------------
function iction.createBottomBarArtwork()
    iction.uiBotBarArt = {}
    local skin = iction.skinData[iction.skin]
    for x = 1, 4 do
        local barData = skin[x]
        barData["uiParentFrame"] = iction.ictionMF
        barData["point"]['p'] = iction.ictionMF
        iction.skinFrameBldr = iction.UIElement
        iction.skinFrame = iction.skinFrameBldr.create(iction.skinFrameBldr, barData)
        iction.skinFrameBldr.setMoveScript(iction.skinFrame, iction.ictionMF, UIParent)
        table.insert(iction.uiBotBarArt, iction.skinFrame)
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
        local artifactData = iction.ictArtifactFrameData
        artifactData["uiParentFrame"] = iction.ictionMF
        artifactData["point"]["p"] = iction.ictionMF
        iction.artifactFrameBldr = iction.UIElement
        iction.artifactFrame = iction.artifactFrameBldr.create(iction.artifactFrameBldr, artifactData)
        iction.artifactFrame.texture = iction.artifactFrameBldr.addTexture(iction.artifactFrame, "artifact-01", 15, 15, "ARTWORK", true, nil, nil, nil, GetSpellTexture(artifact['id']), 1, 1, 1, 1)
        iction.artifactFrame.text = iction.artifactFrameBldr.addFontSring(iction.artifactFrame, "THICKOUTLINE", "OVERLAY", true, nil, nil, nil, 28, 1, 1, 1, 1)
        local function _onUpdate()
            local _, _, _, count, _, _, _, _, _, _, _ = UnitBuff("Player", artifact['name'])
            local charges, _, _, _ = GetSpellCharges(artifact['name'])
            if count == nil and charges == nil then
                iction.setButtonText(0, true, iction.artifactFrame.text)
            elseif count then
                iction.setButtonText(count, false, iction.artifactFrame.text)
            else
                if charges then
                    iction.setButtonText(charges, false, iction.artifactFrame.text)
                end
            end
        end
        iction.artifactFrame:SetScript("OnUpdate", _onUpdate)
    end
end

function iction.createHighlightFrame()
    local fw, fh = iction.calcFrameSize(iction.uiPlayerSpellButtons)
    local highlightData = iction.ictHighLightFrameData
    highlightData["uiParentFrame"] = iction.ictionMF
    highlightData["w"] = fw
    highlightData["h"] = fh
    highlightData["point"]["p"] = iction.ictionMF
    iction.highlightFrameBldr = iction.UIElement
    iction.highlightFrame = iction.highlightFrameBldr.create(iction.highlightFrameBldr, highlightData)
    local bghl = iction.highlightFrameBldr.addTexture(iction.highlightFrame, "ict_highlightTexture", 15, 15, "ARTWORK", true, nil, nil, nil, "Interface\\ChatFrame\\ChatFrameBackground", .1, .6, .1, 0)
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
                iction.highlightTargetSpellframe(UnitGUID("Target"))
            end
        end

        if sourceGUID == iction.playerGUID and eventName ~= "SPELL_HEAL" and eventName ~= "SPELL_PERIODIC_DAMAGE" and eventName ~= "SPELL_AURA_REMOVED" and eventName ~= "SPELL_AURA_APPLIED_DOSE" and eventName ~= "SPELL_AURA_REMOVED_DOSE" then
            if event == "COMBAT_LOG_EVENT_UNFILTERED" then
                if sourceGUID == iction.playerGUID then
                    if eventName == "SPELL_CAST_START" or eventName == "SPELL_AURA_APPLIED" or eventName == "SPELL_AURA_REFRESH" then --eventName == "SPELL_CAST_SUCCESS" or
                    validSpell = false
                        for _, v in pairs(iction.uiPlayerSpellButtons) do
                            if v['name'] == sufx4 then
                                validSpell = true
                            end
                        end
                        for _, v in pairs(iction.uiPlayerBuffButtons) do
                            if v['name'] == sufx4 then
                                validSpell = true
                            end
                        end

                        if validSpell then
                            if iction.debug then print("ValidSpell: " .. sufx4) end
                            -- Add Target
                            -- Irregular debuff handling due to crappy changes to prefix data etc based on spells. WHY!?
                            if sufx4 == "Unstable Affliction" or sufx4 == 'Agony' then
                                iction.createTarget(UnitGUID("Target"), prefix3, sufx4, "DEBUFF")
                            elseif sufx4 == 'Seed of Corruption' and eventName == "SPELL_AURA_APPLIED" then
                                iction.addSeeds(prefix2, sufx4, "DEBUFF")
                            -- Regular debuff/buff handling
                            elseif sufx6 == 'DEBUFF' then
                                iction.createTarget(prefix2, prefix3, sufx4, "DEBUFF")
                                iction.highlightTargetSpellframe(prefix2)
                            elseif sufx6 == 'BUFF' then
                                iction.createTarget(prefix2, prefix3, sufx4, sufx6)
                            end
                        end

                    elseif eventName == "SPELL_AURA_REMOVED" then
                        -- Set frame accordingly
                        iction.hideFrame(prefix2, false, sufx4, sufx6)
                        iction.setMTapBorder()

                    elseif eventName == "SPELL_CAST_SUCCESS" then
                        if sufx4 == 'Channel Demonfire' then
                            iction.createTarget(UnitGUID("Target"), 'nil', sufx4, "DEBUFF")

                        end

                    elseif eventName == "SPELL_DAMAGE" and sufx4 == "Seed of Corruption" then
                        iction.clearSeeds(prefix2)
                    end

            end
            end
        end
        if event == "PLAYER_REGEN_ENABLED" then iction.oocCleanup()end
        if event == "PLAYER_TARGET_CHANGED" then iction.highlightTargetSpellframe(UnitGUID("Target")) iction.currentTargetDebuffExpires() end
    end
    iction.ictionMF:SetScript("OnEvent", eventHandler)
    -- ON UPDATE CHECKS
    local function _onUpdate()
        local shards = UnitPower("Player", 7)
        --local spec = GetSpecialization()
        iction.setSoulShards(shards)
        iction.setConflagCount()
        iction.setMTapBorder()
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
        -- override colors for special frames
        iction.ictionMF.texture:SetVertexColor(.5, .1, .1, .3)
        -- set movable
        iction.setMovable(iction.artifactFrame, isMovable, false)
        iction.setMovable(iction.buffFrame, isMovable, false)
        iction.setMovable(iction.shardFrame, isMovable, false)
        if iction.conflagFrame ~= nil then iction.setMovable(iction.conflagFrame, isMovable) end
    else
        -- override colors for special frames
        iction.ictionMF.texture:SetVertexColor(.1, .1, .1, 0)
        -- set movable
        iction.setMovable(iction.artifactFrame, isMovable, false)
        iction.setMovable(iction.buffFrame, isMovable, true)
        iction.setMovable(iction.shardFrame, isMovable, true)
        if iction.conflagFrame ~= nil then iction.setMovable(iction.conflagFrame, isMovable) end
    end
    for f in list_iter(cols) do
        iction.setMovable(f, isMovable)
        if not isMovable then
            f.texture:SetVertexColor(1, 1, 1, 0)
        end
    end
end

function iction.setMovable(f, isMovable, hideDefault)
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
           if iction.debug then print("point: " .. tostring(point)) end
           if iction.debug then print("relativeTo: " .. tostring(relativeTo)) end
           if iction.debug then print("xOffset: " .. tostring(xOffset)) end
           if iction.debug then print("yOffset: " .. tostring(yOffset)) end
           ictionFramePos[frameName]['point']['x'] = xOffset-MFxOffset
           ictionFramePos[frameName]['point']['y'] = yOffset-MFyOffset
           ictionFramePos[frameName]['point']['pos'] = point
           f:SetPoint(point, iction.ictionMF, ictionFramePos[frameName]['point']['x'], ictionFramePos[frameName]['point']['y'])
          end
        end)
    else
        f:EnableMouse(false)
        f:SetMovable(false)
        if hideDefault then f.texture:SetVertexColor(0, 0, 0, 0) else f.texture:SetVertexColor(1, 1, 1, 1) end
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
