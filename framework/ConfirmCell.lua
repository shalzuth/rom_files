local BaseCell = autoImport("BaseCell")
ConfirmCell = class("ConfirmCell", BaseCell)
function ConfirmCell:ctor(parent)
  if parent == nil then
    return
  end
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.UIV1("cell/ConfirmCell"), parent)
  ConfirmCell.super.ctor(self, go)
end
function ConfirmCell:Init()
  self.label = self:FindComponent("ContentLabel", UILabel)
  local confirmButton = self:FindGO("ConfirmBtn")
  self.confirm_label = self:FindComponent("ConfirmLabel", UILabel, confirmButton)
  self:AddClickEvent(confirmButton, function(go)
    if self.confirmEvt then
      self.confirmEvt()
    end
    self:Reset()
  end)
  local cancelButton = self:FindGO("CancelBtn")
  self.cancel_label = self:FindComponent("CancelLabel", UILabel, cancelButton)
  self:AddClickEvent(cancelButton, function(go)
    if self.cancelEvt then
      self.cancelEvt()
    end
    self:Reset()
  end)
  self:Reset()
end
function ConfirmCell:SetData(txt, confirmEvt, cancelEvt)
  if self.gameObject == nil then
    return
  end
  self.label.text = txt
  self.confirmEvt = confirmEvt
  self.cancelEvt = cancelEvt
  self.gameObject:SetActive(true)
end
function ConfirmCell:SetButtonText(confirmTex, cancelTex)
  if confirmTex and confirmTex ~= "" then
    self.confirm_label.text = confirmTex
  end
  if cancelTex and cancelTex ~= "" then
    self.cancel_label.text = cancelTex
  end
end
function ConfirmCell:Reset()
  if not Slua.IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  self.confirmEvt = nil
  self.cancelEvt = nil
end
