MvpMatchView = class("MvpMatchView", ContainerView)
MvpMatchView.ViewType = UIViewType.NormalLayer
function MvpMatchView:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
  self:AddCloseButtonEvent()
end
function MvpMatchView:FindObjs()
  self.content1 = self:FindGO("content1"):GetComponent(UIRichLabel)
  self.content2 = self:FindGO("content2"):GetComponent(UIRichLabel)
  self.matchBtn = self:FindGO("MatchBtn")
end
function MvpMatchView:AddEvts()
  self:AddClickEvent(self.matchBtn, function()
    self:ClickMatchButton()
  end)
  self:AddListenEvt(ServiceEvent.MatchCCmdJoinRoomCCmd, self.CloseSelf)
end
function MvpMatchView:InitShow()
  self.content1.text = ZhString.MVPMatch_tip1
  self.content2.text = string.format(ZhString.MVPMatch_tip2, GameConfig.MvpBattle.ActivityTime)
end
function MvpMatchView:ClickMatchButton()
  if PvpProxy.Instance:CheckMvpMatchValid() then
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.MvpFight)
  end
end
