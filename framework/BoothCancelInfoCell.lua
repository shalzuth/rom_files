autoImport("BoothInfoBaseCell")
BoothCancelInfoCell = class("BoothCancelInfoCell", BoothInfoBaseCell)
function BoothCancelInfoCell:Init()
  BoothCancelInfoCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end
function BoothCancelInfoCell:FindObjs()
  BoothCancelInfoCell.super.FindObjs(self)
  self.sellCount = self:FindGO("SellCount")
  if self.sellCount then
    self.sellCount = self.sellCount:GetComponent(UILabel)
  end
  self.totalPrice = self:FindGO("TotalPrice")
  if self.totalPrice then
    self.totalPrice = self.totalPrice:GetComponent(UILabel)
  end
end
function BoothCancelInfoCell:SetData(data)
  BoothCancelInfoCell.super.SetData(self, data)
  if data then
    self.count = data.num
    self:UpdateSellCount()
  end
end
function BoothCancelInfoCell:Confirm()
  if self.isInvalid then
    return
  end
  if self.orderId == nil then
    return
  end
  if BoothProxy.Instance:IsMaintenance() then
    MsgManager.ShowMsgByID(25692)
    return
  end
  ServiceRecordTradeProxy.Instance:CallCancelItemRecordTrade(nil, Game.Myself.data.id, nil, self.orderId, BoothProxy.TradeType.Booth)
  self:PassEvent(BoothEvent.CloseInfo, self)
end
function BoothCancelInfoCell:UpdateSellCount()
  if self.sellCount ~= nil then
    self.sellCount.text = self.count
  end
end
function BoothCancelInfoCell:UpdateSellPrice()
  if self.price ~= nil then
    self.priceLabel.text = StringUtil.NumThousandFormat(self.price)
  end
end
function BoothCancelInfoCell:UpdateTotalPrice()
  if self.price ~= nil and self.totalPrice ~= nil then
    self.totalPrice.text = StringUtil.NumThousandFormat(self.price * self.count)
  end
end
function BoothCancelInfoCell:UpdatePrice()
  self:UpdateSellPrice()
  self:UpdateTotalPrice()
end
function BoothCancelInfoCell:SetOrderId(orderId)
  self.orderId = orderId
end
function BoothCancelInfoCell:SetPrice(price, priceRate, statetype)
  self.price = price * priceRate
  self:UpdatePrice()
end
function BoothCancelInfoCell:GetPrice()
  if self.price ~= nil then
    return self.price * (1 + self.priceRate / 100)
  end
  return 0
end
