autoImport("WrapCellHelper")
autoImport("FriendProxy")
autoImport("FriendInfoCell")

FriendView = class("FriendView",SubView)

function FriendView:OnEnter()
	self.super.OnEnter(self)
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function FriendView:OnExit()
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
	self.super.OnExit(self)
end

function FriendView:Init()
	self:FindObj()
	self:InitShow()
	self:AddButtonEvt()
	self:AddViewEvt()
end

function  FriendView:FindObj()
	self.RequestInfoBtn = self:FindGO("RequestInfoBtn")
	self.ListTip = self:FindGO("ListTip"):GetComponent(UILabel)
	self.loading = self:FindGO("Loading")
end

function FriendView:InitShow()
	self.ListTip.text = ZhString.Friend_ListTip

	self.funkey = {
		"InviteMember",
		"SendMessage",
		"DeleteFriend",
		"ShowDetail",
		"AddBlacklist",
		"InviteEnterGuild",
		"Tutor_InviteBeTutor",
		"Tutor_InviteBeStudent",
	}
	self.funkeyOffline = {
		"SendMessage",
		"DeleteFriend",
		"ShowDetail",
		"AddBlacklist",
		"InviteEnterGuild",
	}
	self.tipData = {}

	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY, self.RequestInfoBtn, 4, {-5,-5})

	local contentContainer = self:FindGO("ContentContainer")
	local wrapConfig = {
		wrapObj = contentContainer, 
		pfbNum = 10, 
		cellName = "FriendInfoCell", 
		control = FriendInfoCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(FriendEvent.SelectHead, self.HandleClickItem, self)

	self:UpdateFriendData()
end

function FriendView:HandleClickItem(cellctl)

	local data = cellctl.data;

	local playerData = PlayerTipData.new();
	playerData:SetByFriendData(cellctl.data);

	FunctionPlayerTip.Me():CloseTip()

	TableUtility.TableClear(self.tipData)
	self.tipData.playerData = playerData
	if data.offlinetime == 0 then
		self.tipData.funckeys = self.funkey
	else
		self.tipData.funckeys = self.funkeyOffline
	end

	FunctionPlayerTip.Me():GetPlayerTip( cellctl.headIcon.clickObj , NGUIUtil.AnchorSide.Left, {-380,60},self.tipData)
end

function FriendView:AddButtonEvt()
	self:AddClickEvent(self.RequestInfoBtn,function (g)
		self:ApplyInfo(g)
	end)
	local AddFriendBtn = self:FindGO("AddFriendBtn")
	self:AddClickEvent(AddFriendBtn,function (g)
		self:AddFriend(g)
	end)
	local BlacklistBtn = self:FindGO("BlacklistBtn")
	self:AddClickEvent(BlacklistBtn,function ()
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BlacklistView})
	end)
end

function FriendView:ApplyInfo()
	local datas = FriendProxy.Instance:GetApplyData()

	if #datas > 0 then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.FriendApplyInfoView})
	else
		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY)
		MsgManager.ShowMsgByIDTable(423)
	end
end

function FriendView:AddFriend()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AddFriendView})
end

function FriendView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData,self.UpdateFriendData)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate,self.UpdateSocial)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate,self.UpdateSocialData)
end

function FriendView:UpdateFriendData()
	local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
	local datas = FriendProxy.Instance:GetFriendData()
	if isQuerySocialData then
		self.itemWrapHelper:UpdateInfo(datas)
		self.ListTip.gameObject:SetActive(#datas == 0)
	else
		self.ListTip.gameObject:SetActive(false)
	end

	self.loading:SetActive(not isQuerySocialData)
end

function FriendView:UpdateSocial(note)
	self:UpdateFriendData()
end

function FriendView:UpdateSocialData(data)
	self:UpdateFriendData()

	local itemList = self.itemWrapHelper:GetCellCtls()
	for i=1,#itemList do
		local cellctl = itemList[i]
		if cellctl.data and cellctl.data.guid == data.body.guid and 
			data.body.type == SessionSociality_pb.ESOCIALDATA_OFFLINETIME then
			cellctl:RefreshOfflinetime()
		end
	end
end