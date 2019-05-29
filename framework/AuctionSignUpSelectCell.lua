AuctionSignUpSelectCell = class("AuctionSignUpSelectCell", ItemCell)
function AuctionSignUpSelectCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = Vector3.zero
  AuctionSignUpSelectCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end
function AuctionSignUpSelectCell:FindObjs()
  self.choose = self:FindGO("Choose")
end
function AuctionSignUpSelectCell:AddEvts()
  self:AddCellClickEvent()
end
function AuctionSignUpSelectCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    local itemdata = BagProxy.Instance:GetItemByGuid(data)
    if itemdata ~= nil then
      AuctionSignUpSelectCell.super.SetData(self, itemdata)
    end
  end
end
function AuctionSignUpSelectCell:SetChoose(isChoose)
  self.choose:SetActive(isChoose)
end
