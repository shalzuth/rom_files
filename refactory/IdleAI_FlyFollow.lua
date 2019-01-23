IdleAI_FlyFollow = class("IdleAI_FlyFollow")

local Phase_None = 0
local Phase_Follow = 1
local Phase_Idle = 2

local RotateInterval = 0.5

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero

function IdleAI_FlyFollow:ctor()
	self.phase = Phase_None
	self.dampVelocity = nil
	self.nextRotateTime = 0
end

function IdleAI_FlyFollow:Clear(idleElapsed, time, deltaTime, creature)
	self.phase = Phase_None
	if nil ~= self.dampVelocity then
		self.dampVelocity:Destroy()
		self.dampVelocity = nil
	end
	if nil ~= self.prevPosition then
		self.prevPosition:Destroy()
		self.prevPosition = nil
	end
end

function IdleAI_FlyFollow:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= creature.ai.parent then
		return false
	end
	return true
end

function IdleAI_FlyFollow:Start(idleElapsed, time, deltaTime, creature)
	self.closeFollow = (2 == creature.data:GetFollowType())
	self:_Follow(idleElapsed, time, deltaTime, creature)
end

function IdleAI_FlyFollow:End(idleElapsed, time, deltaTime, creature)
	self.phase = Phase_None
	if nil ~= self.dampVelocity then
		self.dampVelocity:Destroy()
		self.dampVelocity = nil
	end
	self.nextRotateTime = 0
end

function IdleAI_FlyFollow:Update(idleElapsed, time, deltaTime, creature)

	local currentPosition = creature:GetPosition()
	if nil == currentPosition then
		self:_Idle(idleElapsed, time, deltaTime, creature)
		return true
	end

	local targetCreature = creature:Logic_GetFollowTarget()
	if nil == targetCreature then
		self:_Idle(idleElapsed, time, deltaTime, creature)
		return true
	end

	local targetPosition = targetCreature:GetPosition()
	if nil == targetPosition then
		self:_Idle(idleElapsed, time, deltaTime, creature)
		return true
	end

	local creatureData = creature.data

	local followPosition = tempVector3
	local followEP = creatureData:GetFollowEP()
	local epTransform = targetCreature.assetRole:GetEPOrRoot(followEP)
	followPosition:Set(LuaGameObject.GetPosition(epTransform))

	local height = math.abs(currentPosition[2] - followPosition[2])
	local outterHeight = creatureData:GetOutterHeight()
	local distance = nil
	local innerRange = nil
	if outterHeight > (height-outterHeight*0.1) then
		distance = VectorUtility.DistanceXZ(currentPosition, followPosition)
		innerRange = creatureData:GetInnerRange()
		if innerRange > (distance-innerRange*0.1) then
			self:_Idle(idleElapsed, time, deltaTime, creature)
			return true
		end

		if creatureData:GetOutterRange() < distance then
			self:_Follow(idleElapsed, time, deltaTime, creature)
		end
	else
		self:_Follow(idleElapsed, time, deltaTime, creature)
	end
	if Phase_Follow == self.phase then
		-- helplog("Follow", height, distance)
		if nil ~= self.dampVelocity then
			LuaVector3.Better_SmoothDamp(
				currentPosition, 
				followPosition, 
				tempVector3_1,
				self.dampVelocity,
				creatureData:GetDampDuration()
				-- 9999999999,
				-- deltaTime
				)
			creature.logicTransform:PlaceTo(tempVector3_1)
		else
			local lerpT = nil
			if nil ~= distance then
				lerpT = 1-innerRange/distance
			else
				lerpT = 1-outterHeight/height
			end
			if nil ~= self.prevPosition then
				LuaVector3.Better_LerpUnclamped(
					currentPosition, 
					followPosition, 
					self.prevPosition,
					lerpT)
			else
				self.prevPosition = LuaVector3.LerpUnclamped(
					currentPosition, 
					followPosition, 
					lerpT)
			end
			creature.logicTransform:PlaceTo(self.prevPosition)
		end
		creature.logicTransform:RotateTo(followPosition)
	end
	return true
end

function IdleAI_FlyFollow:_Rotate(idleElapsed, time, deltaTime, creature)
	local targetCreature = creature:Logic_GetFollowTarget()
	if nil ~= targetCreature then
		if self.closeFollow then
			creature.logicTransform:RotateTo(targetCreature:GetPosition())
		else
			creature.logicTransform:SetTargetAngleY(targetCreature:GetAngleY())
		end
		self.nextRotateTime = time + RotateInterval
	end
end

function IdleAI_FlyFollow:_Follow(idleElapsed, time, deltaTime, creature)
	if Phase_Follow == self.phase then
		return
	end
	if self.closeFollow and 
		(nil == self.prevPosition 
			or LuaVector3.Equal(self.prevPosition, creature:GetPosition())) then
		if nil ~= self.dampVelocity then
			self.dampVelocity:Destroy()
			self.dampVelocity = nil
		end
	else
		if nil ~= self.dampVelocity then
			self.dampVelocity:Set(0,0,0)
		else
			self.dampVelocity = LuaVector3.zero
		end
	end
	self.phase = Phase_Follow
	creature:Logic_PlayAction_Move()
end

function IdleAI_FlyFollow:_Idle(idleElapsed, time, deltaTime, creature)
	if Phase_Idle == self.phase then
		if time > self.nextRotateTime then
			self:_Rotate(idleElapsed, time, deltaTime, creature)
		end
		return
	end

	if self.closeFollow then
		self.prevPosition = VectorUtility.Asign_3(self.prevPosition, creature:GetPosition())
	end

	self:_Rotate(idleElapsed, time, deltaTime, creature)

	self.phase = Phase_Idle
	creature:Logic_PlayAction_Idle()
end