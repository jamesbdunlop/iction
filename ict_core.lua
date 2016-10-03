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
iction.ictionSpellAnchorOffset = 65
iction.ictionButtonFramePad = 5
iction.targetData = {}     -- {GUID = {name = creatureName, spellData = {spellName = {name=spellName, endtime=float}}}}
iction.targetButtons = {}  -- {GUID = {buttonFrames = {spellName = ButtonFrame}, buttonText = {spellName = fontString}}}
iction.targetFrames = {}
iction.highlightFrame = ''
iction.highlightFrameTexture = ''
iction.hlGuid = "burp"
iction.targetCols = {}
iction.ict_frameOffset = 0
iction.uiPlayerSpellButtons = {}
iction.uiPlayerBuffButtons = {}
iction.uiPlayerArtifact = {}
iction.uiBotBarArt = {}
iction.playerGUID = UnitGUID("Player")
iction.debug = true
iction.font = iction.SharedMedia:Fetch("font", "FRIZQT__")
iction.setCastBar = true
iction.cbX = 0
iction.cbY = -235
iction.cbScale = 1
iction.frameData = nil