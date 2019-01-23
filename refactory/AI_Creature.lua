
AI_Creature = class("AI_Creature", AI_Base)

if not AI_Creature.AI_Creature_inited then
	AI_Creature.AI_Creature_inited = true

	-- seat allowed cmds
	-- AI_CMD_SetAngleY.SeatAllowed = true
	-- AI_CMD_SetScale.SeatAllowed = true
	-- AI_CMD_PlayAction.SeatAllowed = true

	-- in cmd queue
	AI_CMD_PlaceTo.InQueue = true
	AI_CMD_GetOnSeat.InQueue = true
	AI_CMD_GetOffSeat.InQueue = true
	AI_CMD_MoveTo.InQueue = true
	AI_CMD_PlayAction.InQueue = true
	AI_CMD_Skill.InQueue = true

	AI_CMD_PlaceTo.BreakIdle = true
	AI_CMD_GetOnSeat.BreakIdle = true
	AI_CMD_GetOffSeat.BreakIdle = true
	AI_CMD_MoveTo.BreakIdle = true
	AI_CMD_PlayAction.BreakIdle = true
	AI_CMD_Skill.BreakIdle = true
	AI_CMD_Hit.BreakIdle = true
	AI_CMD_Die.BreakIdle = true

	AI_CMD_PlaceTo.IgnoreBreak = true
	AI_CMD_GetOnSeat.IgnoreBreak = true
	AI_CMD_GetOffSeat.IgnoreBreak = true
	AI_CMD_SetAngleY.IgnoreBreak = true
	AI_CMD_SetScale.IgnoreBreak = true
	AI_CMD_Revive.IgnoreBreak = true

	-- request eat request (at push)
	AI_CMD_PlaceTo.ReqEatReq = {
		AI_CMD_MoveTo,
		AI_CMD_GetOnSeat
	}
	AI_CMD_MoveTo.ReqEatReq = {
		AI_CMD_PlayAction,
		AI_CMD_GetOnSeat
	}
	AI_CMD_Skill.ReqEatReq = {
		AI_CMD_Hit,
		AI_CMD_PlayAction,
		AI_CMD_GetOnSeat
	}
	AI_CMD_Die.ReqEatReq = {
		AI_CMD_GetOnSeat
	}
	AI_CMD_Revive.ReqEatReq = {
		AI_CMD_Die,
		AI_CMD_GetOnSeat
	}

	-- running(with cmdInQueue) eat request(without cmdInQueue)
	-- AI_CMD_MoveTo.RunEatReq = {
	-- 	AI_CMD_SetAngleY, -- blocked
	-- }
	AI_CMD_Skill.RunEatReq = {
		AI_CMD_Hit,
		-- AI_CMD_SetAngleY, -- blocked
	}
	AI_CMD_Die.RunEatReq = {
		AI_CMD_Hit,
	}

	-- request(with cmdInQueue) interrupt running(with cmdInQueue)
	AI_CMD_PlaceTo.Interrupts = {
		AI_CMD_MoveTo,
		AI_CMD_Skill,
		AI_CMD_PlayAction
	}
	AI_CMD_MoveTo.Interrupts = {
		AI_CMD_MoveTo,
		AI_CMD_PlayAction
	}
	AI_CMD_Skill.Interrupts = {
		AI_CMD_Skill,
		AI_CMD_PlayAction,
	}
	AI_CMD_PlayAction.Interrupts = {
		AI_CMD_PlayAction,
		AI_CMD_Skill,
	}
	AI_CMD_Hit.Interrupts = {
		AI_CMD_PlayAction
	}
	AI_CMD_Die.Interrupts = {
		AI_CMD_Hit,
		AI_CMD_PlayAction,
		AI_CMD_Skill
	}
	AI_CMD_Revive.Interrupts = {
		AI_CMD_Die
	}
	AI_CMD_GetOffSeat.Interrupts = {
		AI_CMD_PlayAction
	}

	-- request(with cmdInQueue) weak interrupt(1 < cmd.interruptLevel) running(with cmdInQueue)
	AI_CMD_PlaceTo.WeakInterrupts = {
	}
	AI_CMD_MoveTo.WeakInterrupts = {
		AI_CMD_Hit,
		AI_CMD_Skill
	}
	AI_CMD_PlayAction.WeakInterrupts = {
		AI_CMD_Hit,
	}
	AI_CMD_Skill.WeakInterrupts = {
		AI_CMD_Hit,
	}
	-- AI_CMD_Die.WeakInterrupts = {
	-- 	AI_CMD_Hit,
	-- }

	-- request(with cmdInQueue) be blocked by request or running
	AI_CMD_Die.BlockedBy = {
		AI_CMD_Hit
	}
	AI_CMD_SetAngleY.BlockedBy = {
		AI_CMD_MoveTo,
		AI_CMD_Skill
	}
	AI_CMD_MoveTo.BlockedBy = {
		-- AI_CMD_Hit, 
		AI_CMD_Die
	}
	AI_CMD_PlayAction.BlockedBy = {
		AI_CMD_Hit, 
		AI_CMD_Die
	}
	AI_CMD_Skill.BlockedBy = {
		-- AI_CMD_Hit, 
		AI_CMD_Die
	}

	-- running hide running(with cmdInQueue)
	AI_CMD_Hit.Hides = {
		AI_CMD_MoveTo
	}
