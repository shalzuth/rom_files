
local MoveToHelper = AI_CMD_Myself_MoveToHelper

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

function SkillCMD.Start(self, time, deltaTime, creature)
	local args = self.args
	if nil == args[3] then
		return false
	end

	local skill = creature.skill
	local skillInfo = skill.info
	local launchRange = 0
	if not args[8] then 
		launchRange = skillInfo:GetLaunchRange(creature)
	end

	if 0 < launchRange then
		local currentPosition = creature:GetPosition()
		if VectorUtility.DistanceXZ(currentPosition, args[3]) > launchRange then
			if creature:IsAutoBattleStanding() then
				creature:Client_ClearAutoBattleCurrentTarget()
				return false
			end
			-- track
			if SkillCMD_Track.Start(
				self, time, deltaTime, creature) then
				phaseCMD = SkillCMD_Track
				return true
			else
				return false
			end
		end
	end

	-- launch
	if SkillCMD_Run.Start(
		self, time, deltaTime, creature) then
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
	end
end

function SkillCMD.Update(self, time, deltaTime, creature)
	phaseCMD.Update(self, time, deltaTime, creature)
end

function SkillCMD_Track.Start(self, time, deltaTime, creature)
	if MoveToHelper.Start(
		self, time, deltaTime, creature,
		self.args[3], self.args[4]) then
		self:SetInterruptLevel(2)
		return true
	end
	return false
end

function SkillCMD_Track.End(self, time, deltaTime, creature)
	MoveToHelper.End(self, time, deltaTime, creature)
end

function SkillCMD_Track.Update(self, time, deltaTime, creature)
	local currentPosition = creature:GetPosition()
	local skill = creature.skill
	local skillInfo = skill.info
	local launchRange = skillInfo:GetLaunchRange(creature)
	if VectorUtility.DistanceXZ(currentPosition, self.args[3]) < launchRange then
		-- arrived
		nextPhaseCMD = SkillCMD_Run
		self:End(time, deltaTime, creature)
		return
	else
		if creature:IsAutoBattleStanding() then
			creature:Client_ClearAutoBattleCurrentTarget()
			self:End(time, deltaTime, creature)
			return
		end
	end
	MoveToHelper.Update(self, time, deltaTime, creature)
end
-- SkillCMD_Track end

-- SkillCMD_Run begin
function SkillCMD_Run.Start(self, time, deltaTime, creature)
	return AI_CMD_Myself_Skill_Run.Start(
		self, time, deltaTime, creature, 
		nil, 
		self.args[3],
		self.args[7])
end
-- SkillCMD_Run end

return SkillCMD