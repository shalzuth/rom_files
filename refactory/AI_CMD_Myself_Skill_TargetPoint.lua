local MoveToHelper = AI_CMD_Myself_MoveToHelper
local SkillCMD = {}
local SkillCMD_Track = {}
local SkillCMD_Run = {}
setmetatable(SkillCMD_Run, {
  __index = AI_CMD_Myself_Skill_Run
})
local phaseCMD, nextPhaseCMD
function SkillCMD:Start(time, deltaTime, creature)
  local args = self.args
  if nil == args[3] then
    return false
  end
  local skill = creature.skill
  local skillInfo = skill.info
  local launchRange = 0
  if not args[8] then
    launchRange = skillInfo:GetLaunchRange(creature)
  end
  if launchRange > 0 then
    local currentPosition = creature:GetPosition()
    if launchRange < VectorUtility.DistanceXZ(currentPosition, args[3]) then
      if creature:IsAutoBattleStanding() then
        creature:Client_ClearAutoBattleCurrentTarget()
        return false
      end
      if SkillCMD_Track.Start(self, time, deltaTime, creature) then
        phaseCMD = SkillCMD_Track
        return true
      else
        return false
      end
    end
  end
  if SkillCMD_Run.Start(self, time, deltaTime, creature) then
    phaseCMD = SkillCMD_Run
    return true
  else
    return false
  end
end
function SkillCMD:End(time, deltaTime, creature)
  phaseCMD.End(self, time, deltaTime, creature)
  if nil ~= nextPhaseCMD then
    phaseCMD = nextPhaseCMD
    nextPhaseCMD = nil
    self:SetKeepAlive(true)
  end
end
function SkillCMD:Update(time, deltaTime, creature)
  phaseCMD.Update(self, time, deltaTime, creature)
end
function SkillCMD_Track:Start(time, deltaTime, creature)
  if MoveToHelper.Start(self, time, deltaTime, creature, self.args[3], self.args[4]) then
    self:SetInterruptLevel(2)
    return true
  end
  return false
end
function SkillCMD_Track:End(time, deltaTime, creature)
  MoveToHelper.End(self, time, deltaTime, creature)
end
function SkillCMD_Track:Update(time, deltaTime, creature)
  local currentPosition = creature:GetPosition()
  local skill = creature.skill
  local skillInfo = skill.info
  local launchRange = skillInfo:GetLaunchRange(creature)
  if launchRange > VectorUtility.DistanceXZ(currentPosition, self.args[3]) then
    nextPhaseCMD = SkillCMD_Run
    self:End(time, deltaTime, creature)
    return
  elseif creature:IsAutoBattleStanding() then
    creature:Client_ClearAutoBattleCurrentTarget()
    self:End(time, deltaTime, creature)
    return
  end
  MoveToHelper.Update(self, time, deltaTime, creature)
end
function SkillCMD_Run:Start(time, deltaTime, creature)
  return AI_CMD_Myself_Skill_Run.Start(self, time, deltaTime, creature, nil, self.args[3], self.args[7], self.args[9])
end
return SkillCMD
