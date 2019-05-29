ChargeComfirmPanel = class("ChargeComfirmPanel", ContainerView)
ChargeComfirmPanel.ViewType = UIViewType.PopUpLayer
ChargeComfirmPanel.left = nil
function ChargeComfirmPanel:Init()
  self.actBtn = self:FindGO("OkBtn")
  self:AddClickEvent(self.actBtn, function(go)
    EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
    self.super.CloseSelf(self)
  end)
  self.cancelBtn = self:FindGO("CancelBtn")
  self:AddClickEvent(self.cancelBtn, function(go)
    MsgManager.FloatMsg("", ZhString.ChargeLimitFloat)
    self:CloseSelf()
  end)
  self.content1 = self:FindGO("Content1"):GetComponent(UILabel)
end
function ChargeComfirmPanel:OnEnter()
  self.super.OnEnter(self)
  EventManager.Me():AddEventListener(ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd, self.ChargeLimitGetChargeCmd, self)
end
function ChargeComfirmPanel:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd, self.ChargeLimitGetChargeCmd, self)
  self.super.OnExit(self)
end
function ChargeComfirmPanel:CloseSelf()
  EventManager.Me():PassEvent(ChargeLimitPanel.CloseZeny, self)
  self.super.CloseSelf(self)
end
function ChargeComfirmPanel:ChargeLimitGetChargeCmd(data)
  local Count = Table_ChargeLimit[self.viewdata.cid].Count
  helplog("ChargeComfirmPanel:ChargeLimitGetChargeCmd", data.charge, self.viewdata.cid, Count)
  if Count ~= nil then
    ChargeComfirmPanel.left = Table_ChargeLimit[self.viewdata.cid].Count
    self:ReduceLeft(data.charge)
    self.content1.text = string.format(ZhString.ChargeLimit, tostring(ChargeComfirmPanel.left))
  else
    ChargeComfirmPanel.left = nil
    self.content1.text = ZhString.ChargeUnLimit
  end
end
function ChargeComfirmPanel:ReduceLeft(count)
  helplog("ChargeComfirmPanel:ReduceLeft", count, ChargeComfirmPanel.left)
  if ChargeComfirmPanel.left ~= nil then
    ChargeComfirmPanel.left = ChargeComfirmPanel.left - count
    ChargeComfirmPanel.left = ChargeComfirmPanel.left > 0 and ChargeComfirmPanel.left or 0
  end
end
