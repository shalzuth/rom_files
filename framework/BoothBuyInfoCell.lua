autoImport("BoothInfoBaseCell")
BoothBuyInfoCell = class("BoothBuyInfoCell", BoothInfoBaseCell)
function BoothBuyInfoCell:Init()
  BoothBuyInfoCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end
function BoothBuyInfoCell:FindObjs()
  BoothBuyInfoCell.super.FindObjs(self)
  self.own = self:FindGO("OwnCount")
  if self.own then
    self.own = self.own:GetComponent(UILabel)
  end
  self.sellCount = self:FindGO("SellCount")
  if self.sellCount then
    self.sellCount = self.sellCount:GetComponent(UILabel)
  end
  self.money = self:FindGO("Money")
  if self.money then
    self.money = self.money:GetComponent(UILabel)
  end
  self.discountMoney = self:FindGO("DiscountMoney"):GetComponent(UILabel)
  self.quota = self:FindGO("Quota"):GetComponent(UILabel)
end
function BoothBuyInfoCell:AddEvts()
  BoothBuyInfoCell.super.AddEvts(self)
  local cellContainer = self:FindGO("CellContainer")
  self:AddClickEvent(cellContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function BoothBuyInfoCell:InitShow()
  local quotaIcon = self:FindGO("QuotaIcon"):GetComponent(UISprite)
  local quota = Table_Item[GameConfig.Booth.quota_itemid]
  if quota ~= nil then
    IconManager:SetItemIcon(quota.Icon, quotaIcon)
  end
end
function BoothBuyInfoCell:SetData(data)
  BoothBuyInfoCell.super.SetData(self, data:GetItemData())
  self.boothItemData = data
  if data then
    self.count = 1
    self.maxCount = data.count
    self:UpdateSellCount()
    self:UpdateOwn()
    self:UpdateCount()
    self:UpdatePrice()
  end
end
function BoothBuyInfoCell:UpdateBuyPrice()
  if self.priceLabel ~= nil then
    self.priceLabel.text = StringUtil.NumThousandFormat(self.boothItemData:GetPrice())
  end
end
function BoothBuyInfoCell:UpdateMoney()
  if self.money ~= nil then
    self.money.text = StringUtil.NumThousandFormat(self:GetTotalPrice())
  end
end
function BoothBuyInfoCell:UpdateDiscountMoney()
  self.discountMoney.text = StringUtil.NumThousandFormat(BoothProxy.Instance:GetDiscountMoney(self:GetTotalPrice()))
end
function BoothBuyInfoCell:UpdateQuota()
  if BoothProxy.Instance:IsMaintenance() then
    self.quota.text = ZhString.Booth_Maintenance
  else
    self.quota.text = StringUtil.NumThousandFormat(BoothProxy.Instance:GetQuota(self:GetTotalPrice(), self:GetPublicityId()))
  end
end
function BoothBuyInfoCell:UpdateSellCount()
  if self.sellCount ~= nil then
    self.sellCount.text = self.boothItemData.count
  end
end
function BoothBuyInfoCell:UpdateOwn()
  if self.own ~= nil then
    self.own.text = BagProxy.Instance:GetItemNumByStaticID(self.boothItemData.itemid) or 0
  end
end
function BoothBuyInfoCell:UpdatePrice()
  self:UpdateBuyPrice()
  self:UpdateMoney()
  self:UpdateFinalPrice()
end
function BoothBuyInfoCell:UpdateFinalPrice()
  self:UpdateDiscountMoney()
  self:UpdateQuota()
end
function BoothBuyInfoCell:Confirm()
  self:PassEvent(BoothEvent.ConfirmInfo, self)
  self:Cancel()
end
function BoothBuyInfoCell:GetPublicityId()
  if self.stateType ~= nil and self.stateType == ShopMallStateTypeEnum.InPublicity then
    return 1
  end
  return 0
end
function BoothBuyInfoCell:GetTotalPrice()
  return self.boothItemData:GetPrice() * self.count
end
