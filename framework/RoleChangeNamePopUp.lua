RoleChangeNamePopUp = class("RoleChangeNamePopUp", BaseView)
RoleChangeNamePopUp.ViewType = UIViewType.PopUpLayer
function RoleChangeNamePopUp:Init()
  self:InitPopUp()
  self:MapEvent()
  local Tip = self:FindGO("Tip")
  local label = self:FindGO("Label", Tip):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(label, 3, 286)
  self.nameInput.characterLimit = GameConfig.System.namesize_max
end
function RoleChangeNamePopUp:InitPopUp()
  self.maskType = GameConfig.MaskWord.ChangeName
  self.nameInput = self:FindComponent("NameInput", UIInput)
  self.confirmButton = self:FindGO("ConfirmButton")
  self.cancelButton = self:FindGO("CancelButton")
  self:AddClickEvent(self.confirmButton, function(go)
    self:TryChangeName()
  end)
  self:AddClickEvent(self.cancelButton, function(go)
    self:CloseSelf()
  end)
end
function RoleChangeNamePopUp:TryChangeName()
  local name = self.nameInput.value
  if name == "" then
    MsgManager.ShowMsgByIDTable(1006)
    self:ShowChangeError()
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.namesize_min or length > GameConfig.System.namesize_max then
    MsgManager.ShowMsgByIDTable(883)
    self:ShowChangeError()
    return
  end
  if string.find(name, " ") or string.find(name, "\227\128\128") then
    MsgManager.ShowMsgByIDTable(1005)
    self:ShowChangeError()
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(name, self.maskType) then
    MsgManager.ShowMsgByIDTable(1005)
    self:ShowChangeError()
    return
  end
  if name == Game.Myself.data.name then
    MsgManager.ShowMsgByIDTable(1005)
    self:ShowChangeError()
    return
  end
  self:DoChangeName(name)
end
function RoleChangeNamePopUp:ShowChangeError()
  self.nameInput.label.color = ColorUtil.NGUILabelRed
end
function RoleChangeNamePopUp:DoChangeName(name)
  if self.waitRecv == true then
    return
  end
  self.waitRecv = true
  ServiceNUserProxy.Instance:CallUserRenameCmd(name)
end
function RoleChangeNamePopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.NUserUserRenameCmd, self.HandleError)
end
function RoleChangeNamePopUp:HandleError(note)
  self.waitRecv = false
  local errorCode = note.body.code
  if errorCode == SceneUser2_pb.ERENAME_SUCCESS then
    MsgManager.ShowMsgByIDTable(2702)
    self:CloseSelf()
    return
  end
  if errorCode == SceneUser2_pb.ERENAME_CONFLICT then
    MsgManager.ShowMsgByIDTable(1009)
    self:ShowChangeError()
  elseif errorCode == SceneUser2_pb.ERENAME_CD then
    MsgManager.ShowMsgByIDTable(2701)
    self:ShowChangeError()
  end
end
