
AI_CMD_SetScale = {}

-- Args = {
-- 	[1] = AI_CMD_SetScale,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = scale_x, -- float
-- 	[2] = scale_y, -- float
-- 	[3] = scale_z, -- float
-- 	[4] = no smooth, -- bool or nil
-- }

function AI_CMD_SetScale.ResetArgs(self, args)
	self.args[1] = args[2]
	self.args[2] = args[3]
	self.args[3] = args[4]
	self.args[4] = args[5]
end

function AI_CMD_SetScale.Construct(self, args)
	self.args[1] = args[2]
	self.args[2] = args[3]
	self.args[3] = args[4]
	self.args[4] = args[5]
	return 4
end

function AI_CMD_SetScale.Deconstruct(self)
	
end

function AI_CMD_SetScale.Start(self, time, deltaTime, creature)
	if self.args[4] then
		-- no smooth
		creature.logicTransform:SetScaleXYZ(self.args[1],self.args[2],self.args[3])
	else
		creature.logicTransform:ScaleToXYZ(self.args[1],self.args[2],self.args[3])
	end
	return false -- finished
end

function AI_CMD_SetScale.End(self, time, deltaTime, creature)
	
end

function AI_CMD_SetScale.Update(self, time, deltaTime, creature)
	
end

function AI_CMD_SetScale.ToString()
	return "AI_CMD_SetScale",AI_CMD_SetScale
end