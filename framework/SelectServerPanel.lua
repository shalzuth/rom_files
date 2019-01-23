SelectServerPanel = class("SelectServerPanel",BaseView)

autoImport('ServerItemCell')
autoImport("ServerStCell")
autoImport("RegionCell")

SelectServerPanel.ViewType = UIViewType.PopUpLayer

SelectServerPanel.ServerSt = {}
SelectServerPanel.ServerConfig = {
	Normal = 1,
	Crowd = 2,
	Hot = 3,
	Maintain = 0,
}

SelectServerPanel.ServerSt = {
	{id = SelectServerPanel.ServerConfig.Normal,name = ZhString.SelectServerPanel_StateNormal},
	{id = SelectServerPanel.ServerConfig.Crowd,name = ZhString.SelectServerPanel_StateCrowd},
	{id = SelectServerPanel.ServerConfig.Hot,name = ZhString.SelectServerPanel_StateHot},
	{id = SelectServerPanel.ServerConfig.Maintain,name = ZhString.SelectServerPanel_StateMaintain},
}

local tempVector3 = LuaVector3.zero
function SelectServerPanel:Init()
	self:initView();
	self:initData();
	self:addViewEventListener()
end

function SelectServerPanel:initView()
	-- self.serverContainer = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"Container").transform;
	-- self.serverPfb = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"ServerPfb");
	self.serversGrid = self:FindGO("allServers"):GetComponent(UIGrid);
	self.serverList = UIGridListCtrl.new(self.serversGrid, ServerItemCell, "ServerItemCell")
	self.serverList:AddEventListener(MouseEvent.MouseClick,self.serverCellClick,self)

	local panelTitle = self:FindGO("panelTitle"):GetComponent(UILabel)
	panelTitle.text = ZhString.SelectServerPanel_PanelTitle
	self.serverStGrid = self:FindGO("serverStGrid"):GetComponent(UIGrid)
	self.serverStGrid = UIGridListCtrl.new(self.serverStGrid,ServerStCell,"ServerStCell")

	self.RegionGrid = self:FindGO("RegionGrid"):GetComponent(UIGrid)
	self.RegionGrid = UIGridListCtrl.new(self.RegionGrid,RegionCell,"RegionCell")
	self.RegionGrid:AddEventListener(MouseEvent.MouseClick,self.regionCellClick,self)

	local recentLoginTitle = self:FindGO("recentLoginTitle"):GetComponent(UILabel)
	recentLoginTitle.text = ZhString.SelectServerPanel_RecentLogin
	local hasRolesTitle = self:FindGO("hasRolesTitle"):GetComponent(UILabel)
	hasRolesTitle.text = ZhString.SelectServerPanel_HasRoles	

	local recentLoginGrid = self:FindGO("recentLoginGrid"):GetComponent(UIGrid)
	self.recentGrid = UIGridListCtrl.new(recentLoginGrid,ServerItemCell,"ServerItemCell")
	self.recentGrid:AddEventListener(MouseEvent.MouseClick,self.serverCellClick,self)
	local recentLogin = self:FindGO("recentLogin")
	local hasRoles = self:FindGO("hasRoles")

	local bound = NGUIMath.CalculateRelativeWidgetBounds(recentLogin.transform)
	local y = bound.size.y
	local _,posY,_ = LuaGameObject.GetLocalPosition(recentLogin.transform)

	y = posY - y

	local x,_,z = LuaGameObject.GetLocalPosition(hasRoles.transform)

	tempVector3:Set(x,y-30,z)
	hasRoles.transform.localPosition = tempVector3

	self:Hide(hasRoles)
	local hasRolesGrid = self:FindGO("hasRolesGrid"):GetComponent(UIGrid)
	self.hasRolesGrid = UIGridListCtrl.new(hasRolesGrid,ServerItemCell,"ServerItemCell")
	self.hasRolesGrid:AddEventListener(MouseEvent.MouseClick,self.serverCellClick,self)

	local RegionCellHolder = self:FindGO("RegionCellHolder")
	RegionCellHolder = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("RegionCell"), RegionCellHolder);
	tempVector3:Set(0,0,0)
	RegionCellHolder.transform.localPosition = tempVector3
	self.myRegionCell = RegionCell.new(RegionCellHolder)
	local data = {}
	data.type = 1
	data.name = ZhString.SelectServerPanel_MyServer
	self.myRegionCell:SetData(data)
	self.myRegionCell:AddEventListener(MouseEvent.MouseClick,self.regionCellClick,self)
	self.myServers = self:FindGO("myServers")

	self.scrollview = self:FindGO("ScrollView"):GetComponent(UIScrollView);
	self.leftContent = self:FindGO("leftContent")
	self.Bg = self:FindComponent("Bg",UISprite)

	--todo xde 居中选择服务器界面位置
	self.Bg.gameObject.transform.localPosition = Vector3(420,0,0)
	self.rightContent = self:FindGO("rightContent")
	self.rightContent.transform.localPosition = Vector3(0,0,0)
