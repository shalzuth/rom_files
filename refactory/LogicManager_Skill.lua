autoImport ("SkillHitWorker")
autoImport ("SkillComboHitWorker")
autoImport ("SkillComboEmitWorker")
autoImport ("SubSkillProjectile")
autoImport ("SkillLogic_Base")
autoImport ("SkillLogic_TargetNone")
autoImport ("SkillLogic_TargetCreature")
autoImport ("SkillLogic_TargetPoint")
autoImport ("SkillInfo")

autoImport ("SkillPhaseData")
autoImport ("SkillBase")
autoImport ("ServerSkill")
autoImport ("ClientSkill")

LogicManager_Skill = class("LogicManager_Skill")

function LogicManager_Skill:ctor()
	-- 1. register logic class
	self.logicClassMap = {}

	-- no target
	self.logicClassMap["SkillNone"] = autoImport ("SkillLogic_None")
	self.logicClassMap["SkillSelfRange"] = autoImport ("SkillLogic_SelfRange")
	self.logicClassMap["SkillForwardRect"] = autoImport ("SkillLogic_ForwardRect")

	-- target point
	self.logicClassMap["SkillPointRange"] = autoImport ("SkillLogic_PointRange")
	self.logicClassMap["SkillPointRect"] = autoImport ("SkillLogic_PointRect")
	self.logicClassMap["SkillRandomRange"] = autoImport ("SkillLogic_RandomRange")

	-- target creature
	self.logicClassMap["SkillLockedTarget"] = autoImport ("SkillLogic_Single")

	-- 2.
	self.skillInfoMap = {}

	local mapEffectLow = {}
	local count = 0
	local mapLowEffect = function (t)
		if(t~=nil and #t>1) then
			mapEffectLow[t[1]] = t[2]
			count = count + 1
		end
	end
	local empty = {}
	local handleEffectPath = SkillInfo.InitEffectPath
	for k,v in pairs(Table_Skill) do
		handleEffectPath(v.E_Cast)
		handleEffectPath(v.E_Attack)
		handleEffectPath(v.E_Fire)
		handleEffectPath(v.E_Hit)
		handleEffectPath(v.E_Miss)
		handleEffectPath(v.E_CastLock)

		local logicParam = v.Logic_Param or empty

		mapLowEffect(handleEffectPath(logicParam.effect))
		handleEffectPath(logicParam.reading_effect)
		handleEffectPath(logicParam.main_hit_effect)
		handleEffectPath(logicParam.treatment_hit_effect)
		mapLowEffect(handleEffectPath(logicParam.trap_effect))
		if nil ~= logicParam.pre_attack then
			if nil ~= logicParam.pre_attack.effect then
				handleEffectPath(logicParam.pre_attack.effect)
			end
		end
	end
	SkillInfo.MapEffectLow = mapEffectLow
end

function LogicManager_Skill:GetLogic(name)
	return self.logicClassMap[name]
end

function LogicManager_Skill:GetSkillInfo(skillID)
	if(skillID==0) then
		return nil
	end
	local skill = self.skillInfoMap[skillID]
	if(skill==nil) then
		local data = Table_Skill[skillID]
		if(data ~= nil) then
			skill = SkillInfo.new(data, self:GetLogic(data.Logic))
			self.skillInfoMap[skillID] = skill
		end
	end
	return skill
end

function LogicManager_Skill:Update(time, deltaTime)
	
end