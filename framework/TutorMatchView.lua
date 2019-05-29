TutorMatchView = class("TutorMatchView", ContainerView)
TutorMatchView.ViewType = UIViewType.PopUpLayer
local viewName = "view/TutorMatchView"
local joinRoomType = PvpProxy.Type
local pinkTop = LuaColor.New(1, 0.4823529411764706, 0.6431372549019608, 1)
local pinkBottom = LuaColor.New(1, 0.7137254901960784, 0.807843137254902, 1)
local blueTop = LuaColor.New(0.3686274509803922, 0.5725490196078431, 0.9254901960784314, 1)
local blueBottom = LuaColor.New(0.6235294117647059, 0.7450980392156863, 0.9333333333333333, 1)
local studentColor = LuaColor.New(0.47058823529411764, 0.5647058823529412, 0.9568627450980393)
local tutorColor = LuaColor.New(1, 0.8941176470588236, 0.5294117647058824)
function TutorMatchView:Init()
  self.tutorType = self.viewdata and self.viewdata.viewdata
  self:FindObj()
  self:AddViewEvt()
  self:AddCloseButtonEvent()
end
function TutorMatchView:FindObj()
  self.tweenScale = self.gameObject:GetComponent(TweenScale)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.begin = self:FindGO("Begin")
  self.ongoing = self:FindGO("OnGoing")
  local status = TutorProxy.Instance:GetTutorMatStatus()
  if status ~= TutorProxy.TutorMatchStatus.Start then
    self.begin:SetActive(true)
    self.ongoing:SetActive(false)
    self.tip = self:FindGO("tip"):GetComponent(UILabel)
    local male = self:FindGO("maleBG")
    self.maleCheck = self:FindGO("check", male):GetComponent(UIToggle)
    local female = self:FindGO("femaleBG")
    self.femaleCheck = self:FindGO("check", female):GetComponent(UIToggle)
    EventDelegate.Add(self.femaleCheck.onChange, function()
      self:OnToggleChange()
    end)
    EventDelegate.Add(self.maleCheck.onChange, function()
      self:OnToggleChange()
    end)
    self.maleSymbol = self:FindGO("symbol", male):GetComponent(GradientUISprite)
    self.femaleSymbol = self:FindGO("symbol", female):GetComponent(GradientUISprite)
    local button = self:FindGO("button")
    self:AddClickEvent(button, function()
      self:Match()
    end)
    self.btnLabel = self:FindGO("btnLabel"):GetComponent(UILabel)
    self:InitBeginShow()
    self.tweenScale:SetOnFinished(self.super.CloseSelf)
    self:AddButtonEvent("CloseButton", function(go)
      self:ScaleDown()
    end)
  else
    self.begin:SetActive(false)
    self.ongoing:SetActive(true)
    local cancelBtn = self:FindGO("cancelBtn")
    self:AddClickEvent(cancelBtn, function()
      self:Cancel()
    end)
    self:AddButtonEvent("CloseButton", function(go)
      self.super:CloseSelf()
    end)
    self:InitOngoingShow()
  end
end
function TutorMatchView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd, self.super.CloseSelf)
end
function TutorMatchView:InitBeginShow()
  if self.tutorType == TutorType.Student then
    self:SetupStudent()
  elseif self.tutorType == TutorType.Tutor then
    self:SetupTutor()
  end
end
function TutorMatchView:InitOngoingShow()
  if not self.ongoingTip then
    self.ongoingTip = self:FindGO("OngoingTip"):GetComponent(UILabel)
  end
  if self.tutorType == TutorType.Student then
    self.title.text = ZhString.Tutor_Guide_FindStudent
    self.ongoingTip.text = string.format(ZhString.Tutor_Matching, ZhString.Tutor_Student)
    self.ongoingTip.color = tutorColor
  elseif self.tutorType == TutorType.Tutor then
    self.title.text = ZhString.Tutor_Chat_FindTutor
    self.ongoingTip.text = string.format(ZhString.Tutor_Matching, ZhString.Tutor_Title)
    self.ongoingTip.color = studentColor
  end
end
function TutorMatchView:SetupStudent()
  self.title.text = ZhString.Tutor_Guide_FindStudent
  self.tip.text = string.format(ZhString.Tutor_MatchSelect, ZhString.Tutor_Student)
  self.btnLabel.text = ZhString.Tutor_Guide_FindStudent
end
function TutorMatchView:SetupTutor()
  self.title.text = ZhString.Tutor_Chat_FindTutor
  self.tip.text = string.format(ZhString.Tutor_MatchSelect, ZhString.Tutor_Title)
  self.btnLabel.text = ZhString.Tutor_Chat_FindTutor
end
function TutorMatchView:OnToggleChange()
  if self.maleCheck.value then
    self.maleSymbol.gradientTop = blueTop
    self.maleSymbol.gradientBottom = blueBottom
    self.femaleSymbol.gradientTop = LuaColor.white
    self.femaleSymbol.gradientBottom = LuaColor.white
  else
    self.maleSymbol.gradientTop = LuaColor.white
    self.maleSymbol.gradientBottom = LuaColor.white
    self.femaleSymbol.gradientTop = pinkTop
    self.femaleSymbol.gradientBottom = pinkBottom
  end
end
function TutorMatchView:Match()
  if self.maleCheck.value then
    self.selection = 1
  elseif self.femaleCheck.value then
    self.selection = 2
  end
  local msg = {}
  msg.findtutor = self.tutorType == TutorType.Tutor
  msg.gender = self.selection
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(joinRoomType.TutorMatch, nil, nil, nil, nil, nil, nil, nil, nil, msg)
end
function TutorMatchView:Cancel()
  ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(joinRoomType.TutorMatch)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, self)
end
function TutorMatchView:ScaleDown()
  local scaleTime = 0.5
  self.tweenScale.duration = scaleTime
  self.tweenScale:PlayForward()
end
