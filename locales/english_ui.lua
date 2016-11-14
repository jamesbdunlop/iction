-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("iction", "enUS", true, true);
if not L then return; end
L["LOGIN_MSG1"] = "\124c00FFFF44[ictionInfo] Loaded Iction UI. Use /iction options for option ui "
L["LOGIN_MSG2"] = "\124c00FFFF44[ictionInfo] args: /iction unlock /iction lock  /iction max 1, 2, 3 or 4 "
L["LOGIN_MSG3"] = "\124c00FFFF44[ictionInfo] BuffFrame: "

--- args
L['unlock'] = "\124c00FFFF44Unlocking iction ui elements."
L['lock'] = "\124c00FFFF44Locked iction ui elements."
L['countError'] = "\124c00FFFF44Max count too high. Use 1 2 3 or 4"

--- UI stuff
L['warlock'] = 'Warlock'
L['priest'] = 'Priest'