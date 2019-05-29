autoImport("TeamPwsRankCell")
TeamPwsRankPopUp = class("TeamPwsRankPopUp", BaseView)
TeamPwsRankPopUp.ViewType = UIViewType.PopUpLayer
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}
function TeamPwsRankPopUp:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
end
function TeamPwsRankPopUp:FindObjs()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  self.inputSearch = self:FindComponent("InputSearch", UIInput)
  self.listRanks = WrapListCtrl.new(self:FindGO("rankContainer"), TeamPwsRankCell, "TeamPwsRankCell", WrapListCtrl_Dir.Verticle)
end
function TeamPwsRankPopUp:AddButtonEvt()
  self:AddClickEvent(self:FindGO("SearchButton"), function()
    self:ClickButtonSearch()
  end)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("Mask"), function()
    self:CloseSelf()
  end)
end
function TeamPwsRankPopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsRankMatchCCmd, self.HandleQueryTeamPwsRankMatchCCmd)
  self.listRanks:AddEventListener(MouseEvent.MouseClick, self.ClickCellHead, self)
end
function TeamPwsRankPopUp:HandleQueryTeamPwsRankMatchCCmd(note)
  self.data = PvpProxy.Instance:GetTeamPwsRankData()
  self:UpdateData()
end
function TeamPwsRankPopUp:UpdateData()
  self.objLoading:SetActive(false)
  if not self.data then
    return
  end
  self.objEmptyList:SetActive(#self.data < 1)
  self.listRanks:ResetDatas(self.data)
  self.listRanks:ResetPosition()
end
function TeamPwsRankPopUp:ClickButtonSearch()
  if self.objLoading.activeSelf then
    return
  end
  local input = self.inputSearch.value
  if #input > 0 then
    self.data = PvpProxy.Instance:GetTeamPwsRankSearchResult(input)
  else
    self.data = PvpProxy.Instance:GetTeamPwsRankData()
  end
  self:UpdateData()
end
function TeamPwsRankPopUp:ClickCellHead(cellCtl)
  local cellData = cellCtl.data
  if cellCtl == self.curCell or cellCtl.charID == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, {-70, 14})
  local player = PlayerTipData.new()
  player:SetByTeamPwsRankData(cellCtl.data)
  playerTip:SetData({
    playerData = player,
    funckeys = FriendProxy.Instance:IsFriend(id) and playerTipFunc_Friend or playerTipFunc
  })
  playerTip:AddIgnoreBound(cellCtl.headIcon.gameObject)
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:CloseSelf()
    end
  end
  function playerTip.closecallback()
    self.curCell = nil
  end
end
function TeamPwsRankPopUp:OnEnter()
  self.super.OnEnter(self)
  self.objLoading:SetActive(true)
  self.objEmptyList:SetActive(false)
  self.data = PvpProxy.Instance:GetTeamPwsRankData()
  if self.data then
    self:UpdateData()
  else
    ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsRankMatchCCmd()
  end
end
function TeamPwsRankPopUp:OnExit()
  PvpProxy.Instance:TeamPwsRankDataUseOver()
  self.super.OnExit(self)
end
