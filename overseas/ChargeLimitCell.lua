autoImport("BaseCell")
ChargeLimitCell = class("ChargeLimitCell", BaseCell)
function ChargeLimitCell:Init()
  ChargeLimitCell.super.Init(self)
  self.actBtn = self:FindGO("ActionBtn")
  self:AddClickEvent(self.actBtn, function(go)
    if Table_ChargeLimit[self.data.id].Count ~= nil then
      helplog("ChargeLimitPanel.SelectEvent")
      EventManager.Me():PassEvent(ChargeLimitPanel.SelectEvent, self.data.id)
    else
      helplog("ChargeLimitPanel.ClosePanel")
      ChargeComfirmPanel.left = nil
      EventManager.Me():PassEvent(ChargeLimitPanel.ClosePanel, true)
    end
  end)
end
function ChargeLimitCell:SetData(data)
  ChargeLimitCell.super.SetData(self, data)
  self.data = data
  local id = data.id
  local title = self:FindGO("title"):GetComponent(UILabel)
  title.text = data.Title
  local des = self:FindGO("des"):GetComponent(UILabel)
  des.text = data.Desc
  local avatarName = "Avatar" .. id
  self:FindGO(avatarName):SetActive(true)
end
