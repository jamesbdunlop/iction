----------------------------------------------------------------------------------------------
--- Process Buttons ------------------------------------------------------------------------------------
function iction.addButtonsToTable(buttonList, desttable)
    local bList = buttonList
    for _, data in ipairs(bList) do
        for spellName, spellData in pairs(data) do
            print("JAMES: " .. tostring(spellName))
            if spellData["isTalentSpell"] then
                for x=1, 7 do
                    for c=1, 3 do
                        local _, name, _, selected, _ = GetTalentInfo(x, c, 1)
                        if name == spellData['name'] and selected then
                            spellData['vis'] = true
                            spellData['insert'] = true
                            if spellData['name'] == "Drain Soul" and selected then
                                bList[4]['DrainLife']['insert'] = false
                                bList[5]['DrainSoul']['insert'] = true
    end end end end end end end

    for _, data in ipairs(bList) do
        for _, spellData in pairs(data) do
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
    end end end

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
        iction.addButtonsToTable(iction.spells[1]['buffs'], iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = iction.spells[1]['artifact']
    elseif spec == 2 then
        iction.addButtonsToTable(iction.spells[2]['buffs'], iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = iction.spells[2]['artifact']
    elseif spec == 3 then
        iction.addButtonsToTable(iction.spells[3]['buffs'], iction.uiPlayerBuffButtons)
        iction.uiPlayerArtifact = iction.spells[3]['artifact']
    end
end