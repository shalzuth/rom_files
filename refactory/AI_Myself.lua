
AI_Myself = class("AI_Myself", AI_Base)

if not AI_Myself.AI_Myself_inited then
	AI_Myself.AI_Myself_inited = true

	-- parallel cmds
	AI_CMD_Myself_SetAngleY.Parallel = true
	AI_CMD_Myself_SetScale.Parallel = true
	AI_CMD_Myself_PlaceTo.Parallel = true

	-- seat allowed cmds
	AI_CMD_Myself_SetAngleY.SeatAllowed = true
	AI_CMD_Myself_SetScale.SeatAllowed = true
	AI_CMD_Myself_PlayAction.SeatAllowed = true
	-- no dir move but push dir move end
	AI_CMD_Myself_DirMoveEnd.SeatAllowed = true 

	-- seat allowed cmds
	AI_CMD_Myself_Die.NotifyAngleY = true
	AI_CMD_Myself_PlayAction.NotifyAngleY = true

	-- 1:interrupt
	-- 2:weak interrupt
	AI_CMD_Myself_PlaceTo.Interrupt = {
		[AI_CMD_Myself_Skill] = 1,
	}

	AI_CMD_Myself_MoveTo.Interrupt = {
		[AI_CMD_Myself_MoveTo] = 1,
		[AI_CMD_Myself_DirMove] = 1,
		[AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_Skill] = 2,
		[AI_CMD_Myself_PlayAction] = 1,
		[AI_CMD_Myself_Hit] = 2,
	}
	AI_CMD_Myself_DirMove.Interrupt = {
		[AI_CMD_Myself_MoveTo] = 1,
		[AI_CMD_Myself_DirMove] = 1,
		[AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_Skill] = 2,
		[AI_CMD_Myself_PlayAction] = 1,
		[AI_CMD_Myself_Hit] = 2,
	}
	AI_CMD_Myself_DirMoveEnd.Interrupt = {
		[AI_CMD_Myself_DirMove] = 1,
	}
	AI_CMD_Myself_Access.Interrupt = {
		[AI_CMD_Myself_MoveTo] = 1,
		[AI_CMD_Myself_DirMove] = 1,
		[AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_Skill] = 2,
		[AI_CMD_Myself_PlayAction] = 1,
		[AI_CMD_Myself_Hit] = 2,
	}
	AI_CMD_Myself_Skill.Interrupt = {
		[AI_CMD_Myself_MoveTo] = 1,
		[AI_CMD_Myself_DirMove] = 1,
		[AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_Skill] = 2,
		[AI_CMD_Myself_PlayAction] = 1,
		[AI_CMD_Myself_Hit] = 2,
	}
	AI_CMD_Myself_PlayAction.Interrupt = {
		[AI_CMD_Myself_MoveTo] = 1,
		[AI_CMD_Myself_DirMove] = 1,
		[AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_Skill] = 2,
		[AI_CMD_Myself_PlayAction] = 1,
		[AI_CMD_Myself_Hit] = 2,
	}
	AI_CMD_Myself_Hit.Interrupt = {
		-- [AI_CMD_Myself_MoveTo] = 1,
		-- [AI_CMD_Myself_DirMove] = 1,
		-- [AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_PlayAction] = 1,
		[AI_CMD_Myself_Hit] = 1,
	}
	AI_CMD_Myself_Die.Interrupt = {
		[AI_CMD_Myself_MoveTo] = 1,
		[AI_CMD_Myself_DirMove] = 1,
		[AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_Skill] = 1,
		[AI_CMD_Myself_PlayAction] = 1,
		[AI_CMD_Myself_Hit] = 1,
	}

	-- block
	AI_CMD_Myself_Skill.Block = {
		[AI_CMD_Myself_Hit] = 1,
	}
	AI_CMD_Myself_Die.Block = {
		[AI_CMD_Myself_MoveTo] = 9,
		[AI_CMD_Myself_DirMove] = 9,
		[AI_CMD_Myself_Access] = 9,
		[AI_CMD_Myself_Skill] = 9,
		[AI_CMD_Myself_PlayAction] = 9,
		[AI_CMD_Myself_Hit] = 9,
	}

	-- insert
	AI_CMD_Myself_Hit.Insert = {
		[AI_CMD_Myself_MoveTo] = 1,
		[AI_CMD_Myself_DirMove] = 1,
		[AI_CMD_Myself_Access] = 1,
		[AI_CMD_Myself_Skill] = 2,
	}
