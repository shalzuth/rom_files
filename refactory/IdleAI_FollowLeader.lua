
local MyselfIdleAI_HandInHand = class("MyselfIdleAI_HandInHand", IdleAI_HandInHand)

function MyselfIdleAI_HandInHand:ctor()
	MyselfIdleAI_HandInHand.super.ctor(self)
	self.running = false
	self.on = false
end

function MyselfIdleAI_HandInHand:Set(on)
	self.on = on
end

function MyselfIdleAI_HandInHand:Clear(idleElapsed, time, deltaTime, creature)
	MyselfIdleAI_HandInHand.super.Clear(self, idleElapsed, time, deltaTime, creature)
	self.running = false
end

function MyselfIdleAI_HandInHand:Prepare(idleElapsed, time, deltaTime, creature)
	return self.on and MyselfIdleAI_HandInHand.super.Prepare(self, idleElapsed, time, deltaTime, creature)
end

function MyselfIdleAI_HandInHand:Start(idleElapsed, time, deltaTime, creature)
	MyselfIdleAI_HandInHand.super.Start(self, idleElapsed, time, deltaTime, creature)
	self.running = true
end

function MyselfIdleAI_HandInHand:End(idleElapsed, time, deltaTime, creature)
	MyselfIdleAI_HandInHand.super.End(self, idleElapsed, time, deltaTime, creature)
	self.running = false
end


local MyselfIdleAI_DoubleAction = class("MyselfIdleAI_DoubleAction", IdleAI_DoubleAction);
function MyselfIdleAI_DoubleAction:ctor()
	MyselfIdleAI_DoubleAction.super.ctor(self)

	self.running = false
	self.on = false
end
function MyselfIdleAI_DoubleAction:Set(on)
	self.on = on
end
function MyselfIdleAI_DoubleAction:Start(idleElapsed, time, deltaTime, creature)
	MyselfIdleAI_DoubleAction.super.Start(self, idleElapsed, time, deltaTime, creature)

	self.running = true
end
function MyselfIdleAI_DoubleAction:Prepare(idleElapsed, time, deltaTime, creature)
	if(not self.on)then
		return false;
	end
	return MyselfIdleAI_DoubleAction.super.Prepare(self, idleElapsed, time, deltaTime, creature)
end
function MyselfIdleAI_DoubleAction:End(idleElapsed, time, deltaTime, creature)
	MyselfIdleAI_DoubleAction.super.End(self, idleElapsed, time, deltaTime, creature)

	self.running = false
end
function MyselfIdleAI_DoubleAction:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
	local connecting = MyselfIdleAI_DoubleAction.super._SwitchToConnecting(self, idleElapsed, time, deltaTime, creature, masterCreature)
	if(connecting)then
		helplog("MyselfIdleAI_DoubleAction Connecting!");
		creature:Logic_SetDoubleActionState(self.masterGUID, true)
	end
end
function MyselfIdleAI_DoubleAction:End(idleElapsed, time, deltaTime, creature)
	helplog("MyselfIdleAI_DoubleAction End!");
	creature:Logic_SetDoubleActionState(self.masterGUID, false)
	MyselfIdleAI_DoubleAction.super.End(self, idleElapsed, time, deltaTime, creature);
end



IdleAI_FollowLeader = class("IdleAI_FollowLeader")

FunctionFollowCaptainEvent = {
	StateChanged = "E_FunctionFollowCaptain_StateChanged"
}

local OffsetRange = 2
local InnerRange = 1
local DestinationValidRange = 5
local ReteleportTime = 0.5
local ReteleportDistance = 3

local CallFollowTransferCmdInterval = 1
local CallGoMapFollowUserCmdInterval = 1

local LeaderTargetValidDuration = 2

-- local tempVector3 = LuaVector3.zero

