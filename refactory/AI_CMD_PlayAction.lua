AI_CMD_PlayAction = {}
local addSpEffectData = {
  id = 4,
  guid = 1,
  entity = nil
}
local removeSpEffectData = {
  id = 4,
  guid = 1,
  entity = nil
}
local waitForActionCmdArray = {}
local CmdFindPredicate = function(cmd, cmdInstanceID)
  return cmd.instanceID == cmdInstanceID
end
local OnActionFinished = function(creatureGUID, cmdInstanceID)
  local cmd, i = TableUtility.ArrayFindByPredicate(waitForActionCmdArray, CmdFindPredicate, cmdInstanceID)
  if nil ~= cmd then
    cmd.args[6] = false
  end
end
function AI_CMD_PlayAction:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
end
function AI_CMD_PlayAction:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
  return 5
end
function AI_CMD_PlayAction:Deconstruct()
end
function AI_CMD_PlayAction:Start(time, deltaTime, creature)
  self.args[7] = nil
  self.args[8] = nil
  self.args[9] = nil
  local assetRole = creature.assetRole
  local hasAction = assetRole:HasActionRaw(self.args[1])
  local params = Asset_Role.GetPlayActionParams(self.args[1])
  if nil ~= self.args[2] then
    params[4] = self.args[2]
  end
  if nil ~= self.args[3] then
    params[5] = self.args[3]
  end
  if (nil == self.args[2] or 1 > self.args[2]) and not self.args[3] then
    params[6] = true
    if hasAction then
      params[7] = OnActionFinished
      params[8] = self.instanceID
      self.args[6] = creature:Logic_PlayAction(params)
      if self.args[6] then
        TableUtility.ArrayPushBack(waitForActionCmdArray, self)
      end
    else
      creature:Logic_PlayAction(params)
    end
  else
    creature:Logic_PlayAction(params)
    if 1 == Game.Config_Action[self.args[1]].Condition then
      self.args[7] = true
    end
  end
  Asset_Role.ClearPlayActionParams(params)
  if "sit_down" == self.args[1] and creature:AllowSpEffect_OnFloor() then
    self.args[8] = self.instanceID
    addSpEffectData.guid = self.instanceID
    creature:Server_AddSpEffect(addSpEffectData)
  end
  if self.args[5] and self.args[5] > 0 then
    self.args[9] = 0
    return true
  end
  return hasAction or self.args[3] or self.args[4] or self.args[7]
end
function AI_CMD_PlayAction:End(time, deltaTime, creature)
  if not self.args[3] then
    TableUtility.ArrayRemove(waitForActionCmdArray, self)
  end
  if nil ~= self.args[8] then
    removeSpEffectData.guid = self.args[8]
    creature:Server_RemoveSpEffect(removeSpEffectData)
    self.args[8] = nil
  end
end
function AI_CMD_PlayAction:Update(time, deltaTime, creature)
  local args = self.args
  if nil ~= args[5] and args[5] > 0 then
    args[9] = args[9] + deltaTime
    if args[9] > args[5] then
      self:End(time, deltaTime, creature)
    end
  elseif (nil == args[2] or args[2] < 1) and not args[3] and not args[6] then
    self:End(time, deltaTime, creature)
  elseif args[4] and not creature:IsFakeDead() then
    self:End(time, deltaTime, creature)
  elseif args[7] and not creature:IsOnSceneSeat() then
    self:End(time, deltaTime, creature)
  end
end
function AI_CMD_PlayAction.ToString()
  return "AI_CMD_PlayAction", AI_CMD_PlayAction
end
