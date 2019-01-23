
AI_CMD_Myself_MoveToHelper = {}
setmetatable(AI_CMD_Myself_MoveToHelper, {__index = AI_CMD_MoveToHelper})

function AI_CMD_Myself_MoveToHelper.Start(self, time, deltaTime, creature, p, ignoreNavMesh)
	if creature.data:NoMove() then
		self:SetKeepAlive(true)
		return false
	end
	return AI_CMD_MoveToHelper.Start(self, time, deltaTime, creature, p, ignoreNavMesh)
end

-- return arrived
function AI_CMD_Myself_MoveToHelper.Update(self, time, deltaTime, creature, ignoreNavMesh)
	if creature.data:NoMove() then
		self:End(time, deltaTime, creature)
		self:SetKeepAlive(true)
		return false
	end
	return AI_CMD_MoveToHelper.Update(self, time, deltaTime, creature, ignoreNavMesh)
end

local Helper = AI_CMD_Myself_MoveToHelper

AI_CMD_Myself_MoveTo = {}

-- Args = {
-- 	[1] = AI_CMD_Myself_MoveTo,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = position, -- LuaVector3
-- 	[2] = ignoreNavMesh, -- bool or nil
-- 	[3] = callback
-- 	[4] = callbackOwner
-- 	[5] = callbackCustom
-- 	[6] = range -- number or nil
-- }

function AI_CMD_Myself_MoveTo.Construct(self, args)
	self.args[1] = args[2]:Clone()
	self.args[2] = args[3]
	self.args[3] = args[4]
	self.args[4] = args[5]
	self.args[5] = args[6]
	self.args[6] = args[7]
	return 6
end

function AI_CMD_Myself_MoveTo.Deconstruct(self)
	self.args[1]:Destroy()
	self.args[1] = nil
	self.args[3] = nil
	self.args[4] = nil
	self.args[5] = nil
	self.args[6] = nil
end

function AI_CMD_Myself_MoveTo.Start(self, time, deltaTime, creature)
	if creature.data:NoMove() then
		self:SetKeepAlive(true)
		return false
	end
	local ret = Helper.Start(
		self, time, deltaTime, creature, 
		self.args[1],
		self.args[2],
		self.args[6])
	if ret then
		Game.ClickGroundEffectManager:SetPos(creature.logicTransform.targetPosition)
	end
	return ret
end

function AI_CMD_Myself_MoveTo.End(self, time, deltaTime, creature)
	Game.ClickGroundEffectManager:HideEffect()
	Helper.End(self, time, deltaTime, creature)
end

function AI_CMD_Myself_MoveTo.Update(self, time, deltaTime, creature)
	if creature.data:NoMove() then
		self:End(time, deltaTime, creature)
		self:SetKeepAlive(true)
		return
	end
	if Helper.Update(
		self, time, deltaTime, creature, 
		self.args[2],
		self.args[6]) then
		-- arrived
		if nil ~= self.args[3] then
			self.args[3](self.args[4], self.args[5])
			self.args[3] = nil
			self.args[4] = nil
			self.args[5] = nil
		end
	end
end

function AI_CMD_Myself_MoveTo.ToString()
	return "AI_CMD_Myself_MoveTo",AI_CMD_Myself_MoveTo
end