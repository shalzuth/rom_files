local baseCell = autoImport("BaseCell")
DailyCoinCell = class("DailyCoinCell", baseCell)
function DailyCoinCell:Init()
  self:initView()
end
function DailyCoinCell:initView()
  self.icon = self:FindComponent("Icon", UISprite)
  self.back = self:FindComponent("back", UISprite)
end
function DailyCoinCell:SetData(data)
  self.data = data
  if data.isShow then
    local itemStaticData = Table_Item[data.Id]
    local setSuc = IconManager:SetItemIcon(itemStaticData.Icon, self.icon)
    setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.icon)
  end
  self.icon.gameObject:SetActive(data.isShow)
  self.back.gameObject:SetActive(not data.isShow)
end
