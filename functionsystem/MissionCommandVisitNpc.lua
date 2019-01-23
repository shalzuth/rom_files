MissionCommandVisitNpc = class("MissionCommandVisitNpc", MissionCommand)

MissionCommandVisitNpc.TRIGGER_RANGE = 3

-- Args = {
-- 	targetMapID,
-- 	realTargetMapID,
-- 	teleportMapID,
-- 	targetBPID,
-- 	targetPos,

-- 	npcID,
-- 	npcUID,
-- 	distance,

-- 	custom,
-- 	customDeleter,
-- 	customType,
-- }

local tempVector3 = LuaVector3.zero
function MissionCommandVisitNpc:GetTargetPos()
	local args = self.args

	local currentMapID = SceneProxy.Instance:GetCurMapID()
	if currentMapID == args.targetMapID then
		if nil ~= self.npcPoint then
			local pos = self.npcPoint.position
			tempVector3:Set(pos[1],pos[2],pos[3])
			return tempVector3
		end
		if nil ~= args.npcUID then
			local npcPointMap = Game.MapManager:GetNPCPointMap()
			if nil ~= npcPointMap then
				self.npcPoint = npcPointMap[args.npcUID]
				if nil ~= self.npcPoint then
					local pos = self.npcPoint.position
					tempVector3:Set(pos[1],pos[2],pos[3])
					return tempVector3
				end
			end
			LogUtility.InfoFormat("<color=red>MissionCommandVisitNpc: </color>can't find npc by unique id, uID={0}, mapID={1}", 
				args.npcUID, currentMapID)
		end
	end

	return args.targetPos
end

function MissionCommandVisitNpc:Log()
	local args = self.args
	LogUtility.InfoFormat("MissionCommandVisitNpc: {0}, {1}", 
		LogUtility.StringFormat("targetMapID={0}, realTargetMapID={1}, targetBPID={2}", 
			LogUtility.ToString(args.targetMapID), 
			LogUtility.ToString(args.realTargetMapID),
			LogUtility.ToString(args.targetBPID)), 
		LogUtility.StringFormat("targetPos=({0}), npcID={1}, npcUID={2}", 
			targetPos,
			LogUtility.ToString(args.npcID),
			LogUtility.ToString(args.npcUID)))
end

function MissionCommandVisitNpc:DoLaunch()
	local args = self.args
	local targetPos = self:GetTargetPos()
	-- self.teleport:Pause()
	if not self.teleport:Launch(
		args.targetMapID, 
		args.targetBPID, 
		targetPos) then
		LogUtility.InfoFormat("<color=red>MissionCommandVisitNpc: </color>teleport failed, {0}, {1}", 
			LogUtility.StringFormat("targetMapID={0}, realTargetMapID={1}, targetBPID={2}", 
				LogUtility.ToString(args.targetMapID), 
				LogUtility.ToString(args.realTargetMapID),
				LogUtility.ToString(args.targetBPID)), 
			LogUtility.StringFormat("targetPos=({0}), npcID={1}, npcUID={2}", 
				targetPos,
				LogUtility.ToString(args.npcID),
				LogUtility.ToString(args.npcUID)))
		if nil ~= args.callback then
			args.callback(self, MissionCommandMove.CallbackEvent.TeleportFailed)
		end
	else
		LogUtility.InfoFormat("<color=green>MissionCommandVisitNpc: </color>{0}, {1}", 
			LogUtility.StringFormat("targetMapID={0}, realTargetMapID={1}, targetBPID={2}", 
				LogUtility.ToString(args.targetMapID), 
				LogUtility.ToString(args.realTargetMapID),
				LogUtility.ToString(args.targetBPID)), 
			LogUtility.StringFormat("targetPos=({0}), npcID={1}, npcUID={2}", 
				targetPos,
				LogUtility.ToString(args.npcID),
				LogUtility.ToString(args.npcUID)))
	end
end
function MissionCommandVisitNpc:DoShutdown()
	self.teleport:Shutdown()
