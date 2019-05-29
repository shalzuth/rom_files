AI_CMD_Skill = {}
function AI_CMD_Skill:ResetArgs(args)
  args[2]:CopyTo(self.args[1])
end
function AI_CMD_Skill:Construct(args)
  self.args[1] = args[2]:Clone()
  return 1
end
function AI_CMD_Skill:Deconstruct()
  self.args[1]:Destroy()
  self.args[1] = nil
end
function AI_CMD_Skill:Start(time, deltaTime, creature)
  local skill = creature.skill
  local ret, allowInterrupt = skill:SetPhase(self.args[1], creature)
  if ret then
    if allowInterrupt then
      self:SetInterruptLevel(2)
    else
      self:SetInterruptLevel(1)
    end
  end
  return ret
end
function AI_CMD_Skill:End(time, deltaTime, creature)
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
function AI_CMD_Skill:Update(time, deltaTime, creature)
  local skill = creature.skill
  skill:Update(time, deltaTime, creature)
  if not skill.running then
    self:End(time, deltaTime, creature)
  end
end
function AI_CMD_Skill.ToString()
  return "AI_CMD_Skill", AI_CMD_Skill
end
