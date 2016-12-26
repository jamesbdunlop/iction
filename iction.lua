--- version Release 1.3.2
--- hard return on Zabra Hexx SWD
--- hard check added for warlock and priest

local min,max,abs = min,max,abs
local UIParent,GetScreenWidth,GetScreenHeight,IsAltKeyDown = UIParent,GetScreenWidth,GetScreenHeight,IsAltKeyDown
local iction = iction
local localizedClass, _, _ = UnitClass("Player")

local sframe = CreateFrame("Frame", 'ictionRoot')
--- Triggers attached to dummy frame for intial load of addon
sframe:RegisterEvent("PLAYER_LOGIN")
sframe:SetScript("OnEvent", function(self, event, arg1)
    local function loadUI()
        iction.setDebuffButtonLib()
        iction.setBuffButtonLib()
        iction.setMaxTargetTable()
        iction.initMainUI()
        iction.highlightFrameTexture = iction.createHighlightFrame()
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG1"], 15, 25, 35)
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG2"], 15, 25, 35)
        local bf
        if ictionBuffBarBarH then bf = 'Horizontal' else bf = 'Vertical' end
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG3"] .. bf, 15, 25, 35)
    end
    if (event == "PLAYER_LOGIN") then
        iction.playerGUID = UnitGUID("Player")
        --- Set the spell table
        if localizedClass == iction.L['warlock'] then
            iction.spells = iction.lockspells
            loadUI()
        elseif localizedClass == iction.L['priest'] then
            iction.spec = GetSpecialization()
            if iction.spec == 3 then
                iction.spells = iction.priestspells
                loadUI()
            end
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
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG"], 100, 35, 35);
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["unlock"], 100, 35, 35);
        iction.unlockUIElements(true)
    elseif arg == 'lock' then
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["lock"], 100, 35, 35);
        iction.unlockUIElements(false)
    elseif arg == 'options' then iction.setOptionsFrame()
    elseif arg == 'hide' then iction.ictionMF:Hide()
    elseif arg == 'show' then iction.ictionMF:Show()
    else
        local max, cnt =  strsplit(" ", arg)
        if max == 'max' then
            local count = tonumber(cnt)
            if count > 0 and count < 5 then
                ictionTargetCount = count
                ReloadUI()
            else
                DEFAULT_CHAT_FRAME:AddMessage(iction.L["countError"], 100, 35, 35);
            end
        end
    end
end
SlashCmdList["ICTION"] = ictionArgs

----------------------------------------------------------------------------------------------
--- BEGIN UI NOW ---
function iction.initMainUI()
    if localizedClass == iction.L['warlock'] or localizedClass == iction.L['priest'] then
        if iction.debug then print("initMainUI") end
        --- Setup the mainFrame and Eventwatcher ---
        local mainFrame = iction.UIElement
        iction.ictionMF = mainFrame.create(mainFrame, iction.ictMainFrameData)

        if localizedClass == iction.L['warlock'] then
            iction.ictionLockFrameWatcher(iction.ictionMF)
        elseif localizedClass == iction.L['priest'] then
            iction.ictionPriestFrameWatcher(iction.ictionMF)
        end

        iction.ictionMF:SetScale(iction.ictionScale)
        --- Now fire off all the other build functions ---
        iction.createBottomBarArtwork()
        iction.setMTapBorder()

        if localizedClass == iction.L['warlock'] then
            iction.createShardFrame()
            if iction.spec == 3 then iction.createConflagFrame() end
        elseif localizedClass == iction.L['priest'] then
            if iction.spec == 3 then
                iction.createInsanityFrame()
                iction.createSWDFrame()
                iction.createVoidFrame()
            end
        end
        iction.createArtifactFrame()
        iction.createBuffFrame()
        iction.createDebuffColumns()
        iction.setcastbar()
    end
end

----------------------------------------------------------------------------------------------
--- UI BUILDERS ------------------------------------------------------------------------------
function iction.createBottomBarArtwork()
    if iction.debug then print("createBottomBarArtwork") end
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
    if iction.debug then print("createBuffFrame") end
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
end

