autoImport('GVGDetailViewItem')
GVGDetailView = class("GVGDetailView",BaseView)
GVGDetailView.ViewType = UIViewType.PopUpLayer

reusableArray = {}
showArray = {}

function GVGDetailView:Init()
	self:GetGameObjects()
	self:InitView()
	self:addViewEventListener()
	self:addListEventListener()
end

function GVGDetailView:OnExit()
	-- self:CancelListenServerResponse()
	-- if self.itemsController ~= nil then
	-- 	for i = 1, #self.itemsController do
	-- 		self.itemsController[i]:OnExit()
	-- 	end
	-- end
end

function GVGDetailView:InitView( )
	self.uiGridOfItems = self.goItemsRoot:GetComponent(UIGrid)
	if self.listControllerOfItems == nil then
		self.listControllerOfItems = UIGridListCtrl.new(self.uiGridOfItems, GVGDetailViewItem, "GVGDetailViewItem")
	end
	ServiceFuBenCmdProxy.Instance:CallSuperGvgQueryUserDataFubenCmd();
end

function GVGDetailView:GetGameObjects()
	self.goItemsRoot = self:FindGO("ItemsRoot", self.gameObject)
	self.itemsScrollView = self:FindComponent("DetailItemsView", UIScrollView)
	self.arrowList = {}
	for i=2,8 do
		self.arrowList[i] = self:FindGO("Arrow" .. i)
		local go = self:FindGO("OrderButton_" .. i)
		self:AddClickEvent(go,function (go)
			-- helplog("<<<====Arange=====>>>", go.name)
			local index = tonumber(string.split(go.name , "_")[2])
			self:SetIndexArangement(index)
		end)
	end

	self.selfGuildToggle = self:FindComponent("SelfGuildToggle", UIToggle)
	-- self.selfGuildToggle.gameObject:SetActive(false)
	EventDelegate.Add(self.selfGuildToggle.onChange, function ()
		self:SetIsSelfGuild()
	end)
end

function GVGDetailView:SetIsSelfGuild()
	local value = self.selfGuildToggle.value
	if value then
		local guildData = GuildProxy.Instance.myGuildData;
		if self.itemsController ~= nil then
			for i = 1, #self.itemsController do
				local guildCell = self.itemsController[i]
				if(guildData.guid == guildCell.data[10]) then
					guildCell.gameObject:SetActive(true)
				else
					guildCell.gameObject:SetActive(false)
				end
			end
		end
	else
		if self.itemsController ~= nil then
			for i = 1, #self.itemsController do
				local guildCell = self.itemsController[i]
				guildCell.gameObject:SetActive(true)
			end
		end
	end
	self.uiGridOfItems:Reposition ()
	self.itemsScrollView:ResetPosition()
end

function GVGDetailView:addViewEventListener(  )
	-- body
	self:AddButtonEvent("CloseButton",function (  )
		self:CloseSelf()
	end)
end

function GVGDetailView:addListEventListener(  )
	-- body
	self:AddListenEvt(ServiceEvent.FuBenCmdSuperGvgQueryUserDataFubenCmd, self.SetContent)
end

function GVGDetailView:SetContent()
	local guildUserdata = SuperGvgProxy.Instance:GetUserDetails()
	local userName = Game.Myself.data:GetName()

	self.dataFirst = {}
	local df = self.dataFirst
	-- TableUtil.Print(guildUserdata)
	for i=1, #guildUserdata do
		local userData = guildUserdata[i].detailData
		if userData[1] == userName then
			df[9] = userData
		end

		for j=2,8 do
			local lastFirstData = df[j]
			if not lastFirstData then
				df[j] = userData
			elseif lastFirstData[j] < userData[j] then
				df[j] = userData
			end
		end
	end

	self:SetIndexArangement(2)
end


function GVGDetailView:SetIndexArangement( index )
	local guildUserdata = SuperGvgProxy.Instance:GetUserDetails()
	table.sort(guildUserdata, function (x, y)
		return x.detailData[index] > y.detailData[index]
	end)
	
	self.listControllerOfItems:ResetDatas(guildUserdata)
	self.itemsController = self.listControllerOfItems:GetCells()

	local df = self.dataFirst
	for i=2,8 do
		local firstData = df[i]
		if firstData and firstData[i] ~= 0 then
			local cell = self.listControllerOfItems:FindCellByData(firstData)
			if cell then
				cell:ActiveMax(i)
			end
		end
	end

	if self.lastArrow then
		self.lastArrow:SetActive(false)
	end
	self.lastArrow = self.arrowList[index]
	self.lastArrow:SetActive(true)

	self:SetIsSelfGuild()
end