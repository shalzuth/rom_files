autoImport("EquipProps")
autoImport("PropsContainer")
RolePropsContainer = reusableClass("RolePropsContainer", PropsContainer)
RolePropsContainer.PoolSize = 250
if not ClassNeedGetSet then
  function RolePropsContainer.__index(t, k)
    if RolePropsContainer[k] == nil and RolePropsContainer.config ~= nil then
      local vo = RolePropsContainer.config[k]
      if vo ~= nil then
        local p = Prop.new(vo)
        t[k] = p
        return p
      end
    end
    return RolePropsContainer[k]
  end
else
  local superIndex = RolePropsContainer.__index
  function RolePropsContainer.__index(t, k)
    local r = superIndex(t, k)
    if r ~= nil then
      return r
    end
    if RolePropsContainer[k] == nil and RolePropsContainer.config ~= nil then
      local vo = RolePropsContainer.config[k]
      if vo ~= nil then
        local p = Prop.new(vo)
        t[k] = p
        return p
      end
    end
    return RolePropsContainer[k]
  end
  break
end
RolePropsContainer.Protocol = Prop.new()
function RolePropsContainer:ctor()
  RolePropsContainer.super.ctor(self)
  self.configs = RolePropsContainer.config
end
function RolePropsContainer:DoConstruct(asArray, parts)
  self:Reset()
end
function RolePropsContainer:DoDeconstruct(asArray)
end
