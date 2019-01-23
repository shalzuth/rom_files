IdleAI_HandInHand = class("IdleAI_HandInHand")

local Phase_Idle = 0
local Phase_Follow = 1
local Phase_Connecting = 2
local Phase_Connected = 3

local HandInCP = RoleDefines_CP.LeftHand
local InHandCP = RoleDefines_CP.RightHand

local InnerRange = 1
local OutterRange = 2
local TargetValidDistance = 1
local ConnectDistance = 0.1
local ConnectingDuration = 0.3

local PlayActionIdleDelay = 0.3

local FindCreature = SceneCreatureProxy.FindCreature

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero
local tempVector3_2 = LuaVector3.zero

function IdleAI_HandInHand:ctor()
	self.phase = Phase_Idle
	self.targetPosition = nil
	self.connectingElapsed = 0
	self.masterGUID = 0
	self.requestMasterGUID = nil
	self.nextPlayActionIdleTime = 0
end

function IdleAI_HandInHand:Request_Set(guid)
	self.requestMasterGUID = guid
end

function IdleAI_HandInHand:Clear(idleElapsed, time, deltaTime, creature)
	local masterCreature = nil
	if 0 ~= self.masterGUID then
		masterCreature = FindCreature(self.masterGUID)
	end
	self:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature)
	self:_SwitchMaster(0, creature)
	self.connectingElapsed = 0
end

function IdleAI_HandInHand:Prepare(idleElapsed, time, deltaTime, creature)
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

function IdleAI_HandInHand:Start(idleElapsed, time, deltaTime, creature)
end

function IdleAI_HandInHand:End(idleElapsed, time, deltaTime, creature)
	local masterCreature = nil
	if 0 ~= self.masterGUID then
		masterCreature = FindCreature(self.masterGUID)
	end
	self:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature)
end

function IdleAI_HandInHand:Update(idleElapsed, time, deltaTime, creature)
	local masterCreature = FindCreature(self.masterGUID)

	if Phase_Idle == self.phase then
		self:_UpdateIdle(idleElapsed, time, deltaTime, creature, masterCreature)
	elseif Phase_Follow == self.phase then
		self:_UpdateFollow(idleElapsed, time, deltaTime, creature, masterCreature)
	elseif Phase_Connecting == self.phase then
		self:_UpdateConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
	elseif Phase_Connected == self.phase then
		self:_UpdateConnected(idleElapsed, time, deltaTime, creature, masterCreature)
	end
	return true
end

function IdleAI_HandInHand:_SwitchMaster(masterGUID, creature)
	local oldMasterGUID = self.masterGUID
	if oldMasterGUID == masterGUID then
		return
	end
	self.masterGUID = masterGUID
	if 0 ~= oldMasterGUID then
		local masterCreature = FindCreature(oldMasterGUID)
		if nil ~= masterCreature then
			masterCreature:ClearHandInHand()
		end
		Game.LogicManager_HandInHand:UnregisterHandInHand(
			masterCreature, 
			creature)
	end
	if 0 ~= masterGUID and Phase_Connected == self.phase then
		local masterCreature = FindCreature(masterGUID)
		Game.LogicManager_HandInHand:RegisterHandInHand(
			masterCreature, 
			creature)
	end
end

function IdleAI_HandInHand:_MoveTo(p, creature, masterCreature)
	if not creature.logicTransform:NavMeshMoveTo(p) then
		creature.logicTransform:MoveTo(p)
	end
	self.targetPosition = VectorUtility.Asign_3(self.targetPosition, p)
end

function IdleAI_HandInHand:_StopMove(creature, masterCreature, forceStop)
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

function IdleAI_HandInHand:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature, forceStop)
	if Phase_Idle == self.phase then
		return
	end
	local oldPhase = self.phase
	self.phase = Phase_Idle
	if nil ~= masterCreature then
		masterCreature:ClearHandInHand()
	end
	local needIdle = creature:IsPlayingInHandAction()
	creature:ClearHandInHand()
	self:_StopMove(creature, masterCreature, forceStop)

	if Phase_Connecting == oldPhase then
		creature:Logic_SamplePosition(0) -- force sample
		if needIdle then
			creature:Logic_PlayAction_Idle()
		end
	elseif Phase_Connected == oldPhase then
		creature:Logic_SamplePosition(0) -- force sample
		Game.LogicManager_HandInHand:UnregisterHandInHand(
			masterCreature, 
			creature)
		if needIdle then
			creature:Logic_PlayAction_Idle()
		end
	end

	LogUtility.InfoFormat("<color=yellow>HandInHand SwitchToIdle: </color>{0}", 
		creature.data and creature.data:GetName() or "No Name")
end
function IdleAI_HandInHand:_UpdateIdle(idleElapsed, time, deltaTime, creature, masterCreature)
	local masterPosition = masterCreature:GetPosition()
	local distance = VectorUtility.DistanceXZ(masterPosition, creature:GetPosition())
	if OutterRange < distance then
		self:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
		return
	end

	if masterCreature:IsReadyToHandIn(HandInCP) then
		if InnerRange < distance then
			self:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
		else
			if nil ~= creature.assetRole:GetCP(InHandCP) then
				self:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
			end
		end
	end
end

