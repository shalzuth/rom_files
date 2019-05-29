ChangeCatPopUp = class("ChangeCatPopUp", ContainerView)
ChangeCatPopUp.ViewType = UIViewType.NormalLayer
autoImport("ChangeCatCell")
function ChangeCatPopUp:Init()
  self.orginalID = self.viewdata.viewdata.originalID
  self.catData = self.viewdata.viewdata.catData
  self:InitView()
  self:MapEvent()
  self:UpdateMemberCats()
end
function ChangeCatPopUp:InitView()
  local titleName = self:FindComponent("Title", UILabel)
  titleName.text = ZhString.ChangeCat_Title
  local wrapContent = self:FindGO("MemberWrap")
  local wrapConfig = {
    wrapObj = wrapContent,
    pfbNum = 5,
    cellName = "ChangeCatCell",
    control = ChangeCatCell
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.DoReplace, self)
end
function ChangeCatPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.SessionTeamMemberCatUpdateTeam, self.UpdateMemberCats)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateMemberCats)
end
function ChangeCatPopUp:DoReplace(cellCtl)
  local targetID = cellCtl.data and cellCtl.data.id
  if targetID then
    MsgManager.ConfirmMsgByID(27142, function()
      ServiceScenePetProxy.Instance:CallReplaceCatPetCmd(self.orginalID, targetID)
      self:CloseSelf()
    end, nil, nil)
  end
end
function ChangeCatPopUp:UpdateMemberCats()
  self.wraplist:UpdateInfo(self.catData)
  self.wraplist:ResetPosition()
end
