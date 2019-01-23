autoImport("MySceneryPictureManager")
autoImport("PersonalTempPictureTabCell")
TempPersonalPicturePanel = class("TempPersonalPicturePanel", ContainerView)

TempPersonalPicturePanel.GetPersonPicThumbnail = "TempPersonalPicturePanel_GetPersonPicThumbnail"
TempPersonalPicturePanel.ReplacePersonPicThumbnail = "TempPersonalPicturePanel_ReplacePersonPicThumbnail"
TempPersonalPicturePanel.ReUploadingPersonPicThumbnail = "TempPersonalPicturePanel_ReUploadingPersonPicThumbnail"
TempPersonalPicturePanel.DelPersonPicThumbnail = "TempPersonalPicturePanel_DelPersonPicThumbnail"
TempPersonalPicturePanel.CancelPersonPicThumbnail = "TempPersonalPicturePanel_CancelPersonPicThumbnail"
TempPersonalPicturePanel.ViewType = UIViewType.NormalLayer

function TempPersonalPicturePanel:Init()
	-- body
	self:initView()
	self:initData()
	self:AddViewEvts()
end

function TempPersonalPicturePanel:AddViewEvts()
	self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadProgressCallback,self.SceneryThumbnailPhDlPgCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadCompleteCallback,self.SceneryThumbnailPhDlCpCallback);
	self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadErrorCallback,self.SceneryThumbnailPhDlErCallback);

	self:AddListenEvt(ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd,self.UpdateResolvedPhotoManualCmd);
end

function TempPersonalPicturePanel:SceneryThumbnailPhDlPgCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.roleId,data.index)
	if(cell and cell.data.roleId == data.roleId)then
		cell:setDownloadProgress(data.progress)
	end		
end

function TempPersonalPicturePanel:SceneryThumbnailPhDlCpCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.roleId,data.index)
	if(cell and cell.data.roleId == data.roleId)then
		self:GetPersonPicThumbnail(cell)
	end
end

function TempPersonalPicturePanel:SceneryThumbnailPhDlErCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.roleId,data.index)
	if(cell and cell.data.roleId == data.roleId)then
		cell:setDownloadFailure()
	end
end

function TempPersonalPicturePanel:UpdateResolvedPhotoManualCmd()
	local datas = AdventureDataProxy.Instance:GetAllTempScenerys()
	self.categoryList:ResetDatas(datas)	
	local cells = self.categoryList:GetCells()
	local reset = true
	for i=1,#cells do
		local singleCell = cells[i]
		self:AddTabChangeEvent(singleCell.gameObject,nil,singleCell)
		if(self.currentData and singleCell.data.roleId == self.currentData.roleId)then
			self:SetData(self.currentData,true)
			reset = false
			break
		end
	end
	if(reset and cells[1])then
		self:TabChangeHandler(cells[1])
	elseif(reset)then
		self:SetData(nil)
	end
end

function TempPersonalPicturePanel:GetItemCellById(roleId,index)
	local cells = self:GetItemCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local single = cells[i]
			if(single.data and single.data.index == index and single.data.roleId == roleId)then
				return single
			end
		end
	end
end

function TempPersonalPicturePanel:GetItemCells()
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

