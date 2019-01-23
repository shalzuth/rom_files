
local AccessHelper = AI_CMD_Myself_AccessHelper

local SkillCMD = {}
local SkillCMD_Track = {}
local SkillCMD_Run = {}
setmetatable(SkillCMD_Run, {__index = AI_CMD_Myself_Skill_Run})

-- self.args = {
-- 	[1] = skillID, -- int
-- 	[2] = targetCreatureGUID, -- long
-- 	[3] = targetPosition, LuaVector3 or nil
-- 	[4] = ignoreNavMesh, -- bool or nil
-- 	[5] = forceTargetCreature, -- bool or nil
-- 	[6] = allowResearch, -- bool or nil
-- 	[7] = ignoreLaunchRange, -- bool or nil
-- }

local phaseCMD = nil
local nextPhaseCMD = nil

local ResearchInterval = 0.5
local nextResearchTime = 0

function SkillCMD.Start(self, time, deltaTime, creature)
	local args = self.args

	-- find target
	local targetCreature = SceneCreatureProxy.FindCreature(args[2])
	if nil == targetCreature or Game.Myself == targetCreature then
		return false
	end

	if SkillCMD_Run == phaseCMD then
		return phaseCMD.Start(
			self, time, deltaTime, creature, 
			targetCreature)
	end

	local targetPosition = targetCreature:GetPosition()

	local skill = creature.skill
	local skillInfo = skill.info
	local launchRange = 0
	if not args[8] then 
		launchRange = skillInfo:GetLaunchRange(creature)
	end

	if 0 < launchRange then
		local currentPosition = creature:GetPosition()
		if VectorUtility.DistanceXZ(currentPosition, targetPosition) > launchRange then
			if creature:IsAutoBattleStanding() then
				creature:Client_ClearAutoBattleCurrentTarget()
				local lockedTarget = creature:GetLockTarget()
				if lockedTarget == targetCreature then
					creature:Client_LockTarget(nil)
				end
				return false
			end
			-- track
			if SkillCMD_Track.Start(
				self, time, deltaTime, creature, 
				targetCreature, 
				launchRange,
				args[4]) then
				phaseCMD = SkillCMD_Track
				return true
			else
				return false
			end
		end
	end

	-- launch
	if SkillCMD_Run.Start(
		self, time, deltaTime, creature, 
		targetCreature) then
		phaseCMD = SkillCMD_Run
		return true
	else
		return false
	end
end

function SkillCMD.End(self, time, deltaTime, creature)
	phaseCMD.End(self, time, deltaTime, creature)
	if nil ~= nextPhaseCMD then
		phaseCMD = nextPhaseCMD
		nextPhaseCMD = nil
		self:SetKeepAlive(true)
	else
		phaseCMD = nil
	end
end

function SkillCMD.Update(self, time, deltaTime, creature)
	phaseCMD.Update(self, time, deltaTime, creature)
end

-- SkillCMD_Track begin
function SkillCMD_Track.Start(self, time, deltaTime, creature, targetCreature, launchRange, ignoreNavMesh)
	local ret, canLaunch = AccessHelper.Start(
		self, time, deltaTime, creature,
		targetCreature, 
		launchRange,
		ignoreNavMesh)
	if canLaunch then
		nextPhaseCMD = SkillCMD_Run
	else
		if ret then
			self:SetInterruptLevel(2)
			nextResearchTime = time+ResearchInterval
		end
	end
	return ret
end

function SkillCMD_Track.End(self, time, deltaTime, creature)
	AccessHelper.End(self, time, deltaTime, creature)
end

