-- TO DO
-- Add unending resolve
-- Fix cooldown for felflame
-- Sniff down issue with siphon life on affliction that sees it not refreshing sometimes
-- Fix clash with Followers immolate when using Rityssn as a follower (timers see his debuff as player owned)
-- Fix bug where directly after reload in destruction the first target doesn't appear correctly at all!

--- version alpha0.0.2
local iction = iction
----------------------------------------------------------------------------------------------
--- CREATE GLOBAL MAIN FRAME ---
--- note: IctionMainWindow is now a global accessor to this frame
iction.ictionMF = CreateFrame("Frame", "IctionMainWindow", UIParent)
iction.ictionMF:SetPoint("CENTER", 0, 0);
--- Settings for mainFrame ---
iction.ictionMF:SetMovable(true)
iction.ictionMF:EnableMouse(false)
iction.ictionMF:SetUserPlaced(true)
iction.ictionMF:SetClampedToScreen(true)
iction.ictionMF:SetFrameStrata("LOW")
iction.ictionMF:SetWidth(iction.ictionMFW)
iction.ictionMF:SetHeight(iction.ictionMFH)
local bgF = iction.ictionMF:CreateTexture(nil, "ARTWORK")
      bgF:SetAllPoints(true)
      bgF:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
      bgF:SetVertexColor(.5, .5, .5, 0)
iction.ictionMF.texture = bgF

----------------------------------------------------------------------------------------------
--- CAST BAR ---
-- Player cast bar location if this was to be released this would need a clean way to move
-- it and set position
function iction.setcastbar()
    if iction.setCastBar then
        CastingBarFrame:ClearAllPoints()
        CastingBarFrame:SetPoint("CENTER",UIParent,"CENTER", iction.cbX, iction.cbY)
        CastingBarFrame.SetPoint = function() end
        CastingBarFrame:SetScale(iction.cbScale)
    end
end

----------------------------------------------------------------------------------------------
--- CREATE THE ADDON MAIN FRAME / REGISTER ADDON ---
local sframe = CreateFrame("Frame", 'ictionRoot')
--- Triggers attached to dummy frame for intial load of addon
sframe:RegisterEvent("PLAYER_LOGIN")
sframe:RegisterEvent("ADDON_LOADED")
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
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionInfo]Loaded Iction UI. Use /iction unlock to move ui elements ", 15, 25, 35);
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionInfo]Valid iction args: /iction unlock /iction lock  /iction max #[1-4] ", 15, 25, 35);
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    end
    if( event == "ADDON_LOADED" ) and arg1 == "iction" then
        if ictionFramePos == nil then
            ictionFramePos = {}
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionMSG]First time load detected setting default frame positions...", 65, 35, 35);
        end
        if not ictionTargetCount then
            iction.ict_maxTargets = 2
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionMSG]First time load detected setting tgt count to 2...", 65, 35, 35);
        else
            iction.ict_maxTargets = ictionTargetCount
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionMSG]Set max count to ".. iction.ict_maxTargets, 100, 35, 35);
        end
        if ictionSetCastBar == nil then
            iction.setCastBar = false
        else
            iction.setCastBar = ictionSetCastBar
            if iction_cbx ~= nil then iction.cbX = iction_cbx end
            if iction_cby ~= nil then iction.cbY = iction_cby end
        end
    end
end)

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
    --- Setup the event watcher ---
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
    --- Column anchor for Cooldowns ---
    iction.colAnchor = CreateFrame("Frame", "iction_CoolDown", iction.ictionMF)
    iction.colAnchor:SetFrameStrata("MEDIUM")
    local anch = iction.colAnchor:CreateTexture(nil, "ARTWORK")
          anch:SetAllPoints(true)
          anch:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
          anch:SetVertexColor(.5, 1, .5, 0)
    iction.colAnchor.texture = anch
    iction.colAnchor:SetPoint("BOTTOM", iction.ictionMF, -2, 0)
    iction.colAnchor:SetWidth(120)
    iction.colAnchor:SetHeight(iction.bh)
    iction.ictionMF:SetScale(iction.ictionScale)