function iction.createDebuffColumns()
    if iction.debug then print("createDebuffColumns") end
    iction.debuffColumns = {}
    local x, y
    x = -(iction.bw*2 + iction.ictionMFW)
    y = -(iction.ictionMFH/2)
    for i = 1, 4, 1 do
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
        --table.insert(iction.debuffColumns, deBfCol)
        iction.debuffColumns["col_" ..i] = deBfCol
    end
end

function iction.createShardFrame()
    if iction.debug then print("createShardFrame") end
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
    if iction.debug then print("createConflagFrame") end
    iction.conflags = {}
    local conflagData = iction.ictConflagData
    conflagData["uiParentFrame"] = iction.ictionMF
    conflagData["point"]["p"] = iction.ictionMF
    iction.conflagFrameBldr = iction.UIElement
    iction.conflagFrame = iction.conflagFrameBldr.create(iction.conflagFrameBldr, conflagData)
    table.insert(iction.conflags, iction.conflagFrameBldr.addTexture(iction.conflagFrame, "conflag-01", 15, 15, "ARTWORK", nil, "LEFT", 15, 0, "Interface/AddOns/iction/media/icons/conflag", 1, 1, 1, 0))
    table.insert(iction.conflags, iction.conflagFrameBldr.addTexture(iction.conflagFrame, "conflag-02", 15, 15, "ARTWORK", nil, "LEFT", 35, 0, "Interface/AddOns/iction/media/icons/conflag", 1, 1, 1, 0))
end

function iction.createInsanityFrame()
    if iction.debug then print("createInsanityFrame") end
    local insanityBar = {}
    local insanityData = iction.ictInsanityData
    insanityData["uiParentFrame"] = iction.ictionMF
    insanityData["point"]["p"] = iction.ictionMF
    iction.insanityFrameBldr = iction.UIElement
    iction.insanityFrame = iction.insanityFrameBldr.create(iction.insanityFrameBldr, insanityData)
    iction.insanityFrameBldr.addTexture(iction.insanityFrame, "insanity", 106, iction.bh/1.8, "BACKGROUND", nil, "LEFT", -3, 0, "Interface\\ChatFrame\\ChatFrameBackground", 0, 0, 0, 1)
    table.insert(insanityBar, iction.insanityFrameBldr.addTexture(iction.insanityFrame, "insanity", 1, iction.bh/2, "ARTWORK", nil, "LEFT", 0, 0, "Interface\\ChatFrame\\ChatFrameBackground", .5, .1, 1, 1))
    iction.insanityFrame.text = iction.insanityFrameBldr.addFontSring(iction.insanityFrame, "THICKOUTLINE", "OVERLAY", true, nil, nil, nil, 16, 1, 1, 1, 1)

    local function _updateInsanity()
        local insanity = UnitPower("player", SPELL_POWER_INSANITY)
        if insanity ~= 0 then
            insanityBar[1]:SetWidth(insanity)
            iction.insanityFrame.text:SetText(tostring(insanity))
            insanityBar[1]:SetVertexColor(.5, .1, 1, 1)
        else
            insanityBar[1]:SetVertexColor(0, 0, 0, .1)
            iction.insanityFrame.text:SetText("0")
        end
    end
    iction.insanityFrame:SetScript("OnUpdate", _updateInsanity)

end

