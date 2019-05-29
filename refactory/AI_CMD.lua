autoImport("AI_CMD_PlaceTo")
autoImport("AI_CMD_MoveTo")
autoImport("AI_CMD_SetAngleY")
autoImport("AI_CMD_SetScale")
autoImport("AI_CMD_Skill")
autoImport("AI_CMD_PlayAction")
autoImport("AI_CMD_Hit")
autoImport("AI_CMD_Die")
autoImport("AI_CMD_Revive")
autoImport("AI_CMD_GetOnSeat")
autoImport("AI_CMD_GetOffSeat")
autoImport("AI_CMD_Myself_PlaceTo")
autoImport("AI_CMD_Myself_MoveTo")
autoImport("AI_CMD_Myself_DirMove")
autoImport("AI_CMD_Myself_DirMoveEnd")
autoImport("AI_CMD_Myself_Access")
autoImport("AI_CMD_Myself_SetAngleY")
autoImport("AI_CMD_Myself_SetScale")
autoImport("AI_CMD_Myself_Skill")
autoImport("AI_CMD_Myself_PlayAction")
autoImport("AI_CMD_Myself_Hit")
autoImport("AI_CMD_Myself_Die")
AI_CMD = class("AI_CMD", ReusableObject)
AI_CMD.PoolSize = 300
function AI_CMD.Create(args)
  return ReusableObject.Create(AI_CMD, true, args)
end
function AI_CMD:ctor()
  AI_CMD.super.ctor(self)
  self.AIClass = nil
  self.args = {}
  self.running = false
  self.keepAlive = false
  self.interruptLevel = 1
end
function AI_CMD:ResetArgs(args)
  self.AIClass.ResetArgs(self, args)
end
function AI_CMD:TryRestart(args, creature)
  if nil == self.AIClass.TryRestart then
    return false
  end
  return self.AIClass.TryRestart(self, args, creature)
end
function AI_CMD:Start(time, deltaTime, creature)
  if self.running then
    return
  end
  self:SetKeepAlive(false)
  self.running = self.AIClass.Start(self, time, deltaTime, creature)
  if self.running then
    creature.ai:HideCommands(self.AIClass, time, deltaTime, creature)
    return true
  end
  return false
end
function AI_CMD:End(time, deltaTime, creature)
  if not self.running then
    return
  end
  self.AIClass.End(self, time, deltaTime, creature)
  self.running = false
  creature.ai:UnhideCommands(self.AIClass, time, deltaTime, creature)
end
function AI_CMD:Update(time, deltaTime, creature)
  if not self.running then
    return
  end
  self.AIClass.Update(self, time, deltaTime, creature)
end
function AI_CMD:SetKeepAlive(v)
  self.keepAlive = v
end
function AI_CMD:SetInterruptLevel(level)
  self.interruptLevel = level
end
function AI_CMD:DoConstruct(asArray, args)
  self.AIClass = args[1]
  local argsCount = self.AIClass.Construct(self, args)
  if argsCount < #self.args then
    for i = #self.args, argsCount + 1, -1 do
      self.args[i] = nil
    end
  end
  self.running = false
  self.keepAlive = false
  self.interruptLevel = 1
end
function AI_CMD:DoDeconstruct(asArray)
  self.AIClass.Deconstruct(self)
  self.AIClass = nil
end