end

local NotifyServerAngleYDelay = 0.5
local NotifyServerAngleYInterval = 0.3

local CancelSkillLockTargetDelay = 1

function AI_Myself:ctor()
	self.cmdQueue = {}
	self.parallelCmds = {}
	self.currentCmd = nil
	self.nextCmd = nil
	self.nextCmd1 = nil
	self.dieCmd = nil
	self.nextNotifyAngleYTime = 0
	self.prevNotifyAngleY = 0

	self.skillLockTargetGUID = 0
	self.cancelSkillLockTargetGUIDTime = 0

	self.followers = {}

	self.requestBreakAll = false
	self.requestWeakBreak = false
	self.weakBreakIgnoreAction = false

	self.delayInterruptCameraSmooth = 0
	AI_Myself.super.ctor(self)
end

function AI_Myself:_InitIdleAI(idleAIManager)
	self.idleAIManager:PushAI(IdleAI_FearRun.new())

	self:_InitAutoAI(idleAIManager)

	self.idleAIManager:PushAI(IdleAI_Attack.new())
	self.idleAIManager:PushAI(IdleAI_PlayShow.new())
end

function AI_Myself:_InitAutoAI(idleAIManager)
	self.autoAI_WorldTeleport = WorldTeleport.new()

	self.autoAI_MissionCommand = IdleAI_MissionCommand.new()
	self.idleAIManager:PushAI(self.autoAI_MissionCommand)

	self.autoAI_FakeDead = IdleAI_FakeDead.new()
	self.idleAIManager:PushAI(self.autoAI_FakeDead)

	self.autoAI_FollowLeader = IdleAI_FollowLeader.new()
	self.idleAIManager:PushAI(self.autoAI_FollowLeader)

	self.autoAI_EndlessTowerSweep = IdleAI_EndlessTowerSweep.new()
	self.idleAIManager:PushAI(self.autoAI_EndlessTowerSweep)

	self.autoAI_Battle = IdleAI_AutoBattle.new()
	self.autoAI_BattleManager = AutoBattleManager.new(self.autoAI_Battle)
	self.idleAIManager:PushAI(self.autoAI_Battle)

	Game.WorldTeleport = self.autoAI_WorldTeleport
	Game.AutoBattleManager = self.autoAI_BattleManager
end

function AI_Myself:HideCommands(AIClass, time, deltaTime, creature)
	-- TODO
end

function AI_Myself:UnhideCommands(AIClass, time, deltaTime, creature)
	-- TODO
end

function AI_Myself:_NotifyAngleY(time, deltaTime, creature)
	if NotifyServerAngleYDelay > self.idleElapsed then
		return
	end
	self:_DoNotifyAngleY(time, deltaTime, creature)
end

function AI_Myself:_DoNotifyAngleY(time, deltaTime, creature)
	if time > self.nextNotifyAngleYTime then
		self.nextNotifyAngleYTime = time + NotifyServerAngleYInterval
		local angleY = creature:GetAngleY()
		if nil ~= angleY and self.prevNotifyAngleY ~= angleY then
			self.prevNotifyAngleY = angleY
			creature:Client_SyncRotationY(angleY)
		end
	end
end

function AI_Myself:_Idle(time, deltaTime, creature)
	self:_NotifyAngleY(time, deltaTime, creature)
	return AI_Myself.super._Idle(self, time, deltaTime, creature)
end

