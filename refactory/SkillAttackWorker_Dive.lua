
local SelfClass = class("SkillAttackWorker_Dive", ReusableObject)

SelfClass.PoolSize = 100

local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.zero
local tempVector2 = LuaVector2.zero
local tempVector2_1 = LuaVector2.zero

-- LogicParams = {
-- 	action,
-- 	initSpeed,
-- 	acceleration,
-- 	speedLimit,
-- 	over_distance
-- }

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
	creature.logicTransform:LookAt(targetCreature:GetPosition())

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

	-- play SE
	local sePath = skillInfo:GetAttackSEPath(creature)
	if nil ~= sePath then
		assetRole:PlaySEOneShotAt(sePath, attackEP)
	end

	args[2] = targetGUID
	args[3] = logicParams.initSpeed
	args[4] = logicParams.acceleration
	args[5] = logicParams.speedLimit

	args[6] = LuaVector3.zero
	args[7] = LuaVector3.zero
	args[8] = LuaVector3.zero

	args[9] = false -- over

	return true
end

function SelfClass:End(skill, creature)
	
end

function SelfClass:Update(skill, time, deltaTime, creature)
	local args = self.args
	local logicParams = args[1]

	local targetGUID = args[2]
	local targetCreature = FindCreature(targetGUID)
	if nil == targetCreature then
		return false
	end

	local currentPosition = creature:GetPosition()
	local targetPosition = targetCreature:GetPosition()

	local p0 = args[6]
	local p1 = args[7]
	local p2 = args[8]

	if not args[9] then
		-- not over
		creature.logicTransform:LookAt(targetPosition)
		
		p0:Set(currentPosition[1], currentPosition[2], currentPosition[3])
		p1:Set(targetPosition[1], targetPosition[2], targetPosition[3])

		VectorUtility.SubXZ_2(p1, p0, tempVector2)
		LuaVector2.Normalized(tempVector2)
		
		tempVector2:Mul(logicParams.over_distance)
		tempVector2[1] = p1[1]+tempVector2[1]
		tempVector2[2] = p1[3]+tempVector2[2]
		p2:Set(tempVector2[1], p1[2], tempVector2[2])
	end

	-- bezier nextPosition
	VectorUtility.SetXZ_2(p0, tempVector2)
	VectorUtility.SetXZ_2(p2, tempVector2_1)
	local distanceXZ = LuaVector2.Distance(tempVector2, tempVector2_1)

	local deltaDistance = args[3] * deltaTime
	VectorUtility.Better_MoveTowardsXZ_2(
		currentPosition, 
		p2, 
		tempVector2, 
		deltaDistance)

	VectorUtility.SetXZ_2(p0, tempVector2_1)
	
	local movedDistanceXZ = LuaVector2.Distance(tempVector2, tempVector2_1)
	local progress = NumberUtility.Clamp01(movedDistanceXZ/distanceXZ)
	VectorUtility.Better_Bezier(p0, p1, p2, tempVector3, progress)
	
	VectorUtility.SetXZ_3(tempVector2, tempVector3)
	creature.logicTransform:PlaceTo(tempVector3)
	currentPosition = creature:GetPosition()

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

	if not args[9] then
		local restDistance = VectorUtility.DistanceXZ(currentPosition, p2)
		if restDistance <= logicParams.over_distance then
			args[9] = true
			args[4] = -args[3]*args[3] / (2*restDistance)
			args[5] = 0
			-- hit
			local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(
				skill, 
				creature, 
				skill.phaseData, 
				creature.assetRole, 
				skill.info)
			hitWorker:Work(1, 1)
			hitWorker:Destroy()
		end
	else
		if 0 >= args[3] 
			or VectorUtility.DistanceXZ(currentPosition, p1) >= logicParams.over_distance then
			return false
		end
	end
	return true
end

-- override begin
function SelfClass:DoConstruct(asArray, args)
	self.args[1] = args
end

function SelfClass:DoDeconstruct(asArray)
	local args = self.args
	if nil ~= args[6] then
		args[6]:Destroy()
	end
	if nil ~= args[7] then
		args[7]:Destroy()
	end
	if nil ~= args[8] then
		args[8]:Destroy()
	end
	TableUtility.ArrayClearWithCount(args, 9)
end
-- override end

return SelfClass