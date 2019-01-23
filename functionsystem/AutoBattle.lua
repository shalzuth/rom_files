AutoBattle = class("AutoBattle")

-- static method begin
-- function AutoBattle.SortTargetList(rolePosition, roleList)
-- 	local rolePositionXZ = Vector2(rolePosition.x, rolePosition.z)
-- 	local time = Time.time
-- 	if nil ~= AutoBattle.currentCreature then
-- 		AutoBattle.currentCreature:RemoveInvalidHatred()
-- 	end
-- 	LuaUtils.SortRoleList(roleList, function(role1, role2)
-- 		local creature1 = role1.data.custom
-- 		local creature2 = role2.data.custom
-- 		if nil ~= AutoBattle.currentCreature then
-- 			if AutoBattle.currentCreature:CheckHatred(creature1.id, time) then
-- 				return -1
-- 			end
-- 			if AutoBattle.currentCreature:CheckHatred(creature2.id, time) then
-- 				return 1
-- 			end
-- 		end
-- 		if nil ~= creature1 and nil ~= creature2 then
-- 			-- Full HP First
-- 			local maxHP1 = creature1.props.MaxHp:GetValue()
-- 			local HP1 = creature1.props.Hp:GetValue()

-- 			local maxHP2 = creature2.props.MaxHp:GetValue()
-- 			local HP2 = creature2.props.Hp:GetValue()

-- 			if HP1 == maxHP1 and HP2 ~= maxHP2 then
-- 				return -1
-- 			elseif HP1 ~= maxHP1 and HP2 == maxHP2 then
-- 				return 1
-- 			end
-- 		end
-- 		local p1 = role1.position
-- 		local p2 = role2.position
-- 		local d1 = Vector2.Distance(rolePositionXZ, Vector2(p1.x, p1.z))
-- 		local d2 = Vector2.Distance(rolePositionXZ, Vector2(p2.x, p2.z))
-- 		if d1 < d2 then
-- 			return -1
-- 		end
-- 		return 1
-- 	end)
-- end
-- static method end

local tempCreatureArray = {}

AutoBattle.SearchRandomDistance = 5

AutoBattle.currentCreature = nil
AutoBattle.searchPosition = nil
AutoBattle.searchRange = nil
AutoBattle.randomTarget = nil
AutoBattle.hatredTarget = nil
AutoBattle.hatredMinDistance = 999999999

local function TargetFilter(targetCreature, searchTargetArgs)
	if nil ~= targetCreature.data and targetCreature.data:NoAutoAttack() then
		return false
	end
	return true
end
AutoBattle.TargetFilter = TargetFilter

local function SearchRandomTarget(targetCreature, skillInfo)
	local dist = VectorUtility.DistanceXZ(AutoBattle.searchPosition, targetCreature:GetPosition())
	if nil ~= AutoBattle.searchRange and dist > AutoBattle.searchRange then
		return false
	end
	if AutoBattle.SearchRandomDistance > dist 
		and TargetFilter(targetCreature)
		and skillInfo:CheckTarget(AutoBattle.currentCreature, targetCreature) then
		AutoBattle.randomTarget = targetCreature
		-- LogUtility.InfoFormat("<color=yellow>SearchRandomTarget: </color>{0}", 
		-- 	targetCreature.data:GetName())
		return RandomUtil.Range(1, 10) < 5
	end
	return false
end

local function SearchHatredTarget(targetCreature, hatredTime, skillInfo)
	if TargetFilter(targetCreature)
		and skillInfo:CheckTarget(AutoBattle.currentCreature, targetCreature) then
		local dist = VectorUtility.DistanceXZ(AutoBattle.searchPosition, targetCreature:GetPosition())
		if nil ~= AutoBattle.searchRange and dist > AutoBattle.searchRange then
			return false
		end
		if AutoBattle.hatredMinDistance > dist then
			AutoBattle.hatredTarget = targetCreature
			AutoBattle.hatredMinDistance = dist
			-- LogUtility.InfoFormat("<color=yellow>SearchHatredTarget: </color>{0}, {1}", 
			-- 	targetCreature.data:GetName(), dist)
		end
	end
	return false
