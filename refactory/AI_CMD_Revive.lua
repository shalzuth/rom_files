
AI_CMD_Revive = {}

-- Args = {
-- 	[1] = AI_CMD_Revive,
-- 	see self.args below
-- }

-- self.args = {
-- }

function AI_CMD_Revive.ResetArgs(self, args)
end

function AI_CMD_Revive.Construct(self, args)
	return 0
end

function AI_CMD_Revive.Deconstruct(self)
end

function AI_CMD_Revive.Start(self, time, deltaTime, creature)
	return false
end

function AI_CMD_Revive.End(self, time, deltaTime, creature)
	
end

function AI_CMD_Revive.Update(self, time, deltaTime, creature)
end

function AI_CMD_Revive.ToString()
	return "AI_CMD_Revive",AI_CMD_Revive
end