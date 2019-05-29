AI_CMD_Revive = {}
function AI_CMD_Revive:ResetArgs(args)
end
function AI_CMD_Revive:Construct(args)
  return 0
end
function AI_CMD_Revive:Deconstruct()
end
function AI_CMD_Revive:Start(time, deltaTime, creature)
  return false
end
function AI_CMD_Revive:End(time, deltaTime, creature)
end
function AI_CMD_Revive:Update(time, deltaTime, creature)
end
function AI_CMD_Revive.ToString()
  return "AI_CMD_Revive", AI_CMD_Revive
end
