
local SelfClass = class("SkillAttackWorker_Dash", ReusableObject)

SelfClass.PoolSize = 100

local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero

local AttackActionMaxLength = 3

-- LogicParams = {
-- 	action,
-- 	initSpeed,
-- 	acceleration,
-- 	speedLimit,
-- }

local waitForActionWorkerArray = {}
local function WorkerFindPredicate(worker, workerInstanceID)
	return worker.instanceID == workerInstanceID
end
local function OnActionFinished(creatureGUID, workerInstanceID)
	local worker, i = TableUtility.ArrayFindByPredicate(
		waitForActionWorkerArray, 
		WorkerFindPredicate, 
		workerInstanceID)
	if nil ~= worker then
		worker.args[6] = 0 -- action finished
	end
end

function SelfClass.Create(args)
	return ReusableObject.Create( SelfClass, true, args )
end

function SelfClass:ctor()
	self.args = {}
end

function SelfClass:Start(skill, creature)
	local phaseData = skill.phaseData
	if 0 >= phaseData:GetTargetCount() then
		return false
	end
	local targetGUID = phaseData:GetTarget(1)
	local targetCreature = FindCreature(targetGUID)
	if nil == targetCreature then
		return false
	end

	local args = self.args
	local logicParams = args[1]
	local assetRole = creature.assetRole
	local skillInfo = skill.info

	-- look at target
	local targetPosition = nil
	if 1 == logicParams.no_track then
		targetPosition = phaseData:GetPosition()
		if nil == targetPosition then
			targetPosition = targetCreature:GetPosition()
			phaseData:SetPosition(targetPosition)
		end
	else
		targetPosition = targetCreature:GetPosition()
	end
	creature.logicTransform:LookAt(targetPosition)

	-- play action
	local playActionParams = Asset_Role.GetPlayActionParams(logicParams.action)
	playActionParams[6] = true -- force
	creature:Logic_PlayAction(playActionParams)

	local attackEP = skillInfo:GetAttackEP(creature)
	-- play effect
	local effectPath = skillInfo:GetAttackEffectPath(creature)
	if nil ~= effectPath then
		local effect = nil
		if skillInfo:AttackEffectOnRole(creature) then
			effect = assetRole:PlayEffectOneShotOn( effectPath, attackEP )
		else
			effect = assetRole:PlayEffectOneShotAt( effectPath, attackEP )
			effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
		end
	end
	effectPath = skillInfo:GetPreAttackEffectPath(creature)
	if nil ~= effectPath then
		local effect = assetRole:PlayEffectOn( effectPath, skillInfo:GetPreAttackEffectEP(creature) )
		skill:AddEffect(effect)
	end

	-- play SE
	local sePath = skillInfo:GetAttackSEPath(creature)
	if nil ~= sePath then
		assetRole:PlaySEOneShotAt(sePath, attackEP)
	end

	args[2] = targetGUID
	args[3] = logicParams.initSpeed
	args[4] = logicParams.acceleration
	args[5] = logicParams.speedLimit

	args[6] = -1 -- wait for attack action time flag

	return true
end

function SelfClass:End(skill, creature)
	
end

function SelfClass:Update(skill, time, deltaTime, creature)
	local args = self.args
	if 0 <= args[6] then
		return time < args[6]
	end

	local logicParams = args[1]

	local targetGUID = args[2]
	local targetCreature = FindCreature(targetGUID)
	if nil == targetCreature then
		return false
	end

	local currentPosition = creature:GetPosition()
	local targetPosition = nil
	if 1 == logicParams.no_track then
		targetPosition = skill.phaseData:GetPosition()
		if nil == targetPosition then
			targetPosition = targetCreature:GetPosition()
		end
	else
		targetPosition = targetCreature:GetPosition()
	end

	local deltaDistance = args[3] * deltaTime
	LuaVector3.Better_Sub(targetPosition, currentPosition, tempVector3)
	LuaVector3.Normalized(tempVector3)

	local distance = LuaVector3.Distance(currentPosition, targetPosition)
	if deltaDistance >= distance then
		-- end
		args[6] = time+AttackActionMaxLength
		deltaDistance = distance
	end

	tempVector3:Mul(deltaDistance)
	
	LuaVector3.Better_Add(
		currentPosition, 
		tempVector3, 
		tempVector3_1)

	creature.logicTransform:PlaceTo(tempVector3_1)
	currentPosition = creature:GetPosition()

	if 0 < args[6] then
		local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(
			skill, 
			creature, 
			skill.phaseData, 
			creature.assetRole, 
			skill.info)
		hitWorker:Work(1, 1)
		hitWorker:Destroy()

		local actionPlayed = false

		local assetRole = creature.assetRole
		local actionName = skill.info:GetAttackAction(creature)
		if nil ~= actionName and assetRole:HasActionRaw(actionName) then
			local playActionParams = Asset_Role.GetPlayActionParams(actionName)
			playActionParams[6] = true -- force
			playActionParams[7] = OnActionFinished
			playActionParams[8] = self.instanceID
			actionPlayed = creature:Logic_PlayAction(playActionParams)
			if actionPlayed then
				TableUtility.ArrayPushBack(waitForActionWorkerArray, self)
			end
			Asset_Role.ClearPlayActionParams(playActionParams)
		end

		return actionPlayed
	else
		-- update speed
		local minSpeed = args[3]
		local maxSpeed = args[5]
		if minSpeed > maxSpeed then
			local tempSpeed = minSpeed
			minSpeed = maxSpeed
			maxSpeed = tempSpeed
		end
		local newSpeed = args[3] + args[4] * deltaTime
		args[3] = NumberUtility.Clamp(newSpeed, minSpeed, maxSpeed)
	end
	return true
end

-- override begin
function SelfClass:DoConstruct(asArray, args)
	self.args[1] = args
end

function SelfClass:DoDeconstruct(asArray)
	TableUtility.ArrayRemove(waitForActionWorkerArray, self)
	TableUtility.ArrayClearWithCount(self.args, 7)
end
-- override end

return SelfClass