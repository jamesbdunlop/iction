----- version Release 2.0.3 -----

-- NOTES:
--- Removed a loose print statement
--- Removed a curious bug with tagging a target dead and spellData = nil
--- Options spell list now returns to the top of the list on open
--- Options Unlock uses internal lib ui now shows text properly when options opened more than one per session
--- Options Close button uses internal lib
--- Added buffLimit to the options panel for setting a limit to displayed buffs
--- Add checkbox for displaying player buffs only or all of them
--- Added a GCD to buttons (well kind of)

-- Known issues
--- Issue with priest special frames the voidFrame in particular

-- To Do
--- Add more artifact info for other classes / specs?

local UIParent = UIParent
local iction = iction
local sframe = CreateFrame("Frame", 'ictionRoot')
--- Triggers attached to dummy frame for intial load of addon
sframe:RegisterEvent("PLAYER_LOGIN")
sframe:SetScript("OnEvent", function(self, event, arg1)
    local function loadUI()
        iction.debuffColumns_setMax()
        iction.initMainUI()
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG1"], 15, 25, 35)
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG2"], 15, 25, 35)
        local bf
        if ictionBuffBarBarH then bf = 'Horizontal' else bf = 'Vertical' end
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG3"] .. bf, 15, 25, 35)
    end

    if (event == "PLAYER_LOGIN") then
        iction.playerGUID = UnitGUID("Player")
        loadUI()
        self:UnregisterEvent("PLAYER_LOGIN")
    end
    if iction.debugUI then print("iction rootFrame script success!") end
end)

----------------------------------------------------------------------------------------------
--- REGISTER THE SLASH COMMAND ---
SLASH_ICTION1  = "/iction"
local function ictionArgs(arg, editbox)
    if not arg then iction.initMainUI()
    elseif arg == 'unlock' then
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["LOGIN_MSG"], 100, 35, 35);
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["unlock"], 100, 35, 35);
        iction.unlockUIElements(true)
    elseif arg == 'lock' then
        DEFAULT_CHAT_FRAME:AddMessage(iction.L["lock"], 100, 35, 35);
        iction.unlockUIElements(false)
    elseif arg == 'options' then iction.setOptionsFrame()
    elseif arg == 'hide' then iction.mainFrameBldr.frame:Hide()
    elseif arg == 'show' then iction.mainFrameBldr.frame:Show()
    else
        local max, cnt =  strsplit(" ", arg)
        if max == 'max' then
            local count = tonumber(cnt)
            if count > 0 and count < 5 then
                ictionTargetCount = count
                ReloadUI()
            else
                DEFAULT_CHAT_FRAME:AddMessage(iction.L["countError"], 100, 35, 35);
            end
        end
    end
    if iction.debugUI then print("ictionArgs success!") end
end
SlashCmdList["ICTION"] = ictionArgs

----------------------------------------------------------------------------------------------
--- BEGIN UI NOW ---
function iction.initMainUI()
    if iction.debugUI then print("iction.initMainUI init...") end
    --- Setup the mainFrame and Eventwatcher ---
    local MFData = iction.ictMainFrameData
    iction.mainFrameBldr = {}
          setmetatable(iction.mainFrameBldr, {__index = iction.UIFrameElement})
          iction.mainFrameBldr.create(iction.mainFrameBldr, MFData)
          iction.mainFrameBldr.setMoveScript(iction.mainFrameBldr, UIParent)
          iction.mainFrameBldr.frame:SetScale(iction.ictionScale)

    --- Now fire off all the other build functions ---
    iction.createBottomBarArtwork()
    iction.initSpellTable()

    if iction.class == iction.L['Warlock'] then
        iction.createShardFrame()
        if iction.spec == 3 then iction.createConflagFrame() end
    elseif iction.class == iction.L['Priest'] then
        if iction.spec == 3 then
            iction.createInsanityFrame()
            iction.createSWDFrame()
            iction.createVoidFrame()
        end
    end
    iction.createArtifactFrame()
    iction.createBuffFrame()
    iction.createDebuffColumns()

    --- Setup the frame watcher for spells etc
    iction.watcher(iction.mainFrameBldr.frame)

    if iction.debugUI then print("iction.initMainUI success!") end
    iction.playerGUID = UnitGUID("Player")
end

function iction.initSpellTable()
    local localizedClass, _, _ = UnitClass("Player")
        iction.class = localizedClass
    local spec = GetSpecialization()
        iction.spec = spec
    if not ictionValidSpells[iction.class] then
        ictionValidSpells[iction.class] = {}
        ictionValidSpells[iction.class][iction.spec] = {}
        ictionValidSpells[iction.class][iction.spec]["spells"] = {}
    elseif not ictionValidSpells[iction.class][iction.spec] then
        ictionValidSpells[iction.class][iction.spec] = {}
        ictionValidSpells[iction.class][iction.spec]["spells"] = {}
    end
end