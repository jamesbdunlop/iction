----------------------------------------------------------------------------------------------
--- BUTTON GENERATOR -------------------------------------------------------------------------
function iction.buttonBuild(pFrame, guid, buttons, paddingX, paddingY, buff)
    if iction.debug then print("buttonBuild") end
    -- Create an empty button table
    local buttonFrames = {}
    local buttonText = {}
    for key, value in pairs(buttons) do
        if value['vis'] then
            local spellID = value['id']
            -- Create the button frame
            local b = CreateFrame("Button", value['name'], pFrame, value["inherits"])
                  print("created a button: " .. tostring(value['name']))
                  b:RegisterEvent("SPELL_CAST_START")
                  b:SetAttribute("name", value['id'])
                  b:SetAttribute("spellName", value['name'])
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
                  local file_id = GetSpellTexture(value['id'])
                  but:SetTexture(file_id)
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

