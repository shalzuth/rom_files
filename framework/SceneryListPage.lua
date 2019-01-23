SceneryListPage = class("SceneryListPage", SubView)

autoImport("WrapCellHelper")
autoImport("PersonalPictureCell")
autoImport("PersonalPicturCombineItemCell")

SceneryListPage.MaxCategory = { id = 99999999,value = {}}


SceneryListPage.ClickId = {
	RefreshIndicator = 1,
	CheckSelect = 2,
}

function SceneryListPage:Init()
	self:AddViewEvts();
	self:initView();
	self:initData()
end

function SceneryListPage:AddViewEvts()
	-- self:AddListenEvt(MySceneryPictureManager.SceneryOriginPhotoUploadProgressCallback,self.SceneryOriginPhUpPgCallback);
	-- self:AddListenEvt(MySceneryPictureManager.SceneryOriginPhotoUploadCompleteCallback,self.SceneryOriginPhUpCpCallback);
	-- self:AddListenEvt(MySceneryPictureManager.SceneryOriginPhotoUploadErrorCallback,self.SceneryOriginPhUpErCallback);

	self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadProgressCallback,self.SceneryThumbnailPhDlPgCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadCompleteCallback,self.SceneryThumbnailPhDlCpCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadErrorCallback,self.SceneryThumbnailPhDlErCallback);
end

function SceneryListPage:SceneryThumbnailPhDlPgCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell and cell.data.roleId == data.roleId)then
		cell:setDownloadProgress(data.progress)
	end		
end

function SceneryListPage:SceneryThumbnailPhDlCpCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell and cell.data.roleId == data.roleId)then
		self:GetPersonPicThumbnail(cell)
	end
end

function SceneryListPage:SceneryThumbnailPhDlErCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell and cell.data.roleId == data.roleId)then
		cell:setDownloadFailure()
	end
end

-- function SceneryListPage:PersonalOriginPhUpPgCallback( note )
-- 	local data = note.body
-- 	local cell = self:GetItemCellById(data.index)
-- 	if(cell)then
-- 		cell:setUploadProgress(data.progress)
-- 	end		
-- end

-- function SceneryListPage:PersonalOriginPhUpCpCallback( note )
-- 	local data = note.body
-- 	local cell = self:GetItemCellById(data.index)
-- 	if(cell)then
-- 		cell:setUploadSuccess()
-- 	end
-- end

-- function SceneryListPage:PersonalOriginPhUpErCallback( note )
-- 	local data = note.body
-- 	local cell = self:GetItemCellById(data.index)
-- 	if(cell)then
-- 		cell:setUploadFailure()
-- 	end
-- end

function SceneryListPage:initView()
	self.gameObject = self:FindGO("SceneryListPage")
	local itemContainer = self:FindGO("bag_itemContainer");
	local pfbNum = 7

	local wrapConfig = {
		wrapObj = itemContainer,
		pfbNum = pfbNum,		
		cellName = "PersonalPicturCombineItemCell",
		control = PersonalPicturCombineItemCell,
		dir = 2,
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);
	self.wraplist:AddEventListener(PersonalPicturePanel.GetPersonPicThumbnail, self.GetPersonPicThumbnail, self);
	-- self.wraplist:AddEventListener(PersonalPicturePanel.ReplacePersonPicThumbnail, self.ReplacePersonPicThumbnail, self);
	-- self.wraplist:AddEventListener(PersonalPicturePanel.ReUploadingPersonPicThumbnail, self.ReUploadingPersonPicThumbnail, self);
	-- self.wraplist:AddEventListener(PersonalPicturePanel.DelPersonPicThumbnail, self.DelPersonPicThumbnail, self);
	-- self.wraplist:AddEventListener(PersonalPicturePanel.CancelPersonPicThumbnail, self.CancelPersonPicThumbnail, self);

	self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView);
	self.scrollView.OnStop = function ()
		self:ScrollViewRevert();
	end

	self.emptyCt = self:FindGO("emptyCt")
	local emptyDes = self:FindComponent("emptyDes",UILabel)
	emptyDes.text = ZhString.PersonalPicturePanel_AlbumStateEmpty
	local emptySp = self:FindComponent("emptySp",UISprite)
	emptySp:UpdateAnchors()

	self.curState = self:FindComponent("CurState",UILabel)

	self.leftIndicator = self:FindGO("leftIndicator")
	self.rightIndicator = self:FindGO("rightIndicator")

	self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
	self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
	EventDelegate.Add(self.itemTabs.onChange, function()
		if self.selectTabData ~= self.itemTabs.data then
			self.selectTabData = self.itemTabs.data
			self:tabClick()
		end
	end)
