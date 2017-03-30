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
    if iction.artifactFrameBldr then
        iction.artifactFrameBldr.frame:Hide()
        iction.artifactFrameBldr = nil
    end
    local fntSize, icon
    fntSize = 26

    local artifact = iction.artifact()
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
          setmetatable(iction.artifactFrameBldr, {__index = iction.UIFrameElement})
          iction.artifactFrameBldr.create(iction.artifactFrameBldr, artifactData)
          iction.artifactFrameBldr.addFontString(iction.artifactFrameBldr, "THICK", "MEDIUM", true, nil, nil, nil, fntSize, 1, 1, 1, 1)

    local function _warlockUpdate()
        local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(artifact['id'])
        if artifact['id'] then
            local _, _, _, count, _, _, _, _, _, _, _ = UnitBuff("Player", name)
            local charges, _, _, _ = GetSpellCharges(name)
            if count == nil and charges == nil then
                iction.artifactFrameBldr.text:SetText("")
            elseif count then
                iction.artifactFrameBldr.text:SetText(count)
            elseif charges then
                iction.artifactFrameBldr.text:SetText(charges)
            end
        end
    end

    local function _priestUpdate()
        if iction.blizz_buffActive(194249) then
            iction.artifactFrameBldr.textures[1]:SetVertexColor(1, 1, 1, 1)
        else
            iction.artifactFrameBldr.textures[1]:SetVertexColor(1, .1, .1, .7)
        end

        --- Update channeled timer for artifact channel
        local channeledSpellID, cexpires = iction.blizz_getChannelSpellInfo()
        if channeledSpellID == 205065 then
            local remainingT = cexpires - GetTime()
            local TL = tonumber(string.format("%.1f", (remainingT)))
            if TL > 3 then
                iction.artifactFrameBldr.text:SetTextColor(1, 1, 1, 1)
            else
                iction.artifactFrameBldr.text:SetTextColor(1, .1, .1, 1)
            end
            iction.artifactFrameBldr.text:SetText(tostring(TL))

        elseif iction.isSpellOnCooldown(205065) then
            local start, duration, _ = GetSpellCooldown(205065)
            if duration > 1.5 then
                local cdET = iction.fetchCooldownET(205065)
                local remainingT = cdET - GetTime()
                local TL = tonumber(string.format("%.1d", (remainingT)))
                iction.artifactFrameBldr.textures[1]:SetVertexColor(.55, .1, .1, 1)
                if TL > 3 then
                    iction.artifactFrameBldr.text:SetTextColor(1, 1, 1, 1)
                else
                    iction.artifactFrameBldr.text:SetTextColor(1, .1, .1, 1)
                end
                iction.artifactFrameBldr.text:SetText(TL)
            end
        else
            iction.artifactFrameBldr.text:SetText("")
        end
        --- Sparkle on insanity
    end

    if iction.class == iction.L['Warlock'] then
        iction.artifactFrameBldr.frame:SetScript("OnUpdate", _warlockUpdate)
    elseif iction.class == iction.L['Priest'] and iction.spec == 3 then
        iction.artifactFrameBldr.frame:SetScript("OnUpdate", _priestUpdate)
    end
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.artifactFrameBldr)
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
        iction.buffFrameBldr.create(iction.buffFrameBldr, buffData)

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
    local insanityData = iction.ictInsanityData
          insanityData["uiParentFrame"] = iction.mainFrameBldr.frame
          insanityData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
    iction.insanityFrameBldr = {}
          setmetatable(iction.insanityFrameBldr, {__index = iction.UIFrameElement})
          iction.insanityFrameBldr.create(iction.insanityFrameBldr, insanityData)
    if iction.debugUI then print("createInsanityFrame created!") end
    local function _updateInsanity()
        if iction.spec == 3 then
            local insanity = UnitPower("player", SPELL_POWER_INSANITY)
            if insanity ~= 0 then
                iction.insanityFrameBldr.textures[3]:SetWidth(insanity)
                iction.insanityFrameBldr.text:SetText(tostring(insanity))
                iction.insanityFrameBldr.textures[3]:SetVertexColor(.5, .1, 1, 1)
            else
                iction.insanityFrameBldr.textures[3]:SetVertexColor(0, 0, 0, .1)
                iction.insanityFrameBldr.text:SetText("0")
            end
        end
    end
    iction.insanityFrameBldr.frame:SetScript("OnUpdate", _updateInsanity)
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.insanityFrameBldr)
end

function iction.createSWDFrame()
    local SWDData = iction.ictSWDData
          SWDData["uiParentFrame"] = iction.mainFrameBldr.frame
          SWDData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame

    iction.SWDFrameBldr = {}
          setmetatable(iction.SWDFrameBldr, {__index = iction.UIFrameElement})
          iction.SWDFrameBldr.create(iction.SWDFrameBldr, SWDData)
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.SWDFrameBldr)

    iction.SWDButtonBldr = {}
          local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(iction.swdID)
          local SWDData = {}
                SWDData['uiName'] = name
                SWDData['id'] = iction.swdID
                SWDData['rank'] = rank
                SWDData['castingTime'] = castingTime --returns in milliseconds so we should do *.001
                SWDData['minRange'] = minRange
                SWDData['maxRange'] = maxRange
                SWDData['icon'] = icon
          setmetatable(iction.SWDButtonBldr, {__index = iction.UIButtonElement})
          iction.SWDButtonBldr.create(iction.SWDButtonBldr, iction.SWDFrameBldr.frame, SWDData, "CENTER", 0, 0)
          iction.SWDButtonBldr.buttonFrame:SetAllPoints(true)
end

function iction.createVoidFrame()
    local VFData = iction.ictVoidData
          VFData["uiParentFrame"] = iction.mainFrameBldr.frame
          VFData['pointPosition']['relativeTo'] = iction.mainFrameBldr.frame
    iction.voidFrameBldr = {}
          setmetatable(iction.voidFrameBldr, {__index = iction.UIFrameElement})
          iction.voidFrameBldr.create(iction.voidFrameBldr, VFData)
    -- Add to moveable frame table
    table.insert(iction.moveableUIFrames,  iction.voidFrameBldr)

    iction.voidButtonBldr = {}
          local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(iction.vbID)
          local VButtonData = {}
                VButtonData['uiName'] = name
                VButtonData['id'] = iction.vbID
                VButtonData['rank'] = rank
                VButtonData['castingTime'] = castingTime --returns in milliseconds so we should do *.001
                VButtonData['minRange'] = minRange
                VButtonData['maxRange'] = maxRange
                VButtonData['icon'] = icon
          setmetatable(iction.voidButtonBldr, {__index = iction.UIButtonElement})
          iction.voidButtonBldr.create(iction.voidButtonBldr, iction.voidFrameBldr.frame, VButtonData, "CENTER", 0, 0)
          iction.voidButtonBldr.buttonFrame:SetAllPoints(true)
end
