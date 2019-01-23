IdleAI_BeHolded = class("IdleAI_BeHolded")

-- NCreature new function:
-- ClearHold
-- ClearBeHolded
-- IsPlayingHoldIdleAction
-- IsPlayingHoldMoveAction
-- IsPlayingBeHoldedAction
-- IsReadyToHold
-- Hold
-- BeHolded

local Phase_Idle = 0
local Phase_Follow = 1
local Phase_Connected = 2

local HoldCP = RoleDefines_CP.RightHand

local InnerRange = 1
local OutterRange = 2
local TargetValidDistance = 1
local ConnectDistance = 0.1

local FindCreature = SceneCreatureProxy.FindCreature

function IdleAI_BeHolded:ctor()
	self.phase = Phase_Idle
	self.targetPosition = nil
	self.masterGUID = 0
	self.requestMasterGUID = nil
	self.scale = 1
	self.angleY = 0
	self.offset = LuaVector3.zero
end

function IdleAI_BeHolded:Request_Set(guid, scale, angleY, offset)
	self.requestMasterGUID = guid
	self.scale = scale or 1
	self.angleY = angleY or 0
	if nil ~= offset and 3 <= #offset then
		self.offset:Set(offset[1], offset[2], offset[3])
	else
		self.offset:Set(0,0,0)
	end
end

function IdleAI_BeHolded:Clear(idleElapsed, time, deltaTime, creature)
	local masterCreature = nil
	if 0 ~= self.masterGUID then
		masterCreature = FindCreature(self.masterGUID)
	end
	self:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature)
	self:_SwitchMaster(0, creature)
	self.scale = 1
end

function IdleAI_BeHolded:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= self.requestMasterGUID then
		self:_SwitchMaster(self.requestMasterGUID, creature)
		self.requestMasterGUID = nil
	end
	if 0 == self.masterGUID then
		return false
	end
	local masterCreature = FindCreature(self.masterGUID)
	return nil ~= masterCreature
end

function IdleAI_BeHolded:Start(idleElapsed, time, deltaTime, creature)
end

function IdleAI_BeHolded:End(idleElapsed, time, deltaTime, creature)
	local masterCreature = nil
	if 0 ~= self.masterGUID then
		masterCreature = FindCreature(self.masterGUID)
	end
	self:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature)
end

function IdleAI_BeHolded:Update(idleElapsed, time, deltaTime, creature)
	local masterCreature = FindCreature(self.masterGUID)

	if Phase_Idle == self.phase then
		self:_UpdateIdle(idleElapsed, time, deltaTime, creature, masterCreature)
	elseif Phase_Follow == self.phase then
		self:_UpdateFollow(idleElapsed, time, deltaTime, creature, masterCreature)
	elseif Phase_Connected == self.phase then
		self:_UpdateConnected(idleElapsed, time, deltaTime, creature, masterCreature)
	end
	return true
end

function IdleAI_BeHolded:_SwitchMaster(masterGUID, creature)
	local oldMasterGUID = self.masterGUID
	if oldMasterGUID == masterGUID then
		return
	end
	self.masterGUID = masterGUID
	if 0 ~= oldMasterGUID then
		local masterCreature = FindCreature(oldMasterGUID)
		if nil ~= masterCreature then
			masterCreature:ClearHold()
		end
	end
	if 0 ~= masterGUID and Phase_Connected == self.phase then
		local masterCreature = FindCreature(masterGUID)
		if nil ~= masterCreature and masterCreature:IsReadyToHold(HoldCP) then
			masterCreature:Hold()
			self:Connect(masterCreature, creature)
		end
	end
end

function IdleAI_BeHolded:_MoveTo(p, creature, masterCreature)
	if not creature.logicTransform:NavMeshMoveTo(p) then
		creature.logicTransform:MoveTo(p)
	end
	self.targetPosition = VectorUtility.Asign_3(self.targetPosition, p)
end

function IdleAI_BeHolded:_StopMove(creature, masterCreature, forceStop)
	if forceStop 
		or (nil ~= self.targetPosition 
			and nil ~= creature.logicTransform.targetPosition
			and LuaVector3.Equal(self.targetPosition, creature.logicTransform.targetPosition)) then
		creature.logicTransform:StopMove()
		creature:Logic_PlayAction_Idle()
	end
	if nil ~= self.targetPosition then
		self.targetPosition:Destroy()
		self.targetPosition = nil
	end
end

