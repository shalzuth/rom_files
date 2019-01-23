autoImport("SkyWheelSearchCell")

SkyWheelSearchView = class("SkyWheelSearchView",ContainerView)

SkyWheelSearchView.ViewType = UIViewType.PopUpLayer

function SkyWheelSearchView:OnExit()
	FriendProxy.Instance:ClearSearchData()
end

function SkyWheelSearchView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function SkyWheelSearchView:FindObj()
	self.go = self:FindGO("SearchView")
	self.ContentInputLabel = self:FindGO("ContentInputLabel" , self.go):GetComponent(UILabel)
	self.SearchListContainer = self:FindGO("SearchListContainer" , self.go)
	self.SearchListScrollView = self:FindGO("SearchListScrollView", self.go):GetComponent(UIScrollView)
	self.EmptySearch = self:FindGO("EmptySearch" , self.go):GetComponent(UILabel)

	local contentInput = self:FindGO("ContentInput",self.go):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(contentInput, 16)
end

function SkyWheelSearchView:AddButtonEvt()
	local searchBtn = self:FindGO("SearchBtn" , self.go)
	self:AddClickEvent(searchBtn,function (g)
		self:Search(g)
	end)
end

function SkyWheelSearchView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityFindUser,self.UpdateSearchList)
end

function SkyWheelSearchView:InitShow()
	self.ContentInputLabel.text = ZhString.Friend_SearchContent
	self.EmptySearch.text = ZhString.Friend_EmptySearch

	self.EmptySearch.gameObject:SetActive(false)

	self.SearchListScrollView:ResetPosition()

	local wrapConfig = {
		wrapObj = self.SearchListContainer, 
		pfbNum = 5, 
		cellName = "SkyWheelSearchCell", 
		control = SkyWheelSearchCell, 
		dir = 1,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(SkyWheel.Select, self.HandleClickSelect , self)
end

function SkyWheelSearchView:Search()
	if self.ContentInputLabel.text ~= ZhString.Friend_SearchContent then
		ServiceSessionSocialityProxy.Instance:CallFindUser(self.ContentInputLabel.text , nil)
	else
		MsgManager.ShowMsgByIDTable(418)
	end
end

function SkyWheelSearchView:UpdateSearchList()

	local datas = FriendProxy.Instance:GetSearchData()
	self.itemWrapHelper:UpdateInfo(datas)

	if #datas > 0 then 
		self.EmptySearch.gameObject:SetActive(false)
	else
		self.EmptySearch.gameObject:SetActive(true)
	end

	self.itemWrapHelper:ResetPosition()
end

function SkyWheelSearchView:HandleClickSelect(cellctl)
	local data = cellctl.data
	if data then
		-- self.container:SetData(data)
		self:sendNotification(SkyWheel.ChangeTarget , data)
		self:CloseSelf()
	end
end