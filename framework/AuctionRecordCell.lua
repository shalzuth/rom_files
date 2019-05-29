local baseCell = autoImport("BaseCell")
AuctionRecordCell = class("AuctionRecordCell", baseCell)
local normalItemColor = "%s%s%s"
local damageItemColor = "[c][cf1c0f]%s%s%s[-][/c]"
function AuctionRecordCell:Init()
  AuctionRecordCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end
function AuctionRecordCell:FindObjs()
  self.info = self:FindGO("Info")
  self.time = self:FindGO("Time"):GetComponent(UILabel)
  self.result = self:FindGO("Result"):GetComponent(UILabel)
  self.receiveSp = self:FindGO("ReceiveBtn"):GetComponent(UIMultiSprite)
  self.receiveLabel = self:FindGO("Label", self.receiveSp.gameObject):GetComponent(UILabel)
end
function AuctionRecordCell:AddEvts()
  self:AddClickEvent(self.receiveSp.gameObject, function()
    self:Receive()
  end)
end
function AuctionRecordCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    if data.time and data.time ~= 0 then
      self.time.text = ClientTimeUtil.GetFormatTimeStr(data.time)
    else
      self.time.text = ""
    end
    if data.status == AuctionRecordTakeState.None then
      self.receiveSp.gameObject:SetActive(false)
      self.result.gameObject:SetActive(false)
    elseif data.status == AuctionRecordTakeState.CanTake then
      self.receiveSp.gameObject:SetActive(true)
      self.result.gameObject:SetActive(false)
    elseif data.status == AuctionRecordTakeState.Took then
      self.receiveSp.gameObject:SetActive(false)
      self.result.gameObject:SetActive(true)
      self.result.text = ZhString.Auction_RecordTook
    end
    local info = ""
    if data.type == AuctionRecordState.BuySuccess then
      info = string.format(ZhString.Auction_RecordBuySuccess, data.seller, data:GetZoneid(), data:GetItemString(), StringUtil.NumThousandFormat(data.costMoney))
      self:SetVerifying()
    elseif data.type == AuctionRecordState.BuySuccessPass then
      info = string.format(ZhString.Auction_RecordBuySuccess, data.seller, data:GetZoneid(), data:GetItemString(), StringUtil.NumThousandFormat(data.costMoney))
      self:SetReceiveBtn(ZhString.Auction_RecordTakeItem, 1)
    elseif data.type == AuctionRecordState.BuySuccessNoPass then
      info = string.format(ZhString.Auction_RecordBuyNoPass, data:GetItemString(), StringUtil.NumThousandFormat(data.costMoney))
      self:SetReceiveBtn(ZhString.Auction_RecordTakeItem, 1)
    elseif data.type == AuctionRecordState.SellSucess then
      info = string.format(ZhString.Auction_RecordSellSucess, data:GetItemString(), data.buyer, data:GetZoneid(), StringUtil.NumThousandFormat(data.tax), StringUtil.NumThousandFormat(data.getMoney))
      self:SetVerifying()
    elseif data.type == AuctionRecordState.SellSucessPass then
      info = string.format(ZhString.Auction_RecordSellSucess, data:GetItemString(), data.buyer, data:GetZoneid(), StringUtil.NumThousandFormat(data.tax), StringUtil.NumThousandFormat(data.getMoney))
      self:SetReceiveBtn(ZhString.Auction_RecordTakeMoney, 0)
    elseif data.type == AuctionRecordState.SellSucessNoPass then
      info = string.format(ZhString.Auction_RecordSellNoPass, data:GetItemString(), StringUtil.NumThousandFormat(data.getMoney))
      self:SetReceiveBtn(ZhString.Auction_RecordTakeItem, 1)
    elseif data.type == AuctionRecordState.SellFail then
      info = string.format(ZhString.Auction_RecordSellFail, data:GetItemString())
      self:SetReceiveBtn(ZhString.Auction_RecordRetrieveItem, 1)
    elseif data.type == AuctionRecordState.OverTakePrice then
      info = string.format(ZhString.Auction_RecordOverTakePrice, data:GetItemString(), StringUtil.NumThousandFormat(data.price))
      self:SetReceiveBtn(ZhString.Auction_RecordRetrieveMoney, 0)
    elseif data.type == AuctionRecordState.SignUp then
      self:OnDestroy()
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateSignUpInfo, self)
    elseif data.type == AuctionRecordState.SignUpSuccess then
      info = string.format(ZhString.Auction_RecordSignUpSuccess, data:GetItemString(), AuctionProxy.Instance:GetMyItemIndex(data.batchid, data.id))
    elseif data.type == AuctionRecordState.SignUpFail then
      info = string.format(ZhString.Auction_RecordSignUpFail, data:GetItemString())
      self:SetReceiveBtn(ZhString.Auction_RecordRetrieveItem, 1)
    end
    self.infoSL = SpriteLabel.new(self.info, nil, 36, 36, true)
    self.infoSL:SetText(info, true)
  end
end
function AuctionRecordCell:Receive()
  if self.data then
    helplog("CallTakeAuctionRecordCCmd", self.data.id, self.data.type)
    ServiceAuctionCCmdProxy.Instance:CallTakeAuctionRecordCCmd(self.data.id, self.data.type)
  end
end
function AuctionRecordCell:SetReceiveBtn(string, state)
  self.receiveLabel.text = string
  self.receiveSp.CurrentState = state
  if state == 0 then
    self.receiveLabel.effectColor = ColorUtil.ButtonLabelOrange
  else
    self.receiveLabel.effectColor = ColorUtil.ButtonLabelGreen
  end
end
function AuctionRecordCell:UpdateSignUpInfo()
  if self.data.type == AuctionRecordState.SignUp then
    local totalSec = AuctionProxy.Instance:GetAuctionTime() - ServerTime.CurServerTime() / 1000
    if totalSec > 0 then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
      local info = string.format(ZhString.Auction_RecordSignUp, self.data:GetItemString(), day, hour, min, sec)
      self.infoSL:SetText(info, true)
    else
      self:OnDestroy()
    end
  end
end
function AuctionRecordCell:SetVerifying()
  self.result.gameObject:SetActive(true)
  self.result.text = ZhString.Auction_RecordVerifying
end
function AuctionRecordCell:OnDestroy()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
  end
end
