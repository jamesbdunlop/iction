----------------------------------------------------------------------------------------------
--- Define PLAYER SPELL & BUFF buttons -------------------------------------------------------

----------------------------------------------------------------------------------------------
--- AFFLICTION -------------------------------------------------------------------------------
-- 233490
-- 233496
-- 233497

local aff_SpellList = {
[0] = nil,
[1] = {Fear = {name = "Fear", insert = true, isTalentSpell = false, vis = true, id = 118699, duration = 20, maxTime = 20, icon = ""}},
[2] = {Seed = {name = "Seed of Corruption", insert = true, isTalentSpell = false, vis = true, id = 27243, duration = 13.9, maxTime = 28, icon = "Interface/AddOns/iction/media/icons/seedofcorruption"}},
[3] = {PhantomSingularity = {name = "Phantom Singularity", insert = false, isTalentSpell = true, vis = false, id = 205179, duration = 13.9, maxTime = 13.9, icon = ""}},
[4] = {DrainLife = {name = "Drain Life", insert = true, isTalentSpell = false, vis = true, id = 234153, duration = 4.6, maxTime = 4.6, icon = "Interface/AddOns/iction/media/icons/drainLife"}},
[5] = {DrainSoul = {name = "Drain Soul", insert = false, isTalentSpell = true, vis = false, id = 198590, duration = 14, maxTime = 4.75, icon = "Interface/AddOns/iction/media/icons/drainSoul"}},
[6] = {SiphonLife  = {name = "Siphon Life", insert = false, isTalentSpell = true, vis = false, id = 63106, duration = 14, maxTime = 19.5, icon = "Interface/AddOns/iction/media/icons/siphonLife"}},
[7] = {Corruption = {name = "Corruption", insert = true, isTalentSpell = false, vis = true, id = 146739, duration = 15, maxTime = 17.9, icon = "Interface/AddOns/iction/media/icons/corruption"}},
[8] = {UA = {name = "Unstable Affliction", insert = true, isTalentSpell = false, vis = true, id = 233490, duration = 5, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/unstableAffliction"}},
[9] = {Agony = {name = "Agony", insert = true, isTalentSpell = false, vis = true, id = 980, duration = 18, maxTime = 24, icon = "Interface/AddOns/iction/media/icons/agony"}},
}

local aff_BuffList = {
[0] = nil,
[1] = {manaTap     = {name = "Mana Tap",  insert = false, isTalentSpell = true,  vis = false, sbid = 44, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"}},
[2] = {reapSouls   = {name = "Deadwind Harvester",  insert = true, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls"}},
[3] = {Unending    = {name = "Unending Resolve",  insert = true, isTalentSpell = false, vis = true, id = 104773, duration = 8, maxTime = 8, icon = ""}},
[4] = {SoulHarvest = {name = "Soul Harvest",  insert = false, isTalentSpell = true, vis = false, id = 196098, duration = 10, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/soulHarvest"}},
[5] = {BurningRush = {name = "Burning Rush",  insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""}},
[6] = {DarkPact    = {name = "Dark Pact",  insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""}},
[7] = {WrathofConsumption = {name = "Wrath of Consumption",  insert = false, isTalentSpell = false, vis = false, id = 199472, duration = 20, maxTime = 20, icon = ""}},
[8] = {SoulLeech   = {name = "Soul Leech", insert = true, isTalentSpell = false, vis = true, id = 108366, duration = 15, maxTime = 15, icon = ""}},
}
local aff_artifact = { name = "Tormented Souls",  insert = true, isArtifact = true, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls" }

----------------------------------------------------------------------------------------------
--- DESTRO -----------------------------------------------------------------------------------
local destro_SpellList = {
[0] = nil,
[1] = {Fear = {name = "Fear", insert = true, isTalentSpell = false, vis = true, id = 5782, duration = 20, maxTime = 20, icon = ""}},
[2] = {Havoc = {name = "Havoc",  insert = true, isTalentSpell = false, vis = true, id = 80240, duration = 7, maxTime = 7, icon = "Interface/AddOns/iction/media/icons/baneofHavoc"}},
[3] = {Eradication = {name = "Eradication",  insert = false, isTalentSpell = true, vis = false, id = 196414, duration = 6, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/eradication"}},
[4] = {DrainLife = {name = "Drain Life",  insert = true, isTalentSpell = false, vis = true, id = 234153, duration = 4.6, maxTime = 4.6, icon = "Interface/AddOns/iction/media/icons/drainLife"}},
[5] = {ChannelDemonfire = {name = "Channel Demonfire",  insert = false, isTalentSpell = true, vis = false, id = 196447, duration = 2.6, maxTime = 2.6, icon = "Interface/AddOns/iction/media/icons/felflame"}},
[6] = {Immolate = {name = "Immolate",  insert = true, isTalentSpell = false, vis = true, id = 157736, duration = 17.5, maxTime = 22, icon = "Interface/AddOns/iction/media/icons/immolate"}},
[7] = {Conflag = {name = "Conflagrate",  insert = true, isTalentSpell = false, vis = false, id = 17962, duration = 0, maxTime = 0, icon = ""}},
}
local destro_BuffList = {
[0] = nil,
[1] = {manaTap     = {name = "Mana Tap", insert = false, isTalentSpell = true, vis = false, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"}},
[2] = {backdraft   = {name = "Backdraft", insert = false, isTalentSpell = true, vis = false, id = 117828, duration = 3, maxTime = 3, icon = "Interface/AddOns/iction/media/icons/backdraft"}},
[3] = {Unending    = {name = "Unending Resolve", insert = true, isTalentSpell = false, vis = true, id = 104773, duration = 8, maxTime = 8, icon = ""}},
[4] = {DarkPact    = {name = "Dark Pact", insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""}},
[5] = {soulHarvest = {name = "Soul Harvest", insert = false, isTalentSpell = false, vis = true, id = 196098, duration = 10, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/soulHarvest"}},
[6] = {BurningRush = {name = "Burning Rush", insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""}},
[7] = {SoulLeech   = {name = "Soul Leech", insert = true, isTalentSpell = false, vis = true, id = 108366, duration = 15, maxTime = 15, icon = ""}},
}
local destro_artifact = {name = "Dimensional Rift", insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 196586, duration = 4, maxTime = 8, icon = "Interface/AddOns/iction/media/icons/dimensionalRift" }

----------------------------------------------------------------------------------------------
--- DEMO -------------------------------------------------------------------------------------
local demo_SpellList = {
[0] = nil,
[1] = {Doom = {name = "Doom", insert = true, isTalentSpell = false, vis = true, id = 603, duration = 17.5, maxTime = 17.5, icon = ""}},
[2] = {SummonDarkglare = {name = "Summon Darkglare", insert = false, isTalentSpell = true, vis = false, id = 205180, duration = 12, maxTime = 12, icon = ""}},
[3] = {Fear = {name = "Fear", insert = true, isTalentSpell = false, vis = true, id = 5782, duration = 20, maxTime = 20, icon = ""}},
}
local demo_BuffList = {
[0] = nil,
[1] = {BurningRush = {name = "Burning Rush", insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""}},
[2] = {soulHarvest = {name = "Soul Harvest", insert = false, isTalentSpell = true, vis = false, id = 196098, duration = 10, maxTime = 30, icon = ""}},
[3] = {DarkPact    = {name = "Dark Pact", insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""}},
[4] = {ShadowyInspiration = {name = "Shadowy Inspiration", insert = false, isTalentSpell = true, vis = false, id = 196606, duration = 14, maxTime = 14, icon = ""}},
[5] = {SoulLeech   = {name = "Soul Leech", insert = true, isTalentSpell = false, vis = true, id = 108366, duration = 15, maxTime = 15, icon = ""}},
}
--Demonic Synergy 171982
local demo_artifact = {name = "Thal`kiel's Consumption", isArtifact = true, isTalentSpell = false, vis = true, id = 211714, duration = 4, maxTime = 8, icon = "Interface/AddOns/iction/media/icons/dimensionalRift" }

----------------------------------------------------------------------------------------------
--- Process Buttons ------------------------------------------------------------------------------------
function iction.addButtonsToTable(buttonList, desttable)
    local bList = buttonList
    for x, data in ipairs(bList) do
        for spellName, spellData in pairs(data) do
            if spellData["isTalentSpell"] then
                for x=1, 7 do
                    for c=1, 3 do
                        local talentID, name, texture, selected, available = GetTalentInfo(x, c, 1)
                        if name == spellData['name'] and selected then
                            spellData['vis'] = true
                            spellData['insert'] = true
                            if spellData['name'] == "Drain Soul" and selected then
                                bList[4]['DrainLife']['insert'] = false
                                bList[5]['DrainSoul']['insert'] = true
                            end
                        end
                    end
                end
            end
        end
    end

    for x, data in ipairs(bList) do
        for spellName, spellData in pairs(data) do
            if spellData['insert'] then
                table.insert(desttable, {name = spellData['name'],
                                         h = iction.bh,
                                         w = iction.bw,
                                         inherits = "SecureActionButtonTemplate",
                                         icon = spellData['icon'],
                                         id = spellData['id'],
                                         duration = spellData['duration'],
                                         maxTime = spellData['maxTime'],
                                         vis = spellData['vis']
                                         })
            end
        end
    end
end

function iction.tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function iction.setDebuffButtonLib()
    local buttonLib
    iction.uiPlayerSpellButtons = {}
    local spec = GetSpecialization()
    if spec == 1 then
        iction.addButtonsToTable(aff_SpellList, iction.uiPlayerSpellButtons)
    elseif spec == 2 then
        iction.addButtonsToTable(demo_SpellList, iction.uiPlayerSpellButtons)
    elseif spec == 3 then
        iction.addButtonsToTable(destro_SpellList, iction.uiPlayerSpellButtons)
    end
end

function iction.setBuffButtonLib()
    local buttonLib
    iction.uiPlayerBuffButtons = {}
    local spec = GetSpecialization()
    if spec == 1 then
        iction.addButtonsToTable(aff_BuffList, iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = aff_artifact
    elseif spec == 2 then
        iction.addButtonsToTable(demo_BuffList, iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = demo_artifact
    elseif spec == 3 then
        iction.addButtonsToTable(destro_BuffList, iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = destro_artifact
    end
end