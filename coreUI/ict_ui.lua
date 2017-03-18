local iction = iction
----------------------------------------------------------------------------------------------
--- UI BUILDERS ------------------------------------------------------------------------------
function iction.createBottomBarArtwork()
    if iction.debugUI then print("iction.createBottomBarArtwork init...") end
    -- Clear previous out
    if iction.uiBotBarArt then
        for i = 1, iction.tablelength(iction.uiBotBarArt) do
            if iction.uiBotBarArt[i] ~= nil then
                iction.uiBotBarArt[i].setVisibility(iction.uiBotBarArt[i], false)
                iction.uiBotBarArt[i] = nil
    end end end
    local skin = iction.skinData[iction.skin]
          skin["uiParentFrame"] = iction.mainFrameBldr.frame
          skin['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
    local skinFrameBldr = {}
          setmetatable(skinFrameBldr, {__index = iction.UIFrameElement})
          skinFrameBldr.create(skinFrameBldr, skin)
    table.insert(iction.uiBotBarArt, skinFrameBldr)

    if iction.debugUI then print("Set skin to skin: " .. tostring(iction.skin)) end
    if iction.debugUI then print("iction.createBottomBarArtwork success!") end
end

function iction.createArtifactFrame()
    if iction.artifactFrame~= nil then
        iction.artifactFrame:Hide()
        iction.artifactFrame = nil
    end
    local fntSize, icon
    if iction.class == iction.L['Warlock'] then
        fntSize = 26
    elseif iction.class == iction.L['Priest'] then
        fntSize = 20
    end

    local next = next
    local artifact = iction.uiPlayerArtifact
    if next(artifact) ~= nil then
        local artifactData = iction.ictArtifactFrameData
              artifactData["uiParentFrame"] = iction.mainFrameBldr.frame
              artifactData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
              local artifactTexture = { name = "artifact-01",
                                        allPoints = true,
                                        anchorPoint = "LEFT",
                                        apX = 0,
                                        apY = 0,
                                        w = 15,
                                        h= 15,
                                        level = "ARTWORK",
                                        texture= GetSpellTexture(artifact['id']),
                                        vr = 1, vg = 1, vb = 1, va = 1}
              table.insert(artifactData['textures'], artifactTexture)

        iction.artifactFrameBldr = {}
              setmetatable(iction.artifactFrameBldr, {__index = iction.UIButtonElement})
              iction.artifactFrameBldr.create(iction.artifactFrameBldr, artifactData)
              iction.artifactFrameBldr.addFontString(iction.artifactFrame, "THICKOUTLINE", "OVERLAY", true, nil, nil, nil, fntSize, 1, 1, 1, 1)

        local function _warlockUpdate()
            local _, _, _, count, _, _, _, _, _, _, _ = UnitBuff("Player", artifact['name'])
            local charges, _, _, _ = GetSpellCharges(artifact['name'])
            if count == nil and charges == nil then
                iction.artifactFrameBldr.timerText:SetText("")
            elseif count then
                iction.artifactFrameBldr.timerText:SetText(count)
            elseif charges then
                iction.artifactFrameBldr.timerText:SetText(charges)
            end
        end

        local function _priestUpdate()
            if iction.blizz_buffActive(194249) then
                iction.artifactFrame.texture:SetVertexColor(1, 1, 1, 1)
            else
                iction.artifactFrame.texture:SetVertexColor(1, .1, .1, .7)
            end

            --- Update channeled timer for artifact channel
            local channeledSpellID, cexpires = iction.blizz_getChannelSpellInfo()
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

        if iction.class == iction.L['Warlock'] then
            iction.artifactFrameBldr.buttonFrame:SetScript("OnUpdate", _warlockUpdate)
        elseif iction.class == iction.L['Priest'] and iction.spec == 3 then
            iction.artifactFrameBldr.buttonFrame:SetScript("OnUpdate", _priestUpdate)
        end
        -- Add to moveable frame table
        table.insert(iction.moveableUIFrames,  iction.artifactFrameBldr)
    end
    if iction.debugUI then print("iction.createArtifactFrame success!") end
end

function iction.createBuffFrame()
    local buffData = iction.ictBuffFrameData
    buffData['uiParentFrame'] = iction.mainFrameBldr.frame
    buffData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
    buffData['w'] = 200
    buffData['h'] = iction.bh
    iction.buffFrameBldr = {}
    setmetatable(iction.buffFrameBldr, {__index = iction.UIFrameElement})
    iction.buffFrame = iction.buffFrameBldr.create(iction.buffFrameBldr, buffData)

    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames, iction.buffFrameBldr)
end

