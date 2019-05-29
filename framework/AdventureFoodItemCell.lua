autoImport("BaseCell")
AdventureFoodItemCell = class("AdventureFoodItemCell", ItemCell)
function AdventureFoodItemCell:Init()
  self.itemObj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  self.itemObj.transform.localPosition = Vector3.zero
  AdventureFoodItemCell.super.Init(self)
  self:AddCellClickEvent()
  self.unlockClient = self:FindGO("unlockClient"):GetComponent(UISprite)
  self.BagChooseSymbol = self:FindGO("BagChooseSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
end
function AdventureFoodItemCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self:Show(self.BagChooseSymbol)
    else
      self:Hide(self.BagChooseSymbol)
    end
  end
end
function AdventureFoodItemCell:SetData(data)
  self:Show(self.itemObj)
  local itemData
  if data then
    itemData = data.itemData
  end
  AdventureFoodItemCell.super.SetData(self, itemData)
  self.data = data
  self:Hide(self.unlockClient.gameObject)
  if not data then
    return
  end
  self:PassEvent(AdventureFoodPage.CheckHashSelected, self)
  self:setItemIsLock(data)
  if data.status == SceneFood_pb.EFOODSTATUS_ADD then
    self:Show(self.unlockClient.gameObject)
    self:Show(self.foodStars[0])
  elseif data.status == SceneFood_pb.EFOODSTATUS_CLICKED then
    self:Hide(self.unlockClient.gameObject)
    self:Show(self.foodStars[0])
  else
    self:Hide(self.foodStars[0])
    self:Hide(self.unlockClient.gameObject)
    local atlas = RO.AtlasMap.GetAtlas("NewCom")
    if atlas then
      self.icon.atlas = atlas
      self.icon.spriteName = "Adventure_icon_03"
      self.icon:MakePixelPerfect()
    end
    self:GetBgSprite()
    self.bg.spriteName = "com_icon_bottom6"
  end
end
local tempColor = LuaColor.white
function AdventureFoodItemCell:setItemIsLock(data)
end
function AdventureFoodItemCell:PlayUnlockEffect()
  self:PlayUIEffect(EffectMap.UI.Activation, self.effectContainer, true)
end