end

function AI_CMD_Die.AllowStart(cmd, ai, creature)
	if ai:DieBlocked() then
		-- LogUtility.InfoFormat("<color=yellow>DieBlocked: </color>{0}",
		-- 	creature.data and creature.data:GetName() or "No Name")
		return false
	end
	return true
end

local function EatCommands(eatAIClasses, cmds)
	if nil ~= eatAIClasses then
		for i=1, #eatAIClasses do
			local eatAIClass = eatAIClasses[i]
			local eatCmd = cmds[eatAIClass]
			if nil ~= eatCmd then
				eatCmd:Destroy()
				cmds[eatAIClass] = nil
			end
		end
	end
end

local function InterruptCommands(AIClass, cmds, currentCmd, time, deltaTime, creature)
	local interruptCount = 0
	local interrupts = AIClass.Interrupts
	if nil ~= interrupts then
		for i=1, #interrupts do
			local interruptAIClass = interrupts[i]
			if interruptAIClass.InQueue then
				if nil ~= currentCmd 
					and currentCmd.AIClass == interruptAIClass then
					currentCmd:End(time, deltaTime, creature)
					currentCmd:Destroy()
					currentCmd = nil
					interruptCount = interruptCount + 1
				end
			else
				local interruptCmd = cmds[interruptAIClass]
				if nil ~= interruptCmd then
					interruptCmd:End(time, deltaTime, creature)
					interruptCmd:Destroy()
					cmds[interruptAIClass] = nil
					interruptCount = interruptCount + 1
				end
			end
		end
	end
	return interruptCount
end

local function TryInterruptCommands(AIClass, cmds, currentCmd, time, deltaTime, creature)
	local interruptCount = 0
	local interrupts = AIClass.Interrupts
	if nil ~= interrupts then
		-- try interrupt current command
		if nil ~= currentCmd then
			for i=1, #interrupts do
				local interruptAIClass = interrupts[i]
				if interruptAIClass.InQueue then
					if currentCmd.AIClass == interruptAIClass then
						currentCmd:End(time, deltaTime, creature)
						currentCmd:Destroy()
						currentCmd = nil
						interruptCount = interruptCount + 1
						break
					end
				end
			end
		end

		if nil == currentCmd then
			-- current command interrupted, interrupt cmds
			for i=1, #interrupts do
				local interruptAIClass = interrupts[i]
				if not interruptAIClass.InQueue then
					local interruptCmd = cmds[interruptAIClass]
					if nil ~= interruptCmd then
						interruptCmd:End(time, deltaTime, creature)
						interruptCmd:Destroy()
						cmds[interruptAIClass] = nil
						interruptCount = interruptCount + 1
					end
				end
			end
		end
	end
	return interruptCount
end

