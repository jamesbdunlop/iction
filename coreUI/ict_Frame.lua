--- Core frame class
local iction = iction
iction.UIFrameElement = {}
iction.UIButtonElement = {}
iction.UISpellScrollFrameElement = {}
------------------------------------------------------------------------------------------------------------------------
--- FRAME
function iction.UIFrameElement.create(self, data)
    self.frameName = data['nameAttr']
    self.data = data
    self.textures = {}
    -- Create the frame --
    self.frame = CreateFrame("Frame", self.data['uiName'], self.data['uiParentFrame'] or UIParent, self.data['uiInherits'])
    self.frame.isMoving = false
    self.frame:SetResizable(true)
    self.frame:SetMovable(self.data['movable'])
    self.frame:EnableMouse(self.data['enableMouse'])
    self.frame:SetUserPlaced(self.data['userPlaced'])
    self.frame:SetClampedToScreen(self.data['SetClampedToScreen'])
    self.frame:SetFrameStrata(self.data['strata'])
    self.frame:SetWidth(self.data['w'])
    self.frame:SetHeight(self.data['h'])
    self.frame:SetAttribute('name', self.data['nameAttr'])
    self.frame:SetBackdropColor(self.data['bgCol']['r'], self.data['bgCol']['g'], self.data['bgCol']['b'], self.data['bgCol']['a'])
    -- Texture
    self.textures = {}
    self.createTextures(self)
    self.frame.texture = self.textures[0]
    self.setPoints(self)
    -- Default fontString
    self.text = self.addFontString(self, "THICKOUTLINE", "OVERLAY", false, "CENTER", 0, 0, 12, .1, 1, .1, 1)
    self.frame:Show()
end

function iction.UIFrameElement.createTextures(self, data)
    local t = self.data['textures']
    local itr = iction.list_iter(t)
    while true do
        local textureData = itr()
        if textureData == nil then break end
        local texture = self.frame:CreateTexture(textureData['name'], textureData['level'])
        -- POINTS
        if textureData['allPoints'] then
            texture:SetAllPoints(textureData['allPoints'])
        else
            texture:SetPoint(textureData['anchorPoint'], textureData['apX'], textureData['apY'])
        end

        -- WIDTH / HEIGHT
        if textureData['w'] then texture:SetWidth(textureData['w']) end
        if textureData['h'] then texture:SetHeight(textureData['h']) end

        -- TEXTURE PATH
        texture:SetTexture(textureData['texture'])
        texture:SetVertexColor(textureData['vr'], textureData['vg'], textureData['vb'], textureData['va'])

        -- ADD TO THE TABLE
        table.insert(self.textures, texture)
    end
end

function iction.UIFrameElement.setTextureVertexColor(self, vtxR, vtxG, vtxB, vtxA)
    -- Will change the vertex color for ALL textures in a frame
    if self.textures then
        local itr = iction.list_iter(self.textures)
        while true do
            local texture = itr()
            if texture == nil then break end
            texture:SetVertexColor(vtxR, vtxG, vtxB, vtxA)
        end
    end
end

function iction.UIFrameElement.setTextureBGColor(self, vtxR, vtxG, vtxB, vtxA)
    -- Will change the vertex backdropColor for the base frame
    self.frame:SetBackdropColor(vtxR, vtxG, vtxB, vtxA)
end

