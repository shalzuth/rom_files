
AI_CMD_PlayAction = {}

-- Args = {
-- 	[1] = AI_CMD_PlayAction,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = name, -- LuaVector3
-- 	[2] = normalizedTime, -- int
-- 	[3] = loop, -- bool or nil
-- 	[4] = fake dead, -- bool or nil
-- 	[5] = forceDuration, -- number or nil
-- 	[6] = action finished
-- 	[7] = scene seat only action
-- 	[8] = SpEffect instanceID
-- 	[9] = time elapsed
-- }

local addSpEffectData = {
	id = 4,
	guid = 1,
	entity = nil
}

local removeSpEffectData = {
	id = 4,
	guid = 1,
	entity = nil
}

local waitForActionCmdArray = {}
local function CmdFindPredicate(cmd, cmdInstanceID)
	return cmd.instanceID == cmdInstanceID
end
local function OnActionFinished(creatureGUID, cmdInstanceID)
	local cmd, i = TableUtility.ArrayFindByPredicate(
		waitForActionCmdArray, 
		CmdFindPredicate, 
		cmdInstanceID)
	if nil ~= cmd then
		cmd.args[6] = false -- action finished
	end
end

function AI_CMD_PlayAction.ResetArgs(self, args)
	self.args[1] = args[2]
	self.args[2] = args[3]
	self.args[3] = args[4]
	self.args[4] = args[5]
	self.args[5] = args[6]
end

function AI_CMD_PlayAction.Construct(self, args)
	self.args[1] = args[2]
	self.args[2] = args[3]
	self.args[3] = args[4]
	self.args[4] = args[5]
	self.args[5] = args[6]
	return 5
end

function AI_CMD_PlayAction.Deconstruct(self)
	
end

function AI_CMD_PlayAction.Start(self, time, deltaTime, creature)
	self.args[7] = nil
	self.args[8] = nil
	self.args[9] = nil
	
	local assetRole = creature.assetRole

	local hasAction = assetRole:HasActionRaw(self.args[1])

	local params = Asset_Role.GetPlayActionParams(self.args[1])
	if nil ~= self.args[2] then
		params[4] = self.args[2]
	end
	if nil ~= self.args[3] then
		params[5] = self.args[3]
	end
	if (nil == self.args[2] or 1 > self.args[2]) and not self.args[3] then
		-- not loop
		params[6] = true -- force
		if hasAction then
			params[7] = OnActionFinished
			params[8] = self.instanceID
			self.args[6] = creature:Logic_PlayAction(params) -- wait for action
			if self.args[6] then
				TableUtility.ArrayPushBack(waitForActionCmdArray, self)
			end
		else
			creature:Logic_PlayAction(params)
		end
	else
		creature:Logic_PlayAction(params)
		if 1 == Game.Config_Action[self.args[1]].Condition then
			-- scene seat only action
			self.args[7] = true
		end
	end
	
	Asset_Role.ClearPlayActionParams(params)

	if "sit_down" == self.args[1]
		and creature:AllowSpEffect_OnFloor() then
		self.args[8] = self.instanceID
		addSpEffectData.guid = self.instanceID
		creature:Server_AddSpEffect(addSpEffectData)
	end

	if self.args[5] and 0 < self.args[5] then
		-- force duration
		self.args[9] = 0
		return true
	end
	return (hasAction 
		or self.args[3] 
		or self.args[4] 
		or self.args[7])
end

function AI_CMD_PlayAction.End(self, time, deltaTime, creature)
	if not self.args[3] then
		-- not loop
		TableUtility.ArrayRemove(waitForActionCmdArray, self)
	end
	if nil ~= self.args[8] then
		removeSpEffectData.guid = self.args[8]
		creature:Server_RemoveSpEffect(removeSpEffectData)
		self.args[8] = nil
	end
end

function AI_CMD_PlayAction.Update(self, time, deltaTime, creature)
	local args = self.args
	if nil ~= args[5] and 0 < args[5] then
		-- force duration
		args[9] = args[9] + deltaTime
		if args[9] > args[5] then
			self:End(time, deltaTime, creature)
		end
	elseif (nil == args[2] or 1 > args[2]) 
		and not args[3] 
		and not args[6] then
		-- 1 > normalizedTime and not loop and action finished 
		self:End(time, deltaTime, creature)
	elseif args[4] and not creature:IsFakeDead() then
		self:End(time, deltaTime, creature)
	elseif args[7] and not creature:IsOnSceneSeat() then
		-- scene seat only action
		self:End(time, deltaTime, creature)
	end
end

function AI_CMD_PlayAction.ToString()
	return "AI_CMD_PlayAction",AI_CMD_PlayAction
end