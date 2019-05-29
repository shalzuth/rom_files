local BaseCell = autoImport("BaseCell")
AstrolabeView_ContrastCell = class("AstrolabeView_ContrastCell", BaseCell)
local config_PropName = Game.Config_PropName
function AstrolabeView_ContrastCell:Init()
  self.name = self:FindComponent("Name", UILabel)
  self.value = self:FindComponent("Value", UILabel)
end
function AstrolabeView_ContrastCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
  end
  self.gameObject:SetActive(true)
  local pro = config_PropName[data[1]]
  if pro == nil then
    self.gameObject:SetActive(false)
    error("not find attri:" .. tostring(data[1]))
  end
  self.name.text = pro.PropName
  if pro.IsPercent ~= 0 then
    if 0 < data[2] then
      self.value.text = "+" .. data[2] * 100 .. "%"
    else
      self.value.text = "-" .. data[2] * 100 .. "%"
    end
  elseif 0 < data[2] then
    self.value.text = "+" .. data[2]
  else
    self.value.text = "-" .. data[2]
  end
end