function iction.UIFrameElement.setPoints(self)
    self.frame:ClearAllPoints()
    --------------------------
    --- Position Stuff
    if ictionFramePos[self.frameName] then
        self.data['pointPosition']['point'] = ictionFramePos[self.frameName]["point"]['point']
        self.data['pointPosition']['relativePoint'] = ictionFramePos[self.frameName]["point"]['relativePoint']
        self.data['pointPosition']['p'] = ictionFramePos[self.frameName]["point"]['p']
        self.data['pointPosition']['x'] = ictionFramePos[self.frameName]["point"]['x']
        self.data['pointPosition']['y'] = ictionFramePos[self.frameName]["point"]['y']
    end

    --- Setup the cache for postion
    self.framePosition = {}
    self.frameMoveParent = nil

    local framePos = {point = self.data['pointPosition']['point'],
                      relativeTo = self.data['pointPosition']["relativeTo"],
                      relativePoint = self.data['pointPosition']['relativePoint'],
                      xOfs = self.data['pointPosition']["x"], yOfs = self.data['pointPosition']["y"]}
    self.storePos(self, 'startPos', framePos)
    self.storePos(self, 'startPre', framePos)
    self.storePos(self, 'endPos', framePos)
    --- Set the inital position
    self.frame:SetPoint(self.data['pointPosition']['point'], self.data['pointPosition']["relativeTo"], self.data['pointPosition']["relativePoint"], self.data['pointPosition']["x"], self.data['pointPosition']["y"])
    self.frameMoveParent = self.frame:GetParent()
    if iction.debugUI then print (self.frameName .. " |posx: " .. tostring(self.data['pointPosition']["x"]) .. " |posy: " .. tostring(self.data['pointPosition']["y"]) .. " |pos: " .. tostring(self.data['pointPosition']['point'])) end
end

function iction.UIFrameElement.storePos(self, curPos, data)
    self.framePosition[curPos] = data
end

function iction.UIFrameElement.setMovedPosition(self)
    local deltaX = self.framePosition["startPre"]["xOfs"] - self.framePosition['endPos']["xOfs"]
    local deltaY = self.framePosition["startPre"]["yOfs"] - self.framePosition['endPos']["yOfs"]
    local parentFrame = self.frameMoveParent
    if not self.framePosition["startPos"]['relativeTo'] then
        parentFrame = UIParent
    end

    if iction.debuUI then print(self.frameName .. " set parent to ".. tostring(parentFrame:GetAttribute("name"))) end
    self.frame:SetPoint(self.framePosition["startPos"]["point"],
                        self.frameMoveParent,
                        self.framePosition["startPos"]["relativePoint"],
                        self.framePosition["startPos"]["xOfs"] - deltaX,
                        self.framePosition["startPos"]["yOfs"] - deltaY)
    --- Now set the global position for reload
    ictionFramePos[self.frameName] = {}
    ictionFramePos[self.frameName]["point"] = {}
    ictionFramePos[self.frameName]["point"]['point'] = self.framePosition["startPos"]["point"]
    ictionFramePos[self.frameName]["point"]['x']   = self.framePosition["startPos"]["xOfs"] - deltaX
    ictionFramePos[self.frameName]["point"]['y']   = self.framePosition["startPos"]["yOfs"] - deltaY
    ictionFramePos[self.frameName]["point"]['relativePoint']   = self.framePosition["startPos"]["relativePoint"]
end

function iction.UIFrameElement.setMoveScript(self)
    local StartPoint, StartRelativeTo, StartRelativePoint, startXOfs, startYOfs
    local prePoint, preRelativeTo, preRelativePoint, preXOfs, preYOfs
    local postPoint, postRelativeTo, postRelativePoint, postXOfs, postYOfs
    self.frame:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            StartPoint, StartRelativeTo, StartRelativePoint, startXOfs, startYOfs = self.frame:GetPoint(1)
            if not StartRelativeTo or not StartRelativeTo:GetName() then
                StartRelativeTo = iction_MF -- For some reason the UI can drop the parent frame entirely! so force the MF instead.
            end
            local framePos = {point = StartPoint, relativeTo = StartRelativeTo, relativePoint = StartRelativePoint, xOfs = startXOfs, yOfs = startYOfs}
            self.storePos(self, 'startPos', framePos)

            self.frame:StartMoving()

            prePoint, preRelativeTo, preRelativePoint, preXOfs, preYOfs = self.frame:GetPoint(1)
            local framePos = {point = prePoint, relativeTo = preRelativeTo, relativePoint = preRelativePoint, xOfs = preXOfs, yOfs = preYOfs}
            self.storePos(self, 'startPre', framePos)
        end
    end)

    self.frame:SetScript("OnMouseUp", function(_, button)
        if button == "LeftButton" then
            postPoint, postRelativeTo, postRelativePoint, postXOfs, postYOfs = self.frame:GetPoint(1)
            local framePos = {point = postPoint, relativeTo = postRelativeTo, relativePoint = postRelativePoint, xOfs = postXOfs, yOfs = postYOfs}
            self.storePos(self, 'endPos', framePos)
            self.frame:StopMovingOrSizing()
            self.setMovedPosition(self)
        end
    end)
