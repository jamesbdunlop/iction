----------------------------------------------------------------------------------------------
--- BUTTON GENERATOR -------------------------------------------------------------------------
function iction.addButtons(pFrame, guid, buttons, paddingX, paddingY, buff)
    if iction.debug then print("Dbg: iction.addButtons") end
    if iction.debug then print("\t pFrame: " .. tostring(pFrame)) end
    -- Create an empty button table
    local buttonFrames = {}
    local buttonText = {}
    for key, value in pairs(buttons) do
        if iction.debug then print("\t value['name']: " .. value['name']) end
        if iction.debug then print("\t value['inherits']: " .. value['inherits']) end
        -- Ace font for UI
        if value['vis'] then
            -- Create the button frame
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
                      but:SetTexture(file_id)--artifact['icon'])
                 end
                  but:SetVertexColor(0.9,0.3,0.3, .5)
            b.texture = but
            -- Create the fontString for the button
            local fnt = b:CreateFontString(nil, "OVERLAY","GameFontGreen")
                  fnt:SetFont(iction.font, 28, "OVERLAY", "THICKOUTLINE")
                  fnt:SetPoint("CENTER", b, 0, 0)
                  fnt:SetTextColor(.1, 1, .1, 1)
            b.text = fnt

            -- Add the button the the creatures button table
            buttonFrames[value['name']] = b
            buttonText[value['name']] = fnt

            if not iction.ictionHorizontal then
                paddingY = paddingY + iction.bh
                paddingX = paddingX
            else
                paddingY = paddingY
                paddingX = paddingX + iction.bh
            end
        end
    end
    return buttonFrames, buttonText
end

