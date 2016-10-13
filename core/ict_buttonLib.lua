----------------------------------------------------------------------------------------------
--- Define PLAYER SPELL & BUFF buttons -------------------------------------------------------
----------------------------------------------------------------------------------------------
--- AFFLICTION -------------------------------------------------------------------------------
local activeSpellBookSpells = {}
local aff_SpellList = {
UA = {name = "Unstable Affliction", insert = true, isTalentSpell = false, vis = true, id = 30108, uration = 5, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/unstableAffliction"},
Corruption = {name = "Corruption", insert = true, isTalentSpell = false, vis = true, id = 172, duration = 15, maxTime = 17.9, icon = "Interface/AddOns/iction/media/icons/corruption"},
DrainLife = {name = "Drain Life", insert = true, isTalentSpell = false, vis = true, id = 689, duration = 4.6, maxTime = 4.6, icon = "Interface/AddOns/iction/media/icons/drainLife"},
Seed = {name = "Seed of Corruption", insert = true, isTalentSpell = false, vis = true, id = 27243, duration = 13.9, maxTime = 13.9, icon = "Interface/AddOns/iction/media/icons/seedofcorruption"},
Agony = {name = "Agony", insert = true, isTalentSpell = false, vis = true, id = 980, duration = 17, maxTime = 24, icon = "Interface/AddOns/iction/media/icons/agony"},

DrainSoul = {name = "Drain Soul", insert = false, isTalentSpell = true, vis = false, id = 198590, duration = 14, maxTime = 4.75, icon = "Interface/AddOns/iction/media/icons/drainSoul"},
SiphonLife = {name = "Siphon Life", insert = false, isTalentSpell = true, vis = false, id = 63106, duration = 14, maxTime = 19.5, icon = "Interface/AddOns/iction/media/icons/siphonLife"},
PhantomSingularity = {name = "Phantom Singularity", insert = false, isTalentSpell = true, vis = false, id = 205179, duration = 13.9, maxTime = 13.9, icon = ""},
}
-- healthFunnel
local aff_BuffList = {
manaTap = {name = "Mana Tap",  insert = false, isTalentSpell = true,  vis = false, sbid = 44, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"},
reapSouls = {name = "Deadwind Harvester",  insert = true, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls"},
Unending = {name = "Unending Resolve",  insert = true, isTalentSpell = false, vis = true, id = 104773, duration = 8, maxTime = 8, icon = ""},
SoulHarvest = {name = "Soul Harvest",  insert = false, isTalentSpell = true, vis = false, id = 196098, duration = 10, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/soulHarvest"},
BurningRush = {name = "Burning Rush",  insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""},
DarkPact = {name = "Dark Pact",  insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""},
}
local aff_artifact = {
name = "Tormented Souls",  insert = true, isArtifact = true, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls"
}
--- DESTRO -----------------------------------------------------------------------------------
local destro_SpellList = {
Immolate = {name = "Immolate",  insert = true, isTalentSpell = false, vis = true, id = 348, duration = 17.5, maxTime = 22, icon = "Interface/AddOns/iction/media/icons/immolate"},
Havoc = {name = "Havoc",  insert = true, isTalentSpell = false, vis = true, id = 80240, duration = 7, maxTime = 7, icon = "Interface/AddOns/iction/media/icons/baneofHavoc"},
DrainLife = {name = "Drain Life",  insert = true, isTalentSpell = false, vis = true, id = 689, duration = 4.6, maxTime = 4.6, icon = "Interface/AddOns/iction/media/icons/drainLife"},
ChannelDemonfire = {name = "Channel Demonfire",  insert = false, isTalentSpell = true, vis = false, id = 196447, duration = 2.6, maxTime = 2.6, icon = "Interface/AddOns/iction/media/icons/felflame"},
Eradication = {name = "Eradication",  insert = false, isTalentSpell = true, vis = false, id = nil, duration = 6, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/eradication"},
}
local destro_BuffList = {
Unending = {name = "Unending Resolve", insert = true, isTalentSpell = false, vis = true, id = 104773, duration = 8, maxTime = 8, icon = ""},
backdraft = {name = "Backdraft", insert = false, isTalentSpell = true, vis = false, id = nil, duration = 3, maxTime = 3, icon = "Interface/AddOns/iction/media/icons/backdraft"},
manaTap = {name = "Mana Tap", insert = false, isTalentSpell = true, vis = false, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"},
soulHarvest = {name = "Soul Harvest", insert = false, isTalentSpell = false, vis = true, id = 196098, duration = 10, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/soulHarvest"},
DarkPact = {name = "Dark Pact", insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""},
BurningRush = {name = "Burning Rush", insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""},
}

local destro_artifact = {name = "Dimensional Rift", insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 196586, duration = 4, maxTime = 8, icon = "Interface/AddOns/iction/media/icons/dimensionalRift" }
--- DEMO -------------------------------------------------------------------------------------
local demo_SpellList = {
                        Doom = {name = "Doom", insert = true, isTalentSpell = false, vis = true, id = 603, duration = 17.5, maxTime = 17.5, icon = ""},
}
local demo_BuffList = {
                         BurningRush = {name = "Burning Rush", insert = false, isTalentSpell = true, vis = false, id = 111400, duration = 999, maxTime = 999, icon = ""},
                         soulHarvest = {name = "Soul Harvest", insert = false, isTalentSpell = true, vis = false, id = 196098, duration = 10, maxTime = 30, icon = ""},
                         DarkPact = {name = "Dark Pact", insert = false, isTalentSpell = true, vis = false, id = 108416, duration = 20, maxTime = 20, icon = ""},
                         ShadowyInspiration = {name = "Shadowy Inspiration", insert = false, isTalentSpell = true, vis = false, id = 196606, duration = 14, maxTime = 14, icon = ""},
}
--Demonic Synergy 171982
local demo_artifact = {name = "Thal`kiel's Consumption", isArtifact = true, isTalentSpell = false, vis = true, id = 211714, duration = 4, maxTime = 8, icon = "Interface/AddOns/iction/media/icons/dimensionalRift" }

--- UTILS ------------------------------------------------------------------------------------
function iction.addButtonsToTable(buttonList, desttable)
    local bList = buttonList
    for _, data in pairs(bList) do
        if data["isTalentSpell"] then
            for x=1, 7 do
                for c=1, 3 do
                    local talentID, name, texture, selected, available = GetTalentInfo(x, c, 1)
                    if name == data['name'] and selected then
                        data['vis'] = true
                        data['insert'] = true
                        if data['name'] == "Drain Soul" and selected then
                            bList['DrainLife']['insert'] = false
                            bList['DrainSoul']['insert'] = true
                        end
                    end
                end
            end
        end
    end

    for _, data in pairs(bList) do
        if data['insert'] and data['vis'] then
            print(data['name'])
            table.insert(desttable, {name = data['name'],
                                     h = iction.bh,
                                     w = iction.bw,
                                     inherits = "SecureActionButtonTemplate",
                                     icon = data['icon'],
                                     id = data['id'],
                                     duration = data['duration'],
                                     maxTime = data['maxTime'],
                                     vis = data['vis']
                                     })
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