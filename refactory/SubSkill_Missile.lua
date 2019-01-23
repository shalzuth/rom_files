local SelfClass = {}

local AngleRange = 150
local StartFactor = {0,0}
-- self.args[2] = Table_Skill/Logic_Param/emit
local ControlFactor = {8.5,5.0}

local FindCreature = SceneCreatureProxy.FindCreature
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
	args[14] = nil
end

function SelfClass.Start(self, endPosition)
	local args = self.args

	local emitParams = args[2]

	local effect = args[8]
	local currentPosition = effect:GetLocalPosition()

	VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
	effect:ResetLocalEulerAngles(tempVector3)

	-- init bezier
	local dirEulerAngles = tempVector3
	LuaVector3.Better_Sub(endPosition, currentPosition, dirEulerAngles)
	LuaVector3.Normalized(dirEulerAngles)
	dirEulerAngles:Mul(-1)

	local bezPos0 = currentPosition:Clone()
	args[12] = bezPos0
	local bezPos1 = currentPosition:Clone()
	args[13] = bezPos1

	LuaVector3.Better_Mul(dirEulerAngles, StartFactor[1], tempVector3_1)
	tempVector3_1[2] = tempVector3_1[2] + StartFactor[2]
	bezPos0:Add(tempVector3_1)

	local custom_controlfactor = emitParams.controlfactor;
	if(custom_controlfactor)then
		LuaVector3.Better_Mul(dirEulerAngles, math.min(custom_controlfactor[1] , tempVector3.magnitude * 0.75), tempVector3_1)
		tempVector3_1[2] = tempVector3_1[2] + custom_controlfactor[2]
		bezPos1:Add(tempVector3_1)
	else
		LuaVector3.Better_Mul(dirEulerAngles, ControlFactor[1], tempVector3_1)
		tempVector3_1[2] = tempVector3_1[2] + ControlFactor[2]
		bezPos1:Add(tempVector3_1)
	end
	
	if(emitParams.nooffset ~= 1)then
		local emitIndex = args[6]
		local emitCount = args[7]

		-- random angle
		local anglePiece = AngleRange/emitCount
		local angleOffset = math.random(0, anglePiece)
		local angle = anglePiece*math.floor(emitIndex/2)-anglePiece/2+angleOffset
		if 0 ~= emitIndex%2 then
			angle = -angle
		end

		if 0 ~= angle then
			tempQuaternion:AngleAxis(angle, dirEulerAngles)
			LuaVector3.Better_Sub(bezPos1, bezPos0, tempVector3_1)
			LuaQuaternion.Better_MulVector3(tempQuaternion, tempVector3_1, bezPos1)
			bezPos1:Add(bezPos0)
		end
	end

	effect:ResetLocalPosition(bezPos0)

	args[14] = 0 -- elapsedTime
	return true
end

function SelfClass.End(self)
	
end

function SelfClass.Update(self, endPosition, refreshed, time, deltaTime)
	local args = self.args
	args[14] = args[14] + deltaTime

	local effect = args[8]
	local currentPosition = effect:GetLocalPosition()
	
	if refreshed then
		VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
		effect:ResetLocalEulerAngles(tempVector3)
	end

	local nextPosition = tempVector3

	local emitParams = args[2]
	local t = args[14] / emitParams.duration
	if 1 < t then
		t = 1
	end
	VectorUtility.Better_Bezier(
		args[12], 
		args[13], 
		endPosition, 
		nextPosition, 
		t)
	
	if 1 <= t then
		-- hit
		self:Hit(endPosition)
		return false
	else
		effect:ResetLocalPosition(nextPosition)
		return true
	end
end

return SelfClass