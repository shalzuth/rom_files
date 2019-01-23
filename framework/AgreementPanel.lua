AgreementPanel = class("AgreementPanel", BaseView)
AgreementPanel.ViewType = UIViewType.PopUpLayer

function AgreementPanel:Init()
	self.title = self:FindComponent("Title", UILabel);
	self.text = self:FindComponent("Text", UILabel);
	self.button = self:FindGO("Button");
	self:AddClickEvent(self.button, function ( )		
		self:CloseSelf()
	end);
	self.buttonlab = self:FindComponent("Label", UILabel, self.button);
	self.title.text = ZhString.StartGamePanel_AgreetmentTitle
	self.buttonlab.text = ZhString.ServiceErrorUserCmdProxy_Confirm
	self.text.text = ZhString.StartGamePanel_AgreetmentContent
end