ChangeGuildZoneView = class("ChangeGuildZoneView", SubMediatorView)

ChangeGuildZoneView.ViewType = UIViewType.NormalLayer

function ChangeGuildZoneView:Init()
	self:FindObjs()
	self:AddEvts()
	self:InitShow()
end

function ChangeGuildZoneView:FindObjs()
	self.gameObject = self:LoadPreferb("view/ChangeGuildZoneView" , nil , true)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.currentZone = self:FindGO("CurrentZone"):GetComponent(UILabel)
	self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(self.contentInput, 8)
	self.changeBtn = self:FindGO("ChangeBtn")
	self.changeBtnLabel = self:FindGO("Label",self.changeBtn):GetComponent(UILabel)
end

function ChangeGuildZoneView:AddEvts()
	self:AddClickEvent(self.changeBtn,function ()
		self:ClickChangeBtn()
	end)
	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton,function ()
		self.container:CloseSelf()
	end)
end

function ChangeGuildZoneView:InitShow()

	local guildData = GuildProxy.Instance.myGuildData

	self.name.text = string.format(ZhString.ChangeGuildZone_Name , guildData.name)
	self.currentZone.text = ChangeZoneProxy.Instance:ZoneNumToString(guildData.zoneid, ZhString.ChangeGuildZone_Current);

	if guildData.zonetime ~= 0 then
		self.changeBtnLabel.text = ZhString.ChangeZone_CancelChangeGuildLine

		self.contentInput.enabled = false
		self.contentInput.value = ChangeZoneProxy.Instance:ZoneNumToString(GuildProxy.Instance.myGuildData.nextzone)
	else
		self.changeBtnLabel.text = ZhString.ChangeZone_ChangeGuildLine

		self.contentInput.enabled = true
		self.contentInput.value = ""
	end
end

function ChangeGuildZoneView:ClickChangeBtn()
	--todo xde
	local value = self.contentInput.value
	local name,id = string.match(value, '(%a+)(%d+)')
	if name ~= nil and id ~=nil then
		--	local num = ChangeZoneProxy.Instance:ZoneStringToNum(value)
		helplog(name)
		helplog(id)
		local num = OverseaHostHelper:ZoneInfoToNum(name,id)
		if GuildProxy.Instance.myGuildData.zonetime == 0 then
			if value == "" then
				MsgManager.ShowMsgByID(3087)
				return
			end

			if num == GuildProxy.Instance.myGuildData.zoneid then
				MsgManager.ShowMsgByID(3084)
				return
			end

			if ChangeZoneProxy.Instance:GetInfos(num) == nil then
				MsgManager.ShowMsgByID(3088)
				return
			end

			local count = GuildProxy.Instance:GetGuildPackItemNumByItemid( GameConfig.Zone.guild_zone_exchange.cost[1][1] )
			if count < GameConfig.Zone.guild_zone_exchange.cost[1][2] then
				MsgManager.ShowMsgByID(3083)
				return
			end

			self:CallExchangeZoneGuildCmd(num)
		else
			MsgManager.ConfirmMsgByID(3090,function ()
				self:CallExchangeZoneGuildCmd(num)
			end )
		end
	else
		MsgManager.ShowMsgByID(3088)
		return
	end
end

function ChangeGuildZoneView:CallExchangeZoneGuildCmd(num)
	ServiceGuildCmdProxy.Instance:CallExchangeZoneGuildCmd(num, GuildProxy.Instance.myGuildData.zonetime == 0 )
	LogUtility.InfoFormat("CallExchangeZoneGuildCmd : num : {0} , {1}",tostring(num),tostring(GuildProxy.Instance.myGuildData.zonetime == 0))

	self.container:CloseSelf()
end

function ChangeGuildZoneView:OnEnter()
	ChangeGuildZoneView.super.OnEnter(self);
	FunctionGuild.Me():QueryGuildItemList()
end