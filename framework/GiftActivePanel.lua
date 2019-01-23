GiftActivePanel = class("GiftActivePanel", ContainerView)
GiftActivePanel.ViewType = UIViewType.NormalLayer

function GiftActivePanel:Init()
	self:InitView()
	self:AddEvts()
	self:AddViewEvt()
end

function GiftActivePanel:InitView( )
	local Title = self:FindComponent("Title",UILabel)
	Title.text = ZhString.GiftActive_Title

	self.accInput = self:FindComponent("AcInput",UIInput)

	UIUtil.LimitInputCharacter(self.accInput, 12)
end

function GiftActivePanel:AddEvts()
	self:AddButtonEvent("confirm",function ()
		if self.accInput.value == "" then
			MsgManager.ShowMsgByID(1063)
			return
		end

		ServiceSessionSocialityProxy.Instance:CallUseGiftCodeSocialCmd(self.accInput.value)
	end)
end

function GiftActivePanel:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityUseGiftCodeSocialCmd,self.CloseSelf)
end