BehaviourData = class("BehaviourData")
--Alert!!!!!! 以后需做成累加、累减，最后赋值给c#端

-- [System.Flags]
-- 		public enum Behaviour
-- 		{
-- 	 BEHAVIOUR_NONE = 0,
--   BEHAVIOUR_MOVE_ABLE = 1 << 0,
--   BEHAVIOUR_ATTACK_BACK = 1 << 1,
--   BEHAVIOUR_OUT_RANGE_BACK = 1 << 2,
--   BEHAVIOUR_PICKUP = 1 << 3,
--   BEHAVIOUR_TEAM_ATTACK = 1 << 4,
--   BEHAVIOUR_SWITCH_ATTACK = 1 << 5,
--   BEHAVIOUR_SWITCH_BE_ATTACK = 1 << 6,
--   BEHAVIOUR_BE_ATTACK_1_MAX = 1 << 7,
--   BEHAVIOUR_BE_CHANT_ATTACK = 1 << 8,
--   BEHAVIOUR_GEAR = 1 << 9,
--   BEHAVIOUR_NOT_SKILL_SELECT = 1 << 10,
--   BEHAVIOUR_GHOST = 1 << 11,
--   BEHAVIOUR_DEMON = 1 << 12,
--   BEHAVIOUR_FLY = 1 << 13,
--   BEHAVIOUR_STEAL_CAMERA = 1 << 14,
--   BEHAVIOUR_NAUGHTY = 1 << 15,
--   BEHAVIOUR_ALERT = 1 << 16,
--   BEHAVIOUR_EXPEL = 1 << 17,
--   BEHAVIOUR_RECKLESS = 1 << 18,
--   BEHAVIOUR_GHOST_2 = 1 << 19,
--   BEHAVIOUR_JEALOUS = 1 << 20,
--   BEHAVIOUR_MAX = 1 << 31,

-- 		}

function BehaviourData:ctor(creature)
	self.creature = creature
	--默认是BEHAVIOUR_MOVE_ABLE 是可以的
	self:Set(1)
end

function BehaviourData:Set(num)
 	self.behaviour = num
end

function BehaviourData:Get(flag)
	return BitUtil.bandOneZero(self.behaviour,flag)
 end 

function BehaviourData:GetNonMoveable()
	return self:Get(0)>0 and 0 or 1
end

function BehaviourData:GetSkillNonSelectable()
	return self:Get(10)
end

function BehaviourData:GetDamageAlways1()
	return self:Get(7)
end

function BehaviourData:IsFly()
	return self:Get(13)>0
end

function BehaviourData:IsGhost()
	return self:Get(11)>0 or self:Get(19)>0
end