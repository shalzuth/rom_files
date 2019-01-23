
AI_CMD_MoveToHelper = {}

function AI_CMD_MoveToHelper.Start(self, time, deltaTime, creature, p, ignoreNavMesh, range)
	if nil ~= range then
		if VectorUtility.DistanceXZ(creature:GetPosition(), p) <= range then
			return false
		end
	end
	if ignoreNavMesh then
		creature:Logic_MoveTo(p)
	else
		if not creature:Logic_NavMeshMoveTo(p) then
			--maybe creature is in collider,try one more time
			creature:Logic_NavMeshPlaceTo(creature:GetPosition())
			if not creature:Logic_NavMeshMoveTo(p) then
				return false
			end
		end
	end
	creature:Logic_PlayAction_Move()
	return true
end

function AI_CMD_MoveToHelper.End(self, time, deltaTime, creature)
	creature:Logic_StopMove()
end

-- return arrived
function AI_CMD_MoveToHelper.Update(self, time, deltaTime, creature, ignoreNavMesh, range)
	if nil ~= creature.logicTransform.targetPosition then
		if nil ~= range then
			if VectorUtility.DistanceXZ(creature:GetPosition(), creature.logicTransform.targetPosition) <= range then
				self:End(time, deltaTime, creature)
				return true
			end
		end
		if not ignoreNavMesh then
			creature:Logic_SamplePosition(time)
		end
	else
		self:End(time, deltaTime, creature)
		return true
	end
	return false
end

local Helper = AI_CMD_MoveToHelper

AI_CMD_MoveTo = {}

-- Args = {
-- 	[1] = AI_CMD_MoveTo,
-- 	see self.args below
-- }

-- self.args = {
-- 	[1] = position, -- LuaVector3
-- 	[2] = ignoreNavMesh, -- bool or nil
-- }

function AI_CMD_MoveTo.ResetArgs(self, args)
	local p = args[2]
	self.args[1]:Set(p[1], p[2], p[3])
	self.args[2] = args[3]
end

function AI_CMD_MoveTo.Construct(self, args)
	self.args[1] = args[2]:Clone()
	self.args[2] = args[3]
	return 2
end

function AI_CMD_MoveTo.Deconstruct(self)
	self.args[1]:Destroy()
	self.args[1] = nil
end

function AI_CMD_MoveTo.Start(self, time, deltaTime, creature)
	return Helper.Start(
		self, time, deltaTime, creature, 
		self.args[1], self.args[2])
end

function AI_CMD_MoveTo.End(self, time, deltaTime, creature)
	Helper.End(self, time, deltaTime, creature)
end

function AI_CMD_MoveTo.Update(self, time, deltaTime, creature)
	Helper.Update(self, time, deltaTime, creature, self.args[2])
end

function AI_CMD_MoveTo.ToString()
	return "AI_CMD_MoveTo",AI_CMD_MoveTo
end