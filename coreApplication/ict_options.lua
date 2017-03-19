local frameW = 300
local frameH = 380
local optionsBoxTop = -(frameH * .24)
local optionsBoxBottom = (frameH * .5)
local optionsBoxW = (frameW*.25)

local swdLabel = optionsBoxBottom - 20
local swdBoxTop = swdLabel - 15

local voidLabel = swdBoxTop - 33
local voidBoxTop = voidLabel - 15

local scaleUILabel = voidBoxTop - 33
local scaleUIBoxTop = scaleUILabel - 15

local chxboxW = 24

function iction.setOptionsFrame()
    --- Now do the global options default setups
    local curTgtCnt = ictionTargetCount
    local setCount
    if not iction.OptionsFrame then
    local artifact = iction.artifact()
        local function createOptionsFrame()
            local optionsData = iction.ictOptionsFrameData
            iction.optionsFrameBldr = {}
                setmetatable(iction.optionsFrameBldr, {__index = iction.UIFrameElement})
                iction.optionsFrameBldr.create(iction.optionsFrameBldr, optionsData)

                --- FRAMES MOUSE CLICK AND DRAG ---
                iction.optionsFrameBldr.frame:SetScript("OnMouseDown", function(self, button)
                    if button == "LeftButton" and not iction.optionsFrameBldr.frame.isMoving then
                        iction.optionsFrameBldr.frame:StartMoving()
                        iction.optionsFrameBldr.frame.isMoving = true
                    end
                end)

                iction.optionsFrameBldr.frame:SetScript("OnMouseUp", function(self, button)
                    if button == "LeftButton" and iction.optionsFrameBldr.frame.isMoving then
                        iction.optionsFrameBldr.frame:StopMovingOrSizing()
                        iction.optionsFrameBldr.frame.isMoving = false
                    end
                end)
        end
        createOptionsFrame()

        local function listAllSpells()
            local allSpellsData = iction.ictSpellsListFrameData
                  allSpellsData['pointPosition']['relativeTo'] = iction.optionsFrameBldr.frame

            iction.allSpellsListFrameBldr = {}
                setmetatable(iction.allSpellsListFrameBldr, {__index = iction.UIScrollFrameElement})
                iction.allSpellsListFrameBldr.create(iction.allSpellsListFrameBldr, allSpellsData)
        end
        listAllSpells()

        local function createMaxTargetsOptions()
            iction.ict_TargetLabel = iction.optionsFrameBldr.frame:CreateFontString("TargetsLabel", "OVERLAY", "GameFontNormal")
            iction.ict_TargetLabel:SetText(iction.L['maxTargetColsLabel'])
            iction.ict_TargetLabel:SetPoint("LEFT", iction.optionsFrameBldr.frame, 20, 0)
            iction.ict_TargetLabel:SetPoint("TOP", iction.optionsFrameBldr.frame, 0, -70)

            iction.TargetOptionsFrame = CreateFrame('Frame', 'TargetOptionsFrame', iction.optionsFrameBldr.frame, "InsetFrameTemplate")
            iction.TargetOptionsFrame:SetWidth(optionsBoxW)
            iction.TargetOptionsFrame:SetFrameStrata("MEDIUM")
            iction.TargetOptionsFrame:SetPoint("LEFT", iction.optionsFrameBldr.frame, 20, 0)
            iction.TargetOptionsFrame:SetPoint("TOP", iction.optionsFrameBldr.frame, 0, optionsBoxTop)
            iction.TargetOptionsFrame:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, optionsBoxBottom)
            local tgIndent = 10

            ict_MaxTarget1Input = CreateFrame("CheckButton", "ict_maxCount1", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_MaxTarget1Input.tooltip = iction.L['maxTargets1TT']
            ict_MaxTarget1Input:SetWidth(chxboxW)
            ict_MaxTarget1Input:SetPoint("LEFT", iction.TargetOptionsFrame, tgIndent, 0)
            ict_MaxTarget1Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -5)
            ict_MaxTarget1Inputtext = _G["ict_maxCount1Text"]
            ict_MaxTarget1Inputtext:SetText(iction.L['maxT1'])
            ict_MaxTarget1Input:SetScript("OnClick", function()
                                            ict_MaxTarget2Input:SetChecked(false)
                                            ict_MaxTarget3Input:SetChecked(false)
                                            ict_MaxTarget4Input:SetChecked(false)
                                            ictionTargetCount = 1
                                            setCount = 1
                                            end)

            ict_MaxTarget2Input = CreateFrame("CheckButton", "ict_maxCount2", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_MaxTarget2Input.tooltip = iction.L['maxTargets2TT']
            ict_MaxTarget2Input:SetWidth(chxboxW)
            ict_MaxTarget2Input:SetPoint("LEFT", iction.TargetOptionsFrame, tgIndent, 0)
            ict_MaxTarget2Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -25)
            ict_MaxTarget2Inputtext = _G["ict_maxCount2Text"]
            ict_MaxTarget2Inputtext:SetText(iction.L['maxT2'])
            ict_MaxTarget2Input:SetScript("OnClick", function()
                                            ict_MaxTarget1Input:SetChecked(false)
                                            ict_MaxTarget3Input:SetChecked(false)
                                            ict_MaxTarget4Input:SetChecked(false)
                                            ictionTargetCount = 2
                                            setCount = 2
                                            end)

            ict_MaxTarget3Input = CreateFrame("CheckButton", "ict_maxCount3", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_MaxTarget3Input.tooltip = iction.L['maxTargets3TT']
            ict_MaxTarget3Input:SetWidth(chxboxW)
            ict_MaxTarget3Input:SetPoint("LEFT", iction.TargetOptionsFrame, tgIndent, 0)
            ict_MaxTarget3Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -45)
            ict_MaxTarget3Inputtext = _G["ict_maxCount3Text"]
            ict_MaxTarget3Inputtext:SetText(iction.L['maxT3'])
            ict_MaxTarget3Input:SetScript("OnClick", function()
                                            ict_MaxTarget1Input:SetChecked(false)
                                            ict_MaxTarget2Input:SetChecked(false)
                                            ict_MaxTarget4Input:SetChecked(false)
                                            ictionTargetCount = 3
                                            setCount = 3
                                            end)

            ict_MaxTarget4Input = CreateFrame("CheckButton", "ict_maxCount4", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_MaxTarget4Input.tooltip = iction.L['maxTargets4TT']
            ict_MaxTarget4Input:SetWidth(chxboxW)
            ict_MaxTarget4Input:SetPoint("LEFT", iction.TargetOptionsFrame, tgIndent, 0)
            ict_MaxTarget4Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -65)
            ict_MaxTarget4Inputtext = _G["ict_maxCount4Text"]
            ict_MaxTarget4Inputtext:SetText(iction.L['maxT4'])
            ict_MaxTarget4Input:SetScript("OnClick", function()
                                            ict_MaxTarget1Input:SetChecked(false)
                                            ict_MaxTarget2Input:SetChecked(false)
                                            ict_MaxTarget3Input:SetChecked(false)
                                            ictionTargetCount = 4
                                            setCount = 4
                                            end)

            if ictionTargetCount == 1 then ict_MaxTarget1Input:SetChecked(true) setCount = 1 end
            if ictionTargetCount == 2 then ict_MaxTarget2Input:SetChecked(true) setCount = 2 end
            if ictionTargetCount == 3 then ict_MaxTarget3Input:SetChecked(true) setCount = 3 end
            if ictionTargetCount == 4 then ict_MaxTarget4Input:SetChecked(true) setCount = 4 end
        end
        createMaxTargetsOptions()

        local function createSkinOptions()
            -------------------------------------------------------------------------------------------------------------
            --- SKIN SELECTION
            local skinNumber
            iction.ict_skinsLabel = iction.optionsFrameBldr.frame:CreateFontString("SkinsLabel", "OVERLAY", "GameFontNormal")
            iction.ict_skinsLabel:SetText(iction.L['skinLabel'])
            iction.ict_skinsLabel:SetPoint("LEFT", iction.optionsFrameBldr.frame, 200, 0)
            iction.ict_skinsLabel:SetPoint("TOP", iction.optionsFrameBldr.frame, 0, -70)

            iction.SkinOptionsFrame = CreateFrame('Frame', 'SkinOptionsFrame', iction.optionsFrameBldr.frame, "InsetFrameTemplate")
            iction.SkinOptionsFrame:SetFrameStrata("MEDIUM")
            iction.SkinOptionsFrame:SetWidth(optionsBoxW)
            iction.SkinOptionsFrame:SetPoint("RIGHT", iction.optionsFrameBldr.frame, -20, 0)
            iction.SkinOptionsFrame:SetPoint("TOP", iction.optionsFrameBldr.frame, -20, optionsBoxTop)
            iction.SkinOptionsFrame:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, optionsBoxBottom)

            local skinIndent = 10
            ict_skin1Input = CreateFrame("CheckButton", "ict_skin1", iction.SkinOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_skin1Input.tooltip = iction.L['skin1TT']
            ict_skin1Input:SetWidth(chxboxW)
            ict_skin1Input:SetPoint("LEFT", iction.SkinOptionsFrame, skinIndent, 0)
            ict_skin1Input:SetPoint("TOP", iction.SkinOptionsFrame, 0, -5)
            ict_skin1InputText = _G["ict_skin1Text"]
            ict_skin1InputText:SetText(iction.L['maxT1'])
            if ictionSkin == 1 then ict_skin1Input:SetChecked(true) end
            ict_skin1Input:SetScript("OnClick", function()
                                    ict_skin2Input:SetChecked(false)
                                    ict_skin3Input:SetChecked(false)
                                    ict_skin4Input:SetChecked(false)
                                    ictionSkin = 1
                                    iction.skin = ictionSkin
                                    iction.createBottomBarArtwork()
                                    end)
            ict_skin2Input = CreateFrame("CheckButton", "ict_skin2", iction.SkinOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_skin2Input.tooltip = iction.L['skin2TT']
            ict_skin2Input:SetWidth(chxboxW)
            ict_skin2Input:SetPoint("LEFT", iction.SkinOptionsFrame, skinIndent, 0)
            ict_skin2Input:SetPoint("TOP", iction.SkinOptionsFrame, 0, -25)
            ict_skin2InputText = _G["ict_skin2Text"]
            ict_skin2InputText:SetText(iction.L['maxT2'])
            if ictionSkin == 2 then ict_skin2Input:SetChecked(true) end
            ict_skin2Input:SetScript("OnClick", function()
                                    ict_skin1Input:SetChecked(false)
                                    ict_skin3Input:SetChecked(false)
                                    ict_skin4Input:SetChecked(false)
                                    ictionSkin = 2
                                    iction.skin = ictionSkin
                                    iction.createBottomBarArtwork()
                                    end)
            ict_skin3Input = CreateFrame("CheckButton", "ict_skin3", iction.SkinOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_skin3Input.tooltip = iction.L['skin3TT']
            ict_skin3Input:SetWidth(chxboxW)
            ict_skin3Input:SetPoint("LEFT", iction.SkinOptionsFrame, skinIndent, 0)
            ict_skin3Input:SetPoint("TOP", iction.SkinOptionsFrame, 0, -45)
            ict_skin3InputText = _G["ict_skin3Text"]
            ict_skin3InputText:SetText(iction.L['maxT3'])
            if ictionSkin == 3 then ict_skin3Input:SetChecked(true) end
            ict_skin3Input:SetScript("OnClick", function()
                                    ict_skin1Input:SetChecked(false)
                                    ict_skin2Input:SetChecked(false)
                                    ict_skin4Input:SetChecked(false)
                                    ictionSkin = 3
                                    iction.skin = ictionSkin
                                    iction.createBottomBarArtwork()
                                    end)
            ict_skin4Input = CreateFrame("CheckButton", "ict_skin4", iction.SkinOptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_skin4Input.tooltip = iction.L['skin4TT']
            ict_skin4Input:SetWidth(chxboxW)
            ict_skin4Input:SetPoint("LEFT", iction.SkinOptionsFrame, skinIndent, 0)
            ict_skin4Input:SetPoint("TOP", iction.SkinOptionsFrame, 0, -65)
            ict_skin4InputText = _G["ict_skin4Text"]
            ict_skin4InputText:SetText(iction.L['maxT4'])
            if ictionSkin == 4 then ict_skin4Input:SetChecked(true) end
            ict_skin4Input:SetScript("OnClick", function()
                                    ict_skin1Input:SetChecked(false)
                                    ict_skin2Input:SetChecked(false)
                                    ict_skin3Input:SetChecked(false)
                                    ictionSkin = 4
                                    iction.skin = ictionSkin
                                    iction.createBottomBarArtwork()
                                    end)
        end
        createSkinOptions()

        local function createScaleUIOptions()
            ----------------------------------------------------------------------------------------------------------
            --- SCALE
            iction.ict_scaleLabel = iction.optionsFrameBldr.frame:CreateFontString("ScaleLabel", "OVERLAY", "GameFontNormal")
            iction.ict_scaleLabel:SetText(iction.L['scale'])
            iction.ict_scaleLabel:SetPoint("LEFT", iction.optionsFrameBldr.frame, 10, 0)
            iction.ict_scaleLabel:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, scaleUILabel)

            iction.ict_scaleIDXLabel = iction.optionsFrameBldr.frame:CreateFontString("ScaleIDXLabel", "OVERLAY", "GameFontNormal")
            iction.ict_scaleIDXLabel:SetText(ictionGlobalScale)
            iction.ict_scaleIDXLabel:SetPoint("RIGHT", iction.optionsFrameBldr.frame, -10, 0)
            iction.ict_scaleIDXLabel:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, scaleUILabel)

            iction.ict_Scale = CreateFrame("Slider", "ict_scaleSlider", iction.optionsFrameBldr.frame, "OptionsSliderTemplate")
            iction.ict_Scale.tooltip = iction.L['scaleUI']
            iction.ict_Scale:SetPoint("LEFT", iction.optionsFrameBldr.frame, 10, 0)
            iction.ict_Scale:SetPoint("RIGHT", iction.optionsFrameBldr.frame, -10, 0)
            iction.ict_Scale:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, scaleUIBoxTop)
            iction.ict_Scale:SetMinMaxValues(.5,2)
            iction.ict_Scale.minValue, iction.ict_Scale.maxValue = iction.ict_Scale:GetMinMaxValues()
            iction.ict_Scale:SetValue(1)
            iction.ict_Scale:SetValueStep(.1)
            iction.ict_Scale:SetOrientation("HORIZONTAL")
            iction.ict_Scale:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
            iction.ict_Scale:SetBackdrop({
                      bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
                      edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
                      tile = true, tileSize = 8, edgeSize = 8,
                      insets = { left = 3, right = 3, top = 6, bottom = 6 }})
            iction.ict_Scale:SetScript("OnValueChanged", function(self, event, arg1)
                                ictionGlobalScale = tonumber(string.format("%.1f", event))
                                iction.mainFrameBldr.frame:SetScale(tonumber(string.format("%.1f", event)))
                                iction.ict_scaleIDXLabel:SetText(string.format("%.1f", ictionGlobalScale))
                                end)
        end
        createScaleUIOptions()

        local function createSWDOptions()
            ----------------------------------------------------------------------------------------------------------
            --- PWD Scale Options
            iction.ict_swdScaleLabel = iction.optionsFrameBldr.frame:CreateFontString("PWDScaleLabel", "OVERLAY", "GameFontNormal")
            iction.ict_swdScaleLabel:SetText(iction.L['scaleSWD'])
            iction.ict_swdScaleLabel:SetPoint("LEFT", iction.optionsFrameBldr.frame, 10, 0)
            iction.ict_swdScaleLabel:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, swdLabel)

            iction.ict_swdIDXScaleLabel = iction.optionsFrameBldr.frame:CreateFontString("ScaleIDXLabel", "OVERLAY", "GameFontNormal")
            iction.ict_swdIDXScaleLabel:SetText(ictionSWDScale)
            iction.ict_swdIDXScaleLabel:SetPoint("RIGHT", iction.optionsFrameBldr.frame, -10, 0)
            iction.ict_swdIDXScaleLabel:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, swdLabel)

            iction.ict_PWDScale = CreateFrame("Slider", "ict_scaleSlider", iction.optionsFrameBldr.frame, "OptionsSliderTemplate")
            iction.ict_PWDScale.tooltip = iction.L['scaleSWDTT']
            iction.ict_PWDScale:SetPoint("LEFT", iction.optionsFrameBldr.frame, 10, 0)
            iction.ict_PWDScale:SetPoint("RIGHT", iction.optionsFrameBldr.frame, -10, 0)
            iction.ict_PWDScale:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, swdBoxTop)
            iction.ict_PWDScale:SetMinMaxValues(.5,2)
            iction.ict_PWDScale.minValue, iction.ict_Scale.maxValue = iction.ict_Scale:GetMinMaxValues()
            iction.ict_PWDScale:SetValue(ictionSWDScale)
            iction.ict_PWDScale:SetValueStep(.1)
            iction.ict_PWDScale:SetOrientation("HORIZONTAL")
            iction.ict_PWDScale:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
            iction.ict_PWDScale:SetBackdrop({
                      bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
                      edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
                      tile = true, tileSize = 8, edgeSize = 8,
                      insets = { left = 3, right = 3, top = 6, bottom = 6 }})
            iction.ict_PWDScale:SetScript("OnValueChanged", function(self, event, arg1)
                                ictionSWDScale = tonumber(string.format("%.1f", event))
                                iction.SWDFrame:SetScale(tonumber(string.format("%.1f", event)))
                                iction.ict_swdIDXScaleLabel:SetText(string.format("%.1f", ictionSWDScale))
                                end)
        end
        if iction.class == iction.L['Priest'] then
            createSWDOptions()
        end
        local function createVoidOptions()
            ----------------------------------------------------------------------------------------------------------
            --- PWD Scale Options
            iction.ict_voidBoltScaleLabel = iction.optionsFrameBldr.frame:CreateFontString("PWDScaleLabel", "OVERLAY", "GameFontNormal")
            iction.ict_voidBoltScaleLabel:SetText(iction.L['scaleVB'])
            iction.ict_voidBoltScaleLabel:SetPoint("LEFT", iction.optionsFrameBldr.frame, 10, 0)
            iction.ict_voidBoltScaleLabel:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, voidLabel)

            iction.ict_voidBoltIDXScaleLabel = iction.optionsFrameBldr.frame:CreateFontString("ScaleIDXLabel", "OVERLAY", "GameFontNormal")
            iction.ict_voidBoltIDXScaleLabel:SetText(ictionVoidBoltScale)
            iction.ict_voidBoltIDXScaleLabel:SetPoint("RIGHT", iction.optionsFrameBldr.frame, -10, 0)
            iction.ict_voidBoltIDXScaleLabel:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, voidLabel)

            iction.ict_PWDScale = CreateFrame("Slider", "ict_scaleSlider", iction.optionsFrameBldr.frame, "OptionsSliderTemplate")
            iction.ict_PWDScale.tooltip = iction.L['scaleVBTT']
            iction.ict_PWDScale:SetPoint("LEFT", iction.optionsFrameBldr.frame, 10, 0)
            iction.ict_PWDScale:SetPoint("RIGHT", iction.optionsFrameBldr.frame, -10, 0)
            iction.ict_PWDScale:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, voidBoxTop)
            iction.ict_PWDScale:SetMinMaxValues(.5,2)
            iction.ict_PWDScale.minValue, iction.ict_Scale.maxValue = iction.ict_Scale:GetMinMaxValues()
            iction.ict_PWDScale:SetValue(ictionVoidBoltScale)
            iction.ict_PWDScale:SetValueStep(.1)
            iction.ict_PWDScale:SetOrientation("HORIZONTAL")
            iction.ict_PWDScale:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
            iction.ict_PWDScale:SetBackdrop({
                      bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
                      edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
                      tile = true, tileSize = 8, edgeSize = 8,
                      insets = { left = 3, right = 3, top = 6, bottom = 6 }})
            iction.ict_PWDScale:SetScript("OnValueChanged", function(self, event, arg1)
                                ictionVoidBoltScale = tonumber(string.format("%.1f", event))
                                iction.voidFrame:SetScale(tonumber(string.format("%.1f", event)))
                                iction.ict_voidBoltIDXScaleLabel:SetText(string.format("%.1f", ictionVoidBoltScale))
                                end)
        end
        if iction.class == iction.L['Priest'] then
            createVoidOptions()
        end
        ----------------------------------------------------------------------------------------------------------
        --- UNLOCK
        ict_UnlockCBx = CreateFrame("CheckButton", "ict_unlock", iction.optionsFrameBldr.frame, "ChatConfigCheckButtonTemplate")
        ict_UnlockCBx.tooltip = iction.L['unlockUITT']
        ict_UnlockCBx:SetPoint("LEFT", iction.optionsFrameBldr.frame, 10, 0)
        ict_UnlockCBx:SetPoint("BOTTOM", iction.optionsFrameBldr.frame, 0, 10)
        ict_UnlockCBxtext = _G["ict_unlockText"]
        ict_UnlockCBxtext:SetText(iction.L['unlockUILabel'])
        ict_UnlockCBx:SetScript("OnClick", function()
                                if ict_UnlockCBx:GetChecked() then iction.unlockUIElements(true)
                                else iction.unlockUIElements(false) end
                                end)

        ---------------------
        --- Close button ----
        local closeOptionsButton = CreateFrame("Button", "Close", iction.optionsFrameBldr.frame, "UIPanelButtonTemplate")
        closeOptionsButton:SetFrameStrata("MEDIUM")
        closeOptionsButton:SetPoint("BOTTOMRIGHT", iction.optionsFrameBldr.frame, -5, -8)
        closeOptionsButton:SetWidth(45)
        closeOptionsButton:SetHeight(25)

        --- Create the texture for the close button
        local closeButText = closeOptionsButton:CreateTexture(nil, "ARTWORK")
              closeButText:SetAllPoints(true)
              closeButText:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
              closeButText:SetVertexColor(0.9,0.3,0.3, 0)
        closeOptionsButton:Show()
        --- Create the fontString for the close button
        local fnt = closeOptionsButton:CreateFontString(nil, "OVERLAY", "GameFontWhite")
              fnt:SetFont(iction.font, 12, "OVERLAY", "THICKOUTLINE")
              fnt:SetPoint("CENTER", closeOptionsButton, 0, 0)
              fnt:SetText(iction.L['close'])
        closeOptionsButton.text = fnt
        closeOptionsButton:SetScript("OnClick", function()
            iction.optionsFrameBldr.frame:Hide()
            iction.allSpellsListFrameBldr.frame:Hide()
            CastingBarFrame:SetAlpha(0)
            CastingBarFrame:Hide()
            ict_moveCastBarButton = nil
            if setCount ~= curTgtCnt then ReloadUI() end
        end)
        if ictionSetCastBar then
            CastingBarFrame:Show()
            CastingBarFrame:SetAlpha(1)
        end
        iction.optionsFrameBldr.frame:Show()
    else
        iction.optionsFrameBldr.frame:Show()
        if ictionSetCastBar then
            CastingBarFrame:Show()
            CastingBarFrame:SetAlpha(1)
        end
    end
    CastingBarFrame:SetAlpha(1)
end