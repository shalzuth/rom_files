ProfessionContainerView = class("ProfessionContainerView", ContainerView)

autoImport("ProfessionSaveLoadView")

ProfessionContainerView.ViewType = UIViewType.NormalLayer

function ProfessionContainerView:Init()
	self.mainPage = self:AddSubView("ProfessionSaveLoadView", ProfessionSaveLoadView)
	self:AddListenEvt(ServiceEvent.NUserLoadRecordUserCmd,self.CloseSelf)
	--todo xde self.NilTip
	self.XDENilTip = self:FindGO('NilTip',self.whitebgSP):GetComponent(UILabel)
	self.XDENilTip.overflowMethod = 3;
	self.XDENilTip.width = 240

	self.Sprite = self:FindGO('Sprite',self.XDENilTip.gameObject)
	self.Sprite.transform.localPosition = Vector3(171.7,-2,0)
end

function ProfessionContainerView:OnEnter()
	ProfessionContainerView.super.OnEnter(self)
end

function ProfessionContainerView:OnExit()
	ProfessionContainerView.super.OnExit(self)
end