autoImport("Props")
PropsContainer = class("PropsContainer", Props)
function PropsContainer:AddProps(props)
end
function PropsContainer:RemoveProps(props)
end
function PropsContainer:GetPropByID(id)
  return PropsContainer.super.GetPropByID(self, id)
end
function PropsContainer:GetValueByID(id)
  local p = self:GetPropByID(id)
  if p == nil then
    return 0
  end
  return p:GetValue()
end
function PropsContainer:GetPropByName(name)
  return PropsContainer.super.GetPropByName(self, name)
end
function PropsContainer:GetValueByName(name)
  local p = self:GetPropByName(name)
  if p == nil then
    return 0
  end
  return p:GetValue()
end