end

function AutoBattle.SeartTarget(creature, skillInfo)
	local teamFirst = skillInfo:TeamFirst(creature)

	local lockedTarget = creature:GetLockTarget()
	if nil ~= lockedTarget then
		if not teamFirst or lockedTarget:IsInMyTeam() then
			if skillInfo:CheckTarget(creature, lockedTarget) 
				and TargetFilter(creature, nil) then
				return lockedTarget
			end
		end
	end

	local searchRange = 40
	if creature:IsAutoBattleStanding() then
		searchRange = skillInfo:GetLaunchRange(creature)
		AutoBattle.searchRange = searchRange
	end

	if not teamFirst then
		AutoBattle.currentCreature = creature
		AutoBattle.searchPosition = creature:GetPosition()
		AutoBattle.randomTarget = nil
		SceneCreatureProxy.ForEachCreature(SearchRandomTarget, skillInfo)
		AutoBattle.currentCreature = nil
		AutoBattle.searchPosition = nil
		AutoBattle.searchRange = nil
		if nil ~= AutoBattle.randomTarget then
			local targetCreature = AutoBattle.randomTarget
			AutoBattle.randomTarget = nil
			return targetCreature
		end
	end

	local sortComparator = teamFirst 
		and SkillLogic_Base.SortComparator_TeamFirstDistance
		or SkillLogic_Base.SortComparator_Distance
	SkillLogic_Base.SearchTargetInRange(
		tempCreatureArray, 
		creature:GetPosition(), 
		searchRange, 
		skillInfo, 
		creature, 
		TargetFilter, 
		sortComparator)
	local targetCreature = tempCreatureArray[1]
	TableUtility.ArrayClear(tempCreatureArray)
	return targetCreature
end

function AutoBattle:ctor()
	-- self.skillTargetFilter = function(role)
	-- 	local creature = role.data.custom
	-- 	if nil == creature then
	-- 		return true
	-- 	end
	-- 	local detailedType = creature:GetDetailedType()
	-- 	if nil == detailedType then
	-- 		return true
	-- 	end
	-- 	if LNpc.NpcDetailedType.MINI ~= detailedType 
	-- 		and LNpc.NpcDetailedType.MVP ~= detailedType then
	-- 		return true
	-- 	end

	-- 	return false
	-- end
	self:Reset()
end

function AutoBattle:Reset()
	self.skillIndex = nil
	if nil ~= self.skillStatus then
		TableUtility.TableClear(self.skillStatus)
	else
		self.skillStatus = {}
	end
end

function AutoBattle:Update(creature, skillFilter, onlyNoTargetAutoCast, allowResearch)
	self:Attack(creature, nil, skillFilter, onlyNoTargetAutoCast, allowResearch)
end

function AutoBattle:Attack(creature, targetCreature, skillFilter, onlyNoTargetAutoCast, allowResearch)
	local creaturePosition = creature:GetPosition()
	if nil == creaturePosition then
		return false
	end

	if creature.data:NoAttack() then
		return false
	end

	local ret, skillIDAndLevel, noTarget, forceLockCreature, skillInfo = self:Attack_Step1(
		creature, 
		skillFilter, 
		onlyNoTargetAutoCast)
	if not ret then
		return false
	end
	-- LogUtility.InfoFormat("<color=green>AutoBattle selected: </color>{0}, {1}", 
	-- 	skillIDAndLevel, noTarget)

	return self:Attack_Step2(
		creature, 
		targetCreature, 
		skillIDAndLevel, 
		noTarget, 
		forceLockCreature, 
		skillInfo, 
		onlyNoTargetAutoCast, 
		allowResearch)
end

