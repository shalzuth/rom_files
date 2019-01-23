
AI_CMD_PlaceTo = {}

-- Args = {
-- 	[1] = AI_CMD_PlaceTo,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = position, -- LuaVector3
-- 	[2] = ignoreNavMesh, -- bool or nil
-- }

function AI_CMD_PlaceTo.ResetArgs(self, args)
	local p = args[2]
	self.args[1]:Set(p[1], p[2], p[3])
	self.args[2] = args[3]
end

function AI_CMD_PlaceTo.Construct(self, args)
	self.args[1] = args[2]:Clone()
	self.args[2] = args[3]
	return 2
end

function AI_CMD_PlaceTo.Deconstruct(self)
	self.args[1]:Destroy()
	self.args[1] = nil
end

function AI_CMD_PlaceTo.Start(self, time, deltaTime, creature)
	if self.args[2] then
		-- ignore nav mesh
		creature.logicTransform:PlaceTo(self.args[1])
	else
		creature.logicTransform:NavMeshPlaceTo(self.args[1])
	end
	return false -- finished
end

function AI_CMD_PlaceTo.End(self, time, deltaTime, creature)
	
end

function AI_CMD_PlaceTo.Update(self, time, deltaTime, creature)
	
end

function AI_CMD_PlaceTo.ToString()
	return "AI_CMD_PlaceTo",AI_CMD_PlaceTo
end