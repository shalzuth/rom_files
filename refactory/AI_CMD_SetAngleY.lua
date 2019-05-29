AI_CMD_SetAngleY = {}
AI_CMD_SetAngleY.Mode = {
  SetAngleY = 1,
  LookAtCreature = 2,
  LookAtPosition = 3
}
function AI_CMD_SetAngleY:ResetArgs(args)
  self.args[1] = args[2]
  if AI_CMD_SetAngleY.Mode.LookAtPosition == self.args[1] then
    self.args[2] = VectorUtility.Asign_3(self.args[2], args[3])
  else
    self.args[3] = args[3]
  end
  self.args[4] = args[4]
end
function AI_CMD_SetAngleY:Construct(args)
  self.args[1] = args[2]
  if AI_CMD_SetAngleY.Mode.LookAtPosition == self.args[1] then
    self.args[2] = args[3]:Clone()
  else
    self.args[2] = nil
    self.args[3] = args[3]
  end
  self.args[4] = args[4]
  return 4
end
function AI_CMD_SetAngleY:Deconstruct()
  if nil ~= self.args[2] then
    self.args[2]:Destroy()
    self.args[2] = nil
  end
end
function AI_CMD_SetAngleY:Start(time, deltaTime, creature)
  local args = self.args
  if args[4] then
    if AI_CMD_SetAngleY.Mode.SetAngleY == args[1] then
      creature.logicTransform:SetAngleY(args[3])
    elseif AI_CMD_SetAngleY.Mode.LookAtCreature == args[1] then
      local targetCreature = SceneCreatureProxy.FindCreature(args[3])
      if nil ~= targetCreature then
        creature.logicTransform:LookAt(targetCreature:GetPosition())
      end
    elseif AI_CMD_SetAngleY.Mode.LookAtPosition == args[1] then
      creature.logicTransform:LookAt(args[2])
    end
  elseif AI_CMD_SetAngleY.Mode.SetAngleY == args[1] then
    creature.logicTransform:SetTargetAngleY(args[3])
  elseif AI_CMD_SetAngleY.Mode.LookAtCreature == args[1] then
    local targetCreature = SceneCreatureProxy.FindCreature(args[3])
    if nil ~= targetCreature then
      creature.logicTransform:RotateTo(targetCreature:GetPosition())
    end
  elseif AI_CMD_SetAngleY.Mode.LookAtPosition == args[1] then
    creature.logicTransform:RotateTo(args[2])
  end
  return false
end
function AI_CMD_SetAngleY:End(time, deltaTime, creature)
end
function AI_CMD_SetAngleY:Update(time, deltaTime, creature)
end
function AI_CMD_SetAngleY.ToString()
  return "AI_CMD_SetAngleY", AI_CMD_SetAngleY
end
