-- Changelog Release 1.1.2
-- added conflag as a button for cleaner opening handling
-- changed ictions spelling handling to be more spellID orientated for future dev
-- Spells are now ordered
-- Added fear to generic spell list

--to do
-- SORT OUT THE NEW UA SHIT

--- version Release 1.1.2
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
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionInfo] Targets: " .. tostring(ictionTargetCount), 15, 25, 35);
            local bf
            if ictionBuffBarBarH then bf = 'Horizontal' else bf = 'Vertical' end
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionInfo] BuffFrame: " .. bf, 15, 25, 35);
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
    iction.spec = GetSpecialization()
    local mainFrame = iction.UIElement
    iction.ictionMF = mainFrame.create(mainFrame, iction.ictMainFrameData)
    iction.ictionFrameWatcher(iction.ictionMF)
    iction.ictionMF:SetScale(iction.ictionScale)
    --- Now fire off all the other build functions ---
    iction.createBottomBarArtwork()
    iction.setMTapBorder()
    iction.createShardFrame()

    if iction.debug then print('Shard frame created') end
    if iction.spec == 3 then iction.createConflagFrame() end

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
    -- clear previous
    if iction.uiBotBarArt then
        for i = 1, iction.tablelength(iction.uiBotBarArt) do
            if iction.uiBotBarArt[i] ~= nil then
                iction.uiBotBarArt[i]:Hide()
            end
        end
    end
    iction.uiBotBarArt = {}

    local skin = iction.skinData[iction.skin]
    for x = 1, iction.tablelength(skin) do
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
    if iction.buffFrame == nil then
        local fw, fh
        if ictionBuffBarBarH == true then
            _, fw = iction.calcFrameSize(iction.uiPlayerBuffButtons)
            fh = iction.bh+5
        else
            fw, fh = iction.calcFrameSize(iction.uiPlayerBuffButtons)
        end
        local buffData = iction.ictBuffFrameData
        buffData['uiParentFrame'] = iction.ictionMF
        buffData['point']['p'] = iction.ictionMF
        buffData['w'] = fw
        buffData['h'] = fh
        local buffFrame = iction.UIElement
        iction.buffFrame = buffFrame.create(buffFrame, buffData)
    else
        return iction.buffFrame
    end
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
    if iction.artifactFrame~= nil then
        iction.artifactFrame:Hide()
        iction.artifactFrame = nil
    end

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

function iction.unlockUIElements(isMovable)
    local cols = iction.debuffColumns
    if isMovable then
        -- override colors for special frames
        iction.ictionMF.texture:SetVertexColor(.5, .1, .1, .3)
        -- set movable
        iction.setMovable(iction.artifactFrame, isMovable, false)
        iction.setMovable(iction.buffFrame, isMovable, false)
        iction.setMovable(iction.shardFrame, isMovable, false)
        if iction.conflagFrame ~= nil then iction.setMovable(iction.conflagFrame, isMovable, false) end
    else
        -- override colors for special frames
        iction.ictionMF.texture:SetVertexColor(.1, .1, .1, 0)
        -- set movable
        iction.setMovable(iction.artifactFrame, isMovable, false)
        iction.setMovable(iction.buffFrame, isMovable, true)
        iction.setMovable(iction.shardFrame, isMovable, true)
        if iction.conflagFrame ~= nil then iction.setMovable(iction.conflagFrame, isMovable, true) end
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
        ---Name font string ---
        if frameName ~= "Artifact" then
            local fntStr = f:CreateFontString(nil, "OVERLAY","GameFontGreen")
                -- Create the fontString for the button
                  fntStr:SetFont(iction.font, 14, "OVERLAY", "THICKOUTLINE")
                  fntStr:SetPoint("CENTER", f, 0, 0)
                  fntStr:SetTextColor(.1, 1, .1, 1)
                  fntStr:SetText(string.gsub(frameName, "iction_", ""))
                f.text = fntStr
        end
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
        f.text:SetText("")
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