function SkillCMD_Track.Update(self, time, deltaTime, creature)
	local targetCreature = SceneCreatureProxy.FindCreature(self.args[2])
	if nil == targetCreature then
		self:End(time, deltaTime, creature)
		return
	end
	local skill = creature.skill
	local skillInfo = skill.info
	local launchRange = skillInfo:GetLaunchRange(creature)
	local ret, canLaunch = AccessHelper.Update(
		self, time, deltaTime, creature, 
		targetCreature, 
		launchRange, 
		self.args[4])
	if ret then
		if canLaunch then
			nextPhaseCMD = SkillCMD_Run
		end
		self:End(time, deltaTime, creature)
	else
		if creature:IsAutoBattleStanding() then
			creature:Client_ClearAutoBattleCurrentTarget()
			local lockedTarget = creature:GetLockTarget()
			if lockedTarget == targetCreature then
				creature:Client_LockTarget(nil)
			end
			self:End(time, deltaTime, creature)
			return
		else
			-- try research
			if self.args[6] and time > nextResearchTime then
				nextResearchTime = time+ResearchInterval

				targetCreature = SkillCMD_Track.SearchTarget(self, time, deltaTime, creature)
				if nil ~= targetCreature then
					self.args[2] = targetCreature.data.id
				end
			end
		end
	end
end

local tempCreatureArray = {}
function SkillCMD_Track.SearchTarget(self, time, deltaTime, creature)
	local targetCreature = nil

	local skill = creature.skill
	local skillInfo = skill.info
	local launchRange = skillInfo:GetLaunchRange(creature)

	local teamFirst = skillInfo:TeamFirst(creature)
	local hatredFirst = creature:IsAutoBattleProtectingTeam() and skillInfo:TargetEnemy(creature)
	local searchRange = 40

	if hatredFirst then
		SkillLogic_Base.SearchTargetInRange(
			tempCreatureArray, 
			creature:GetPosition(), 
			searchRange, 
			skillInfo, 
			creature, 
			AutoBattle.TargetFilter, 
			SkillLogic_Base.SortComparator_HatredFirstDistance)
		targetCreature = tempCreatureArray[1]
		TableUtility.ArrayClear(tempCreatureArray)
		if nil == targetCreature or not targetCreature:IsHatred() then
			local autoBattleLockTarget, lockID = creature.ai:SearchAutoBattleLockTarget(
				creature, 
				skillInfo)
			if nil ~= autoBattleLockTarget then
				targetCreature = autoBattleLockTarget
			end
		end
	elseif teamFirst then
		SkillLogic_Base.SearchTargetInRange(
			tempCreatureArray, 
			creature:GetPosition(), 
			searchRange, 
			skillInfo, 
			creature, 
			AutoBattle.TargetFilter, 
			SkillLogic_Base.SortComparator_TeamFirstDistance)
		targetCreature = tempCreatureArray[1]
		TableUtility.ArrayClear(tempCreatureArray)
		if nil == targetCreature or not targetCreature:IsInMyTeam() then
			local autoBattleLockTarget, lockID = creature.ai:SearchAutoBattleLockTarget(
				creature, 
				skillInfo)
			if nil ~= autoBattleLockTarget then
				targetCreature = autoBattleLockTarget
			end
		end
	else
		local autoBattleLockTarget, lockID = creature.ai:SearchAutoBattleLockTarget(
			creature, 
			skillInfo)
		if nil ~= autoBattleLockTarget then
			targetCreature = autoBattleLockTarget
		else
			SkillLogic_Base.SearchTargetInRange(
				tempCreatureArray, 
				creature:GetPosition(), 
				searchRange, 
				skillInfo, 
				creature, 
				AutoBattle.TargetFilter, 
				SkillLogic_Base.SortComparator_Distance)
			targetCreature = tempCreatureArray[1]
			TableUtility.ArrayClear(tempCreatureArray)
		end
	end

	if nil ~= targetCreature then
		creature:Client_LockTarget(targetCreature)
	end
	return targetCreature
end
-- SkillCMD_Track end

-- SkillCMD_Run begin
function SkillCMD_Run.Start(self, time, deltaTime, creature, targetCreature)
	return AI_CMD_Myself_Skill_Run.Start(
		self, time, deltaTime, creature, 
		targetCreature, 
		targetCreature:GetPosition(),
		self.args[7])
end
-- SkillCMD_Run end

return SkillCMD