function AutoBattle:Attack_Step1(creature, skillFilter, onlyNoTargetAutoCast)
	local skillIDAndLevel, noTarget, forceLockCreature = self:SelectSkill(creature, skillFilter, onlyNoTargetAutoCast)
	if nil == skillIDAndLevel then
		return false
	end
	local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
	return true, skillIDAndLevel, noTarget, forceLockCreature, skillInfo
end

function AutoBattle:Attack_Step2(creature, targetCreature, skillIDAndLevel, noTarget, forceLockCreature, skillInfo, onlyNoTargetAutoCast, allowResearch)
	local noSearch = false
	-- if onlyNoTargetAutoCast or (not noTarget and nil ~= targetCreature) then
	if onlyNoTargetAutoCast or nil ~= targetCreature then
		noSearch = true
	end
	if nil == forceLockCreature then
		forceLockCreature = targetCreature
		-- hatred first
		local hatredFirst = creature:IsAutoBattleProtectingTeam()
		if hatredFirst and skillInfo:TargetEnemy(creature) then
			-- hatred first
			AutoBattle.currentCreature = creature
			AutoBattle.searchPosition = creature:GetPosition()
			AutoBattle.searchRange = creature:IsAutoBattleStanding() and skillInfo:GetLaunchRange(creature) or nil
			AutoBattle.hatredTarget = nil
			AutoBattle.hatredMinDistance = 999999999
			Game.LogicManager_Hatred:ForEach(SearchHatredTarget, skillInfo)
			AutoBattle.currentCreature = nil
			AutoBattle.searchPosition = nil
			AutoBattle.searchRange = nil
			AutoBattle.hatredMinDistance = 999999999
			if nil ~= AutoBattle.hatredTarget then
				forceLockCreature = AutoBattle.hatredTarget
				AutoBattle.hatredTarget = nil
				noSearch = true
			end
		end
	end

	local forceTargetCreature = false
	local targetPosition = nil

	local skillTargetType = skillInfo:GetTargetType(creature)
	if SkillTargetType.Point == skillTargetType then
		if noTarget and nil == forceLockCreature then
			targetPosition = creature:GetPosition()
		else
			forceTargetCreature = true
		end
	elseif (SkillTargetType.None == skillTargetType and not noTarget) then
		forceTargetCreature = true
	end

	if forceTargetCreature and nil == forceLockCreature then
		if noSearch then
			return false
		end
		forceLockCreature = AutoBattle.SeartTarget(creature, skillInfo)
		if nil == forceLockCreature then
			-- LogUtility.InfoFormat("<color=yellow>AutoBattle No Target Creature: </color>{0}", 
			-- 	skillIDAndLevel)
			return false
		end
	end

	if nil ~= forceLockCreature 
		and (SkillTargetType.Creature == skillTargetType or forceTargetCreature)
		and noSearch
		and forceLockCreature == targetCreature 
		and not skillInfo:CheckTarget(creature, forceLockCreature) then
		return false
	end

	-- LogUtility.InfoFormat("<color=green>AutoBattle Use Skill: </color>{0}, {1}, {2}", 
	-- 	skillIDAndLevel,
	-- 	forceLockCreature and forceLockCreature.data:GetName() or "NoTarget",
	-- 	noSearch)

	if nil == targetPosition and nil ~= forceLockCreature then
		targetPosition = forceLockCreature:GetPosition()
	end

	creature:Client_UseSkill(
		skillIDAndLevel, 
		forceLockCreature, 
		targetPosition, 
		forceTargetCreature,
		noSearch,
		TargetFilter,
		allowResearch)

	local skillStatus = self.skillStatus[skillIDAndLevel]
	if nil == skillStatus then
		skillStatus = {}
		self.skillStatus[skillIDAndLevel] = skillStatus
	end
	skillStatus.lastLaunchTime = Time.time
	return true
end

