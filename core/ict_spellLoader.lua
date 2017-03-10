----------------------------------------------------------------------------------------------
--- Process Buttons ------------------------------------------------------------------------------------
function iction.addButtonsToTable(buttonList, desttable)
    local bList = buttonList
    for _, data in ipairs(bList) do
        for spellName, spellData in pairs(data) do
            if spellData["isTalentSpell"] then
                for x=1, 7 do
                    for c=1, 3 do
                        local _, name, _, selected, _, spellid = GetTalentInfo(x, c, 1)
                        --- how is it that ShadowyInsight talent and buff applied have different id's argh
                        if spellData['id'] == 124430 and spellid == 162452 then
                            if selected then
                                spellData['vis'] = true
                                spellData['insert'] = true
                            end
                        end
                        if spellData['tid'] ~= nil then
                            if spellid == spellData['tid'] and selected then
                                spellData['vis'] = true
                                spellData['insert'] = true
                                --- Drain soul / drain life spellButton switch
                                if spellData['tid'] == 198590 and selected then
                                    bList[4]['DrainLife']['insert'] = false
                                    bList[5]['DrainSoul']['insert'] = true
                                end
    end end end end end end end

    for _, data in ipairs(bList) do
        for _, spellData in pairs(data) do
            if spellData['insert'] then
                table.insert(desttable, {name = spellData['name'],
                                         h = iction.bh,
                                         w = iction.bw,
                                         inherits = "SecureActionButtonTemplate",
                                         id = spellData['id'],
                                         duration = spellData['duration'],
                                         maxTime = spellData['maxTime'],
                                         vis = spellData['vis']
                                         })
    end end end
end

function iction.tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local localizedClass, _, _ = UnitClass("Player")

function iction.setDebuffButtonLib()
    local buttonLib
    iction.uiPlayerSpellButtons = {}
    local spec = GetSpecialization()
    if spec == 1 then
        iction.addButtonsToTable(iction.spells[1]['spells'], iction.uiPlayerSpellButtons)
    elseif spec == 2 then
        iction.addButtonsToTable(iction.spells[2]['spells'], iction.uiPlayerSpellButtons)
    elseif spec == 3 then
        iction.addButtonsToTable(iction.spells[3]['spells'], iction.uiPlayerSpellButtons)
    end
end

function iction.setBuffButtonLib()
    local buttonLib
    iction.uiPlayerBuffButtons = {}
    local spec = GetSpecialization()
    if spec == 1 then
        iction.addButtonsToTable(iction.spells[1], iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = iction.spells[1]['artifact']
    elseif spec == 2 then
        iction.addButtonsToTable(iction.spells[2]['buffs'], iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = iction.spells[2]['artifact']
    elseif spec == 3 then
        iction.addButtonsToTable(iction.spells[3]['buffs'], iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = iction.spells[3]['artifact']
    end
end

function iction.getSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
    return currentSpecName
end

function iction.getAllSpells()
    local spells = {
        [0] = nil,
        [1] = {spells = {[0] = nil},
               artifact = {[0] = {name = "Tormented Souls", insert = true, isArtifact = true, isTalentSpell = false, vis = true, id = 216708, duration = 30, maxTime = 30 }
                          }
            }
    }
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
                  end
            end
      end
    end
    return spells
end