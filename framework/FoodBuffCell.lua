local BaseCell = autoImport("BaseCell")
FoodBuffCell = class("FoodBuffCell", BaseCell)
function FoodBuffCell:Init()
  self:GetGameObjects()
end
function FoodBuffCell:GetGameObjects()
  self.icon = self:FindComponent("Icon", UISprite)
  self.scaleSet = self:FindGO("ScaleSet")
end
function FoodBuffCell:SetData(data)
  local itemStaticData = Table_Item[data.itemid]
  if self.icon then
    local setSuc, scale = false, Vector3.one
    if dType == 1200 then
      setSuc = IconManager:SetFaceIcon(itemStaticData.Icon, self.icon)
      setSuc = setSuc or IconManager:SetFaceIcon("boli", self.icon)
    else
      setSuc = IconManager:SetItemIcon(itemStaticData.Icon, self.icon)
      setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.icon)
    end
    if setSuc then
      self.icon.gameObject:SetActive(true)
      self.icon:MakePixelPerfect()
      self.icon.transform.localScale = self.scaleSet.transform.localScale
    else
      self.icon.gameObject:SetActive(false)
    end
  end
end
