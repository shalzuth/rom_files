
local SelfClass = class("SkillAttackWorker_MissileFrom", ReusableObject)

SelfClass.PoolSize = 100

local FindCreature = SceneCreatureProxy.FindCreature

local StartFactor = {0,0}
local ControlFactor = {2,5.0}

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero

-- LogicParams = {
-- 	action,
-- 	duration,
-- 	over_duration,
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

	local bezPos0 = LuaVector3.zero
	local hitEP = skillInfo:GetHitEP(creature)
	bezPos0:Set(LuaGameObject.GetPosition(targetCreature.assetRole:GetEPOrRoot(hitEP)))
	args[2] = bezPos0
	local bezPos1 = bezPos0:Clone()
	args[3] = bezPos1
	local endPosition = creature:GetPosition():Clone()
	args[4] = endPosition
	args[5] = 0
	assetRole:SetShadowEnable(false)

	-- init bezier
	local dirEulerAngles = tempVector3
	LuaVector3.Better_Sub(endPosition, bezPos0, dirEulerAngles)
	LuaVector3.Normalized(dirEulerAngles)

	LuaVector3.Better_Mul(dirEulerAngles, StartFactor[1], tempVector3_1)
	tempVector3_1[2] = tempVector3_1[2] + StartFactor[2]
	bezPos0:Add(tempVector3_1)

	LuaVector3.Better_Mul(dirEulerAngles, ControlFactor[1], tempVector3_1)
	tempVector3_1[2] = tempVector3_1[2] + ControlFactor[2]
	bezPos1:Add(tempVector3_1)

	creature.logicTransform:PlaceTo(bezPos0)

	-- play action
	local playActionParams = Asset_Role.GetPlayActionParams(logicParams.action)
	playActionParams[6] = true -- force
	creature:Logic_PlayAction(playActionParams)
	return true
end

function SelfClass:End(skill, creature)
	creature.logicTransform:PlaceTo(self.args[4])
	creature.assetRole:SetShadowEnable(true)
end

function SelfClass:Update(skill, time, deltaTime, creature)
	local args = self.args
	local logicParams = args[1]

	local over = args[5] >= logicParams.duration
	args[5] = args[5] + deltaTime

	if over then
		return args[5] < logicParams.duration+logicParams.over_duration
	else
		local t = args[5] / logicParams.duration
		if 1 < t then
			t = 1
		end
		t = t*t -- acceleration lerp
		VectorUtility.Better_Bezier(
			args[2], 
			args[3], 
			args[4], 
			tempVector3, 
			t)
		creature.logicTransform:LookAt(tempVector3)
		creature.logicTransform:PlaceTo(tempVector3)
		if 1 <= t then
			creature.assetRole:SetShadowEnable(true)
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
	if nil ~= args[2] then
		args[2]:Destroy()
	end
	if nil ~= args[3] then
		args[3]:Destroy()
	end
	if nil ~= args[4] then
		args[4]:Destroy()
	end
	TableUtility.ArrayClearWithCount(args, 5)
end
-- override end

return SelfClass