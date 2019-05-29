autoImport("BoothSellInfoCell")
autoImport("BoothCancelInfoCell")
autoImport("BoothResellInfoCell")
autoImport("BoothIntroduceCell")
autoImport("ExchangeIntroduceData")
BoothSellInfoView = class("BoothSellInfoView", ContainerView)
BoothSellInfoView.ViewType = UIViewType.PopUpLayer
local BoothTradeType = BoothProxy.TradeType.Booth
function BoothSellInfoView:OnExit()
  if self.infoCell then
    self.infoCell:Exit()
  end
  if self.introCell then
    self.introCell:OnDestroy()
  end
  BoothSellInfoView.super.OnExit(self)
end
function BoothSellInfoView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
end
function BoothSellInfoView:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.scrollView = self:FindGO("ScrollView").transform
  self.helpBtn = self:FindGO("HelpButton")
end
function BoothSellInfoView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd, self.RecvItemPrice)
  self:AddListenEvt(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd, self.RecvInfo)
end
function BoothSellInfoView:InitShow()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local sellType = viewdata.type
    local itemdata = viewdata.data
    local boothItemData = viewdata.boothItemData
    self.name.text = itemdata.staticData.NameZh
    FunctionItemTrade.Me():GetTradePrice(itemdata, true, true, BoothTradeType)
    if sellType == ShopMallExchangeSellEnum.Sell then
      local infoGo = self:LoadPreferb("cell/BoothSellInfoCell")
      self.infoCell = BoothSellInfoCell.new(infoGo)
    elseif sellType == ShopMallExchangeSellEnum.Cancel then
      if itemdata.staticData.MaxNum == 1 then
        go = self:LoadPreferb("cell/CancelSellNotOverLapCell")
      else
        go = self:LoadPreferb("cell/CancelSellOverLapCell")
      end
      self.infoCell = BoothCancelInfoCell.new(go)
      if boothItemData ~= nil then
        self.infoCell:SetOrderId(boothItemData.orderId)
      end
      ServiceRecordTradeProxy.Instance:CallItemSellInfoRecordTradeCmd(nil, nil, nil, nil, nil, nil, nil, nil, boothItemData.orderId, BoothTradeType)
    elseif sellType == ShopMallExchangeSellEnum.Resell then
      local infoGo = self:LoadPreferb("cell/BoothResellInfoCell")
      self.infoCell = BoothResellInfoCell.new(infoGo)
      if boothItemData ~= nil then
        self.infoCell:SetOrderId(boothItemData.orderId)
      end
      ServiceRecordTradeProxy.Instance:CallItemSellInfoRecordTradeCmd(nil, nil, nil, nil, nil, nil, nil, nil, boothItemData.orderId, BoothTradeType)
    end
    self.infoCell:SetData(itemdata)
    self.infoCell:AddEventListener(BoothEvent.CloseInfo, self.CloseSelf, self)
    self.infoCell:AddEventListener(BoothEvent.ChangeInfo, self.ChangeInfo, self)
    self.introData = ExchangeIntroduceData.new()
  end
end
function BoothSellInfoView:ChangeInfo(cell)
  if self.introCell ~= nil then
    self.introCell:UpdateQuota(cell:GetPrice(), cell.count)
  end
end
function BoothSellInfoView:RecvItemPrice(note)
  local data = note.body
  local viewdata = self.viewdata.viewdata
  if data and viewdata and data.trade_type == BoothTradeType then
    local sellType = viewdata.type
    local itemdata = viewdata.data
    local boothItemData = viewdata.boothItemData
    if data.itemData and data.itemData.base and itemdata.staticData.id ~= data.itemData.base.id then
      return
    end
    local priceRate = 1
    local statetype = data.statetype
    local boothItemData = viewdata.boothItemData
    if boothItemData ~= nil then
      priceRate = boothItemData:GetPriceRate()
      if sellType == ShopMallExchangeSellEnum.Cancel then
        if boothItemData.publicityId ~= 0 then
          statetype = ShopMallStateTypeEnum.InPublicity
        else
          statetype = ShopMallStateTypeEnum.OverlapNormal
        end
      end
    end
    local _BoothConfig = GameConfig.Booth
    local go, downrate, uprate
    if (sellType == ShopMallExchangeSellEnum.Sell or sellType == ShopMallExchangeSellEnum.Resell) and statetype == ShopMallStateTypeEnum.InPublicity then
      statetype = ShopMallStateTypeEnum.WillPublicity
    end
    if statetype == ShopMallStateTypeEnum.WillPublicity then
      self:UpdateHelp(sellType)
      downrate = _BoothConfig.downrate_publicity_max
      uprate = _BoothConfig.uprate_publicity_max
      go = self:LoadPreferb("cell/BoothSellWillPublicityCell", self.scrollView)
      self.infoCell:SetStateType(statetype)
    elseif statetype == ShopMallStateTypeEnum.InPublicity then
      self:UpdateHelp(sellType)
      downrate = _BoothConfig.downrate_publicity_max
      uprate = _BoothConfig.uprate_publicity_max
      go = self:LoadPreferb("cell/BoothSellPublicityCell", self.scrollView)
      self.infoCell:SetStateType(statetype)
    else
      downrate = _BoothConfig.downrate_max
      uprate = _BoothConfig.uprate_max
      go = self:LoadPreferb("cell/BoothSellNormalCell", self.scrollView)
    end
    self.introData:SetData(data)
    self.introData:SetStatetype(statetype)
    self.introData:SetPriceRate(priceRate)
    self.introData:SetExchangeType(sellType)
    if boothItemData ~= nil then
      self.introData:SetCount(boothItemData.count)
      self.introData:SetEndTime(boothItemData.endTime)
    end
    if self.introCell ~= nil then
      GameObject.DestroyImmediate(self.introCell.gameObject)
      self.introCell = nil
    end
    self.introCell = BoothIntroduceCell.new(go)
    self.introCell:SetData(self.introData)
    self.infoCell:SetPriceRate(downrate, uprate)
    self.infoCell:SetPrice(data.price, priceRate, statetype)
  end
end
function BoothSellInfoView:RecvInfo(note)
  local data = note.body
  local viewdata = self.viewdata.viewdata
  if data and viewdata then
    local boothItemData = viewdata.boothItemData
    if boothItemData ~= nil and data.order_id == boothItemData.orderId then
      self.introData:SetBuyerCount(data.buyer_count)
      if self.introCell ~= nil then
        self.introCell:UpdateBuyerCount()
      end
    end
  end
end
function BoothSellInfoView:UpdateHelp(sellType)
  self.helpBtn:SetActive(sellType == ShopMallExchangeSellEnum.Sell)
end