function AI_Myself:_SetNextCommand(cmd, creature)
	-- LogUtility.InfoFormat("<color=yellow>SetNextCommand: </color>{0} --> {1}", 
	-- 	self.nextCmd and self.nextCmd.AIClass.ToString() or "nil", 
	-- 	cmd and cmd.AIClass.ToString() or "nil")

	if AI_CMD_Myself_Skill ~= cmd.AIClass 
		and AI_CMD_Myself_Hit ~= cmd.AIClass then
		-- cancel attack
		creature:Logic_SetAttackTarget(nil)
	end

	if nil ~= self.nextCmd1 then
		if not self:_DoAllowInsert(self.nextCmd1, cmd.AIClass, creature) then
			-- not insert
			if self:_CmdCanBeReplaced(creature, self.nextCmd1, cmd) then 
				self.nextCmd1:Destroy()
				self.nextCmd1 = cmd
				return true
			else
				return false
			end
		end
	end
	if nil ~= self.nextCmd then
		if self:_DoAllowInsert(self.nextCmd, cmd.AIClass, creature) then
			-- insert
			if nil ~= self.nextCmd1 then
				self.nextCmd1:Destroy()
			end
			self.nextCmd1 = self.nextCmd
		else
			if self:_CmdCanBeReplaced(creature, self.nextCmd, cmd) then 
				self.nextCmd:Destroy()
			else
				return false
			end
		end
	end
	self.nextCmd = cmd
	return true
end

function AI_Myself:_AllowInterrupt(time, deltaTime, creature)
	if nil == self.nextCmd then
		return false
	end

	-- local currentCmd = self.currentCmd
	-- if nil ~= currentCmd.AIClass.AllowInterrupt 
	-- 	and currentCmd.AIClass.AllowInterrupt(currentCmd, self.nextCmd, time, deltaTime, creature) then
	-- 	return true
	-- end
	return self:_DoAllowInterrupt(self.currentCmd, self.nextCmd.AIClass, creature)
end

function AI_Myself:_DoAllowInterrupt(currentCmd, nextAIClass, creature)
	-- LogUtility.InfoFormat("<color=yellow>_DoAllowInterrupt: </color>{0} --> {1}", 
	-- 		currentCmd.AIClass.ToString(), 
	-- 		nextAIClass.ToString())

	local nextInterruptMap = nextAIClass.Interrupt
	if nil == nextInterruptMap then
		return false
	end

	local interruptLevel = nextInterruptMap[currentCmd.AIClass]
	-- LogUtility.InfoFormat("<color=yellow>CheckInterruptLevel: </color>{0} --> {1}", 
	-- 		interruptLevel, 
	-- 		currentCmd.interruptLevel)
	if nil == interruptLevel then
		return false
	end
	if currentCmd.interruptLevel < interruptLevel then
		return false
	end
	return true
end

function AI_Myself:_AllowInsert(time, deltaTime, creature)
	if nil == self.nextCmd then
		return false
	end
	return self:_DoAllowInsert(self.currentCmd, self.nextCmd.AIClass, creature)
end

function AI_Myself:_DoAllowInsert(currentCmd, nextAIClass, creature)
	local nextInsertMap = nextAIClass.Insert
	if nil == nextInsertMap then
		return false
	end

	-- LogUtility.InfoFormat("<color=yellow>_DoAllowInsert: </color>{0} --> {1}", 
	-- 	currentCmd.AIClass.ToString(), 
	-- 	nextAIClass.ToString())

	local insertLevel = nextInsertMap[currentCmd.AIClass]
	if nil == insertLevel then
		return false
	end

	-- LogUtility.InfoFormat("<color=yellow>CheckInsertLevel: </color>{0} --> {1}", 
	-- 	insertLevel, 
	-- 	currentCmd.interruptLevel)

	if currentCmd.interruptLevel < insertLevel then
		return false
	end
	return true
end

function AI_Myself:_NextSkillCmdCanUse(creature,nextCmd)
	if(nextCmd~=nil) then
		if(AI_CMD_Myself_Skill == nextCmd.AIClass) then
			local skillInfo = Game.LogicManager_Skill:GetSkillInfo(nextCmd.args[1])
			if(skillInfo ~= nil) then
				if(creature:Logic_CheckSkillCanUseBySkillInfo(skillInfo)) then
					return true
				end
			end
		end
	end
	return false
