CreateTipPanel = class("CreateTipPanel", BaseView)
CreateTipPanel.ViewType = UIViewType.PopUpLayer
function CreateTipPanel:Init()
  self:AddListenEvt(XDEUIEvent.CloseCreateRoleTip, function()
    self:CloseSelf()
  end)
end
function CreateTipPanel:OnEnter()
  CreateTipPanel.super.OnEnter(self)
  LeanTween.delayedCall(0.05, function()
    self.Scroll = self:FindGO("Scroll"):GetComponent(UITable)
    self.Scroll:Reposition()
  end)
end
function CreateTipPanel:OnExit()
  CreateTipPanel.super.OnExit(self)
end
