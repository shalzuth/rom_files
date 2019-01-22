Logic_Transform_DirMove = class("Logic_Transform_DirMove", ReusableObject)

if not Logic_Transform_DirMove.Logic_Transform_DirMove_Inited then
	Logic_Transform_DirMove.Logic_Transform_DirMove_Inited = true
	Logic_Transform_DirMove.PoolSize = 100
end

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero

-- Args = {
-- 	[1] = dirAngleY, -- float
-- 	[2] = distance, -- float
-- 	[3] = speed, -- float
-- }

function Logic_Transform_DirMove.Create(args)
	return ReusableObject.Create( Logic_Transform_DirMove, true, args )
end

function Logic_Transform_DirMove:ctor()
	self.args = {}
end

function Logic_Transform_DirMove:Update(logicTransform, time, deltaTime)
	if not self.running then
		return
	end

	local args = self.args
	local currentPosition = logicTransform.currentPosition

	tempVector3:Set(0, 0, 1)
	local dir = VectorUtility.SelfAngleYToVector3(tempVector3, args[1])
	local ret, targetPosition = NavMeshUtility.Better_RaycastDirection(
		currentPosition, tempVector3, dir)
	if not ret then
		-- blocked
		self.running = false
		return
	end
	local restDistance = args[2] - args[4]
	if 0 >= restDistance then
		self.running = false
		return
	end
	local deltaDistance = args[3]*deltaTime
	LuaVector3.Better_MoveTowards(
		currentPosition, targetPosition, tempVector3_1, math.min(deltaDistance, restDistance))
	local movedDistance = LuaVector3.Distance(currentPosition, tempVector3_1)
	NavMeshUtility.SelfSample(tempVector3_1)
	currentPosition:Set(tempVector3_1[1], tempVector3_1[2], tempVector3_1[3])
	args[4] = args[4] + movedDistance
	if args[4] >= args[2] then
		-- finish
		self.running = false
		return
	end
end

-- override begin
function Logic_Transform_DirMove:DoConstruct(asArray, args)
	self.args[1] = args[1]
	self.args[2] = args[2]
	self.args[3] = args[3]
	self.args[4] = 0 -- moved distance

	self.running = true
end

function Logic_Transform_DirMove:DoDeconstruct(asArray)
end

function Logic_Transform_DirMove:OnObserverDestroyed(k, obj)
end
-- override end