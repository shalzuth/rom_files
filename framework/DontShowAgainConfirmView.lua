local UniqueConfirmView = autoImport("UniqueConfirmView")
DontShowAgainConfirmView = class("DontShowAgainConfirmView", UniqueConfirmView)
DontShowAgainConfirmView.ViewType = UIViewType.ConfirmLayer
function DontShowAgainConfirmView:Init()
  self.viewdata.title = self.viewdata.data.Title
  self.viewdata.confirmtext = self.viewdata.data.button ~= "" and self.viewdata.data.button or nil
  self.viewdata.canceltext = self.viewdata.data.buttonF ~= "" and self.viewdata.data.buttonF or nil
  self.viewdata.needCloseBtn = self.viewdata.data.Close == 1
  if self.viewdata.data.TimeInterval == 0 then
    self.viewdata.checkLabel = ZhString.DontShowAgainCheckString
  elseif self.viewdata.data.TimeInterval then
    self.viewdata.checkLabel = string.format(ZhString.DontShowAgainCheckStringWithDays, self.viewdata.data.TimeInterval)
  end
  DontShowAgainConfirmView.super.Init(self)
  self:FillTitle()
  self:FillCheckLabel()
  self:JudgeNeedShowToggle()
  self.contentLabel.fontSize = 23
end
function DontShowAgainConfirmView:FindObjs()
  self.isHandled = false
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.contentLabel = self:FindGO("ContentLabel"):GetComponent(UILabel)
  self.confirmLabel = self:FindGO("ConfirmLabel"):GetComponent(UILabel)
  self.cancelLabel = self:FindGO("CancelLabel"):GetComponent(UILabel)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self.checkBg = self:FindGO("CheckBg"):GetComponent(UISprite)
  self.checkLabel = self:FindGO("CheckLabel"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self:AddButtonEvent("ConfirmBtn", function(go)
    self:HandleDontShowAgain()
    self:DoConfirm()
    self:CloseSelf()
  end)
  self:AddButtonEvent("CancelBtn", function(go)
    self:HandleDontShowAgain()
    self:DoCancel()
    self:CloseSelf()
  end)
end
function DontShowAgainConfirmView:JudgeNeedShowToggle()
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  local data = self.viewdata.data
  if data.TimeInterval == nil or data.TimeInterval == -1 then
    self:Hide(self.checkBtn)
    self.contentLabel.transform.localPosition = Vector3.zero
    self.bg.bottomAnchor.absolute = -142
  else
    self.contentLabel.transform.localPosition = Vector3(0, 63, 0)
    self:Show(self.checkBtn)
    self.bg.bottomAnchor.absolute = -222
  end
end
function DontShowAgainConfirmView:DoConfirm()
  if self.viewdata.confirmHandler ~= nil then
    self.viewdata.confirmHandler(self.viewdata.source)
  end
end
function DontShowAgainConfirmView:DoCancel()
  if self.viewdata.cancelHandler ~= nil then
    self.viewdata.cancelHandler(self.viewdata.source)
  end
end
function DontShowAgainConfirmView:FillCheckLabel(text)
  text = text or self.viewdata.checkLabel
  if text ~= nil then
    self.checkLabel.text = text
  end
  local checkLabelX = self.checkLabel.transform.localPosition.x
  local p = Vector3(-(checkLabelX - self.checkBg.width / 2 + self.checkLabel.width) / 2, 108, 0)
  self.checkBtn.transform.localPosition = p
end
function DontShowAgainConfirmView:HandleDontShowAgain()
  local data = self.viewdata.data
  if self.checkBtn and data.TimeInterval ~= nil and data.TimeInterval ~= -1 and self.checkBtn.value then
    LocalSaveProxy.Instance:AddDontShowAgain(data.id, data.TimeInterval)
  end
end