function AutoBattle:SelectSkill(creature, filter, onlyNoTargetAutoCast)
	local skillProxy = SkillProxy.Instance
	if nil ~= skillProxy then
		local skillItems = skillProxy:GetAutoBattleSkillsWithCombo()
		local startIndex = 1
		if nil ~= self.skillIndex then
			startIndex = self.skillIndex + 1
			-- LogUtility.InfoFormat("<color=yellow>SelectSkill: </color>startIndex={0}", startIndex)
		end
		-- print ("<color=blue>AutoBattle SelectSkill: </color>startIndex="..startIndex)
		local skillItem, skillIndex, noTarget, forceLockCreature = self:LoopGetValidSkill(creature, skillItems, startIndex, filter, onlyNoTargetAutoCast)
		if nil ~= skillItem then
			-- LogUtility.InfoFormat("<color=blue>AutoBattle SelectSkill: </color>selectedIndex={0}", skillIndex)
			if nil ~= skillIndex then
				self.skillIndex = skillIndex
			end
			return skillItem:GetID(), noTarget, forceLockCreature
		end
	end

	-- 2016.3.31. remove default attack
	-- local attackSkillIDAndLevel = AutoBattle.GetAttackSkillIDAndLevel(role)
	-- if nil == filter or filter(attackSkillIDAndLevel) then
	-- 	return attackSkillIDAndLevel
	-- end
	return nil
end

