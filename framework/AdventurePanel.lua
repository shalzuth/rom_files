AdventurePanel = class("AdventurePanel", ContainerView)
AdventurePanel.ViewType = UIViewType.NormalLayer
autoImport("AdventureCategoryCell")
autoImport("AdventureHomePage")
autoImport("AdventureResearchPage")
autoImport("AdventureItemNormalListPage")
autoImport("BeautifulAreaPhotoNetIngManager")
autoImport("AdventureAchievementPage")
autoImport("AdventureFoodPage")

AdventurePanel.Category = GameConfig.AdventureCategoryConfig

function AdventurePanel:GetShowHideMode()
	return PanelShowHideMode.MoveOutAndMoveIn
end

function AdventurePanel:Init()
	self:initView()	
end

function AdventurePanel:OnEnter(  )
	-- body
	-- printRed("AdventurePanel:OnEnter(  )")
	self.super.OnEnter(self)
	self:initData()	
	-- printRed("function AdventurePanel:OnEnter(  )")
	BeautifulAreaPhotoNetIngManager.Ins():OnSwitchOn()
	self:RegistRedTip()
	self:resetCategory()
	local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
	manager_Camera:ActiveMainCamera(false);
end

function AdventurePanel:RegistRedTip(  )
	-- body
	if(self.redData)then
		for i=1,#self.redData do
			local single = self.redData[i]
			self:RegisterRedTipCheck(single.id,single.obj,nil,single.offset)
		end
	end
end

function AdventurePanel:OnExit()
	self.super.OnExit(self)
	local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
	manager_Camera:ActiveMainCamera(true);
	-- printRed("AdventurePanel:OnExit(  )")
	BeautifulAreaPhotoNetIngManager.Ins():OnSwitchOff()
	self.currentKey = nil
	-- printRed("function AdventurePanel:OnExit()")
end

function AdventurePanel:handleRegistRedTip( data )
	-- body
	if(data)then
		-- printRed(data.id)
		-- printRed(data.obj)
		-- self:Log("regist",data.offset)
		
	end
end

function AdventurePanel:initView(  )
	-- body
	self.adventureHomePage = self:AddSubView("AdventureHomePage",AdventureHomePage)
	self.itemListPage = self:AddSubView("SceneryNormalListPage",AdventureItemNormalListPage)
	self.researchPage = self:AddSubView("AdventureResearchPage",AdventureResearchPage)
	self.achievePage = self:AddSubView("AdventureAchievementPage",AdventureAchievementPage)
	self.adventureFoodPage = self:AddSubView("AdventureFoodPage",AdventureFoodPage)

	local CategoryListTable = self:FindGO("categoryList"):GetComponent(UIGrid)
	self.categoryList = UIGridListCtrl.new(CategoryListTable,AdventureCategoryCell,"AdventureCategoryCell")
	self.categorSv = self:FindComponent("ScrollView",UIScrollView,self:FindGO("toggles"))
	--解决关闭相机背景
	-- local maskBg = self:FindGO("maskBg")
	-- if ApplicationInfo.IsIphoneX() and maskBg then
	-- 	self:Hide(maskBg)
	-- end
end

function AdventurePanel:initData(  )
	-- body
	local list = {}
	for k,v in pairs(AdventureDataProxy.Instance.categoryDatas) do
		local menuId = v.staticData.MenuID
		if(v.staticData.Position and v.staticData.Position > 1 and ((menuId and FunctionUnLockFunc.Me():CheckCanOpen(menuId)) or not menuId))then
			table.insert(list,v)
		end
	end
	table.sort(list,function ( l,r )
		-- body
		return l.staticData.Order < r.staticData.Order
	end)

	self.categoryList:ResetDatas(list)	
	local cells = self.categoryList:GetCells()
	self.redData = {}
	for i=1,#cells do
		local singleCell = cells[i]
		self:AddTabChangeEvent(singleCell.gameObject,nil,singleCell)

		local redTipIds = AdventureDataProxy.Instance:getRidTipsByCategoryId(singleCell.data.staticData.id)
		for j=1,#redTipIds do
			local single = redTipIds[j]
			local data = {}
			data.id = single
			data.obj = singleCell.icon
			data.offset = {-5,-5}
			table.insert(self.redData,data)
		end
	end
