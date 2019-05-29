LogicManager_RoleDress = class("LogicManager_RoleDress")
LogicManager_RoleDress.Priority = {
  Normal = 1,
  Friend = 2,
  Guild = 3,
  Team = 4,
  _Count = 4
}
local FindHighAndLowPriorityCreature = function(creatures, highPriorityCreature, highPriority, lowPriorityCreature, lowPriority)
  local highIndex = 0
  local lowIndex = 0
  local creatureCount = #creatures
  if creatureCount > 0 then
    for i = 1, creatureCount do
      local creature = creatures[i]
      local priority = creature:GetDressPriority()
      if highPriority < priority then
        highPriorityCreature = creature
        highPriority = priority
        highIndex = i
      end
      if lowPriority > priority then
        lowPriorityCreature = creature
        lowPriority = priority
        lowIndex = i
      end
    end
  end
  return highPriorityCreature, highPriority, highIndex, lowPriorityCreature, lowPriority, lowIndex
end
local FindHighPriorityCreature = function(creatures, highPriorityCreature, highPriority)
  local index = 0
  local creatureCount = #creatures
  if creatureCount > 0 then
    for i = 1, creatureCount do
      local creature = creatures[i]
      local priority = creature:GetDressPriority()
      if highPriority < priority then
        highPriorityCreature = creature
        highPriority = priority
        index = i
      end
    end
  end
  return highPriorityCreature, highPriority, index
end
function LogicManager_RoleDress:ctor()
  self.dressedCreatures = {}
  self.dressedCount = 0
  self.undressedCreatures = {}
  self.undressedCount = 0
  for i = 1, LogicManager_RoleDress.Priority._Count do
    self.dressedCreatures[i] = {}
    self.undressedCreatures[i] = {}
  end
  self.limitCount = 0
  self.dressDisable = false
  self.waitingDressedCreatures = {}
  self.waitingUndressedCreatures = {}
end
function LogicManager_RoleDress:Add(creature)
  if creature:IsDressEnable() then
    TableUtility.ArrayPushBack(self.waitingDressedCreatures, creature)
  else
    TableUtility.ArrayPushBack(self.waitingUndressedCreatures, creature)
  end
end
function LogicManager_RoleDress:Remove(creature)
  local priority = creature:GetDressPriority()
  if creature:IsDressEnable() then
    if 0 < TableUtility.ArrayRemove(self.dressedCreatures[priority], creature) then
      self.dressedCount = self.dressedCount - 1
      return
    end
    TableUtility.ArrayRemove(self.waitingDressedCreatures, creature)
  else
    if 0 < TableUtility.ArrayRemove(self.undressedCreatures[priority], creature) then
      self.undressedCount = self.undressedCount - 1
      return
    end
    TableUtility.ArrayRemove(self.waitingUndressedCreatures, creature)
  end
end
function LogicManager_RoleDress:RefreshPriority(creature, oldPriority, newPriority)
  if creature:IsDressEnable() then
    if self.dressedCount < self:GetLimitCount() then
      return
    end
    if oldPriority < newPriority then
      if 0 < TableUtility.ArrayRemove(self.dressedCreatures[oldPriority], creature) then
        TableUtility.ArrayPushBack(self.dressedCreatures[newPriority], creature)
      end
      return
    end
    if 0 < TableUtility.ArrayRemove(self.dressedCreatures[oldPriority], creature) then
      self.dressedCount = self.dressedCount - 1
      TableUtility.ArrayPushBack(self.waitingDressedCreatures, creature)
    end
  else
    if newPriority < oldPriority then
      if 0 < TableUtility.ArrayRemove(self.undressedCreatures[oldPriority], creature) then
        TableUtility.ArrayPushBack(self.undressedCreatures[newPriority], creature)
      end
      return
    end
    if 0 < TableUtility.ArrayRemove(self.undressedCreatures[oldPriority], creature) then
      self.undressedCount = self.undressedCount - 1
      TableUtility.ArrayPushBack(self.waitingUndressedCreatures, creature)
    end
  end
end
function LogicManager_RoleDress:SetLimitCount(count)
  if self.limitCount == count then
    return
  end
  self.limitCount = count
end
function LogicManager_RoleDress:GetLimitCount(count)
  if self.dressDisable then
    return 0
  end
  return self.limitCount
end
function LogicManager_RoleDress:SetDressDisable(disable)
  self.dressDisable = disable
