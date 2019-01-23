EffectWorker_Connect = class("EffectWorker_Connect", ReusableObject)

local FindCreature = SceneCreatureProxy.FindCreature

local tempVector3 = LuaVector3.zero

EffectWorker_Connect.EffectType = 1;

-- Args = ID

function EffectWorker_Connect.Create( ID )
	return ReusableObject.Create( EffectWorker_Connect, true, ID )
end

function EffectWorker_Connect:ctor()
	self.guid2 = 0
	self.performData = nil
	self.effect = nil
end

function EffectWorker_Connect:SetArgs(args, creature)
	self.guid2 = args[1]
	self.duration = args[2]
end

function EffectWorker_Connect:Update(time, deltaTime, creature1)
	local creature2 = FindCreature(self.guid2)
	if nil == creature2 or true == creature2.assetRole:GetInvisible() then
		self:_DestroyEffect()
		return
	end
	self:_CreateEffect()
	if nil == self.lineRender then
		self.lineRender = self.effect:GetComponent(LineRenderer)
		if nil == self.lineRender then
			return
		end
	end

	if self.duration ~= nil then
		if self.elapseTime == nil then
			self.elapseTime = 0
		end
		self.elapseTime = self.elapseTime + deltaTime

		if self.elapseTime >= self.duration then
			self.elapseTime = nil
			return false
		end
	end

	local transform1 = creature1.assetRole:GetEPOrRoot(self.performData.ep1)
	local transform2 = creature2.assetRole:GetEPOrRoot(self.performData.ep2)
	self.lineRender.positionCount = 2
	tempVector3:Set(LuaGameObject.GetPosition(transform1))
	self.lineRender:SetPosition(0, tempVector3)
	tempVector3:Set(LuaGameObject.GetPosition(transform2))
	self.lineRender:SetPosition(1, tempVector3)
end

function EffectWorker_Connect:_CreateEffect()
	if nil ~= self.effect then
		return
	end
	self.effect = Asset_Effect.PlayAt(self.performData.effect, LuaGeometry.Const_V3_zero)
end

function EffectWorker_Connect:_DestroyEffect()
	if nil == self.effect then
		return
	end
	local oldEffect = self.effect
	self.effect = nil
	self.lineRender = nil
	oldEffect:Destroy()
end

-- override begin
function EffectWorker_Connect:DoConstruct(asArray, ID)
	self.performData = Table_SpEffect[ID].Perform
	self.guid2 = 0
	self.effect = nil
	self.lineRender = nil
end

function EffectWorker_Connect:DoDeconstruct(asArray)
	if nil ~= self.effect then
		self.effect:Destroy()
		self.effect = nil
	end
	self.lineRender = nil
	self.performData = nil
	self.duration = nil
	self.elapseTime = nil
end
-- override end