
AI_CMD_GetOffSeat = {}

-- Args = {
-- 	[1] = AI_CMD_GetOffSeat,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = seatID, -- int
-- }

function AI_CMD_GetOffSeat.ResetArgs(self, args)
	self.args[1] = args[2]
end

function AI_CMD_GetOffSeat.Construct(self, args)
	self.args[1] = args[2]
	return 1
end

function AI_CMD_GetOffSeat.Deconstruct(self)
end

function AI_CMD_GetOffSeat.Start(self, time, deltaTime, creature)
	if nil ~= self.args[1] and 0 ~= self.args[1] then
		Game.SceneSeatManager:TryGetOffSeat(
			creature,
			self.args[1])
	end
	return false
end

function AI_CMD_GetOffSeat.End(self, time, deltaTime, creature)
	
end

function AI_CMD_GetOffSeat.Update(self, time, deltaTime, creature)
	
end

function AI_CMD_GetOffSeat.ToString()
	return "AI_CMD_GetOffSeat",AI_CMD_GetOffSeat
end