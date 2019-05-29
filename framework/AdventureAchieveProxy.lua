AdventureAchieveProxy = class("AdventureAchieveProxy", pm.Proxy)
AdventureAchieveProxy.Instance = nil
AdventureAchieveProxy.NAME = "AdventureAchieveProxy"
autoImport("AdventureAchieveData")
autoImport("AdventureAchieveBagData")
AdventureAchieveProxy.Instance = nil
AdventureAchieveProxy.InitBag = {
  AchieveCmd_pb.EACHIEVETYPE_USER,
  AchieveCmd_pb.EACHIEVETYPE_SOCIAL,
  AchieveCmd_pb.EACHIEVETYPE_ADVENTURE,
  AchieveCmd_pb.EACHIEVETYPE_BATTLE,
  AchieveCmd_pb.EACHIEVETYPE_ACTIVITY,
  AchieveCmd_pb.EACHIEVETYPE_OTHER,
  AchieveCmd_pb.EACHIEVETYPE_DRAMA
}
AdventureAchieveProxy.HomeCategoryId = 1000000
local tempArrayData = {}
function AdventureAchieveProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AdventureAchieveProxy.NAME
  if AdventureAchieveProxy.Instance == nil then
    AdventureAchieveProxy.Instance = self
  end
  self.categoryDatas = {}
  self.reverseDatas = {}
  self:initAchieveData()
  self.bagMap = {}
  for k, v in pairs(AdventureAchieveProxy.InitBag) do
    local bagData = AdventureAchieveBagData.new(nil, v)
    self.bagMap[v] = bagData
  end
  self.advanceClasses = {}
  self.currentCgPfNum = 3
  self:addAchieveToBag()
  self:initChangePfData()
end
function AdventureAchieveProxy:addAchieveToBag()
  for k, v in pairs(self.categoryDatas) do
    if v.childs then
      local bagData = self.bagMap[k]
      if bagData then
        for k1, v1 in pairs(v.childs) do
          for i = 1, #v1.types do
            local single = v1.types[i]
            local data = {
              id = single.id
            }
            local item = AdventureAchieveData.new(data)
            if item.staticData then
              bagData:AddItem(item)
            end
          end
        end
      end
    end
  end
end
function AdventureAchieveProxy:initChangePfData()
  for key, value in pairs(Table_Class) do
    local advanceClasses = value.AdvanceClass
    if advanceClasses then
      for j = 1, #advanceClasses do
        local single = advanceClasses[j]
        self.advanceClasses[single] = value
      end
    end
  end
end
function AdventureAchieveProxy:getCategoryRedtip(id)
  local category = self.categoryDatas[id]
  if category and category.childs then
    local list = {}
    for k, v in pairs(category.childs) do
      if v.staticData.RedTip then
        list[#list + 1] = v.staticData.RedTip
      end
    end
    return list
  end
end
function AdventureAchieveProxy:initAchieveData()
  self.categoryDatas[AdventureAchieveProxy.HomeCategoryId] = {
    staticData = Table_Achievement[AdventureAchieveProxy.HomeCategoryId]
  }
  for k, v in pairs(Table_Achievement) do
    if v.Tier == 3 then
      local subData = Table_Achievement[v.SubGroup]
      if subData and subData.SubGroup then
        local uperData = Table_Achievement[subData.SubGroup]
        if uperData then
          if not self.categoryDatas[uperData.id] then
            local categorys = {staticData = uperData}
          end
          local childs = categorys.childs or {}
          if not childs[v.SubGroup] then
            local child = {staticData = subData}
          end
          local types = child.types or {}
          table.insert(types, v)
          child.types = types
          childs[v.SubGroup] = child
          categorys.childs = childs
          self.categoryDatas[uperData.id] = categorys
          self.reverseDatas[k] = {subData, uperData}
        end
      end
    end
  end
end
function AdventureAchieveProxy:getTopCategoryIdByAchiveId(id)
  if self.reverseDatas[id] then
    local data = self.reverseDatas[id]
    return data[2].id
  end
end
function AdventureAchieveProxy:QueryAchieveDataAchCmd(data)
  local type = data.type
  local bagData = self.bagMap[type]
  if bagData then
    bagData:UpdateItems(data)
    self:CheckRedTips(bagData)
  end
end
function AdventureAchieveProxy:CheckRedTips(bagData)
  for k1, v1 in pairs(bagData.tabs) do
    local tbs = v1:GetItems()
    local addRedTip = false
    local RedTip = v1.tab.RedTip
    if RedTip then
      for i = 1, #tbs do
        local single = tbs[i]
        if single:canGetReward() then
          addRedTip = true
          break
        end
      end
      if addRedTip then
        RedTipProxy.Instance:UpdateRedTip(RedTip)
      else
        RedTipProxy.Instance:RemoveWholeTip(RedTip)
      end
    else
    end
  end
end
function AdventureAchieveProxy:QueryUserResumeAchCmd(data)
  local userResume = data.data
  self.createtime = userResume.createtime
  self.logintime = userResume.logintime
  self.bepro_1_time = userResume.bepro_1_time
  self.bepro_2_time = userResume.bepro_2_time
  self.bepro_3_time = userResume.bepro_3_time
  self.walk_distance = userResume.walk_distance
  self.max_team = userResume.max_teams
  self.max_hand = userResume.max_hands
  self.max_wheel = userResume.max_wheels
  self.max_chat = userResume.max_chats
  self.max_music = userResume.max_music
  self.max_save = userResume.max_save
  self.max_besave = userResume.max_besave
end
function AdventureAchieveProxy:GetLastTenAchieveDatas()
  local items = {}
  for k, v in pairs(self.bagMap) do
    local tbs = v:GetItems()
    for i = 1, #tbs do
      if tbs[i]:getCompleteString() then
        items[#items + 1] = tbs[i]
      end
    end
  end
  table.sort(items, function(l, r)
    if l.finishtime == r.finishtime then
      return l.id < r.id
    elseif l.finishtime == nil then
      return false
    elseif r.finishtime == nil then
      return true
    else
      return l.finishtime > r.finishtime
    end
  end)
  return items
end
function AdventureAchieveProxy:getTabsByCategory(categoryId)
  return self.categoryDatas[categoryId]
end
function AdventureAchieveProxy:getTotalAchieveProgress()
  local unlock = 0
  local total = 0
  for k, v in pairs(AdventureAchieveProxy.InitBag) do
    local unlock1, total1 = self:getAchieveAndTotalNum(v)
    unlock = unlock + unlock1
    total = total + total1
  end
  return unlock, total
end
function AdventureAchieveProxy:getAchieveAndTotalNum(categoryId, SubGroup)
  local unlock = 0
  local total = 0
  local bagData = self.bagMap[categoryId]
  if bagData then
    local items = bagData:GetItems(SubGroup)
    if items and #items > 0 then
      total = #items
      for i = 1, #items do
        local single = items[i]
        if single:getCompleteString() then
          unlock = unlock + 1
        end
      end
    end
  end
  return unlock, total
end
