SignInQAView = class("SignInQAView", BaseView)
SignInQAView.ViewType = UIViewType.TipLayer
function SignInQAView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
  self:AddListenEvt(NewServerSignInEvent.MapViewClose, self.CloseSelf)
end
function SignInQAView:FindObjs()
  self.bgTex = self:FindComponent("Bg", UITexture)
  self.iconBgTex = self:FindComponent("IconBg", UITexture)
  self.submitButton = self:FindGO("SubmitButton")
  self.questionLabel = self:FindComponent("QuestionLabel", UILabel)
  self.toggles = {}
  self.toggleLabels = {}
  local toggleGO
  for i = 1, 2 do
    toggleGO = self:FindGO("Toggle" .. i)
    self.toggles[i] = toggleGO:GetComponent(UIToggle)
    self.toggleLabels[i] = self:FindComponent("Label", UILabel, toggleGO)
  end
end
function SignInQAView:InitShow()
  self.day = self.viewdata.viewdata
  self.answerIndex = 1
  local dayStaticData = NewServerSignInProxy.Instance:GetStaticTextDataOfDay(self.day)
  if not dayStaticData then
    LogUtility.ErrorFormat("Cannot find SignIn Data of Day {0}!", self.day)
  end
  self.questionLabel.text = dayStaticData.Question
  for i = 1, 2 do
    self.toggleLabels[i].text = dayStaticData["Choice" .. i]
  end
end
function SignInQAView:AddEvents()
  self:AddClickEvent(self.submitButton, function()
    local dayStaticData = NewServerSignInProxy.Instance:GetStaticTextDataOfDay(self.day)
    if not dayStaticData then
      return
    end
    if self.answerIndex == tonumber(dayStaticData.Answer) then
      MsgManager.ShowMsgByID(28012)
      self:sendNotification(NewServerSignInEvent.RemoveBarrier)
    else
      MsgManager.ShowMsgByID(28013)
    end
    self:CloseSelf()
  end)
  for i = 1, 2 do
    EventDelegate.Add(self.toggles[i].onChange, function()
      if self.toggles[i].value then
        self.answerIndex = i
      end
    end)
    break
  end
end
function SignInQAView:OnEnter()
  SignInQAView.super.OnEnter(self)
  self.bgTexName = "sign_bg_boli"
  self.iconBgTexName = "guild_bg_05"
  PictureManager.Instance:SetUI(self.bgTexName, self.bgTex)
  PictureManager.Instance:SetGuildBuilding(self.iconBgTexName, self.iconBgTex)
end
function SignInQAView:OnExit()
  PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTex)
  PictureManager.Instance:UnloadGuildBuilding(self.iconBgTexName, self.iconBgTex)
  SignInQAView.super.OnExit(self)
end
