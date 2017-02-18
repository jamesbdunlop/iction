----------------------------------------------------------------------------------------------
--- Define PLAYER SPELL & BUFF buttons -------------------------------------------------------
local iction = iction
iction.lockspells = {
[0] = nil,
[1] = {spells = {
                [0] = nil,
                [1] = {Fear = {name = "Fear",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 118699, duration = 20, maxTime = 20}},
                [2] = {Seed = {name = "Seed of Corruption",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 27243, duration = 13.9, maxTime = 28}},
                [3] = {PhantomSingularity = {name = "Phantom Singularity",
                    insert = false, isTalentSpell = true, vis = false, tid = 205179, id = 205179, duration = 13.9, maxTime = 13.9}},
                [4] = {DrainSoul = {name = "Drain Soul",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 198590, duration = 14, maxTime = 4.75}},
                [5] = {SiphonLife  = {name = "Siphon Life",
                    insert = false, isTalentSpell = true, vis = false, tid = 63106, id = 63106, duration = 14, maxTime = 19.5}},
                [6] = {Corruption = {name = "Corruption",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 146739, duration = 15, maxTime = 17.9}},
                [7] = {UA = {name = "Unstable Affliction",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 233490, duration = 5, maxTime = 6}},
                [8] = {Agony = {name = "Agony",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 980, duration = 18, maxTime = 24}},
                },
        buffs = {
                [0] = nil,
                [1] = {EmpoweredLifeTap = {name = "Empowered Life Tap",
                    insert = false, isTalentSpell = true, vis = false, tid = 235157, id = 235156, duration = 20, maxTime = 26}},
                [2] = {reapSouls = {name = "Deadwind Harvester",
                    insert = true, isTalentSpell = false, vis = true, tid = 196104, id = 216708, duration = 30, maxTime = 30}},
                [3] = {Unending = {name = "Unending Resolve",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 104773, duration = 8, maxTime = 8}},
                [4] = {SoulHarvest = {name = "Soul Harvest",
                    insert = false, isTalentSpell = true, vis = false, tid = 196098, id = 196098, duration = 10, maxTime = 30}},
                [5] = {BurningRush = {name = "Burning Rush",
                    insert = false, isTalentSpell = true, vis = false, tid = 111400, id = 111400, duration = 999, maxTime = 999}},
                [6] = {DarkPact = {name = "Dark Pact",
                    insert = false, isTalentSpell = true, vis = false, tid = 108416, id = 108416, duration = 20, maxTime = 20}},
                [7] = {SoulLeech = {name = "Soul Leech",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 108366, duration = 15, maxTime = 15}},
                },
        artifact = { name = "Tormented Souls",
            insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 216708, duration = 30, maxTime = 30}
      },
[2] = {spells = {
                [0] = nil,
                [1] = {Doom = {name = "Doom",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 603, duration = 17.5, maxTime = 17.5}},
                [2] = {SummonDarkglare = {name = "Summon Darkglare",
                    insert = false, isTalentSpell = true, vis = false, tid = nil, id = 205180, duration = 12, maxTime = 12}},
                [3] = {Fear = {name = "Fear",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 5782, duration = 20, maxTime = 20}},
                },
       buffs = {
                [0] = nil,
                [1] = {BurningRush = {name = "Burning Rush",
                    insert = false, isTalentSpell = true, vis = false, tid = 111400, id = 111400, duration = 999, maxTime = 999}},
                [2] = {soulHarvest = {name = "Soul Harvest",
                    insert = false, isTalentSpell = true, vis = false, tid = 196098, id = 196098, duration = 10, maxTime = 30}},
                [3] = {DarkPact    = {name = "Dark Pact",
                    insert = false, isTalentSpell = true, vis = false, tid = 108416, id = 108416, duration = 20, maxTime = 20}},
                [4] = {ShadowyInspiration = {name = "Shadowy Inspiration",
                    insert = false, isTalentSpell = true, vis = false, tid = 196606, id = 196606, duration = 14, maxTime = 14}},
                [5] = {SoulLeech   = {name = "Soul Leech",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 108366, duration = 15, maxTime = 15}},
                },
       artifact = {name = "Thal`kiel's Consumption",
           insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 211714, duration = 4, maxTime = 8}
      },
[3] = {spells = {
                [0] = nil,
                [1] = {Fear = {name = "Fear",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 5782, duration = 20, maxTime = 20}},
                [2] = {Havoc = {name = "Havoc",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 80240, duration = 7, maxTime = 7}},
                [3] = {Eradication = {name = "Eradication",
                    insert = false, isTalentSpell = true, vis = false, tid = 196412, id = 196414, duration = 6, maxTime = 6}},
                [4] = {DrainLife = {name = "Drain Life",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 234153, duration = 4.6, maxTime = 4.6}},
                [5] = {ChannelDemonfire = {name = "Channel Demonfire",
                    insert = false, isTalentSpell = true, vis = false, tid = 196447, id = 196447, duration = 2.6}},
                [6] = {Immolate = {name = "Immolate",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 157736, duration = 17.5, maxTime = 22}},
                [7] = {Conflag = {name = "Conflagrate",
                    insert = true, isTalentSpell = false, vis = false, tid = nil, id = 17962, duration = 0, maxTime = 0}},
                [8] = {ShadowBurn = {name = "ShadowBurn",
                    insert = true, isTalentSpell = true, vis = false, tid = 17877, id = 17877, duration = 4, maxTime = 0}},
                },
       buffs = {
                [0] = nil,
                [1] = {EmpoweredLifeTap = {name = "Empowered Life Tap",
                    insert = false, isTalentSpell = true, vis = false, tid = 235157, id = 235156, duration = 20, maxTime = 26}},
                [2] = {backdraft = {name = "Backdraft",
                    insert = false, isTalentSpell = true, vis = false, tid = 196406, id = 117828, duration = 3, maxTime = 3}},
                [3] = {Unending = {name = "Unending Resolve",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 104773, duration = 8, maxTime = 8}},
                [4] = {DarkPact= {name = "Dark Pact",
                    insert = false, isTalentSpell = true, vis = false, tid = 108416, id = 108416, duration = 20, maxTime = 20}},
                [5] = {soulHarvest = {name = "Soul Harvest",
                    insert = false, isTalentSpell = false, vis = true, tid = nil, id = 196098, duration = 10, maxTime = 30}},
                [6] = {BurningRush = {name = "Burning Rush",
                    insert = false, isTalentSpell = true, vis = false, tid = 111400, id = 111400, duration = 999, maxTime = 999}},
                [7] = {SoulLeech = {name = "Soul Leech",
                    insert = true, isTalentSpell = false, vis = true, tid = nil, id = 108366, duration = 15, maxTime = 15}},
                [9] = {Roaringblaze = {name = "Roaring blaze",
                    insert = true, isTalentSpell = true, vis = true, tid = 205184, id = 205184, duration = 15, maxTime = 15}},
                },
       artifact = {name = "Dimensional Rift",
           insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 196586, duration = 4, maxTime = 8}
      },
}
