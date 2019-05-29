local BaseCell = autoImport("BaseCell")
BarrageFrameCell = class("BarrageFrameCell", BaseCell)
local Color_LackOfItem = Color(1, 0, 0, 1)
function BarrageFrameCell:Init()
  self.labText = self:FindComponent("Text", UILabel)
  self.objNoItem = self:FindGO("NoItem")
  self.sprCostItem = self:FindComponent("CostItem", UISprite)
  self.labItemNum = self:FindComponent("labItemNum", UILabel, self.sprCostItem.gameObject)
  self.objLock = self:FindGO("Lock")
  self.objSelect = self:FindGO("Select")
  self:AddCellClickEvent()
end
function BarrageFrameCell:SetData(data)
  self.data = data
  if self.id ~= data.id then
    FunctionBarrage.Me():CreateFrame(self.labText.gameObject, data.id)
  end
  self.id = data.id
  local colorLimit = Table_BarrageFrame[self.id].FontColorLimit
  self.labText.color = colorLimit and colorLimit ~= "" and FunctionBarrage.Me():GetColorByName(colorLimit) or LuaColor.white
  if data.CostItem and data.CostItem ~= 0 then
    self.objNoItem:SetActive(false)
    self.sprCostItem.gameObject:SetActive(true)
    IconManager:SetItemIcon(Table_Item[data.CostItem].Icon, self.sprCostItem)
    self.labItemNum.text = string.format("x%s", data.CostItemNum)
    if BagProxy.Instance:GetItemNumByStaticID(data.CostItem) < data.CostItemNum then
      self.labItemNum.color = Color_LackOfItem
    else
      self.labItemNum.color = LuaColor.black
    end
  else
    self.objNoItem:SetActive(true)
    self.sprCostItem.gameObject:SetActive(false)
  end
  local isUnLock = BarrageProxy.Instance:IsFrameUnlocked(self.id)
  self.objLock:SetActive(not isUnLock)
  self.gameObject:GetComponent(Collider).enabled = isUnLock
end
function BarrageFrameCell:SetCurFrame(curFrameID)
  self.objSelect:SetActive(curFrameID == self.id)
end
