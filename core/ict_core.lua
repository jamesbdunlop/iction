iction = {}
----------------------------------------------------------------------------------------------
--- GLOBALS ----------------------------------------------------------------------------------
iction.SharedMedia = LibStub("LibSharedMedia-3.0");
iction.L = LibStub("AceLocale-3.0"):GetLocale("iction", false) or nil
iction.bw = 36
iction.bh = 36
iction.spells = {}
iction.ictionMFH = 64
iction.ictionMFW = 128
iction.ictionScale = 1
iction.ictionSpellAnchorOffset = 65
iction.ictionButtonFramePad = 3
iction.targetData = {}     -- {GUID = {name = creatureName, spellData = {spellName = {name=spellName, endtime=float}}}}
iction.targetButtons = {}  -- {GUID = {buttonFrames = {spellName = ButtonFrame}, buttonText = {spellName = fontString}}}
iction.targetFrames = {}
iction.stackFrames = {}
iction.highlightFrame = ''
iction.highlightFrameTexture = ''
iction.hlGuid = ""
iction.targetCols = {}
iction.ict_frameOffset = 0
iction.uiPlayerSpellButtons = {}
iction.uiPlayerSpells = nil
iction.uiPlayerBuffButtons = {}
iction.uiPlayerBuffs = nil
iction.uiPlayerArtifact = {}
iction.uiBotBarArt = {}
iction.playerGUID = UnitGUID("Player")
iction.debug = false
iction.debugTimers = false
iction.font = iction.SharedMedia:Fetch("font", "FRIZQT__")
iction.setCastBar = true
iction.cbX = 0
iction.cbY = -235
iction.cbScale = 1
iction.frameData = nil
iction.vbID = 205448
iction.swdID = 32379
iction.spec = GetSpecialization()
iction.SWDScale = 2
iction.VoidboltScale = 2

----------------------------------------------------------------------------------------------
--- CREATE THE ADDON MAIN FRAME / REGISTER ADDON ---
local sframe = CreateFrame("Frame", 'ictionRoot')
--- Triggers attached to dummy frame for intial load of addon
sframe:RegisterEvent("ADDON_LOADED")
sframe:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
sframe:SetScript("OnEvent", function(self, event, arg1)
    if( event == "ADDON_LOADED" ) and arg1 == "iction" then
        --- Locale check
        if iction.L == nil then print("Unsupported Locale!") end

        --- Legacy check for globals cleanup
        if ictionLegacy == nil then ictionFramePos = nil ictionLegacy = false end

        --- Initialize frame position table
        if not ictionFramePos then ictionFramePos = {} end

        --- Initialize skin
        if not ictionSkin then iction.skin = 03 else iction.skin = ictionSkin end

        --- Initialize buffBar layout
        if ictionBuffBarBarH == nil then
            ictionBuffBarBarH = true
        end

        --- Initialize globalScale
        if ictionGlobalScale == nil then iction.ictionScale = 1 else iction.ictionScale = ictionGlobalScale end

        --- Initialize targetCount
        if not ictionTargetCount then
            iction.ict_maxTargets = 2
        else
            iction.ict_maxTargets = ictionTargetCount
        end

        if not ictionSWDScale then
            iction.SWDScale = 2
        else
            iction.SWDScale = ictionSWDScale
        end

        if not ictionVoidBoltScale then
            iction.VoidboltScale = 1.5
        else
            iction.VoidboltScale = ictionVoidBoltScale
        end

        --- Initialize castBarPosition
        if ictionSetCastBar == nil then
            iction.setCastBar = false
        else
            iction.setCastBar = ictionSetCastBar
            if iction_cbx ~= nil then iction.cbX = iction_cbx end
            if iction_cby ~= nil then iction.cbY = iction_cby end
        end
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
        if not iction.MF then iction.specChanged() end
    end
end)