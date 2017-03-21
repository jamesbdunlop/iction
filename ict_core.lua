iction = {}
local localizedClass, _, _ = UnitClass("Player")
----------------------------------------------------------------------------------------------
--- GLOBALS ----------------------------------------------------------------------------------
--- LIBS
iction.SharedMedia = LibStub("LibSharedMedia-3.0");
iction.L = LibStub("AceLocale-3.0"):GetLocale("iction", false) or nil
--- UI
iction.ictionMFH = 64
iction.ictionMFW = 256
iction.bw = 36
iction.bh = 36
iction.ictionScale = 1
iction.ictionSpellAnchorOffset = 65
iction.ictionButtonFramePad = 3
iction.moveableUIFrames = {}
iction.hightlghtFrameGuid = ""
iction.targetCols = {}
iction.ict_frameOffset = 0
iction.uiPlayerArtifact = {}
iction.uiBotBarArt = {}
iction.cbX = 0
iction.cbY = -235
iction.cbScale = 1
iction.vbID = 205448
iction.swdID = 32379
iction.class = localizedClass
iction.SWDScale = 2
iction.VoidboltScale = 2
iction.hlGuid = nil

--- COMBAT
iction.targetData = {}
iction.activeSpellTable = {}
iction.validSpellTable = {}
--- DEBUG
iction.debugUI = false
iction.debugUITimers = false
iction.debugUITargetSpell = false
iction.debugRunningTimers = false

iction.playerGUID = nil
iction.spec = nil
iction.font = iction.SharedMedia:Fetch("font", "FRIZQT__")


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

        if not ictionValidSpells then
            ictionValidSpells = {}
        end
    end
end)
if iction.debugUI then print("iction core success!") end
