ProfessionContainerView = class("ProfessionContainerView", ContainerView)
autoImport("ProfessionSaveLoadView")
ProfessionContainerView.ViewType = UIViewType.NormalLayer
function ProfessionContainerView:Init()
  self.mainPage = self:AddSubView("ProfessionSaveLoadView", ProfessionSaveLoadView)
  self:AddListenEvt(ServiceEvent.NUserLoadRecordUserCmd, self.CloseSelf)
end
function ProfessionContainerView:OnEnter()
  ProfessionContainerView.super.OnEnter(self)
end
function ProfessionContainerView:OnExit()
  ProfessionContainerView.super.OnExit(self)
end
