----------------------------------------------------------------------------------------------
--- Define PLAYER SPELL & BUFF buttons -------------------------------------------------------
local iction = iction
iction.spells = {
[0] = nil,
[1] = {spells = {
                [0] = nil,
                [1] = {Fear = {name = "Fear", insert = true, isTalentSpell = false, vis = true, id = 118699, duration = 20, maxTime = 20, icon = ""}},
                [2] = {Seed = {name = "Seed of Corruption", insert = true, isTalentSpell = false, vis = true, id = 27243, duration = 13.9, maxTime = 28, icon = "Interface/AddOns/iction/media/icons/seedofcorruption"}},
                [3] = {PhantomSingularity = {name = "Phantom Singularity", insert = false, isTalentSpell = true, vis = false, id = 205179, duration = 13.9, maxTime = 13.9, icon = ""}},
                [4] = {DrainLife = {name = "Drain Life", insert = true, isTalentSpell = false, vis = true, id = 689, duration = 4.6, maxTime = 4.6, icon = "Interface/AddOns/iction/media/icons/drainLife"}},
                [5] = {DrainSoul = {name = "Drain Soul", insert = false, isTalentSpell = true, vis = false, id = 198590, duration = 14, maxTime = 4.75, icon = "Interface/AddOns/iction/media/icons/drainSoul"}},
                [6] = {SiphonLife  = {name = "Siphon Life", insert = false, isTalentSpell = true, vis = false, id = 63106, duration = 14, maxTime = 19.5, icon = "Interface/AddOns/iction/media/icons/siphonLife"}},
                [7] = {Corruption = {name = "Corruption", insert = true, isTalentSpell = false, vis = true, id = 146739, duration = 15, maxTime = 17.9, icon = "Interface/AddOns/iction/media/icons/corruption"}},
                [8] = {UA = {name = "Unstable Affliction", insert = true, isTalentSpell = false, vis = true, id = 233490, duration = 5, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/unstableAffliction"}},
                [9] = {Agony = {name = "Agony", insert = true, isTalentSpell = false, vis = true, id = 980, duration = 18, maxTime = 24, icon = "Interface/AddOns/iction/media/icons/agony"}},
                },
        buffs = {
                [0] = nil,
                [1] = {manaTap     = {name = "Mana Tap",  insert = false, isTalentSpell = true,  vis = false, sbid = 44, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"}},
                [2] = {reapSouls   = {name = "Deadwind Harvester",  insert = true, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls"}},
                [3] = {Unending    = {name = "Unending Resolve",  insert = true, isTalentSpell = false, vis = true, id = 104773, duration = 8, maxTime = 8, icon = ""}},
                [4] = {SoulHarvest = {name = "Soul Harvest",  insert = false, isTalentSpell = true, vis = false, id = 196098, duration = 10, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/soulHarvest"}},
                [5] = {BurningRush = {name = "Burning Rush",  insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""}},
                [6] = {DarkPact    = {name = "Dark Pact",  insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""}},
                [7] = {WrathofConsumption = {name = "Wrath of Consumption",  insert = false, isTalentSpell = false, vis = false, id = 199472, duration = 20, maxTime = 20, icon = ""}},
                [8] = {SoulLeech   = {name = "Soul Leech", insert = true, isTalentSpell = false, vis = true, id = 108366, duration = 15, maxTime = 15, icon = ""}},
                },
        artifact = { name = "Tormented Souls",  insert = true, isArtifact = true, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls" }
      },
[2] = {spells = {
                [0] = nil,
                [1] = {Doom = {name = "Doom", insert = true, isTalentSpell = false, vis = true, id = 603, duration = 17.5, maxTime = 17.5, icon = ""}},
                [2] = {SummonDarkglare = {name = "Summon Darkglare", insert = false, isTalentSpell = true, vis = false, id = 205180, duration = 12, maxTime = 12, icon = ""}},
                [3] = {Fear = {name = "Fear", insert = true, isTalentSpell = false, vis = true, id = 5782, duration = 20, maxTime = 20, icon = ""}},
                },
       buffs = {
                [0] = nil,
                [1] = {BurningRush = {name = "Burning Rush", insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""}},
                [2] = {soulHarvest = {name = "Soul Harvest", insert = false, isTalentSpell = true, vis = false, id = 196098, duration = 10, maxTime = 30, icon = ""}},
                [3] = {DarkPact    = {name = "Dark Pact", insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""}},
                [4] = {ShadowyInspiration = {name = "Shadowy Inspiration", insert = false, isTalentSpell = true, vis = false, id = 196606, duration = 14, maxTime = 14, icon = ""}},
                [5] = {SoulLeech   = {name = "Soul Leech", insert = true, isTalentSpell = false, vis = true, id = 108366, duration = 15, maxTime = 15, icon = ""}},
                },
       artifact = {name = "Thal`kiel's Consumption", isArtifact = true, isTalentSpell = false, vis = true, id = 211714, duration = 4, maxTime = 8, icon = "Interface/AddOns/iction/media/icons/dimensionalRift" }
      },
[3] = {spells = {
                [0] = nil,
                [1] = {Fear = {name = "Fear", insert = true, isTalentSpell = false, vis = true, id = 5782, duration = 20, maxTime = 20, icon = ""}},
                [2] = {Havoc = {name = "Havoc",  insert = true, isTalentSpell = false, vis = true, id = 80240, duration = 7, maxTime = 7, icon = "Interface/AddOns/iction/media/icons/baneofHavoc"}},
                [3] = {Eradication = {name = "Eradication",  insert = false, isTalentSpell = true, vis = false, id = 196414, duration = 6, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/eradication"}},
                [4] = {DrainLife = {name = "Drain Life",  insert = true, isTalentSpell = false, vis = true, id = 234153, duration = 4.6, maxTime = 4.6, icon = "Interface/AddOns/iction/media/icons/drainLife"}},
                [5] = {ChannelDemonfire = {name = "Channel Demonfire",  insert = false, isTalentSpell = true, vis = false, id = 196447, duration = 2.6, maxTime = 2.6, icon = "Interface/AddOns/iction/media/icons/felflame"}},
                [6] = {Immolate = {name = "Immolate",  insert = true, isTalentSpell = false, vis = true, id = 157736, duration = 17.5, maxTime = 22, icon = "Interface/AddOns/iction/media/icons/immolate"}},
                [7] = {Conflag = {name = "Conflagrate",  insert = true, isTalentSpell = false, vis = false, id = 17962, duration = 0, maxTime = 0, icon = ""}},
                },
       buffs = {
                [0] = nil,
                [1] = {manaTap     = {name = "Mana Tap", insert = false, isTalentSpell = true, vis = false, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"}},
                [2] = {backdraft   = {name = "Backdraft", insert = false, isTalentSpell = true, vis = false, id = 117828, duration = 3, maxTime = 3, icon = "Interface/AddOns/iction/media/icons/backdraft"}},
                [3] = {Unending    = {name = "Unending Resolve", insert = true, isTalentSpell = false, vis = true, id = 104773, duration = 8, maxTime = 8, icon = ""}},
                [4] = {DarkPact    = {name = "Dark Pact", insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""}},
                [5] = {soulHarvest = {name = "Soul Harvest", insert = false, isTalentSpell = false, vis = true, id = 196098, duration = 10, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/soulHarvest"}},
                [6] = {BurningRush = {name = "Burning Rush", insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""}},
                [7] = {SoulLeech   = {name = "Soul Leech", insert = true, isTalentSpell = false, vis = true, id = 108366, duration = 15, maxTime = 15, icon = ""}},
                },
       artifact = {name = "Dimensional Rift", insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 196586, duration = 4, maxTime = 8, icon = "Interface/AddOns/iction/media/icons/dimensionalRift" }
      },
}
