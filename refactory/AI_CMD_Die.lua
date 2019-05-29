AI_CMD_Die = {}
function AI_CMD_Die:ResetArgs(args)
  self.args[1] = args[2]
end
function AI_CMD_Die:Construct(args)
  self.args[1] = args[2]
  return 1
end
function AI_CMD_Die:Deconstruct()
end
function AI_CMD_Die:Start(time, deltaTime, creature)
  local params = Asset_Role.GetPlayActionParams(Asset_Role.ActionName.Die)
  if self.args[1] then
    params[4] = 1
  end
  creature:Logic_PlayAction(params)
  creature:Logic_DeathBegin()
  return true
end
function AI_CMD_Die:End(time, deltaTime, creature)
end
function AI_CMD_Die:Update(time, deltaTime, creature)
end
function AI_CMD_Die.ToString()
  return "AI_CMD_Die", AI_CMD_Die
end
