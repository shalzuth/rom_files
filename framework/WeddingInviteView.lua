autoImport("WeddingInviteCell")

WeddingInviteView = class("WeddingInviteView", ContainerView)

WeddingInviteView.ViewType = UIViewType.PopUpLayer

local _WeddingProxy = WeddingProxy.Instance
local _InviteMaxCount = GameConfig.Wedding.InviteMaxCount
local funkey = {
	"InviteMember",
	"SendMessage",
	"InviteEnterGuild",
	"ShowDetail",
	"AddBlacklist",
}
local tipData = {}

function WeddingInviteView:OnEnter()
	WeddingInviteView.super.OnEnter(self)
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function WeddingInviteView:OnExit()
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
	WeddingInviteView.super.OnExit(self)
end

function WeddingInviteView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function WeddingInviteView:FindObjs()
	self.friendTog = self:FindGO("FriendTog"):GetComponent(UIToggle)
	self.friendTogLabel = self:FindGO("Label", self.friendTog.gameObject):GetComponent(UILabel)
	self.guildTog = self:FindGO("GuildTog"):GetComponent(UIToggle)
	self.guildTogLabel = self:FindGO("Label", self.guildTog.gameObject):GetComponent(UILabel)
	self.nearTog = self:FindGO("NearTog"):GetComponent(UIToggle)
	self.nearTogLabel = self:FindGO("Label", self.nearTog.gameObject):GetComponent(UILabel)
	self.noneTip = self:FindGO("NoneTip")
	self.loading = self:FindGO("Loading")
	self.tip = self:FindGO("Tip"):GetComponent(UILabel)
end

function WeddingInviteView:AddEvts()
	self:AddTabEvent(self.friendTog.gameObject, function (go, value)
		self:UpdateFriend()
	end)

	self:AddTabEvent(self.guildTog.gameObject, function (go, value)
		self:UpdateGuild()
	end)

	self:AddTabEvent(self.nearTog.gameObject, function (go, value)
		self:UpdateNear()
	end)
end

function WeddingInviteView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.HandleUpdateFriend)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.HandleUpdateFriend)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.HandleUpdateFriend)
	self:AddListenEvt(ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd, self.HandleUpdateWeddingManual)
end

function WeddingInviteView:InitShow()
	local container = self:FindGO("Container")
	local wrapConfig = ReusableTable.CreateTable()
	wrapConfig.wrapObj = container
	wrapConfig.pfbNum = 6
	wrapConfig.cellName = "WeddingInviteCell"
	wrapConfig.control = WeddingInviteCell
	wrapConfig.dir = 1
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	self.itemWrapHelper:AddEventListener(WeddingEvent.Select, self.HandleSelect, self)
	ReusableTable.DestroyTable(wrapConfig)

	self:UpdateFriend()
	self:UpdateTip()
end

function WeddingInviteView:UpdateFriend()
	self:UpdateLabel(self.friendTogLabel)

	local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
	local data = _WeddingProxy:GetInviteFriendList()
	if isQuerySocialData then
		self.itemWrapHelper:UpdateInfo(data)
		self.noneTip:SetActive(#data == 0)
	else
		self.noneTip:SetActive(false)
	end

	self.loading:SetActive(not isQuerySocialData)
end

function WeddingInviteView:UpdateGuild()
	self.loading:SetActive(false)
	self:UpdateLabel(self.guildTogLabel)

	local data = _WeddingProxy:GetInviteGuildList()
	if data ~= nil then
		self.itemWrapHelper:UpdateInfo(data)
		self.noneTip:SetActive(#data == 0)
	end
end

function WeddingInviteView:UpdateNear()
	self.loading:SetActive(false)
	self:UpdateLabel(self.nearTogLabel)

	local data = _WeddingProxy:GetInviteNearList()
	if data ~= nil then
		self.itemWrapHelper:UpdateInfo(data)
		self.noneTip:SetActive(#data == 0)
	end
end

function WeddingInviteView:UpdateLabel(label)
	if self.lastLabel ~= nil then
		self.lastLabel.color = ColorUtil.TitleGray
	end

	label.color = ColorUtil.TitleBlue
	self.lastLabel = label
end

function WeddingInviteView:UpdateTip()
	self.tip.text = string.format(ZhString.Wedding_InviteTip, _WeddingProxy:GetInviteCount(), _InviteMaxCount)
end

function WeddingInviteView:HandleSelect(cell)
	local data = cell.data
	if data then
		local playerData = PlayerTipData.new()
		playerData:SetByFriendData(data)

		FunctionPlayerTip.Me():CloseTip()

		local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380,60})

		tipData.playerData = playerData
		tipData.funckeys = funkey

		playerTip:SetData(tipData)
	end
end

function WeddingInviteView:HandleUpdateFriend()
	if self.friendTog.value then
		self:UpdateFriend()
	end
end

function WeddingInviteView:HandleUpdateWeddingManual(note)
	local data = note.body
	if data ~= nil and #data.invitees > 0 then
		self:UpdateTip()

		if self.friendTog.value then
			self:UpdateFriend()
		elseif self.guildTog.value then
			self:UpdateGuild()
		elseif self.nearTog.value then
			self:UpdateNear()
		end
	end
end