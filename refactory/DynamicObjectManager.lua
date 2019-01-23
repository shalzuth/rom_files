
-- Table_SceneInteractionObject = {
-- 	[1] = {id=1, ResetDelay=1, ResetAnimation="state2001", CD=1}
-- }

local PlayActionCrossFadeDuration = 0.3

DynamicObject = class("DynamicObject", ReusableObject)

if not DynamicObject.DynamicObject_inited then
	DynamicObject.DynamicObject_inited = true
	DynamicObject.PoolSize = 20
end

local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayClear = TableUtility.ArrayClear
local ArrayClearWithCount = TableUtility.ArrayClearWithCount
local VectorDistanceXZ = VectorUtility.DistanceXZ

local tempTriggerIndex = 0
local tempPlayerCount = 0
local function TriggerCheck(creature, self)
	local p1 = creature:GetPosition()
	local p2 = self.triggerPositions[tempTriggerIndex]
	if VectorDistanceXZ(p1, p2) < self.triggerSizes[tempTriggerIndex] then
		tempPlayerCount = tempPlayerCount + 1
	end
end

function DynamicObject.Create( objData )
	return ReusableObject.Create( DynamicObject, true, objData )
end

function DynamicObject:ctor()
	self.ID = nil
	self.staticData = nil

	self.triggerCount = 0
	self.triggerActions = {}
	self.triggerPositions = {}
	self.triggerSizes = {}
	self.triggerPlayerCounts = {}
	self.triggerTags = {}
	self.animators = {}

	self.activeTriggerIndex = 0

	self.CDLeft = 0
	self.resetLeft = 0
end

function DynamicObject:PlayAction(actionName)
	if nil == actionName or "" == actionName then
		return
	end
	local animators = self.animators
	for i=1, #animators do
		animators[i]:CrossFade(actionName, PlayActionCrossFadeDuration)
	end
end

function DynamicObject:StartReset()
	local resetDelay = self.staticData.ResetDelay
	if nil ~= resetDelay and 0 < resetDelay then
		self.resetLeft = resetDelay
	else
		self:DoReset()
	end
end

function DynamicObject:DoReset()
	self.resetLeft = 0
	local resetAnimation = self.staticData.ResetAnimation
	if nil == resetAnimation or "" == resetAnimation then
		self:PlayAction(resetAnimation)
	end
	self.activeTriggerIndex = 0
end

function DynamicObject:StopReset()
	self.resetLeft = 0
end

function DynamicObject:SetActiveTrigger(newActiveTriggerIndex)
	if 0 < self.CDLeft then
		return
	end
	self.activeTriggerIndex = newActiveTriggerIndex
	self:PlayAction(self.triggerActions[newActiveTriggerIndex])
	self.CDLeft = self.staticData.CD or 0
end

function DynamicObject:Update(time, deltaTime)
	-- 0. update CDLeft and ResetLeft
	if 0 < self.CDLeft then
		self.CDLeft = self.CDLeft - deltaTime
		if 0 > self.CDLeft then
			self.CDLeft = 0
		end
	end

	local oldResetLeft = self.resetLeft
	if 0 < self.resetLeft then
		self.resetLeft = self.resetLeft - deltaTime
		if 0 > self.resetLeft then
			self.resetLeft = 0
		end
	end

	local triggerCount = self.triggerCount

	local newActiveTriggerIndex = 0

	local myself = Game.Myself
	-- 1. triggers
	for i=1, triggerCount do
		tempTriggerIndex = i
		TriggerCheck(myself, self)
		NSceneUserProxy.Instance:ForEach(TriggerCheck, self)
		if self.triggerPlayerCounts[i] ~= tempPlayerCount then
			self.triggerPlayerCounts[i] = tempPlayerCount
			self.triggerTags[i] = tempPlayerCount
			if 0 < tempPlayerCount then
				newActiveTriggerIndex = i
			end
		end
		tempPlayerCount = 0
	end
	tempTriggerIndex = 0

	-- 2. states
	if 0 < self.activeTriggerIndex then
		local activeTriggerTag = self.triggerTags[self.activeTriggerIndex]
		if nil ~= activeTriggerTag then
			if 0 < activeTriggerTag then
				self:StopReset()
			else
				self:StartReset()
			end
		end
	else
		if 0 < newActiveTriggerIndex then
			self:SetActiveTrigger(newActiveTriggerIndex)
		end
	end

	-- 3.
	ArrayClearWithCount(self.triggerTags, triggerCount)

	if 0 < oldResetLeft and 0 >= self.resetLeft then
		self:DoReset()
	end
