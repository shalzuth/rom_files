autoImport("AutoAimMonsterData")
FunctionMonster = class("FunctionMonster")
FunctionMonster.Priority = {
  MVP = 1,
  MINI = 2,
  Monster = 3
}
function FunctionMonster.Me()
  if nil == FunctionMonster.me then
    FunctionMonster.me = FunctionMonster.new()
  end
  return FunctionMonster.me
end
function FunctionMonster:ctor()
  self.monsterList = {}
  self.monsterStaticInfoMap = {}
  self.monsterStaticInfoList = {}
end
function FunctionMonster:FilterMonster(ignoreSkill)
  TableUtility.ArrayClear(self.monsterList)
  local userMap = NSceneNpcProxy.Instance.userMap
  local hasLearnMvp, hasLearnMini = true, true
  if ignoreSkill ~= true then
    hasLearnMvp = SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchmvpskill)
    hasLearnMini = SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchminiskill)
  end
  for _, monster in pairs(userMap) do
    if monster.data and monster.data:IsMonster() then
      if monster.data.staticData.Type == "MVP" then
        if hasLearnMvp then
          table.insert(self.monsterList, monster.data.id)
        end
      elseif monster.data.staticData.Type == "MINI" then
        if hasLearnMini then
          table.insert(self.monsterList, monster.data.id)
        end
      else
        table.insert(self.monsterList, monster.data.id)
      end
    end
  end
  return self.monsterList
end
function FunctionMonster:FilterMonsterStaticInfo()
  TableUtility.TableClear(self.monsterStaticInfoMap)
  local npcMap = NSceneNpcProxy.Instance.npcMap
  local hasLearnMvp = SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchmvpskill)
  local hasLearnMini = SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchminiskill)
  local hasMvpOrMini = false
  for npcID, npcList in pairs(npcMap) do
    if npcList and #npcList > 0 then
      local monster = npcList[1]
      if monster.data and monster.data:IsMonster() and self:CanSearchMonster(monster, hasLearnMvp, hasLearnMini) and self.monsterStaticInfoMap[npcID] == nil then
        local data = AutoAimMonsterData.new()
        data:SetId(npcID)
        data:SetLevel(monster.data:GetBaseLv())
        data:SetBossType(monster:GetBossType())
        self.monsterStaticInfoMap[npcID] = data
        if monster.data:IsBoss() or monster.data:IsMini() then
          hasMvpOrMini = true
        end
      end
    end
  end
  return self.monsterStaticInfoMap, hasMvpOrMini
end
function FunctionMonster:SortMonsterStaticInfo()
  TableUtility.ArrayClear(self.monsterStaticInfoList)
  for k, v in pairs(self.monsterStaticInfoMap) do
    table.insert(self.monsterStaticInfoList, v)
  end
  table.sort(self.monsterStaticInfoList, function(l, r)
    local ldata = Table_Monster[l:GetId()]
    local rdata = Table_Monster[r:GetId()]
    if ldata and rdata then
      if ldata.Type ~= rdata.Type then
        return self.Priority[ldata.Type] < self.Priority[rdata.Type]
      else
        return l:GetLevel() < r:GetLevel()
      end
    else
      return false
    end
  end)
  return self.monsterStaticInfoList
end
function FunctionMonster:CanSearchMonster(monster, hasLearnMvp, hasLearnMini)
  local sdata = monster.data.staticData
  local can = false
  if sdata.Type == "MVP" then
    if hasLearnMvp then
      can = true
    end
  elseif sdata.Type == "MINI" then
    if hasLearnMini then
      can = true
    end
  elseif sdata.Body == nil then
    can = false
  else
    can = true
  end
  return can
end