function IdleAI_FollowLeader:ctor()
	self.leaderID = 0
	self.autoBattleOn = false
	self.autoBattle = AutoBattle.new()
	self.prevUpdateTime = nil
	self.goFromMapID = nil
	self.goMapID = nil

	self.nextTimeCallFollowTransferCmd = 0
	self.nextTimeCallGoMapFollowUserCmd = 0

	-- local offsetLimit = OffsetRange / 2
	-- self.offset = LuaVector3.New(
	-- 	math.random(-offsetLimit, offsetLimit), 
	-- 	0, 
	-- 	math.random(-offsetLimit, offsetLimit))

	self.requestLeaderID = 0
	self.requestHandInHandOn = nil
	self.requestDoubleAction = nil
	self.requestMoveToMapID = nil
	self.requestMoveToMapPos = nil

	self.subAIManager = IdleAIManager.new()
	self.subAI_DoubleAction = MyselfIdleAI_DoubleAction.new();
	self.subAIManager:PushAI(self.subAI_DoubleAction);
	self.subAI_HandInHand = MyselfIdleAI_HandInHand.new()
	self.subAIManager:PushAI(self.subAI_HandInHand)

	self.exitPointDisable = false
	self.prevHandInHandRunning = false

	self.leaderTargetID = 0
	self.leaderTargetIDValidTime = 0

	self.delay = 0
end

function IdleAI_FollowLeader:_NotifyHandInHand(time, deltaTime, creature)
	if self.prevHandInHandRunning == self.subAI_HandInHand.running then
		return
	end
	self.prevHandInHandRunning = self.subAI_HandInHand.running
	creature:Logic_SetHandInHandState(self.leaderID, self.subAI_HandInHand.running)
end

function IdleAI_FollowLeader:_SetExitPointDisable(disable)
	if self.exitPointDisable == disable then
		return
	end
	self.exitPointDisable = disable
	Game.AreaTrigger_ExitPoint:SetDisable(disable)
end

function IdleAI_FollowLeader:Clear(idleElapsed, time, deltaTime, creature)
	self:ResetMoveCMD(nil)
	self:_ClearMoveToMap()
	self.requestLeaderID = 0
	self.requestHandInHandOn = nil
	self.requestDoubleAction = nil
	self:_SwitchLeader(0)

	self:_NotifyHandInHand(time, deltaTime, creature);

	self.subAIManager:Clear(idleElapsed, time, deltaTime, creature)
	self:_SetExitPointDisable(false)

	self.leaderTargetID = 0
	self.leaderTargetIDValidTime = 0

	self.delay = 0
end

function IdleAI_FollowLeader:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= creature.ai.parent then
		return false
	end
	-- if FunctionCameraEffect.Me():Bussy() then
	-- 	return false
	-- end
	local oldLeader = self.leaderID
	self:_SwitchLeader(self.requestLeaderID, self.requestIgnoreNotifyServer)
	if(nil ~= self.requestDoubleAction)then
		self.subAI_DoubleAction:Set(self.requestDoubleAction)
		self.requestDoubleAction = nil
	end
	local oldHandInHandOn = self.subAI_HandInHand.on
	if nil ~= self.requestHandInHandOn then
		self.subAI_HandInHand:Set(self.requestHandInHandOn)
		self.requestHandInHandOn = nil
	end
	if oldLeader ~= self.leaderID or oldHandInHandOn ~= self.subAI_HandInHand.on then
		EventManager.Me():DispatchEvent(FunctionFollowCaptainEvent.StateChanged, self)
	end
	return 0 ~= self.leaderID 
end

function IdleAI_FollowLeader:Start(idleElapsed, time, deltaTime, creature)
	if 0 < self.delay then
		self.delay = time+1
	end
end

function IdleAI_FollowLeader:End(idleElapsed, time, deltaTime, creature)
	self:ResetMoveCMD(nil)
	self:_ClearMoveToMap()

	self.subAIManager:Break(idleElapsed, time, deltaTime, creature)

	self:_NotifyHandInHand(time, deltaTime, creature);

	self:_SetExitPointDisable(false)

	if 1 ~= self.delay then
		self.delay = 0
	end
end