local function WeakInterruptCommands(AIClass, cmds, currentCmd, time, deltaTime, creature)
	local interruptCount = 0
	local interrupts = AIClass.WeakInterrupts
	if nil ~= interrupts then
		for i=1, #interrupts do
			local interruptAIClass = interrupts[i]
			if interruptAIClass.InQueue then
				-- interrupt current cmd in queue
				if nil ~= currentCmd 
					and currentCmd.AIClass == interruptAIClass 
					and 1 < currentCmd.interruptLevel then
					currentCmd:End(time, deltaTime, creature)
					currentCmd:Destroy()
					currentCmd = nil
					interruptCount = interruptCount + 1
				end
			else
				local interruptCmd = cmds[interruptAIClass]
				if nil ~= interruptCmd and 1 < interruptCmd.interruptLevel then
					interruptCmd:End(time, deltaTime, creature)
					interruptCmd:Destroy()
					cmds[interruptAIClass] = nil
					interruptCount = interruptCount + 1
				end
			end
		end
	end
	return interruptCount
end

local function TryWeakInterruptCommands(AIClass, cmds, currentCmd, time, deltaTime, creature)
	local interruptCount = 0
	local interrupts = AIClass.WeakInterrupts
	if nil ~= interrupts then
		-- try interrupt current command
		if nil ~= currentCmd and 1 < currentCmd.interruptLevel then
			for i=1, #interrupts do
				local interruptAIClass = interrupts[i]
				if interruptAIClass.InQueue then
					if currentCmd.AIClass == interruptAIClass then
						currentCmd:End(time, deltaTime, creature)
						currentCmd:Destroy()
						currentCmd = nil
						interruptCount = interruptCount + 1
						break
					end
				end
			end
		end

		if nil == currentCmd then
			-- current command interrupted, interrupt cmds
			for i=1, #interrupts do
				local interruptAIClass = interrupts[i]
				if not interruptAIClass.InQueue then
					local interruptCmd = cmds[interruptAIClass]
					if nil ~= interruptCmd and 1 < interruptCmd.interruptLevel then
						interruptCmd:End(time, deltaTime, creature)
						interruptCmd:Destroy()
						cmds[interruptAIClass] = nil
						interruptCount = interruptCount + 1
					end
				end
			end
		end
	end
	return interruptCount
end

local function AllowStart(AIClass, cmd, ai, creature)
	local blockedBy = AIClass.BlockedBy
	if nil ~= blockedBy then
		local requestCmds = ai.requestCmds
		local runningCmds = ai.runningCmds
		for i=1, #blockedBy do
			local blockedByAIClass = blockedBy[i]
			local blockedByCmd = requestCmds[blockedByAIClass]
			if nil ~= blockedByCmd then
				-- LogUtility.InfoFormat("<color=yellow>Cmd Blocked By Request: </color>{0}, {1}",
				-- 	creature.data and creature.data:GetName() or "No Name",
				-- 	LogUtility.StringFormat("{0}|--{1}", AIClass.ToString(), blockedByAIClass.ToString()))
				return false
			end
			blockedByCmd = runningCmds[blockedByAIClass]
			if nil ~= blockedByCmd then
				-- LogUtility.InfoFormat("<color=yellow>Cmd Blocked By Running: </color>{0}, {1}",
				-- 	creature.data and creature.data:GetName() or "No Name",
				-- 	LogUtility.StringFormat("{0}|--{1}", AIClass.ToString(), blockedByAIClass.ToString()))
				return false
			end
		end
	end
	if nil ~= AIClass.AllowStart then
		return AIClass.AllowStart(cmd, ai, creature)
	end
	return true
end

-- NOTE: for npc or other players
function AI_Creature:ctor()
	self.requestCmds = {}
	self.runningCmds = {}

	self.currentCmd = nil
	self.cmdQueue = {}
	self.idle = false

	self.requestBreakAll = false
	self.requestCameraFlash = false

	self.idleBreaked = false
	AI_Creature.super.ctor(self)
end

function AI_Creature:_TryBreakIdle(cmd, time, deltaTime, creature)
	if cmd.AIClass.BreakIdle then
		self:_IdleBreak(time, deltaTime, creature)
	end
end

