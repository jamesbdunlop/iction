--- Core frame class
local iction = iction
iction.UIFrameElement = {}
iction.UIButtonElement = {}
------------------------------------------------------------------------------------------------------------------------
--- FRAME
function iction.UIFrameElement.create(self, data)
    self.frameName = data['nameAttr']
    self.data = data
    self.textures = {}
    -- Create the frame --
    self.frame = CreateFrame(self.data['uiType'], self.data['uiName'], self.data['uiParentFrame'] or UIParent, self.data['uiInherits'])
    self.frame.isMoving = false
    self.setPoints(self)
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
    self.frame.texture = self.createTexture(self)
    self.setPoints(self)
    self.frame:Show()


end

function iction.UIFrameElement.createTexture(self)
    local textureData = self.data['texture']
    self.FTexture = self.frame:CreateTexture(textureData['name'], textureData['level'])
    self.FTexture:SetAllPoints(textureData['allPoints'])
    self.FTexture:SetTexture(textureData['texture'])
    self.FTexture:SetVertexColor(textureData['vr'], textureData['vg'], textureData['vb'], textureData['va'])
    table.insert(self.textures, self.FTexture)
    return self.FTexture
end

function iction.UIFrameElement.setTextureVertexColor(self, vtxR, vtxG, vtxB, vtxA)
    -- Will change the vertex color for ALL textures in a frame
    if self.textures then
        for _, t in pairs(self.textures) do
            if t ~= nil then
                t:SetVertexColor(vtxR, vtxG, vtxB, vtxA)
            end
    end end
end

function iction.UIFrameElement.setTextureBGColor(self, vtxR, vtxG, vtxB, vtxA)
    -- Will change the vertex backdropColor for the frame
    self.frame:SetBackdropColor(vtxR, vtxG, vtxB, vtxA)
end

function iction.UIFrameElement.setBaseTexturePath(self, texturePath)
    self.data['texture']['texture'] = texturePath
    self.FTexture:SetTexture(texturePath)
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
    self.frame:SetPoint(self.data['pointPosition']['point'],
                        self.data['pointPosition']["relativeTo"],
                        self.data['pointPosition']["relativePoint"],
                        self.data['pointPosition']["x"],
                        self.data['pointPosition']["y"])
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

function iction.UIFrameElement.addTexture(self, name, w, h, strata, allPoints, anchorPoint, x, y, texturePath, vtxR, vtxG, vtxB, vtxA)
    local addT = self.frame:CreateTexture(name, strata)
        if allPoints then
            addT:SetAllPoints(true)
        else
            addT:SetPoint(anchorPoint, x, y)
        end
        addT:SetWidth(w)
        addT:SetHeight(h)
        addT:SetTexture(texturePath)
        addT:SetVertexColor(vtxR, vtxG, vtxB, vtxA)
    return addT
end

function iction.UIFrameElement.addFontSring(self, outline, strata, allPoints, anchorPoint, x, y, size, vtxR, vtxG, vtxB, vtxA)
    local Addfnt = self:CreateFontString(nil, strata)
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
    local name = self.data['name']
    local id = self.data['id']
    local rank = self.data['rank']
    local castingTime = self.data['castingTime']
    local minRange = self.data['minRange']
    local maxRange = self.data['maxRange']
    local icon = self.data['icon']
    local insert = self.data['insert']
    local isArtifact = self.data['isArtifact']
    local isTalentSpell = self.data['isTalentSpell']
    local vis = self.data['vis']

    local butParentFrame = pFrame
    local bw = iction.bw
    local bh = iction.bh
    local b = CreateFrame("Button", name, butParentFrame, nil)
      b:SetAttribute("name", id)
      b:SetAttribute("id", id)
      b:SetAttribute("spellName", name)
      b:SetFrameStrata("MEDIUM")
      b:EnableMouse(false)
      b:SetDisabledFontObject("GameFontDisable")
      b:SetNormalFontObject("GameFontNormalSmall");
      b:SetHighlightFontObject("GameFontHighlight");
      b:SetPoint(align, butParentFrame, posX, posY)
      b:SetWidth(bw)
      b:SetHeight(bh)
    local but = b:CreateTexture(nil, "ARTWORK")
          but:SetAllPoints(true)
          but:SetTexture(icon)
          but:SetVertexColor(0.9,0.3,0.3, .5)
    b.texture = but
    -- Create the fontString for the button
    local fnt = self.addFontString(b, "THICKOUTLINE", "OVERLAY", false, "CENTER", 0, 0, 24, .1, 1, .1, 1)
    return b, fnt
end

function iction.UIButtonElement.addFontString(self, outline, strata, allPoints, anchorPoint, x, y, size, vtxR, vtxG, vtxB, vtxA)
    local Addfnt = self:CreateFontString(nil, strata)
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

function iction.UIButtonElement.setButtonState(self, active, hidden, refresh, procced)
    if active and not refresh and not procced then
        self:SetBackdropColor(1, 1, 1, 1)
        self.texture:SetVertexColor(0.9,0.9,0.9, .9)
    elseif hidden then
        self:SetBackdropColor(0,0,0, 0)
        self.texture:SetVertexColor(0,0,0, 0)
    elseif active and refresh then
        self:SetBackdropColor(1, 1, 1, 1)
        self.texture:SetVertexColor(1, 0, 0, 1)
    elseif active and procced then
        self:SetBackdropColor(1, 1, .1, 1)
        self.texture:SetVertexColor(1, 1, .1, 1)
    else
        self:SetBackdropColor(1, 1, 1, 1)
        self.texture:SetVertexColor(0.9,0.3,0.3, .5)
    end
end

function iction.UIButtonElement.setButtonText(self, text, hidden, colorize, color)
    if hidden == true then
        self:SetText("")
    else
        self:SetText(text)
        if colorize then
            self:SetTextColor(color[1], color[2], color[3], color[4])
        else
            self:SetTextColor(.1, 1, .1, 1)
        end
    end
end

function iction.UIButtonElement.setButtonColor(self, color)
    self:SetTextColor(color[1], color[2], color[3], color[4])
end