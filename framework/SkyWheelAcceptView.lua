SkyWheelAcceptView = class("SkyWheelAcceptView", ContainerView)
SkyWheelAcceptView.ViewType = UIViewType.TeamLayer
function SkyWheelAcceptView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  SkyWheelAcceptView.super.OnExit(self)
end
function SkyWheelAcceptView:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end
function SkyWheelAcceptView:FindObj()
  self.content = self:FindGO("Content"):GetComponent(UILabel)
  self.acceptButton = self:FindGO("AcceptButton")
  self.countdown = self:FindGO("Countdown"):GetComponent(UILabel)
  local label = self:FindGO("Label", self.acceptButton):GetComponent(UILabel)
  label.fontSize = 23
  OverseaHostHelper:FixLabelOverV1(label, 3, 140)
end
function SkyWheelAcceptView:AddButtonEvt()
  self:AddClickEvent(self.acceptButton, function()
    if self.data then
      if self.totalCountdown == 0 then
        MsgManager.ShowMsgByIDTable(881)
      else
        ServiceCarrierCmdProxy.Instance:CallFerrisWheelProcessInviteCarrierCmd(self.data.targetid, CarrierCmd_pb.EFERRISACTION_AGREE, self.data.id)
        self:CloseSelf()
      end
    end
  end)
  local close = self:FindGO("CloseButton")
  self:AddClickEvent(close, function()
    ServiceCarrierCmdProxy.Instance:CallFerrisWheelProcessInviteCarrierCmd(self.data.targetid, CarrierCmd_pb.EFERRISACTION_DISAGREE, self.data.id)
    self:CloseSelf()
  end)
end
function SkyWheelAcceptView:AddViewEvt()
  self:AddListenEvt(SkyWheel.CloseAccept, self.CloseSelf)
end
function SkyWheelAcceptView:InitShow()
  if self.viewdata.viewdata then
    self.data = self.viewdata.viewdata
    if self.data.targetname then
      local dateLand = Table_DateLand[self.data.id]
      self.content.text = string.format(ZhString.SkyWheel_Accept, self.data.targetname, dateLand.Name or "")
      self.totalCountdown = dateLand.countdown
      if self.timeTick == nil then
        self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self)
      end
    end
  end
end
function SkyWheelAcceptView:UpdateCountDown()
  local count = self.totalCountdown - 1
  if count >= 0 then
    self.totalCountdown = count
  else
    TimeTickManager.Me():ClearTick(self)
  end
  self.countdown.text = string.format(ZhString.SkyWheel_Countdown, tostring(self.totalCountdown))
end
