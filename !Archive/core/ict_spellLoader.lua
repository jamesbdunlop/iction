function iction.getAllSpells()
    local spells = {
                    [0] = nil,
                    [1] = {spells = {[0] = nil}}
                    }
    --- Trawl the entire spell book for pells. Sick of trying to figure out the most important going to leave this up
    --- to the user and a config panel.
    local numTabs = GetNumSpellTabs()
    for i=1,numTabs do
      local name, texture, offset, numSpells = GetSpellTabInfo(i)
      if name == iction.getSpecName() then
          for x=offset +1, offset + numSpells do
              local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(x, "spell")
                  if name and spellID and not IsPassiveSpell(spellID) then
                      spells[1].spells[spellID] = {}
                      spells[1].spells[spellID]['name'] = name
                      spells[1].spells[spellID]['id'] = spellID
                      spells[1].spells[spellID]['rank'] = rank
                      spells[1].spells[spellID]['castingTime'] = castingTime --returns in milliseconds so we should do *.001
                      spells[1].spells[spellID]['minRange'] = minRange
                      spells[1].spells[spellID]['maxRange'] = maxRange
                      spells[1].spells[spellID]['icon'] = icon
                      spells[1].spells[spellID]['insert'] = true
                      spells[1].spells[spellID]['isArtifact'] = false
                      spells[1].spells[spellID]['isTalentSpell'] = true
                      spells[1].spells[spellID]['vis'] = true
    end end end end
    --- Artifact
    table.insert(spells[1], iction.artifact())
    return spells
end

function iction.artifact()
    artifact = {}
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