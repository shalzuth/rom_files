AdventureAchievementPage = class("AdventureAchievementPage", SubView)

autoImport("AdventureResearchCategoryCell");
autoImport("AdventureResearchDescriptionCell");
autoImport("AdventureResearchCombineItemCell");
autoImport("AchievementCategoryCell");
autoImport("AchievementDescriptionCell");
autoImport("AchievementSocialCell");
autoImport("AchievementChangeProCell");
autoImport("AdventureTitleBufferCell");
autoImport("TitleAdventureCombineItemCell");

AdventureAchievementPage.filterId = {
	all = 1,
	complete = 2,
	uncomplete = 3,
}

AdventureAchievementPage.tabItems =
{
	{id = AdventureAchievementPage.filterId.all,name = ZhString.AdventureAchievePage_AllAchieve},
	{id = AdventureAchievementPage.filterId.complete,name = ZhString.AdventureAchievePage_Complete},
	{id = AdventureAchievementPage.filterId.uncomplete,name = ZhString.AdventureAchievePage_UnComplete},
}

AdventureAchievementPage.SocialIDPair = {
	max_team = 1,
	max_hand = 2,
	max_wheel = 3,
	max_chat = 4,
	max_music = 5,
	max_save = 6,
	max_besave = 7,
}

AdventureAchievementPage.SocialID = {
	"max_team",
	"max_hand",
	"max_wheel",
	"max_chat",
	"max_music",
	"max_save",
	"max_besave",
}

AdventureAchievementPage.changePf = {
	bepro_1_time = 1,
	bepro_2_time = 2,
	bepro_3_time = 3,
}

AdventureAchievementPage.childGroupCellClick = "AdventureAchievementPage_childGroupCellClick"
local tempVector3 = LuaVector3.zero
local tempArray = {}
function AdventureAchievementPage:Init()
	self:AddViewEvts();
	self:initView();
	self:initTabData()
	local UserName = self:FindComponent("UserName",UILabel)
	UserName.text = Game.Myself.data:GetName()
	self.UserTitle = self:FindComponent("UserTitle",UILabel)	
end

function AdventureAchievementPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.AchieveCmdQueryUserResumeAchCmd,self.QueryUserResumeAchCmd);
	self:AddListenEvt(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd,self.HandleAchieveDataAchCmd);
	self:AddListenEvt(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd,self.HandleAchieveDataAchCmd);	
	self:AddListenEvt(ServiceEvent.QuestQuestUpdate,self.HandleQuestUpdate);	
	self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate,self.HandleQuestUpdate);	
	self:AddListenEvt(ServiceEvent.UserEventChangeTitle,self.initTitleData);
	EventManager.Me():AddEventListener(ServiceEvent.UserEventChangeTitle, self.HandleChangeTitle, self)
end

function AdventureAchievementPage:SubAchieveClickHandle(data)
	self:ShowSubTitleAchieve(self.data.staticData.id,data.id)
end

function AdventureAchievementPage:HandleChangeTitle()
	self:initTitleProp()
end

function AdventureAchievementPage:requestAchieveData()
	ServiceAchieveCmdProxy.Instance:CallQueryUserResumeAchCmd()
end

function AdventureAchievementPage:HandleQuestUpdate(  )
	self:updateDescList(true)
end

