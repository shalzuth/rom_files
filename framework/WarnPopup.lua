WarnPopup = class("WarnPopup", BaseView)
WarnPopup.resID = ResourcePathHelper.UIPopup("WarnPopup")
function WarnPopup:ctor(data, parent)
  self.gameObject = self:CreateObj(parent)
  self:Init()
  self:ResetData(data)
end
function WarnPopup:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(WarnPopup.resID, parent)
end
function WarnPopup:Init()
  self:FindObjs()
end
function WarnPopup:FindObjs()
  self.contentLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "ContentLabel"):GetComponent(UILabel)
  self.confirmLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "ConfirmLabel"):GetComponent(UILabel)
  self.cancelLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "CancelLabel"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self:AddButtonEvent("ConfirmBtn", function(go)
    self:DoConfirm()
    self:CloseSelf()
  end)
  self:AddButtonEvent("CancelBtn", function(go)
    self:DoCancel()
    self:CloseSelf()
  end)
end
function WarnPopup:ResetData(data)
  self.viewdata = data
  self:FillContent()
  self:FillButton()
end
function WarnPopup:DoConfirm()
  if self.viewdata.confirmHandler ~= nil then
    self.viewdata.confirmHandler(self.viewdata.source)
  end
end
function WarnPopup:DoCancel()
  if self.viewdata.cancelHandler ~= nil then
    self.viewdata.cancelHandler(self.viewdata.source)
  end
end
function WarnPopup:Destroy()
  GameObject.Destroy(self.gameObject)
end
function WarnPopup:CloseSelf()
  self:PassEvent(UIEvent.CloseUI)
end
function WarnPopup:OnExit()
end
function WarnPopup:FillTitle(text)
  text = text or self.viewdata.title
  if text ~= nil then
    self.titleLabel.text = text
  end
end
function WarnPopup:FillContent(text)
  text = text or self.viewdata.content
  if text ~= nil then
    self.contentLabel.text = text
    UIUtil.FitLabelLine(self.contentLabel)
  end
end
function WarnPopup:FillButton()
  local confirmtext = self.viewdata.confirmtext
  if confirmtext == nil or confirmtext == "" then
    confirmtext = ZhString.UniqueConfirmView_Confirm or confirmtext
  end
  local canceltext = self.viewdata.canceltext
  if canceltext == nil or canceltext == "" then
    canceltext = ZhString.UniqueConfirmView_CanCel or canceltext
  end
  self.confirmLabel.text = confirmtext
  self.cancelLabel.text = canceltext
  if self.viewdata.canceltext == nil or self.viewdata.canceltext == "" then
    self:Hide(self.cancelBtn)
    local pos = self.confirmBtn.transform.localPosition
    pos.x = 0
    self.confirmBtn.transform.localPosition = pos
  end
end
