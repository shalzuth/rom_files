QuestSymbolCheck = class("QuestSymbolCheck")
autoImport("QuestTypeConfig")
function QuestSymbolCheck.GetQuestSymbolByQuest(quest)
  if quest.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and quest.staticData.WhetherTrace ~= 3 then
    local symbolType = 100
    if quest.staticData.TraceInfo ~= "" then
      if symbolType > QuestSymbolType.TraceTalk then
        symbolType = QuestSymbolType.TraceTalk or symbolType
      end
    elseif quest.type and QuestDataTypeSymbolMap[quest.type] then
      return QuestDataTypeSymbolMap[quest.type]
    end
    if symbolType ~= 100 then
      return symbolType
    end
  end
end
function QuestSymbolCheck.HasDailySymbol(npcSData)
  if npcSData == nil then
    return false
  end
  if QuestSymbolCheck.HasSealSymbol(npcSData) then
    return true
  end
  if QuestSymbolCheck.HasInstituteSymbol(npcSData) then
    return true
  end
  if QuestSymbolCheck.HasWantedSymbol(npcSData) then
    return true
  end
  if QuestSymbolCheck.HasPveCardSymbolCheck(npcSData) then
    return true
  end
  return false
end
function QuestSymbolCheck.HasSealSymbol(npcSData)
  if npcSData then
    local npcFuncs = npcSData.NpcFunction
    if npcFuncs then
      for i = 1, #npcFuncs do
        local single = npcFuncs[i]
        local cfg = Table_NpcFunction[single.type]
        if cfg and cfg.Type == "seal" and FunctionUnLockFunc.Me():CheckCanOpenByPanelId(cfg.id, nil, MenuUnlockType.NpcFunction) then
          local sealDailyTime = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_SEAL)
          sealDailyTime = sealDailyTime or 0
          local maxSealTime = GameConfig.Seal.maxSealNum
          return sealDailyTime < maxSealTime
        end
      end
    else
      errorLog(string.format("npcSData not has npcFunction: %s", tostring(npcSData.id)))
    end
  end
  return false
end
function QuestSymbolCheck.HasInstituteSymbol(npcSData)
  if not npcSData then
    return false
  end
  local npcFuncs = npcSData.NpcFunction
  if npcFuncs == nil then
    errorLog(string.format("npcSData not has npcFunction: %s", tostring(npcSData.id)))
    return false
  end
  local canEnterInstitute = false
  for i = 1, #npcFuncs do
    local single = npcFuncs[i]
    local cfg = Table_NpcFunction[single.type]
    if cfg and cfg.NameEn == "Laboratory" and FunctionUnLockFunc.Me():CheckCanOpenByPanelId(cfg.id, nil, MenuUnlockType.NpcFunction) then
      canEnterInstitute = true
      break
    end
  end
  if canEnterInstitute then
    local instituteDailyTime = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_LABORATORY)
    instituteDailyTime = instituteDailyTime or 0
    return instituteDailyTime < 1
  end
  return false
end
function QuestSymbolCheck.HasWantedSymbol(npcSData)
  if not npcSData then
    return false
  end
  local npcFuncs = npcSData.NpcFunction
  if npcFuncs == nil then
    errorLog(string.format("npcSData not has npcFunction: %s", tostring(npcSData.id)))
    return false
  end
  for i = 1, #npcFuncs do
    local single = npcFuncs[i]
    local cfg = Table_NpcFunction[single.type]
    if cfg and cfg.Type == "wanted" and FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.AnnounceQuestPanel.id) then
      local wantedDailyTime = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
      wantedDailyTime = wantedDailyTime or 0
      local maxwantedTime = QuestProxy.Instance:getMaxWanted() or 0
      return wantedDailyTime < maxwantedTime
    end
  end
  return false
end
function QuestSymbolCheck.HasQuestSymbolByMap(mapid)
  local list = QuestProxy.Instance:getQuestListByMapAndSymbol(mapid)
  if list ~= nil and #list > 0 then
    return true
  end
  local questInfo = WorldMapProxy.Instance:GetWorldQuestInfo(mapid)
  if questInfo and (questInfo[1] or questInfo[2] or questInfo[3]) then
    return true
  end
  local config = Table_MapInfo and Table_MapInfo[mapid]
  if config then
    local units = config.units
    for id, _ in pairs(units) do
      local npcSData = Table_Npc[id]
      if npcSData and QuestSymbolCheck.HasDailySymbol(npcSData) then
        return true
      end
    end
  end
  return false
end
function QuestSymbolCheck.HasPveCardSymbolCheck(npcSData)
  if npcSData == nil then
    return false
  end
  local npcFuncs = npcSData.NpcFunction
  if npcFuncs == nil or #npcFuncs == 0 then
    return false
  end
  local table_NpcFunction = Table_NpcFunction
  local ftype, cfg, finded
  for i = 1, #npcFuncs do
    ftype = npcFuncs[i].type
    cfg = table_NpcFunction[ftype]
    if cfg and cfg.Type == "PveCardReward" then
      finded = true
      break
    end
  end
  if not finded then
    return false
  end
  local count = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_PVECARD_GETREWARD)
  return count == 0
end
