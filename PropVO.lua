PropVO = class("PropVO")

PropValueType = {
	Int = "Int",
	Float = "Float",
	Bool = "Bool"
}

function PropVO:ctor()
end

function PropVO:Init(id,typeID,name,displayName,isPercent,priority,valueType,defaultValue,IsClientPercent,isSyncFloat)
	self.id = id
	self.typeID = typeID
	--???????????????atk,hp,mp..etc
	self.name = name
	--??????????????????????????????????????????????????????..etc
	self.displayName = displayName
	self.isPercent = isPercent
	self.priority = priority
	self.valueType = valueType
	self.defaultValue = defaultValue
	self.IsClientPercent = IsClientPercent
	self.isSyncFloat = isSyncFloat
end

function PropVO.Create(id,typeID,name,displayName,isPercent,priority,valueType,defaultValue,IsClientPercent,isSyncFloat)
	local data = PropVO.new()
	data:Init(id,typeID,name,displayName,isPercent,priority,valueType,defaultValue,IsClientPercent,isSyncFloat)
	return data
end

-- return PropVO