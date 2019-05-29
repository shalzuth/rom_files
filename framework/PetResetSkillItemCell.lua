local BaseCell = autoImport("BaseCell")
PetResetSkillItemCell = class("PetResetSkillItemCell", BaseCell)
function PetResetSkillItemCell:Init()
  self.name = self:FindComponent("name", UILabel)
  self.num = self:FindComponent("num", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self:AddCellClickEvent()
  OverseaHostHelper:FixLabelOverV1(self.name, 3, 140)
end
function PetResetSkillItemCell:SetData(data)
  self.data = data
  if data ~= nil then
    self.gameObject:SetActive(true)
    PetResetSkillItemCell.super.SetData(self, data)
    if data.id == "Reset_Grey" then
      self.icon.color = ColorUtil.NGUIShaderGray
      self.num.text = "[c][ff0000]1[-][/c]"
    else
      self.icon.color = ColorUtil.NGUIWhite
      self.num.text = 1
    end
    self.name.text = data.staticData.NameZh
    IconManager:SetItemIcon(data.staticData.Icon, self.icon)
  else
    self.gameObject:SetActive(false)
  end
end
