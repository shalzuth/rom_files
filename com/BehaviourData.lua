BehaviourData = class("BehaviourData")
function BehaviourData:ctor(creature)
  self.creature = creature
  self:Set(1)
end
function BehaviourData:Set(num)
  self.behaviour = num
end
function BehaviourData:Get(flag)
  return BitUtil.bandOneZero(self.behaviour, flag)
end
function BehaviourData:GetNonMoveable()
  return 0 < self:Get(0) and 0 or 1
end
function BehaviourData:GetSkillNonSelectable()
  return self:Get(10)
end
function BehaviourData:GetDamageAlways1()
  return self:Get(7)
end
function BehaviourData:IsFly()
  return self:Get(13) > 0
end
function BehaviourData:IsGhost()
  return self:Get(11) > 0 or 0 < self:Get(19)
end
