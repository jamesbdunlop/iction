-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("iction", "enUS", true, true);
if not L then return; end
--- Login
L["LOGIN_MSG1"] = "\124c00FFFF44[ictionInfo] Loaded Iction UI. Use /iction options for option ui "
L["LOGIN_MSG2"] = "\124c00FFFF44[ictionInfo] args: /iction unlock /iction lock  /iction max 1, 2, 3 or 4 "
L["LOGIN_MSG3"] = "\124c00FFFF44[ictionInfo] BuffFrame: "

--- Commandline args
L['unlock'] = "\124c00FFFF44Unlocking iction ui elements."
L['lock'] = "\124c00FFFF44Locked iction ui elements."
L['countError'] = "\124c00FFFF44Max count too high. Use 1 2 3 or 4"

--- Options UI text
L['MoveCastBarTT'] = "Set place your bliz cast bar in a custom location or not."
L['MoveCastBarText'] = "Set custom cast bar location"
L['skinLabel'] = 'Skin:'
L['skin1TT'] = "Select for skin 1"
L['skin2TT'] = "Select for skin 2"
L['skin3TT'] = "Select for skin 3"
L['skin4TT'] = "Select for skin 4"
L['scale'] = "Scale:"
L['scaleUI'] = "Set overall ui scale"
L['unlockUILabel'] = "Unlock UI"
L['unlockUITT'] = "Unlock moveable ui elements. Uncheck to lock again."
L['maxTargetColsLabel'] = 'Max Tgt Cols:'
L['maxTargets1TT'] = "Max targets 1. \nNote: Changing count will reload the UI on close."
L['maxTargets2TT'] = "Max targets 2. \nNote: Changing count will reload the UI on close."
L['maxTargets3TT'] = "Max targets 3. \nNote: Changing count will reload the UI on close."
L['maxTargets4TT'] = "Max targets 4. \nNote: Changing count will reload the UI on close."
L['maxT1'] = "1"
L['maxT2'] = "2"
L['maxT3'] = "3"
L['maxT4'] = "4"
L['setBuffBar'] = "Set buffBar to be horizontal or not."
L['HorizontalBuffBar'] = "Horizontal BuffBar?"
L['HorizontalBuffBarText'] = "\124c00FFFF44Set BuffBar to Horizontal"
L['VerticalBuffBarText'] = "\124c00FFFF44Set BuffBar to Vertical"
L['close'] = "Close"
--- UI stuff
L['Warlock'] = 'Warlock'
L['Priest'] = 'Priest'
L['specChangeMSG'] = "\124c00FFFF44[ictionInfo] Iction has detected a spec change. If you find things going a bit weird. Reload the ui using /reload ui!"
L['scaleSWD'] = 'Scale SWD frm:'
L['scaleSWDTT'] = 'Scale Shadow Word: Death frame'
L['scaleVB'] = 'Scale VBlt Frm:'
L['scaleVBTT'] = 'Scale VoidBolt frame'