end

function AI_Myself:_NextSkillCmdCanBreakWeakFreeze(creature,nextCmd)
	if nil == nextCmd then
		return false
	end
	if AI_CMD_Myself_Skill ~= nextCmd.AIClass then
		return false
	end
	return creature.data:CanBreakWeakFreezeBySkillID(nextCmd.args[1])
end

function AI_Myself:_CmdCanBeReplaced(creature,cmd,replaceCmd)
	if AI_CMD_Myself_Skill == cmd.AIClass and AI_CMD_Myself_Skill.FromServer(cmd) then
		return false
	end
	return true
end

function AI_Myself:_TrySwitchCommand(time, deltaTime, creature)
	local creatureData = creature.data
	local breakWeakFreeze = false
	if creatureData:WeakFreeze() then
		local nextCmd = self.nextCmd or self.nextCmd1
		if self:_NextSkillCmdCanBreakWeakFreeze(creature, nextCmd) then
			breakWeakFreeze = true
		end
	end
	if creatureData:Freeze() then
		local nextCmd = self.nextCmd or self.nextCmd1
		if(self:_NextSkillCmdCanUse(creature,nextCmd)==false) then
			return
		end
	elseif creatureData:NoAct() or creatureData:FearRun() then
		local nextCmd = self.nextCmd or self.nextCmd1
		if nil == self.dieCmd 
			and (nil == nextCmd 
				or AI_CMD_Myself_Hit ~= nextCmd.AIClass
				or AI_CMD_Myself_Die ~= nextCmd.AIClass
				)
			and false == self:_NextSkillCmdCanUse(creature,nextCmd) then
			return
		end
	end
	if breakWeakFreeze then
		creature:Logic_BreakWeakFreeze()
	end

	if nil ~= self.dieCmd then
		-- dead
		if not self:DieBlocked() then
			if self:_SetNextCommand(self.dieCmd, creature) then
				self.dieCmd = nil
			-- 	LogUtility.Info("<color=yellow>Set Die Command</color>")
			-- else
			-- 	LogUtility.Info("<color=yellow>DieBlocked</color>")
			end
		end
	end

	if nil == self.nextCmd and nil ~= self.nextCmd1 then
		self.nextCmd = self.nextCmd1
		self.nextCmd1 = nil
	end

	if nil ~= self.currentCmd then
		if nil ~= self.nextCmd then
			if nil ~= self.nextCmd1 
				and self:_DoAllowInterrupt(self.nextCmd, self.nextCmd1.AIClass, creature) then
				self.nextCmd:Destroy()
				self.nextCmd = self.nextCmd1
				self.nextCmd1 = nil
			end
		end
		if self:_AllowInterrupt(time, deltaTime, creature) then
			-- LogUtility.InfoFormat("<color=yellow>SwitchCommand: </color>{0} --> {1}, {2}", 
			-- 	self.currentCmd.AIClass.ToString(), 
			-- 	self.nextCmd.AIClass.ToString(),
			-- 	LogUtility.ToString(self.nextCmd))
			self.currentCmd:End(time, deltaTime, creature)
			self.currentCmd:Destroy()

			self.currentCmd = self.nextCmd
			self.nextCmd = self.nextCmd1
			self.nextCmd1 = nil
		elseif self:_AllowInsert(time, deltaTime, creature) then
			-- LogUtility.InfoFormat("<color=yellow>InsertCommand: </color>{0} <-- {1}, {2}", 
			-- 	self.currentCmd.AIClass.ToString(), 
			-- 	self.nextCmd.AIClass.ToString(),
			-- 	LogUtility.ToString(self.nextCmd))
			local oldCurrentCmd = self.currentCmd
			self.currentCmd = self.nextCmd
			oldCurrentCmd:End(time, deltaTime, creature)
			if nil ~= self.dieCmd then
				oldCurrentCmd:Destroy()
				self.nextCmd = self.nextCmd1
				self.nextCmd1 = nil
			else
				self.nextCmd = oldCurrentCmd
			end
		end
	elseif nil ~= self.nextCmd then
		-- LogUtility.InfoFormat("<color=yellow>SwitchCommand: </color>{0} --> {1}, {2}", 
		-- 	"nil", 
		-- 	self.nextCmd.AIClass.ToString(),
		-- 	LogUtility.ToString(self.nextCmd))
		self.currentCmd = self.nextCmd
		self.nextCmd = self.nextCmd1
		self.nextCmd1 = nil
	end
