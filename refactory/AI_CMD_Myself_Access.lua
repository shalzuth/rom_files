AI_CMD_Myself_AccessHelper = {}
setmetatable(AI_CMD_Myself_AccessHelper, {
  __index = AI_CMD_Myself_MoveToHelper
})
local TargetValidDistance = 1
function AI_CMD_Myself_AccessHelper:_TryAccess(time, deltaTime, creature, targetCreature, range)
  if targetCreature.data:NoAccessable() then
    return true, false
  end
  local currentPosition = creature:GetPosition()
  local targetPosition = targetCreature:GetPosition()
  if range > VectorUtility.DistanceXZ(currentPosition, targetPosition) then
    return true, true
  end
  return false, false
end
function AI_CMD_Myself_AccessHelper:Start(time, deltaTime, creature, targetCreature, range, ignoreNavMesh)
  local ret, canAccess = AI_CMD_Myself_AccessHelper._TryAccess(self, time, deltaTime, creature, targetCreature, range)
  if ret then
    return false, canAccess
  end
  return AI_CMD_Myself_MoveToHelper.Start(self, time, deltaTime, creature, targetCreature:GetPosition(), ignoreNavMesh), false
end
function AI_CMD_Myself_AccessHelper:End(time, deltaTime, creature)
  AI_CMD_Myself_MoveToHelper.End(self, time, deltaTime, creature)
end
function AI_CMD_Myself_AccessHelper:Update(time, deltaTime, creature, targetCreature, range, ignoreNavMesh)
  local ret, canAccess = AI_CMD_Myself_AccessHelper._TryAccess(self, time, deltaTime, creature, targetCreature, range)
  if ret then
    return ret, canAccess
  end
  local logicTransform = creature.logicTransform
  local prevTargetPosition = logicTransform.targetPosition
  local targetPosition = targetCreature:GetPosition()
  if (nil == prevTargetPosition or VectorUtility.DistanceXZ(prevTargetPosition, targetPosition) > TargetValidDistance) and not AI_CMD_Myself_MoveToHelper.Start(self, time, deltaTime, creature, targetPosition, ignoreNavMesh) then
    logicTransform:SetTargetPosition(targetPosition)
  end
  AI_CMD_Myself_MoveToHelper.Update(self, time, deltaTime, creature, ignoreNavMesh)
  return false, false
end
local AccessHelper = AI_CMD_Myself_AccessHelper
AI_CMD_Myself_Access = {}
function AI_CMD_Myself_Access:Construct(args)
  local creature = args[2]
  local p = creature:GetPosition()
  self.args[1] = creature.data.id
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
  self.args[6] = args[7]
  return 6
end
function AI_CMD_Myself_Access:Deconstruct()
  if nil ~= self.args[4] and nil ~= self.args[5] then
    self.args[5](self.args[4])
  end
  self.args[4] = nil
  self.args[5] = nil
  self.args[6] = nil
end
function AI_CMD_Myself_Access:Start(time, deltaTime, creature)
  local targetCreature = SceneCreatureProxy.FindCreature(self.args[1])
  if nil == targetCreature then
    return false
  end
  local accessRange = self.args[3]
  if accessRange < 0 then
    accessRange = targetCreature.data:GetAccessRange()
  end
  local ret, accessed = AccessHelper.Start(self, time, deltaTime, creature, targetCreature, accessRange, self.args[2])
  if accessed then
    creature:Client_ArrivedAccessTarget(targetCreature, self.args[4], self.args[6])
  end
  return ret
end
function AI_CMD_Myself_Access:End(time, deltaTime, creature)
  AccessHelper.End(self, time, deltaTime, creature)
end
function AI_CMD_Myself_Access:Update(time, deltaTime, creature)
  local targetCreature = SceneCreatureProxy.FindCreature(self.args[1])
  if nil == targetCreature then
    self:End(time, deltaTime, creature)
    return
  end
  local accessRange = self.args[3]
  if accessRange < 0 then
    accessRange = targetCreature.data:GetAccessRange()
  end
  local ret, canAccess = AccessHelper.Update(self, time, deltaTime, creature, targetCreature, accessRange, self.args[2])
  if ret then
    local custom, customType = self.args[4], self.args[6]
    self:End(time, deltaTime, creature)
    if canAccess then
      creature:Client_ArrivedAccessTarget(targetCreature, custom, customType)
    end
  end
end
function AI_CMD_Myself_Access.ToString()
  return "AI_CMD_Myself_Access", AI_CMD_Myself_Access
end
