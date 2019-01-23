ChristmasInviteView = class("ChristmasInviteView",ContainerView)

ChristmasInviteView.ViewType = UIViewType.NormalLayer

local bgName = "letter_bg_10"

function ChristmasInviteView:OnExit()
	PictureManager.Instance:UnLoadStar(bgName, self.bg)
	ChristmasInviteView.super.OnExit(self)
end

function ChristmasInviteView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:InitShow()
	self:SetData()
end

function ChristmasInviteView:FindObj()
	self.bg = self:FindGO("Background"):GetComponent(UITexture)
	self.content = self:FindGO("Content"):GetComponent(UIInput)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.inviteButton = self:FindGO("InviteButton"):GetComponent(UISprite)
	self.inviteLabel = self:FindGO("Label" , self.inviteButton.gameObject):GetComponent(UILabel)

	UIUtil.LimitInputCharacter(self.content, 50)
end

function ChristmasInviteView:AddButtonEvt()
	self:AddClickEvent(self.inviteButton.gameObject,function ()
		self:ClickInvite()
	end)

	EventDelegate.Set(self.content.onChange,function ()
		self.isNotEmpty = self.content.value ~= ""
		self:SetInvite()
	end)
end

function ChristmasInviteView:InitShow()
	self.itemGuid = self.viewdata.viewdata

	PictureManager.Instance:SetStar(bgName, self.bg)

	self:SetInvite(false)
end

function ChristmasInviteView:ClickInvite()
	if self.canInvite then
		if self.isNotSelf then
			local item = StarProxy.Instance.itemData.id
			ServiceUserEventProxy.Instance:CallLoveLetterUse(item, self.dataGuid, self.content.value)
			self:CloseSelf()
		else
			MsgManager.ShowMsgByIDTable(3604)
		end
	end
end

function ChristmasInviteView:SetData()
	local target = StarProxy.Instance:GetCachedTarget()
	if target and target.data then
		local data = target.data
		self.name.text = target.data.name
		self.isNotSelf = data.id ~= Game.Myself.data.id
		self:SetInvite()

		self.dataGuid = data.id
		-- self.dataZoneid = data.zoneid
	end
end

function ChristmasInviteView:SetInvite()
	self.canInvite = self.isNotSelf and self.isNotEmpty

	if self.canInvite then
		self.inviteButton.color = ColorUtil.NGUIWhite
		self.inviteLabel.effectColor = ColorUtil.ButtonLabelGreen
	else
		self.inviteButton.color = ColorUtil.NGUIShaderGray
		self.inviteLabel.effectColor = ColorUtil.NGUIGray
	end
end
