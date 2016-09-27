----------------------------------------------------------------------------------------------
--- Define PLAYER SPELL & BUFF buttons -------------------------------------------------------
----------------------------------------------------------------------------------------------
--- AFFLICTION -------------------------------------------------------------------------------
local activeSpellBookSpells = {}
local aff_SpellList = {
                        UA = {name = "Unstable Affliction", isTalentSpell = false, vis = true, id = 30108, uration = 5, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/unstableAffliction"},
                        Corruption = {name = "Corruption", isTalentSpell = false, vis = true, id = 172, duration = 15, maxTime = 17.9, icon = "Interface/AddOns/iction/media/icons/corruption"},
                        DrainSoul = {name = "Drain Soul", isTalentSpell = false, vis = true, id = 198590, duration = 14, maxTime = 4.75, icon = "Interface/AddOns/iction/media/icons/drainSoul"},
                        Agony = {name = "Agony", isTalentSpell = false, vis = true, id = 980, duration = 17, maxTime = 24, icon = "Interface/AddOns/iction/media/icons/agony"},
                        SiphonLife = {name = "Siphon Life", isTalentSpell = false, vis = true, id = 63106, duration = 14, maxTime = 19.5, icon = "Interface/AddOns/iction/media/icons/siphonLife"},
                        Seed = {name = "Seed of Corruption", isTalentSpell = false, vis = true, id = 27243, duration = 13.9, maxTime = 13.9, icon = "Interface/AddOns/iction/media/icons/seedofcorruption"},
                        }
-- healthFunnel
local aff_BuffList = {
                      manaTap = {name = "Mana Tap", isArtifact = false, isTalentSpell = true,  vis = true, sbid = 44, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"},
                      reapSouls = {name = "Deadwind Harvester", isArtifact = false, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls"},
                      }
local aff_artifact = {
                      name = "Tormented Souls", isArtifact = true, isTalentSpell = false, vis = true, sbid = 46, id = 216708, duration = 30, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/reapsouls"
                      }
--- DESTRO -----------------------------------------------------------------------------------
local destro_SpellList = {
                        Immolate = {name = "Immolate", isTalentSpell = false, vis = true, id = 348, duration = 17.5, maxTime = 22, icon = "Interface/AddOns/iction/media/icons/immolate"},
                        Eradication = {name = "Eradication", isTalentSpell = true, vis = true, id = nil, duration = 6, maxTime = 6, icon = "Interface/AddOns/iction/media/icons/eradication"},
                        Havoc = {name = "Havoc", isTalentSpell = false, vis = true, id = 80240, duration = 7, maxTime = 7, icon = "Interface/AddOns/iction/media/icons/baneofHavoc"},
                        DrainLife = {name = "Drain Life", isTalentSpell = false, vis = true, id = 689, duration = 4.6, maxTime = 4.6, icon = "Interface/AddOns/iction/media/icons/drainLife"},
                        Demonfire = {name = "Channel Demonfire", isTalentSpell = true, vis = true, id = 196448, duration = 7, maxTime = 7, icon = "Interface/AddOns/iction/media/icons/felflame"},
}
local destro_BuffList = {
                         backdraft = {name = "Backdraft", isTalentSpell = true, vis = true, id = nil, duration = 3, maxTime = 3, icon = "Interface/AddOns/iction/media/icons/backdraft"},
                         manaTap    = {name = "Mana Tap", isTalentSpell = true, vis = true, id = 196104, duration = 20, maxTime = 26, icon = "Interface/AddOns/iction/media/icons/manaTap"},
                         soulHarvest    = {name = "Soul Harvest", isTalentSpell = true, vis = true, id = 196098, duration = 10, maxTime = 30, icon = "Interface/AddOns/iction/media/icons/soulHarvest"},
}

local destro_artifact = {name = "Dimensional Rift", isArtifact = true, isTalentSpell = false, vis = true, id = 196586, duration = 4, maxTime = 8, icon = "Interface/AddOns/iction/media/icons/dimensionalRift" }
--- DEMO -------------------------------------------------------------------------------------

--- UTILS ------------------------------------------------------------------------------------
function iction.addButtonsToTable(buttonList, desttable)
    if iction.debug then print("Dbg: iction.addButtonsToTable ") end
    for _, data in pairs(buttonList) do
        local insert = true
        if data["isTalentSpell"] then
            insert = false
            for x=1, 7 do
                for c=1, 3 do
                    local talentID, name, texture, selected, available = GetTalentInfo(x, c, 1)
                    if name == data['name'] and selected then
                        insert = true
                    end
                end
            end
        end

        if insert then
            if iction.debug then print("\t inserting button: " .. data['name']) end
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
    elseif spec == 3 then
        iction.addButtonsToTable(destro_BuffList, iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = destro_artifact
    end
end