end

function iction.UIFrameElement.setRemoveMoveScript(self)
    self.frame:SetScript("OnMouseDown", function(_, button)
    end)
    self.frame:SetScript("OnMouseUp", function(_, button)
    end)
    self.frame.isMoving = false
end

function iction.UIFrameElement.setFrameLockState(self, state)
    self.frame:EnableMouse(state)
    self.frame.isMoving = state
end

function iction.UIFrameElement.setVisibility(self, visible)
    if visible then
        self.frame:Show()
        self.setTextureBGColor(self, 1,1,1,1)
        self.setTextureVertexColor(self, 1,1,1,1)
    else
        self.frame:Hide()
        self.setTextureBGColor(self, 0,0,0,0)
        self.setTextureVertexColor(self, 0,0,0,0)
    end
    if iction.debugUI then print("iction.UIFrameElement.setVisibility success!") end
end

function iction.UIFrameElement.addFontString(self, outline, strata, allPoints, anchorPoint, x, y, size, vtxR, vtxG, vtxB, vtxA)
    local Addfnt = self.frame:CreateFontString(nil, strata)
        if allPoints then
            Addfnt:SetAllPoints(true)
        else
            Addfnt:SetPoint(anchorPoint, x, y)
        end
        Addfnt:SetFont(iction.font, size, strata, outline)
        Addfnt:SetFontObject("GameFontWhite")
        Addfnt:SetTextColor(vtxR,vtxG, vtxB, vtxA)
    self.text = Addfnt
    return Addfnt
end

------------------------------------------------------------------------------------------------------------------------
--- BUTTON
function iction.UIButtonElement.create(self, pFrame, data, align, posX, posY)
    --- Extract data
    self.data = data
    self.frameName = self.data['uiName'] -- use this to match activeSpells to as id is fickle
    self.id = self.data['id']  -- note here the spell id from the spell book for corruption is 172 but cast its 146739
    self.rank = self.data['rank']
    self.castingTime = self.data['castingTime']
    self.minRange = self.data['minRange']
    self.maxRange = self.data['maxRange']
    self.icon = self.data['icon']

    self.buttonFrame = CreateFrame("Button", name, pFrame, nil)
    self.buttonFrame:SetFrameStrata("MEDIUM")
    self.buttonFrame:EnableMouse(false)
    self.buttonFrame:SetDisabledFontObject("GameFontDisable")
    self.buttonFrame:SetNormalFontObject("GameFontNormalSmall")
    self.buttonFrame:SetHighlightFontObject("GameFontHighlight")
    self.buttonFrame:SetPoint(align, pFrame, posX, posY)
    self.buttonFrame:SetWidth(iction.bw)
    self.buttonFrame:SetHeight(iction.bh)

    self.texture = self.buttonFrame:CreateTexture(nil, "ARTWORK")
        self.texture:SetAllPoints(true)
        self.texture:SetTexture(self.icon)
        self.texture:SetVertexColor(0.9,0.3,0.3, .5)
    -- Create the fontString for the button
    self.text = self.addFontString(self, "THICKOUTLINE", "OVERLAY", false, "CENTER", 0, 0, 24, .1, 1, .1, 1)
end

function iction.UIButtonElement.addCountFrame(self)
    self.countFrame = self.frame:CreateTexture(self.frameName .. "_count", "MEDIUM")
    self.countFrame:EnableMouse(false)
    self.buttonFrame:SetPoint("RIGHT", self.buttonFrame, iction.bw, iction.bh)
    self.buttonFrame:SetWidth(16)
    self.buttonFrame:SetHeight(16)
end

function iction.UIButtonElement.addFontString(self, outline, strata, allPoints, anchorPoint, x, y, size, vtxR, vtxG, vtxB, vtxA)
    local Addfnt = self.buttonFrame:CreateFontString(nil, strata)
        if allPoints then
            Addfnt:SetAllPoints(true)
        else
            Addfnt:SetPoint(anchorPoint, x, y)
        end
        Addfnt:SetFont(iction.font, size, strata, outline)
        Addfnt:SetFontObject("GameFontWhite")
        Addfnt:SetTextColor(vtxR,vtxG, vtxB, vtxA)
    return Addfnt
