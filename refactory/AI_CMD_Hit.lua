AI_CMD_Hit = {}
local StiffTime = 0.1
local Duration = 1.5
local waitForActionCmdArray = {}
local CmdFindPredicate = function(cmd, cmdInstanceID)
  return cmd.instanceID == cmdInstanceID
end
local OnActionFinished = function(creatureGUID, cmdInstanceID)
  local cmd, i = TableUtility.ArrayFindByPredicate(waitForActionCmdArray, CmdFindPredicate, cmdInstanceID)
  if nil ~= cmd then
    cmd.args[5] = false
  end
end
function AI_CMD_Hit:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
end
function AI_CMD_Hit:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  return 3
end
function AI_CMD_Hit:Deconstruct()
end
function AI_CMD_Hit:Start(time, deltaTime, creature)
  if self.args[1] then
    creature.assetRole:ChangeColorFromTo(LuaGeometry.Const_Col_white, LuaGeometry.Const_Col_whiteClear, 0.5)
  end
  if nil ~= self.args[3] then
    self.args[4] = time + self.args[3]
  else
    if creature.data:NoStiff() then
      return false
    end
    self.args[4] = time + StiffTime
  end
  local hitActionName
  if nil ~= self.args[2] then
    hitActionName = self.args[2]
  else
    hitActionName = Asset_Role.ActionName.Hit
  end
  local assetRole = creature.assetRole
  if assetRole:HasActionRaw(hitActionName) or assetRole:HasActionIgnoreMount(hitActionName) or assetRole:HasAction(hitActionName) then
    local params = Asset_Role.GetPlayActionParams(hitActionName)
    params[6] = true
    params[7] = OnActionFinished
    params[8] = self.instanceID
    self.args[5] = creature:Logic_PlayAction(params)
    if self.args[5] then
      TableUtility.ArrayPushBack(waitForActionCmdArray, self)
    end
    Asset_Role.ClearPlayActionParams(params)
  else
    self.args[5] = false
  end
  self.args[6] = time + Duration
  return true
end
function AI_CMD_Hit:End(time, deltaTime, creature)
  TableUtility.ArrayRemove(waitForActionCmdArray, self)
  creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
end
function AI_CMD_Hit:Update(time, deltaTime, creature)
  if time > self.args[4] then
    self:SetInterruptLevel(2)
    if not self.args[5] then
      self:End(time, deltaTime, creature)
    elseif time > self.args[6] then
      self:End(time, deltaTime, creature)
    end
  end
end
function AI_CMD_Hit.ToString()
  return "AI_CMD_Hit", AI_CMD_Hit
end