end
function LogicManager_RoleDress:Update(time, deltaTime)
  if self.dressedCount < self:GetLimitCount() and 0 >= #self.waitingDressedCreatures and 0 >= #self.waitingUndressedCreatures and 0 >= self.undressedCount then
    return
  end
  local highPriorityCreature
  local highPriority = 0
  local highPriorityCreatureArray
  local highPriorityIndex = 0
  local lowPriorityCreature
  local lowPriority = 9999999
  local lowPriorityIndex = 0
  local creatures = self.waitingDressedCreatures
  highPriorityCreature, highPriority, highPriorityIndex, lowPriorityCreature, lowPriority, lowPriorityIndex = FindHighAndLowPriorityCreature(self.waitingDressedCreatures, highPriorityCreature, highPriority, lowPriorityCreature, lowPriority)
  if highPriorityIndex > 0 then
    highPriorityCreatureArray = self.waitingDressedCreatures
  end
  local newHighPriorityCreature, newHighPriority, newHighPriorityIndex = FindHighPriorityCreature(self.waitingUndressedCreatures, highPriorityCreature, highPriority)
  if newHighPriorityIndex > 0 then
    highPriorityCreatureArray = self.waitingUndressedCreatures
    highPriorityCreature = newHighPriorityCreature
    highPriority = newHighPriority
    highPriorityIndex = newHighPriorityIndex
  end
  if nil ~= highPriorityCreature and self:_TryDress(highPriorityCreature, highPriority) then
    table.remove(highPriorityCreatureArray, highPriorityIndex)
    if highPriorityCreature == lowPriorityCreature then
      lowPriorityCreature = nil
    end
  else
    self:_TryDressOne()
  end
  if nil ~= lowPriorityCreature and self:_TryUndress(lowPriorityCreature, lowPriority) then
    table.remove(self.waitingDressedCreatures, lowPriorityIndex)
  else
    self:_TryUndressOne()
  end
end
function LogicManager_RoleDress:_TryDress(creature, priority)
  if self.dressedCount < self:GetLimitCount() then
    TableUtility.ArrayPushBack(self.dressedCreatures[priority], creature)
    self.dressedCount = self.dressedCount + 1
    creature:SetDressEnable(true)
    return true
  end
  for i = 1, priority - 1 do
    local dressedCreatures = self.dressedCreatures[i]
    if #dressedCreatures > 0 then
      local replacedCreature = TableUtility.ArrayPopBack(dressedCreatures)
      TableUtility.ArrayPushBack(self.undressedCreatures[i], replacedCreature)
      self.undressedCount = self.undressedCount + 1
      replacedCreature:SetDressEnable(false)
      TableUtility.ArrayPushBack(self.dressedCreatures[priority], creature)
      creature:SetDressEnable(true)
      return true
    end
  end
  return false
end
function LogicManager_RoleDress:_TryUndress(creature, priority)
  if self.dressedCount < self:GetLimitCount() then
    return false
  end
  TableUtility.ArrayPushBack(self.undressedCreatures[priority], creature)
  self.undressedCount = self.undressedCount + 1
  creature:SetDressEnable(false)
  return true
end
function LogicManager_RoleDress:_TryDressOne()
  if self.dressedCount >= self:GetLimitCount() then
    return false
  end
  for i = LogicManager_RoleDress.Priority._Count, 1, -1 do
    local undressedCreatures = self.undressedCreatures[i]
    if #undressedCreatures > 0 then
      local creature = TableUtility.ArrayPopBack(undressedCreatures)
      self.undressedCount = self.undressedCount - 1
      TableUtility.ArrayPushBack(self.dressedCreatures[i], creature)
      self.dressedCount = self.dressedCount + 1
      creature:SetDressEnable(true)
      return true
    end
  end
  return false
end
function LogicManager_RoleDress:_TryUndressOne()
  if self.dressedCount <= self:GetLimitCount() then
    return false
  end
  for i = 1, LogicManager_RoleDress.Priority._Count do
    local dressedCreatures = self.dressedCreatures[i]
    if #dressedCreatures > 0 then
      local creature = TableUtility.ArrayPopBack(dressedCreatures)
      self.dressedCount = self.dressedCount - 1
      TableUtility.ArrayPushBack(self.undressedCreatures[i], creature)
      self.undressedCount = self.undressedCount + 1
      creature:SetDressEnable(false)
      return true
    end
  end
  return false
end
