RolePart_Damp = class("RolePart_Damp", ReusableObject)

RolePart_Damp.PoolSize = 100

local Phase_None = 0
local Phase_Follow = 1
local Phase_Idle = 2

local RotateInterval = 0.5
-- local RotateSpeed = 20
local InvalidDistance = 10

local tempVector3 = LuaVector3.zero

function RolePart_Damp.Create( )
	return ReusableObject.Create( RolePart_Damp, true, nil )
end

function RolePart_Damp:ctor()
	self.args = {
		[1] = nil, -- assetRole
		[2] = 0, -- part index
	}
	self.params = nil
	self.dampVelocity = LuaVector3.zero
	self.currentPosition = LuaVector3.zero
end

function RolePart_Damp:SetParams(assetRole, partIndex, params)
	self.args[1] = assetRole
	self.args[2] = partIndex
	self.params = params

	local rolePart = assetRole:GetPartObject(partIndex)
	if nil ~= rolePart then
		self.currentPosition:Set(LuaGameObject.GetPosition(rolePart.transform.parent))
	end
end

function RolePart_Damp:_Follow(time, deltaTime, assetRole, rolePartTransform)
	if Phase_Follow == self.phase then
		return
	end
	self.dampVelocity:Set(0,0,0)
	self.phase = Phase_Follow
end

function RolePart_Damp:_Idle(time, deltaTime, assetRole, rolePartTransform)
	if Phase_Idle == self.phase then
		return false
	end

	self.phase = Phase_Idle
	return true
end

function RolePart_Damp:LateUpdate(time, deltaTime)
	local args = self.args
	local assetRole = args[1]
	if assetRole:NoLogic() then
		return
	end
	local rolePart = assetRole:GetPartObject(args[2])
	if nil == rolePart then
		return
	end
	local params = self.params
	local rolePartTransform = rolePart.transform

	local followPosition = tempVector3
	followPosition:Set(LuaGameObject.GetPosition(rolePartTransform.parent))
	if nil ~= params.offset then
		assetRole:InverseTransformPoint(followPosition, followPosition)
		followPosition:Add(params.offset)
		assetRole:TransformPoint(followPosition, followPosition)
	end

	local distance = VectorUtility.DistanceXZ(self.currentPosition, followPosition)
	local innerRange = params.inner_range
	if innerRange > (distance-innerRange*0.1) then
		if self:_Idle(time, deltaTime, assetRole, rolePartTransform) then
			self.currentPosition:Set(LuaGameObject.GetPosition(rolePartTransform))
		else
			rolePartTransform.position = self.currentPosition
		end
	else
		if InvalidDistance < distance then
			self.currentPosition:Set(followPosition[1], followPosition[2], followPosition[3])
		else
			if params.outter_range < distance then
				self:_Follow(time, deltaTime, assetRole, rolePartTransform)
			end
			LuaVector3.SelfSmoothDamp(
				self.currentPosition, 
				followPosition, 
				self.dampVelocity,
				params.duration
				-- 9999999999,
				-- deltaTime
				)
		end
		rolePartTransform.position = self.currentPosition
	end

	tempVector3:Set(assetRole:GetEulerAnglesXYZ())
	-- local x,y,z = LuaGameObject.GetEulerAngles(rolePartTransform)
	-- tempVector3[2] = NumberUtility.MoveTowardsAngle(y, tempVector3[2], deltaTime*RotateSpeed)
	rolePartTransform.eulerAngles = tempVector3
end

-- override begin
function RolePart_Damp:DoConstruct(asArray, args)
	self.phase = Phase_None
	self.dampVelocity:Set(0,0,0)
	self.nextRotateTime = 0
end

function RolePart_Damp:DoDeconstruct(asArray)
	self.args[1] = nil
	self.args[2] = 0
	self.params = nil
end
-- override end