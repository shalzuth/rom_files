SkillInfo = class("SkillInfo")

local SpecialCamp_Team = -1 -- exclude myself

local DamageType = CommonFun.DamageType
local CampMap = {
	["Neutral"] = RoleDefines_Camp.NEUTRAL,
	["Enemy"] = RoleDefines_Camp.ENEMY,
	["Friend"] = RoleDefines_Camp.FRIEND,
	["Team"] = SpecialCamp_Team,
}
local pointTargetLargeLaunchRange = 5

local function PreprocessEffectPaths(paths)
	if nil ~= paths then
		paths[1] = "Skill/"..paths[1]
		if nil == paths[2] then
			paths[2] = paths[1]
		elseif "none" == paths[2] then
			paths[2] = nil
		else
			paths[2] = "Skill/"..paths[2]
		end
	end
	return paths
end

local function GetEffectPath(paths)
	if nil == paths then
		return nil
	end
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		return paths[2]
	end
	return paths[1]
end

local _effect_Map = {}
function SkillInfo.InitEffectPath(str)
	if(str) then
		local found = _effect_Map[str]
		if(found==nil) then
			found = PreprocessEffectPaths(StringUtil.Split(str, ","))
			_effect_Map[str] = found
		end
		return found
	end
	return nil
end

local mapMode = 1
function SkillInfo.SetMapMode(mode)
	mapMode = mode
end

