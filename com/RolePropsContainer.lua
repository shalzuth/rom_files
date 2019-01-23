autoImport("EquipProps")
autoImport("PropsContainer")

RolePropsContainer = reusableClass("RolePropsContainer",PropsContainer)
RolePropsContainer.PoolSize = 250
if(not ClassNeedGetSet) then
RolePropsContainer.__index =function (t,k)
		if(RolePropsContainer[k]==nil) then
			if(RolePropsContainer.config~=nil) then
				local vo = RolePropsContainer.config[k]
				if(vo~=nil) then
					-- LogUtility.Info("Index Create prop.."..k)
					local p = Prop.new(vo)
					t[k] = p
					return p
				end
			end
		end
		return RolePropsContainer[k]
	end
else
	local superIndex = RolePropsContainer.__index
	RolePropsContainer.__index =function (t,k)
		local r = superIndex(t,k)
		if(r~=nil) then return r end
		if(RolePropsContainer[k]==nil) then
			if(RolePropsContainer.config~=nil) then
				local vo = RolePropsContainer.config[k]
				if(vo~=nil) then
					-- LogUtility.Info("Index Create prop.."..k)
					local p = Prop.new(vo)
					t[k] = p
					return p
				end
			end
		end
		return RolePropsContainer[k]
	end
end
RolePropsContainer.Protocol = Prop.new()
-- RolePropsContainer.new = function (...)
-- 	local instance = setmetatable({}, RolePropsContainer)
-- 	instance.class = RolePropsContainer
-- 	instance:ctor(...)
-- 	return instance
-- end

function RolePropsContainer:ctor()
	RolePropsContainer.super.ctor(self)
	self.configs = RolePropsContainer.config
end

-- override begin
function RolePropsContainer:DoConstruct(asArray, parts)
	self:Reset()
end

function RolePropsContainer:DoDeconstruct(asArray)
end
-- override end

-- function RolePropsContainer:SetValueById( id,value )
-- 	-- print("id:"..id.." value:"..value)
-- 	local p= self:GetPropByID(id)
-- 	stack("prop type:"..p.propVO.id.." name:"..p.propVO.displayName.."  value:"..value)
-- 	RolePropsContainer.super.SetValueById(self,id,value)
-- end