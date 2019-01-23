AttrEffect = class("AttrEffect")

-- AttrEffect=1	魔法伤害免疫  1 << 0
-- AttrEffect=2	物理伤害免疫  1 << 1
-- AttrEffect=3	血量无法恢复  1 << 2
-- AttrEffect=4	魔法无法恢复  1 << 3
-- AttrEffect=5	吟唱不会中断  1 << 4
-- AttrEffect=6	无视种族伤害  1 << 5
-- AttrEffect=7	无视体型伤害  1 << 6
-- AttrEffect=8	无视属性伤害  1 << 7
-- AttrEffect=9	无视近战普攻伤害 1 << 8
-- AttrEffect=10 必定命中且暴击 1 << 9
-- AttrEffect=17 隐匿状态    1 << 16
-- AttrEffect=20 无敌状态    1 << 19
-- AttrEffect=27 致盲状态    1 << 26

function AttrEffect:ctor()
	self:Set(0)
end

function AttrEffect:Set(num)
 	self.behaviour = num
end

function AttrEffect:Get(flag)
	return BitUtil.bandOneZero(self.behaviour,flag)
end 

--魔法伤害免疫
function AttrEffect:MagicDamageInvincible()
	return self:Get(0) >0
end

--物理伤害免疫
function AttrEffect:PhysicDamageInvincible()
	return self:Get(1) >0
end

--血量无法恢复
function AttrEffect:HpDisableRecover()
	return self:Get(2) >0
end

--魔法无法恢复
function AttrEffect:MpDisableRecover()
	return self:Get(3) >0
end

--吟唱不会中断
function AttrEffect:SingDisableInterrupt()
	return self:Get(4) >0
end

--无视种族伤害
function AttrEffect:IgnoreRaceDamage()
	return self:Get(5) >0
end

--无视体型伤害
function AttrEffect:IgnoreShapeDamage()
	return self:Get(6) >0
end

--无视属性伤害
function AttrEffect:IgnoreAttrDamage()
	return self:Get(7) >0
end

--无视近战普攻伤害
function AttrEffect:IgnoreJinzhanDamage()
	return self:Get(8) >0
end

--必定命中且暴击
function AttrEffect:DefiniteHitAndCritical()
	return self:Get(9) >0
end

--无敌状态
function AttrEffect:InvincibleState()
	return self:Get(19) >0
end

--致盲状态
function AttrEffect:BlindnessState()
	return self:Get(26) >0
end


AttrEffectB = class("AttrEffectB")

-- AttrEffectB=2	下个区域型技能范围扩大至x  1 << 1
-- AttrEffectB=8	下一次读条类技能顺发  1 << 7
-- AttrEffectB=16	无法被敌方作为技能目标  1 << 14

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