function SkillInfo:ctor(staticData, LogicClass)
	self.staticData = staticData
	self.LogicClass = LogicClass

    -- todo xde 使用技能后头像上方的tips
    self.speakName = staticData.NameZh and OverSea.LangManager.Instance():GetLangByKey(staticData.NameZh).."!!" or nil
    -- self.speakName = staticData.NameZh and staticData.NameZh.."!!" or nil

	local logicParam = staticData.Logic_Param or {}
	self.logicParam = logicParam
	self.emit = logicParam.emit

	local campStrs = StringUtil.Split(staticData.Camps, '|')
	if nil ~= campStrs and 0 < #campStrs then
		local camps = {}
		for i=1, #campStrs do
			local camp = CampMap[campStrs[i]]
			TableUtility.ArrayPushBack(camps, camp)
		end
		self.camps = camps
		self.campsOnlyEnemy = 1 == #camps and RoleDefines_Camp.ENEMY == camps[1]
		self.campsOnlyTeam = 1 == #camps and SpecialCamp_Team == camps[1]
	end

	self.buffs = {{}, {}}
	if nil ~= staticData.Buff then
		local buffMap = staticData.Buff

		local selfBuffs = {}
		if nil ~= buffMap.self then
			local buffs = buffMap.self
			for i=1, #buffs do
				selfBuffs[#selfBuffs+1] = buffs[i]
			end
		end
		if nil ~= buffMap.self_skill then
			local buffs = buffMap.self_skill
			for i=1, #buffs do
				selfBuffs[#selfBuffs+1] = buffs[i]
			end
		end
		if 0 < #selfBuffs then
			self.buffs[1].selfBuffs = selfBuffs
		end

		self.buffs[1].teamBuffs = buffMap.team
	end

	if nil ~= staticData.Pvp_buff then
		local buffMap = staticData.Pvp_buff

		local selfBuffs = {}
		if nil ~= buffMap.self then
			local buffs = buffMap.self
			for i=1, #buffs do
				selfBuffs[#selfBuffs+1] = buffs[i]
			end
		end
		if nil ~= buffMap.self_skill then
			local buffs = buffMap.self_skill
			for i=1, #buffs do
				selfBuffs[#selfBuffs+1] = buffs[i]
			end
		end
		if 0 < #selfBuffs then
			self.buffs[2].selfBuffs = selfBuffs
		end

		self.buffs[2].teamBuffs = buffMap.team
	end

	self.effectsPath = {
		_effect_Map[staticData.E_Cast],
		_effect_Map[staticData.E_Attack],
		_effect_Map[staticData.E_Fire],
		_effect_Map[staticData.E_Hit],
		_effect_Map[staticData.E_Miss],
		_effect_Map[staticData.E_CastLock],
		-- PreprocessEffectPaths(StringUtil.Split(staticData.E_Cast, ",")),
		-- PreprocessEffectPaths(StringUtil.Split(staticData.E_Attack, ",")),
		-- PreprocessEffectPaths(StringUtil.Split(staticData.E_Fire, ",")),
		-- PreprocessEffectPaths(StringUtil.Split(staticData.E_Hit, ",")),
		-- PreprocessEffectPaths(StringUtil.Split(staticData.E_Miss, ","))
	}

	self.effectsPathMap = {
		effect = _effect_Map[logicParam.effect],
		reading_effect = _effect_Map[logicParam.reading_effect],
		main_hit_effect = _effect_Map[logicParam.main_hit_effect],
		treatment_hit_effect = _effect_Map[logicParam.treatment_hit_effect],
		trap_effect = _effect_Map[logicParam.trap_effect],
		-- effect = StringUtil.Split(logicParam.effect, ","),
		-- reading_effect = StringUtil.Split(logicParam.reading_effect, ","),
		-- main_hit_effect = StringUtil.Split(logicParam.main_hit_effect, ","),
		-- treatment_hit_effect = StringUtil.Split(logicParam.treatment_hit_effect, ","),
		-- trap_effect = StringUtil.Split(logicParam.trap_effect, ","),
	}
	if nil ~= logicParam.pre_attack then
		if nil ~= logicParam.pre_attack.effect then
			self.effectsPathMap.pre_attack_effect = _effect_Map[logicParam.pre_attack.effect]
			-- self.effectsPathMap.pre_attack_effect = StringUtil.Split(logicParam.pre_attack.effect, ",")
		end
	end
	-- for k,v in pairs(self.effectsPathMap) do
	-- 	PreprocessEffectPaths(v)
	-- end

	if nil ~= self.emit then
		self.emitEffectPath = StringUtil.Split(self.emit.effect, ",")
		PreprocessEffectPaths(self.emitEffectPath)

		if nil ~= self.emit.effect_logic then
			self.emitLogicEffectPath = StringUtil.Split(self.emit.effect_logic.effect, ",")
			PreprocessEffectPaths(self.emitLogicEffectPath)
		end
	end

	self.sesPath = {
		StringUtil.Split(staticData.SE_cast, "-"),
		StringUtil.Split(staticData.SE_attack, "-"),
		StringUtil.Split(staticData.SE_fire, "-"),
		StringUtil.Split(staticData.SE_hit, "-"),
		StringUtil.Split(staticData.SE_miss, "-")
	}
	-- for i=1, #self.sesPath do
	-- 	local paths = self.sesPath[i]
	-- 	if nil ~= paths then
	-- 		for j=1, #paths do
	-- 			if "None" == paths[j] then
	-- 				paths[j] = nil
	-- 			end
	-- 		end
	-- 	end
	-- end
	if(staticData.TargetFilter and staticData.TargetFilter.classID) then
		self.targetfilterClassIDMap = {}
		local classes = staticData.TargetFilter.classID
		for i=1,#classes do
			self.targetfilterClassIDMap[classes[i]] = 1
		end
	end
end

function SkillInfo:GetSkillID(creature)
	return self.staticData.id
end

function SkillInfo:GetSkillType(creature)
	return self.staticData.SkillType
end

function SkillInfo:IsNormalAttack(creature)
	return 1 == self.staticData.Launch_Type
end

function SkillInfo:ShowMagicCrit(creature)
	return not self:IsNormalAttack(creature) and 1 ~= self.staticData.RollType
end

function SkillInfo:GetSpeakName(creature)
	return self.speakName
end

function SkillInfo:GetAutoCondition(creature)
	return self.staticData.AutoCondition
end

function SkillInfo:GetSelfBuffs( creature )
	return self.buffs[mapMode].selfBuffs
end

function SkillInfo:GetTeamBuffs( creature )
	return self.buffs[mapMode].teamBuffs
end

function SkillInfo:NoTargetAutoCast(creature)
	return 1 == self.staticData.NoTargetAutoCast
end


function SkillInfo:NoAttackWait(creature)
	return "Buff" == self.staticData.SkillType
end

function SkillInfo:NoWait(creature)
	return 1 == self.staticData.AttackStatus
end

function SkillInfo:GetTargetType(creature)
	return self.LogicClass.TargetType
end

-- {multi_target=false, single_fire=false, type=1, ...}
function SkillInfo:GetEmitParams(creature)
	return self.emit
end

function SkillInfo:GetPreAttackParams(creature)
	return self.logicParam.pre_attack
end

function SkillInfo:GetAttackEP(creature)
	return self.staticData.Attack_EP or 0
end

function SkillInfo:GetFireEP(creature)
	return self.staticData.Fire_EP or 0
end

function SkillInfo:GetHitEP(creature)
	return self.staticData.Target_EP or 0
end

function SkillInfo:GetCastLockEP(creature)
	return self.staticData.CastLock_EP or 0
end

function SkillInfo:GetPreAttackEffectEP(creature)
	if nil == self.logicParam.pre_attack then
		return 0
	end
	return self.logicParam.pre_attack.effect_ep or 0
end

function SkillInfo:GetCastEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local paths = self.effectsPath[1]
	return GetEffectPath(paths)
end

function SkillInfo:GetCastLockEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		return EffectMap.Maps.LockOnLow
	end
	return EffectMap.Maps.LockOn
end

function SkillInfo:GetCastLockConfigEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end

	local paths = self.effectsPath[6]
	return GetEffectPath(paths)
end

-- return effectPath, isMagicCircle
function SkillInfo:GetCastPointEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	local paths = self.effectsPathMap.reading_effect
	if nil ~= paths then
		return GetEffectPath(paths), false
	end
	
	local magicCircle = nil
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		magicCircle = EffectMap.Maps.MagicCircleLow
	else
		magicCircle = EffectMap.Maps.MagicCircle
	end

	if RoleDefines_Camp.ENEMY == creature.data:GetCamp() then
		return magicCircle[2], true
	end
	return magicCircle[1], true
end

function SkillInfo:GetPointEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		return EffectMap.Maps.MagicCircleLow[1]
	end
	return EffectMap.Maps.MagicCircle[1]
end

function SkillInfo:GetPointEffectSize(creature)
	return self.LogicClass.GetPointEffectSize(self, creature)
end

function SkillInfo:GetAttackEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local paths = self.effectsPath[2]
	return GetEffectPath(paths)
end

function SkillInfo:AttackEffectOnRole(creature)
	return 1 == self.staticData.E_Attack_On
end

function SkillInfo:GetFireEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local paths = self.effectsPath[3]
	return GetEffectPath(paths)
end

function SkillInfo:GetFirePointEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local paths = self.effectsPathMap.effect
	return GetEffectPath(paths)
end

function SkillInfo:GetHitEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	local paths = self.effectsPath[4]
	return GetEffectPath(paths)
end

function SkillInfo:GetDefaultHitEffectPath(creature, damageType)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if DamageType.Crit == damageType then
		return EffectMap.Maps.CriticalHit
	else
		return EffectMap.Maps.NormalHit
	end
end

function SkillInfo:GetMissEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	local paths = self.effectsPath[5]
	return GetEffectPath(paths)
end

function SkillInfo:GetMainHitEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	local paths = self.effectsPathMap.main_hit_effect
	return GetEffectPath(paths)
end

function SkillInfo:GetTreatmentHitEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	local paths = self.effectsPathMap.treatment_hit_effect
	return GetEffectPath(paths)
end

function SkillInfo:GetTrapEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	-- if not SkillLogic_Base.AllowSelfEffect(creature) then
	-- 	return nil
	-- end
	local paths = self.effectsPathMap.trap_effect
	return GetEffectPath(paths)
end

function SkillInfo:GetPreAttackEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	local paths = self.effectsPathMap.pre_attack_effect
	return GetEffectPath(paths)
end

function SkillInfo:GetEmitEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local paths = self.emitEffectPath
	return GetEffectPath(paths)
end

function SkillInfo:GetEmitLogicEffectPath(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil
	end
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local paths = self.emitLogicEffectPath
	return GetEffectPath(paths)
end

-- return path, epID
function SkillInfo:GetBlockHitEffectInfo(creature, targetCreature)
	if Game.HandUpManager:IsInHandingUp() then
		return nil, nil
	end
	local HarmImmune = targetCreature.data:GetProperty("HarmImmune")
	if nil ~= HarmImmune and 0 < HarmImmune then
		local harmImmuneInfo = Game.Config_BuffStateOdds[HarmImmune]
		if nil ~= harmImmuneInfo and nil ~= harmImmuneInfo.Effect then
			return GetEffectPath(harmImmuneInfo.Effect), harmImmuneInfo.EP
		end
	end
	return nil, nil
end

function SkillInfo:GetSpecialAttackEffects(creature)
	return self.staticData.AttackEffects
end

function SkillInfo:GetSpecialHitEffects(creature)
	return self.staticData.HitEffects
end

function SkillInfo:_GetSEPath(creature, index)
	local paths = self.sesPath[index]
	if nil ~= paths then
		local pathLen = #paths
		if 1 < pathLen then
			local p = RandomUtil.Range(1, pathLen)
			p = RandomUtil.RoundInt(p)
			return paths[p]
		else
			return paths[1]
		end
	end
	return nil
end

function SkillInfo:GetCastSEPath(creature)
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	return self:_GetSEPath(creature, 1)
end

function SkillInfo:GetAttackSEPath(creature)
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local path = self:_GetSEPath(creature, 2)
	if nil ~= path then
		if "None" == path then
			return nil
		end
		return path
	end
	
	-- weapon
	local weaponID = creature.assetRole:GetWeaponID()
	if 0 ~= weaponID then
		local weaponInfo = Table_Equip[weaponID]
		if nil ~= weaponInfo then
			return weaponInfo.SE_attack
		end
	end
	return nil
end

function SkillInfo:GetFireSEPath(creature)
	if not SkillLogic_Base.AllowSelfEffect(creature) then
		return nil
	end
	local path = self:_GetSEPath(creature, 3)
	if nil ~= path then
		if "None" == path then
			return nil
		end
		return path
	end
	
	-- weapon
	local weaponID = creature.assetRole:GetWeaponID()
	if 0 ~= weaponID then
		local weaponInfo = Table_Equip[weaponID]
		if nil ~= weaponInfo then
			return weaponInfo.SE_fire
		end
	end
	return nil
end

function SkillInfo:GetHitSEPath(creature, weaponID)
	local path = self:_GetSEPath(creature, 4)
	if nil ~= path then
		if "None" == path then
			return nil
		end
		return path
	end
	
	-- weapon
	if nil == weaponID or 0 == weaponID then
		if nil ~= creature then
			weaponID = creature.assetRole:GetWeaponID()
		end
	end
	if 0 ~= weaponID then
		local weaponInfo = Table_Equip[weaponID]
		if nil ~= weaponInfo then
			return weaponInfo.SE_hit
		end
	end
	return nil
end

function SkillInfo:GetMissSEPath(creature)
	return self:_GetSEPath(creature, 5)
end

function SkillInfo:GetCastAction(creature)
	return self.staticData.CastAct
end

function SkillInfo:GetAttackAction(creature)
	return self.staticData.AttackAct
end

function SkillInfo:GetEndAction(creature)
	return self.staticData.EndAct
end

function SkillInfo:GetLaunchRange(creature)
	local launchRange = self.staticData.Launch_Range
	if nil ~= creature and nil ~= creature.data and launchRange then
		local props = creature.data.props
		if nil ~= props then
			local AtkDistancePer = props.AtkDistancePer:GetValue()
			local AtkDistance = props.AtkDistance:GetValue()

			--skill dynamic start
			local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
			local dynamicSkillInfoProp = dynamicSkillInfo~=nil and dynamicSkillInfo.props or nil

			if(dynamicSkillInfoProp~=nil) then
				AtkDistancePer = AtkDistancePer + dynamicSkillInfoProp.AtkDistancePer:GetValue()
				AtkDistance = AtkDistance + dynamicSkillInfoProp.AtkDistance:GetValue()
			end
			--skill dynamic end

			launchRange = launchRange*(1+AtkDistancePer)+AtkDistance

			if(launchRange<0) then
				launchRange = 0
			end
		end
		if(self:GetTargetType(creature) == SkillTargetType.Point) then
			if(creature.data:NextPointTargetSkillLargeLaunchRange()) then
				launchRange = launchRange + pointTargetLargeLaunchRange
			end
		end
	end
	return launchRange
end

function SkillInfo:NoAction(creature)
	return 1 == self.logicParam.no_action
end

function SkillInfo:NoSelect(creature)
	if 1 == self.logicParam.no_select then
		return true
	end
	if Game.MapManager:IsNoSelectTarget() then
		local logicName = self.staticData.Logic
		if "SkillSelfRange" == logicName
			or "SkillForwardRect" == logicName
			or "SkillPointRange" == logicName
			or "SkillPointRect" == logicName then
			return true
		end
	end
	return false
end

function SkillInfo:NoHit(creature, damageType)
	if 1 == self.logicParam.no_hit then
		return true
	end
	return DamageType.None == damageType 
		or DamageType.Miss == damageType 
		or DamageType.Treatment == damageType 
		or DamageType.Treatment_Sp == damageType 
		or DamageType.Barrier == damageType 
		or DamageType.Block == damageType
end

function SkillInfo:NoHitEffectMove(creature, damageType, damage)
	if nil ~= creature and creature.data:NoHitEffectMove() then
		return true
	end
	if DamageType.None == damageType 
		or DamageType.Miss == damageType 
		or DamageType.Treatment == damageType 
		or DamageType.Treatment_Sp == damageType 
		or DamageType.Barrier == damageType 
		or DamageType.Block == damageType
		or DamageType.AutoBlock == damageType
		or DamageType.WeaponBlock == damageType then
		return true
	end
	if 1 ~= self.logicParam.zero_damage_hitback and 0 == damage then
		return true
	end
	return false
end

function SkillInfo:NoAttackEffectMove(creature)
	return nil ~= creature and creature.data:NoAttackEffectMove()
end

function SkillInfo:NoRepelMajor(creature)
	return 1 == self.logicParam.no_repel_major
end

function SkillInfo:GetFireCount(creature)
	return self.logicParam.fire_count or 1
end

function SkillInfo:TargetIncludeSelf(creature)
	return 1 == self.logicParam.include_self
end

function SkillInfo:TargetIncludeTeamRange(creature)
	return self.logicParam.team_range or 0
end

function SkillInfo:GetTargetsMaxCount(creature)
	local logicParam_range_num = self.logicParam.range_num
	local range_num = logicParam_range_num or 999
	--skill dynamic start
	local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
	if(dynamicSkillInfo~=nil) then
		if(dynamicSkillInfo:GetTargetNumChange()~=0) then
			range_num = logicParam_range_num or 0
			range_num = range_num + dynamicSkillInfo:GetTargetNumChange()
			if(range_num<0) then
				range_num = 0
			end
		end
	end
	--skill dynamic end
	return range_num
end

function SkillInfo:GetTargetRange(creature)
	local range = self.logicParam.range or 0
	--skill dynamic start
	local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
	if(dynamicSkillInfo~=nil) then
		range = range + dynamicSkillInfo:GetTargetRange()
	end
	--skill dynamic end
	return range
end

function SkillInfo:GetTargetForwardRect(creature, offset, size)
	size[1] = self.logicParam.width
	size[2] = self.logicParam.distance
	offset[1] = 0
	offset[2] = size[2]/2 + self.logicParam.forward_offset or 0
end

function SkillInfo:GetTargetRect(creature, offset, size)
	size[1] = self.logicParam.width
	size[2] = self.logicParam.distance
	offset[1] = 0
	offset[2] = 0
end

function SkillInfo:GetTargetAction(creature)
	return self.logicParam.target_action
end

function SkillInfo:PlaceTarget(creature)
	return 1 == self.logicParam.place_target
end

function SkillInfo:SelectLockedTarget(creature)
	return 1 == self.logicParam.select_target
end

function SkillInfo:GetDamageCount(creature, targetCreature, damageType, damage)
	local damageCount = 1
	if DamageType.ErLianJi == damageType then
		damageCount = 2
	else
		local damageCountInfo = self.staticData.DamTime
		if 1 == damageCountInfo.type then
			damageCount = damageCountInfo.value
		elseif 2 == damageCountInfo.type then
			local targetShape = targetCreature.data.shape
			if nil ~= targetShape then
				if CommonFun.Shape.S == targetShape then
					damageCount = damageCountInfo.value.S
				elseif CommonFun.Shape.M == targetShape then
					damageCount = damageCountInfo.value.M
				elseif CommonFun.Shape.L == targetShape then
					damageCount = damageCountInfo.value.L
				end
			end
		end
	end
	if damageCount > damage then
		damageCount = damage
	end
	return damageCount
end

function SkillInfo:TargetOnlyEnemy(creature)
	return self.campsOnlyEnemy
end

function SkillInfo:TargetEnemy(creature)
	if nil == self.camps then
		return false
	end
	if self.campsOnlyEnemy then
		return true
	end
	if 0 == TableUtility.ArrayFindIndex(self.camps, RoleDefines_Camp.ENEMY) then
		return false
	end
	return true
end

function SkillInfo:TargetOnlyTeam(creature) -- exclude myself
	return self.campsOnlyTeam
end

function SkillInfo:TargetInFilter(creature,targetCreature)
	return self:TargetInClassFilter(creature,targetCreature)
end

function SkillInfo:TargetInClassFilter(creature,targetCreature)
	if self.targetfilterClassIDMap~=nil then
		local classID = targetCreature.data:GetClassID()
		return self.targetfilterClassIDMap[classID]~=nil
	end
	return false
end

function SkillInfo:CheckCamps(creature, targetCreature)
	local camps = self.camps
	if nil ~= camps then
		local targetCamp = targetCreature.data:GetCamp()
		--temp handle
		if(creature~=Game.Myself) then
			return true
		end
		for i=1, #camps do
			local c = camps[i]
			if targetCamp == c then
				return true
			elseif SpecialCamp_Team == c then
				if Game.Myself == creature then
					if targetCreature ~= creature and targetCreature:IsInMyTeam() then
						return true
					end
				else
					-- other don't check
					return true
				end
			end
		end
		return false
	end
	return true
end

local DEAD_STATUS=1
local INREVIVE_STATUS=2
function SkillInfo:CheckSelectLife(targetCreature)
	local selectLife = (self.logicParam and self.logicParam.select) or 0
	if 1 <= selectLife then
		-- dead
		if not targetCreature:IsDead() then
			return false
		end
		if(targetCreature:IsInRevive()) then
			if( 1== selectLife) then
				return false,1
			end
		end
	else
		-- alive
		if targetCreature:IsDead() then
			return false
		end
	end
	return true
end

function SkillInfo:CheckTarget(creature, targetCreature)
	-- accessable
	if targetCreature.data:NoAccessable() then
		return false
	end

	-- targetfilter
	if self:TargetInFilter(creature,targetCreature) then
		return false
	end

	-- camp
	if not self:CheckCamps(creature, targetCreature) then
		return false
	end

	-- life
	local lifeCheck,reason = self:CheckSelectLife(targetCreature)
	if not lifeCheck then
		return false,4,reason
	end

	-- detail type
	if nil ~= self.logicParam then
		local notAllowedNPCType = self.logicParam.invalid_target_type
		if nil ~= notAllowedNPCType then
			local npcDetailedType = targetCreature.data.detailedType
			if npcDetailedType and npcDetailedType == notAllowedNPCType then
				return false
			end
		end
	end

	--CanNotBeSkillTargetByEnemy
	if(targetCreature.data:CanNotBeSkillTargetByEnemy() and targetCreature.data:GetCamp()==RoleDefines_Camp.ENEMY) then
		return false
	end

	return true
end

function SkillInfo:IsGuideCast(creature)
	local castParams = self.staticData.Lead_Type
	return nil ~= castParams and SkillCastType.Guide == castParams.type 
end

function SkillInfo:InfiniteCast(creature)
	local castParams = self.staticData.Lead_Type
	return nil ~= castParams 
		and SkillCastType.Lead == castParams.type 
		and 1 ~= castParams.no_infinite
end

function SkillInfo:GetCastInfo(creature)
	local staticData = self.staticData
	local castParams = staticData.Lead_Type
	local castTime = 0
	local castAllowInterrupted = false
	if nil ~= castParams then
		if SkillCastType.Physics == castParams.type then
			castTime = castParams.ReadyTime
			local dynamicSkillInfo,dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)
			if(dynamicSkillInfo~=nil) then
				castTime = castTime + dynamicSkillInfo:GetChangeReady()
			end
			if(castTime<0) then
				castTime = 0
			end
			if(creature and creature.data:NextSkillNoReady()) then
				castTime = 0
			end
		elseif SkillCastType.Magic == castParams.type then
			local props = creature.data.props
			local CTChangePer = props.CTChangePer:GetValue()
			local CTChange = props.CTChange:GetValue()
			local CastSpd = props.CastSpd:GetValue()
			local CTFixedPer = props.CTFixedPer:GetValue()
			local CTFixed = props.CTFixed:GetValue()

			--skill dynamic start
			local dynamicSkillInfo,dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)

			if(dynamicSkillInfoProp~=nil) then
				CTChangePer = CTChangePer + dynamicSkillInfoProp.CTChangePer:GetValue()
				CTChange = CTChange + dynamicSkillInfoProp.CTChange:GetValue()
				CastSpd = CastSpd + dynamicSkillInfoProp.CastSpd:GetValue()
				CTFixedPer = CTFixedPer + dynamicSkillInfoProp.CTFixedPer:GetValue()
				CTFixed = CTFixed + dynamicSkillInfoProp.CTFixed:GetValue()
			end
			--skill dynamic end

			if 0 > CastSpd then
				CastSpd = 0
			end

			local fct = castParams.FCT*(1+CTChangePer)+CTChange-CastSpd
			if 0 > fct then
				fct = 0
			end

			local fixedCCT = (castParams.CCT + CTFixed)
			if(fixedCCT<0) then
				fixedCCT = 0
			end
			local cct = fixedCCT*(1+CTFixedPer)
			if(cct<0) then
				cct = 0
			end
			castTime = cct+fct
			if(creature.data:NextSkillNoReady()) then
				castTime = 0
			end
		elseif SkillCastType.Lead == castParams.type then
			castTime = castParams.duration
			castAllowInterrupted = true
		elseif SkillCastType.Guide == castParams.type then
			local props = creature.data.props
			local DChangePer = props.DChangePer:GetValue()
			local DChange = props.DChange:GetValue()

			--skill dynamic start
			local dynamicSkillInfo,dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)
			if nil ~= dynamicSkillInfoProp then
				DChangePer = DChangePer + dynamicSkillInfoProp.DChangePer:GetValue()
				DChange = DChange + dynamicSkillInfoProp.DChange:GetValue()
			end
			--skill dynamic end

			castTime = (castParams.DCT+DChange)*(1+DChangePer)
			if 0 > castTime then
				castTime = 0
			end
		end
	end
	return castTime, castAllowInterrupted
end

function SkillInfo:GetLogicRealCD(creature)
	return self:GetCD(creature,true)
end

function SkillInfo:GetCD(creature,calLogicReal)
	local cd = self.staticData.CD or 0
	local props = creature.data.props
	local logicRealCd = self.logicParam and self.logicParam.real_cd
	if(calLogicReal and logicRealCd) then
		cd = logicRealCd
	end
	if nil ~= props and nil ~= cd then
		-- 基本时间(技能表CD字段)*(1+CDChangePer)+CDChange 
		local CDChangePer = props.CDChangePer:GetValue()
		local CDChange = props.CDChange:GetValue()

		if(self.staticData.FixCD and self.staticData.FixCD==1) then
			CDChangePer = 0
			CDChange = 0
		end

		--skill dynamic start
		local dynamicSkillInfo,dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)

		if(dynamicSkillInfoProp~=nil) then
			CDChangePer = CDChangePer + dynamicSkillInfoProp.CDChangePer:GetValue()
			CDChange = CDChange + dynamicSkillInfoProp.CDChange:GetValue()
		end
		--skill dynamic end

		cd = cd*(1+CDChangePer)+CDChange
	end
	if(cd==0 and self.staticData.CD==nil) then
		return nil
	end
	return cd
end
function SkillInfo:GetDelayCD(creature)
	local cd = self.staticData.DelayCD or 0
	local props = creature.data.props
	if nil ~= props and nil ~= cd then
		-- 基本时间(技能表CD字段)*(1+DelayCDChangePer)+DelayCDChange 
		local CDChangePer = props.DelayCDChangePer:GetValue()
		local CDChange = props.DelayCDChange:GetValue()

		--skill dynamic start
		local dynamicSkillInfo,dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)

		if(dynamicSkillInfoProp~=nil) then
			CDChangePer = CDChangePer + dynamicSkillInfoProp.DelayCDChangePer:GetValue()
			CDChange = CDChange + dynamicSkillInfoProp.DelayCDChange:GetValue()
		end
		--skill dynamic end

		cd = cd*(1+CDChangePer)+CDChange
		if(cd<0) then
			cd = 0
		end
	end
	if(cd==0 and self.staticData.DelayCD==nil) then
		return nil
	end
	return cd
