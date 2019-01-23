autoImport("Props")

ClientProps = class("ClientProps",Props)

function ClientProps:InitProp(propVO)
	local p = Prop.new(propVO)
	-- self.propsMapId[propVO.id] = p
	self[propVO.name] = p
	p.value = 0
	-- print(propVO.name)
	return p
end