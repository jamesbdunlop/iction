----------------------------------------------------------------------------------------------
--- BUTTON GENERATOR -------------------------------------------------------------------------
function iction.buttonBuild(pFrame, guid, buttons, paddingX, paddingY, buff)
    -- Create an empty button table
    local buttonFrames = {}
    local buttonText = {}

    for key, value in pairs(buttons) do
        if value['vis'] then
            -- Create the button frame
            if iction.debug then print("Creating button for " .. value['name']) end
            local b = CreateFrame("Button", value['name'], pFrame, value["inherits"])
                  b:SetAttribute("name", value['name'])
                  b:SetFrameStrata("MEDIUM")
                  b:SetDisabledFontObject("GameFontDisable")
                  b:SetNormalFontObject("GameFontNormalSmall");
                  b:SetHighlightFontObject("GameFontHighlight");
                  b:SetWidth(iction.bw)
                  b:SetHeight(iction.bh)
                  b:SetPoint("BOTTOM", pFrame, paddingX, paddingY)
                  b:RegisterForClicks("AnyUp");
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
                  fnt:SetFont(iction.font, 28, "OVERLAY", "THICKOUTLINE")
                  fnt:SetPoint("CENTER", b, 0, 0)
                  fnt:SetTextColor(.1, 1, .1, 1)
            b.text = fnt

            if iction.buffFrameHorizontal and buff then
                b:SetPoint("LEFT", pFrame, paddingX, paddingY)
                paddingY = paddingY
                paddingX = paddingX + iction.bh
            else
                paddingY = paddingY + iction.bh
                paddingX = paddingX
            end
            -- Add the button the the creatures button table
            buttonFrames[value['name']] = b
            buttonText[value['name']] = fnt
        end
    end
    return buttonFrames, buttonText
end

