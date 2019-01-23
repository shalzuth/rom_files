
local SelfClass = class("SubSkill_EffectOneShotOnTerrain", ReusableObject)

SelfClass.PoolSize = 100

local tempVector3 = LuaVector3.zero

local tempArgs = {
	[1] = nil, -- effect_logic, 
	[2] = nil, -- effectPath, 
}

function SelfClass.GetArgs(params, creature, skillInfo)
	tempArgs[1] = params
	tempArgs[2] = skillInfo:GetEmitLogicEffectPath(creature)
	return tempArgs
end

function SelfClass.ClearArgs(args)
	TableUtility.ArrayClear(args)
end

function SelfClass.Create(args)
	return ReusableObject.Create( SelfClass, true, args )
end

function SelfClass:ctor()
	self.args = {}
end

function SelfClass:Update(effect, time, deltaTime)
	local args = self.args
	local logicParams = args[1]

	args[3] = args[3] + deltaTime
	if args[3] > logicParams.interval then
		local effectPosition = effect:GetLocalPosition()
		NavMeshUtility.Better_Sample(effectPosition, tempVector3)
		
		if 1 > VectorUtility.DistanceXZ(effectPosition, tempVector3) then
			-- play
			args[3] = 0

			tempVector3[1] = effectPosition[1]
			tempVector3[2] = effectPosition[2]

			local effect = Asset_Effect.PlayOneShotAt(args[2], tempVector3)
			if nil ~= logicParams.randomAxisY then
				local angleY = RandomUtil.Range(0, 360)
				effect:ResetLocalEulerAnglesXYZ(0, angleY, 0)
			end
		end
	end
end

-- override begin
function SelfClass:DoConstruct(asArray, args)
	self.args[1] = args[1]
	self.args[2] = args[2]
	self.args[3] = 0 -- elapsedTime
end

function SelfClass:DoDeconstruct(asArray)
	local args = self.args
	TableUtility.ArrayClear(args)
end
-- override end

return SelfClass