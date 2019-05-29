function Game.Preprocess_Table()
  Game.Preprocess_UnionConfig()
  Game.Preprocess_BranchConfig()
  Game.Preprocess_Table_ActionAnime()
  Game.Preprocess_Table_Achievement()
  Game.Preprocess_Table_BuffState()
  Game.Preprocess_Table_BuffStateOdds()
  Game.Preprocess_Table_RoleData()
  Game.Preprocess_Table_ItemType()
  Game.Preprocess_Table_Reward()
  Game.Preprocess_Table_ActionEffect()
  Game.Preprocess_Equip()
  Game.Preprocess_Pet()
  Game.Preprocess_Menu()
  Game.Preprocess_PoemStep()
  Game.Preprocess_ActivityInfo()
  Game.Preprocess_BossCompose()
  Game.Preprocess_AppleStore_Verify()
end
local PreprocessEffectPaths = function(paths)
  if nil ~= paths then
    if nil == paths[2] then
      paths[2] = paths[1]
    elseif "none" == paths[2] then
      paths[2] = nil
    end
  end
  return paths
end
Game.PreprocessEffectPaths = PreprocessEffectPaths
local myBranchValue = EnvChannel.BranchBitValue[EnvChannel.Channel.Name]
local RemoveConfigByBranch = function(mapConfig, config, tablename)
  if mapConfig and config then
    for k, v in pairs(mapConfig) do
      if v & myBranchValue > 0 then
        config[k] = nil
      end
    end
  end
end
local g_table
local forbidCfg = GameConfig.Forbid
local HandleForbidByType1 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, indexCfg in pairs(cfg) do
      if type(indexCfg) ~= "table" or #indexCfg ~= 2 then
        redlog("\233\133\141\231\189\174\230\160\188\229\188\143\229\135\186\233\148\153\239\188\140ftype_start_end \231\177\187\229\158\139\229\143\170\232\131\189\233\133\141\231\189\174table\231\177\187\229\158\139,\229\143\170\230\156\137\232\181\183\229\167\139ID\227\128\129\230\136\170\230\173\162ID")
        return
      end
      if bit & myBranchValue > 0 then
        for tabKey, _ in pairs(tab) do
          if tabKey >= indexCfg[1] and tabKey <= indexCfg[2] then
            if nil == tab[tabKey] then
              redlog("\229\177\143\232\148\189\233\133\141\231\189\174\228\184\186\231\169\186! ", tabName, " \229\177\143\232\148\189\231\177\187\229\158\139ftype_start_end\239\188\140\233\148\153\232\175\175ID: ", tabKey)
            else
              tab[tabKey] = nil
            end
          end
        end
      end
    end
  end
end
local HandleForbidByType2 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, startID in pairs(cfg) do
      if type(startID) ~= "number" then
        redlog("\233\133\141\231\189\174\230\160\188\229\188\143\229\135\186\233\148\153\239\188\140ftype_start \231\177\187\229\158\139\229\143\170\232\131\189\233\133\141\231\189\174number\231\177\187\229\158\139\232\181\183\229\167\139ID\239\188\137")
        return
      end
      if bit & myBranchValue > 0 then
        for tabKey, _ in pairs(tab) do
          if startID <= tabKey then
            if nil == tab[tabKey] then
              redlog("\229\177\143\232\148\189\233\133\141\231\189\174\228\184\186\231\169\186! ", tabName, " \231\177\187\229\158\139ftype_start\239\188\140\233\148\153\232\175\175ID: ", tabKey)
            else
              tab[tabKey] = nil
            end
          end
        end
      end
    end
  end
