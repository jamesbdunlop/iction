function iction.setOptionsFrame()
    --- Now do the global options default setups
    local curTgtCnt = ictionTargetCount
    local setCount
    if not iction.OptionsFrame then
        iction.OptionsFrame = CreateFrame('Frame', 'ictionOptions', UIParent, "OptionsBoxTemplate")
        iction.OptionsFrame:SetPoint("CENTER", UIParent, 0, 250)
        iction.OptionsFrame:SetFrameStrata("BACKGROUND")
        iction.OptionsFrame:EnableMouse(true)
        iction.OptionsFrame:SetMovable(true)
        iction.OptionsFrame:SetUserPlaced(true)
        iction.OptionsFrame:SetWidth(300)
        iction.OptionsFrame:SetHeight(300)
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
        ---------------------
        --- Move CastBar ----
        ict_moveCastBarButton = CreateFrame("CheckButton", "ict_moveCastBarButton", iction.OptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_moveCastBarButton.tooltip = "Set place your bliz cast bar in a custom location or not."
        icttext = _G["ict_moveCastBarButtonText"]
        if ictionSetCastBar then ict_moveCastBarButton:SetChecked(true) end
        ict_moveCastBarButton:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
        ict_moveCastBarButton:SetPoint("TOP", iction.OptionsFrame, 0, -10)
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

        ict_BBarHorizontalButton = CreateFrame("CheckButton", "ict_BBarHorizontalButton", iction.OptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_BBarHorizontalButton.tooltip = "Set buffBar to be horizontal or not."
        bbhtext = _G["ict_BBarHorizontalButtonText"]
        if ictionBuffBarBarH then ict_BBarHorizontalButton:SetChecked(true) end
        ict_BBarHorizontalButton:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
        ict_BBarHorizontalButton:SetPoint("TOP", iction.OptionsFrame, 0, -40)
        bbhtext:SetText("Horizontal BuffBar?")
        ict_BBarHorizontalButton:SetScript("OnClick", function()
            if ict_BBarHorizontalButton:GetChecked() then
                ictionBuffBarBarH = true
                DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44Set BuffBar to Horizontal", 100, 35, 35)
            else
                ictionBuffBarBarH = false
                DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44Set BuffBar to Vertical", 100, 35, 35)
            end
        end)

        iction.ict_TargetLabel = UIParent:CreateFontString("TargetsLabel", "OVERLAY", "GameFontNormal")
        iction.ict_TargetLabel:SetText('Max Target Columns:')
        iction.ict_TargetLabel:SetPoint("LEFT", iction.OptionsFrame, 20, 0)
        iction.ict_TargetLabel:SetPoint("TOP", iction.OptionsFrame, 0, -70)

        iction.TargetOptionsFrame = CreateFrame('Frame', 'TargetOptionsFrame', iction.OptionsFrame, "InsetFrameTemplate")
        iction.TargetOptionsFrame:SetFrameStrata("MEDIUM")
        iction.TargetOptionsFrame:SetPoint("LEFT", iction.OptionsFrame, 20, 0)
        iction.TargetOptionsFrame:SetPoint("RIGHT", iction.OptionsFrame, -20, 0)
        iction.TargetOptionsFrame:SetPoint("TOP", iction.OptionsFrame, -20, -85)
        iction.TargetOptionsFrame:SetPoint("BOTTOM", iction.OptionsFrame, 0, 175)

        ict_MaxTarget1Input = CreateFrame("CheckButton", "ict_maxCount1", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_MaxTarget1Input.tooltip = "Set targets to track to 1. \nNote: Changing count will reload the UI on close."
        ict_MaxTarget1Input:SetPoint("LEFT", iction.TargetOptionsFrame, 20, 0)
        ict_MaxTarget1Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -15)
        ict_MaxTarget1Inputtext = _G["ict_maxCount1Text"]
        ict_MaxTarget1Inputtext:SetText("1")
        if ictionTargetCount == 1 then ict_MaxTarget1Input:SetChecked(true) setCount = 1 end
        ict_MaxTarget1Input:SetScript("OnClick", function()
                                        ict_MaxTarget2Input:SetChecked(false)
                                        ict_MaxTarget3Input:SetChecked(false)
                                        ict_MaxTarget4Input:SetChecked(false)
                                        ictionTargetCount = 1
                                        setCount = 1
                                        end)

        ict_MaxTarget2Input = CreateFrame("CheckButton", "ict_maxCount2", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_MaxTarget2Input.tooltip = "Set targets to track to 2. \nNote: Changing count will reload the UI on close."
        ict_MaxTarget2Input:SetPoint("LEFT", iction.TargetOptionsFrame, 85, 0)
        ict_MaxTarget2Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -15)
        ict_MaxTarget2Inputtext = _G["ict_maxCount2Text"]
        ict_MaxTarget2Inputtext:SetText("2")
        ict_MaxTarget2Input:SetScript("OnClick", function()
                                        ict_MaxTarget1Input:SetChecked(false)
                                        ict_MaxTarget3Input:SetChecked(false)
                                        ict_MaxTarget4Input:SetChecked(false)
                                        ictionTargetCount = 2
                                        setCount = 2
                                        end)
        if ictionTargetCount == 2 then ict_MaxTarget2Input:SetChecked(true) setCount = 2 end

        ict_MaxTarget3Input = CreateFrame("CheckButton", "ict_maxCount3", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_MaxTarget3Input.tooltip = "Set targets to track to 3. \nNote: Changing count will reload the UI on close."
        ict_MaxTarget3Input:SetPoint("LEFT", iction.TargetOptionsFrame, 150, 0)
        ict_MaxTarget3Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -15)
        ict_MaxTarget3Inputtext = _G["ict_maxCount3Text"]
        ict_MaxTarget3Inputtext:SetText("3")
        ict_MaxTarget3Input:SetScript("OnClick", function()
                                        ict_MaxTarget1Input:SetChecked(false)
                                        ict_MaxTarget2Input:SetChecked(false)
                                        ict_MaxTarget4Input:SetChecked(false)
                                        ictionTargetCount = 3
                                        setCount = 3
                                        end)
        if ictionTargetCount == 3 then ict_MaxTarget3Input:SetChecked(true) setCount = 3 end

        ict_MaxTarget4Input = CreateFrame("CheckButton", "ict_maxCount4", iction.TargetOptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_MaxTarget4Input.tooltip = "Set targets to track to 4. \nNote: Changing count will reload the UI on close."
        ict_MaxTarget4Input:SetPoint("LEFT", iction.TargetOptionsFrame, 215, 0)
        ict_MaxTarget4Input:SetPoint("TOP", iction.TargetOptionsFrame, 0, -15)
        ict_MaxTarget4Inputtext = _G["ict_maxCount4Text"]
        ict_MaxTarget4Inputtext:SetText("4")
        ict_MaxTarget4Input:SetScript("OnClick", function()
                                        ict_MaxTarget1Input:SetChecked(false)
                                        ict_MaxTarget2Input:SetChecked(false)
                                        ict_MaxTarget3Input:SetChecked(false)
                                        ictionTargetCount = 4
                                        setCount = 4
                                        end)
        if ictionTargetCount == 4 then ict_MaxTarget4Input:SetChecked(true) setCount = 4 end

        ict_UnlockCBx = CreateFrame("CheckButton", "ict_unlock", iction.OptionsFrame, "ChatConfigCheckButtonTemplate")
        ict_UnlockCBx.tooltip = "Unlock moveable ui elements. Uncheck to lock again."
        ict_UnlockCBx:SetPoint("LEFT", iction.OptionsFrame, 10, 0)
        ict_UnlockCBx:SetPoint("BOTTOM", iction.OptionsFrame, 0, 10)
        ict_UnlockCBxtext = _G["ict_unlockText"]
        ict_UnlockCBxtext:SetText("Unlock UI")
        ict_UnlockCBx:SetScript("OnClick", function()
                                if ict_UnlockCBx:GetChecked() then iction.unlockUIElements(true)
                                else iction.unlockUIElements(false) end
                                end)
        if ictionTargetCount == 4 then ict_MaxTarget4Input:SetChecked(true) setCount = 4 end

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
              fnt:SetText("Close")
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