end

function SelectServerPanel:serverCellClick( cellCtl )
	-- body
	self:sendNotification(ServiceEvent.ChooseServer, cellCtl.data)
	self:CloseSelf()
end

function SelectServerPanel:regionCellClick( child )
	-- body
	--click region
	-- printGreen("click")
	if(not child)then
		return
	end
	local data = child.data
	if(data.type == 1)then
		self.myRegionCell:setIsSelected(true)
		self:Show(self.myServers)
		self:Hide(self.serversGrid.gameObject)
	else
		self.myRegionCell:setIsSelected(false)
		self:Hide(self.myServers)
		self:Show(self.serversGrid.gameObject)
	end
	local cells = self.RegionGrid:GetCells()
	for i=1,#cells do
		local single = cells[i]
		if(single ~= child)then
			single:setIsSelected(false)		
		else
			single:setIsSelected(true)				
			self.serverList:ResetDatas(data.list)				
		end
	end
end

function SelectServerPanel:initRightContent()
	local recentList = {}
	local serverData
	if(sdkEnable)then
		serverData = FunctionLogin.Me():getDefaultServerData()
	else		
		serverData = Table_ServerList[self.viewdata.index]
	end
	if(serverData)then
		table.insert(recentList,serverData)
	end
	self.recentGrid:ResetDatas(recentList)
	self.serverStGrid:ResetDatas(SelectServerPanel.ServerSt)
end

function SelectServerPanel:initLeftContent()
	local list = {}
	local sdkEnable = FunctionLogin.Me():getSdkEnable(  )
	local servers
	if(sdkEnable)then
		servers = FunctionLogin.Me():getServerDatas()
	else
		servers = Table_ServerList
	end
	local count = #servers%10 == 0 and #servers/10 or math.floor(#servers/10)+1
	-- printGreen(count)
	local hasShow = false
	for i=1,count do
		data = {}
		data.type = 2
		data.state = SelectServerPanel.ServerConfig.Normal
		data.isNew = true
		local name = ((i-1)*10+1).."-"
		local LCount = 0
		if(i*10>#servers)then
			name = name..#servers
			LCount = #servers
		else
			name = name..(i*10)
			LCount = 10*i
		end
		data.name = name..ZhString.SelectServerPanel_Region
		local tmpList = {}
		for j=(i-1)*10+1,LCount do
			table.insert(tmpList,servers[j])
		end
		data.list = tmpList
		table.insert(list,data)
	end
	self.RegionGrid:ResetDatas(list)
	if(#list<2)then
		self.Bg.width = 846
		self:Hide(self.leftContent)
		self:regionCellClick(self.RegionGrid:GetCells()[1])
	else
		self.Bg.width = 1074
		self:Show(self.leftContent)
		self:regionCellClick(self.myRegionCell)
	end	
	self.scrollview:ResetPosition();
end

function SelectServerPanel:initData()
	local sdkEnable = FunctionLogin.Me():getSdkEnable(  )
	local servers
	if(sdkEnable)then
		servers = FunctionLogin.Me():getServerDatas()
	else
		servers = Table_ServerList
	end

	if(not servers)then
		return
	end
	self:initLeftContent()
	self:initRightContent()
	-- local cells = self.serverList:GetCells()
	-- for i=1,#cells do
	-- 	local single = cells[i]
	-- 	if(single.data.id == self.viewdata.index)then
	-- 		single:SetCurrentServer(true)
	-- 		break
	-- 	end
	-- end
end

function SelectServerPanel:addViewEventListener(  )
	-- body	
end

function SelectServerPanel:OnExit(  )
	-- body
end