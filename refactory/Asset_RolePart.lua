Asset_RolePart = class("Asset_RolePart", ReusableObject)

if not Asset_RolePart.Asset_RolePart_Inited then
	Asset_RolePart.Asset_RolePart_Inited = true
	Asset_RolePart.PoolSize = 10
end

local tempArgs = {
	0, -- Asset_Role.PartIndex
	0, -- ID
	nil, -- parent
	LuaVector3.zero, -- local Position
	LuaVector3.zero, -- local Rotation
	LuaVector3.one, -- local Scale
	nil, -- callback
	nil, -- callbackArg
}

function Asset_RolePart.Create( partIndex, ID, callback, callbackArg )
	tempArgs[1] = partIndex
	tempArgs[2] = ID
	tempArgs[3] = nil
	tempArgs[4]:Set(0,0,0)
	tempArgs[5]:Set(0,0,0)
	tempArgs[6]:Set(1,1,1)
	tempArgs[7] = callback
	tempArgs[8] = callbackArg
	return ReusableObject.Create( Asset_RolePart, true, tempArgs )
end

function Asset_RolePart:ctor()
	self.args = {}
	Asset_RolePart.super.ctor(self)
end

function Asset_RolePart:SetLayer(layer)
	self.args[11] = layer
	if nil ~= self.args[9] then
		self.args[9].layer = layer
	end
end

function Asset_RolePart:ResetParent(parent)
	self.args[3] = parent
	if nil ~= self.args[9] then
		self.args[9].transform:SetParent(parent, false)
	end
end

function Asset_RolePart:ResetLocalPositionXYZ(x, y, z)
	self.args[4]:Set(x, y, z)
	if nil ~= self.args[9] then
		self.args[9].transform.localPosition = self.args[4]
	end
end
function Asset_RolePart:ResetLocalPosition(p)
	self:ResetLocalPositionXYZ(p[1], p[2], p[3])
end

function Asset_RolePart:ResetLocalEulerAnglesXYZ(x, y, z)
	self.args[5]:Set(x, y, z)
	if nil ~= self.args[9] then
		self.args[9].transform.localEulerAngles = self.args[5]
	end
end

function Asset_RolePart:RotateDelta(y)
	local vector = self.args[5]
	self.args[5]:Set(vector.x, vector.y+y, vector.z)
	if nil ~= self.args[9] then
		self.args[9].transform.localEulerAngles = self.args[5]
	end
end

function Asset_RolePart:ResetLocalEulerAngles(p)
	self:ResetLocalEulerAnglesXYZ(p[1], p[2], p[3])
end

function Asset_RolePart:ResetLocalScaleXYZ(x, y, z)
	self.args[6]:Set(x, y, z)
	if nil ~= self.args[9] then
		self.args[9].transform.localScale = self.args[6]
	end
end

function Asset_RolePart:ResetLocalScale(p)
	self:ResetLocalScaleXYZ(p[1], p[2], p[3])
end

function Asset_RolePart:_ResetRolePart()
	local rolePart = self.args[9]
	local objTransform = rolePart.transform
	objTransform.parent = self.args[3]
	objTransform.localPosition = self.args[4]
	objTransform.localEulerAngles = self.args[5]
	objTransform.localScale = self.args[6]
	
	rolePart.layer = self.args[11]
end

function Asset_RolePart:_Destroy()
	if nil ~= self.args[9] then
		self.assetManager:DestroyPart(self.args[1], self.args[2], self.args[9])
		self.args[9] = nil
	end
end

function Asset_RolePart:_CancelLoading()
	if nil ~= self.args[10] then
		self.assetManager:CancelCreatePart(self.args[1], self.args[2], self.args[10])
		self.args[10] = nil
	end
end

function Asset_RolePart:OnPartCreated( tag, obj, part, ID )
	if self.args[10] ~= tag then
		self.assetManager:DestroyPart(part, ID, obj)
		return
	end
	self.args[10] = nil
	if nil == obj then
		LogUtility.WarningFormat("Load Role Part Failed: part={0}, ID={1}", part, ID)
		return
	end
	obj.gameObject:SetActive(true)
	self.args[9] = obj
	self:_ResetRolePart()

	if nil ~= self.args[7] then
		self.args[7](obj, self.args[8])
		self:RemoveCreatedCallBack()
	end
end

function Asset_RolePart:RemoveCreatedCallBack()
	self.args[7] = nil -- callback
	self.args[8] = nil -- callbackArg
end

-- override begin
function Asset_RolePart:DoConstruct(asArray, args)
	self.assetManager = Game.AssetManager_Role

	self.args[1] = args[1] -- partIndex
	self.args[2] = args[2] -- ID
	self.args[3] = args[3]
	self.args[4] = args[4]:Clone()
	self.args[5] = args[5]:Clone()
	self.args[6] = args[6]:Clone()
	self.args[7] = args[7] -- callback
	self.args[8] = args[8] -- callbackArg
	self.args[9] = nil -- rolePart

	self.args[10] = nil
	self.args[11] = 0 -- layer
	local loadTag = self.assetManager:CreatePart(
		args[1], 
		args[2], 
		self.OnPartCreated, 
		self)
	self.args[10] = loadTag
end

function Asset_RolePart:DoDeconstruct(asArray)
	self:_CancelLoading()
	self:_Destroy()
	self.args[3] = nil
	self.args[4]:Destroy()
	self.args[5]:Destroy()
	self.args[6]:Destroy()
	self:RemoveCreatedCallBack()
end
-- override end