end

function iction.UIButtonElement.setButtonState(self, active, hidden, refresh, procced)
    if active and not refresh and not procced then
        self.buttonFrame:SetBackdropColor(1, 1, 1, 1)
        self.texture:SetVertexColor(0.9,0.9,0.9, .9)
    elseif hidden then
        self.buttonFrame:SetBackdropColor(0,0,0, 0)
        self.texture:SetVertexColor(0,0,0, 0)
    elseif active and refresh then
        self.buttonFrame:SetBackdropColor(1, 1, 1, 1)
        self.texture:SetVertexColor(1, 0, 0, 1)
    elseif active and procced then
        self.buttonFrame:SetBackdropColor(1, 1, .1, 1)
        self.texture:SetVertexColor(1, 1, .1, 1)
    else
        self.buttonFrame:SetBackdropColor(1, 1, 1, 1)
        self.texture:SetVertexColor(0.9,0.3,0.3, .5)
    end
end

function iction.UIButtonElement.setButtonColor(self, color)
    self.text:SetTextColor(color[1], color[2], color[3], color[4])
end

------------------------------------------------------------------------------------------------------------------------
--- OPTIONS SCROLL FRAME

function iction.UISpellScrollFrameElement.create(self, data)
    self.frameName = data['nameAttr']
    self.data = data
    self.textures = {}
    -- Create the frame --
    self.scrollframe = CreateFrame("ScrollFrame", self.data['uiName'], self.data['uiParentFrame'] or UIParent, self.data['uiInherits'])
    self.frame = CreateFrame("Frame", 'SpellList',  self.scrollframe)
    self.scrollframe:SetScrollChild(self.frame)
    self.scrollframe:SetWidth(self.data['w'])
    self.scrollframe:SetHeight(self.data['h'])

    self.setScrollPoints(self)
    self.setPoints(self)

    self.frame.isMoving = false
    self.frame:EnableMouse(self.data['enableMouse'])
    self.frame:SetClampedToScreen(self.data['SetClampedToScreen'])
    self.frame:SetFrameStrata(self.data['strata'])
    self.frame:SetWidth(self.data['w'])
    self.frame:SetHeight(self.data['h'])
    self.frame:SetAttribute('name', self.data['nameAttr'])
    self.frame:SetBackdropColor(self.data['bgCol']['r'], self.data['bgCol']['g'], self.data['bgCol']['b'], self.data['bgCol']['a'])
    -- Texture
    self.textures = {}
    self.createTextures(self)
    self.frame.texture = self.textures[0]
    -- Default fontString
    self.frame:Show()
    self.scrollframe:Show()
end

function iction.UISpellScrollFrameElement.addItems(self, t)
    local spellList = iction.list_iter(t)
    local y = 0
    local h = 0
    while true do
        local spellInfo, i = spellList()
        if not spellInfo then break end
        local spellCheckBox = CreateFrame("CheckButton", "spellOptionsButton_"..spellInfo['id'], self.frame, "OptionsSmallCheckButtonTemplate")
            if i == 1 then
                spellCheckBox:SetPoint("TOPLEFT", self.frame)
            else
                spellCheckBox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, y)
            end
            spellCheckBox:SetWidth(24)
            spellCheckBox:SetHeight(24)

            spellCheckBox:SetScript("OnClick", function(self)
                                        if self:GetChecked() then
                                            table.insert(ictionValidSpells, spellInfo['id'])
                                        else
                                            table.remove(ictionValidSpells, spellInfo['id'])
                                        end
                                    end)
            if iction.validSpellID(spellInfo['id']) then spellCheckBox:SetChecked(true) end

        local fnt = self.frame:CreateFontString("spellOptionsLabel_"..spellInfo['id'], 'OVERLAY')
            fnt:SetFont(iction.font, 14, 'OVERLAY', 'THICKOUTLINE')
            fnt:SetFontObject("GameFontWhite")
            fnt:SetTextColor(1,1, 1, 1)
            fnt:SetText(spellInfo['uiName'])
            if i == 1 then
                fnt:SetPoint("TOPLEFT", self.frame, 24, -4)  -- anchors the first string, parent should be the content frame
            else
                fnt:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 24, y-4)
            end
        y = y -26
        h = h +26
    end
    self.scrollframe:SetMaxResize(300, h)
    self.frame:SetHeight(h)