end

local tempPos = LuaVector3.zero
function SceneryListPage:initData(  )
	-- body
	self.showMode = self.container.showMode
	self.showMode = self.showMode and self.showMode or PersonalPicturePanel.ShowMode.NormalMode
	self:initCategoryData()
	self:UpdateList()
	TimeTickManager.Me():CreateTick(1000,500,self.refreshLRIndicator,self,SceneryListPage.ClickId.RefreshIndicator)
	local datas = self:getDatas()
	MySceneryPictureManager.Instance():AddMySceneryThumbnailInfos(datas)	
end

function SceneryListPage:getDatas( )
	-- body
	local bag = AdventureDataProxy.Instance.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
	local datas = {}
	if(bag)then
		local tabId = self.selectTabData and self.selectTabData.id or nil
		local items = bag:GetItems(tabId)	

		for i=1,#items do
			local single = items[i]
			if(single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK)then
				local photoData = PhotoData.new(single,PhotoDataProxy.PhotoType.SceneryPhotoType)
				datas[#datas+1] = photoData
			end
		end
		if(tabId == SceneryListPage.MaxCategory.id - 1)then
			local list = {}
			for i=1,#datas do
				local single = datas[i]
				if(PhotoDataProxy.Instance:checkPhotoFrame(single))then
					list[#list+1] = single
				end
			end
			datas = list
		end
		table.sort(datas,function ( l,r )
			-- body
			return l.index < r.index
		end)
	end
	return datas
end

function SceneryListPage:refreshLRIndicator()
	local b = self.scrollView.bounds
	if(self.scrollView.panel)then
		local clip = self.scrollView.panel.finalClipRegion
		local hx = clip.z * 0.5
		local hy = clip.w * 0.5
		if (b.min.x < clip.x - hx)then
		 	self:Show(self.leftIndicator)
		else
			self:Hide(self.leftIndicator)
		end
		if (b.max.x > clip.x + hx) then
			self:Show(self.rightIndicator)
		else
			self:Hide(self.rightIndicator)
		end
	end
end

function SceneryListPage:checkSelect( )
	-- body
	if(self.itemTabs.isOpen)then
		self:Show(self.ItemTabsBgSelect)
	else
		self:Hide(self.ItemTabsBgSelect)
	end
end

function SceneryListPage:tabClick( noResetPos)
	-- body
	self:UpdateList(noResetPos)
end

function SceneryListPage:initCategoryData(  )
	-- body
	local list = {}
	local data = AdventureDataProxy.Instance:getTabsByCategory(SceneManual_pb.EMANUALTYPE_SCENERY)
	for k,v in pairs(data.childs) do
		table.insert(list,v.staticData)
	end

	table.sort(list,function ( l,r )
	-- body		
		return l.Order < r.Order
	end)

	self:Show(self.itemTabs.gameObject)	
	self.itemTabs:Clear()
	local tmpData = {}
	tmpData.id = SceneryListPage.MaxCategory.id
	tmpData.Name = string.format(ZhString.AdventurePanel_AllTab,data.staticData.Name)
	table.insert(list,1,tmpData)
	tmpData = {}
	tmpData.id = SceneryListPage.MaxCategory.id - 1
	tmpData.Name = ZhString.PersonalPictureCell_CurrentShow
	table.insert(list,tmpData)
	for i=1,#list do
		local single = list[i]
		if(single.id)then
			self.itemTabs:AddItem(single.Name,single)
		end 
	end
	

	if(#list>0)then
		self.itemTabs.value = list[1].Name
	end
end

function SceneryListPage:OnEnter()
	-- body
	TimeTickManager.Me():CreateTick(0,100,self.checkSelect,self,SceneryListPage.ClickId.CheckSelect)
end

function SceneryListPage:OnExit()
	TimeTickManager.Me():ClearTick(self)
end

function SceneryListPage:UpdateList(noResetPos)
	local bag = AdventureDataProxy.Instance.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
	if(bag)then
		local datas = self:getDatas()
		if(not datas or #datas == 0)then
			self:Show(self.emptyCt)
		else
			self:Hide(self.emptyCt)
		end
		self:SetData(datas, noResetPos);
	end
	
	-- local total = PhotoDataProxy.Instance:getPictureAblumSize()
	-- local cur = #datas
	-- if(cur>total)then
	-- 	self.curState.text = "[c][FF1212FF]"..cur.."/"..total.."[-][/c]"
	-- else
	-- 	self.curState.text = "[c][ADADADFF]"..cur.."/"..total.."[-][/c]"
	-- end	
end

function SceneryListPage:SetData(datas, noResetPos)
	local newdata = self:ReUnitData(datas, 4);
	self.wraplist:UpdateInfo(newdata);
	if(not noResetPos)then
		self.wraplist:ResetPosition()
	end
	local cells = self:GetItemCells()
	if(cells and #cells >0)then
		for i=1,#cells do
			local single = cells[i]
			single:setMode(self.showMode)
		end
	end
end

function SceneryListPage:ResetPosition()
	if(not self.hasReset)then
		self.hasReset = true
		if(self.wraplist)then
			self.wraplist:ResetPosition()
		end
	end
end
function SceneryListPage:ReUnitData(datas, rowNum)
	if(not self.unitData)then
		self.unitData = {};
	else
		TableUtility.ArrayClear(self.unitData);
	end

	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/rowNum)+1;
			local i2 = math.floor((i-1)%rowNum)+1;
			self.unitData[i1] = self.unitData[i1] or {};
			if(datas[i] == nil)then
				self.unitData[i1][i2] = nil;
			else
				self.unitData[i1][i2] = datas[i];
			end
		end
	end
	return self.unitData;
end

function SceneryListPage:GetPersonPicThumbnail(cellCtl)
	MySceneryPictureManager.Instance():log("GetPersonPicThumbnail")
	if(cellCtl and cellCtl.data)then
		MySceneryPictureManager.Instance():GetMySceneryPicThumbnail(cellCtl)
	end
end

function SceneryListPage:HandleClickItem(cellCtl)
	if(cellCtl and cellCtl.data)then
		MySceneryPictureManager.Instance():log("HandleClickItem")
		if(cellCtl.status == PersonalPictureCell.PhotoStatus.Success)then
				local viewdata = {PhotoData = cellCtl.data}
				PersonalPictureDetailPanel.ViewType = UIViewType.PopUpLayer
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.PersonalPictureDetailPanel, viewdata = viewdata});
		end
	end
end

function SceneryListPage:GetItemCellById(index)
	local cells = self:GetItemCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local single = cells[i]
			if(single.data and single.data.index == index)then
				return single
			end
		end
	end
end

function SceneryListPage:GetItemCells()
	local combineCells = self.wraplist:GetCellCtls();
	local result = {};
	for i=1,#combineCells do
		local v = combineCells[i];
		local childs = v:GetCells();
		for i=1,#childs do
			table.insert(result, childs[i]);
		end
	end
	return result;
end