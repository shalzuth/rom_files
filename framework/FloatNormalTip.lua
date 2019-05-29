autoImport("BaseTip")
FloatNormalTip = class("FloatNormalTip", BaseTip)
FloatNormalTip.MaxWidth = 230
function FloatNormalTip:Init()
  self.desc = self:FindComponent("Desc", UILabel)
  self.closeComp = self:FindGO("Main"):GetComponent(CloseWhenClickOtherPlace)
  function self.closeComp.callBack()
    TipsView.Me():HideTip(FloatNormalTip)
  end
end
function FloatNormalTip:SetData(data, forceOpen)
  if not forceOpen and (data == nil or data == "") then
    TipsView.Me():HideTip(FloatNormalTip)
    return
  end
  self.desc.text = data
  UIUtil.FitLabelHeight(self.desc, FloatNormalTip.MaxWidth)
end
function FloatNormalTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end
function FloatNormalTip:RemoveUpdateTick()
  if self.updateCallTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateCallTick = nil
  end
  self.updateCall = nil
  self.updateCallTick = nil
end
function FloatNormalTip:SetUpdateSetText(interval, updateCall, updateCallParam)
  self.updateCall = updateCall
  self.updateCallParam = updateCallParam
  if self.updateCallTick == nil then
    self.updateCallTick = TimeTickManager.Me():CreateTick(0, interval, self._TickUpdateCall, self, 1)
  end
end
function FloatNormalTip:SetCloseCall(closeCall, closeCallParam)
  self.closeCall = closeCall
  self.closeCallParam = closeCallParam
end
function FloatNormalTip:_TickUpdateCall()
  if self.updateCall then
    local needRemove, text = self.updateCall(self.updateCallParam)
    self:SetData(text)
    if needRemove then
      self:RemoveUpdateTick()
    end
  end
end
function FloatNormalTip:OnEnter()
  FloatNormalTip.super.OnEnter(self)
end
function FloatNormalTip:DestroySelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
function FloatNormalTip:OnExit()
  self:RemoveUpdateTick()
  if self.closeCall then
    self.closeCall(self.closeCallParam)
  end
  return true
end
