AI_CMD_GetOnSeat = {}
function AI_CMD_GetOnSeat:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
end
function AI_CMD_GetOnSeat:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  return 2
end
function AI_CMD_GetOnSeat:Deconstruct()
end
function AI_CMD_GetOnSeat:Start(time, deltaTime, creature)
  if nil ~= self.args[1] and 0 ~= self.args[1] then
    if self.args[2] then
      creature:Client_GetOnSeat(self.args[1])
    else
      Game.SceneSeatManager:GetOnSeat(creature, self.args[1])
    end
  end
  return false
end
function AI_CMD_GetOnSeat:End(time, deltaTime, creature)
end
function AI_CMD_GetOnSeat:Update(time, deltaTime, creature)
end
function AI_CMD_GetOnSeat.ToString()
  return "AI_CMD_GetOnSeat", AI_CMD_GetOnSeat
end
