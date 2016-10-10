--- Core frame class
local iction = iction
iction.UIElement = {}
local ictDefaultFrameData = {uiType = "Frame",
                            uiName = "TestFrame",
                            nameAttr = "TestName",
                            uiParentFrame = iction.ictionMF,
                            uiInherits = nil,
                            userPlaced = true,
                            movable = true,
                            enableMouse = false,
                            SetClampedToScreen = true,
                            w = 50,
                            h = 50,
                            bgCol = {r = 0, g = 1, b= 0, a = 0},
                            strata = "HIGH",
                            texture = {name = nil, allPoints = true,
                                       texture= "Interface\\ChatFrame\\ChatFrameBackground",
                                       vr = 1, vg = 1, vb = 1, va = 1, level = "ARTWORK" },
                            point = {pos = "TOP", p = iction.ictionMF, x = 10, y = 0}
                            }

function iction.UIElement.create(self, data)
    local attrName = data['nameAttr']
    if not ictionFramePos[attrName] then
        ictionFramePos[attrName] = {}
        ictionFramePos[attrName]["point"] = {}
        ictionFramePos[attrName]["point"]['pos'] = data["point"]['pos']
        ictionFramePos[attrName]["point"]['x']   = data["point"]['x']
        ictionFramePos[attrName]["point"]['y']   = data["point"]['y']
    else
        data["point"]['pos'] = ictionFramePos[attrName]["point"]['pos']
        data["point"]['x']   = ictionFramePos[attrName]["point"]['x']
        data["point"]['y']   = ictionFramePos[attrName]["point"]['y']
    end
    self.data = data
    -- Create the frame
    self.frame = CreateFrame(self.data['uiType'], self.data['uiName'], self.data['uiParentFrame'] or UIParent, self.data['uiInherits'])
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
    return self.frame
end

function iction.UIElement.createTexture(self, data)
    local textureData = data
    self.FTexture = self.frame:CreateTexture(textureData['name'], textureData['level'])
    self.FTexture:SetAllPoints(textureData['allPoints'])
    self.FTexture:SetTexture(textureData['texture'])
    self.FTexture:SetVertexColor(textureData['vr'], textureData['vg'], textureData['vb'], textureData['va'])
    return self.FTexture
end

function iction.UIElement.setBaseTexturePath(self, texturePath)
    self.data['texture']['texture'] = texturePath
    self.FTexture:SetTexture(texturePath)
end

function iction.UIElement.setPoints(self)
    local attrName = self.data['nameAttr']
    print('Setting point for ' ..  attrName)
    self.frame:ClearAllPoints()
    self.frame:SetPoint(self.data["point"]['pos'], self.data["point"]['p'], self.data["point"]['x'], self.data["point"]['y'])
end

function iction.UIElement.setMoveScript(self, f, relativeF)
    local fname = f:GetAttribute("name")
    ---Note this works on setting the move action on f not self so if you want to move the same frame self and f should be the same ---
    self:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not f.isMoving then
            f:StartMoving();
            f.isMoving = true;
        end
    end)
    self:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and f.isMoving then
            f:StopMovingOrSizing();
            f.isMoving = false;
            if relativeF then
               local point, relativeTo, relativePoint, xOffset, yOffset = f:GetPoint(1)
               local MFpoint, MFrelativeTo, MFrelativePoint, MFxOffset, MFyOffset = relativeF:GetPoint(1)
               ictionFramePos[fname]['point']['x'] = xOffset-MFxOffset
               ictionFramePos[fname]['point']['y'] = yOffset-MFyOffset
               ictionFramePos[fname]['point']['pos'] = "CENTER"
               f:SetPoint(ictionFramePos[fname]['point']['pos'], relativeF, ictionFramePos[fname]['point']['x'], ictionFramePos[fname]['point']['y'])
            end
        end
    end)
end

function iction.UIElement.addTexture(self, name, w, h, strata, allPoints, anchorPoint, x, y, texturePath, vtxR, vtxG, vtxB, vtxA)
    local AddTextre = self:CreateTexture(name, strata)
        if allPoints then
            AddTextre:SetAllPoints(true)
        else
            AddTextre:SetPoint(anchorPoint, x, y)
        end
        AddTextre:SetWidth(w)
        AddTextre:SetHeight(h)
        AddTextre:SetTexture(texturePath)
        AddTextre:SetVertexColor(vtxR, vtxG, vtxB, vtxA)
    self.texture = AddTextre
    return AddTextre
end

function iction.UIElement.addFontSring(self, outline, strata, allPoints, anchorPoint, x, y, size, vtxR, vtxG, vtxB, vtxA)
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