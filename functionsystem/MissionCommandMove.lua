MissionCommandMove = class("MissionCommandMove", MissionCommand)

-- Args = {
-- 	targetMapID,
-- 	targetBPID,
-- 	targetPos,
-- 	showClickGround,
-- 	allowExitPoint,
-- 	distance,

-- 	custom,
-- }

MissionCommandMove.CallbackEvent = {
	TeleportFailed = MissionCommand.CallbackEvent.Custom+1,
}

function MissionCommandMove:Log()
	local args = self.args
	LogUtility.InfoFormat("MissionCommandMove: {0}", 
		LogUtility.StringFormat("targetMapID={0}, targetBPID={1}, targetPos={2}", 
			LogUtility.ToString(args.targetMapID), 
			LogUtility.ToString(args.targetBPID), 
			LogUtility.ToString(args.targetPos)))
end

function MissionCommandMove:DoLaunch()
	local args = self.args
	-- self.teleport:Pause()
	if not self.teleport:Launch(
		args.targetMapID, 
		args.targetBPID, 
		args.targetPos,
		args.showClickGround,
		args.allowExitPoint) then
		LogUtility.InfoFormat("<color=red>MissionCommandMove: </color>teleport failed, {0}", 
			LogUtility.StringFormat("targetMapID={0}, targetBPID={1}, targetPos={2}", 
				LogUtility.ToString(args.targetMapID), 
				LogUtility.ToString(args.targetBPID), 
				LogUtility.ToString(args.targetPos)))
		if nil ~= args.callback then
			args.callback(self, MissionCommandMove.CallbackEvent.TeleportFailed)
		end
	end
end
function MissionCommandMove:DoShutdown()
	self.teleport:Shutdown()
end
function MissionCommandMove:DoUpdate(time, deltaTime)
	local args = self.args
	if nil ~= args.distance then
		local currentMapID = Game.MapManager:GetMapID()
		if currentMapID == args.targetMapID then
			if nil == args.targetPos then
				-- arrived and wait
				self.teleport:Shutdown()
				Game.Myself:Logic_PlayAction_Idle()
				return false
			end
			if self.teleport.running then
				local distance = VectorUtility.DistanceXZ(
					Game.Myself:GetPosition(), 
					args.targetPos)
				if args.distance > distance then
					-- arrived and wait
					self.teleport:Shutdown()
					Game.Myself:Logic_PlayAction_Idle()
					return false
				end
			end
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

	-- self.teleport:Resume()
	self.teleport:Update()
	if not self.teleport.running then
		Game.Myself:Logic_PlayAction_Idle()
		return false
	end
	return true
end

function MissionCommandMove:DoConstruct(asArray, args)
	MissionCommandMove.super.DoConstruct(self, asArray, args)
	if nil == self.args.targetMapID then
		self.args.targetMapID = Game.MapManager:GetMapID()
	end
	if nil ~= self.args.targetPos then
		self.args.targetPos = self.args.targetPos:Clone()
	end
	self.teleport = Game.WorldTeleport
end

function MissionCommandMove:DoDeconstruct(asArray)
	if nil ~= self.args.targetPos then
		self.args.targetPos:Destroy()
	end
	MissionCommandMove.super.DoDeconstruct(self, asArray)
	self.teleport = nil
end