function IdleAI_FollowLeader:Update(idleElapsed, time, deltaTime, creature)
	if not TeamProxy.Instance:IHaveTeam() then
		self:Request_Set(0, true)
		return false
	end
	local myTeam = TeamProxy.Instance.myTeam
	local leader = myTeam:GetMemberByGuid(self.leaderID)
	if nil == leader or leader:IsOffline() then
		self:Request_Set(0, true)
		return false
	end

	if nil ~= self.prevUpdateTime then
		deltaTime = time - self.prevUpdateTime
	end
	self.prevUpdateTime = time

	if nil ~= self.requestMoveToMapID then
		local mapID = self.requestMoveToMapID
		local pos = self.requestMoveToMapPos
		self.requestMoveToMapID = nil
		self.requestMoveToMapPos = nil
		self:MoveToMap(mapID, pos)
		if nil ~= pos then
			pos:Destroy()
		end
		if nil == self.moveCMD then
			self:Request_Set(0)
			return false
		end
	end
	if self:Follow(time, deltaTime, creature) then
		self.subAIManager:Break(idleElapsed, time, deltaTime, creature)
		self:_SetExitPointDisable(false)
	else
		self:_SetExitPointDisable(true)
		self.subAIManager:Update(idleElapsed, time, deltaTime, creature)
	end

	self:_NotifyHandInHand(time, deltaTime, creature);
	return true
end

local tempMissionCommandArgs = {}
function IdleAI_FollowLeader:MoveToMap(mapID, pos)
	if 0 == self.leaderID or 0 == mapID then
		return
	end

	tempMissionCommandArgs.targetMapID = mapID
	tempMissionCommandArgs.targetPos = pos
	tempMissionCommandArgs.customType = AccessCustomType.Follow
	local cmd = MissionCommandFactory.CreateCommand(
		tempMissionCommandArgs, 
		MissionCommandMove)
	TableUtility.TableClear(tempMissionCommandArgs)
	self:ResetMoveCMD(cmd)
	self.moveFromMap = Game.MapManager:GetMapID()
	self.moveToMap = mapID
	if nil ~= pos then
		self.moveToPos = VectorUtility.Asign_3(self.moveToPos, pos)
	else
		if nil ~= self.moveToPos then
			self.moveToPos:Destroy()
			self.moveToPos = nil
		end
	end
end

function IdleAI_FollowLeader:ResetMoveCMD(cmd)
	if nil ~= self.moveCMD then
		self.moveCMD:Shutdown()
		self.moveCMD:Destroy()
	end
	self.moveCMD = cmd
	if nil ~= self.moveCMD then
		self.moveCMD:Launch()
	end
end

function IdleAI_FollowLeader:Attack(creature, targetCreature)
	if nil ~= targetCreature then
		return self.autoBattle:Attack(creature, targetCreature)
	else
		-- onlyNoTargetAutoCast
		return self.autoBattle:Attack(creature, targetCreature, nil, true)
	end
end

function IdleAI_FollowLeader:DoCallGoMap(fromMapID, mapID, userID, time)
	if time > self.nextTimeCallGoMapFollowUserCmd then
		self.nextTimeCallGoMapFollowUserCmd = time+CallGoMapFollowUserCmdInterval

		ServiceNUserProxy.Instance:CallGoMapFollowUserCmd(mapID, userID)

		self.goFromMapID = fromMapID
		self.goMapID = mapID
		self:ResetMoveCMD(nil)
	end
end

function IdleAI_FollowLeader:TryCallGoMap(leader, time, deltaTime)
	local currentMapID = Game.MapManager:GetMapID()

	local leaderMapID = leader.mapid
	if leaderMapID ~= currentMapID then
		if leaderMapID ~= self.goMapID and nil ~= leaderMapID and 0 ~= leaderMapID then
			self:DoCallGoMap(currentMapID, leaderMapID, leader.id, time)
			return true
		end
		return false
	end

	self.goFromMapID = nil
	self.goMapID = nil

	return false
end

function IdleAI_FollowLeader:TryAttack(time, myTeam, leader, creature)
	if not self.autoBattleOn then
		return false
	end

	local targetCreature = nil
	local teamTargetID = 0
	-- if nil ~= leader.targetid and 0 ~= leader.targetid then
	-- 	teamTargetID = leader.targetid
	-- elseif nil ~= myTeam.target and 0 ~= myTeam.target then
	-- 	teamTargetID = myTeam.target
	-- end
	if nil ~= self.leaderTargetID and 0 ~= self.leaderTargetID then
		if time < self.leaderTargetIDValidTime then
			teamTargetID = self.leaderTargetID
		else
			self.leaderTargetID = 0
			self.leaderTargetIDValidTime = 0
		end
	end

	if 0 ~= teamTargetID then
		targetCreature = SceneCreatureProxy.FindCreature(teamTargetID)
	end	

	-- LogUtility.InfoFormat("<color=yellow>TryAttack: </color>{0}, {1}", 
	-- 	teamTargetID, targetCreature and targetCreature.data:GetName() or "nil")

	return self:Attack(creature, targetCreature)
