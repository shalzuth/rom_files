SkyWheelInviteView = class("SkyWheelInviteView",SubMediatorView)

local SubDateType = {
	[1] = 1,
	[4] = 2,
	[5] = 3,
}

function SkyWheelInviteView:OnEnter(subId)
	SkyWheelInviteView.super.OnEnter(self)

	self.dateLandId = SubDateType[subId]
	self.dateLandName = ""
	local dateLand = Table_DateLand[self.dateLandId]
	if dateLand then
		self.dateLandName = dateLand.Name
	end

	self.content.text = string.format(ZhString.SkyWheel_Invite, self.dateLandName)
end

function SkyWheelInviteView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function SkyWheelInviteView:FindObj()
	self.gameObject = self:LoadPreferb("view/SkyWheelInviteView" , nil , true)
	self.content = self:FindGO("Content" ):GetComponent(UILabel)
	self.name = self:FindGO("Name" ):GetComponent(UILabel)
	self.inviteButton = self:FindGO("InviteButton"):GetComponent(UISprite)
	self.inviteLabel = self:FindGO("Label" , self.inviteButton.gameObject):GetComponent(UILabel)
end

function SkyWheelInviteView:AddButtonEvt()
	self:AddClickEvent(self.inviteButton.gameObject,function ()
		self:ClickInvite()
	end)

	local searchButton = self:FindGO("SearchButton")
	self:AddClickEvent(searchButton,function ()
		self:ClickSearch()
	end)

	local friendButton = self:FindGO("FriendButton")
	self:AddClickEvent(friendButton,function ()
		self:ClickFriend()
	end)

	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton,function ()
		self.container:CloseSelf();
	end)
end

function SkyWheelInviteView:AddViewEvt()
	self:AddListenEvt(SkyWheel.ChangeTarget , self.HandleChange)
end

function SkyWheelInviteView:InitShow()
	self:SetInviteButtonGray()
	self.gameObject:SetActive(true)
end

function SkyWheelInviteView:ClickInvite()
	if self.dataGuid then
		if self.dataGuid ~= Game.Myself.data.id then
				local handed = Game.Myself:Client_IsFollowHandInHand()
				if handed then
					MsgManager.ConfirmMsgByID(876,function ()
						self:Invite()
					end , nil , nil, self.dateLandName)
				else
					self:Invite()
				end
		else
			MsgManager.ShowMsgByIDTable(875)
		end
	else
		MsgManager.ShowMsgByIDTable(870)
	end
end

function SkyWheelInviteView:ClickSearch()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.SkyWheelSearchView})
end

function SkyWheelInviteView:ClickFriend()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.SkyWheelFriendView})
end

function SkyWheelInviteView:SetData(data)
	if data.name then
		self.name.text = data.name
	end
	if data.guid == Game.Myself.data.id then
		self:SetInviteButtonGray()
	else
		self:SetInviteButtonNormal()
	end

	self.dataGuid = data.guid
	self.dataZoneid = data.zoneid
end

function SkyWheelInviteView:SetInviteButtonGray()
	self.inviteButton.color = ColorUtil.NGUIShaderGray
	self.inviteLabel.effectColor = ColorUtil.NGUIGray
end

function SkyWheelInviteView:SetInviteButtonNormal()
	self.inviteButton.color = ColorUtil.NGUIWhite
	self.inviteLabel.effectColor = ColorUtil.ButtonLabelPink
end

function SkyWheelInviteView:Invite()

	local dialog = 1312544
	if self.dataZoneid ~= MyselfProxy.Instance:GetZoneId() then
		dialog = 8558
	else
		ServiceCarrierCmdProxy.Instance:CallFerrisWheelInviteCarrierCmd(self.dataGuid, nil, self.dateLandId)
	end

	self.container:CloseSelf()

	local dialogData = DialogUtil.GetDialogData(dialog);

	local viewdata = {
		viewname = "DialogView",
		dialoglist = {dialogData.Text},
		npcinfo = self.container.npcinfo,
	}
	self:sendNotification(UIEvent.ShowUI, viewdata)
end

function SkyWheelInviteView:HandleChange(note)
	local data = note.body
	self:SetData(data)
end