end

function AI_Myself:_TryExecuteSerialCommand(time, deltaTime, creature)
	if nil ~= self.currentCmd then
		local cmd = self.currentCmd
		if cmd.running then
			cmd:Update(time, deltaTime, creature)
		else
			self:_IdleBreak(time, deltaTime, creature)
			cmd:Start(time, deltaTime, creature)
		end

		if nil ~= self.currentCmd 
			and not self.currentCmd.running 
			and not self.currentCmd.keepAlive then
			-- LogUtility.InfoFormat("<color=yellow>Command End: </color>{0}", 
			-- 	self.currentCmd.AIClass.ToString())
			self.currentCmd:Destroy()
			self.currentCmd = nil
		end
	end
end

function AI_Myself:_TryExecuteParallelCommand(time, deltaTime, creature)
	if 0 >= #self.parallelCmds then
		return
	end
	local cmds = self.parallelCmds
	for i=#cmds, 1, -1 do
		local cmd = cmds[i]
		if cmd.running then
			cmd:Update(time, deltaTime, creature)
		else
			if nil ~= self.currentCmd 
				and AI_Myself:_DoAllowInsert(self.currentCmd, cmd.AIClass, creature) then
				self.currentCmd:End()
				self.currentCmd:Destroy()
				self.currentCmd = self.nextCmd
				self.nextCmd = self.nextCmd1
				self.nextCmd1 = nil
			end
			cmd:Start(time, deltaTime, creature)
		end

		if not cmd.running and not cmd.keepAlive then
			table.remove(cmds, i)
			cmd:Destroy()
		end
	end
end

-- test begin
local AllMyself_AI_CMD = {
	AI_CMD_Myself_SetAngleY,
	AI_CMD_Myself_PlaceTo,
	AI_CMD_Myself_SetScale,
	AI_CMD_Myself_MoveTo,
	AI_CMD_Myself_PlayAction,
	AI_CMD_Myself_DirMove,
	AI_CMD_Myself_DirMoveEnd,
	AI_CMD_Myself_Access,
	AI_CMD_Myself_Skill,
	AI_CMD_Myself_Hit,
	AI_CMD_Myself_Die,
}
-- test end

function AI_Myself:GetCurrentCommand(creature)
	return self.currentCmd
end

function AI_Myself:PushCommand(args, creature)
	-- test begin
	-- Debug_AssertFormat(
	-- 	0 < TableUtility.ArrayFindIndex(AllMyself_AI_CMD, args[1]), 
	-- 	"Not Myself AI CMD: {0}", 
	-- 	args[1].ToString())
	-- test end
	if args[1].Parallel then
		-- parallel
		TableUtility.ArrayPushBack(self.parallelCmds, AI_CMD.Create(args))
	else
		-- serial
		if AI_CMD_Myself_Die == args[1] then
			if nil ~= self.dieCmd then
				self.dieCmd:Destroy()
			end
			self.dieCmd = AI_CMD.Create(args)
			-- LogUtility.Info("<color=yellow>Push Die Command</color>")
			return
		else
			if nil ~= self.dieCmd and AI_CMD_Myself_Hit ~= args[1] then
				-- die block others
				-- LogUtility.InfoFormat("<color=yellow>Die Block: </color>{0}", args[1].ToString())
				return
			end
		end
		if nil ~= self.currentCmd then
			if self.currentCmd.AIClass == args[1]
				and self.currentCmd:TryRestart(args, creature) then
				return
			end
			local block = self.currentCmd.AIClass.Block
			if nil ~= block then
				local blockLevel = block[args[1]]
				if nil ~= blockLevel 
					and self.currentCmd.interruptLevel <= blockLevel then
					-- block
					-- LogUtility.InfoFormat("<color=yellow>{0} Block: </color>{1}", self.currentCmd.AIClass.ToString(), args[1].ToString())
					return
				end
			end
		end
		local cmd = AI_CMD.Create(args)
		if not self:_SetNextCommand(cmd, creature) then
			cmd:Destroy()
		end
	end

	if not args[1].SeatAllowed then
		Game.SceneSeatManager:MyselfManualGetOffSeat(creature)
	end