end

----------------------------------------------------------------------------------------------
--- UI STUFF ---------------------------------------------------------------------------------
function iction.createBottomBarArtwork()
    local barStrata = "BACKGROUND"
    local barTexLvL = "ARTWORK"
    local botbar01 = {bg1 = {name = "iction_bg1", w=64, h=64,
                             strata = barStrata, textureLevel = barTexLvL, parent = iction.ictionMF,
                             centerOffsetX = -96, centerOffsetY = 0, bottomOffsetX = 0, bottomOffsetY = 2,
                             texture = "Interface/AddOns/iction/media/bg/bg1"},
                      bg2 = {name = "iction_bg2", w=64, h=64,
                             strata = barStrata, textureLevel = barTexLvL, parent = iction.ictionMF,
                             centerOffsetX = -32, centerOffsetY = 0, bottomOffsetX = 0, bottomOffsetY = 2,
                             texture = "Interface/AddOns/iction/media/bg/bg2"},
                      bg3 = {name = "iction_bg3", w=64, h=64,
                             strata = barStrata, textureLevel = barTexLvL, parent = iction.ictionMF,
                             centerOffsetX = 32, centerOffsetY = 0, bottomOffsetX = 0, bottomOffsetY = 2,
                             texture = "Interface/AddOns/iction/media/bg/bg3"},
                      bg4 = {name = "iction_bg4", w=64, h=64,
                             strata = barStrata, textureLevel = barTexLvL, parent = iction.ictionMF,
                             centerOffsetX = 96, centerOffsetY = 0, bottomOffsetX = 0, bottomOffsetY = 2,
                             texture = "Interface/AddOns/iction/media/bg/bg4"}}
    local botframe
    for barName, barData in pairs(botbar01) do
        botframe =  CreateFrame("Frame", barData['name'], barData['parent'])
        botframe:SetFrameStrata(barData['strata'])
        botframe:SetWidth(barData['w'])
        botframe:SetHeight(barData['h'])
        local ftx = botframe:CreateTexture(nil, barData['textureLevel'])
              ftx:SetAllPoints(true)
              ftx:SetTexture(barData['texture'])
              ftx:SetVertexColor(1, 1, 1, 1)
        botframe.texture = ftx
        botframe:SetPoint("CENTER", barData['parent'], barData['centerOffsetX'], barData['centerOffsetY'])
        botframe:SetPoint("BOTTOM", barData['parent'], barData['bottomOffsetX'], barData['bottomOffsetY'])
        --- FRAMES MOUSE CLICK AND DRAG ---
        botframe:SetScript("OnMouseDown", function(self, button)
          if button == "LeftButton" and not iction.ictionMF.isMoving then
           iction.ictionMF:StartMoving();
           iction.ictionMF.isMoving = true;
          end
        end)
        botframe:SetScript("OnMouseUp", function(self, button)
          if button == "LeftButton" and iction.ictionMF.isMoving then
           iction.ictionMF:StopMovingOrSizing();
           iction.ictionMF.isMoving = false;
          end
        end)
        table.insert(iction.uiBotBarArt, ftx)
    end

end

function iction.createBuffFrame()
    iction.buffFrame = CreateFrame("Frame", "iction_buffFrame", iction.ictionMF)
    iction.buffFrame:SetFrameStrata("BACKGROUND")
    iction.buffFrame:EnableMouse(false)
    iction.buffFrame:SetWidth(128)
    iction.buffFrame:SetHeight(32)
    iction.buffFrame:SetBackdropColor(0,1,0,0);
    iction.buffFrame:SetPoint("BOTTOM", iction.ictionMF, -2, 5)
    iction.buffFrame:CreateTexture("ictionMFBackground", "ARTWORK")
    iction.buffFrame:CreateTexture("ictionMFBorder", "BACKGROUND")
end

