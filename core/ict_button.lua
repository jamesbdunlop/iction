----------------------------------------------------------------------------------------------
--- BUTTON GENERATOR -------------------------------------------------------------------------
function iction.buttonBuild(pFrame, guid, buttons, paddingX, paddingY, buff)
    -- Create an empty button table
    local buttonFrames = {}
    local buttonText = {}
    for key, value in pairs(buttons) do
        if value['vis'] then
            local spellID = value['id']
            -- Create the button frame
            if iction.debug then print("Creating button for " .. value['name']) end
            local b = CreateFrame("Button", value['name'], pFrame, value["inherits"])
                  b:SetAttribute("name", value['id'])
                  b:SetFrameStrata("MEDIUM")
                  b:EnableMouse(false)
                  b:SetDisabledFontObject("GameFontDisable")
                  b:SetNormalFontObject("GameFontNormalSmall");
                  b:SetHighlightFontObject("GameFontHighlight");
                  b:SetWidth(iction.bw)
                  b:SetHeight(iction.bh)
                  b:SetPoint("BOTTOM", pFrame, paddingX, paddingY)
            local but = b:CreateTexture(nil, "ARTWORK")
                  but:SetAllPoints(true)
                  if value['id'] == nil then
                      but:SetTexture(value['icon'])
                  else
                     local file_id = GetSpellTexture(value['id'])
                      but:SetTexture(file_id)
                 end
                  but:SetVertexColor(0.9,0.3,0.3, .5)
            b.texture = but
            -- Create the fontString for the button
            local fnt = b:CreateFontString(nil, "OVERLAY","GameFontGreen")
                  fnt:SetFont(iction.font, 24, "OVERLAY", "THICKOUTLINE")
                  fnt:SetPoint("CENTER", b, 0, 0)
                  fnt:SetTextColor(.1, 1, .1, 1)
            b.text = fnt

            if ictionBuffBarBarH and buff then
                b:SetPoint("LEFT", pFrame, paddingX, paddingY)
                paddingY = paddingY
                paddingX = paddingX + iction.bh + iction.ictionButtonFramePad
            else
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

