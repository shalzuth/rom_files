AttrEffect = class("AttrEffect")
function AttrEffect:ctor()
  self:Set(0)
end
function AttrEffect:Set(num)
  self.behaviour = num
end
function AttrEffect:Get(flag)
  return BitUtil.bandOneZero(self.behaviour, flag)
end
function AttrEffect:MagicDamageInvincible()
  return 0 < self:Get(0)
end
function AttrEffect:PhysicDamageInvincible()
  return self:Get(1) > 0
end
function AttrEffect:HpDisableRecover()
  return self:Get(2) > 0
end
function AttrEffect:MpDisableRecover()
  return self:Get(3) > 0
end
function AttrEffect:SingDisableInterrupt()
  return self:Get(4) > 0
end
function AttrEffect:IgnoreRaceDamage()
  return self:Get(5) > 0
end
function AttrEffect:IgnoreShapeDamage()
  return self:Get(6) > 0
end
function AttrEffect:IgnoreAttrDamage()
  return self:Get(7) > 0
end
function AttrEffect:IgnoreJinzhanDamage()
  return self:Get(8) > 0
end
function AttrEffect:DefiniteHitAndCritical()
  return self:Get(9) > 0
end
function AttrEffect:InvincibleState()
  return self:Get(19) > 0
end
function AttrEffect:BlindnessState()
  return self:Get(26) > 0
end
AttrEffectB = class("AttrEffectB")
function AttrEffectB:ctor()
  self:Reset()
end
function AttrEffectB:Reset()
  self.value = 0
end
function AttrEffectB:Set(value)
  self.value = value
end
function AttrEffectB:NextPointTargetSkillLargeLaunchRange()
  return self.value & 2 > 0
end
function AttrEffectB:NextSkillNoReady()
  return self.value & 128 > 0
end
function AttrEffectB:CanNotBeSkillTargetByEnemy()
  return self.value & 32768 > 0
end
function AttrEffectB:IsInMagicMachine()
  return BitUtil.bandOneZero(self.value, 19) > 0
end
function AttrEffectB:IsOnWolf()
  return BitUtil.bandOneZero(self.value, 18) > 0
end
