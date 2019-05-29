AI_CMD_SetScale = {}
function AI_CMD_SetScale:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
end
function AI_CMD_SetScale:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  return 4
end
function AI_CMD_SetScale:Deconstruct()
end
function AI_CMD_SetScale:Start(time, deltaTime, creature)
  if self.args[4] then
    creature.logicTransform:SetScaleXYZ(self.args[1], self.args[2], self.args[3])
  else
    creature.logicTransform:ScaleToXYZ(self.args[1], self.args[2], self.args[3])
  end
  return false
end
function AI_CMD_SetScale:End(time, deltaTime, creature)
end
function AI_CMD_SetScale:Update(time, deltaTime, creature)
end
function AI_CMD_SetScale.ToString()
  return "AI_CMD_SetScale", AI_CMD_SetScale
end