function AdventureAchievementPage:RegistRedTip(  )
	-- -- body
	-- if(not self.hasRegist)then
	-- 	self.hasRegist = true
		local cells = self.achivementCategoryGrid:GetCells()
		if(cells and #cells>0)then
			for i=1,#cells do
				local singleCell = cells[i]
				local redTipIds = AdventureAchieveProxy.Instance:getCategoryRedtip(singleCell.data.staticData.id)
				if(redTipIds)then
					for j=1,#redTipIds do
						-- helplog("RegisterRedTipCheck1",redTipIds[j],singleCell.bg)
						self:RegisterRedTipCheck(redTipIds[j],singleCell.bg,nil,{-5,-5})
					end
				end

				local subCells = singleCell:getSubChildCells()
				if(subCells and #subCells>0)then
					for j=1,#subCells do
						local RedTip = subCells[j].data.staticData.RedTip
						if(RedTip)then
							-- helplog("RegisterRedTipCheck2",RedTip,subCells[j].bg)
							self:RegisterRedTipCheck(RedTip,subCells[j].bg,nil,{-5,-5})
						end
					end
				end
			end
		end
	-- end
end

function AdventureAchievementPage:ScrollViewRevert(callback)
	self.revertCallBack = callback;
	self.propScrollView:Revert();
end

function AdventureAchievementPage:HandleAchieveDataAchCmd(  )
	-- body
	self:initCategoryData()
	if(self.data)then
		if(self.data.staticData.id == AdventureAchieveProxy.HomeCategoryId)then
			self:UpdateRecentAchieves()
		else
			self:updateDescList(true)
		end
	end
end

function AdventureAchievementPage:initTitleProp( resetPos )
	local allTitle = TitleProxy.Instance:GetTitle()
	local newData = self:ReUniteCellData(allTitle, 1);
	if(self.itemWrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.bag_itemContainer, 
			pfbNum = 12, 
			cellName = "TitleAdventureCombineItemCell", 
			control = TitleAdventureCombineItemCell,
			dir = 1,
		}
		self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
		self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick,self.TitleCellClick,self)
	end
	self.itemWrapHelper:UpdateInfo(newData)
	if(resetPos and self.gameObject.activeSelf)then
		self.itemWrapHelper:ResetPosition()
	end
end

function AdventureAchievementPage:ReUniteCellData(datas, perRowNum)
	local newData = {};
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end

function AdventureAchievementPage:TitleCellClick(cellCtl)
	local data = cellCtl and cellCtl.data

	-- local go = self.PropBordScrollBg
	local go = cellCtl and cellCtl.titleName
	local newChooseID= data and data.id or 0

	if(self.chooseId~=newChooseID)then
		self.chooseId=newChooseID

		self:ShowTitleTip(data,go)
	else
		self.chooseId = 0
		TipManager.Instance:HideTitleTip()
	end
	self:_refreshChoose()
end

function AdventureAchievementPage:ShowTitleTip(data,stick)
	local callback = function ()
		if(not self.destroyed)then
			self.chooseId = 0;
			self:_refreshChoose()
		end
	end;

	local sdata = {
		itemdata = data, 
		ignoreBounds = ignoreBounds,
		callback = callback,
	};

	local tip = TipManager.Instance:ShowTitleTip(sdata,stick,NGUIUtil.AnchorSide.Left,{-255, 0})
	-- tip:AddIgnoreBounds(self.PropBordScrollBg)
end

function AdventureAchievementPage:_refreshChoose( )
	local cells = self.itemWrapHelper:GetCellCtls();
	for i=1,#cells do
		local cell = cells[i]
		for j=1,#cell.childrenObjs do
			local child = cell.childrenObjs[j]
			child:SetChoose(self.chooseId)
		end
	end
end

function AdventureAchievementPage:QueryUserResumeAchCmd(  )
	-- body
	self:RefreshHomeData()
end

function AdventureAchievementPage:initTabData()
	self.itemTabs:Clear()
	for i=1,#AdventureAchievementPage.tabItems do
		local single = AdventureAchievementPage.tabItems[i]
		self.itemTabs:AddItem(single.name,single)
	end

	self.itemTabs.value = AdventureAchievementPage.tabItems[1].name
end

function AdventureAchievementPage:initCategoryData()
	local list = {}
	for k,v in pairs(AdventureAchieveProxy.Instance.categoryDatas) do
		table.insert(list,v)
	end
	table.sort(list,function ( l,r )
		-- body
		return l.staticData.id < r.staticData.id
	end)
	self.achivementCategoryGrid:ResetDatas(list)
	self:RegistRedTip()
end

function AdventureAchievementPage:initTitleData()
	local titleData = Table_Appellation[Game.Myself.data:GetAchievementtitle()]
	if(titleData)then
		self:Show(self.UserTitle.gameObject)
		self.UserTitle.text = "["..titleData.Name.."]"
	else
		self:Hide(self.UserTitle.gameObject)
	end
end

function AdventureAchievementPage:initData()
	self:initCategoryData()
	self:initTitleData()
end

function AdventureAchievementPage:RefreshListData(  )
	self:updateDescList(true)
end

function AdventureAchievementPage:RefreshHomeData(  )
	-- body
	self:UpdateHead()
	self:UpdateUserData()
	self:awardTitleProp()
	self:UpdateRecentAchieves()
	self:updateAchieveTitle()
	self:initTitleProp()
end

function AdventureAchievementPage:updateAchieveTitle()

	local unlock,total = AdventureAchieveProxy.Instance:getTotalAchieveProgress()
	local value = math.floor((unlock/total)*1000)/10
	self.adventureAchievementTabTitle.text = string.format(ZhString.AdventureAchievePage_AchievementTabTitle,value)
end

function AdventureAchievementPage:initView()
	self.gameObject = self:FindGO("AdventureAchievementPage")
	
	self.adventureAchievementTabTitle = self:FindComponent("AdventureAchievementTabTitle",UILabel)
	-- todo xde 调整冒险手册 lbl 长度
	self.adventureAchievementTabTitle.width = 400
	self.adventureProfileTitle = self:FindGO("AdventureProfileTitle")

	self.categoryScrollView = self:FindComponent("AchievementCategoryScrollView", UIScrollView);

	local categoryGrid = self:FindComponent("AchievementCategoryGrid",UITable)
	self.achivementCategoryGrid = UIGridListCtrl.new(categoryGrid,AchievementCategoryCell,"AchievementCategoryCell")
	self.achivementCategoryGrid:AddEventListener(AdventureAchievementPage.childGroupCellClick ,self.childGroupCellClick,self)
	self.achivementCategoryGrid:AddEventListener(MouseEvent.MouseClick,self.categoryCellClick,self)

	local recentAchieveList = self:FindComponent("recentAchieveList",UITable)
	self.recentAchieveListGrid = UIGridListCtrl.new(recentAchieveList,AchievementDescriptionCell,"AchievementDescriptionCell")
	self.recentAchieveListGrid:AddEventListener(MouseEvent.MouseClick ,self.recentAchieveDescCellClick,self)
	self.thirdContent = self:FindGO("thirdContent")
	self.fourthContent = self:FindGO("fourthContent")

	local AchieveDescGrid = self:FindComponent("AchieveDescGrid",UITable)
	self.achiveDescyGrid = UIGridListCtrl.new(AchieveDescGrid,AchievementDescriptionCell,"AchievementDescriptionCell")
	self.achiveDescyGrid:AddEventListener(MouseEvent.MouseClick,self.achieveDescCellClick,self)
	self.achiveDescyGrid:AddEventListener(AchievementDescriptionCell.SubAchieveClick,self.SubAchieveClickHandle,self)

	self.changePfGrid = self:FindComponent("changeProfessionGrid",UIGrid)
	self.changeProfessionGrid = UIGridListCtrl.new(self.changePfGrid,AchievementChangeProCell,"AchievementChangeProCell")

	local SocialInfoGrid = self:FindComponent("SocialInfoGrid",UITable)
	self.SocialInfoGrid = UIGridListCtrl.new(SocialInfoGrid,AchievementSocialCell,"AchievementSocialCell")

	self.emptyContent = self:FindGO("EmptyContent")
	local EmptyContentLabel = self:FindComponent("EmptyContentLabel",UILabel)
	EmptyContentLabel.text = ZhString.AdventureAchievePage_EmptyContentLabel

	self.BornAndToulInfo = self:FindComponent("BornAndToulInfo",UILabel)	

	local recentAchiveTitle = self:FindComponent("recentAchiveTitle",UILabel)
	recentAchiveTitle.text = ZhString.AdventureAchievePage_RecentAchiveTitle

	self.totalTourDis = self:FindComponent("totalTourDis",UILabel)

	self.AchievementList = self:FindGO("AchievementList")
	self.AchievementProfileView = self:FindGO("AchievementProfileView")

	self.secondContent = self:FindGO("secondContent")
	self.thirdContent = self:FindGO("thirdContent")

	self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
	self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
	EventDelegate.Add(self.itemTabs.onChange, function()
		if self.selectTabData ~= self.itemTabs.data then
			self.selectTabData = self.itemTabs.data
			self:updateDescList()
		end
	end)

	local PropShowBtn = self:FindGO("PropShowBtn")
	self:AddClickEvent(PropShowBtn,function ( )
		-- body
		self.PropBord:SetActive(not self.PropBord.activeSelf)
	end)
	local PropShowBtnLabel = self:FindComponent("PropShowBtnLabel",UILabel)
	PropShowBtnLabel.text = ZhString.AdventureAchievePage_PropShowBtnLabel
	self.AchieveCategorySv = self:FindComponent("AchievementCategoryScrollView",UIScrollView)
	self.AchieveCategoryPanel = self:FindComponent("AchievementCategoryScrollView",UIPanel)

	self.AchieveListSv = self:FindComponent("AchieveListScrollView",UIScrollView)
	self.AchieveListPanel = self:FindComponent("AchieveListScrollView",UIPanel)

	self.AchieveProfileSv = self:FindComponent("AdventureProfileScrollView",UIScrollView)
	self.AchieveProfilePanel = self:FindComponent("AdventureProfileScrollView",UIPanel)

	local awardPropTitle =self:FindComponent("awardPropTitle",UILabel)
	awardPropTitle.text = ZhString.AdventureAchievePage_AwardTitlePropTitle
	self.awardPropAchieveList =self:FindComponent("awardPropAchieveList",UIGrid)
	self.awardPropAchieveList = UIGridListCtrl.new(self.awardPropAchieveList,AdventureTitleBufferCell,"AdventureFoodRecipeCell")

	self.PropBord = self:FindGO("PropBord")
	self.PropBordScrollBg = self:FindComponent("PropBordScrollBg",UISprite)
	self.bag_itemContainer = self:FindGO("bag_itemContainer")
	self:Hide(self.PropBord)
	self.propScrollView = self:FindComponent("propScrollView", ROUIScrollView);
	self.propScrollView.OnStop = function ()
		self:ScrollViewRevert();
	end
end

function AdventureAchievementPage:childGroupCellClick( cellCtl )
	if(cellCtl)then
		-- helplog("childGroupCellClick",cellCtl.data.staticData.id)
		self.itemTabs.value = AdventureAchievementPage.tabItems[1].name
		self.subGroupData = cellCtl.data
		self:updateDescList()
	end
end

function AdventureAchievementPage:recentAchieveDescCellClick( cellCtl )
	local cells = self.recentAchieveListGrid:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local cell = cells[i]
			if(cell == cellCtl)then
				cell:setSelected(not cell.isSelected)
			else
				cell:setSelected(false)
			end
		end
	end
	self.recentAchieveListGrid:Layout()

	local bound = NGUIMath.CalculateRelativeWidgetBounds(self.AchieveProfilePanel.cachedTransform,cellCtl.gameObject.transform)
	local offset = self.AchieveProfilePanel:CalculateConstrainOffset(bound.min,bound.max)
	offset = Vector3(0,offset.y,0)
	self.AchieveProfileSv:MoveRelative(offset)
	-- self.AchieveProfileSv:RestrictWithinBounds(true)
end

function AdventureAchievementPage:achieveDescCellClick( cellCtl )
	-- helplog("achieveDescCellClick",cellCtl.data.id)	
	local cells = self.achiveDescyGrid:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local cell = cells[i]
			if(cell == cellCtl)then
				cell:setSelected(not cell.isSelected)
			else
				cell:setSelected(false)
			end
		end
	end
	self.achiveDescyGrid:Layout()

	local bound = NGUIMath.CalculateRelativeWidgetBounds(self.AchieveListPanel.cachedTransform,cellCtl.gameObject.transform)
	local offset = self.AchieveListPanel:CalculateConstrainOffset(bound.min,bound.max)
	offset = Vector3(0,offset.y,0)
	self.AchieveListSv:MoveRelative(offset)
	-- self.AchieveListSv:RestrictWithinBounds(true)
end

function AdventureAchievementPage:categoryCellClick( cellCtl )
	-- helplog("categoryCellClick",cellCtl.data.staticData.id)	
	if(not cellCtl.isSelected)then
		self.itemTabs.value = AdventureAchievementPage.tabItems[1].name
		self:setCategoryData(cellCtl.data)
	end
	
	local cells = self.achivementCategoryGrid:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local cell = cells[i]
			if(cell == cellCtl)then
				cell:clickEvent()
				cell:setSelected(true)
			else
				cell:setSelected(false)
			end
		end
	end
	self.achivementCategoryGrid:Layout()
end

function AdventureAchievementPage:changeToHomeCategory( result )
	if(result)then
		if(self.AchievementProfileView.activeSelf == false)then
			self:Show(self.AchievementProfileView)
			self:Hide(self.AchievementList)
			return true
		end
	else
		self:Hide(self.AchievementProfileView)
		self:Show(self.AchievementList)
	end
end

function AdventureAchievementPage:setCategoryData( data )
	-- body
	-- helplog("setCategoryData",data.staticData.id)	
	self.data = data
	self.subGroupData = nil
	if(data.staticData.id == AdventureAchieveProxy.HomeCategoryId)then
		 -- helplog("self:Show(self.AchievementProfileView)")
		self:Show(self.AchievementProfileView)
		self:Hide(self.AchievementList)
		self:RefreshHomeData()
	else
		 -- helplog("self:Show(self.AchievementList)")
		self:Show(self.AchievementList)
		self:Hide(self.AchievementProfileView)
		self:RefreshListData()
	end
end

function AdventureAchievementPage:updateDescList( noResetPos)

	if(self.data and self.data.staticData.id ~= AdventureAchieveProxy.HomeCategoryId)then
		local bagData = AdventureAchieveProxy.Instance.bagMap[self.data.staticData.id]
		if(not bagData)then
			return
		end
		local items
		if(self.subGroupData)then
			-- helplog("updateDescList1")
			items = bagData:GetItems(self.subGroupData.staticData.id)
		else
			-- helplog("updateDescList2")
			items = bagData:GetItems()
		end	

		if(items and #items > 0)then
			local list = {}
			if(self.selectTabData)then
				if(self.selectTabData.id == AdventureAchievementPage.filterId.all)then
					list = items
				elseif(self.selectTabData.id == AdventureAchievementPage.filterId.complete)then
					for i=1,#items do
						if(items[i]:getCompleteString())then
							list[#list+1] = items[i]
						end
					end
				elseif(self.selectTabData.id == AdventureAchievementPage.filterId.uncomplete)then
					for i=1,#items do
						if(not items[i]:getCompleteString())then
							list[#list+1] = items[i]
						end
					end
				end
			end
			self.achiveDescyGrid:ResetDatas(list)
			self:Hide(self.emptyContent)
			if(not noResetPos)then
				self.AchieveListSv:ResetPosition()
			end
		else
			self.achiveDescyGrid:ResetDatas()
			self:Show(self.emptyContent)
		end
	end
end

function AdventureAchievementPage:checkSelect( )
	-- body
	if(self.itemTabs.isOpen)then
		self:Show(self.ItemTabsBgSelect)
	else
		self:Hide(self.ItemTabsBgSelect)
	end
end

function AdventureAchievementPage:OnExit()
	TimeTickManager.Me():ClearTick(self)
	EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChangeTitle,self.HandleChangeTitle,self)
	-- local cells = self.achivementCategoryGrid:GetCells()
	-- if(cells and #cells>0)then
	-- 	local cell = cells[1]
	-- 	self:categoryCellClick(cell)
	-- end
	-- self.selectTabData = nil
	-- self.subGroupData = nil
	-- self.data = nil
	-- self:Log("OnExit")
end

function AdventureAchievementPage:OnEnter()
	-- body
	TimeTickManager.Me():CreateTick(0,500,self.checkSelect,self)
	self:requestAchieveData()	
end

function AdventureAchievementPage:ShowSelf(viewdata)
	self:Show()
	-- helplog("AdventureAchievementPage:ShowSelf(viewdata)")
	-- local changed = self:changeToHomeCategory(true)
	self.categoryScrollView:ResetPosition()
	self.AchieveProfileSv:ResetPosition()	
	self:initData()
	self:RefreshHomeData()
	-- if(changed)then
	-- 	self:changeToHomeCategory(false)
	-- end
	local cells = self.achivementCategoryGrid:GetCells()
	if(viewdata)then
		local type = viewdata.type
		local id = viewdata.id
		-- self:Log("AdventureAchievementPage:ShowSelf(viewdata)",type,id)
		if(cells and #cells>0)then
			for i=1,#cells do
				local cell = cells[i]
				if(cell.data.staticData.id == type)then
					-- self:Log("AdventureAchievementPage:ShowSelf(viewdata)",type,id)
					if(not cell.isSelected)then
						self:categoryCellClick(cell)
					else
						self:updateDescList()
					end
					local desCells = self.achiveDescyGrid:GetCells()
					if(desCells and #desCells>0)then
						for j=1,#desCells do
							local single = desCells[j]
							if(single.data.id == id)then
								self:achieveDescCellClick(single)
								break
							end
						end
					end
					break
				end
			end
		end
	else
		if(cells and #cells>0)then
			local cell = cells[1]
			self:categoryCellClick(cell)
		end
	end
end

function AdventureAchievementPage:ShowSubTitleAchieve(type,id)
	
	local cells = self.achivementCategoryGrid:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local cell = cells[i]
			if(cell.data.staticData.id == type)then
				self:categoryCellClick(cell)
				local desCells = self.achiveDescyGrid:GetCells()
				if(desCells and #desCells>0)then
					for j=1,#desCells do
						local single = desCells[j]
						if(single.data.id == id)then
							self:achieveDescCellClick(single)
							break
						end
					end
				end
				break
			end
		end
	end
end

function AdventureAchievementPage:awardTitleProp()
	local items = TitleProxy.Instance:GetAllTitleProp()
	local tempArray = {};
	for k, v in pairs(items) do
		local cdata = {k, v};
		table.insert(tempArray, cdata);
	end
	local x,y,z = LuaGameObject.GetLocalPosition(self.secondContent.transform)
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform,false)
	local height = bd.size.y
	
	if(height ~= 0)then
		y = y - height - 20
	end
	if(#tempArray>0)then
		self:Show(self.thirdContent)
		self.awardPropAchieveList:ResetDatas(tempArray)
	else
		self.awardPropAchieveList:ResetDatas()
		self:Hide(self.thirdContent)
	end
	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
	tempVector3:Set(x1,y,z1)
	self.thirdContent.transform.localPosition = tempVector3
end

function AdventureAchievementPage:sortItems(items)
	table.sort(items,function ( l,r )
		-- body
		if(l:canGetReward() == r:canGetReward())then
			if(l.finishtime == r.finishtime)then
				return l.id < r.id
			elseif(l.finishtime == nil)then
				return false
			elseif(r.finishtime == nil)then
				return true
			else
				return l.finishtime > r.finishtime
			end
		else
			-- helplog("left:canGetReward()",tostring(left:canGetReward()))
			return l:canGetReward()
		end	
	end)
end

function AdventureAchievementPage:UpdateRecentAchieves()
	local items = AdventureAchieveProxy.Instance:GetLastTenAchieveDatas()
	if(items and #items>0)then
		self:Show(self.fourthContent)
		if(#items <= 10)then
			-- self:Log("UpdateRecentAchieves1")
			self:sortItems(items)
			self.recentAchieveListGrid:ResetDatas(items)
		else
			TableUtility.ArrayClear(tempArray)
			for i=1,10 do
				tempArray[#tempArray +1] = items[i]
			end
			-- self:Log("UpdateRecentAchieves2")
			self:sortItems(tempArray)
			self.recentAchieveListGrid:ResetDatas(tempArray)
		end

		local bd = NGUIMath.CalculateRelativeWidgetBounds(self.thirdContent.transform,false)
		local height = bd.size.y
		local x,y,z = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
		if(height ~= 0)then
			y = y - height - 20
		end

		local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.fourthContent.transform)
		tempVector3:Set(x1,y,z1)
		self.fourthContent.transform.localPosition = tempVector3
	else
		self:Hide(self.fourthContent)
	end
end

function AdventureAchievementPage:UpdateUserData()

	local createtime = AdventureAchieveProxy.Instance.createtime
	local logintime = AdventureAchieveProxy.Instance.logintime
	local dateStr = ""	
	local totalDays = "0"
 	if createtime and createtime >0 then
 		dateStr = os.date("%Y.%m.%d",createtime)  		
 		local pastTime = ServerTime.CurServerTime()/1000 - createtime
 		totalDays = pastTime/60/60/24
 		totalDays = math.floor(totalDays)
 	end
 	local text = string.format(ZhString.AdventureAchievePage_BornAndToulInfo,dateStr,totalDays,logintime)
	self.BornAndToulInfo.text = text
	self.totalTourDis.text = string.format(ZhString.AdventureAchievePage_TotalTourDis, AdventureAchieveProxy.Instance.walk_distance)

	self:updateProfessionData()
	self:updateSocialData()
end

function AdventureAchievementPage:updateProfessionData(  )
	-- body
	local currentPf = Game.Myself.data:GetCurOcc()
	local curCl = currentPf.professionData

	local list = {}
	local index = 0
	while curCl and AdventureAchieveProxy.Instance.advanceClasses[curCl.id] do
		index = index +1
		list[index] = curCl.NameZh
		curCl = AdventureAchieveProxy.Instance.advanceClasses[curCl.id]
	end

	TableUtility.ArrayClear(tempArray)
	for i=1,AdventureAchieveProxy.Instance.currentCgPfNum do
		local key = string.format("bepro_%s_time",i)
		local value = AdventureAchieveProxy.Instance[key]
		if(value and value > 0)then
			if(i <= #list)then
				local data = {
						name = list[#list - i+1],
						time = value,
					}
				tempArray[#tempArray+1] = data
			end
		end
	end
	self.changeProfessionGrid:ResetDatas(tempArray)
end

function AdventureAchievementPage:updateSocialData(  )
	-- body	
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.changePfGrid.transform,false)
	local height = bd.size.y
	TableUtility.ArrayClear(tempArray)
	for i = 1,#AdventureAchievementPage.SocialID do
		local key = AdventureAchievementPage.SocialID[i]
		local value = AdventureAchieveProxy.Instance[key]
		if(value and #value >0 )then
			local data = {
					id =  AdventureAchievementPage.SocialIDPair[key],
					value = value,
				}
			tempArray[#tempArray+1] = data
		end
	end
	self.SocialInfoGrid:ResetDatas(tempArray)
	local x,y,z = LuaGameObject.GetLocalPosition(self.changePfGrid.transform)
	-- helplog("updateSocialData:height ",height,y,#tempArray)
	if(height>0)then
		y = y - height - 20
	end
	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
	tempVector3:Set(x1,y,z1)
	self.secondContent.transform.localPosition = tempVector3
end

function AdventureAchievementPage:UpdateHead(  )
	-- body
	if(not self.targetCell)then
		local headCellObj = self:FindGO("PortraitCell")		
		self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId,headCellObj)
		tempVector3:Set(0,0,0)
		self.headCellObj.transform.localPosition = tempVector3
		self.targetCell = PlayerFaceCell.new(self.headCellObj)

		self.targetCell:HideLevel()
		self.targetCell:HideHpMp()
	end
	local headData = HeadImageData.new();
	headData:TransByLPlayer(Game.Myself);
	-- 临时处理
	headData.frame = nil;
	headData.job = nil;
	self.targetCell:SetData(headData);
end