MissionCommandSkill = class("MissionCommandSkill", MissionCommand)

-- Args = {
-- 	targetMapID,
-- 	targetBPID,
-- 	targetPos,

-- 	groupID,
-- 	npcID,
-- 	skillID,
-- }

local FindNPCRange = 15
local MovingSwitchTargetInterval = 2

local tempVector3 = LuaVector3.zero

function MissionCommandSkill:ctor()
	MissionCommandSkill.super.ctor(self)

	self.autoBattle = AutoBattle.new()
	self.targetFilter = function (target)
		if nil ~= target
			and not target:IsDead()
			and not target.data:NoAccessable() then
			local distance = VectorUtility.DistanceXZ(
				Game.Myself:GetPosition(), 
				target:GetPosition())
			return FindNPCRange > distance
		end
		return false
	end

	self.nextSwitchTargetTime = 0
end

function MissionCommandSkill:Log()
	local args = self.args
	LogUtility.InfoFormat("MissionCommandSkill: {0}, {1}", 
		LogUtility.StringFormat("targetMapID={0}, targetBPID={1}, targetPos=({2})", 
			LogUtility.ToString(args.targetMapID), 
			LogUtility.ToString(args.targetBPID),
			targetPos), 
		LogUtility.StringFormat("npcID={0}, npcUID={1}, groupID={2}", 
			LogUtility.ToString(args.npcID),
			LogUtility.ToString(args.npcUID),
			LogUtility.ToString(args.groupID)))
end

function MissionCommandSkill:AutoBattleOn()
	
end

function MissionCommandSkill:AutoBattleOff()
	if not self.ignoreAutoBattle then
		self:Shutdown()
	end
end

function MissionCommandSkill:AutoBattleLost()
	self:AutoBattleOff()
end

function MissionCommandSkill:CurrentTargetValid()
	return self.targetFilter(self:GetWeakData(1))
end

function MissionCommandSkill:SwitchTarget(time, deltaTime)
	local args = self.args
	local oldTarget = self:GetWeakData(1)
	local newTarget = nil
	if nil ~= args.groupID then
		newTarget = NSceneNpcProxy.Instance:FindNearestNpcByGroupID(
			Game.Myself:GetPosition(), 
			args.groupID, 
			self.targetFilter)
	else
		newTarget = NSceneNpcProxy.Instance:FindNearestNpc(
			Game.Myself:GetPosition(), 
			args.npcID, 
			self.targetFilter)
	end
	LogUtility.InfoFormat("<color=green>MissionCommandSkill SwitchTarget: </color>{0} --> {1}", 
		(oldTarget and oldTarget.data:GetName() or "nil"), 
		(newTarget and newTarget.data:GetName() or "nil"))

	if oldTarget ~= newTarget then
		self:SetWeakData(1, newTarget)
		if nil ~= newTarget then
			Game.Myself:Client_LockTarget(newTarget)
		-- else
		-- 	print(string.format("<color=yellow>MissionCommandSkill: target not found, </color>groupID=%s, npcID=%s", 
		-- 			tostring(args.groupID), tostring(args.npcID)))
		end
	end
end

function MissionCommandSkill:GetTargetPos()
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
			LogUtility.InfoFormat("<color=red>MissionCommandSkill: </color>can't find npc by unique id, uID={0}, mapID={1}", 
				args.npcUID, currentMapID)
		end
	end

	return args.targetPos
end

function MissionCommandSkill:DoLaunch()
	-- local args = self.args
	-- local targetPos = self:GetTargetPos()
	-- self.teleport:Pause()
	-- if not self.teleport:Launch(
	-- 	args.targetMapID, 
	-- 	args.targetBPID, 
	-- 	targetPos) then
	-- 	LogUtility.InfoFormat("<color=red>MissionCommandSkill: </color>teleport failed, {0}, {1}", 
	-- 		LogUtility.StringFormat("targetMapID={0}, targetBPID={1}, targetPos=({2})", 
	-- 			LogUtility.ToString(args.targetMapID), 
	-- 			LogUtility.ToString(args.targetBPID),
	-- 			targetPos), 
	-- 		LogUtility.StringFormat("npcID={0}, npcUID={1}, groupID={2}", 
	-- 			LogUtility.ToString(args.npcID),
	-- 			LogUtility.ToString(args.npcUID),
	-- 			LogUtility.ToString(args.groupID)))
	-- 	if nil ~= args.callback then
	-- 		args.callback(self, MissionCommandMove.CallbackEvent.TeleportFailed)
	-- 	end
	-- end

	self.ignoreAutoBattle = true
	Game.AutoBattleManager:SetController(self)
	Game.AutoBattleManager:AutoBattleOff()
	self.ignoreAutoBattle = false