end

function AdventurePanel:resetCategory(  )
	-- body
	local cells = self.categoryList:GetCells()
	if(cells and #cells >0)then
		if(self.viewdata.viewdata.achieveData)then
			for i=1,#cells do
				if(cells[i].data.staticData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE)then
					self:TabChangeHandler(cells[i])
					break
				end
			end
		else
			self:TabChangeHandler(cells[1])
		end
	end
	self:adjustItemPos()
end

function AdventurePanel:TabChangeHandler(cell)
	-- body
	if(self.currentKey ~=cell)then
		AdventurePanel.super.TabChangeHandler(self,cell)	
		self:handleCategoryClick(cell)		
		self.currentKey = cell
	end
end

function AdventurePanel:addListEventListener(  )
	-- body
	-- self:AddListenEvt(QuestEvent.QuestDelete,self.questDelete)
	-- self:AddListenEvt(ServiceEvent.QuestQuestDetailUpdate,self.QuestQuestDetailUpdate)
	-- self:AddListenEvt(ServiceEvent.QuestQuestDetailList,self.QuestQuestDetailUpdate)
end

function AdventurePanel:handleCategorySelect( data )
	-- body	
	if(data.staticData.id == SceneManual_pb.EMANUALTYPE_HOMEPAGE)then
		self.adventureHomePage:Show()
		self.adventureFoodPage:Hide()
		self.itemListPage:Hide()
		self.researchPage:Hide()
		self.achievePage:Hide()
	elseif(data.staticData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE)then
		self.researchPage:Hide()
		self.adventureFoodPage:Hide()
		self.adventureHomePage:Hide()
		self.itemListPage:Hide()	
		self.achievePage:ShowSelf(self.viewdata.viewdata.achieveData)
		self.viewdata.viewdata.achieveData = nil
	elseif(data.staticData.id == SceneManual_pb.EMANUALTYPE_RESEARCH)then
		self.adventureFoodPage:Hide()
		self.researchPage:ShowSelf()
		self.adventureHomePage:Hide()
		self.itemListPage:Hide()
		self.achievePage:Hide()
	elseif(data.staticData.id == 18)then
		self.adventureFoodPage:ShowSelf()
		self.adventureHomePage:Hide()
		self.itemListPage:Hide()
		self.achievePage:Hide()
		self.researchPage:Hide()
	else
		self.adventureFoodPage:Hide()
		self.itemListPage:Show()
		self.researchPage:Hide()
		self.itemListPage:setCategoryData(data)
		self.adventureHomePage:Hide()
		self.achievePage:Hide()
	end
end

function AdventurePanel:handleCategoryClick( child )
	-- body
	self:handleCategorySelect(child.data)
	local cells = self.categoryList:GetCells()

	for i=1,#cells do
		local single = cells[i]
		if single == child then
			single:setIsSelected(true)
		else 
			single:setIsSelected(false)
		end
	end
end

function AdventurePanel:adjustItemPos(  )
	-- body
	self.categorSv:ResetPosition()
end

function AdventurePanel.OpenAchievePageById( achieveId )
 	-- body
 	local type = AdventureAchieveProxy.Instance:getTopCategoryIdByAchiveId(achieveId)
 	if(type)then
	 	GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.AdventurePanel, viewdata = {achieveData = {type = type,id = achieveId}}});
	 else
	 	helplog("can't find type:",achieveId);
	 end
end 

function AdventurePanel.OpenAchievePage( type,achieveId )
 	-- body
 	if(Table_Achievement[type] and Table_Achievement[achieveId])then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.AdventurePanel, viewdata = {achieveData = {type = type,id = achieveId}}});
	end
end 