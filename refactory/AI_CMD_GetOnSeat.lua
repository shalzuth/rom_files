
AI_CMD_GetOnSeat = {}

-- Args = {
-- 	[1] = AI_CMD_GetOnSeat,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = seatID, -- int
-- }

function AI_CMD_GetOnSeat.ResetArgs(self, args)
	self.args[1] = args[2]
end

function AI_CMD_GetOnSeat.Construct(self, args)
	self.args[1] = args[2]
	return 1
end

function AI_CMD_GetOnSeat.Deconstruct(self)
end

function AI_CMD_GetOnSeat.Start(self, time, deltaTime, creature)
	if nil ~= self.args[1] and 0 ~= self.args[1] then
		Game.SceneSeatManager:GetOnSeat(
			creature,
			self.args[1])
	end
	return false
end

function AI_CMD_GetOnSeat.End(self, time, deltaTime, creature)
	
end

function AI_CMD_GetOnSeat.Update(self, time, deltaTime, creature)
	
end

function AI_CMD_GetOnSeat.ToString()
	return "AI_CMD_GetOnSeat",AI_CMD_GetOnSeat
end