end

function IdleAI_FollowLeader:Follow(time, deltaTime, creature)
	local myTeam = TeamProxy.Instance.myTeam
	local leader = myTeam:GetMemberByGuid(self.leaderID)

	-- LogUtility.InfoFormat("<color=yellow>Follow: </color>{0}, {1}", leader.mapid, leader.pos)
	if self:TryCallGoMap(leader, time, deltaTime) then
		return true
	end

	if nil ~= self.goMapID then
		-- not same map
		if 0 < self.delay then
			if time < self.delay then
				return true
			else
				self.delay = 0
			end
		end
		
		local currentMapID = Game.MapManager:GetMapID()
		if nil ~= self.moveCMD then
			
			if self.moveFromMap ~= currentMapID then
				-- reteleport
				self:MoveToMap(self.moveToMap)
			else
				self.moveCMD:Update(time, deltaTime)
				if not self.moveCMD.running then
					self:ResetMoveCMD(nil)
				else
					if not creature:IsMoving() 
						and ReteleportTime < deltaTime then
						-- reteleport
						self:MoveToMap(self.moveToMap)
					end
				end
			end
		else
			if self.goFromMapID ~= currentMapID then
				-- not the same from map
				self.goFromMapID = nil
				self.goMapID = nil
			elseif nil ~= self.moveToMap then
				self:MoveToMap(self.moveToMap)
			end
		end
		return true
	end

	-- same map
	if self:TryAttack(time, myTeam, leader, creature) then
		self:ResetMoveCMD(nil)
		return true
	end

	if 0 < self.delay then
		if time < self.delay then
			return true
		else
			self.delay = 0
		end
	end

	-- print(string.format("<color=red>FunctionFollowCaptain:Follow Move</color>"))
	if nil ~= self.subAIManager.currentAI then
		-- use sub AI
		return false
	end

	local leaderPos = leader.pos
	local leaderCreature = SceneCreatureProxy.FindCreature(leader.id)
	if nil ~= leaderCreature then
		leaderPos = leaderCreature:GetPosition()
	end
	-- local followPos = tempVector3
	-- LuaVector3.Better_Add(leaderPos, self.offset, followPos)
	local followPos = leaderPos

	if nil == self.moveToPos 
		or ReteleportDistance < VectorUtility.DistanceXZ(self.moveToPos, followPos) then
		-- reteleport
		self:MoveToMap(nil, followPos)
		if nil == self.moveCMD then
			self:Request_Set(0)
			return true
		end
	end

	if nil ~= self.moveCMD then
		self.moveCMD:Update(time, deltaTime)
	end
	
	local myPosition = creature:GetPosition()

	local distance = VectorUtility.DistanceXZ(followPos, myPosition)
	if OffsetRange < distance then
		if nil ~= self.moveCMD then
			if not self.moveCMD.running then
				self:ResetMoveCMD(nil)
				-- 玩家位置过远 请求传送过去
				-- if time > self.nextTimeCallFollowTransferCmd then
				-- 	self.nextTimeCallFollowTransferCmd = time+CallFollowTransferCmdInterval
				-- 	ServiceNUserProxy.Instance:CallFollowTransferCmd(leader.id)
				-- end
			end
		else
			-- teleport
			if time > self.nextTimeCallFollowTransferCmd then
				self.nextTimeCallFollowTransferCmd = time+CallFollowTransferCmdInterval
				self:MoveToMap(nil, followPos)
				if nil == self.moveCMD then
					self:Request_Set(0)
					return true
				end
			end
		end
	else
		if InnerRange > distance then
			if nil ~= self.moveCMD then
				self:ResetMoveCMD(nil)
			end
			return false
		else
			if not (nil ~= self.moveCMD and self.moveCMD.running) then
				return false
			end
		end
	end
	return true
end

function IdleAI_FollowLeader:OnMemberOffline(event)
	if self.leaderID == event.data.id then
		self:Request_Set(0)
	end
end