function iction.createArtifactFrame()
    if iction.debug then print("createArtifactFrame") end
    if iction.artifactFrame~= nil then
        iction.artifactFrame:Hide()
        iction.artifactFrame = nil
    end
    local fntSize
    if localizedClass == iction.L['warlock'] then
        fntSize = 26
    elseif localizedClass == iction.L['priest'] then
        fntSize = 20
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
        iction.artifactFrame.text = iction.artifactFrameBldr.addFontSring(iction.artifactFrame, "THICKOUTLINE", "OVERLAY", true, nil, nil, nil, fntSize, 1, 1, 1, 1)
        local function _warlockUpdate()
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

        local function _priestUpdate()
            if iction.buffActive(194249) then
                iction.artifactFrame.texture:SetVertexColor(1, 1, 1, 1)
            else
                iction.artifactFrame.texture:SetVertexColor(1, .1, .1, .7)
            end

            --- Update channeled timer for artifact channel
            local channeledSpellID, cexpires = iction.getChannelSpell()
            if channeledSpellID == 205065 then
                local remainingT = cexpires - GetTime()
                local TL = tonumber(string.format("%.1f", (remainingT)))
                if TL > 3 then
                    iction.artifactFrame.text:SetTextColor(1, 1, 1, 1)
                else
                    iction.artifactFrame.text:SetTextColor(1, .1, .1, 1)
                end
                iction.artifactFrame.text:SetText(tostring(TL))

            elseif iction.isSpellOnCooldown(205065) then
                local start, duration, _ = GetSpellCooldown(205065)
                if duration > 1.5 then
                    local cdET = iction.fetchCooldownET(205065)
                    local remainingT = cdET - GetTime()
                    local TL = tonumber(string.format("%.1d", (remainingT)))
                    iction.artifactFrame.texture:SetVertexColor(.55, .1, .1, 1)
                    if TL > 3 then
                        iction.artifactFrame.text:SetTextColor(1, 1, 1, 1)
                    else
                        iction.artifactFrame.text:SetTextColor(1, .1, .1, 1)
                    end
                    iction.artifactFrame.text:SetText(TL)
                end
            else
                iction.artifactFrame.text:SetText("")
            end
            --- Sparkle on insanity
        end

        if localizedClass == iction.L['warlock'] then
            iction.artifactFrame:SetScript("OnUpdate", _warlockUpdate)
        elseif localizedClass == iction.L['priest'] and iction.spec == 3 then
            iction.artifactFrame:SetScript("OnUpdate", _priestUpdate)
        end
    end
end

function iction.createHighlightFrame()
    if iction.debug then print("createHighlightFrame") end
    local fw, fh = iction.calcFrameSize(iction.uiPlayerSpellButtons)
    local highlightData = iction.ictHighLightFrameData
    highlightData["uiParentFrame"] = iction.ictionMF
    highlightData["w"] = fw
    highlightData["h"] = fh
    highlightData["point"]["p"] = iction.ictionMF
    iction.highlightFrameBldr = iction.UIElement
    iction.highlightFrame = iction.highlightFrameBldr.create(iction.highlightFrameBldr, highlightData)
    local bghl = iction.highlightFrameBldr.addTexture(iction.highlightFrame, "ict_highlightTexture", 1, 1, "BACKGROUND", true, nil, nil, nil, "Interface\\ChatFrame\\ChatFrameBackground", .1, .6, .1, 0)
    return bghl
end

function iction.createSWDFrame()
    iction.SWDUIElements = {}
    if iction.debug then print("createSWDFrame") end
    local SWDData = iction.ictSWDData
    SWDData["uiParentFrame"] = iction.ictionMF
    SWDData["point"]["p"] = iction.ictionMF
    iction.SWDFrameBldr = iction.UIElement
    iction.SWDFrame = iction.SWDFrameBldr.create(iction.SWDFrameBldr, SWDData)
    iction.SWDFrame.texture = iction.SWDFrameBldr.addTexture(iction.SWDFrame, "ict_SWDTexture", 15, 15, "BACKGROUND", true, nil, nil, nil, "Interface\\ChatFrame\\ChatFrameBackground", .1, .6, .1, 0)
    --- CREATE SPECIAL BUTTON
    local swd = {}
    local swdID = iction.swdID
    iction.addButtonsToTable(iction.priestspells[3]['swd'], swd)
    iction.SWDButtonFrame, iction.SWDButtonText = iction.buttonBuild(iction.SWDFrame, 'nil', swd, 0, 0, False, 42)
    iction.SWDButtonFrame[swdID]:SetWidth(SWDData["w"])
    iction.SWDButtonFrame[swdID]:SetHeight(SWDData["h"])
    iction.SWDFrame:SetScale(iction.SWDScale)
    table.insert(iction.SWDUIElements, iction.SWDFrame)
    table.insert(iction.SWDUIElements, iction.SWDButtonFrame)
    table.insert(iction.SWDUIElements, iction.SWDButtonText)
