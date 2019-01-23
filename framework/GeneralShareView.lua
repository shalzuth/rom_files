GeneralShareView = class("GeneralShareView",ContainerView)

GeneralShareView.ViewType = UIViewType.PopUpLayer

function GeneralShareView:Init()
	self:FindObj()
	self:AddEvt()
	self:AddViewEvt()
	self:InitShow()
end

function GeneralShareView:FindObj()
	--todo xde 去除 其他分享
--	local qq = self:FindGO("QQ")
--	self:AddClickEvent(qq, function ()
--		self:ClickQQ()
--	end)
--
--	local wechat = self:FindGO("Wechat")
--	self:AddClickEvent(wechat, function ()
--		self:ClickWechat()
--	end)
--
--	local wechatMoments = self:FindGO("WechatMoments")
--	self:AddClickEvent(wechatMoments, function ()
--		self:ClickWechatMoments()
--	end)
--
--	local sina = self:FindGO("Sina")
--	self:AddClickEvent(sina, function ()
--		self:ClickSina()
--	end)
--todo xde add fb
	local facebook = self:FindGO("Facebook")
	self:AddClickEvent(facebook, function ()
		self:sendNotification(ShareEvent.ClickPlatform, "Facebook")
		self:CloseSelf()
	end)
end

function GeneralShareView:AddEvt()
	-- body
end

function GeneralShareView:AddViewEvt()
	-- body
end

function GeneralShareView:InitShow()

end

function GeneralShareView:ClickQQ()
	local platform = E_PlatformType.QQ
	if SocialShare.Instance:IsClientValid(platform) then
		self:sendNotification(ShareEvent.ClickPlatform, platform)
		self:CloseSelf()
	else
		MsgManager.ShowMsgByIDTable(562)
	end
end

function GeneralShareView:ClickWechat()
	local platform = E_PlatformType.Wechat
	if SocialShare.Instance:IsClientValid(platform) then
		self:sendNotification(ShareEvent.ClickPlatform, platform)
		self:CloseSelf()
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function GeneralShareView:ClickWechatMoments()
	local platform = E_PlatformType.WechatMoments
	if SocialShare.Instance:IsClientValid(platform) then
		self:sendNotification(ShareEvent.ClickPlatform, platform)
		self:CloseSelf()
	else
		MsgManager.ShowMsgByIDTable(561)
	end
end

function GeneralShareView:ClickSina()
	local platform = E_PlatformType.Sina
	if SocialShare.Instance:IsClientValid(platform) then
		self:sendNotification(ShareEvent.ClickPlatform, platform)
		self:CloseSelf()
	else
		MsgManager.ShowMsgByIDTable(563)
	end
end