function IdleAI_BeHolded:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature, forceStop)
	if Phase_Idle == self.phase then
		return
	end
	local oldPhase = self.phase
	self.phase = Phase_Idle
	if nil ~= masterCreature then
		masterCreature:ClearHold()
	end
	local needIdle = creature:IsPlayingBeHoldedAction()
	creature:ClearBeHolded()
	self:_StopMove(creature, masterCreature, forceStop)

	if Phase_Connected == oldPhase then
		creature:Logic_SamplePosition(0) -- force sample
		if needIdle then
			creature:Logic_PlayAction_Idle()
		end
		self:Break(masterCreature, creature)
	end

	LogUtility.InfoFormat("<color=yellow>BeHolded SwitchToIdle: </color>{0}", 
		creature.data and creature.data:GetName() or "No Name")
end
function IdleAI_BeHolded:_UpdateIdle(idleElapsed, time, deltaTime, creature, masterCreature)
	local masterPosition = masterCreature:GetPosition()
	local distance = VectorUtility.DistanceXZ(masterPosition, creature:GetPosition())
	if OutterRange < distance then
		self:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
		return
	end

	if masterCreature:IsReadyToHold(HoldCP) then
		if InnerRange < distance then
			self:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
		else
			self:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
		end
	end
end

function IdleAI_BeHolded:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
	if Phase_Follow == self.phase then
		return
	end
	self.phase = Phase_Follow
	masterCreature:ClearHold()
	creature:ClearBeHolded()
	creature:Logic_PlayAction_Move()
	self:Break(masterCreature, creature)

	LogUtility.InfoFormat("<color=yellow>BeHolded SwitchToFollow: </color>{0}", 
		creature.data and creature.data:GetName() or "No Name")
end
function IdleAI_BeHolded:_UpdateFollow(idleElapsed, time, deltaTime, creature, masterCreature)
	local masterPosition = masterCreature:GetPosition()
	local distance = VectorUtility.DistanceXZ(masterPosition, creature:GetPosition())
	if InnerRange < distance then
		local logicTransform = creature.logicTransform
		local prevTargetPosition = logicTransform.targetPosition 
		if nil == prevTargetPosition then
			self:_MoveTo(masterPosition, creature, masterCreature)
		elseif VectorUtility.DistanceXZ(masterPosition, prevTargetPosition) > TargetValidDistance then
			self:_MoveTo(masterPosition, creature, masterCreature)
		end
		creature:Logic_SamplePosition(time)
	else
		if masterCreature:IsReadyToHold(HoldCP)  then
			self:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
		else
			self:_SwitchToIdle(
				idleElapsed, 
				time, 
				deltaTime, 
				creature, 
				masterCreature,
				true)
		end
	end
end

function IdleAI_BeHolded:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
	if Phase_Connected == self.phase then
		return
	end
	self.phase = Phase_Connected
	self:_StopMove(creature, masterCreature)
	masterCreature:Hold()
	creature:BeHolded()
	self:Connect(masterCreature, creature)

	LogUtility.InfoFormat("<color=yellow>BeHolded SwitchToConnected: </color>{0}", 
		creature.data and creature.data:GetName() or "No Name")
end
function IdleAI_BeHolded:_UpdateConnected(idleElapsed, time, deltaTime, creature, masterCreature)
	if masterCreature:IsPlayingHoldIdleAction() then
		creature:Logic_PlayAction_Idle()
	elseif masterCreature:IsPlayingHoldMoveAction() then
		creature:Logic_PlayAction_Move()
	else
		self:_SwitchToIdle(
			idleElapsed, 
			time, 
			deltaTime, 
			creature, 
			masterCreature,
			true)
		return
	end

	local holdCPTransform = masterCreature.assetRole:GetCP(HoldCP)
	if nil == holdCPTransform then
		self:_SwitchToIdle(
			idleElapsed, 
			time, 
			deltaTime, 
			creature, 
			masterCreature,
			true)
		return
	end
end

function IdleAI_BeHolded:Connect(masterCreature, creature)
	if nil ~= masterCreature then
		local holdCPTransform = masterCreature.assetRole:GetCP(HoldCP)
		if nil ~= holdCPTransform then
			creature:SetParent(holdCPTransform)
			creature.assetRole:SetShadowEnable(false)
			creature.assetRole:SetPosition(self.offset)
			creature.logicTransform:ScaleTo(self.scale)
			creature.logicTransform:SetTargetAngleY(self.angleY)
		end
	end
end

function IdleAI_BeHolded:Break(masterCreature, creature)
	creature:SetParent(nil)
	creature.assetRole:SetShadowEnable(true)
	creature.logicTransform:ScaleToXYZ(creature:GetScaleWithFixHW())
end
