local baseCell = autoImport("BaseCell")
DoujinshiButtonCell = class("DoujinshiButtonCell", baseCell)
function DoujinshiButtonCell:Init()
  self:initView()
end
function DoujinshiButtonCell:initView()
  self.activity_texture = self:FindComponent("activity_texture", UITexture)
  self.activity_label = self:FindComponent("activity_label", UILabel)
  self.holderSp = self:FindComponent("holderSp", UISprite)
end
function DoujinshiButtonCell:SetData(data)
  self.data = data
  self:Show(self.holderSp)
  self.activity_texture.gameObject:SetActive(false)
  self.activity_label.text = data.name
  IconManager:SetUIIcon(data.icon, self.holderSp)
end