function AutoBattle:IsSkillAutoBattleValid(creature, skillIDAndLevel, autoBattleParams, skillInfo)
	local forceLockCreature = nil
	if nil ~= autoBattleParams then
		if 1 == autoBattleParams.type then
			local skillStatus = self.skillStatus[skillIDAndLevel]
			if nil ~= skillStatus 
				and nil ~= skillStatus.lastLaunchTime 
				and Time.time < (skillStatus.lastLaunchTime+autoBattleParams.time) then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=1, time limit={1}, rest time={2}", 
				-- 	skillIDAndLevel, 
				-- 	autoBattleParams.time, 
				-- 	skillStatus.lastLaunchTime+autoBattleParams.time - Time.time)
				return false
			end
		elseif 2 == autoBattleParams.type then
			-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=2", skillIDAndLevel)
			return false
		elseif 3 == autoBattleParams.type then
			local props = creature.data.props
			if nil ~= props then
				local maxHP = props.MaxHp:GetValue()
				local HP = props.Hp:GetValue()
				if HP >= autoBattleParams.value/100.0*maxHP then
					-- print(string.format("<color=yellow>IsSkillAutoBattleValid: </color>skill=%d, type=3", skillIDAndLevel))
					return false
				end
			end
		elseif 5 == autoBattleParams.type then
			local myTeam = TeamProxy.Instance.myTeam
			if nil == myTeam then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=5, 1", skillIDAndLevel)
				return false
			end
			local members = myTeam:GetMembersList()
			if nil == members then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=5, 2", skillIDAndLevel)
				return false
			end
			local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
			local skillLaunchRange = skillInfo:GetLaunchRange(creature)
			local rolePosition = creature:GetPosition()
			local minHPPercent = 1
			local minHPCreature = nil
			for i=1, #members do
				local m = members[i]
				local memberCreature = SceneCreatureProxy.FindCreature(m.id)
				if nil ~= memberCreature and not memberCreature:IsDead() then
					local targetNoBuffId = autoBattleParams.target_noBuff
					local targetHasNoBuff = true
					if targetNoBuffId ~= nil then
						targetHasNoBuff = not memberCreature.data:HasBuffID(targetNoBuffId)
					end
					-- member must be around me
					if targetHasNoBuff and not (VectorUtility.DistanceXZ(rolePosition, memberCreature:GetPosition()) > skillLaunchRange) 
						and nil ~= m.hpmax and nil ~= m.hp then
						local maxHP = m.hpmax
						local HP = m.hp
						local HPPercent = HP / maxHP
						if (nil == minHPCreature or HPPercent < minHPPercent) 
							and skillInfo:CheckTarget(creature, memberCreature) then
							minHPPercent = HPPercent
							minHPCreature = memberCreature
						end
					end
				end
			end
			if nil == minHPCreature 
				or minHPPercent >= autoBattleParams.teamvalue/100.0 then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=5, 3", skillIDAndLevel)
				return false
			end

			forceLockCreature = minHPCreature
		elseif 7 == autoBattleParams.type then
			local myTeam = TeamProxy.Instance.myTeam
			if nil == myTeam then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=7, 1", skillIDAndLevel)
				return false
			end
			local members = myTeam:GetMembersList()
			if nil == members then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=7, 2", skillIDAndLevel)
				return false
			end
			local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
			local buffs = skillInfo:GetTeamBuffs(creature)
			if nil == buffs or 0 >= #buffs then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=7, 3", skillIDAndLevel)
				return false
			end
			local onlyLockTarget = nil
			if 1 == autoBattleParams.only_lock_target then
				onlyLockTarget = creature:GetLockTarget()
			end

			local skillLaunchRange = skillInfo:GetLaunchRange(creature)
			local rolePosition = creature:GetPosition()
			for i=1, #members do
				local m = members[i]
				local memberCreature = SceneCreatureProxy.FindCreature(m.id)
				if nil ~= memberCreature and not memberCreature:IsDead() then
					-- member must be around me
					if not (VectorUtility.DistanceXZ(rolePosition, memberCreature:GetPosition()) > skillLaunchRange) 
						and not memberCreature:HasBuffs(buffs) 
						and skillInfo:CheckTarget(creature, memberCreature)
						and (nil == onlyLockTarget or onlyLockTarget == memberCreature) then
						forceLockCreature = memberCreature
						break
					end
				end
			end
			if nil == forceLockCreature then
				return false
			end
		elseif 8 == autoBattleParams.type then
			local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
			local buffs = skillInfo:GetSelfBuffs(creature)
			if nil == buffs or 0 >= #buffs then
				return false
			end
			if creature:HasBuffs(buffs) then
				return false
			end
		elseif 9 == autoBattleParams.type then
			local myTeam = TeamProxy.Instance.myTeam
			if nil == myTeam then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=9, 1", skillIDAndLevel)
				return false
			end
			local members = myTeam:GetMembersList()
			if nil == members then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=9, 2", skillIDAndLevel)
				return false
			end
			local buffStateEffects = autoBattleParams.state_effect
			if nil == buffStateEffects or 0 >= #buffStateEffects then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=9, 3", skillIDAndLevel)
				return false
			end
			local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
			local skillLaunchRange = skillInfo:GetLaunchRange(creature)
			local rolePosition = creature:GetPosition()
			for i=1, #members do
				local m = members[i]
				local memberCreature = SceneCreatureProxy.FindCreature(m.id)
				if nil ~= memberCreature and not memberCreature:IsDead() then
					-- member must be around me
					if not (VectorUtility.DistanceXZ(rolePosition, memberCreature:GetPosition()) > skillLaunchRange)
						and memberCreature:HasBuffStates(buffStateEffects) 
						and skillInfo:CheckTarget(creature, memberCreature) then
						forceLockCreature = memberCreature
						break
					end
				end
			end
			if nil == forceLockCreature then
				return false
			end
		elseif 10 == autoBattleParams.type then
			local myTeam = TeamProxy.Instance.myTeam
			if nil == myTeam then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=10, 1", skillIDAndLevel)
				return false
			end
			local members = myTeam:GetMembersList()
			if nil == members then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=10, 2", skillIDAndLevel)
				return false
			end
			local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
			local skillLaunchRange = skillInfo:GetLaunchRange(creature)
			local rolePosition = creature:GetPosition()
			for i=1, #members do
				local m = members[i]
				local memberCreature = SceneCreatureProxy.FindCreature(m.id)
				if nil ~= memberCreature and memberCreature:IsDead()
					and not (VectorUtility.DistanceXZ(rolePosition, memberCreature:GetPosition()) > skillLaunchRange) 
					and skillInfo:CheckTarget(creature, memberCreature) then
					-- member must be around me
					forceLockCreature = memberCreature
					break
				end
			end
			if nil == forceLockCreature then
				return false
			end
		elseif 11 == autoBattleParams.type then
			local props = creature.data.props
			if nil ~= props then
				local maxHP = props.MaxHp:GetValue()
				local HP = props.Hp:GetValue()
				if HP <= autoBattleParams.value/100.0*maxHP then
					-- print(string.format("<color=yellow>IsSkillAutoBattleValid: </color>skill=%d, type=11", skillIDAndLevel))
					return false
				end
			end
		elseif 12 == autoBattleParams.type then
			if creature:HasBuff(autoBattleParams.buffid) 
				and creature:GetBuffLayer(autoBattleParams.buffid) >= autoBattleParams.num then
				return false
			end
		elseif 13 == autoBattleParams.type then
			local myTeam = TeamProxy.Instance.myTeam
			if nil == myTeam then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=7, 1", skillIDAndLevel)
				return false
			end
			local members = myTeam:GetMembersList()
			if nil == members then
				-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type=7, 2", skillIDAndLevel)
				return false
			end
			local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
			local onlyLockTarget = nil
			if 1 == autoBattleParams.only_lock_target then
				onlyLockTarget = creature:GetLockTarget()
			end

			local skillLaunchRange = skillInfo:GetLaunchRange(creature)
			local rolePosition = creature:GetPosition()
			for i=1, #members do
				local m = members[i]
				local memberCreature = SceneCreatureProxy.FindCreature(m.id)
				if nil ~= memberCreature and not memberCreature:IsDead() then
					-- member must be around me
					if not (VectorUtility.DistanceXZ(rolePosition, memberCreature:GetPosition()) > skillLaunchRange) 
						and memberCreature:GetBuffLayer(autoBattleParams.buffid) < autoBattleParams.num
						and skillInfo:CheckTarget(creature, memberCreature)
						and (nil == onlyLockTarget or onlyLockTarget == memberCreature) then
						forceLockCreature = memberCreature
						break
					end
				end
			end
			if nil == forceLockCreature then
				return false
			end
		end
	end
	-- LogUtility.InfoFormat("<color=yellow>IsSkillAutoBattleValid: </color>skill={0}, type={1}, {2}", skillIDAndLevel, autoBattleParams and autoBattleParams.type or -1, forceLockCreature and forceLockCreature.name or "nil")
	return true, forceLockCreature
