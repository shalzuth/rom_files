autoImport("WrapCellHelper")
autoImport("AddFriendCell")

AddFriendView = class("AddFriendView",ContainerView)

AddFriendView.ViewType = UIViewType.PopUpLayer;

function AddFriendView:Init()
	self:FindObj()
	self:InitShow()
	self:AddButtonEvt()
	self:AddViewEvt()

	--todo xde
	OverseaHostHelper:FixLabelOverV1(self.SearchTip,3,400)
end

function AddFriendView:FindObj()
	self.ContentInputLabel = self:FindGO("ContentInputLabel"):GetComponent(UILabel)
	self.EmptySearch = self:FindGO("EmptySearch"):GetComponent(UILabel)
	self.SearchTip = self:FindGO("SearchTip"):GetComponent(UILabel)

	local contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(contentInput, 16)
end

function AddFriendView:InitShow()
	
	self.ContentInputLabel.text = ZhString.Friend_SearchContent
	self.SearchTip.text = ZhString.Friend_SearchTip
	self.EmptySearch.text = ZhString.Friend_EmptySearch

	self.EmptySearch.gameObject:SetActive(false)
	self.SearchTip.gameObject:SetActive(true)

	self.funkey = {
		"InviteMember",
		"SendMessage",
		"AddFriend",
		"ShowDetail",
		"AddBlacklist",
		"InviteEnterGuild",
		"Tutor_InviteBeTutor",
		"Tutor_InviteBeStudent",
	}
	self.tipData = {}

	local searchListContainer = self:FindGO("SearchListContainer" )
	local wrapConfig = {
		wrapObj = searchListContainer, 
		pfbNum = 5, 
		cellName = "AddFriendCell", 
		control = AddFriendCell, 
		dir = 1,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(FriendEvent.SelectHead, self.HandleClickSearchHead , self)

	local datas = FriendProxy.Instance:GetSearchData()
	self.itemWrapHelper:UpdateInfo(datas)
	self.itemWrapHelper:ResetPosition()
end

function AddFriendView:AddButtonEvt()
	local searchBtn = self:FindGO("SearchBtn")
	self:AddClickEvent(searchBtn,function (g)
		self:Search(g)
	end)
end

function AddFriendView:OnExit()
	FriendProxy.Instance:ClearSearchData()
end

function AddFriendView:Search()
	
	self.SearchTip.gameObject:SetActive(false)

	if self.ContentInputLabel.text ~= ZhString.Friend_SearchContent then
		ServiceSessionSocialityProxy.Instance:CallFindUser(self.ContentInputLabel.text , nil)
	else
		MsgManager.ShowMsgByIDTable(418)
	end
end

function AddFriendView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityFindUser,self.UpdateSearchList)
end

function AddFriendView:UpdateSearchList()

	local datas = FriendProxy.Instance:GetSearchData()

	self.itemWrapHelper:UpdateInfo(datas)

	if #datas > 0 then 
		self.EmptySearch.gameObject:SetActive(false)
	else
		self.EmptySearch.gameObject:SetActive(true)
	end

	self.itemWrapHelper:ResetPosition()
end

function AddFriendView:HandleClickSearchHead(cellctl)

	local data = cellctl.data;

	if data.guid == Game.Myself.data.id then
		return
	end

	local playerData = PlayerTipData.new()
	playerData:SetByFriendData(data)

	FunctionPlayerTip.Me():CloseTip()

	local playerTip = FunctionPlayerTip.Me():GetPlayerTip( cellctl.headIcon.clickObj , NGUIUtil.AnchorSide.Left, {-380,60})

	TableUtility.TableClear(self.tipData)
	self.tipData.playerData = playerData
	self.tipData.funckeys = self.funkey

	playerTip:SetData(self.tipData)
end