end
function SkillInfo:GetSP(creature)
	local SpCost = self.staticData.SkillCost.sp or 0
	local props = creature.data.props
	if nil ~= props and nil~=SpCost then
			-- 基本SP消耗(技能表SpCost字段)*(1+SpCostPer)+SpCost
			local SpCostPer = props.SpCostPer:GetValue()
			local RSpCost = props.SpCost:GetValue()

			--skill dynamic start
			local dynamicSkillInfo,dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)

			if(dynamicSkillInfoProp~=nil) then
				SpCostPer = SpCostPer + dynamicSkillInfoProp.SpCostPer:GetValue()
				RSpCost = RSpCost + dynamicSkillInfoProp.SpCost:GetValue()
			end
			--skill dynamic end

			SpCost = math.max(0,SpCost*(1+SpCostPer)+RSpCost)
	end

	local maxSpPer = self.staticData.SkillCost.maxspper
	if maxSpPer ~= nil then
		SpCost = math.max(0, props.MaxSp:GetValue() * maxSpPer / 100)
	end

	if(SpCost==0 and self.staticData.SkillCost.sp==nil and maxSpPer == nil ) then
		return nil
	end
	return SpCost
end
function SkillInfo:GetHP(creature)
	local HpCost = self.staticData.SkillCost.hp or 0
	local props = creature.data.props
	if nil ~= props and nil~=HpCost and nil ~= props.HpCost then
			-- 基本SP消耗(技能表SpCost字段)*(1+SpCostPer)+SpCost
			local HpCostPer = props.HpCostPer:GetValue()
			local RHpCost = props.HpCost:GetValue()

			--skill dynamic start
			local dynamicSkillInfo,dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)
			if(dynamicSkillInfoProp~=nil) then
				HpCostPer = HpCostPer + dynamicSkillInfoProp.HpCostPer:GetValue()
				RHpCost = RHpCost + dynamicSkillInfoProp.HpCost:GetValue()
			end
			--skill dynamic end

			HpCost = HpCost*(1+HpCostPer)+RHpCost
	end
	if(HpCost==0 and self.staticData.SkillCost.hp==nil) then
		return nil
	end
	return HpCost
end

function SkillInfo:TeamFirst(creature)
	return 1 == self.logicParam.team_first
end

--return dynamicSkillinfo,dynamicSkillinfo.props
function SkillInfo:_GetDynamicSkillInfoAndProp(creature)
	local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
	local dynamicSkillInfoProp = dynamicSkillInfo~=nil and dynamicSkillInfo.props or nil
	return dynamicSkillInfo,dynamicSkillInfoProp
end