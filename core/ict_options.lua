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
local localizedClass, _, _ = UnitClass("Player")

function iction.setOptionsFrame()
    --- Now do the global options default setups
    local curTgtCnt = ictionTargetCount
    local setCount
    if not iction.OptionsFrame then
        local function createOptionsFrame()
            iction.OptionsFrame = CreateFrame('Frame', 'ictionOptions', UIParent, "OptionsBoxTemplate")
            iction.OptionsFrame:SetPoint("CENTER", UIParent, 0, 250)
            iction.OptionsFrame:SetFrameStrata("MEDIUM")
            iction.OptionsFrame:EnableMouse(true)
            iction.OptionsFrame:SetMovable(true)
            iction.OptionsFrame:SetUserPlaced(true)
            iction.OptionsFrame:SetWidth(frameW)
            iction.OptionsFrame:SetHeight(frameH)
            iction.OptionsFrame:SetBackdropColor(1, 0, 0, 1)

            local OptionsBgT = iction.OptionsFrame:CreateTexture(nil, "BACKGROUND")
                  OptionsBgT:SetAllPoints(true)
                  OptionsBgT:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                  OptionsBgT:SetVertexColor(.4, .1, .1, .85)
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
        end
        createOptionsFrame()

        local function createCastBarOptions()
            ---------------------
            --- Move CastBar ----
            ict_moveCastBarButton = CreateFrame("CheckButton", "ict_moveCastBarButton", iction.OptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_moveCastBarButton.tooltip = iction.L['MoveCastBarTT']
            icttext = _G["ict_moveCastBarButtonText"]
            if ictionSetCastBar then ict_moveCastBarButton:SetChecked(true) end
            ict_moveCastBarButton:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            ict_moveCastBarButton:SetPoint("TOP", iction.OptionsFrame, 0, -10)
            icttext:SetText(iction.L['MoveCastBarText'])
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
        end
        createCastBarOptions()

        local function createHorizontalBarOptions()
            ----------------------------------------------------------------------------------------------------------
            --- HORIZONTAL BUFF BAR
            ict_BBarHorizontalButton = CreateFrame("CheckButton", "ict_BBarHorizontalButton", iction.OptionsFrame, "ChatConfigCheckButtonTemplate")
            ict_BBarHorizontalButton.tooltip = iction.L['setBuffBar']
            bbhtext = _G["ict_BBarHorizontalButtonText"]
            if ictionBuffBarBarH then ict_BBarHorizontalButton:SetChecked(true) end
            ict_BBarHorizontalButton:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            ict_BBarHorizontalButton:SetPoint("TOP", iction.OptionsFrame, 0, -40)
            bbhtext:SetText(iction.L['HorizontalBuffBar'])
            ict_BBarHorizontalButton:SetScript("OnClick", function()
                if ict_BBarHorizontalButton:GetChecked() then
                    ictionBuffBarBarH = true
                    DEFAULT_CHAT_FRAME:AddMessage(iction.L['HorizontalBuffBarText'], 100, 35, 35)
                else
                    ictionBuffBarBarH = false
                    DEFAULT_CHAT_FRAME:AddMessage(iction.L['VerticalBuffBarText'], 100, 35, 35)
                end
            end)
        end
        createHorizontalBarOptions()

        local function createMaxTargetsOptions()
            ----------------------------------------------------------------------------------------------------------
            --- MAX TARGETS
            iction.ict_TargetLabel = iction.OptionsFrame:CreateFontString("TargetsLabel", "OVERLAY", "GameFontNormal")
            iction.ict_TargetLabel:SetText(iction.L['maxTargetColsLabel'])
            iction.ict_TargetLabel:SetPoint("LEFT", iction.OptionsFrame, 20, 0)
            iction.ict_TargetLabel:SetPoint("TOP", iction.OptionsFrame, 0, -70)

            iction.TargetOptionsFrame = CreateFrame('Frame', 'TargetOptionsFrame', iction.OptionsFrame, "InsetFrameTemplate")
            iction.TargetOptionsFrame:SetWidth(optionsBoxW)
            iction.TargetOptionsFrame:SetFrameStrata("MEDIUM")
            iction.TargetOptionsFrame:SetPoint("LEFT", iction.OptionsFrame, 20, 0)
            iction.TargetOptionsFrame:SetPoint("TOP", iction.OptionsFrame, 0, optionsBoxTop)
            iction.TargetOptionsFrame:SetPoint("BOTTOM", iction.OptionsFrame, 0, optionsBoxBottom)
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
            iction.ict_skinsLabel = iction.OptionsFrame:CreateFontString("SkinsLabel", "OVERLAY", "GameFontNormal")
            iction.ict_skinsLabel:SetText(iction.L['skinLabel'])
            iction.ict_skinsLabel:SetPoint("LEFT", iction.OptionsFrame, 200, 0)
            iction.ict_skinsLabel:SetPoint("TOP", iction.OptionsFrame, 0, -70)

            iction.SkinOptionsFrame = CreateFrame('Frame', 'SkinOptionsFrame', iction.OptionsFrame, "InsetFrameTemplate")
            iction.SkinOptionsFrame:SetFrameStrata("MEDIUM")
            iction.SkinOptionsFrame:SetWidth(optionsBoxW)
            iction.SkinOptionsFrame:SetPoint("RIGHT", iction.OptionsFrame, -20, 0)
            iction.SkinOptionsFrame:SetPoint("TOP", iction.OptionsFrame, -20, optionsBoxTop)
            iction.SkinOptionsFrame:SetPoint("BOTTOM", iction.OptionsFrame, 0, optionsBoxBottom)

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
            iction.ict_scaleLabel = iction.OptionsFrame:CreateFontString("ScaleLabel", "OVERLAY", "GameFontNormal")
            iction.ict_scaleLabel:SetText(iction.L['scale'])
            iction.ict_scaleLabel:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            iction.ict_scaleLabel:SetPoint("BOTTOM", iction.OptionsFrame, 0, scaleUILabel)

            iction.ict_scaleIDXLabel = iction.OptionsFrame:CreateFontString("ScaleIDXLabel", "OVERLAY", "GameFontNormal")
            iction.ict_scaleIDXLabel:SetText(ictionGlobalScale)
            iction.ict_scaleIDXLabel:SetPoint("RIGHT", iction.OptionsFrame, -10, 0)
            iction.ict_scaleIDXLabel:SetPoint("BOTTOM", iction.OptionsFrame, 0, scaleUILabel)

            iction.ict_Scale = CreateFrame("Slider", "ict_scaleSlider", iction.OptionsFrame, "OptionsSliderTemplate")
            iction.ict_Scale.tooltip = iction.L['scaleUI']
            iction.ict_Scale:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            iction.ict_Scale:SetPoint("RIGHT", iction.OptionsFrame, -10, 0)
            iction.ict_Scale:SetPoint("BOTTOM", iction.OptionsFrame, 0, scaleUIBoxTop)
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
                                iction.ictionMF:SetScale(tonumber(string.format("%.1f", event)))
                                iction.ict_scaleIDXLabel:SetText(string.format("%.1f", ictionGlobalScale))
                                end)
        end
        createScaleUIOptions()

        local function createSWDOptions()
            ----------------------------------------------------------------------------------------------------------
            --- PWD Scale Options
            iction.ict_swdScaleLabel = iction.OptionsFrame:CreateFontString("PWDScaleLabel", "OVERLAY", "GameFontNormal")
            iction.ict_swdScaleLabel:SetText(iction.L['scaleSWD'])
            iction.ict_swdScaleLabel:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            iction.ict_swdScaleLabel:SetPoint("BOTTOM", iction.OptionsFrame, 0, swdLabel)

            iction.ict_swdIDXScaleLabel = iction.OptionsFrame:CreateFontString("ScaleIDXLabel", "OVERLAY", "GameFontNormal")
            iction.ict_swdIDXScaleLabel:SetText(ictionSWDScale)
            iction.ict_swdIDXScaleLabel:SetPoint("RIGHT", iction.OptionsFrame, -10, 0)
            iction.ict_swdIDXScaleLabel:SetPoint("BOTTOM", iction.OptionsFrame, 0, swdLabel)

            iction.ict_PWDScale = CreateFrame("Slider", "ict_scaleSlider", iction.OptionsFrame, "OptionsSliderTemplate")
            iction.ict_PWDScale.tooltip = iction.L['scaleSWDTT']
            iction.ict_PWDScale:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            iction.ict_PWDScale:SetPoint("RIGHT", iction.OptionsFrame, -10, 0)
            iction.ict_PWDScale:SetPoint("BOTTOM", iction.OptionsFrame, 0, swdBoxTop)
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
        if localizedClass == iction.L['priest'] then
            createSWDOptions()
        end
        local function createVoidOptions()
            ----------------------------------------------------------------------------------------------------------
            --- PWD Scale Options
            iction.ict_voidBoltScaleLabel = iction.OptionsFrame:CreateFontString("PWDScaleLabel", "OVERLAY", "GameFontNormal")
            iction.ict_voidBoltScaleLabel:SetText(iction.L['scaleVB'])
            iction.ict_voidBoltScaleLabel:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            iction.ict_voidBoltScaleLabel:SetPoint("BOTTOM", iction.OptionsFrame, 0, voidLabel)

            iction.ict_voidBoltIDXScaleLabel = iction.OptionsFrame:CreateFontString("ScaleIDXLabel", "OVERLAY", "GameFontNormal")
            iction.ict_voidBoltIDXScaleLabel:SetText(ictionVoidBoltScale)
            iction.ict_voidBoltIDXScaleLabel:SetPoint("RIGHT", iction.OptionsFrame, -10, 0)
            iction.ict_voidBoltIDXScaleLabel:SetPoint("BOTTOM", iction.OptionsFrame, 0, voidLabel)

            iction.ict_PWDScale = CreateFrame("Slider", "ict_scaleSlider", iction.OptionsFrame, "OptionsSliderTemplate")
            iction.ict_PWDScale.tooltip = iction.L['scaleVBTT']
            iction.ict_PWDScale:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
            iction.ict_PWDScale:SetPoint("RIGHT", iction.OptionsFrame, -10, 0)
            iction.ict_PWDScale:SetPoint("BOTTOM", iction.OptionsFrame, 0, voidBoxTop)
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
        if localizedClass == iction.L['priest'] then
            createVoidOptions()
        end
        ----------------------------------------------------------------------------------------------------------
        --- UNLOCK
        ict_UnlockCBx = CreateFrame("CheckButton", "ict_unlock", iction.OptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_UnlockCBx.tooltip = iction.L['unlockUITT']
        ict_UnlockCBx:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
        ict_UnlockCBx:SetPoint("BOTTOM", iction.OptionsFrame, 0, 10)
        ict_UnlockCBxtext = _G["ict_unlockText"]
        ict_UnlockCBxtext:SetText(iction.L['unlockUILabel'])
        ict_UnlockCBx:SetScript("OnClick", function()
                                if ict_UnlockCBx:GetChecked() then iction.unlockUIElements(true)
                                else iction.unlockUIElements(false) end
                                end)

        ---------------------
        --- Close button ----
        local closeOptionsButton = CreateFrame("Button", "Close", iction.OptionsFrame, "UIPanelButtonTemplate")
        closeOptionsButton:SetFrameStrata("HIGH")
        closeOptionsButton:SetPoint("BOTTOMRIGHT", iction.OptionsFrame, -5, -8)
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
            iction.OptionsFrame:Hide()
            CastingBarFrame:SetAlpha(0)
            CastingBarFrame:Hide()
            ict_moveCastBarButton = nil
            if setCount ~= curTgtCnt then ReloadUI() end
        end)
        if ictionSetCastBar then
            CastingBarFrame:Show()
            CastingBarFrame:SetAlpha(1)
        end
        iction.OptionsFrame:Show()
    else
        iction.OptionsFrame:Show()
        if ictionSetCastBar then
            CastingBarFrame:Show()
            CastingBarFrame:SetAlpha(1)
        end
    end
    CastingBarFrame:SetAlpha(1)
end