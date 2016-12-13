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
            local fPFrame = pFrame
            local bw = iction.bw
            local bh = iction.bh
            if value['id'] == 32379 then --- SWD smelly handler as I am avoiding a full core system overhaul at this point.
                fPFrame = iction.SWDFrame
                paddingX = 0
                paddingY = 0
                bw = bw + 15
                bh = bh + 15
            elseif value['id'] == 205448 then --- VoidBolt smelly handler as I am avoiding a full core system overhaul at this point.
                fPFrame = iction.voidFrame
                paddingX = 0
                paddingY = 0
            end
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
                  b:SetPoint("BOTTOM", fPFrame, paddingX, paddingY)
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
                b:SetPoint("LEFT", fPFrame, paddingX, paddingY)
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

