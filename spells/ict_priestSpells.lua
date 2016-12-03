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
                [1] = {ShadowWordVoid = {name = "Shadow Word: Void",
                    insert = false, isTalentSpell = true, vis = false, tid = 205351, id = 205351, duration = 14, maxTime = 14, icon = ""}},
                [2] = {MindSear = {name = "Mind Sear",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 48045, duration = 4.3, maxTime = 4.3, icon = ""}},
                [3] = {MindFlay = {name = "Mind Flay",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 15407, duration = 2.5, maxTime = 2.5, icon = ""}},
                [4] = {ShadowWordDeath = {name = "Shadow Word: Death",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 32379, duration = nil, maxTime = nil, icon = ""}},
                [5] = {ShadowWordPain = {name = "Shadow Word: Death",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 589, duration = 14, maxTime = 14, icon = ""}},
                [6] = {VampricTouch = {name = "Vampiric Touch",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 34914, duration = 14, maxTime = 14, icon = ""}},
                [7] = {MindBlast = {name = "Mind Blast", insert = true, isTalentSpell = false, vis = true, id = 8092, duration = 1, maxTime = 1, icon = ""}},
                [8] = {VoidBolt = {name = "Void Bolt", insert = true, isTalentSpell = false, vis = true, id = 205448, duration = 15, maxTime = 15, icon = ""}},
                [9] = {ShadowCrash = {name = "Shadow Crash", insert = true, isTalentSpell = false, vis = true, id = 205385, duration = 5, maxTime = 5, icon = ""}},
                },
       buffs = {
                [0] = nil,
                [1] = {BodyAndSoul  = {name = "Body and Soul",
                    insert = false, isTalentSpell = true, vis = false, tid = 64129, id = 65081, duration = 3, maxTime = 3, icon = ""}},
                [2] = {PWShield     = {name = "Power Word: Shield",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 17, duration = 15, maxTime = 15, icon = ""}},
                [3] = {TwistOfFate  = {name = "Twist of Fate",
                    insert = false, isTalentSpell = true, vis = false, tid = 109142, id = 109142, duration = 15, maxTime = 15, icon = ""}},
                [4] = {VoidRay  = {name = "Void Ray",
                    insert = false, isTalentSpell = true, vis = false, tid = 205371, id = 205372, duration = 6, maxTime = 6, icon = ""}},
                [5] = {ShadowForm  = {name = "Shadow Form",
                    insert = false, isTalentSpell = false, vis = false, tid = nil, id = 232698, duration = 0, maxTime = 0, icon = ""}},
                [6] = {LingeringInsanity  = {name = "Lingering Insanity",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 197937, duration = 0, maxTime = 0, icon = ""}},
                [7] = {VoidEruption = {name = "Void Eruption",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 228260, duration = 15, maxTime = 15, icon = ""}},
                [8] = {ShadowyInsightBuff = {name = "Shadowy Insight",
                    insert = false, isTalentSpell = true, vis = false, tid = 162452, id = 124430, duration = 15, maxTime = 15, icon = ""}},
                --124430[8] = {VoidForm = {name = "Void Form", insert = false, isTalentSpell = false, vis = false, id = 194249, duration = 15, maxTime = 15, icon = ""}},
                },
       artifact = {name = "Void Torrent", insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 205065, duration = 4, maxTime = 4, icon = "" }
      },
}