end

function iction.createVoidFrame()
    iction.voidBoltUIElements = {}
    if iction.debug then print("createVoidFrame") end
    local VFData = iction.ictVoidData
    VFData["uiParentFrame"] = iction.ictionMF
    VFData["point"]["p"] = iction.ictionMF
    iction.voidFrameBldr = iction.UIElement
    iction.voidFrame = iction.voidFrameBldr.create(iction.voidFrameBldr, VFData)
    iction.voidFrame.texture = iction.voidFrameBldr.addTexture(iction.voidFrame, "ict_voidFrameTexture", 15, 15, "ARTWORK", true, nil, nil, nil, "Interface\\ChatFrame\\ChatFrameBackground", 1, 1, 1, 0)
    --- CREATE SPECIAL BUTTON
    local vblt = {}
    local vbltID = iction.vbID
    iction.addButtonsToTable(iction.priestspells[3]['voidB'], vblt)
    iction.vBoltButtonFrame, iction.vBoltButtonText = iction.buttonBuild(iction.voidFrame, 'nil', vblt, 0, 0, False, 24)
    iction.vBoltButtonFrame[vbltID]:SetWidth(VFData["w"])
    iction.vBoltButtonFrame[vbltID]:SetHeight(VFData["h"])
    iction.SWDFrame:SetScale(iction.VoidboltScale)
    table.insert(iction.voidBoltUIElements, iction.voidFrame)
    table.insert(iction.voidBoltUIElements, iction.vBoltButtonFrame)
    table.insert(iction.voidBoltUIElements, iction.vBoltButtonText)
end

----------------------------------------------------------------------------------------------
--- UI CUSTOMIZE -----------------------------------------------------------------------------
function iction.unlockUIElements(isMovable)
    if iction.debug then print("unlockUIElements") end
    local cols = iction.debuffColumns
    if isMovable then
        -- override colors for special frames
        iction.ictionMF.texture:SetVertexColor(.5, .1, .1, .3)
        -- set movable
        iction.setMovable(iction.artifactFrame, isMovable, false)
        iction.setMovable(iction.buffFrame, isMovable, false)
        if localizedClass == iction.L['warlock'] then
            iction.setMovable(iction.shardFrame, isMovable, false)
            if iction.conflagFrame ~= nil then iction.setMovable(iction.conflagFrame, isMovable, false) end
        elseif localizedClass == iction.L['priest'] then
            if iction.insanityFrame ~= nil then iction.setMovable(iction.insanityFrame, isMovable, false) end
            if iction.SWDFrame ~= nil then iction.setMovable(iction.SWDFrame, isMovable, false) end
            if iction.voidFrame ~= nil then iction.setMovable(iction.voidFrame, isMovable, false) end
        end
    else
        -- override colors for special frames
        iction.ictionMF.texture:SetVertexColor(.1, .1, .1, 0)
        -- set movable
        iction.setMovable(iction.artifactFrame, isMovable, false)
        iction.setMovable(iction.buffFrame, isMovable, true)
        if localizedClass == iction.L['warlock'] then
            iction.setMovable(iction.shardFrame, isMovable, true)
            if iction.conflagFrame ~= nil then iction.setMovable(iction.conflagFrame, isMovable, true) end
        elseif localizedClass == iction.L['priest'] then
            if iction.insanityFrame ~= nil then iction.setMovable(iction.insanityFrame, isMovable, false, {0, 0, 0, 1}) end
            if iction.SWDFrame ~= nil then iction.setMovable(iction.SWDFrame, isMovable, false, {0, 0, 0, 0}) end
            if iction.voidFrame ~= nil then iction.setMovable(iction.voidFrame, isMovable, false, {0, 0, 0, 0}) end
        end
    end
    for id, f in pairs(cols) do
        iction.setMovable(f, isMovable)
        if not isMovable then
            f.texture:SetVertexColor(1, 1, 1, 0)
        end
    end
