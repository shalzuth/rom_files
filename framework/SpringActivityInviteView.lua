SpringActivityInviteView = class("SpringActivityInviteView",ContainerView)

SpringActivityInviteView.ViewType = UIViewType.NormalLayer

local bgName = "letter_bg_cat"

function SpringActivityInviteView:OnExit()
	PictureManager.Instance:UnLoadStar(bgName, self.bg)
	SpringActivityInviteView.super.OnExit(self)
end

function SpringActivityInviteView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:InitShow()
	self:SetData()
end

function SpringActivityInviteView:FindObj()
	self.bg = self:FindGO("Background"):GetComponent(UITexture)
	self.content = self:FindGO("Content"):GetComponent(UIInput)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.inviteButton = self:FindGO("InviteButton"):GetComponent(UISprite)
	self.inviteLabel = self:FindGO("Label" , self.inviteButton.gameObject):GetComponent(UILabel)
	self.inviteLabel.text = ZhString.SpringActivitySendText
	UIUtil.LimitInputCharacter(self.content, 50)
end

function SpringActivityInviteView:AddButtonEvt()
	self:AddClickEvent(self.inviteButton.gameObject,function ()
		self:ClickInvite()
	end)

	EventDelegate.Set(self.content.onChange,function ()
		self.isNotEmpty = self.content.value ~= ""
		self:SetInvite()
	end)
end

function SpringActivityInviteView:InitShow()
	self.itemGuid = self.viewdata.viewdata
	local itemData = BagProxy.Instance:GetItemByGuid(self.itemGuid)
	-- helplog("SpringActivityInviteViewxx:",self.itemGuid,tostring(itemData))
	local config = GameConfig.Item_LoveLetter or {}
	if(itemData and config[itemData.staticData.id])then
		local lId = config[itemData.staticData.id]
		local letter = Table_LoveLetter[lId]
		if letter and letter.Letter then
			self.content.value = letter.Letter
		end
	end

	PictureManager.Instance:SetStar(bgName, self.bg)

	self:SetInvite(false)
end

function SpringActivityInviteView:ClickInvite()
	if self.canInvite then
		if self.isNotSelf then
			local item = StarProxy.Instance.itemData.id
			ServiceUserEventProxy.Instance:CallLoveLetterUse(item, self.dataGuid, self.content.value,SceneItem_pb.ELETTERTYPE_SPRING)
			self:CloseSelf()
		else
			MsgManager.ShowMsgByIDTable(3604)
		end
	end
end

function SpringActivityInviteView:SetData()
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

function SpringActivityInviteView:SetInvite()
	self.canInvite = self.isNotSelf and self.isNotEmpty

	if self.canInvite then
		self.inviteButton.color = ColorUtil.NGUIWhite
		self.inviteLabel.effectColor = LuaColor(159/255,10/255,16/255,1)
	else
		self.inviteButton.color = ColorUtil.NGUIShaderGray
		self.inviteLabel.effectColor = ColorUtil.NGUIGray
	end
end