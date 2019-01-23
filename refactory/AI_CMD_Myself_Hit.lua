AI_CMD_Myself_Hit = {}
setmetatable(AI_CMD_Myself_Hit, {__index = AI_CMD_Hit})

function AI_CMD_Myself_Hit.Update(self, time, deltaTime, creature)
	-- LogUtility.InfoFormat("Hit Update: {0}, {1}", self.args[2], self.args[3])
	AI_CMD_Hit.Update(self, time, deltaTime, creature)
end

function AI_CMD_Myself_Hit.ToString()
	return "AI_CMD_Myself_Hit",AI_CMD_Myself_Hit
end