function IdleAI_HandInHand:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
	if Phase_Follow == self.phase then
		return
	end
	self.phase = Phase_Follow
	masterCreature:ClearHandInHand()
	creature:ClearHandInHand()
	creature:Logic_PlayAction_Move()

	LogUtility.InfoFormat("<color=yellow>HandInHand SwitchToFollow: </color>{0}", 
		creature.data and creature.data:GetName() or "No Name")
end
function IdleAI_HandInHand:_UpdateFollow(idleElapsed, time, deltaTime, creature, masterCreature)
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
		if masterCreature:IsReadyToHandIn(HandInCP) 
			and nil ~= creature.assetRole:GetCP(InHandCP) then
			self:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
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

function IdleAI_HandInHand:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
	if Phase_Connecting == self.phase then
		return
	end
	self.phase = Phase_Connecting
	self:_StopMove(creature, masterCreature)
	masterCreature:HandIn()
	creature:InHand()
	self.connectingElapsed = 0

	LogUtility.InfoFormat("<color=yellow>HandInHand SwitchToConnecting: </color>{0}", 
		creature.data and creature.data:GetName() or "No Name")
end
function IdleAI_HandInHand:_UpdateConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
	if masterCreature:IsPlayingHandInIdleAction() then
		creature:Logic_PlayAction_Idle()
	elseif masterCreature:IsPlayingHandInMoveAction() then
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

	local handInCPTransform = masterCreature.assetRole:GetCP(HandInCP)
	if nil == handInCPTransform then
		self:_SwitchToIdle(
			idleElapsed, 
			time, 
			deltaTime, 
			creature, 
			masterCreature,
			true)
		return
	end
	local inHandCPTransform = creature.assetRole:GetCP(InHandCP)
	if nil == inHandCPTransform then
		self:_SwitchToIdle(
			idleElapsed, 
			time, 
			deltaTime, 
			creature, 
			masterCreature,
			true)
		return
	end

	tempVector3:Set(LuaGameObject.GetPosition(handInCPTransform))
	tempVector3_1:Set(LuaGameObject.GetPosition(inHandCPTransform))
	if VectorUtility.DistanceXZ(tempVector3, tempVector3_1) <= ConnectDistance then
		creature.logicTransform:PlaceTo(tempVector3_2)
		self:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
		return
	end

	local currentPosition = creature:GetPosition()
	LuaVector3.Better_Sub(tempVector3, tempVector3_1, tempVector3_2)
	tempVector3_2:Add(currentPosition)

	local targetAngleY = masterCreature:GetAngleY()

	local masterScale = masterCreature:GetScaleVector()
	tempVector3_1:Set(masterScale[1],masterScale[2],masterScale[3])
	tempVector3_1:Mul(creature:GetDefaultScale())

	self.connectingElapsed = self.connectingElapsed + deltaTime
	if self.connectingElapsed < ConnectingDuration then
		local progress = self.connectingElapsed/ConnectingDuration
		LuaVector3.Better_LerpUnclamped(
			currentPosition, 
			tempVector3_2,
			tempVector3,
			progress)
		creature.logicTransform:PlaceTo(tempVector3)

		creature.logicTransform:SetAngleY(NumberUtility.LerpAngleUnclamped(
			creature:GetAngleY(), 
			targetAngleY, 
			progress))

		LuaVector3.Better_LerpUnclamped(
			creature:GetScaleVector(), 
			tempVector3_1,
			tempVector3,
			progress)
		creature.logicTransform:SetScaleXYZ(tempVector3[1],tempVector3[2],tempVector3[3])
	else
		creature.logicTransform:PlaceTo(tempVector3_2)
		creature.logicTransform:SetAngleY(targetAngleY)
		creature.logicTransform:SetScale(targetScale)
		self:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
	end
end

function IdleAI_HandInHand:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
	if Phase_Connected == self.phase then
		return
	end
	self.phase = Phase_Connected
	self:_StopMove(creature, masterCreature)
	masterCreature:HandIn()
	creature:InHand()
	self.nextPlayActionIdleTime = 0
	
	Game.LogicManager_HandInHand:RegisterHandInHand(
		masterCreature, 
		creature)

	LogUtility.InfoFormat("<color=yellow>HandInHand SwitchToConnected: </color>{0}", 
		creature.data and creature.data:GetName() or "No Name")
end
function IdleAI_HandInHand:_UpdateConnected(idleElapsed, time, deltaTime, creature, masterCreature)
	if masterCreature:IsPlayingHandInIdleAction() then
		if 0 < self.nextPlayActionIdleTime then
			if time > self.nextPlayActionIdleTime then
				creature:Logic_PlayAction_Idle()
			end
		else
			self.nextPlayActionIdleTime = time + PlayActionIdleDelay
		end
	elseif masterCreature:IsPlayingHandInMoveAction() then
		self.nextPlayActionIdleTime = 0
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

	local handInCPTransform = masterCreature.assetRole:GetCP(HandInCP)
	if nil == handInCPTransform then
		self:_SwitchToIdle(
			idleElapsed, 
			time, 
			deltaTime, 
			creature, 
			masterCreature,
			true)
		return
	end
	local inHandCPTransform = creature.assetRole:GetCP(InHandCP)
	if nil == inHandCPTransform then
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