end

function AutoBattle:IsSkillItemValid(creature, skillItem, filter, onlyNoTargetAutoCast)
	if nil == skillItem then
		-- LogUtility.Info("<color=yellow>IsSkillItemValid: </color>skillItem is nil")
		return false
	end
	local skillIDAndLevel = skillItem:GetID()
	local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)

	local noTarget = false
	local forceLockCreature = nil
	local autoBattlePriority = 0
	local autoBattleParams = skillInfo:GetAutoCondition(creature)
	if nil ~= autoBattleParams and 0 < #autoBattleParams then
		local autoBattleValid = false
		for i=1, #autoBattleParams do
			local p = autoBattleParams[i]
			local valid, targetCreature = self:IsSkillAutoBattleValid(creature, skillIDAndLevel, p, skillInfo)
			if valid then
				autoBattleValid = true
				noTarget = (1 == p.no_target)
				forceLockCreature = targetCreature
				if nil ~= p.priority then
					autoBattlePriority = p.priority
				end
				break
			end
		end
		if not autoBattleValid then
			-- LogUtility.Info("<color=yellow>IsSkillItemValid: </color>autoBattleValid=false")
			return false
		end
	end
	if(skillItem:IsAutoShortCutLocked()) then
		return false
	end
	if not SkillProxy.Instance:SkillCanBeUsed(skillItem) then
		-- LogUtility.InfoFormat("<color=yellow>IsSkillItemValid: </color>skill={0}, SkillCanBeUsed=false", skillIDAndLevel)
		return false
	end
	if nil ~= filter and not filter(skillIDAndLevel) then
		-- LogUtility.InfoFormat("<color=yellow>IsSkillItemValid: </color>skill={0}, filter=false", skillIDAndLevel)
		return false
	end

	if nil == forceLockCreature 
		and onlyNoTargetAutoCast 
		and not skillInfo:NoTargetAutoCast(creature) then
		return false
	end

	return true, noTarget, forceLockCreature, autoBattlePriority
