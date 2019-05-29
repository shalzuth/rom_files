DesertWolfJoinView = class("DesertWolfJoinView", ContainerView)
DesertWolfJoinView.ViewType = UIViewType.PopUpLayer
function DesertWolfJoinView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
  local NameInput = self:FindGO("NameInput")
  NameInput.transform.localPosition = Vector3(-102, -64, 0)
  local teamName = self:FindGO("TeamName"):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(teamName, 3, 120)
end
function DesertWolfJoinView:FindObjs()
  self.nameInput = self:FindGO("NameInput"):GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.nameInput, 12)
end
function DesertWolfJoinView:AddEvts()
  local joinButton = self:FindGO("JoinButton", self.desertWolfView)
  self:AddClickEvent(joinButton, function()
    self:ClickJoin()
  end)
end
function DesertWolfJoinView:AddViewEvts()
end
function DesertWolfJoinView:InitShow()
  self.defaultName = string.format(ZhString.Pvp_DesertWolfJoinName, Game.Myself.data.name)
  self.nameInput.value = self.defaultName
end
function DesertWolfJoinView:ClickJoin()
  local resultStr = string.gsub(self.nameInput.value, " ", "")
  if StringUtil.ChLength(resultStr) >= 2 then
    if not FunctionMaskWord.Me():CheckMaskWord(resultStr, GameConfig.MaskWord.PvpName) then
      ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.DesertWolf, 0, resultStr)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByIDTable(958)
    end
  else
    MsgManager.ShowMsgByIDTable(883)
  end
end
