-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("iction", "deDE", true, true);
if not L then return; end
--- Login
L["LOGIN_MSG1"] = "\124c00FFFF44[ictionInfo] Loaded Iction Benutzeroberfläche. Verwenden Sie / iction Optionen für die Option ui "
L["LOGIN_MSG2"] = "\124c00FFFF44[ictionInfo] Args: / iction unlock / iction lock / iction max 1, 2, 3 oder 4"
L["LOGIN_MSG3"] = "\124c00FFFF44[ictionInfo] BuffRahmen: "

--- Commandline args
L['unlock'] = "\124c00FFFF44Entsperrung ui Elemente."
L['lock'] = "\124c00FFFF44 Gesperrte UI-Elemente."
L['countError'] = "\124c00FFFF44 Max. Zählerstand zu hoch. Benutzen 1 2 3 or 4"

--- Options UI text
L['MoveCastBarTT'] = "Setzen Sie Ihre Bliz Cast Bar an einem benutzerdefinierten Ort oder nicht."
L['MoveCastBarText'] = "Stellen Sie die benutzerdefinierte Cast-Leiste ein"
L['skinLabel'] = 'Haut:'
L['skin1TT'] = "Wählen Sie für die Haut 1"
L['skin2TT'] = "Wählen Sie für die Haut 2"
L['skin3TT'] = "Wählen Sie für die Haut 3"
L['skin4TT'] = "Wählen Sie für die Haut 4"
L['scale'] = "Rahmen:"
L['scaleUI'] = "Set insgesamt ui Skala"
L['unlockUILabel'] = "UI freischalten"
L['unlockUITT'] = "Unlock beweglichen ui-Elemente. Deaktivieren Sie die Sperre erneut."
L['maxTargetColsLabel'] = 'Max Tgt Cols:'
L['maxTargets1TT'] = "Max Ziele 1. \ nHinweis: Das Ändern der Zählung wird die Benutzeroberfläche beim Schließen neu laden"
L['maxTargets2TT'] = "Max Ziele 2. \ nHinweis: Das Ändern der Zählung wird die Benutzeroberfläche beim Schließen neu laden"
L['maxTargets3TT'] = "Max Ziele 3. \ nHinweis: Das Ändern der Zählung wird die Benutzeroberfläche beim Schließen neu laden"
L['maxTargets4TT'] = "Max Ziele 4. \ nHinweis: Das Ändern der Zählung wird die Benutzeroberfläche beim Schließen neu laden"
L['maxT1'] = "1"
L['maxT2'] = "2"
L['maxT3'] = "3"
L['maxT4'] = "4"
L['setBuffBar'] = "Buff Stab waagerecht einstellen oder nicht"
L['HorizontalBuffBar'] = "Horizontal BuffBar?"
L['HorizontalBuffBarText'] = "\124c00FFFF44Set BuffBar to Horizontal"
L['VerticalBuffBarText'] = "\124c00FFFF44Set BuffBar to Vertikal"
L['close'] = "Schließen"
--- UI stuff
L['warlock'] = 'Warlock'
L['priest'] = 'Priest'
L['specChangeMSG'] = "\124c00FFFF44[ictionInfo] Iction hat eine Spezifikationsänderung erkannt. Wenn Sie die Dinge ein bisschen seltsam. Laden Sie die ui mit / reload ui!"