end

function iction.setMovable(f, isMovable, hideDefault, color)
    if iction.debug then print("setMovable") end
    if f then
        local frameName = f:GetAttribute("name")
        if isMovable then
            f:SetParent(iction.ictionMF)
            f.texture:SetVertexColor(.1, 1, .1, .25)
            insanityMOVEFRAME:SetVertexColor(.1, 1, .1, .25)
            SWDMOVEFRAME:SetVertexColor(.1, 1, .1, .25)
            VOIDMOVEFRAME:SetVertexColor(.1, 1, .1, .25)
            ARTIFACTMOVEFRAME:SetVertexColor(.1, 1, .1, .25)
            f:EnableMouse(true)
            f:SetMovable(true)
            f:SetParent(iction.ictionMF)
            ---Name font string ---
            if frameName ~= "Artifact" then
                if f.text ~= nil then
                    f.text:SetText(string.gsub(frameName, "iction_", ""))
                else
                    local fntStr = f:CreateFontString(nil, "OVERLAY","GameFontGreen")
                        -- Create the fontString for the button
                          fntStr:SetFont(iction.font, 14, "OVERLAY", "THICKOUTLINE")
                          fntStr:SetPoint("CENTER", f, 0, 0)
                          fntStr:SetTextColor(.1, 1, .1, 1)
                          fntStr:SetText(string.gsub(frameName, "iction_", ""))
                        f.text = fntStr
                end
            end
            ---Scripts for moving---
            f:SetScript("OnMouseDown", function(self, button)
                if button == "LeftButton" and not f.isMoving then
                    f:StartMoving()
                    f.isMoving = true
                end
            end)

            f:SetScript("OnMouseUp", function(self, button)
                if button == "LeftButton" and f.isMoving then
                    f:StopMovingOrSizing()
                    f.isMoving = false
                    f:SetParent(iction.ictionMF)
                    local s = f:GetScale()
                    local point, relativeTo, relativePoint, xOffset, yOffset = f:GetPoint(1)
                    local MFpoint, MFrelativeTo, MFrelativePoint, MFxOffset, MFyOffset = iction.ictionMF:GetPoint(1)
                    ictionFramePos[frameName]['point']['x'] = xOffset-(MFxOffset/s)
                    ictionFramePos[frameName]['point']['y'] = yOffset-(MFyOffset/s)
                    ictionFramePos[frameName]['point']['pos'] = point
                    f:ClearAllPoints()
                    f:SetPoint(point, iction.ictionMF, ictionFramePos[frameName]['point']['x'], ictionFramePos[frameName]['point']['y'])
                end
            end)
        else
            f:EnableMouse(false)
            f:SetMovable(false)
            if hideDefault then f.texture:SetVertexColor(0, 0, 0, 0)
            else
                if color == nil then
                    f.texture:SetVertexColor(1, 1, 1, 1)
                else
                    insanityMOVEFRAME:SetVertexColor(.1, 1, .1, 0)
                    SWDMOVEFRAME:SetVertexColor(.1, 1, .1, 0)
                    VOIDMOVEFRAME:SetVertexColor(.1, 1, .1, 0)
                    ARTIFACTMOVEFRAME:SetVertexColor(.1, 1, .1, 0)
                    f.texture:SetVertexColor(color[1], color[2], color[3], color[4])
                end
            end
            f:SetScript("OnMouseDown", nil)
            f:SetScript("OnMouseUp", nil)
            if f.text ~= nil then f.text:SetText("") end
        end
    end
end

function ictionlist_iter(t)
  local i = 0
  local n = table.getn(t)
  return function ()
       i = i + 1
       if i <= n then return t[i] end
     end
end
