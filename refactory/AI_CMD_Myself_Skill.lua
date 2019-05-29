local lastAttackTime = 0
local lastSkillTime = 0
local SkillInterval = 1
AI_CMD_Myself_Skill_Run = {}
function AI_CMD_Myself_Skill_Run:Start(time, deltaTime, creature, targetCreature, targetPosition, noLimit, ignoreCast)
  local skillCanUse
  local skill = creature.skill
  if not noLimit and creature.data:NoAttack() and not isAttackSkil then
    skillCanUse = creature:Logic_CheckSkillCanUseByID(skill:GetSkillID())
    if not skillCanUse then
      return false
    end
  end
  local isAttackSkill = skill:IsAttackSkill(creature)
  if not noLimit and creature.data:NoSkill() and not isAttackSkill then
    if nil == skillCanUse then
      skillCanUse = creature:Logic_CheckSkillCanUseByID(skill:GetSkillID())
    end
    if not skillCanUse then
      return false
    end
  end
  if not SkillProxy.Instance:SkillCanBeUsedByID(skill:GetSkillID(), true) then
    return false
  end
  if self.args[5] and nil ~= targetCreature then
    creature.logicTransform:LookAt(targetCreature:GetPosition())
  end
  local ret, allowInterrupt = skill:Launch(targetCreature, targetPosition, creature, ignoreCast)
  if ret then
    if isAttackSkill then
      lastAttackTime = time
    elseif not noLimit then
      lastSkillTime = time
    end
    if allowInterrupt then
      self:SetInterruptLevel(2)
    else
      self:SetInterruptLevel(1)
    end
    return true
  end
  return false
end
function AI_CMD_Myself_Skill_Run:End(time, deltaTime, creature)
  local skill = creature.skill
  skill:End(creature)
  if skill.info:NoWait(creature) then
    creature.ai:SetNoIdleAction()
  elseif not skill.info:NoAttackWait(creature) then
    local endAction = skill.info:GetEndAction(creature)
    if nil ~= endAction and "" ~= endAction then
      creature.ai:SetIdleAction(endAction)
    else
      creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
    end
  end
end
function AI_CMD_Myself_Skill_Run:Update(time, deltaTime, creature)
  local skill = creature.skill
  skill:Update(time, deltaTime, creature)
  if not skill.running then
    self:End(time, deltaTime, creature)
  end
end
AI_CMD_Myself_Skill = {}
local SkillCMD = {
  [SkillTargetType.None] = autoImport("AI_CMD_Myself_Skill_TargetNone"),
  [SkillTargetType.Creature] = autoImport("AI_CMD_Myself_Skill_TargetCreature"),
  [SkillTargetType.Point] = autoImport("AI_CMD_Myself_Skill_TargetPoint")
}
local skillCMD
function AI_CMD_Myself_Skill:Construct(args)
  self.args[1] = args[2]
  local targetCreature = args[3]
  if nil ~= targetCreature then
    self.args[2] = targetCreature.data.id
  else
    self.args[2] = 0
  end
  local p = args[4]
  if nil ~= p then
    self.args[3] = p:Clone()
  else
    self.args[3] = nil
  end
  self.args[4] = args[5]
  self.args[5] = args[6]
  self.args[6] = args[7]
  self.args[7] = args[8]
  self.args[8] = nil
  self.args[9] = args[9]
  return 9
end
function AI_CMD_Myself_Skill:Deconstruct()
  if nil ~= self.args[3] then
    self.args[3]:Destroy()
    self.args[3] = nil
  end
end
function AI_CMD_Myself_Skill:FromServer()
  return self.args[7] or false
end
function AI_CMD_Myself_Skill:Start(time, deltaTime, creature)
  local args = self.args
  local isAttackSkill = creature.data:GetAttackSkillIDAndLevel() == args[1]
  if isAttackSkill then
    local attackSpeed = creature.data:GetAttackSpeed_Adjusted() or 1
    local attackInterval = 1.0 / attackSpeed
    local interval = time - lastAttackTime
    if attackInterval > interval then
      helplog("Attack Too Fast", args[1], interval)
      return false
    end
  end
  local interval = time - lastSkillTime
  if interval < SkillInterval then
    helplog("Skill Too Fast", args[1], interval)
    return false
  end
  local limitSkill = creature.data:GetLimitSkill(args[1])
  if nil ~= limitSkill and not limitSkill:IsIgnoreTarget() then
    args[2] = limitSkill:GetFromID()
    args[6] = false
    args[8] = true
  end
  if args[9] then
    args[8] = true
  end
  local skill = creature.skill
  skill:SetSkillID(args[1])
  local targetType
  if args[5] then
    targetType = SkillTargetType.Creature
  else
    targetType = skill.info:GetTargetType(creature)
  end
  skillCMD = SkillCMD[targetType]
  if skillCMD.Start(self, time, deltaTime, creature) then
    local targetCreature
    if 0 ~= args[2] then
      creature:Logic_SetSkillState(args[2])
      targetCreature = SceneCreatureProxy.FindCreature(args[2])
    end
    if isAttackSkill then
      creature:Logic_SetAttackTarget(targetCreature)
    else
      local attackTarget = creature:Logic_GetAttackTarget()
      if SkillTargetType.None ~= targetType and attackTarget ~= targetCreature then
        creature:Logic_SetAttackTarget(nil)
      end
    end
    return true
  end
  return false
end
function AI_CMD_Myself_Skill:End(time, deltaTime, creature)
  skillCMD.End(self, time, deltaTime, creature)
end
function AI_CMD_Myself_Skill:Update(time, deltaTime, creature)
  skillCMD.Update(self, time, deltaTime, creature)
end
function AI_CMD_Myself_Skill.ToString()
  return "AI_CMD_Myself_Skill", AI_CMD_Myself_Skill
end