end
local HandleForbidByType3 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, ftab in pairs(cfg) do
      if bit & myBranchValue > 0 then
        if type(ftab) ~= "table" then
          redlog("\233\133\141\231\189\174\230\160\188\229\188\143\229\135\186\233\148\153\239\188\140ftype_id \231\177\187\229\158\139\229\143\170\232\131\189\233\133\141\231\189\174table\231\177\187\229\158\139\231\154\132ID\233\155\134\229\144\136")
          return
        end
        for i = 1, #ftab do
          if nil == tab[ftab[i]] then
            redlog("\229\177\143\232\148\189\233\133\141\231\189\174\228\184\186\231\169\186! ", tabName, " \231\177\187\229\158\139ftype_id\239\188\140\233\148\153\232\175\175ID: ", ftab[i])
          else
            tab[ftab[i]] = nil
          end
        end
      end
    end
  end
end
local HandleForbidByType4 = function(cfg, tab, tabName)
  if cfg and tab then
    local tName = "Table_" .. tabName
    local exitSTab = nil ~= _G[tName .. "_s"]
    tab = exitSTab and _G[tName .. "_s"] or tab
    for bit, singleCfg in pairs(cfg) do
      if bit & myBranchValue > 0 then
        for i = 1, #singleCfg do
          local cfg = singleCfg[i]
          local dirtyArray = {}
          for k, v in pairs(tab) do
            dirtyArray[k] = false
          end
          for cfgK, cfgV in pairs(cfg) do
            for tabK, tabV in pairs(tab) do
              local tV = exitSTab and StrTablesManager.GetData(tName, tabK) or tabV
              if tV[cfgK] ~= cfgV then
                dirtyArray[tabK] = true
              end
            end
          end
          for key, flag in pairs(dirtyArray) do
            if false == flag then
              tab[key] = nil
            end
          end
        end
      end
    end
  end
end
local HandleForbidByType5 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, ftab in pairs(cfg) do
      if bit & myBranchValue > 0 then
        if type(ftab) ~= "table" then
          redlog("\233\133\141\231\189\174\230\160\188\229\188\143\229\135\186\233\148\153\239\188\140ftype_petAvatar \231\177\187\229\158\139\229\143\170\232\131\189\233\133\141\231\189\174table\231\177\187\229\158\139\231\154\132ID\233\155\134\229\144\136")
          return
        end
        for i = 1, #ftab do
          for bodyID, bodyTab in pairs(tab) do
            for partId, partTab in pairs(bodyTab) do
              for k, v in pairs(partTab) do
                if v.id == ftab[i] then
                  tab[bodyID][partId][k].forbidFlag = true
                end
              end
            end
          end
        end
      end
    end
  end
end
function Game.Preprocess_BranchConfig()
  if GameConfig.BranchForbid then
    local g_table
    for k, v in pairs(GameConfig.BranchForbid) do
      for tablename, t in pairs(v) do
        g_table = _G["Table_" .. tablename]
        if g_table then
          RemoveConfigByBranch(t, g_table)
        end
      end
    end
  end
  local forbidHandle = {}
  forbidHandle.ftype_start_end = HandleForbidByType1
  forbidHandle.ftype_start = HandleForbidByType2
  forbidHandle.ftype_id = HandleForbidByType3
  forbidHandle.ftype_params = HandleForbidByType4
  forbidHandle.ftype_petAvatar = HandleForbidByType5
  if forbidCfg then
    for tabName, forbid_cfg in pairs(forbidCfg) do
      g_table = _G["Table_" .. tabName]
      if g_table then
        for ftype, v in pairs(forbid_cfg) do
          local call = forbidHandle[ftype]
          if call then
            call(v, g_table, tabName)
          else
            redlog("\229\177\143\232\148\189\233\133\141\231\189\174\231\177\187\229\158\139\229\161\171\229\134\153\233\148\153\232\175\175\239\188\140", tabName, "\233\148\153\232\175\175\231\177\187\229\158\139\239\188\154", ftype)
          end
        end
      end
    end
  end
  if GameConfig.SystemForbid then
    for k, v in pairs(GameConfig.SystemForbid) do
      GameConfig.SystemForbid[k] = v & myBranchValue > 0 and true or false
    end
  else
    GameConfig.SystemForbid = {}
  end
