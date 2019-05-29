autoImport("AuctionSignUpCell")
AuctionSignUpView = class("AuctionSignUpView", ContainerView)
AuctionSignUpView.ViewType = UIViewType.NormalLayer
local bgName = "auction_bg_background"
local Sort = function(l, r)
  if l:IsSigned() == r:IsSigned() then
    local lCanSignUp = l:CanSignUp()
    local rCanSignUp = r:CanSignUp()
    if lCanSignUp == rCanSignUp then
      local lcard = Table_Card[l.itemid]
      local rcard = Table_Card[r.itemid]
      if lcard ~= nil and rcard ~= nil then
        local lequip = Table_Equip[l.itemid]
        local requip = Table_Equip[r.itemid]
        if lequip ~= nil and requip ~= nil then
          return l.itemid < r.itemid
        else
          return lequip ~= nil
        end
      else
        return lcard ~= nil
      end
    else
      return lCanSignUp
    end
  else
    return l:IsSigned()
  end
end
function AuctionSignUpView:OnEnter()
  AuctionSignUpView.super.OnEnter(self)
  ServiceAuctionCCmdProxy.Instance:CallOpenAuctionPanelCCmd(true)
end
function AuctionSignUpView:OnExit()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
  ServiceAuctionCCmdProxy.Instance:CallOpenAuctionPanelCCmd(false)
  local _PictureManager = PictureManager.Instance
  _PictureManager:UnLoadAuction(bgName, self.bg)
  _PictureManager:UnLoadAuction(bgName, self.bg1)
  AuctionSignUpView.super.OnExit(self)
end
function AuctionSignUpView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function AuctionSignUpView:FindObjs()
  self.bg = self:FindGO("Background"):GetComponent(UITexture)
  self.bg1 = self:FindGO("Background1"):GetComponent(UITexture)
  self.countdown = self:FindGO("Countdown"):GetComponent(UILabel)
  self.recordBtn = self:FindGO("RecordBtn")
end
function AuctionSignUpView:AddEvts()
  local lastAuctionBtn = self:FindGO("LastAuctionBtn")
  self:AddClickEvent(lastAuctionBtn, function()
    self:LastAuction()
  end)
  self:AddClickEvent(self.recordBtn, function()
    self:Record()
  end)
end
function AuctionSignUpView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.AuctionCCmdNtfAuctionStateCCmd, self.UpdateItem)
  self:AddListenEvt(ServiceEvent.AuctionCCmdNtfSignUpInfoCCmd, self.UpdateItem)
  self:AddListenEvt(ServiceEvent.AuctionCCmdNtfMySignUpInfoCCmd, self.UpdateItem)
  self:AddListenEvt(ServiceEvent.AuctionCCmdSignUpItemCCmd, self.UpdateItem)
end
function AuctionSignUpView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local _PictureManager = PictureManager.Instance
  _PictureManager:SetAuction(bgName, self.bg)
  _PictureManager:SetAuction(bgName, self.bg1)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_AUCTION_RECORD, self.recordBtn, 3, {-5, -5})
  local contentContainer = self:FindGO("ContentContainer")
  local wrapConfig = {
    wrapObj = contentContainer,
    pfbNum = 6,
    cellName = "AuctionSignUpCell",
    control = AuctionSignUpCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleSelect, self)
  self:UpdateItem()
  if self.timeTick == nil then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self)
  end
end
function AuctionSignUpView:UpdateItem()
  local data = AuctionProxy.Instance:GetSignUpList()
  if data then
    table.sort(data, Sort)
    self.itemWrapHelper:ResetDatas(data)
  end
end
function AuctionSignUpView:UpdateCountdown()
  local auctionTime = AuctionProxy.Instance:GetAuctionTime()
  if auctionTime then
    local totalSec = auctionTime - ServerTime.CurServerTime() / 1000
    if totalSec > 0 then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
      if AuctionProxy.Instance:GetDelay() then
        self.countdown.text = string.format(ZhString.Auction_DelayCountdown, day, hour, min, sec)
      else
        self.countdown.text = string.format(ZhString.Auction_Countdown, day, hour, min, sec)
      end
    end
  end
end
function AuctionSignUpView:LastAuction()
  ServiceAuctionCCmdProxy.Instance:CallReqLastAuctionInfoCCmd()
end
function AuctionSignUpView:Record()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AuctionRecordView
  })
end
function AuctionSignUpView:HandleSelect(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