function AI_Creature:_InitIdleAI(idleAIManager)
	self.idleAI_DoubleAction = IdleAI_DoubleAction.new();
	idleAIManager:PushAI(self.idleAI_DoubleAction);
	self.idleAI_BeHolded = IdleAI_BeHolded.new()
	idleAIManager:PushAI(self.idleAI_BeHolded)
	self.idleAI_HandInHand = IdleAI_HandInHand.new()
	idleAIManager:PushAI(self.idleAI_HandInHand)
	self.idleAI_Photographer = IdleAI_Photographer.new()
	idleAIManager:PushAI(self.idleAI_Photographer)
	idleAIManager:PushAI(IdleAI_PlayShow.new())
end

function AI_Creature:_PlayIdleAction(time, deltaTime, creature)
	if nil ~= creature.data and creature.data:NoPlayIdle() then
		return
	end
	AI_Creature.super._PlayIdleAction(self, time, deltaTime, creature)
end

function AI_Creature:HideCommands(AIClass, time, deltaTime, creature)
	local currentCmd = self.currentCmd
	local cmds = self.runningCmds
	local hides = AIClass.Hides
	if nil ~= hides then
		for i=1, #hides do
			local hideAIClass = hides[i]
			local hideCmd = cmds[hideAIClass]
			if nil ~= hideCmd then
				hideCmd:End(time, deltaTime, creature)
				hideCmd:SetKeepAlive(true)
			end

			if nil ~= currentCmd and currentCmd.AIClass == hideAIClass then
				currentCmd:End(time, deltaTime, creature)
				currentCmd:SetKeepAlive(true)
				currentCmd = nil
			end
		end
	end
end

function AI_Creature:UnhideCommands(AIClass, time, deltaTime, creature)
	local currentCmd = self.currentCmd
	local cmds = self.runningCmds
	local hides = AIClass.Hides
	if nil ~= hides then
		for i=1, #hides do
			local hideAIClass = hides[i]
			local hideCmd = cmds[hideAIClass]
			if nil ~= hideCmd then
				self:_TryBreakIdle(hideCmd, time, deltaTime, creature)
				hideCmd:Start(time, deltaTime, creature)
			end

			if nil ~= currentCmd and currentCmd.AIClass == hideAIClass then
				self:_TryBreakIdle(currentCmd, time, deltaTime, creature)
				currentCmd:Start(time, deltaTime, creature)
				currentCmd = nil
			end
		end
	end
end

