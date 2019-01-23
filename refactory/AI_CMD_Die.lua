
AI_CMD_Die = {}

-- Args = {
-- 	[1] = AI_CMD_Die,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = no action, -- bool or nil
-- }
function AI_CMD_Die.ResetArgs(self, args)
	self.args[1] = args[2]
end

function AI_CMD_Die.Construct(self, args)
	self.args[1] = args[2]
	return 1
end

function AI_CMD_Die.Deconstruct(self)
end

function AI_CMD_Die.Start(self, time, deltaTime, creature)
	local params = Asset_Role.GetPlayActionParams(Asset_Role.ActionName.Die)
	if self.args[1] then
		params[4] = 1 -- normalizedTime(no action)
	end
	creature:Logic_PlayAction(params)
	creature:Logic_DeathBegin()
	return true
end

function AI_CMD_Die.End(self, time, deltaTime, creature)
	
end

function AI_CMD_Die.Update(self, time, deltaTime, creature)
	
end

function AI_CMD_Die.ToString()
	return "AI_CMD_Die",AI_CMD_Die
end