BoothNameView = class("BoothNameView", ContainerView)
BoothNameView.ViewType = UIViewType.PopUpLayer
function BoothNameView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function BoothNameView:FindObjs()
  self.sign = self:FindGO("Sign"):GetComponent(UIMultiSprite)
  self.signTitle = self:FindGO("SignTitle"):GetComponent(UILabel)
  self.input = self:FindGO("Input"):GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.input, GameConfig.Booth.name_length_max)
end
function BoothNameView:AddEvts()
  local confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(confirmBtn, function()
    self:ClickConfirm()
  end)
end
function BoothNameView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.NUserBoothReqUserCmd, self.HandleBoothReq)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end
function BoothNameView:InitShow()
  local viewdata = self.viewdata.viewdata
  if viewdata ~= nil then
    self.playerID = viewdata.playerID
  end
  self:UpdateSign()
  self:UpdateName()
end
function BoothNameView:UpdateSign()
  local level = BoothProxy.Instance:GetScoreLevel(MyselfProxy.Instance:GetBoothScore())
  self.sign.CurrentState = level
  local name = ""
  local scoreConfig = GameConfig.Booth.score[level]
  if scoreConfig ~= nil then
    name = scoreConfig.name
  end
  self.signTitle.text = string.format(ZhString.Booth_SignName, name)
end
function BoothNameView:UpdateName()
  if self.playerID ~= nil then
    local name = BoothProxy.Instance:GetName(self.playerID)
    if name ~= nil then
      self.input.value = name
      return
    end
  end
  self.input.value = string.format(ZhString.Booth_Name, Game.Myself.data.name)
end
function BoothNameView:ClickConfirm()
  if #self.input.value < 1 then
    MsgManager.ShowMsgByID(25700)
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(self.input.value, GameConfig.MaskWord.BoothName) then
    MsgManager.ShowMsgByID(2604)
    return
  end
  if self.playerID ~= nil then
    if BoothProxy.Instance:IsSimulateMode() then
      BoothProxy.Instance:SetSimulateMode(true, self.input.value)
      self:sendNotification(BoothEvent.ChangeName)
      self:CloseSelf()
    else
      ServiceNUserProxy.Instance:CallBoothReqUserCmd(self.input.value, BoothProxy.OperEnum.Update)
    end
  else
    BoothProxy.Instance:SetSimulateMode(true, self.input.value)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.BoothMainView
    })
    self:CloseSelf()
  end
end
function BoothNameView:HandleBoothReq(note)
  self:CloseSelf()
end