function AI_Creature:_TryExecuteCommands(time, deltaTime, creature)
	local runningCount = 0

	local requestCmds = self.requestCmds
	local runningCmds = self.runningCmds
	local currentCmd  = self.currentCmd
	local cmdQueue = self.cmdQueue
	-- 1. update and eat
	for AIClass, cmd in pairs(runningCmds) do
		cmd:Update(time, deltaTime, creature)
		if cmd.running or cmd.keepAlive then
			EatCommands(AIClass.RunEatReq, requestCmds)
			runningCount = runningCount + 1
		else
			cmd:Destroy()
			runningCmds[AIClass] = nil
		end
	end
	if nil ~= currentCmd then
		currentCmd:Update(time, deltaTime, creature)
		if currentCmd.running or currentCmd.keepAlive then
			runningCount = runningCount + 1
			EatCommands(currentCmd.AIClass.RunEatReq, requestCmds)
			runningCount = runningCount - InterruptCommands(
				currentCmd.AIClass, 
				runningCmds, 
				nil, 
				time, deltaTime, creature)
			runningCount = runningCount - WeakInterruptCommands(
				currentCmd.AIClass, 
				runningCmds, 
				nil, 
				time, deltaTime, creature)
		else
			currentCmd:Destroy()
			currentCmd = nil
			self.currentCmd = nil
		end
	end

	-- 2. interrupt and start
	for AIClass, cmd in pairs(requestCmds) do
		runningCount = runningCount - InterruptCommands(
			AIClass, 
			runningCmds, 
			currentCmd, 
			time, deltaTime, creature)
		runningCount = runningCount - WeakInterruptCommands(
			AIClass, 
			runningCmds, 
			currentCmd, 
			time, deltaTime, creature)
	end
	if nil ~= currentCmd and not currentCmd:Alive() then
		currentCmd = nil
		self.currentCmd = nil
	end

	if nil ~= currentCmd and 0 < #cmdQueue then
		local nextCmd = cmdQueue[1]
		runningCount = runningCount - TryInterruptCommands(
			nextCmd.AIClass, 
			runningCmds, 
			currentCmd, 
			time, deltaTime, creature)
		if not currentCmd:Alive() then
			currentCmd = nil
			self.currentCmd = nil
		end
		runningCount = runningCount - TryWeakInterruptCommands(
			nextCmd.AIClass, 
			runningCmds, 
			currentCmd, 
			time, deltaTime, creature)
		if nil ~= currentCmd and not currentCmd:Alive() then
			currentCmd = nil
			self.currentCmd = nil
		end
	end

	-- 3. start
	local fastForward = false
	for AIClass, cmd in pairs(requestCmds) do
		if AllowStart(AIClass, cmd, self, creature) then
			requestCmds[AIClass] = nil
			local oldCmd = runningCmds[AIClass]
			if nil ~= oldCmd then
				if oldCmd.running then
					oldCmd:End(time, deltaTime, creature)
				elseif oldCmd.keepAlive then
					-- hided
					cmd:SetKeepAlive(true)
				end
				oldCmd:Destroy()
				runningCmds[AIClass] = nil
			end
			if cmd.keepAlive then
				-- hided
				runningCmds[AIClass] = cmd
			else
				self:_TryBreakIdle(cmd, time, deltaTime, creature)
				if cmd:Start(time, deltaTime, creature) then
					runningCmds[AIClass] = cmd
					runningCount = runningCount + 1
				else
					cmd:Destroy()
				end
			end
		else
			fastForward = true
		end
	end
	if nil == currentCmd then
		while 0 < #cmdQueue do
			local cmd = cmdQueue[1]
			if not AllowStart(cmd.AIClass, cmd, self, creature) then
				break
			end
			table.remove(cmdQueue, 1)
			self:_TryBreakIdle(cmd, time, deltaTime, creature)
			if cmd:Start(time, deltaTime, creature) then
				runningCount = runningCount + 1
				currentCmd = cmd
				break
			else
				cmd:Destroy()
			end
		end

		self.currentCmd = currentCmd
	end

	if not fastForward and 0 < #cmdQueue then
		fastForward = true
	end

	-- 4. 
	if fastForward then
		creature.logicTransform:SetFastForwardSpeed(2)
		creature.assetRole:SetSpeedScale(2)
	else
		creature.logicTransform:SetFastForwardSpeed(1)
		creature.assetRole:SetSpeedScale(1)
	end

	return runningCount
end

function AI_Creature:IsDiePending()
	return nil ~= self.requestCmds[AI_CMD_Die]
end

function AI_Creature:PushCommand(args, creature)
	-- if nil ~= creature.data and "4453d" == creature.data:GetName() then
	-- 	LogUtility.InfoFormat("<color=yellow>[{0}] PushCommand: </color>{1}", 
	-- 		LogUtility.StringFormat("{0}, {1}", creature.data and creature.data:GetName() or "No Name", creature.data and creature.data.id or "No ID"), 
	-- 		args[1].ToString())
	-- end
	local requestCmds = self.requestCmds
	local AIClass = args[1]

	-- if not AIClass.SeatAllowed then
	-- 	Game.SceneSeatManager:GetOffSeat(creature)
	-- end

	local cmd = requestCmds[AIClass]
	if nil ~= cmd then
		cmd:ResetArgs(args)
	else
		if AIClass.InQueue then
			local cmdQueue = self.cmdQueue
			local cmdCount = #cmdQueue

			if 0 >= cmdCount then
				-- push
				cmdQueue[1] = AI_CMD.Create(args)
			else
				local lastCmd = cmdQueue[cmdCount]
				if lastCmd.AIClass == AIClass then
					-- refresh last
					lastCmd:ResetArgs(args)
				else
					local eatAIClasses = AIClass.ReqEatReq
					if nil ~= eatAIClasses 
						and 0 < TableUtility.ArrayFindIndex(eatAIClasses, lastCmd.AIClass) then
						-- eat last
						lastCmd:Destroy()
						cmdQueue[cmdCount] = AI_CMD.Create(args)
					else
						-- push
						cmdQueue[cmdCount+1] = AI_CMD.Create(args)
					end
				end
			end
		else
			-- eat
			EatCommands(AIClass.ReqEatReq, requestCmds)
			requestCmds[AIClass] = AI_CMD.Create(args)
		end
	end
