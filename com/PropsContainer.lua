autoImport("Props")

PropsContainer = class("PropsContainer",Props)

-- function PropsContainer:ctor(configs,createAll)
-- 	self.props = {}
-- 	self.propsMapId = {}
-- 	-- print(configs)
-- 	self.configs = configs
-- 	if(createAll == true) then
-- 		self:InitAllProps()
-- 	end
-- end

-- function PropsContainer:InitAllProps()
-- 	for _, o in pairs(self.configs) do
-- 		self:InitProp(o)
-- 	end
-- end

-- function PropsContainer:InitProp(propVO)
-- 	local p = Prop.new(propVO)
-- 	self.props[propVO.name] = p
-- 	self.propsMapId[propVO.id] = p
-- end

function PropsContainer:AddProps( props )
	-- body
end

function PropsContainer:RemoveProps( props )
	-- body
end

--通过配置的属性ID获取属性prop
function PropsContainer:GetPropByID( id )
	return PropsContainer.super.GetPropByID(self,id)
end

--通过配置的属性ID获取属性值
function PropsContainer:GetValueByID( id )
	local p = self:GetPropByID(id)
	if(p == nil) then
		return 0
	end
	return p:GetValue()
end

--通过配置的属性字段获取属性prop
function PropsContainer:GetPropByName( name )
	return PropsContainer.super.GetPropByName(self,name)
end

--通过配置的属性字段获取属性值
function PropsContainer:GetValueByName( name )
	local p = self:GetPropByName(name)
	if(p == nil) then
		return 0
	end
	return p:GetValue()
end