end

-- override begin
function DynamicObject:DoConstruct(asArray, objData)
	local staticID = tonumber(objData:GetProperty(0))
	self.staticData = Table_SceneInteractionObject[staticID]
	if nil == self.staticData then
		LogUtility.DebugErrorFormat(objData, "Table_SceneInteractionObject[{0}] is nil", staticID)
	end

	self.ID = objData.ID
	local triggerCount = tonumber(objData:GetProperty(1))
	if 0 < triggerCount then
		for i=1, triggerCount do
			ArrayPushBack(self.triggerActions, objData:GetProperty(i+1))
			local transform = objData:GetComponentProperty(i-1)
			ArrayPushBack(self.triggerPositions, LuaVector3.New(LuaGameObject.GetPosition(transform)))
			local size = LuaGameObject.GetLocalScale(transform)
			ArrayPushBack(self.triggerSizes, size)
		end
	end
	
	local i = triggerCount
	local animator = objData:GetComponentProperty(i)
	if nil ~= animator then
		repeat
			ArrayPushBack(self.animators, animator)
			i = i+1
			animator = objData:GetComponentProperty(i)
		until nil == animator
	end
	self.triggerCount = triggerCount
end

function DynamicObject:DoDeconstruct(asArray)
	self.staticData = nil
	local triggerCount = self.triggerCount
	self.triggerCount = 0
	ArrayClearWithCount(self.triggerActions, triggerCount)
	for i=1, triggerCount do
		self.triggerPositions[i]:Destroy()
		self.triggerPositions[i] = nil
	end
	ArrayClearWithCount(self.triggerSizes, triggerCount)
	ArrayClearWithCount(self.triggerPlayerCounts, triggerCount)
	ArrayClearWithCount(self.triggerTags, triggerCount)
	ArrayClear(self.animators)

	self.activeTriggerIndex = 0
	self.CDLeft = 0
	self.resetLeft = 0
end
-- override end

DynamicObjectManager = class("DynamicObjectManager")

local UpdateInterval = 0.1

local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayClear = TableUtility.ArrayClear

function DynamicObjectManager:ctor()
	self.objs = {}
	self.objCount = 0
end

function DynamicObjectManager:SetDynamicData(objID, objData)
	-- helplog("SetDynamicData", objID, objData)
	local oldObj = self.objs[objID]
	if nil ~= oldObj then
		oldObj:Destroy()
		self.objs[objID] = nil
		self.objCount = self.objCount - 1
	end
	if nil ~= objData then
		self.objs[objID] = DynamicObject.Create(objData)
		self.objCount = self.objCount + 1
	end
end

function DynamicObjectManager:Clear()
	for k,v in pairs(self.objs) do
		v:Destroy()
		self.objs[k] = nil
	end
	self.objCount = 0
end

function DynamicObjectManager:Launch()
	if self.running then
		return
	end
	self.running = true

	self.nextUpdateTime = 0
	self.eatenDeltaTime = 0
end

function DynamicObjectManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false

	self:Clear()
end

function DynamicObjectManager:Update(time, deltaTime)
	if not self.running then
		return
	end

	if time < self.nextUpdateTime then
		self.eatenDeltaTime = self.eatenDeltaTime + deltaTime
		return
	end
	deltaTime = deltaTime + self.eatenDeltaTime
	self.eatenDeltaTime = 0
	self.nextUpdateTime = time + UpdateInterval

	if 0 < self.objCount then
		for k,v in pairs(self.objs) do
			v:Update(time, deltaTime)
		end
	end
end