end

-- request begin
function AI_Creature:BreakAll(time, deltaTime, creature)
	self.requestBreakAll = true
	-- break not tunning cmds
	local cmds = self.requestCmds
	for k,v in pairs(cmds) do
		if not k.IgnoreBreak then
			v:Destroy()
			cmds[k] = nil
		end
	end

	cmds = self.cmdQueue
	if 0 < #cmds then
		for i=#cmds, 1, -1 do
			if not cmds[i].AIClass.IgnoreBreak then
				cmds[i]:Destroy()
				table.remove(cmds, i)
			end
		end
	end
end

function AI_Creature:CameraFlash(time, deltaTime, creature)
	self.requestCameraFlash = true
end

function AI_Creature:HandInHand(masterGUID, creature)
	self.idleAI_HandInHand:Request_Set(masterGUID)
end

function AI_Creature:BeHolded(masterGUID, creature)
	if nil ~= creature.data then
		self.idleAI_BeHolded:Request_Set(
		masterGUID, 
		creature.data:GetHoldScale(), 
		creature.data:GetHoldDir(),
		creature.data:GetHoldOffset())
	else
		self.idleAI_BeHolded:Request_Set(masterGUID)
	end
	
end

function AI_Creature:DoDoubleAction(masterGUID, creature)
	self.idleAI_DoubleAction:Request_Set(masterGUID);
end
-- request end

function AI_Creature:_CameraFlash(time, deltaTime, creature)
	self.requestCameraFlash = false
	self.idleAI_Photographer:Flash(time, deltaTime, creature)
end

function AI_Creature:_BreakAll(time, deltaTime, creature)
	self.requestBreakAll = false
	-- break running AI and cmds
	self:_IdleBreak(time, deltaTime, creature)

	cmds = self.runningCmds
	for k,v in pairs(cmds) do
		v:Destroy()
		cmds[k] = nil
	end

	if nil ~= self.currentCmd then
		self.currentCmd:End(time, deltaTime, creature)
		self.currentCmd:Destroy()
		self.currentCmd = nil
	end
end

-- override begin
function AI_Creature:_Clear(time, deltaTime, creature)
	self:BreakAll(time, deltaTime, creature)
	self:_BreakAll(time, deltaTime, creature)
	AI_Creature.super._Clear(self,time, deltaTime, creature)
end
function AI_Creature:_DoUpdate(time, deltaTime, creature)
	self.idleBreaked = false

	-- 1.
	local runningCount = self:_TryExecuteCommands(time, deltaTime, creature)
	AI_Creature.super._DoUpdate(self, time, deltaTime, creature)

	-- 2.
	if 0 >= runningCount then
		self:_Idle(time, deltaTime, creature)
	else
		self:_IdleBreak(time, deltaTime, creature)
	end

	self.idleBreaked = false
end
function AI_Creature:_DoRequest(time, deltaTime, creature)
	AI_Creature.super._DoRequest(self, time, deltaTime, creature)
	if self.requestBreakAll then
		self:_BreakAll(time, deltaTime, creature)
	end
	if self.requestCameraFlash then
		self:_CameraFlash(time, deltaTime, creature)
	end
end

function AI_Creature:_IdleBreak(time, deltaTime, creature)
	if self.idleBreaked then
		return
	end
	self.idleBreaked = true
	AI_Creature.super._IdleBreak(self, time, deltaTime, creature)
end

function AI_Creature:_Idle(time, deltaTime, creature)
	if nil ~= self.parent and self.idleAIManager:GetCurrentAI() == self.idleAI_BeHolded then
		self.idleAIManager:UpdateCurrentAI(self.idleElapsed, time, deltaTime, creature)
		return false
	end
	return AI_Creature.super._Idle(self, time, deltaTime, creature)
end
-- override end