function iction.createDebuffColumns()
    iction.debuffColumns = {}
    x = -(iction.bw*2 + iction.ictionMFW)
    y = -(iction.ictionMFH/2)
    for i = 1, 4 do
        local frameName = "iction_col_".. i
        local dFrame = CreateFrame("Frame", frameName, iction.ictionMF)
              dFrame:SetAttribute('name', frameName)
              if ictionFramePos[frameName] == nil then
                  dFrame:ClearAllPoints()
                  if i == 3 then x = x + iction.ictionMFW+50 end
                  dFrame:SetPoint("CENTER", iction.ictionMF, "CENTER", x, y)
                  ictionFramePos[frameName] = {x = x, y = y }
                  x = x + 75
              else
                  dFrame:SetDontSavePosition()
                  dFrame:ClearAllPoints()
                  dFrame:SetPoint("CENTER", iction.ictionMF, ictionFramePos[frameName]['x'], ictionFramePos[frameName]['y'])
              end
              dFrame:SetMovable(true)
              dFrame:EnableMouse(false)
              dFrame:SetClampedToScreen(true)
              dFrame:SetFrameStrata("BACKGROUND")
              dFrame:SetWidth(iction.bw+5)
              dFrame:SetHeight(iction.bh+5)
        local bg = dFrame:CreateTexture("iction_col" .. i .. '_bg', "ARTWORK")
              bg:SetAllPoints(true)
              bg:SetTexture("Interface/AddOns/iction/media/"..i)
              bg:SetVertexColor(1, 1, 1, 0)
        dFrame.texture = bg
        table.insert(iction.debuffColumns, dFrame)
    end
end

function iction.createShardFrame()
    iction.soulShards = {}
    iction.shardFrame = CreateFrame("Frame", "iction_shardFrame", iction.ictionMF)
    iction.shardFrame:SetFrameStrata("MEDIUM")
    iction.shardFrame:EnableMouse(false)
    iction.shardFrame:SetWidth(128)
    iction.shardFrame:SetHeight(32)
    iction.shardFrame:SetBackdropColor(1,1,1,1);
    iction.shardFrame:SetPoint("BOTTOM", iction.ictionMF, 0, 50)
    iction.shardFrame:SetPoint("CENTER", iction.ictionMF, 0, 0)
    local shards = {shd1 = {name = "shard-01", w = 32, h = 22, strata = "ARTWORK", parent = iction.shardFrame,
                            leftOffsetX = 5, leftOffsetY = 0, icon = "Interface/AddOns/iction/media/icons/soulShard"},
                    shd2 = {name = "shard-02", w = 32, h = 28, strata = "ARTWORK", parent = iction.shardFrame,
                            leftOffsetX = 28, leftOffsetY = 3, icon = "Interface/AddOns/iction/media/icons/soulShard" },
                    shd3 = {name = "shard-03", w = 32, h = 32, strata = "ARTWORK", parent = iction.shardFrame,
                            leftOffsetX = 51, leftOffsetY = 5, icon = "Interface/AddOns/iction/media/icons/soulShard"},
                    shd4 = {name = "shard-04", w = 32, h = 36, strata = "ARTWORK", parent = iction.shardFrame,
                            leftOffsetX = 74, leftOffsetY = 7, icon = "Interface/AddOns/iction/media/icons/soulShard"},
                    shd5 = {name = "shard-05", w = 32, h = 42, strata = "ARTWORK", parent = iction.shardFrame,
                            leftOffsetX = 95, leftOffsetY = 9, icon = "Interface/AddOns/iction/media/icons/soulShard"},
                    }
    for x = 1, 5 do
        local shardData = shards["shd" .. x]
        local shrd = iction.shardFrame:CreateTexture(shardData['name'], shardData['strata'])
              shrd:SetPoint("LEFT", shardData['leftOffsetX'], shardData['leftOffsetY'])
              shrd:SetWidth(shardData["w"])
              shrd:SetHeight(shardData["h"])
              shrd:SetTexture(shardData["icon"])
              shrd:SetVertexColor(1, 1, 1, 1)
        iction.shardFrame.texture = shrd
        table.insert(iction.soulShards, shrd)
    end
end

