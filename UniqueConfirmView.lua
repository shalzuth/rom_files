local UniqueConfirmView = class("UniqueConfirmView",BaseView)
UniqueConfirmView.ViewType = UIViewType.ConfirmLayer

function UniqueConfirmView:Init()
	self:FindObjs()
	-- self:FillTitle()
	self:FillContent()
	self:FillButton();
	self:InitCloseBtn();
end

function UniqueConfirmView:GetUnique()
	return self.viewdata.unique
end

function UniqueConfirmView:FindObjs()
	self.isHandled = false
	-- self.titleLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"TitleLabel"):GetComponent(UILabel)
	self.contentLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"ContentLabel"):GetComponent(UILabel)
	self.confirmLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"ConfirmLabel"):GetComponent(UILabel)
	self.cancelLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"CancelLabel"):GetComponent(UILabel)
	self.confirmBtn = self:FindGO("ConfirmBtn")
	self.cancelBtn = self:FindGO("CancelBtn")

	self:AddButtonEvent("ConfirmBtn",function(go)
 		self:DoConfirm()
 		self:CloseSelf()
 	end)

 	self:AddButtonEvent("CancelBtn",function(go)
 		self:DoCancel()
 		self:CloseSelf()
 	end)
end

function UniqueConfirmView:InitCloseBtn()
	self.closeBtn = self:FindGO("CloseButton")
	if(self.closeBtn~=nil) then
		if(self.viewdata.needCloseBtn) then
			self:Show(self.closeBtn)
		else
			self:Hide(self.closeBtn)
		end
	end
end

function UniqueConfirmView:DoConfirm()
	-- print("??????")
	if(self.viewdata.confirmHandler~=nil) then
		self.viewdata.confirmHandler(self.viewdata.source)
	end
end

function UniqueConfirmView:DoCancel()
	-- print("??????")
	if(self.viewdata.cancelHandler~=nil) then
		self.viewdata.cancelHandler(self.viewdata.source)
	end
end

function UniqueConfirmView:CloseSelf()
	self.isHandled = true
	UniqueConfirmView.super.CloseSelf(self)
end

function UniqueConfirmView:OnEnter()
	UIManagerProxy.UniqueConfirmView = self
	UniqueConfirmView.super.OnEnter(self)
end

function UniqueConfirmView:OnExit()
	if(self.isHandled==false and self.viewdata.needExitDefaultHandle) then
		self:DoCancel()
	end
	UIManagerProxy.UniqueConfirmView = nil
	self.viewdata = nil
end

function UniqueConfirmView:FillTitle(text)
	text = text or self.viewdata.title
	if(text~=nil) then
		self.titleLabel.text = text
	end
end

function UniqueConfirmView:FillContent(text)
	text = text or self.viewdata.content
	if(text~=nil) then
		self.contentLabel.text = text
		-- UIUtil.FitLabelLine(self.contentLabel)
	end
end

function UniqueConfirmView:FillButton()
	local confirmtext = self.viewdata.confirmtext;
	if(confirmtext==nil or confirmtext=="") then
		self:Hide(self.confirmBtn)
	end
	confirmtext = (confirmtext==nil or confirmtext=="") and ZhString.UniqueConfirmView_Confirm or confirmtext;
	local canceltext = self.viewdata.canceltext;
	if(canceltext==nil or canceltext=="") then
		self:Hide(self.cancelBtn)
	end
	canceltext = (canceltext==nil or canceltext=="") and ZhString.UniqueConfirmView_CanCel or canceltext;
	self.confirmLabel.text = confirmtext;
	self.cancelLabel.text = canceltext;
end

return UniqueConfirmView