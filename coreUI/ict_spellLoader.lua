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
                            spellData['uiName'] = name
                            spellData['id'] = spellID
                            spellData['rank'] = rank
                            spellData['castingTime'] = castingTime --returns in milliseconds so we should do *.001
                            spellData['minRange'] = minRange
                            spellData['maxRange'] = maxRange
                            spellData['icon'] = icon
                      table.insert(spells, spellData)
    end end end end
    return spells
end

local localizedClass, _, _ = UnitClass("Player")
function iction.artifact()
    local artifact = {}
    if localizedClass == 'Warlock' then
        if GetSpecialization() == 1 then
             artifact = {uiName = "Tormented Souls", id = 216695}
        elseif GetSpecialization() == 2 then
             artifact = {uiName = "Thal`kiel's Consumption", id = 211714}
        elseif GetSpecialization() == 3 then
             artifact = {uiName = "Dimensional Rift", id = 196586}
        end
    elseif localizedClass == 'Priest' then
        if GetSpecialization() == 1 then
             artifact = {uiName = "", id = 1}
        elseif GetSpecialization() == 2 then
             artifact = {uiName = "", id = 1}
        elseif GetSpecialization() == 3 then
             artifact = {uiName = "Void Torrent", id = 205065}
        end
    end
    return artifact
end