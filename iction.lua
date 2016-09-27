local iction = iction
----------------------------------------------------------------------------------------------
--- CREATE GLOBAL MAIN FRAME ---
--- note: IctionMainWindow is now a global accessor to this frame
iction.ictionMF = CreateFrame("Frame", "IctionMainWindow", UIParent)
iction.ictionMF:SetPoint("CENTER", 0, 0);
iction.ictionMF:SetMovable(true)
iction.ictionMF:EnableMouse(false)
iction.ictionMF:SetUserPlaced(true);

--- Player cast bar location if this was to be released this would need a clean way to move it and set position
--print("iction.setCastBar: ".. iction.setCastBar)
--if iction.setCastBar then
--    CastingBarFrame:ClearAllPoints()
--    CastingBarFrame:SetPoint("CENTER",UIParent,"CENTER", iction.cbX, iction.cbY)
--    CastingBarFrame.SetPoint = function() end
--    CastingBarFrame:SetScale(iction.cbScale)
--end
----------------------------------------------------------------------------------------------
--- REGISTER THE ADDON ---
local sframe = CreateFrame("Frame", 'ictionRoot')
--- Triggers for intial load of addon
sframe:RegisterEvent("PLAYER_LOGIN")
sframe:RegisterEvent("ADDON_LOADED")
sframe:SetScript("OnEvent", function(self, event)
    if( event == "PLAYER_LOGIN" ) then
        local localizedClass, _, _ = UnitClass("Player");
        iction.playerGUID = UnitGUID("Player")
        if localizedClass == 'Warlock' then
            iction.setDebuffButtonLib()
            iction.setBuffButtonLib()
            iction.setMaxTargetTable()
            iction.initMainUI()
            iction.highlightFrameTexture = iction.createHighlightFrame()
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44Loaded Iction UI. Use /iction to show the ui ", 15, 25, 35);
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

----------------------------------------------------------------------------------------------
--- REGISTER THE SLASH COMMAND ---
SLASH_ICTION1 = "/iction"
SlashCmdList["ICTION"] = function()
    iction.initMainUI()
end

----------------------------------------------------------------------------------------------
--- BEGIN UI NOW ---
function iction.initMainUI()
    --- Setup the event watcher ---
    iction.ictionFrameWatcher(iction.ictionMF)
    --- Set up the mainFrame now ---
    iction.ictionMF:SetMovable(true)
    iction.ictionMF:EnableMouse(false)
    iction.ictionMF:SetUserPlaced(true);
    iction.ictionMF:SetResizable(true)
    iction.ictionMF:SetClampedToScreen(true)
    iction.ictionMF:SetFrameStrata("LOW")
    iction.ictionMF:SetBackdropColor(0,0,0,.15);
    iction.ictionMF:SetWidth(iction.ictionMFH)
    iction.ictionMF:SetHeight(iction.ictionMFH)

    iction.createBottomBarArtwork()
    iction.setMTapBorder()
    iction.createShardFrame()
    iction.createConflagFrame()
    iction.createArtifactFrame()
    iction.createBuffFrame()

    --- Column anchor for debuffs ---
    iction.colAnchor = CreateFrame("Frame", "iction_colAnchor", iction.ictionMF)
    iction.colAnchor:SetFrameStrata("BACKGROUND")
    local anch = iction.colAnchor:CreateTexture(nil, "MEDIUM")
          anch:SetAllPoints(true)
          anch:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
          anch:SetVertexColor(.5, 1, .5, 0)
    iction.colAnchor.texture = anch
    iction.colAnchor:SetPoint("BOTTOM", iction.ictionMF, 0, iction.ictionSpellAnchorOffset)
    iction.colAnchor:SetWidth(64)
    iction.colAnchor:SetHeight(24)

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
    iction.buffFrame:SetBackdropColor(0,1,0,1);
    iction.buffFrame:SetPoint("BOTTOM", iction.ictionMF, -2, 5)
    iction.buffFrame:CreateTexture("ictionMFBackground", "ARTWORK")
    iction.buffFrame:CreateTexture("ictionMFBorder", "BACKGROUND")
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
        if iction.debug then print("Dbg: iction.createArtifactFrame") end
        if iction.debug then print("\t artifact['name']: " .. artifact['name']) end
        if iction.debug then print("\t artifact['icon']: " .. artifact['icon']) end
        iction.artifacts = {}
        iction.artifactFrame = CreateFrame("Button", "iction_artifactFrame", iction.ictionMF)
        iction.artifactFrame:SetFrameStrata("MEDIUM")
        iction.artifactFrame:EnableMouse(false)
        iction.artifactFrame:SetWidth(iction.bw)
        iction.artifactFrame:SetHeight(iction.bh)
        iction.artifactFrame:SetBackdropColor(1,1,1,1);
        iction.artifactFrame:SetPoint("BOTTOM", iction.ictionMF, 0, 10)
        iction.artifactFrame:SetPoint("CENTER", iction.ictionMF, -75, 0)
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
        table.insert(iction.artifacts, arti01)

        local function _onUpdate()
            local _, _, _, count, _, _, _, _, _, _, _ = UnitBuff("Player", artifact['name'])
            local charges, maxCharges, start, duration = GetSpellCharges(artifact['name'])
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
    --- http://wowprogramming.com/docs/api_types#guid
    --- http://wowwiki.wikia.com/wiki/API_COMBAT_LOG_EVENT
    --- http://www.wowinterface.com/forums/showthread.php?t=15457
    iction.ictionMF:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    iction.ictionMF:RegisterEvent("PLAYER_TARGET_CHANGED")
    iction.ictionMF:RegisterEvent("PLAYER_REGEN_ENABLED")

    -- ON EVENT CHECKS
    local function eventHandler(self, event, currentTime, eventName, sourceFlags, sourceGUID, sourceName, flags, prefix1, prefix2, prefix3, sufx1,  sufx2,  sufx3,  sufx4,  sufx5,  sufx6,  sufx7, sufx8,  sufx9, ...)
        -- creatureGUID = prefix2, creatureName = prefix3
        -- curSpellName = sufx4, creatureGUID = prefix2, creatureName = prefix3
        --- START DOING COMBAT LOG STUFF NOW
        if event == "COMBAT_LOG_EVENT_UNFILTERED" then
            if iction.debug then print("\t eventName: " .. tostring(eventName)) end
            if eventName == "UNIT_DIED" then
                -- Remove unit from the table if it died.
                iction.tagDeadTarget(prefix2)
                iction.targetData[prefix2] = nil
            end
        end
        if sourceGUID == iction.playerGUID then
            --if iction.debug then print("\t eventName: " .. tostring(eventName)) end
            --if iction.debug then print("\t playerGUID: " .. tostring(iction.playerGUID)) end
            --if iction.debug then print("\t sourceGUID: " .. tostring(sourceGUID)) end
            if event == "COMBAT_LOG_EVENT_UNFILTERED" then
                if sourceGUID == iction.playerGUID then
                    if eventName == "SPELL_DAMAGE" then
                        --iction.createTarget(prefix2, prefix3, sufx4, "DEBUFF")
                        -- create a channeled spell bar here for 5 seconds the dur of the spell
                        -- get the button to show the cool down for felfire instead
                    end
                    if eventName == "SPELL_ENERGIZE" or eventName == "SPELL_CAST_SUCCESS" or eventName == "SPELL_CAST_START" or eventName == "SPELL_AURA_APPLIED" or eventName == "SPELL_AURA_REFRESH" or eventName == "SPELL_AURA_DOSE" then
                        -- Add Target
                        --if not iction.colGUIDExists(prefix2) == true then
                        if iction.debug then print("\t CAST INFO: ") end
                        if iction.debug then print("\t prefix2: " .. tostring(prefix2)) end
                        if iction.debug then print("\t prefix3: " .. tostring(prefix3)) end
                        if iction.debug then print("\t sufx4: " .. tostring(sufx4)) end
                        if iction.debug then print("\t sufx6: " .. tostring(sufx6)) end
                        if sufx4 == "Unstable Affliction" then
                            iction.createTarget(UnitGUID("Target"), prefix3, sufx4, "DEBUFF")
                        elseif sufx4 == 'Agony'  then -- seriously wtf Agony you SUCK
                            iction.createTarget(prefix2, prefix3, sufx4, "DEBUFF")
                        elseif sufx6 == 'DEBUFF' then --and sufx4 ~= 'Mana Tap' and sufx4 ~= 'Life Tap' and sufx4 ~= 'Hearthstone'  and sufx4 ~= 'Reap Souls' and not string.find(sufx4, 'Summon') then
                            iction.createTarget(prefix2, prefix3, sufx4, "DEBUFF")
                            iction.highlightTargetSpellframe(prefix2)
                        elseif sufx6 == 'BUFF' then
                            iction.createTarget(prefix2, prefix3, sufx4, sufx6)
                        end
                        --end
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