end

function AutoBattle:LoopGetValidSkill(creature, skillItems, startIndex, filter, onlyNoTargetAutoCast)
	local attackSkillIDAndLevel = creature.data:GetAttackSkillIDAndLevel()
	local attackSkillItem = nil
	local attackSkillIndex = nil
	local attackSkillNoTarget = false
	local attackSkillForceLockCreature = nil

	local selectedSkillItem = nil
	local selectedIndex = nil 
	local selectedNoTarget = false
	local selectedForceLockCreature = nil
	local selectedPriority = -1

	if nil ~= skillItems and 0 < #skillItems then
		local skillItemCount = #skillItems
		if startIndex <= skillItemCount then
			for i = startIndex, skillItemCount do
				local skillItem = skillItems[i]
				local skillID = skillItem:GetID()
				local valid, noTarget, forceLockCreature, priority = self:IsSkillItemValid(creature, skillItem, filter, onlyNoTargetAutoCast)
				-- LogUtility.InfoFormat("<color>Try Select Skill(in {0}): </color>{1}{2}",
				-- 	skillItemCount,
				-- 	LogUtility.StringFormat("i={0},valid={1},noTarget={2},",i,valid,noTarget),
				-- 	LogUtility.StringFormat("forceLockCreature={0},priority={1}",forceLockCreature,priority))
				if valid then
					if attackSkillIDAndLevel ~= skillID then
						if not creature.data:NoSkill() then
							if selectedPriority < priority then
								selectedSkillItem = skillItem
								selectedIndex = i
								selectedNoTarget = noTarget
								selectedForceLockCreature = forceLockCreature
								selectedPriority = priority
							end
							-- return skillItem, i, noTarget, forceLockCreature
						end
					else
						attackSkillItem = skillItem
						attackSkillIndex = i
						attackSkillNoTarget = noTarget
						attackSkillForceLockCreature = forceLockCreature
					end
				end
			end
		end
		
		local endIndex = math.min(startIndex, skillItemCount)
		if 0 < endIndex and 1 < startIndex then
			for i = 1, endIndex do
				local skillItem = skillItems[i]
				local skillID = skillItem:GetID()
				local valid, noTarget, forceLockCreature, priority = self:IsSkillItemValid(creature, skillItem, filter, onlyNoTargetAutoCast)
				-- LogUtility.InfoFormat("<color>Try Select Skill(in {0}): </color>{1}{2}",
				-- 	skillItemCount,
				-- 	LogUtility.StringFormat("i={0},valid={1},noTarget={2},",i,valid,noTarget),
				-- 	LogUtility.StringFormat("forceLockCreature={0},priority={1}",forceLockCreature,priority))
				if valid then
					if attackSkillIDAndLevel ~= skillID then
						if not creature.data:NoSkill() then
							if selectedPriority < priority then
								selectedSkillItem = skillItem
								selectedIndex = i
								selectedNoTarget = noTarget
								selectedForceLockCreature = forceLockCreature
								selectedPriority = priority
							end
							-- return skillItem, i, noTarget, forceLockCreature
						end
					else
						attackSkillItem = skillItem
						attackSkillIndex = i
						attackSkillNoTarget = noTarget
						attackSkillForceLockCreature = forceLockCreature
					end
				end
			end
		end
	end

	if nil ~= selectedSkillItem then
		return selectedSkillItem, selectedIndex, selectedNoTarget, selectedForceLockCreature
	end

	-- return attackSkillItem, attackSkillIndex, attackSkillNoTarget, forceLockCreature
	return attackSkillItem, nil, attackSkillNoTarget, forceLockCreature
end
