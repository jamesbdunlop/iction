--- version Release 2.0.0
--- Full over haul of internal engine / ui
local min, max, abs = min, max, abs
local UIParent, GetScreenWidth,GetScreenHeight,IsAltKeyDown = UIParent, GetScreenWidth, GetScreenHeight, IsAltKeyDown
local iction = iction

local sframe = CreateFrame("Frame", 'ictionRoot')
if iction.debugUI then print("iction rootFrame success!") end

--- Triggers attached to dummy frame for intial load of addon
sframe:RegisterEvent("PLAYER_LOGIN")
sframe:SetScript("OnEvent", function(self, event, arg1)
    local function loadUI()
        iction.debuffColumns_setMax()
        iction.initMainUI()
        iction.highlightFrameTexture = iction.createHighlightFrame()
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
    iction.mainFrameBldr = {}
    setmetatable(iction.mainFrameBldr, {__index = iction.UIFrameElement})
    iction.mainFrameBldr.create(iction.mainFrameBldr, iction.ictMainFrameData)
    iction.mainFrameBldr.setMoveScript(iction.mainFrameBldr, UIParent)
    iction.mainFrameBldr.frame:SetScale(iction.ictionScale)

    --- Now fire off all the other build functions ---
    iction.createBottomBarArtwork()

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
    if iction.class == iction.L['Warlock'] then
        iction.ictionLockFrameWatcher(iction.mainFrameBldr.frame)
    elseif iction.class == iction.L['Priest'] then
        iction.ictionPriestFrameWatcher(iction.mainFrameBldr.frame)
    end

    if iction.debugUI then print("iction.initMainUI success!") end
end