end
function MissionCommandVisitNpc:DoUpdate(time, deltaTime)
	local moving = self.teleport.running
	local args = self.args
	if nil ~= args.realTargetMapID then
		local currentMapID = Game.MapManager:GetMapID()
		if currentMapID == args.realTargetMapID then
			-- arrived real map
			if moving then
				self.teleport:Shutdown()
				Game.Myself:Logic_PlayAction_Idle()
			end
			return false
		end
	end

	if Game.Myself.data:NoMove() then
		if not self.teleport.pausing then
			self.teleport:Pause()
			Game.Myself:Logic_StopMove()
			Game.Myself:Logic_PlayAction_Idle()
		end
		return true
	elseif self.teleport.pausing then
		self.teleport:Resume()
	end
	
	self.teleport:Update()
	-- self.teleport:Resume()

	local currentMapID = Game.MapManager:GetMapID()
	if currentMapID == args.targetMapID then
		local targetPos = self:GetTargetPos()
		if nil == targetPos then
			-- wait
			return true
		end

		local arrived = false
		local myPosition = Game.Myself:GetPosition()
		local distance = VectorUtility.DistanceXZ(myPosition, targetPos)
		if MissionCommandVisitNpc.TRIGGER_RANGE > distance then
			-- look for npc
			local npc = nil
			if nil ~= args.npcUID then
				local npcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(args.npcUID)
				if nil ~= npcs and 0 < #npcs then
					npc = npcs[1]
				end
			else
				npc = NSceneNpcProxy.Instance:FindNearestNpc(myPosition, args.npcID)
			end
			if nil ~= npc then
				-- completed
				if AccessCustomType.Follow == args.customType then
					Game.Myself:Client_AccessTarget(
						npc,
						args.teleportMapID,
						nil,
						args.customType)
					if nil ~= args.custom and nil ~= args.customDeleter then
						args.customDeleter(args.custom)
					end
				else
					Game.Myself:Client_AccessTarget(
						npc,
						args.custom,
						args.customDeleter,
						args.customType)
				end
				args.custom = nil
				args.customDeleter = nil
				args.customType = nil
				return false
			end
			
			if nil ~= args.distance then
				arrived = args.distance > distance
			else
				arrived = 0.01 > distance
			end
		end

		if arrived then
			-- arrived and wait
			if moving then
				self.teleport:Shutdown()
				Game.Myself:Logic_PlayAction_Idle()
			end
		else
			if not self.teleport.running then
				-- move to targetPos
				if not self.teleport:Launch(
					args.targetMapID, 
					args.targetBPID, 
					targetPos) then
					LogUtility.InfoFormat("<color=red>MissionCommandVisitNpc: </color>teleport failed, {0}, {1}", 
						LogUtility.StringFormat("targetMapID={0}, realTargetMapID={1}, targetBPID={2}", 
							LogUtility.ToString(args.targetMapID), 
							LogUtility.ToString(args.realTargetMapID),
							LogUtility.ToString(args.targetBPID)), 
						LogUtility.StringFormat("targetPos=({0}), npcID={1}, npcUID={2}", 
							targetPos,
							LogUtility.ToString(args.npcID),
							LogUtility.ToString(args.npcUID)))
					return false
				end
			end
		end
	else
		if not self.teleport.running then
			-- can't arrive target map
			Game.Myself:Logic_PlayAction_Idle()
			LogUtility.InfoFormat("<color=red>MissionCommandVisitNpc: </color>teleport failed, {0}, {1}", 
				LogUtility.StringFormat("targetMapID={0}, realTargetMapID={1}, targetBPID={2}", 
					LogUtility.ToString(args.targetMapID), 
					LogUtility.ToString(args.realTargetMapID),
					LogUtility.ToString(args.targetBPID)), 
				LogUtility.StringFormat("targetPos=({0}), npcID={1}, npcUID={2}", 
					targetPos,
					LogUtility.ToString(args.npcID),
					LogUtility.ToString(args.npcUID)))
			return false
		end
	end
	return true
end

function MissionCommandVisitNpc:DoConstruct(asArray, args)
	MissionCommandVisitNpc.super.DoConstruct(self, asArray, args)
	if nil == self.args.targetMapID then
		self.args.targetMapID = Game.MapManager:GetMapID()
	end
	if nil ~= self.args.targetPos then
		self.args.targetPos = self.args.targetPos:Clone()
	end
	self.teleport = Game.WorldTeleport
	self.npcPoint = nil
end

function MissionCommandVisitNpc:DoDeconstruct(asArray)
	local args = self.args
	if nil ~= args.targetPos then
		args.targetPos:Destroy()
	end
	MissionCommandVisitNpc.super.DoDeconstruct(self, asArray)
	self.teleport = nil
	self.npcPoint = nil
	if nil ~= args.custom and nil ~= args.customDeleter then
		args.customDeleter(args.custom)
	end
	args.custom = nil
	args.customDeleter = nil
end