function TempPersonalPicturePanel:initData(  )
	-- ServicePhotoCmdProxy.Instance:CallQueryUserPhotoListPhotoCmd()
	self.showMode = self.showMode and self.showMode or PersonalPicturePanel.ShowMode.NormalMode
	local datas = AdventureDataProxy.Instance:GetAllTempScenerys()
	self.categoryList:ResetDatas(datas)	
	local cells = self.categoryList:GetCells()
	self.redData = {}
	for i=1,#cells do
		local singleCell = cells[i]
		self:AddTabChangeEvent(singleCell.gameObject,nil,singleCell)
	end
	self:TabChangeHandler(cells[1])
	self:ResetPosition()


	local currentTime = ServerTime.CurServerTime()
	currentTime = math.floor(currentTime / 1000)
	local time = AdventureDataProxy.Instance.tempAlbumTime
	local leftTime = time - currentTime
	local preText = ZhString.TempPersonalPicture_CloseTime
	if(leftTime >= 3600*24)then
		local day = math.floor(leftTime/(3600*24))
		self.closeTimeLabel.text = string.format(preText,day)
	else
		preText = ZhString.TempPersonalPicture_CloseTime_
		local h = math.floor(leftTime / 3600)
		local m = math.floor((leftTime - h*3600) / 60)
		local s = leftTime - h*3600 - m*60
		local timestr = string.format(ZhString.MainViewPolyFightPage_TimeLineDes,h,m,s)
		self.closeTimeLabel.text = string.format(preText,timestr)
	end
end

function TempPersonalPicturePanel:TabChangeHandler(cell)
	-- body
	if(cell and self.currentKey ~=cell)then
		TempPersonalPicturePanel.super.TabChangeHandler(self,cell)	
		self:handleCategoryClick(cell)		
		self.currentKey = cell
	end
end

function TempPersonalPicturePanel:handleCategoryClick( child )
	-- body
	self:SetData(child.data)
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

function TempPersonalPicturePanel:SetData( data ,noResetPos)
	-- body
	self.currentData = data
	if(not data)then
		self.wraplist:UpdateInfo({});
		return 
	end
	local datas = self:getDatas(data.scenerys)
	if(not datas or #datas == 0)then
		self:Show(self.emptyCt)
	else
		self:Hide(self.emptyCt)
	end
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
	MySceneryPictureManager.Instance():AddMySceneryThumbnailInfos(datas)
end

function TempPersonalPicturePanel:ReUnitData(datas, rowNum)
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

function TempPersonalPicturePanel:ResetPosition()
	if(not self.hasReset)then
		self.hasReset = true
		if(self.wraplist)then
			self.wraplist:ResetPosition()
		end
	end
end

function TempPersonalPicturePanel:getDatas( scenerys)
	local datas = {}
	for i=1,#scenerys do
		local single = scenerys[i]
		local photoData = PhotoData.new(single,PhotoDataProxy.PhotoType.SceneryPhotoType)
		photoData:setBelongAcc(true)
		datas[#datas+1] = photoData
	end

	table.sort(datas,function ( l,r )
		-- body
		return l.index < r.index
	end)
	return datas
end

function TempPersonalPicturePanel:initView(  )
	-- body
	local CategoryListTable = self:FindGO("TopContainer"):GetComponent(UIGrid)
	self.categoryList = UIGridListCtrl.new(CategoryListTable,PersonalTempPictureTabCell,"PersonalTempPictureTabCell")
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

	self.closeTimeLabel = self:FindComponent("closeTime",UILabel)
	self.leftIndicator = self:FindGO("leftIndicator")
	self.rightIndicator = self:FindGO("rightIndicator")
	TimeTickManager.Me():CreateTick(1000,500,self.refreshLRIndicator,self,SceneryListPage.ClickId.RefreshIndicator)	
end

function TempPersonalPicturePanel:GetPersonPicThumbnail(cellCtl)
	MySceneryPictureManager.Instance():log("GetPersonPicThumbnail")
	if(cellCtl and cellCtl.data)then
		MySceneryPictureManager.Instance():GetMySceneryPicThumbnail(cellCtl)
	end
end

function TempPersonalPicturePanel:HandleClickItem(cellCtl)
	if(cellCtl and cellCtl.data)then
		MySceneryPictureManager.Instance():log("HandleClickItem")
		if(cellCtl.status == PersonalPictureCell.PhotoStatus.Success)then
				local viewdata = {PhotoData = cellCtl.data}
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.TempPersonalPictureDetailPanel, viewdata = viewdata});
		end
	end
end

function TempPersonalPicturePanel:refreshLRIndicator()
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