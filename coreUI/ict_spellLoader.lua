local iction = iction
function iction.getAllSpells()
    local spells = {}
    --- Trawl the entire spell book for pells. Sick of trying to figure out the most important going to leave this up
    --- to the user and a config panel.
    local numTabs = GetNumSpellTabs()
    for i=1,numTabs do
      local name, texture, offset, numSpells = GetSpellTabInfo(i)
      if name == iction.getSpecName() then
          for x=offset +1, offset + numSpells do
              local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(x, "spell")
                  if name and spellID and not IsPassiveSpell(spellID) then
                      local spellData = {}
                      spellData['name'] = name
                      spellData['id'] = spellID
                      spellData['rank'] = rank
                      spellData['castingTime'] = castingTime --returns in milliseconds so we should do *.001
                      spellData['minRange'] = minRange
                      spellData['maxRange'] = maxRange
                      spellData['icon'] = icon
                      table.insert(spells, spellData)
    end end end end
    --- Artifact
    table.insert(spells, iction.artifact())
    return spells
end

function iction.artifact()
    local artifact = {}
    if iction.class == 'Warlock' then
        if iction.spec == 1 then
             artifact = {artifact = {name = "Tormented Souls", insert = true,
                                     isArtifact = true, isTalentSpell = false,
                                     vis = true, id = 216708,
                                     duration = 30, maxTime = 30
                                     }
                        }
        end
    end
    return artifact
end