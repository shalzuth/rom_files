AI_CMD_MoveToHelper = {}
function AI_CMD_MoveToHelper:Start(time, deltaTime, creature, p, ignoreNavMesh, range)
  if creature.data:NoAct() then
    return false
  end
  if nil ~= range and range >= VectorUtility.DistanceXZ(creature:GetPosition(), p) then
    return false
  end
  if ignoreNavMesh then
    creature:Logic_MoveTo(p)
  elseif not creature:Logic_NavMeshMoveTo(p) then
    creature:Logic_NavMeshPlaceTo(creature:GetPosition())
    if not creature:Logic_NavMeshMoveTo(p) then
      return false
    end
  end
  creature:Logic_PlayAction_Move()
  return true
end
function AI_CMD_MoveToHelper:End(time, deltaTime, creature)
  creature:Logic_StopMove()
end
function AI_CMD_MoveToHelper:Update(time, deltaTime, creature, ignoreNavMesh, range)
  if nil ~= creature.logicTransform.targetPosition then
    if nil ~= range and range >= VectorUtility.DistanceXZ(creature:GetPosition(), creature.logicTransform.targetPosition) then
      self:End(time, deltaTime, creature)
      return true
    end
    if not ignoreNavMesh then
      creature:Logic_SamplePosition(time)
    end
  else
    self:End(time, deltaTime, creature)
    return true
  end
  return false
end
local Helper = AI_CMD_MoveToHelper
AI_CMD_MoveTo = {}
function AI_CMD_MoveTo:ResetArgs(args)
  local p = args[2]
  self.args[1]:Set(p[1], p[2], p[3])
  self.args[2] = args[3]
end
function AI_CMD_MoveTo:Construct(args)
  self.args[1] = args[2]:Clone()
  self.args[2] = args[3]
  return 2
end
function AI_CMD_MoveTo:Deconstruct()
  self.args[1]:Destroy()
  self.args[1] = nil
end
function AI_CMD_MoveTo:Start(time, deltaTime, creature)
  return Helper.Start(self, time, deltaTime, creature, self.args[1], self.args[2])
end
function AI_CMD_MoveTo:End(time, deltaTime, creature)
  Helper.End(self, time, deltaTime, creature)
end
function AI_CMD_MoveTo:Update(time, deltaTime, creature)
  Helper.Update(self, time, deltaTime, creature, self.args[2])
end
function AI_CMD_MoveTo.ToString()
  return "AI_CMD_MoveTo", AI_CMD_MoveTo
end