function iction.createConflagFrame()
    iction.conflags = {}
    iction.conflagFrame = CreateFrame("Frame", "iction_conflagFrame", iction.ictionMF)
    iction.conflagFrame:SetFrameStrata("MEDIUM")
    iction.conflagFrame:EnableMouse(false)
    iction.conflagFrame:SetWidth(128)
    iction.conflagFrame:SetHeight(32)
    iction.conflagFrame:SetBackdropColor(1,1,1,1);
    iction.conflagFrame:SetPoint("BOTTOM", iction.ictionMF, 0, 80)
    iction.conflagFrame:SetPoint("CENTER", iction.ictionMF, 0, 0)
    local conf01 = iction.conflagFrame:CreateTexture("conflag-01", "ARTWORK")
          conf01:SetPoint("LEFT", 15, 0)
          conf01:SetWidth(15)
          conf01:SetHeight(15)
          conf01:SetTexture("Interface/AddOns/iction/media/icons/conflag")
          conf01:SetVertexColor(1, 1, 1, 1)
    local conf02 = iction.conflagFrame:CreateTexture("conflag-02", "ARTWORK")
          conf02:SetPoint("LEFT", 35, 0)
          conf02:SetWidth(15)
          conf02:SetHeight(15)
          conf02:SetTexture("Interface/AddOns/iction/media/icons/conflag")
          conf02:SetVertexColor(1, 1, 1, 1)

    iction.conflagFrame.texture = conf01
    iction.conflagFrame.texture = conf02
    table.insert(iction.conflags, conf01)
    table.insert(iction.conflags, conf02)
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
    iction.ictionMF:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    iction.ictionMF:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
    iction.ictionMF:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
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
    else
        iction.ictionMF.texture:SetVertexColor(.1, .1, .1, 0)
    end
    for f in list_iter(cols) do
        iction.setMovable(f, isMovable)
    end
end

function iction.setMovable(f, isMovable)
    local frameName = f:GetAttribute("name")
    if isMovable then
        f:SetParent(iction.ictionMF)
        f.texture:SetVertexColor(.1, 1, .1, .7)
        f:EnableMouse(true)
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
           ictionFramePos[frameName]['x'] = xOffset-MFxOffset
           ictionFramePos[frameName]['y'] = yOffset-MFyOffset
           f:SetPoint("CENTER", iction.ictionMF, ictionFramePos[frameName]['x'], ictionFramePos[frameName]['y'])
          end
        end)
    else
        f:EnableMouse(false)
        f:SetScript("OnMouseDown", nil)
        f:SetScript("OnMouseUp", nil)
        f.texture:SetVertexColor(1, 1, 1, 0)
    end
end

