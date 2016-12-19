----------------------------------------------------------------------------------------------
--- BUTTON GENERATOR -------------------------------------------------------------------------
function iction.buttonBuild(pFrame, guid, buttons, paddingX, paddingY, buff, fontSize)
    if iction.debug then print("buttonBuild") end
    -- Create an empty button table
    local buttonFrames = {}
    local buttonText = {}
    if not fontSize then fontSize = 24 end
    for key, value in pairs(buttons) do
        if value['vis'] then
            local spellID = value['id']
            -- Create the button frame
            local fPFrame = pFrame
            local bw = iction.bw
            local bh = iction.bh
                local b = CreateFrame("Button", value['name'], fPFrame, value["inherits"])
                  b:SetAttribute("name", value['id'])
                  b:SetAttribute("spellName", value['name'])
                  b:SetFrameStrata("MEDIUM")
                  b:EnableMouse(false)
                  b:SetDisabledFontObject("GameFontDisable")
                  b:SetNormalFontObject("GameFontNormalSmall");
                  b:SetHighlightFontObject("GameFontHighlight");
                  b:SetWidth(bw)
                  b:SetHeight(bh)
                  if not buff then
                    b:SetPoint("BOTTOM", fPFrame, paddingX, paddingY)
                  end
            local but = b:CreateTexture(nil, "ARTWORK")
                  but:SetAllPoints(true)
                  local file_id = GetSpellTexture(value['id'])
                  but:SetTexture(file_id)
                  but:SetVertexColor(0.9,0.3,0.3, .5)

            b.texture = but
            -- Create the fontString for the button
            local fnt = b:CreateFontString(nil, "OVERLAY","GameFontGreen")
                  fnt:SetFont(iction.font, fontSize, "OVERLAY", "THICKOUTLINE")
                  fnt:SetPoint("CENTER", b, 0, 0)
                  fnt:SetTextColor(.1, 1, .1, 1)
            b.text = fnt

            if ictionBuffBarBarH and buff then
                b:SetPoint("LEFT", fPFrame, paddingX, 20)
                paddingY = paddingY
                paddingX = paddingX + iction.bh + iction.ictionButtonFramePad
            elseif not  ictionBuffBarBarH and buff then
                 b:SetPoint("Bottom", fPFrame, paddingX, paddingY)
                paddingY = paddingY + iction.bh + iction.ictionButtonFramePad
                paddingX = paddingX
            end
            -- Add the button the the creatures button table
            buttonFrames[spellID] = b
            buttonText[spellID] = fnt
        end
    end
    return buttonFrames, buttonText
end

