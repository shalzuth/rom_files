autoImport("FriendView")
autoImport("TutorMainView")
FriendMainView = class("FriendMainView", ContainerView)
FriendMainView.ViewType = UIViewType.ChatroomLayer
FriendMainView.TabName = {
  [1] = ZhString.FriendMainView_FriendTabName,
  [2] = ZhString.FriendMainView_TutorTabName
}
function FriendMainView:OnEnter()
  FriendMainView.super.OnEnter(self)
  self:TabChangeHandler(PanelConfig.FriendView.tab)
end
function FriendMainView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function FriendMainView:FindObjs()
  self.friendRoot = self:FindGO("FriendRoot")
  self.tutorRoot = self:FindGO("TutorRoot")
  self.listTitle = self:FindGO("ListTitle"):GetComponent(UILabel)
end
function FriendMainView:AddEvts()
  local friendBtn = self:FindGO("FriendBtn")
  self.tutorBtn = self:FindGO("TutorBtn")
  self:AddTabChangeEvent(friendBtn, self.friendRoot, PanelConfig.FriendView)
  if GameConfig.SystemForbid.Tutor then
    friendBtn:SetActive(false)
    self.tutorBtn:SetActive(false)
    local bg = self:FindGO("MainBg"):GetComponent(UISprite)
    bg.leftAnchor.absolute = bg.leftAnchor.absolute + 70
    bg.rightAnchor.absolute = bg.rightAnchor.absolute + 70
  else
    self:AddTabChangeEvent(self.tutorBtn, self.tutorRoot, PanelConfig.TutorView)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_TUTOR_UNLOCK, self.tutorBtn, 2, {-12, -10})
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_STUDENT_UNLOCK, self.tutorBtn, 2, {-12, -10})
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_APPLY, self.tutorBtn, 2, {-12, -10})
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_TASK, self.tutorBtn, 2, {-12, -10})
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_GROW_REWARD, self.tutorBtn, 2, {-12, -10})
  end
  local toggleList = {
    friendBtn,
    self.tutorBtn
  }
  for i, v in ipairs(toggleList) do
    do
      local longPress = v:GetComponent(UILongPress)
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.FriendMainView, {state, i})
      end
    end
    break
  end
  self:AddEventListener(TipLongPressEvent.FriendMainView, self.HandleLongPress, self)
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  self.tabIconSpList = {}
  for i, v in ipairs(toggleList) do
    local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
    icon:SetActive(iconActive)
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    local label = GameObjectUtil.Instance:DeepFindChild(v, "NameLabel")
    label:SetActive(nameLabelActive)
    self:UpdateTutorBtn()
  end
end
function FriendMainView:AddViewEvts()
  self:AddListenEvt(RedTipProxy.UpdateRedTipEvent, self.UpdateRedTip)
  self:AddListenEvt(RedTipProxy.UpdateParamEvent, self.UpdateRedTip)
  self:AddListenEvt(ServiceEvent.SessionSocialityTutorFuncStateNtfSocialCmd, self.UpdateTutorBtn)
end
function FriendMainView:InitShow()
  self:AddSubView("FriendView", FriendView)
  self.tutorMainView = self:AddSubView("TutorMainView", TutorMainView)
end
function FriendMainView:TabChangeHandler(key)
  if FriendMainView.super.TabChangeHandler(self, key) then
    if key == PanelConfig.FriendView.tab then
      self.listTitle.text = ZhString.Friend_ListTitle
      self:ShowFriend(true)
    elseif key == PanelConfig.TutorView.tab then
      self.listTitle.text = ZhString.Tutor_Title
      self:ShowFriend(false)
      self.tutorMainView:ChangeView()
    end
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end
function FriendMainView:ShowFriend(isShow)
  self.friendRoot:SetActive(isShow)
  self.tutorRoot:SetActive(not isShow)
end
function FriendMainView:UpdateRedTip(note)
  local data = note.body
  if data and data.id == SceneTip_pb.EREDSYS_TUTOR_TASK and self.tutorMainView.lastView ~= nil then
    self.tutorMainView.lastView:UpdateView()
  end
end
function FriendMainView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    if isPressing then
      local backgroundSp = self.coreTabMap[index].go:GetComponent(UISprite)
      TipManager.Instance:TryShowHorizontalTabNameTip(FriendMainView.TabName[index], backgroundSp, NGUIUtil.AnchorSide.Left)
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
function FriendMainView:ResetTabIconColor()
  for i, v in ipairs(self.tabIconSpList) do
    v.color = ColorUtil.TabColor_White
  end
end
function FriendMainView:SetCurrentTabIconColor(currentTabGo)
  self:ResetTabIconColor()
  if not currentTabGo then
    return
  end
  local iconSp = GameObjectUtil.Instance:DeepFindChild(currentTabGo, "Icon"):GetComponent(UISprite)
  if not iconSp then
    return
  end
  iconSp.color = ColorUtil.TabColor_DeepBlue
end
function FriendMainView:UpdateTutorBtn()
  helplog("FriendMainView:UpdateTutorBtn", TutorProxy.Instance:GetFuncState())
  if not TutorProxy.Instance:GetFuncState() then
    self.tutorBtn:SetActive(false)
  else
    self.tutorBtn:SetActive(true)
  end
end