end
function Game.Preprocess_Table_RoleData()
  local propNameConfig = {}
  for k, v in pairs(Table_RoleData) do
    propNameConfig[v.VarName] = v
  end
  Game.Config_PropName = propNameConfig
end
function Game.Preprocess_Table_ActionAnime()
  local actionConfig = {}
  local actionConfig_HideWeapon = {}
  for k, v in pairs(Table_ActionAnime) do
    actionConfig[v.Name] = v
  end
  Game.Config_Action = actionConfig
end
function Game.Preprocess_Table_Achievement()
  local titleAchievemnetConfig = {}
  for k, v in pairs(Table_Achievement) do
    if v.RewardItems and v.RewardItems[1] and v.RewardItems[1][1] then
      local titleID = v.RewardItems[1][1]
      titleAchievemnetConfig[titleID] = v
    end
  end
  Game.Config_TitleAchievemnet = titleAchievemnetConfig
end
function Game.Preprocess_Table_BuffState()
  local buffConfig = {}
  for k, v in pairs(Table_BuffState) do
    local config = {
      Effect_start = PreprocessEffectPaths(StringUtil.Split(v.Effect_start, ",")),
      Effect_startAt = PreprocessEffectPaths(StringUtil.Split(v.Effect_startAt, ",")),
      Effect_hit = PreprocessEffectPaths(StringUtil.Split(v.Effect_hit, ",")),
      Effect_end = PreprocessEffectPaths(StringUtil.Split(v.Effect_end, ",")),
      Effect = PreprocessEffectPaths(StringUtil.Split(v.Effect, ",")),
      Effect_around = PreprocessEffectPaths(StringUtil.Split(v.Effect_around, ",")),
      EffectGroup = PreprocessEffectPaths(StringUtil.Split(v.EffectGroup, ",")),
      EffectGroup_around = PreprocessEffectPaths(StringUtil.Split(v.EffectGroup_around, ","))
    }
    buffConfig[k] = config
  end
  Game.Config_BuffState = buffConfig
end
function Game.Preprocess_Table_BuffStateOdds()
  local buffConfig = {}
  for k, v in pairs(Table_BuffStateOdds) do
    local config = {
      Effect = PreprocessEffectPaths(StringUtil.Split(v.Effect, ",")),
      EP = v.EP
    }
    buffConfig[k] = config
  end
  Game.Config_BuffStateOdds = buffConfig
end
local function _Preprocess_Reward_GetRewardDataByTeam(teamId, teamMap)
  local list = {}
  local singleTeamList = teamMap[teamId]
  if not singleTeamList then
    redlog(string.format("Rward\232\161\168\228\184\173\228\184\141\229\173\152\229\156\168team\228\184\186%s\231\154\132\233\133\141\231\189\174!!!!!!!!!!!!!!!!", teamId))
    return list
  end
  for k, v in pairs(singleTeamList) do
    if v.type == 3 or v.type == 4 then
      for _, rTeamIds in pairs(v.item) do
        local rewardItems = _Preprocess_Reward_GetRewardDataByTeam(rTeamIds.id, teamMap)
        TableUtil.InsertArray(list, rewardItems)
      end
    else
      for _, ritems in pairs(v.item) do
        local hasAdd = false
        for j = 1, #list do
          local tmp = list[j]
          if tmp.id == ritems.id then
            tmp.num = tmp.num + ritems.num
            hasAdd = true
            break
          end
        end
        if not hasAdd then
          local data = {}
          data.id = ritems.id
          data.num = ritems.num
          data.rewardType = v.type
          table.insert(list, data)
        end
      end
    end
  end
  return list
