local iction = iction
local frameW = 300
local frameH = 450
local optionsBoxTop = -(frameH * .21)
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
    local artifact = iction.artifact()

    local function closeOptionsUI()
        if iction.optionsFrameBldr and iction.optionsFrameBldr.frame then
            iction.optionsFrameBldr.frame:Hide()
            iction.allSpellsListFrameBldr.frame:Hide()
            iction.allSpellsListFrameBldr.scrollframe:Hide()
            iction.allSpellsListFrameBldr = {}
            iction.optionsFrameBldr = {}
        end
    end

    local function createOptionsFrame()
        closeOptionsUI()
        local optionsData = iction.ictOptionsFrameData
              optionsData['h'] = frameH
              optionsData['w'] = frameW
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
              allSpellsData['h'] = frameH

        iction.allSpellsListFrameBldr = {}
            setmetatable(iction.allSpellsListFrameBldr, {__index = iction.UISpellScrollFrameElement})
            iction.allSpellsListFrameBldr.create(iction.allSpellsListFrameBldr, allSpellsData)
            iction.allSpellsListFrameBldr.addItems(iction.allSpellsListFrameBldr, iction.getAllSpells())
    end
    listAllSpells()

    local function createMaxTargetsOptions()
        local columnData = iction.ictColumnCheckBoxListFrameData
              columnData['pointPosition']['relativeTo'] = iction.optionsFrameBldr.frame

        iction.optionsTargetListFrameBldr = {}
            setmetatable(iction.optionsTargetListFrameBldr, {__index = iction.UICheckBoxListFrameElement})
            iction.optionsTargetListFrameBldr.create(iction.optionsTargetListFrameBldr, columnData)

        local items = { [0]=nil,
                        [1] = {label = 'ict_maxCount1'},
                        [2] = {label = 'ict_maxCount2'},
                        [3] = {label = 'ict_maxCount3'},
                        [4] = {label = 'ict_maxCount4'}
                      }
        iction.optionsTargetListFrameBldr.addItems(iction.optionsTargetListFrameBldr, items)
    end
    createMaxTargetsOptions()

    local function createSkinOptions()
         local skinData = iction.ictSkinListFrameData
              skinData['pointPosition']['relativeTo'] = iction.optionsFrameBldr.frame

        iction.optionsSkinListFrameBldr = {}
            setmetatable(iction.optionsSkinListFrameBldr, {__index = iction.UICheckBoxListFrameElement})
            iction.optionsSkinListFrameBldr.create(iction.optionsSkinListFrameBldr, skinData)

        local items = { [0]=nil,
                        [1] = {label = 'skin1'},
                        [2] = {label = 'skin2'},
                        [3] = {label = 'skin3'},
                        [4] = {label = 'skin4'}
                      }
        iction.optionsSkinListFrameBldr.addItems(iction.optionsSkinListFrameBldr, items)
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

    if iction.class == iction.L['Priest'] and iction.spec == 3 then
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
                                iction.SWDFrameBldr.frame:SetScale(tonumber(string.format("%.1f", event)))
                                iction.ict_swdIDXScaleLabel:SetText(string.format("%.1f", ictionSWDScale))
                                end)
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
                                iction.voidFrameBldr.frame:SetScale(tonumber(string.format("%.1f", event)))
                                iction.ict_voidBoltIDXScaleLabel:SetText(string.format("%.1f", ictionVoidBoltScale))
                                end)
        end
        createSWDOptions()
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
        closeOptionsUI()
        if setCount ~= curTgtCnt then ReloadUI() end
    end)
    iction.optionsFrameBldr.frame:Show()
end