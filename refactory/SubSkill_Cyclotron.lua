local SelfClass = {}

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero
local tempQuaternion = LuaQuaternion.identity

function SelfClass.Deconstruct(self)
	local args = self.args
	if nil ~= args[12] then
		args[12]:Destroy()
		args[12] = nil
	end
	if nil ~= args[13] then
		args[13]:Destroy()
		args[13] = nil
	end
	if nil ~= args[14] then
		args[14]:Destroy()
		args[14] = nil
	end
end

function SelfClass.Start(self, endPosition)
	local args = self.args
	local effect = args[8]
	local currentPosition = effect:GetLocalPosition()

	local distance = LuaVector3.Distance(currentPosition, endPosition)
	local radius = distance*0.5

	VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
	effect:ResetLocalEulerAngles(tempVector3)

	-- init bezier
	local dirEulerAngles = tempVector3
	LuaVector3.Better_Sub(endPosition, currentPosition, dirEulerAngles)
	LuaVector3.Normalized(dirEulerAngles)

	local bezPos0 = currentPosition:Clone()
	args[12] = bezPos0
	local bezPos1 = currentPosition:Clone()
	args[13] = bezPos1

	LuaVector3.Better_Mul(dirEulerAngles, radius, tempVector3_1)
	tempVector3_1[2] = tempVector3_1[2] + distance
	bezPos1:Add(tempVector3_1)

	local bezPos2 = bezPos1:Clone()
	args[14] = bezPos2
	
	tempQuaternion:AngleAxis(90, dirEulerAngles)
	LuaVector3.Better_Sub(bezPos1, bezPos0, tempVector3_1)
	LuaQuaternion.Better_MulVector3(tempQuaternion, tempVector3_1, bezPos1)
	bezPos1:Add(bezPos0)

	tempQuaternion:AngleAxis(-90, dirEulerAngles)
	LuaVector3.Better_Sub(bezPos2, bezPos0, tempVector3_1)
	LuaQuaternion.Better_MulVector3(tempQuaternion, tempVector3_1, bezPos2)
	bezPos2:Add(bezPos0)

	effect:ResetLocalPosition(bezPos0)

	args[15] = 0 -- elapsedTime
	args[16] = false -- hited
	return true
end

function SelfClass.End(self)
	
end

function SelfClass.Update(self, endPosition, refreshed, time, deltaTime)
	local args = self.args
	args[15] = args[15] + deltaTime

	local effect = args[8]
	local currentPosition = effect:GetLocalPosition()
	
	if refreshed then
		VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
		effect:ResetLocalEulerAngles(tempVector3)
	end

	local nextPosition = tempVector3

	local emitParams = args[2]
	local t = args[15] / emitParams.duration
	if 1 < t then
		t = 1
	end
	if 0.5 > t then
		VectorUtility.Better_Bezier(
			args[12], 
			args[13], 
			endPosition, 
			nextPosition, 
			t*2)
	else
		if not args[16] then
			args[16] = true
			self:Hit(endPosition)
		end
		VectorUtility.Better_Bezier(
			endPosition, 
			args[14], 
			args[12], 
			nextPosition, 
			t*2-1)
	end
	
	
	if 1 <= t then
		return false
	else
		effect:ResetLocalPosition(nextPosition)
		return true
	end
end

return SelfClass