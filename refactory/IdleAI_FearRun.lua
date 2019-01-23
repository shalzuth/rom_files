IdleAI_FearRun = class("IdleAI_FearRun")

local FearRunIntervalRange = {1, 2}

local tempVector3 = LuaVector3.zero

function IdleAI_FearRun:ctor()
	self.nextFearRunTime = 0
	self.rotateDir = nil
	self.targetPosition = nil
end

function IdleAI_FearRun:Clear(idleElapsed, time, deltaTime, creature)
	if nil ~= self.rotateDir then
		self.rotateDir:Destroy()
		self.rotateDir = nil
	end
	if nil ~= self.targetPosition then
		self.targetPosition:Destroy()
		self.targetPosition = nil
	end
end

function IdleAI_FearRun:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= creature.ai.parent then
		return false
	end
	return not creature.data:NoMove() and creature.data:FearRun()
end

function IdleAI_FearRun:Start(idleElapsed, time, deltaTime, creature)
	creature:Logic_PlayAction_Move()
	self.rotateDir = LuaVector3.zero
	self.targetPosition = LuaVector3.zero
	self:_Step(idleElapsed, time, deltaTime, creature)
end

function IdleAI_FearRun:End(idleElapsed, time, deltaTime, creature)
	if nil ~= self.targetPosition then
		if nil ~= creature.logicTransform.targetPosition 
			and LuaVector3.Equal(self.targetPosition, creature.logicTransform.targetPosition ) then
			creature:Logic_StopMove()
		end
		self.targetPosition:Destroy()
		self.targetPosition = nil
	end

	if nil ~= self.rotateDir then
		self.rotateDir:Destroy()
		self.rotateDir = nil
	end
end

function IdleAI_FearRun:Update(idleElapsed, time, deltaTime, creature)
	if time < self.nextFearRunTime then
		creature:Logic_SamplePosition(time)
	else
		self:_Step(idleElapsed, time, deltaTime, creature)
	end
	return true
end

function IdleAI_FearRun:_Step(idleElapsed, time, deltaTime, creature)
	local p = creature:GetPosition()
	if nil == p then
		return
	end
	self.nextFearRunTime =  time + RandomUtil.Range(FearRunIntervalRange[1], FearRunIntervalRange[2])
	local dir = tempVector3
	dir[1], dir[3] = RandomUtil.RandomInCircle()
	dir[2] = 0

	local ret,_ = NavMeshUtility.Better_RaycastDirection(p, self.targetPosition, dir)
	if not ret then
		ret,_ = NavMeshUtility.Better_SampleDirection(p, self.targetPosition, dir)
	end
	if ret then
		LuaVector3.Better_Add(p, dir, self.rotateDir)
		creature:Logic_MoveTo(self.targetPosition, self.rotateDir)
	end
end