function IdleAI_FollowLeader:OnExitedTeam(event)
	if(event.data == TeamProxy.ExitType.ServerExit)then
		self:Request_Set(0, true)
	end
end

function IdleAI_FollowLeader:_SwitchLeader(newLeaderID, ignoreNotifyServer)
	if self.leaderID == newLeaderID then
		return
	end
	self.leaderID = newLeaderID
	self.subAI_DoubleAction:Request_Set(newLeaderID);
	self.subAI_HandInHand:Request_Set(newLeaderID)

	if 0 ~= self.leaderID then
		-- start
		Game.AutoBattleManager:SetController(self)
		Game.AutoBattleManager:AutoBattleOn()

		local eventManager = EventManager.Me()
		eventManager:AddEventListener(TeamEvent.MemberOffline, self.OnMemberOffline, self)
		eventManager:AddEventListener(TeamEvent.ExitTeam, self.OnExitedTeam, self)
	else
		-- end
		self.autoBattle:Reset()
		Game.AutoBattleManager:ClearController(self, true)
		self:ResetMoveCMD(nil)
		self.prevUpdateTime = nil
		self.goFromMapID = nil
		self.goMapID = nil

		self.nextTimeCallFollowTransferCmd = 0
		self.nextTimeCallGoMapFollowUserCmd = 0

		local eventManager = EventManager.Me()
		eventManager:RemoveEventListener(TeamEvent.MemberOffline, self.OnMemberOffline, self)
		eventManager:RemoveEventListener(TeamEvent.ExitTeam, self.OnExitedTeam, self)
	   	
	   	if not ignoreNotifyServer then
			-- 给服务器发送取消跟随
	   		ServiceNUserProxy.Instance:CallFollowerUser(0)
	   	end
	end
end

function IdleAI_FollowLeader:_ClearMoveToMap()
	self.requestMoveToMapID = nil
	if nil ~= self.requestMoveToMapPos then
		self.requestMoveToMapPos:Destroy()
		self.requestMoveToMapPos = nil
	end
end

function IdleAI_FollowLeader:IsHandInHand()
	return self.subAI_HandInHand.on
end

-- control begin
function IdleAI_FollowLeader:Request_MoveToMap(mapID, pos)
	LogUtility.InfoFormat("<color=yellow>Follow Request_MoveToMap: </color>{0}, {1}", 
		mapID, pos)
	if 0 == mapID then
		self.requestMoveToMapID = nil
		return
	end
	self.requestMoveToMapID = mapID
	if nil ~= pos then
		self.requestMoveToMapPos = VectorUtility.TryAsign_3(self.requestMoveToMapPos, pos)
	else
		if nil ~= self.requestMoveToMapPos then
			self.requestMoveToMapPos:Destroy()
			self.requestMoveToMapPos = nil
		end
	end
end
function IdleAI_FollowLeader:Request_Set(leaderID, ignoreNotifyServer)
	LogUtility.InfoFormat("<color=yellow>Follow Request_Set: </color>{0}", 
		leaderID)
	self.requestLeaderID = leaderID
	self.requestIgnoreNotifyServer = ignoreNotifyServer
end
function IdleAI_FollowLeader:Request_SetDoubleAction(on)
	self.requestDoubleAction = on
end
function IdleAI_FollowLeader:Request_SetHandInHand(on)
	self.requestHandInHandOn = on
end
function IdleAI_FollowLeader:Request_SetHandInHandState(running)
	self.prevHandInHandRunning = running 
end
function IdleAI_FollowLeader:Request_RefreshLeaderTarget(guid, time)
	if 0 ~= guid then
		self.leaderTargetID = guid 
		self.leaderTargetIDValidTime = time+LeaderTargetValidDuration
	else
		self.leaderTargetID = 0 
		self.leaderTargetIDValidTime = 0
	end
end
function IdleAI_FollowLeader:Request_Delay()
	self.delay = 1
end

-- auto battle manager begin
function IdleAI_FollowLeader:AutoBattleOn()
	self.autoBattleOn = true
end

function IdleAI_FollowLeader:AutoBattleOff()
	self.autoBattleOn = false
end

function IdleAI_FollowLeader:AutoBattleLost()
	self:AutoBattleOff()
end
-- auto battle manager end
-- ocontrol end