AI_CMD_GetOffSeat = {}
function AI_CMD_GetOffSeat:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
end
function AI_CMD_GetOffSeat:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  return 2
end
function AI_CMD_GetOffSeat:Deconstruct()
end
function AI_CMD_GetOffSeat:Start(time, deltaTime, creature)
  if self.args[2] then
    creature:Client_GetOffSeat()
    return false
  end
  if nil ~= self.args[1] and 0 ~= self.args[1] then
    Game.SceneSeatManager:TryGetOffSeat(creature, self.args[1])
  end
  return false
end
function AI_CMD_GetOffSeat:End(time, deltaTime, creature)
end
function AI_CMD_GetOffSeat:Update(time, deltaTime, creature)
end
function AI_CMD_GetOffSeat.ToString()
  return "AI_CMD_GetOffSeat", AI_CMD_GetOffSeat
end