end

function AI_Myself:GetFollowLeaderID(creature)
	return self.autoAI_FollowLeader.leaderID
end

function AI_Myself:IsFollowHandInHand(creature)
	return 0 ~= self:GetFollowLeaderID(creature) and self.autoAI_FollowLeader:IsHandInHand()
end

function AI_Myself:SetFollower(followerID, followType, creature)
	if 0 == followerID then
		return
	end
	if 5 == followType then -- break
		self.followers[followerID] = nil
	else
		self.followers[followerID] = followType or 0
	end
end

function AI_Myself:ClearFollower(creature)
	TableUtility.TableClear(self.followers)
end

-- return k,v table, key:guid, value:type
function AI_Myself:GetAllFollowers(creature)
	return self.followers
end

function AI_Myself:GetHandInHandFollower(creature)
	for k,v in pairs(self.followers) do
		if 1 == v then
			return k
		end
	end
	return 0
end

function AI_Myself:GetCurrentMissionCommand()
	return self.autoAI_MissionCommand.currentCommand
end

function AI_Myself:GetAutoBattleLockID(creature)
	return self.autoAI_Battle.lockID
end

function AI_Myself:GetAutoBattleLockTarget(creature, skillInfo)
	local lockID = self.autoAI_Battle.lockID
	if 0 == lockID then
		return nil
	end
	return self.autoAI_Battle:GetLockTarget(creature, skillInfo), lockID
end

function AI_Myself:SearchAutoBattleLockTarget(creature, skillInfo)
	local lockID = self.autoAI_Battle.lockID
	if 0 == lockID then
		return nil
	end
	return self.autoAI_Battle:SearchLockTarget(creature, skillInfo), lockID
end

function AI_Myself:IsAutoBattleProtectingTeam(creature)
	return self.autoAI_Battle:IsProtectingTeam(creature)
end

function AI_Myself:IsAutoBattleStanding(creature)
	return self.autoAI_Battle:IsStanding(creature)
end

-- request begin
function AI_Myself:SetSkillLockTarget(lockTargetGUID, creature)
	-- self.cancelSkillLockTargetGUIDTime = 0
	-- if self.skillLockTargetGUID == lockTargetGUID then
	-- 	return
	-- end
	-- self.skillLockTargetGUID = lockTargetGUID
	-- ServiceSessionTeamProxy.Instance:CallLockTarget(lockTargetGUID)
	-- LogUtility.InfoFormat("<color=yellow>CallLockTarget: </color>{0}", 
	-- 	lockTargetGUID)
end

function AI_Myself:ClearAuto_BattleCurrentTarget(creature)
	self.autoAI_Battle:Request_ClearCurrentTarget()
end
function AI_Myself:SetAuto_BattleLockID(lockID, creature)
	self.autoAI_Battle:Request_SetLockID(lockID)
end
function AI_Myself:SetAuto_BattleProtectTeam(on, creature)
	self.autoAI_Battle:Request_SetProtectTeam(on)
end
function AI_Myself:SetAuto_BattleStanding(on, creature)
	self.autoAI_Battle:Request_SetStanding(on)
end

function AI_Myself:SetAuto_Battle(on, creature)
	if on then
		local ignoreAction = false
		if(creature:IsFakeDead() and self.currentCmd ~= nil and self.currentCmd.AIClass == AI_CMD_Myself_PlayAction and self.currentCmd.args[4]) then
			if(self.autoAI_FakeDead.on) then
				ignoreAction = true
			end
		end
		self:WeakBreak(Time.time, Time.deltaTime, creature,ignoreAction)
		self:SetAuto_MissionCommand(nil, creature)
		self:SetAuto_FollowLeader(0, creature)
	end
	self.autoAI_Battle:Request_Set(on)
