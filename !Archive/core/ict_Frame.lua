--- Core frame class
local iction = iction
iction.UIFrameElement = {}
iction.UIButtonElement = {}
------------------------------------------------------------------------------------------------------------------------
--- FRAME
function iction.UIFrameElement.create(self, data)
    local attrName = data['nameAttr']
    if not ictionFramePos[attrName] then
        ictionFramePos[attrName] = {}
        ictionFramePos[attrName]["point"] = {}
        ictionFramePos[attrName]["point"]['pos'] = data['pointPosition']['pos']
        ictionFramePos[attrName]["point"]['x']   = data['pointPosition']['x']
        ictionFramePos[attrName]["point"]['y']   = data['pointPosition']['y']
    else
        data['pointPosition']['pos'] = ictionFramePos[attrName]["point"]['pos']
        data['pointPosition']['x'] = ictionFramePos[attrName]["point"]['x']
        data['pointPosition']['y'] = ictionFramePos[attrName]["point"]['y']
    end
    self.data = data
    self.textures = {}
    -- Create the frame --
    local f = CreateFrame(self.data['uiType'], self.data['uiName'], self.data['uiParentFrame'] or UIParent, self.data['uiInherits'])
    self.frame = f
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
    self.texture = self.createTexture(self, self.data['texture'])
    self.frame.texture = self.texture
    self.text = self.frame:addFontString(self, "THICKOUTLINE", "OVERLAY", false, "CENTER", 0, 0, 24, .1, 1, .1, 1)
    self.text:SetText(self.frameName)
    self.frame:Show()
end

function iction.UIFrameElement.createTexture(self, data)
    local textureData = data
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
    local attrName = self.data['nameAttr']
    self.frame:ClearAllPoints()
    self.frame:SetPoint(self.data['pointPosition']["pos"], self.data['pointPosition']["p"], self.data['pointPosition']["x"], self.data['pointPosition']["y"])
end

function iction.UIFrameElement.setMoveScript(self, relativeF)
    local fname = self.frame:GetAttribute("name")
    local frame = self.frame
    ---Note this works on setting the move action on f not self so if you want to move the same frame self and f should be the same ---
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not frame.isMoving then
            frame:StartMoving()
            frame.isMoving = true
        end
    end)

    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and frame.isMoving then
            frame:StopMovingOrSizing()
            frame.isMoving = false
            if relativeF then
               local point, relativeTo, relativePoint, xOffset, yOffset = frame:GetPoint(1)
               local MFpoint, MFrelativeTo, MFrelativePoint, MFxOffset, MFyOffset = relativeF:GetPoint(1)
               ictionFramePos[fname]['point']['x'] = xOffset-MFxOffset
               ictionFramePos[fname]['point']['y'] = yOffset-MFyOffset
               ictionFramePos[fname]['point']['pos'] = "CENTER"
               frame:SetPoint(ictionFramePos[fname]['point']['pos'], relativeF, ictionFramePos[fname]['point']['x'], ictionFramePos[fname]['point']['y'])
            end
        end
    end)
end

function iction.UIFrameElement.setFrameLockState(self, state)
    if state == 'unlocked' then
        self.frame:EnableMouse(true)
        self.frame:SetParent(iction.mainFrameBldr.frame)
    else
        self.frame:EnableMouse(false)
        self.frame:SetParent(iction.mainFrameBldr.frame)
    end
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

    return Addfnt
end

function iction.UIFrameElement.__tostring(self)
    return self.frame:GetAttribute('name')
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

function iction.UIButtonElement.addFontString (self, outline, strata, allPoints, anchorPoint, x, y, size, vtxR, vtxG, vtxB, vtxA)
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