end
function Game.Preprocess_Table_Reward()
  local teamMap = {}
  for k, v in pairs(Table_Reward) do
    local list = teamMap[v.team]
    if list == nil then
      list = {}
      teamMap[v.team] = list
    end
    list[#list + 1] = v
  end
  Game.Config_RewardTeam = {}
  for k, v in pairs(teamMap) do
    local itemList = _Preprocess_Reward_GetRewardDataByTeam(k, teamMap)
    Game.Config_RewardTeam[k] = itemList
  end
  Table_Reward = nil
  _G.Table_Reward = nil
end
function Game.Preprocess_Table_ItemType()
  local types = {}
  local t
  for k, v in pairs(Table_ItemType) do
    if v.Typegroup then
      t = types[v.Typegroup]
      if t == nil then
        t = {}
        types[v.Typegroup] = t
      end
      t[#t + 1] = v.id
    end
  end
  Game.Config_ItemTypeGroup = types
end
function Game.Preprocess_Table_ActionEffect()
  local actionConfig = {}
  for k, v in pairs(Table_ActionEffect) do
    local config = actionConfig[v.BodyID]
    if config == nil then
      config = {}
      actionConfig[v.BodyID] = config
    end
    config[#config + 1] = v.id
  end
  Game.Config_ActionEffect = actionConfig
end
function Game.Preprocess_AppleStore_Verify()
  if not Game.inAppStoreReview then
    return
  end
  if Table_Npc then
    local npc_2156 = Table_Npc[2156]
    local npcFunction = npc_2156 and npc_2156.NpcFunction
    if npcFunction then
      for i = #npcFunction, 1, -1 do
        if npcFunction[i] and npcFunction[i].type == 4025 then
          table.remove(npcFunction, i)
          break
        end
      end
    end
  end
end
local ImportUnionConfig = function()
  autoImport("UnionConfig")
end
pcall(ImportUnionConfig)
function Game._deepCopy(srt, ret)
  for k, v in pairs(srt) do
    if type(v) == "table" then
      if type(ret[k]) == "table" then
        Game._deepCopy(v, ret[k])
      else
        ret[k] = v
      end
    else
      ret[k] = v
    end
  end
end
function Game.Preprocess_UnionConfig()
  if UnionConfig == nil then
    return
  end
  Game._deepCopy(UnionConfig, GameConfig)
end
function Game.Preprocess_Equip()
  Game.Config_BodyDisplay = {}
  for k, v in pairs(Table_Equip) do
    if v.Body and v.display and v.display > 0 then
      Game.Config_BodyDisplay[v.Body] = v.display
    end
  end
end
function Game.Preprocess_Pet()
  local map = {}
  for k, v in pairs(Table_Pet) do
    if v.EggID then
      if map[v.EggID] == nil then
        map[v.EggID] = v
      else
        redlog("One pet egg ID corresponds to multiple pet eggs", v.EggID)
      end
    end
  end
  Game.Config_EggPet = map
end
function Game.Preprocess_Menu()
  Game.Config_UnlockActionIds = {}
  Game.Config_UnlockEmojiIds = {}
  for k, v in pairs(Table_Menu) do
    local evt = v.event
    if evt then
      if evt.type == "unlockaction" then
        if evt.param then
          for k1, v1 in pairs(evt.param) do
            Game.Config_UnlockActionIds[v1] = 1
          end
        end
      elseif evt.type == "unlockexpression" and evt.param then
        for k1, v1 in pairs(evt.param) do
          Game.Config_UnlockEmojiIds[v1] = 1
        end
      end
    end
  end
end
function Game.Preprocess_PoemStep()
  Game.PoemStepDic = {}
  for k, v in pairs(Table_PoemStep) do
    if not Game.PoemStepDic[v.Questid] then
      Game.PoemStepDic[v.Questid] = {}
    end
    table.insert(Game.PoemStepDic[v.Questid], v.id)
  end
  for k, v in pairs(Table_PomeStory) do
    local showlist = {}
    local option1 = {}
    local option2 = {}
    if v.QuestID then
      for i = 1, #v.QuestID do
        local steplist = Game.PoemStepDic[v.QuestID[i]]
        if steplist then
          for j = 1, #steplist do
            showlist[#showlist + 1] = steplist[j]
          end
        end
      end
    end
    if v.NoMustQuestID then
      local n1 = v.NoMustQuestID[1]
      local n2 = v.NoMustQuestID[2]
      if n1 then
        for i = 1, #n1 do
          local steplistn1 = Game.PoemStepDic[n1[i]]
          if steplistn1 then
            for i = 1, #steplistn1 do
              option1[#option1 + 1] = steplistn1[i]
            end
          end
        end
      end
      if n1 then
        for i = 1, #n2 do
          local steplistn2 = Game.PoemStepDic[n2[i]]
          if steplistn2 then
            for i = 1, #steplistn2 do
              option2[#option2 + 1] = steplistn2[i]
            end
          end
        end
      end
    end
    table.sort(showlist, function(l, r)
      return l < r
    end)
    table.sort(option1, function(l, r)
      return l < r
    end)
    table.sort(option2, function(l, r)
      return l < r
    end)
    v.ShowList = showlist
    v.Option1 = option1
    v.Option2 = option2
  end
end
function Game.Preprocess_ActivityInfo()
  if not Table_ActivityInfo then
    return
  end
  for k, v in pairs(Table_ActivityInfo) do
    if v.StartTime then
      local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(v.StartTime)
      starttime = os.time({
        day = st_day,
        month = st_month,
        year = st_year,
        hour = st_hour,
        min = st_min,
        sec = st_sec
      })
      v.StartTimeStamp = starttime
    end
    if v.EndTime then
      local end_year, end_month, end_day, end_hour, end_min, end_sec = StringUtil.GetDateData(v.EndTime)
      endtime = os.time({
        day = end_day,
        month = end_month,
        year = end_year,
        hour = end_hour,
        min = end_min,
        sec = end_sec
      })
      v.EndTimeStamp = endtime
    end
  end
end
function Game.Preprocess_PoemStory()
  local qid = 0
  for k, v in pairs(Table_PomeStory) do
    local checkmap = {}
    if v.QuestID then
      for i = 1, #v.QuestID do
        qid = math.modf(v.QuestID[i] / 10000)
        if not checkmap[qid] then
          checkmap[qid] = qid
        end
      end
    end
    if v.NoMustQuestID then
      for i = 1, #v.NoMustQuestID do
        local Nolist1 = v.NoMustQuestID[1]
        local Nolist2 = v.NoMustQuestID[2]
        for j = 1, #Nolist1 do
          qid = math.modf(Nolist1[j] / 10000)
          if not checkmap[qid] then
            checkmap[qid] = qid
          end
        end
        for k = 1, #Nolist2 do
          qid = math.modf(Nolist2[k] / 10000)
          if not checkmap[qid] then
            checkmap[qid] = qid
          end
        end
      end
    end
    table.sort(showlist, function(l, r)
      return l < r
    end)
    table.sort(option1, function(l, r)
      return l < r
    end)
    table.sort(option2, function(l, r)
      return l < r
    end)
    v.ShowList = showlist
    v.Option1 = option1
    v.Option2 = option2
    if not v.CheckList then
      v.CheckList = {}
      for n, m in pairs(checkmap) do
        table.insert(v.CheckList, m)
      end
    end
  end
end
local composeid = GameConfig.Card.composeid
function Game.Preprocess_BossCompose()
  if Table_Compose[2000] then
    local productRates = Table_Compose[composeid].RandomProduct
    local len = #productRates
    local total = 0
    for i = 1, len do
      local single = productRates[i]
      if Table_Card[single.id] then
        total = total + single.weight
        Table_Card[single.id].WeightShow = single.weight
      end
    end
    GameConfig.Card.TotalWeight = total
  end
end
