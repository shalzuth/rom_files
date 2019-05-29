ShopMallExchangeView = class("ShopMallExchangeView", SubView)
function ShopMallExchangeView:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end
function ShopMallExchangeView:FindObjs()
  self.exchangeView = self.container.exchangeView
  self.buyBtn = self:FindGO("BuyBtn", self.exchangeView):GetComponent(UIToggle)
  self.sellBtn = self:FindGO("SellBtn", self.exchangeView):GetComponent(UIToggle)
  self.recordBtn = self:FindGO("RecordBtn", self.exchangeView):GetComponent(UIToggle)
  self.buyLabel = self.buyBtn.gameObject:GetComponent(UILabel)
  self.sellLabel = self.sellBtn.gameObject:GetComponent(UILabel)
  self.recordLabel = self.recordBtn.gameObject:GetComponent(UILabel)
end
function ShopMallExchangeView:AddEvts()
  EventDelegate.Add(self.buyBtn.onChange, function()
    if self.buyBtn.value then
      self.buyLabel.color = ColorUtil.TitleBlue
    else
      self.buyLabel.color = ColorUtil.TitleGray
    end
  end)
  EventDelegate.Add(self.sellBtn.onChange, function()
    if self.sellBtn.value then
      self.sellLabel.color = ColorUtil.TitleBlue
      ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd(nil, Game.Myself.data.id)
    else
      self.sellLabel.color = ColorUtil.TitleGray
    end
  end)
  EventDelegate.Add(self.recordBtn.onChange, function()
    if self.recordBtn.value then
      self.recordLabel.color = ColorUtil.TitleBlue
    else
      self.recordLabel.color = ColorUtil.TitleGray
    end
  end)
end
function ShopMallExchangeView:InitShow()
  if self.viewdata.viewdata and self.viewdata.viewdata.exchange then
    if self.viewdata.viewdata.exchange == ShopMallExchangeEnum.Sell then
      self.sellBtn.value = true
    elseif self.viewdata.viewdata.exchange == ShopMallExchangeEnum.Record then
      self.recordBtn.value = true
    end
  else
    self.buyBtn.value = true
  end
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TRADE_RECORD, self.recordLabel.gameObject, nil, {5, 5})
end