end

function AI_Myself:SetAutoFakeDead(skillID, creature)
	self.autoAI_FakeDead:Set_AutoFakeDead(skillID)
end

function AI_Myself:SetAuto_MissionCommand(newCmd, creature)
	if nil ~= newCmd then
		self:WeakBreak(Time.time, Time.deltaTime, creature)
		-- self:SetAuto_FollowLeader(0, creature)
	end
	self.autoAI_MissionCommand:Request_Set(newCmd)
end

function AI_Myself:SetAuto_FollowLeader(leaderID, followType, creature, ignoreNotifyServer)
	if 0 ~= leaderID then
		if 1 == followType then
			-- hand in hand
			self.autoAI_FollowLeader:Request_SetHandInHand(true)
		elseif(6 == followType)then
			self.autoAI_FollowLeader:Request_SetDoubleAction(true)
		else
			self.autoAI_FollowLeader:Request_SetDoubleAction(false)
			self.autoAI_FollowLeader:Request_SetHandInHand(false)
		end
		if self:GetFollowLeaderID(creature) ~= leaderID then
			-- break
			self:WeakBreak(Time.time, Time.deltaTime, creature)
			self:SetAuto_MissionCommand(nil, creature)
		end
	else
		self.autoAI_FollowLeader:Request_SetDoubleAction(false)
		self.autoAI_FollowLeader:Request_SetHandInHand(false)
	end
	self.autoAI_FollowLeader:Request_Set(leaderID, ignoreNotifyServer)
end

function AI_Myself:SetAuto_FollowLeaderMoveToMap(mapID, pos)
	self.autoAI_FollowLeader:Request_MoveToMap(mapID, pos)
end

function AI_Myself:SetAuto_FollowHandInHandState(running, creature)
	self.autoAI_FollowLeader:Request_SetHandInHandState(running)
end

function AI_Myself:SetAuto_FollowLeaderTarget(guid, time)
	self.autoAI_FollowLeader:Request_RefreshLeaderTarget(guid, time)
end

function AI_Myself:SetAuto_FollowLeaderDelay()
	self.autoAI_FollowLeader:Request_Delay()
end

function AI_Myself:SetAuto_EndlessTowerSweep(on)
	self.autoAI_EndlessTowerSweep:Request_Set(on)
end

function AI_Myself:GetAuto_EndlessTowerSweep()
	return self.autoAI_EndlessTowerSweep.on
end

function AI_Myself:TryBreakAll(time, deltaTime, creature)
	self:BreakAll(time, deltaTime, creature)
	return true
end

function AI_Myself:BreakAll(time, deltaTime, creature)
	self.requestBreakAll = true

	-- break not tunning cmds
	if nil ~= self.nextCmd then
		self.nextCmd:Destroy()
		self.nextCmd = nil
	end
	if nil ~= self.nextCmd1 then
		self.nextCmd1:Destroy()
		self.nextCmd1 = nil
	end
end
function AI_Myself:WeakBreak(time, deltaTime, creature, ignoreAction)
	self.requestWeakBreak = true
	self.weakBreakIgnoreAction = ignoreAction or false
end

function AI_Myself:DelayInterruptCameraSmooth(delayFrameCount)
	self.delayInterruptCameraSmooth = delayFrameCount
end
-- request end

function AI_Myself:_BreakAll(time, deltaTime, creature)
	self.requestBreakAll = false
	-- break running AI and cmds
	self:_IdleBreak(time, deltaTime, creature)

	if nil ~= self.currentCmd then
		self.currentCmd:End(time, deltaTime, creature)
		self.currentCmd:Destroy()
		self.currentCmd = nil
	end

	-- if nil ~= self.nextCmd then
	-- 	self.nextCmd:Destroy()
	-- 	self.nextCmd = nil
	-- end
	-- if nil ~= self.nextCmd1 then
	-- 	self.nextCmd1:Destroy()
	-- 	self.nextCmd1 = nil
	-- end

	-- local cmds = self.parallelCmds
	-- if 0 < #cmds then
	-- 	for i=#cmds, 1, -1 do
	-- 		cmds[i]:End(time, deltaTime, creature)
	-- 		cmds[i]:Destroy()
	-- 		cmds[i] = nil
	-- 	end
	-- end