end

function iction.UISpellScrollFrameElement.createTextures(self, data)
    local t = self.data['textures']
    local itr = iction.list_iter(t)
    while true do
        local textureData = itr()
        if textureData == nil then break end
        local texture = self.frame:CreateTexture(textureData['name'], textureData['level'])
        -- POINTS
        if textureData['allPoints'] then
            texture:SetAllPoints(textureData['allPoints'])
        else
            texture:SetPoint(textureData['anchorPoint'], textureData['apX'], textureData['apY'])
        end

        -- WIDTH / HEIGHT
        if textureData['w'] then texture:SetWidth(textureData['w']) end
        if textureData['h'] then texture:SetHeight(textureData['h']) end

        -- TEXTURE PATH
        texture:SetTexture(textureData['texture'])
        texture:SetVertexColor(textureData['vr'], textureData['vg'], textureData['vb'], textureData['va'])

        -- ADD TO THE TABLE
        table.insert(self.textures, texture)
    end
end

function iction.UISpellScrollFrameElement.setScrollPoints(self)
    self.scrollframe:ClearAllPoints()
    --------------------------
    --- Position Stuff
    if ictionFramePos[self.frameName] then
        self.data['pointPosition']['point'] = ictionFramePos[self.frameName]["point"]['point']
        self.data['pointPosition']['relativePoint'] = ictionFramePos[self.frameName]["point"]['relativePoint']
        self.data['pointPosition']['p'] = ictionFramePos[self.frameName]["point"]['p']
        self.data['pointPosition']['x'] = ictionFramePos[self.frameName]["point"]['x']
        self.data['pointPosition']['y'] = ictionFramePos[self.frameName]["point"]['y']
    end

    --- Setup the cache for postion
    self.framePosition = {}
    self.frameMoveParent = nil

    local framePos = {point = self.data['pointPosition']['point'],
                      relativeTo = self.data['pointPosition']["relativeTo"],
                      relativePoint = self.data['pointPosition']['relativePoint'],
                      xOfs = self.data['pointPosition']["x"], yOfs = self.data['pointPosition']["y"]}
    self.storePos(self, 'startPos', framePos)
    self.storePos(self, 'startPre', framePos)
    self.storePos(self, 'endPos', framePos)
    --- Set the inital position
    self.scrollframe:SetPoint(self.data['pointPosition']['point'], self.data['pointPosition']["relativeTo"], self.data['pointPosition']["relativePoint"], self.data['pointPosition']["x"], self.data['pointPosition']["y"])
    self.frameMoveParent = self.scrollframe:GetParent()
    if iction.debugUI then print (self.frameName .. " |posx: " .. tostring(self.data['pointPosition']["x"]) .. " |posy: " .. tostring(self.data['pointPosition']["y"]) .. " |pos: " .. tostring(self.data['pointPosition']['point'])) end
end

function iction.UISpellScrollFrameElement.setPoints(self)
    self.frame:ClearAllPoints()
    --------------------------
    --- Position Stuff
    if ictionFramePos[self.frameName] then
        self.data['pointPosition']['point'] = ictionFramePos[self.frameName]["point"]['point']
        self.data['pointPosition']['relativePoint'] = ictionFramePos[self.frameName]["point"]['relativePoint']
        self.data['pointPosition']['p'] = ictionFramePos[self.frameName]["point"]['p']
        self.data['pointPosition']['x'] = ictionFramePos[self.frameName]["point"]['x']
        self.data['pointPosition']['y'] = ictionFramePos[self.frameName]["point"]['y']
    end

    --- Setup the cache for postion
    self.framePosition = {}
    self.frameMoveParent = nil

    local framePos = {point = self.data['pointPosition']['point'],
                      relativeTo = self.data['pointPosition']["relativeTo"],
                      relativePoint = self.data['pointPosition']['relativePoint'],
                      xOfs = self.data['pointPosition']["x"], yOfs = self.data['pointPosition']["y"]}
    self.storePos(self, 'startPos', framePos)
    self.storePos(self, 'startPre', framePos)
    self.storePos(self, 'endPos', framePos)
    --- Set the inital position
    self.frame:SetPoint(self.data['pointPosition']['point'], self.data['pointPosition']["relativeTo"], self.data['pointPosition']["relativePoint"], self.data['pointPosition']["x"], self.data['pointPosition']["y"])
    self.frameMoveParent = self.frame:GetParent()
    if iction.debugUI then print (self.frameName .. " |posx: " .. tostring(self.data['pointPosition']["x"]) .. " |posy: " .. tostring(self.data['pointPosition']["y"]) .. " |pos: " .. tostring(self.data['pointPosition']['point'])) end