function iction.setOptionsFrame()
    if not iction.OptionsFrame then
        iction.OptionsFrame = CreateFrame('Frame', 'ictionOptions', UIParent)
        iction.OptionsFrame:SetPoint("CENTER", UIParent, 0, 0 )
        iction.OptionsFrame:SetFrameStrata("BACKGROUND")
        iction.OptionsFrame:EnableMouse(true)
        iction.OptionsFrame:SetMovable(true)
        iction.OptionsFrame:SetUserPlaced(true)
        iction.OptionsFrame:SetWidth(300)
        iction.OptionsFrame:SetHeight(150)
        iction.OptionsFrame:SetBackdropColor(0,1,0, 1)
        local OptionsBgT = iction.OptionsFrame:CreateTexture(nil, "ARTWORK")
              OptionsBgT:SetAllPoints(true)
              OptionsBgT:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
              OptionsBgT:SetVertexColor(.5, .5, .5, .3)
        iction.OptionsFrame.texture = OptionsBgT

        --- FRAMES MOUSE CLICK AND DRAG ---
        iction.OptionsFrame:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" and not iction.OptionsFrame.isMoving then
                iction.OptionsFrame:StartMoving()
                iction.OptionsFrame.isMoving = true
            end
        end)
        iction.OptionsFrame:SetScript("OnMouseUp", function(self, button)
            if button == "LeftButton" and iction.OptionsFrame.isMoving then
                iction.OptionsFrame:StopMovingOrSizing()
                iction.OptionsFrame.isMoving = false
            end
        end)
        ---------------------
        --- Move CastBar ----
        ict_moveCastBarButton = CreateFrame("CheckButton", "ict_moveCastBarButton", iction.OptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_moveCastBarButton.tooltip = "Set place your bliz cast bar in a custom location or not."
        icttext = _G["ict_moveCastBarButtonText"]
        if ictionSetCastBar then ict_moveCastBarButton:SetChecked(true) end
        ict_moveCastBarButton:SetPoint("LEFT", iction.OptionsFrame, 0, 0)
        ict_moveCastBarButton:SetPoint("TOP", iction.OptionsFrame, 0, -20)
        icttext:SetText("Set custom cast bar location")
        ict_moveCastBarButton:SetScript("OnClick", function()
                                if ict_moveCastBarButton:GetChecked() then
                                    PlaySound("igMainMenuOptionCheckBoxOn")
                                    ictionSetCastBar = true
                                    CastingBarFrame:EnableMouse(true)
                                    CastingBarFrame:SetMovable(true)
                                    CastingBarFrame:SetAlpha(1)
                                    --- FRAMES MOUSE CLICK AND DRAG ---
                                    CastingBarFrame:SetScript("OnMouseDown", function(self, button)
                                                if button == "LeftButton" and not CastingBarFrame.isMoving then
                                                    CastingBarFrame:StartMoving();
                                                    CastingBarFrame.isMoving = true;
                                                end
                                            end)
                                    CastingBarFrame:SetScript("OnMouseUp", function(self, button)
                                                if button == "LeftButton" and CastingBarFrame.isMoving then
                                                    CastingBarFrame:StopMovingOrSizing()
                                                    CastingBarFrame.isMoving = false
                                                    local point, relativeTo, relativePoint, xOffset, yOffset = CastingBarFrame:GetPoint(1)
                                                    iction_cbx = xOffset
                                                    iction_cby = yOffset
                                                end
                                            end)
                                    CastingBarFrame:Show()
                                else
                                    CastingBarFrame:Hide()
                                    ictionSetCastBar = false
                                    PlaySound("igMainMenuOptionCheckBoxOff")
                                end
                            end)

        ---------------------
        --- Close button ----
        local closeOptionsButton = CreateFrame("Button", "Close", iction.OptionsFrame)
        closeOptionsButton:SetFrameStrata("HIGH")
        closeOptionsButton:SetPoint("TOPRIGHT", iction.OptionsFrame, -5, -5 )
        closeOptionsButton:SetWidth(45)
        closeOptionsButton:SetHeight(25)
        --- Create the texture for the close button
        local closeButText = closeOptionsButton:CreateTexture(nil, "ARTWORK")
              closeButText:SetAllPoints(true)
              closeButText:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
              closeButText:SetVertexColor(0.9,0.3,0.3, 1)
        closeOptionsButton:Show()
        --- Create the fontString for the close button
        local fnt = closeOptionsButton:CreateFontString(nil, "OVERLAY", "GameFontWhite")
              fnt:SetFont(iction.font, 12, "OVERLAY", "THICKOUTLINE")
              fnt:SetPoint("CENTER", closeOptionsButton, 0, 0)
              fnt:SetText("Close")
        closeOptionsButton.text = fnt
        closeOptionsButton:SetScript("OnClick", function()
            iction.OptionsFrame:Hide()
            CastingBarFrame:SetAlpha(0)
            CastingBarFrame:Hide()
            ict_moveCastBarButton = nil
        end)

        iction.OptionsFrame:Show()
    else
        iction.OptionsFrame:Show()
    end

    --- Now do the global options default setups
    if ictionSetCastBar then
        CastingBarFrame:SetAlpha(1)
        CastingBarFrame:Show()
    end

end

function list_iter (t)
  local i = 0
  local n = table.getn(t)
  return function ()
           i = i + 1
           if i <= n then return t[i] end
         end
end