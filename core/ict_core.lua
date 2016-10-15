----------------------------------------------------------------------------------------------
----- Register global name iction to ACE for use in addon lua files in the toc
iction = {}
iction.SharedMedia = LibStub("LibSharedMedia-3.0");
----------------------------------------------------------------------------------------------
--- GLOBALS ----------------------------------------------------------------------------------
iction.bw = 36
iction.bh = 36
--- Addon Globals
iction.ictionMFH = 64
iction.ictionMFW = 128
iction.ictionScale = 1
iction.ictionHorizontal = false
iction.buffFrameHorizontal = true
iction.ictionSpellAnchorOffset = 65
iction.ictionButtonFramePad = 5
iction.targetData = {}     -- {GUID = {name = creatureName, spellData = {spellName = {name=spellName, endtime=float}}}}
iction.targetButtons = {}  -- {GUID = {buttonFrames = {spellName = ButtonFrame}, buttonText = {spellName = fontString}}}
iction.targetFrames = {}
iction.highlightFrame = ''
iction.highlightFrameTexture = ''
iction.hlGuid = ""
iction.targetCols = {}
iction.ict_frameOffset = 0
iction.uiPlayerSpellButtons = {}
iction.uiPlayerBuffButtons = {}
iction.uiPlayerArtifact = {}
iction.uiBotBarArt = {}
iction.playerGUID = UnitGUID("Player")
iction.debug = false
iction.font = iction.SharedMedia:Fetch("font", "FRIZQT__")
iction.setCastBar = true
iction.cbX = 0
iction.cbY = -235
iction.cbScale = 1
iction.frameData = nil
----------------------------------------------------------------------------------------------
--- CREATE THE ADDON MAIN FRAME / REGISTER ADDON ---
local sframe = CreateFrame("Frame", 'ictionRoot')
--- Triggers attached to dummy frame for intial load of addon
sframe:RegisterEvent("ADDON_LOADED")
sframe:SetScript("OnEvent", function(self, event, arg1)
    if( event == "ADDON_LOADED" ) and arg1 == "iction" then

        if ictionLegacy == nil then ictionFramePos = nil ictionLegacy = false end
        if not ictionFramePos then ictionFramePos = {} end
        if not ictionSkin then iction.skin = 01 else iction.skin = ictionSkin end
        if not ictionTargetCount then
            iction.ict_maxTargets = 2
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionMSG]First time load detected setting tgt count to 2...", 65, 35, 35);
        else
            iction.ict_maxTargets = ictionTargetCount
            DEFAULT_CHAT_FRAME:AddMessage("\124c00FFFF44[ictionMSG]Set max count to ".. iction.ict_maxTargets, 100, 35, 35);
        end
        if ictionSetCastBar == nil then
            iction.setCastBar = false
        else
            iction.setCastBar = ictionSetCastBar
            if iction_cbx ~= nil then iction.cbX = iction_cbx end
            if iction_cby ~= nil then iction.cbY = iction_cby end
        end
    end
end)