end

function iction.UISpellScrollFrameElement.storePos(self, curPos, data)
    self.framePosition[curPos] = data
end

function iction.UISpellScrollFrameElement.setMovedPosition(self)
    local deltaX = self.framePosition["startPre"]["xOfs"] - self.framePosition['endPos']["xOfs"]
    local deltaY = self.framePosition["startPre"]["yOfs"] - self.framePosition['endPos']["yOfs"]
    local parentFrame = self.frameMoveParent
    if not self.framePosition["startPos"]['relativeTo'] then
        parentFrame = UIParent
    end

    if iction.debuUI then print(self.frameName .. " set parent to ".. tostring(parentFrame:GetAttribute("name"))) end
    self.frame:SetPoint(self.framePosition["startPos"]["point"],
                        self.frameMoveParent,
                        self.framePosition["startPos"]["relativePoint"],
                        self.framePosition["startPos"]["xOfs"] - deltaX,
                        self.framePosition["startPos"]["yOfs"] - deltaY)
    --- Now set the global position for reload
    ictionFramePos[self.frameName] = {}
    ictionFramePos[self.frameName]["point"] = {}
    ictionFramePos[self.frameName]["point"]['point'] = self.framePosition["startPos"]["point"]
    ictionFramePos[self.frameName]["point"]['x']   = self.framePosition["startPos"]["xOfs"] - deltaX
    ictionFramePos[self.frameName]["point"]['y']   = self.framePosition["startPos"]["yOfs"] - deltaY
    ictionFramePos[self.frameName]["point"]['relativePoint']   = self.framePosition["startPos"]["relativePoint"]
end

function iction.UISpellScrollFrameElement.setMoveScript(self)
    local StartPoint, StartRelativeTo, StartRelativePoint, startXOfs, startYOfs
    local prePoint, preRelativeTo, preRelativePoint, preXOfs, preYOfs
    local postPoint, postRelativeTo, postRelativePoint, postXOfs, postYOfs
    self.frame:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            StartPoint, StartRelativeTo, StartRelativePoint, startXOfs, startYOfs = self.frame:GetPoint(1)
            if not StartRelativeTo or not StartRelativeTo:GetName() then
                StartRelativeTo = iction_MF -- For some reason the UI can drop the parent frame entirely! so force the MF instead.
            end
            local framePos = {point = StartPoint, relativeTo = StartRelativeTo, relativePoint = StartRelativePoint, xOfs = startXOfs, yOfs = startYOfs}
            self.storePos(self, 'startPos', framePos)

            self.frame:StartMoving()

            prePoint, preRelativeTo, preRelativePoint, preXOfs, preYOfs = self.frame:GetPoint(1)
            local framePos = {point = prePoint, relativeTo = preRelativeTo, relativePoint = preRelativePoint, xOfs = preXOfs, yOfs = preYOfs}
            self.storePos(self, 'startPre', framePos)
        end
    end)

    self.frame:SetScript("OnMouseUp", function(_, button)
        if button == "LeftButton" then
            postPoint, postRelativeTo, postRelativePoint, postXOfs, postYOfs = self.frame:GetPoint(1)
            local framePos = {point = postPoint, relativeTo = postRelativeTo, relativePoint = postRelativePoint, xOfs = postXOfs, yOfs = postYOfs}
            self.storePos(self, 'endPos', framePos)
            self.frame:StopMovingOrSizing()
            self.setMovedPosition(self)
        end
    end)
end