function iction.createDebuffColumns()
    iction.debuffColumns = {}
    local x, y
    x = -(iction.bw*2 + iction.ictionMFW)
    y = -(iction.ictionMFH/2)
    for i = 1, 4, 1 do
        if i == 3 then x = x + iction.ictionMFW+50 end
        local colData = iction.ictDeBuffColumnData
              colData["uiName"] = "iction_col_".. i
              colData["uiParentFrame"] = iction.mainFrameBldr.frame
              colData["nameAttr"] = "iction_col_".. i
              colData['pointPosition']["pos"] = "CENTER"
              colData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
              colData['pointPosition']["x"] = x
              colData['pointPosition']["y"] = y

        local debuffColumnBldr = {}
        setmetatable(debuffColumnBldr, {__index = iction.UIFrameElement})
        debuffColumnBldr.create(debuffColumnBldr, colData)
--        debuffColumnBldr.addTexture(debuffColumnBldr, "iction_col" .. i .. '_bg', 32, 28, "ARTWORK", true, nil, nil, nil, "Interface/AddOns/iction/media/"..i, .1, .5, .1, 0)
        x = x + 75

        iction.debuffColumns["col_" ..i] = debuffColumnBldr

        -- Add to moveable frame table
        table.insert(iction.moveableUIFrames, debuffColumnBldr)
    end
    if iction.debugUI then print("iction.createDebuffColumns success!") end
end

function iction.createShardFrame()
    local shardData = iction.ictShardData
          shardData["uiParentFrame"] = iction.mainFrameBldr.frame
          shardData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame

    iction.shardFrameBldr = {}
          setmetatable(iction.shardFrameBldr, {__index = iction.UIFrameElement})
    iction.shardFrameBldr.create(iction.shardFrameBldr, shardData)
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.shardFrameBldr)
end

function iction.createConflagFrame()
    local conflagData = iction.ictConflagData
          conflagData["uiParentFrame"] = iction.mainFrameBldr.frame
          conflagData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame

    iction.conflagFrameBldr = {}
          setmetatable(iction.conflagFrameBldr, {__index = iction.UIFrameElement})
    iction.conflagFrameBldr.create(iction.conflagFrameBldr, conflagData)
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.conflagFrameBldr)
end

function iction.createInsanityFrame()
    local insanityBar = {}
    local insanityData = iction.ictInsanityData
          insanityData["uiParentFrame"] = iction.mainFrameBldr.frame
          insanityData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
    iction.insanityFrameBldr = {}
          setmetatable(iction.insanityFrameBldr, {__index = iction.UIFrameElement})
    iction.insanityFrame = iction.insanityFrameBldr.create(iction.insanityFrameBldr, insanityData)
    iction.insanityFrameBldr.addTexture(iction.insanityFrame, "insanity", 106, iction.bh/1.8, "BACKGROUND", nil, "LEFT", -3, 0, "Interface\\ChatFrame\\ChatFrameBackground", 0, 0, 0, 1)
--    table.insert(insanityBar, iction.insanityFrameBldr.addTexture(iction.insanityFrame, "insanity", 1, iction.bh/2, "ARTWORK", nil, "LEFT", 0, 0, "Interface\\ChatFrame\\ChatFrameBackground", .5, .1, 1, 1))
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
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.insanityFrameBldr)
end

function iction.createHighlightFrame()
    local fw, fh = iction.calcFrameSize(iction.spellTable)
    local highlightData = iction.ictHighLightFrameData
    highlightData["uiParentFrame"] = iction.mainFrameBldr.frame
    highlightData["w"] = fw
    highlightData["h"] = fh
    highlightData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame

    iction.highlightFrameBldr = {}
    setmetatable(iction.highlightFrameBldr, {__index = iction.UIFrameElement})
    iction.highlightFrame = iction.highlightFrameBldr.create(iction.highlightFrameBldr, highlightData)
--    iction.highlightFrameBldr.addTexture(iction.highlightFrameBldr, "ict_highlightTexture", 1, 1, "BACKGROUND", true, nil, nil, nil, "Interface\\ChatFrame\\ChatFrameBackground", .1, .6, .1, 0)

    return iction.highlightFrameBldr
end

function iction.createSWDFrame()
    iction.SWDUIElements = {}
    local SWDData = iction.ictSWDData
    SWDData["uiParentFrame"] = iction.mainFrameBldr.frame
    SWDData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
    iction.SWDFrameBldr = {}
    setmetatable(iction.SWDFrameBldr, {__index = iction.UIFrameElement})
    iction.SWDFrame = iction.SWDFrameBldr.create(iction.SWDFrameBldr, SWDData)
--    iction.SWDFrame.texture = iction.SWDFrameBldr.addTexture(iction.SWDFrame, "ict_SWDTexture", 15, 15, "BACKGROUND", true, nil, nil, nil, "Interface\\ChatFrame\\ChatFrameBackground", .1, .6, .1, 0)
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
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.SWDFrameBldr)
end

function iction.createVoidFrame()
    iction.voidBoltUIElements = {}
    local VFData = iction.ictVoidData
    VFData["uiParentFrame"] = iction.mainFrameBldr.frame
    VFData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
    iction.voidFrameBldr = {}
    setmetatable(iction.voidFrameBldr, {__index = iction.UIFrameElement})
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
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.voidFrameBldr)
end
