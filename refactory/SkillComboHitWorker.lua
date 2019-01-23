SkillComboHitWorker = class("SkillComboHitWorker", ReusableObject)

if not SkillComboHitWorker.SkillComboHitWorker_Inited then
	SkillComboHitWorker.SkillComboHitWorker_Inited = true
	SkillComboHitWorker.PoolSize = 200
end

local DamageType = CommonFun.DamageType

local FindCreature = SceneCreatureProxy.FindCreature
local ComboInterval = 0.2

local tempComboHitArgs = {
	[1] = nil, -- targetCreature
	[2] = DamageType.None, -- damageType
	[3] = 0, -- damage
	[4] = 0, -- count
	[5] = 0, -- hitEP
	[6] = false, -- noHit
	[7] = nil, -- sePath
	[8] = HurtNumType.DamageNum, -- labelType
	[9] = HurtNumColorType.Normal, -- labelColorType
	[10] = nil, -- comboDamageLabel
	[11] = nil, -- fromCreature
	[12] = true, -- allowEffect
	[13] = nil, -- skillInfo
}

function SkillComboHitWorker.GetArgs()
	return tempComboHitArgs
end

function SkillComboHitWorker.ClearArgs(args)
	args[1] = nil
	args[10] = nil
	args[11] = nil
	args[12] = true
	args[13] = nil
end

function SkillComboHitWorker.Create( args )
	return ReusableObject.Create( SkillComboHitWorker, true, args )
end

function SkillComboHitWorker:ctor()
	self.args = {}
end

function SkillComboHitWorker:Update(time, deltaTime)
	local args = self.args
	if time < args[15] then
		return
	end
	
	args[15] = time + ComboInterval

	local targetCreature = FindCreature(args[1])
	if nil ~= targetCreature then
		-- hit
		if not args[6] then
			targetCreature:Logic_Hit()
		end
		-- play se
		if self.args[12] and nil ~= args[7] then
			targetCreature.assetRole:PlaySEOneShotAt(args[7], args[5])
		end
	end
	
	if nil ~= args[10] then
		local damage = SkillLogic_Base.GetSplitDamage(
			args[3], args[14], args[4])

		-- show single damage
		SkillLogic_Base.ShowDamage_Single(
			args[2], 
			damage, 
			args[16], 
			args[8], 
			args[9], 
			targetCreature,
			args[13])

		-- show combo damage
		self.args[10]:Show(damage, args[17])
	end

	if args[14] >= args[4] then -- index >= count
		self:Destroy()
	else
		self.args[14] = self.args[14] + 1
	end
end

-- override begin
function SkillComboHitWorker:DoConstruct(asArray, args)
	local creature = args[11]
	local targetCreature = args[1]
	targetCreature.ai:SetDieBlocker(self)
	TableUtility.ArrayShallowCopyWithCount(self.args, args, 13)
	self.args[1] = targetCreature.data.id
	self.args[11] = creature and creature.data.id or 0

	-- comboDamageLabel
	if self.args[12] then -- allowEffect
		if nil == self.args[10] then
			self.args[10] = SceneUIManager.Instance:GetStaticHurtLabelWorker()
		end
		self.args[10]:AddRef()
	else
		self.args[10] = nil
	end

	self.args[14] = 1 -- index
	self.args[15] = 0 -- nextUpdateTime

	-- position
	local targetAssetRole = targetCreature.assetRole
	local epTransform = targetAssetRole:GetEPOrRoot(args[5]) -- hitEP
	self.args[16] = LuaVector3.New(LuaGameObject.GetPosition(epTransform))
	epTransform = targetAssetRole:GetEPOrRoot(RoleDefines_EP.Top) -- comboHitEP
	self.args[17] = LuaVector3.New(LuaGameObject.GetPosition(epTransform))
end

function SkillComboHitWorker:DoDeconstruct(asArray)
	local args = self.args

	local targetCreature = FindCreature(args[1])
	if nil ~= targetCreature then
		targetCreature.ai:ClearDieBlocker(self)
	end

	if nil ~= args[10] then
		args[10]:SubRef()
	end
	args[16]:Destroy()
	args[17]:Destroy()

	args[10] = nil
	args[13] = nil
	args[16] = nil
	args[17] = nil
end
-- override end