end
function MissionCommandSkill:DoShutdown()
	self.teleport:Shutdown()
end
function MissionCommandSkill:DoUpdate(time, deltaTime)
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

	if self.teleport.running then
		self.teleport:Update()
		if not self.teleport.running then
			Game.Myself:Logic_PlayAction_Idle()
		end
	end

	if not self:CurrentTargetValid() then
		if self.teleport.running and not self.teleport.pausing then
			if time > self.nextSwitchTargetTime then
				self.nextSwitchTargetTime = time + MovingSwitchTargetInterval
				self:SwitchTarget()
			end
		else
			self:SwitchTarget()
		end
	end
	
	local args = self.args
	if self:CurrentTargetValid() then
		if nil ~= args.skillID then
			LogUtility.InfoFormat("<color=yellow>MissionCommandSkill:UseSkill: </color>{0}", args.skillID)
			Game.Myself:Client_UseSkill(args.skillID)
		else
			self.autoBattle:Update(Game.Myself)
			Game.AutoBattleManager:AutoBattleOn()
		end

		self.teleport:Pause()
		return true
	else
		-- onlyNoTargetAutoCast
		if nil == args.skillID 
			and self.autoBattle:Attack(Game.Myself, nil, nil, true) then
			Game.AutoBattleManager:AutoBattleOn()
			self.teleport:Pause()
			return true
		end
	end

	if nil ~= self.autoBattle then
		self.ignoreAutoBattle = true
		Game.AutoBattleManager:AutoBattleOff()
		self.ignoreAutoBattle = false
	end

	if self.teleport.running then
		self.teleport:Resume()
	else
		local args = self.args
		local targetPos = self:GetTargetPos()
		local currentMapID = Game.MapManager:GetMapID()
		if nil == args.targetMapID or args.targetMapID == currentMapID then
			if nil ~= targetPos then
				local myPosition = Game.Myself:GetPosition()
				local distance = VectorUtility.DistanceXZ(myPosition, targetPos)
				if 0.01 >= distance then
					return true
				end
			end
		end
		if not self.teleport:Launch(
			args.targetMapID, 
			args.targetBPID, 
			targetPos) then
			LogUtility.InfoFormat("<color=red>MissionCommandSkill: </color>teleport failed, {0}, {1}", 
				LogUtility.StringFormat("targetMapID={0}, targetBPID={1}, targetPos=({2})", 
					LogUtility.ToString(args.targetMapID), 
					LogUtility.ToString(args.targetBPID),
					targetPos), 
				LogUtility.StringFormat("npcID={0}, npcUID={1}, groupID={2}", 
					LogUtility.ToString(args.npcID),
					LogUtility.ToString(args.npcUID),
					LogUtility.ToString(args.groupID)))
			return false
		end
	end
	
	return true
end

function MissionCommandSkill:DoConstruct(asArray, args)
	MissionCommandSkill.super.DoConstruct(self, asArray, args)
	if nil == self.args.targetMapID then
		self.args.targetMapID = Game.MapManager:GetMapID()
	end
	if nil ~= self.args.targetPos then
		self.args.targetPos = self.args.targetPos:Clone()
	end
	self.teleport = Game.WorldTeleport

	self:CreateWeakData()
end

function MissionCommandSkill:DoDeconstruct(asArray)
	if nil ~= self.args.targetPos then
		self.args.targetPos:Destroy()
	end
	MissionCommandSkill.super.DoDeconstruct(self, asArray)
	self.teleport = nil
	self.autoBattle:Reset()
	Game.AutoBattleManager:ClearController(self, true)
end