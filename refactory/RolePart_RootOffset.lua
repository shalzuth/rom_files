RolePart_RootOffset = class("RolePart_RootOffset", ReusableObject)

RolePart_RootOffset.PoolSize = 100

local tempVector3 = LuaVector3.zero

function RolePart_RootOffset.Create( )
	return ReusableObject.Create( RolePart_RootOffset, true, nil )
end

function RolePart_RootOffset:ctor()
	self.args = {
		[1] = nil, -- assetRole
		[2] = 0, -- part index
	}
	self.params = nil
end

function RolePart_RootOffset:SetParams(assetRole, partIndex, params)
	self.args[1] = assetRole
	self.args[2] = partIndex
	self.params = params
end

function RolePart_RootOffset:LateUpdate(time, deltaTime)
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

	local offset = params.offset
	tempVector3:Set(offset[1], offset[2], offset[3])
	local x,y,z = assetRole:GetScaleXYZ()
	VectorUtility.Better_Mul_XYZ(tempVector3,x,y,z,tempVector3)

	assetRole:TransformPoint(tempVector3, tempVector3)
	rolePartTransform.position = tempVector3

	tempVector3:Set(assetRole:GetEulerAnglesXYZ())
	rolePartTransform.eulerAngles = tempVector3
end

-- override begin
function RolePart_RootOffset:DoConstruct(asArray, args)
end

function RolePart_RootOffset:DoDeconstruct(asArray)
	self.args[1] = nil
	self.args[2] = 0
	self.params = nil
end
-- override end