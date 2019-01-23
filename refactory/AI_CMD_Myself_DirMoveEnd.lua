AI_CMD_Myself_DirMoveEnd = {}

-- Args = {
-- 	[1] = AI_CMD_Myself_DirMoveEnd,
-- 	see self.args below
-- }

-- self.args = {
-- }
function AI_CMD_Myself_DirMoveEnd.Construct(self, args)
	return 0
end

function AI_CMD_Myself_DirMoveEnd.Deconstruct(self)
end

function AI_CMD_Myself_DirMoveEnd.Start(self, time, deltaTime, creature)
	return false
end

function AI_CMD_Myself_DirMoveEnd.End(self, time, deltaTime, creature)
	
end

function AI_CMD_Myself_DirMoveEnd.Update(self, time, deltaTime, creature)
end

function AI_CMD_Myself_DirMoveEnd.ToString()
	return "AI_CMD_Myself_DirMoveEnd",AI_CMD_Myself_DirMoveEnd
end