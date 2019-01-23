
SubSkillProjectile = class("SubSkillProjectile", ReusableObject)

if not SubSkillProjectile.SubSkillProjectile_Inited then
	SubSkillProjectile.SubSkillProjectile_Inited = true
	SubSkillProjectile.PoolSize = 100
end

local ProjectileAIClass = {
	[1] = autoImport("SubSkill_StraightLine"),
	[2] = autoImport("SubSkill_Missile"),
	[3] = autoImport("SubSkill_Cyclotron"),
}

local ProjectileEffectLogic = {
	[1] = autoImport("SubSkill_EffectOneShotOnTerrain"),
}

local tempVector3 = LuaVector3.zero
local FindCreature = SceneCreatureProxy.FindCreature

local tempArgs = {
	[1] = nil, -- AIClass, 
	[2] = nil, -- emitParams, 
	[3] = nil, -- hitWorker, 
	[4] = nil, -- forceSingleDamage, 
	[5] = nil, -- startPosition,
	[6] = nil, -- endPosition,
	[7] = 1, -- emitIndex,
	[8] = 1, -- emitCount,
}

function SubSkillProjectile.GetArgs(emitParams, hitWorker, forceSingleDamage, startPosition, endPosition, emitIndex, emitCount)
	tempArgs[1] = ProjectileAIClass[emitParams.type]
	tempArgs[2] = emitParams
	tempArgs[3] = hitWorker
	tempArgs[4] = forceSingleDamage
	tempArgs[5] = startPosition
	tempArgs[6] = endPosition
	tempArgs[7] = emitIndex
	tempArgs[8] = emitCount
	return tempArgs
end

function SubSkillProjectile.ClearArgs(args)
	TableUtility.ArrayClear(args)
end

function SubSkillProjectile.Create(args)
	return ReusableObject.Create( SubSkillProjectile, true, args )
end

function SubSkillProjectile:ctor()
	self.args = {}
end

function SubSkillProjectile:Update(time, deltaTime)
	local args = self.args
	if not args[10] then
		self:_End()
		return
	end

	local endPosition, refreshed = self:GetEndPosition()
	if nil == endPosition then
		self:_End()
		return
	end

	if args[1].Update(self, endPosition, refreshed, time, deltaTime) then
		if nil ~= args[11] then
			args[11]:Update(args[8], time, deltaTime)
		end
	else
		self:_End()
	end
end

function SubSkillProjectile:GetEndPosition()
	local args = self.args
	local endPosition = args[5]
	if nil == endPosition then
		local hitWorker = args[3]
		local targetGUID = hitWorker:GetTarget(1)
		local targetCreature = FindCreature(targetGUID)
		if nil ~= targetCreature then
			local hitEPTransform = targetCreature.assetRole:GetEPOrRoot(args[9])
			tempVector3:Set(LuaGameObject.GetPosition(hitEPTransform))
			endPosition = tempVector3
			return endPosition, true
		end
	end
	return endPosition, false
end

function SubSkillProjectile:Hit(endPosition)
	local args = self.args
	local effect = args[8]
	local hitWorker = args[3]
	local fromPosition = effect:GetLocalPosition()

	local creature = FindCreature(hitWorker:GetFromGUID())
	local skillInfo = hitWorker:GetSkillInfo(creature)
	if SkillTargetType.Point == skillInfo:GetTargetType(creature) then
		local effectPath = skillInfo:GetFirePointEffectPath(creature)
		if nil ~= effectPath then
			Asset_Effect.PlayOneShotAt(effectPath, endPosition)
		end
	end

	hitWorker:SetFromPosition(fromPosition)
	hitWorker:Work(args[6], args[7], args[4])
	-- self:Destroy()
end

function SubSkillProjectile:_Start(creature, skillInfo)
	local args = self.args
	if args[10] then
		return
	end
	local endPosition,_ = self:GetEndPosition()
	if nil == endPosition then
		return
	end

	local effect = args[8]
	local startPosition = effect:GetLocalPosition()
	if 0.5 > LuaVector3.Distance(startPosition, endPosition) then
		-- too near
		self:Hit(endPosition)
		self:Destroy()
		return
	end

	args[10] = args[1].Start(self, endPosition) -- running
	if args[10] then
		-- effect_logic
		local emitParams = args[2]
		local effect_logic = emitParams.effect_logic
		if nil ~= effect_logic then
			local effectLogicClass = ProjectileEffectLogic[effect_logic.type]
			local effectLogicArgs = effectLogicClass.GetArgs(effect_logic, creature, skillInfo)
			args[11] = effectLogicClass.Create(effectLogicArgs)
			effectLogicClass.ClearArgs(effectLogicArgs)
		end
	end
end

function SubSkillProjectile:_End()
	if not self.args[10] then
		return
	end
	self.args[1].End(self)
	self:Destroy()
end

-- override begin
function SubSkillProjectile:DoConstruct(asArray, args)
	self.args[1] = args[1]
	self.args[2] = args[2]
	self.args[3] = args[3]
	self.args[4] = args[4]
	self.args[5] = VectorUtility.TryAsign_3(self.args[5], args[6]) -- endPosition
	self.args[6] = args[7] -- emitIndex
	self.args[7] = args[8] -- emitCount

	local hitWorker = self.args[3]
	local startPosition = args[5]

	hitWorker:AddRef()
	hitWorker:Delay()

	local creature = FindCreature(hitWorker:GetFromGUID())
	local skillInfo = hitWorker:GetSkillInfo()

	local effectPath = skillInfo:GetEmitEffectPath(creature)
	self.args[8] = Asset_Effect.PlayAt(effectPath, startPosition) -- effect
	self.args[9] = skillInfo:GetHitEP(creature) -- hit epID

	self:_Start(creature, skillInfo)
end

function SubSkillProjectile:DoDeconstruct(asArray)
	local args = self.args
	args[1].Deconstruct(self)
	args[3]:SubRef()

	if nil ~= args[5] then
		args[5]:Destroy()
	end

	if nil ~= args[8] then
		args[8]:Destroy()
	end

	if nil ~= args[11] then
		args[11]:Destroy()
	end
	TableUtility.ArrayClearWithCount(args, 11)
end
-- override end