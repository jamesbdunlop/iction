----------------------------------------------------------------------------------------------
--- Define PLAYER SPELL & BUFF buttons -------------------------------------------------------
local iction = iction
iction.priestspells = {
[0] = nil,
[1] = {spells = {
                [0] = nil,
                },
        buffs = {
                [0] = nil,
                },
        artifact = { name = "",  insert = false, isArtifact = true, isTalentSpell = false, vis = true, sbid = 46, id = 1, duration = 30, maxTime = 30, icon = "" }
      },
[2] = {spells = {
                [0] = nil,
                },
       buffs = {
                [0] = nil,
                },
       artifact = {name = "",  insert = false, isArtifact = true, isTalentSpell = false, vis = true, id = 1, duration = 4, maxTime = 8, icon = "" }
      },
[3] = {spells = {
                [0] = nil,
                --[6] = {MindBender = {name = "Mindbender", insert = false, isTalentSpell = true, vis = false, id = 200174, duration = 15, maxTime = 15, icon = ""}},
                --[6] = {VoidEruption = {name = "Void Eruption", insert = true, isTalentSpell = false, vis = true, id = 228260, duration = 15, maxTime = 15, icon = ""}},
                --[7] = {VoidBolt = {name = "Void Bolt", insert = true, isTalentSpell = false, vis = true, id = 205448, duration = 15, maxTime = 15, icon = ""}},
                [1] = {ShadowWordVoid = {name = "Shadow Word: Void", insert = false, isTalentSpell = true, vis = false, id = 205351, duration = 14, maxTime = 14, icon = ""}},
                [2] = {VampricTouch = {name = "Vampiric Touch", insert = true, isTalentSpell = false, vis = true, id = 34914, duration = 14, maxTime = 14, icon = ""}},
                [3] = {MindSear = {name = "Mind Sear", insert = true, isTalentSpell = false, vis = true, id = 48045, duration = 4.3, maxTime = 4.3, icon = ""}},
                [4] = {MindFlay = {name = "Mind Flay", insert = true, isTalentSpell = false, vis = true, id = 15407, duration = 2.5, maxTime = 2.5, icon = ""}},
                [5] = {ShadowWordDeath = {name = "Shadow Word: Death", insert = true, isTalentSpell = false, vis = true, id = 199911, duration = 9, maxTime = 9, icon = ""}},
                [6] = {ShadowWordPain = {name = "Shadow Word: Death", insert = true, isTalentSpell = false, vis = true, id = 589, duration = 14, maxTime = 14, icon = ""}},
                [7] = {MindBlast = {name = "Mind Blast", insert = true, isTalentSpell = false, vis = true, id = 8092, duration = 1, maxTime = 1, icon = ""}},
                },
       buffs = {
                [0] = nil,
                [1] = {BodyAndSoul  = {name = "Body and Soul", insert = false, isTalentSpell = true, vis = false, id = 65081, duration = 3, maxTime = 3, icon = ""}},
                [2] = {PWShield     = {name = "Power Word: Shield", insert = true, isTalentSpell = false, vis = true, id = 17, duration = 15, maxTime = 15, icon = ""}},
                [3] = {TwistOfFate  = {name = "Twist of Fate", insert = false, isTalentSpell = true, vis = false, id = 109142, duration = 15, maxTime = 15, icon = ""}},
                [4] = {VoidRay  = {name = "Void Ray", insert = false, isTalentSpell = true, vis = false, id = 205372, duration = 6, maxTime = 6, icon = ""}},
                [5] = {ShadowForm  = {name = "Shadow Form", insert = false, isTalentSpell = false, vis = false, id = 232698, duration = 0, maxTime = 0, icon = ""}},
                },
       artifact = {name = "Void Torrent", insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 205065, duration = 4, maxTime = 4, icon = "" }
      },
}