end

function AI_Myself:_WeakBreak(time, deltaTime, creature)
	local ignoreAction = self.weakBreakIgnoreAction
	self.requestWeakBreak = false
	self.weakBreakIgnoreAction = false
	self:_IdleBreak(time, deltaTime, creature)

	if nil ~= self.currentCmd then
		local interruptLevel = AI_CMD_Myself_MoveTo.Interrupt[self.currentCmd.AIClass]
		if nil ~= interruptLevel and self.currentCmd.interruptLevel >= interruptLevel then
			if not ignoreAction or AI_CMD_Myself_PlayAction ~= self.currentCmd.AIClass then
				self.currentCmd:End(time, deltaTime, creature)
				self.currentCmd:Destroy()
				self.currentCmd = nil
			end
		end
	end

	-- if nil ~= self.nextCmd then
	-- 	self.nextCmd:Destroy()
	-- 	self.nextCmd = nil
	-- end
	-- if nil ~= self.nextCmd1 then
	-- 	self.nextCmd1:Destroy()
	-- 	self.nextCmd1 = nil
	-- end

	-- local cmds = self.parallelCmds
	-- if 0 < #cmds then
	-- 	for i=#cmds, 1, -1 do
	-- 		cmds[i]:End(time, deltaTime, creature)
	-- 		cmds[i]:Destroy()
	-- 		cmds[i] = nil
	-- 	end
	-- end
end

-- override begin
function AI_Myself:_Clear(time, deltaTime, creature)
	self:_BreakAll(time, deltaTime, creature)
	AI_Myself.super._Clear(self,time, deltaTime, creature)
end

function AI_Myself:_DoUpdate(time, deltaTime, creature)
	if 0 < self.delayInterruptCameraSmooth then
		self.delayInterruptCameraSmooth = self.delayInterruptCameraSmooth-1
		if 0 == self.delayInterruptCameraSmooth 
			and nil ~= CameraController.singletonInstance then
			CameraController.singletonInstance:InterruptSmoothTo()
		end
	end

	-- 1.
	self:_TrySwitchCommand(time, deltaTime, creature)

	-- execute
	self:_TryExecuteParallelCommand(time, deltaTime, creature)
	self:_TryExecuteSerialCommand(time, deltaTime, creature)

	-- if nil == self.currentCmd 
	-- 	or AI_CMD_Myself_Skill ~= self.currentCmd.AIClass then
	-- 	if 0 < self.cancelSkillLockTargetGUIDTime then
	-- 		if time > self.cancelSkillLockTargetGUIDTime then
	-- 			self:SetSkillLockTarget(0, creature)
	-- 		end
	-- 	else
	-- 		self.cancelSkillLockTargetGUIDTime = time + CancelSkillLockTargetDelay
	-- 	end
	-- end

	-- 2.
	if nil == self.currentCmd
		and nil == self.nextCmd 
		and nil == self.nextCmd1 then
		self:_Idle(time, deltaTime, creature)
		if 0 >= #self.parallelCmds then
			-- no cmds
			-- base
			AI_Myself.super._DoUpdate(self, time, deltaTime, creature)

			return
		end
	elseif nil ~= self.currentCmd then
		if self.currentCmd.AIClass.NotifyAngleY then
			self:_DoNotifyAngleY(time, deltaTime, creature)
		end
	end

	-- base
	AI_Myself.super._DoUpdate(self, time, deltaTime, creature)
end
function AI_Myself:_DoRequest(time, deltaTime, creature)
	AI_Myself.super._DoRequest(self, time, deltaTime, creature)
	if self.requestWeakBreak then
		self:_WeakBreak(time, deltaTime, creature)
	end
	if self.requestBreakAll then
		self:_BreakAll(time, deltaTime, creature)
	end
end
-- override end