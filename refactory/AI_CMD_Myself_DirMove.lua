AI_CMD_Myself_DirMove = {}

-- Args = {
-- 	[1] = AI_CMD_Myself_DirMove,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = dir, -- LuaVector3
-- 	[2] = ignoreNavMesh, -- bool or nil
-- }

local NotifyServerInterval = 0.3
local NotifyServerDistance = 0.5
local nextNotifyTime = 0
local prevNotifyPosition = LuaVector3.zero

local tempVector3 = LuaVector3.zero

function AI_CMD_Myself_DirMove.Construct(self, args)
	self.args[1] = args[2]:Clone()
	self.args[2] = args[3]
	self.args[3] = LuaVector3.zero -- step target
	self.args[4] = LuaVector3.zero -- rotate dir
	return 4
end

function AI_CMD_Myself_DirMove.Deconstruct(self)
	self.args[1]:Destroy()
	self.args[3]:Destroy()
	self.args[4]:Destroy()

	self.args[1] = nil
	self.args[3] = nil
	self.args[4] = nil
end

function AI_CMD_Myself_DirMove.TryRestart(self, args, creature)
	local p = args[2]
	self.args[1]:Set(p[1], p[2], p[3])
	self.args[2] = args[3]
	if not self.running then
		return true
	end
	return AI_CMD_Myself_DirMove.Start(self, time, deltaTime, creature)
end

function AI_CMD_Myself_DirMove.Start(self, time, deltaTime, creature)
	if creature.data:NoMove() then
		self:SetKeepAlive(true)
		return false
	end

	AI_CMD_Myself_DirMove._Step(self, time, deltaTime, creature)
	creature:Logic_PlayAction_Move()
	return true
end

function AI_CMD_Myself_DirMove.End(self, time, deltaTime, creature)
	creature:Logic_StopMove()
end

function AI_CMD_Myself_DirMove.Update(self, time, deltaTime, creature)
	if creature.data:NoMove() then
		self:End(time, deltaTime, creature)
		self:SetKeepAlive(true)
		return
	end

	if nil ~= creature.logicTransform.targetPosition then
		if not self.args[2] then
			creature:Logic_SamplePosition(time)
		end
	else
		AI_CMD_Myself_DirMove._Step(self, time, deltaTime, creature)
	end

	-- notify server
	AI_CMD_Myself_DirMove._NotifyServer(self, time, deltaTime, creature)
end

function AI_CMD_Myself_DirMove._Step(self, time, deltaTime, creature)
	local p = creature:GetPosition()
	local ret,_ = NavMeshUtility.Better_RaycastDirection(p, self.args[3], self.args[1])
	if not ret then
		ret,_ = NavMeshUtility.Better_SampleDirection(p, self.args[3], self.args[1])
	end
	if not ret then
		-- fix bad position
		NavMeshUtility.Better_Sample(p, tempVector3)
		creature.logicTransform:PlaceTo(tempVector3)
	end
	LuaVector3.Better_Add(p, self.args[1], self.args[4])
	creature.logicTransform:MoveTo(self.args[3], self.args[4])
end

function AI_CMD_Myself_DirMove._NotifyServer(self, time, deltaTime, creature)
	if time > nextNotifyTime then
		local p = creature:GetPosition()
		if LuaVector3.Distance(prevNotifyPosition, p) > NotifyServerDistance then
			nextNotifyTime = time + NotifyServerInterval
			prevNotifyPosition:Set(p[1], p[2], p[3])
			creature:Client_MoveHandler(p)
		end
	end
end

function AI_CMD_Myself_DirMove.ToString()
	return "AI_CMD_Myself_DirMove",AI_CMD_Myself_DirMove
end