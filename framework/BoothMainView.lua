autoImport("BoothExchangeView")
autoImport("BoothRecordView")
autoImport("BoothChatView")
BoothMainView = class("BoothMainView", ContainerView)
BoothMainView.ViewType = UIViewType.BoothLayer
function BoothMainView:OnEnter()
  BoothMainView.super.OnEnter(self)
  self:CameraRotateToMe(false, CameraConfig.Booth_ViewPort, CameraController.singletonInstance.targetRotationEuler)
  ServiceRecordTradeProxy.Instance:CallPanelRecordTrade(Game.Myself.data.id, RecordTrade_pb.EPANEL_OPEN, BoothProxy.TradeType.Booth)
end
function BoothMainView:OnExit()
  self:CameraReset()
  ServiceRecordTradeProxy.Instance:CallPanelRecordTrade(Game.Myself.data.id, RecordTrade_pb.EPANEL_CLOSE, BoothProxy.TradeType.Booth)
  BoothMainView.super.OnExit(self)
end
function BoothMainView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function BoothMainView:FindObjs()
  self.exchangeRoot = self:FindGO("ExchangeRoot")
  self.recordRoot = self:FindGO("RecordRoot")
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.quota = self:FindGO("Quota"):GetComponent(UILabel)
  self.fadeInOut = self:FindGO("FadeInOut"):GetComponent(UISprite)
  self.btnGrid = self:FindGO("BtnGrid")
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.editName = self:FindGO("EditName")
end
function BoothMainView:AddEvts()
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    if self.isSelf and not BoothProxy.Instance:IsSimulateMode() then
      MsgManager.ConfirmMsgByID(25701, self.Close)
    else
      self:BoothClose()
    end
  end)
  self:AddClickEvent(self.fadeInOut.gameObject, function()
    self:sendNotification(BoothEvent.ShowMiniBooth, true)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.editName, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.BoothNameView,
      viewdata = {
        playerID = self.playerID
      }
    })
  end)
  local help = self:FindGO("HelpBtn")
  self:AddClickEvent(help, function()
    local helpid = 100010
    if not self.isSelf then
      helpid = 100011
    end
    local data = Table_Help[helpid]
    if data ~= nil then
      self:OpenHelpView(data)
    end
  end)
  local exchangeBtn = self:FindGO("ExchangeBtn")
  local recordBtn = self:FindGO("RecordBtn")
  self:AddTabChangeEvent(exchangeBtn, self.exchangeRoot, PanelConfig.BoothExchangeView)
  self:AddTabChangeEvent(recordBtn, self.recordRoot, PanelConfig.BoothRecordView)
end
function BoothMainView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleDataChange)
  self:AddListenEvt(ServiceEvent.NUserBoothReqUserCmd, self.HandleBoothReq)
  self:AddListenEvt(BoothEvent.ChangeName, self.UpdateName)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleMapLoaded)
end
function BoothMainView:InitShow()
  local viewdata = self.viewdata.viewdata
  if viewdata ~= nil then
    self.playerID = viewdata.playerID
  end
  self.playerID = self.playerID or Game.Myself.data.id
  self:AddSubView("BoothChatView", BoothChatView)
  self.exchangeView = self:AddSubView("BoothExchangeView", BoothExchangeView)
  self:AddSubView("BoothRecordView", BoothRecordView)
  self.isSelf = self.playerID == Game.Myself.data.id
  self.btnGrid:SetActive(self.isSelf)
  self.fadeInOut.gameObject:SetActive(self.isSelf)
  self.editName:SetActive(self.isSelf)
  self.quota.gameObject:SetActive(not self.isSelf)
  self:UpdateMoneyRoot()
  self:UpdateName()
  local quotaIcon = self:FindGO("Icon", self.quota.gameObject):GetComponent(UISprite)
  local quota = Table_Item[GameConfig.Booth.quota_itemid]
  if quota ~= nil then
    IconManager:SetItemIcon(quota.Icon, quotaIcon)
  end
end
function BoothMainView:TabChangeHandler(key)
  if BoothMainView.super.TabChangeHandler(self, key) then
    if key == PanelConfig.BoothExchangeView.tab then
      self:ShowExchange(true)
      self.exchangeView:FilterShow()
    elseif key == PanelConfig.BoothRecordView.tab then
      self:ShowExchange(false)
    end
  end
end
function BoothMainView:ShowExchange(isShow)
  self.exchangeRoot:SetActive(isShow)
  self.recordRoot:SetActive(not isShow)
  self.exchangeView:Show(isShow)
end
function BoothMainView.Close()
  ServiceNUserProxy.Instance:CallBoothReqUserCmd(nil, BoothProxy.OperEnum.Close)
end
function BoothMainView:UpdateMoney()
  self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end
function BoothMainView:UpdateQuota()
  self.quota.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetQuota())
end
function BoothMainView:UpdateMoneyRoot()
  self:UpdateMoney()
  if not self.isSelf then
    self:UpdateQuota()
  end
end
function BoothMainView:UpdateName()
  local name = BoothProxy.Instance:GetName(self.playerID)
  if name ~= nil then
    self.name.text = name
    self.editName:SetActive(self.isSelf)
  end
end
function BoothMainView:HandleDataChange(note)
  self:UpdateMoneyRoot()
  self.exchangeView:UpdateScore()
end
function BoothMainView:HandleBoothReq(note)
  local data = note.body
  if data and data.success == true then
    if data.oper == BoothProxy.OperEnum.Update then
      self:UpdateName()
    elseif data.oper == BoothProxy.OperEnum.Close then
      self:BoothClose()
    end
  end
end
function BoothMainView:HandleMapLoaded(note)
  if not BoothProxy.Instance:CanMapBooth() then
    self:CloseSelf()
  end
end
function BoothMainView:BoothClose()
  self:sendNotification(BoothEvent.ShowMiniBooth, false)
  self:CloseSelf()
end
