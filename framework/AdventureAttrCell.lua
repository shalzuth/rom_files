local baseCell = autoImport("BaseCell")
AdventureAttrCell = class("AdventureAttrCell", baseCell)
function AdventureAttrCell:Init()
  self:initView()
end
function AdventureAttrCell:initView()
  self.name = self:FindChild("name"):GetComponent(UILabel)
  self.value = self:FindChild("value"):GetComponent(UILabel)
end
function AdventureAttrCell:SetData(data)
  local value = data.value
  local propStaticData = data.prop
  local name = propStaticData.PropName
  if propStaticData.IsPercent == 1 then
    local tmp = string.format("%.1f", value * 100)
    value = tmp .. "%"
  else
    value = math.floor(value)
  end
  self.name.text = name
  self.value.text = "+" .. value
end
