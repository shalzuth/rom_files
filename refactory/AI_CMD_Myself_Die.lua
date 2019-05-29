AI_CMD_Myself_Die = {}
local Duration = 2
local waitForActionCmd
local OnActionFinished = function(creatureGUID, cmdInstanceID)
  if nil ~= waitForActionCmd and waitForActionCmd.instanceID == cmdInstanceID then
    waitForActionCmd.args[3] = true
    waitForActionCmd = nil
  end
end
function AI_CMD_Myself_Die:Construct(args)
  self.args[1] = args[2]
  return 1
end
function AI_CMD_Myself_Die:Deconstruct()
end
function AI_CMD_Myself_Die:Start(time, deltaTime, creature)
  FunctionSystem.InterruptMyMissionCommand()
  creature:Logic_DeathBegin()
  local dieActionName = Asset_Role.ActionName.Die
  local assetRole = creature.assetRole
  if assetRole:HasActionRaw(dieActionName) then
    local params = Asset_Role.GetPlayActionParams(dieActionName)
    if self.args[1] then
      params[4] = 1
      creature:Logic_DeathEnd()
      creature:Logic_PlayAction(params)
    else
      params[6] = true
      params[7] = OnActionFinished
      params[8] = self.instanceID
      if creature:Logic_PlayAction(params) then
        waitForActionCmd = self
        self.args[2] = time + Duration
        self.args[3] = false
      else
        creature:Logic_DeathEnd()
      end
    end
    Asset_Role.ClearPlayActionParams(params)
  else
    creature:Logic_DeathEnd()
  end
  return true
end
function AI_CMD_Myself_Die:End(time, deltaTime, creature)
  if waitForActionCmd == self then
    waitForActionCmd = nil
  end
end
function AI_CMD_Myself_Die:Update(time, deltaTime, creature)
  if not creature:IsDead() then
    self:End(time, deltaTime, creature)
  elseif self.args[3] or nil ~= self.args[2] and time > self.args[2] then
    self.args[2] = nil
    self.args[3] = false
    if waitForActionCmd == self then
      waitForActionCmd = nil
    end
    creature:Logic_DeathEnd()
  end
end
function AI_CMD_Myself_Die.ToString()
  return "AI_CMD_Myself_Die", AI_CMD_Myself_Die
end
