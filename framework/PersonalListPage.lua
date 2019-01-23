PersonalListPage = class("PersonalListPage", SubView)

autoImport("WrapCellHelper")
autoImport("PersonalPictureCell")
autoImport("PersonalPicturCombineItemCell")
autoImport("PersonalPictureDetailPanel")

PersonalListPage.ClickId = {
	RefreshIndicator = 1,
	CheckSelect = 2,
}

function PersonalListPage:Init()
	self:AddViewEvts();
	self:initView();
	self:initData()
end

function PersonalListPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.PhotoCmdPhotoUpdateNtf,self.PhotoCmdPhotoUpdateNtf);
	self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoUploadProgressCallback,self.PersonalOriginPhUpPgCallback);
	self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoUploadCompleteCallback,self.PersonalOriginPhUpCpCallback);
	self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoUploadErrorCallback,self.PersonalOriginPhUpErCallback);

	self:AddListenEvt(PersonalPictureManager.PersonalThumbnailDownloadProgressCallback,self.PersonalThumbnailPhDlPgCallback);
	self:AddListenEvt(PersonalPictureManager.PersonalThumbnailDownloadCompleteCallback,self.PersonalThumbnailPhDlCpCallback);
	self:AddListenEvt(PersonalPictureManager.PersonalThumbnailDownloadErrorCallback,self.PersonalThumbnailPhDlErCallback);
end

function PersonalListPage:PersonalThumbnailPhDlPgCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell)then
		cell:setDownloadProgress(data.progress)
	end
end

function PersonalListPage:PersonalThumbnailPhDlCpCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell)then
		self:GetPersonPicThumbnail(cell)
	end
end

function PersonalListPage:PersonalThumbnailPhDlErCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell)then
		cell:setDownloadFailure()
	end
end

function PersonalListPage:PersonalOriginPhUpPgCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell)then
		cell:setUploadProgress(data.progress)
	end		
end

function PersonalListPage:PersonalOriginPhUpCpCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell)then
		cell:setUploadSuccess()
	end
end

function PersonalListPage:PersonalOriginPhUpErCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.index)
	if(cell)then
		cell:setUploadFailure()
	end
end


function PersonalListPage:CancelPersonPicThumbnail(cellCtl)
	PersonalPictureManager.Instance():log("CancelPersonPicThumbnail")
	self:DelPersonPicThumbnail(cellCtl)
	-- if(cellCtl and cellCtl.data)then
	-- 	PersonalPhoto.Ins():StopUpload(cellCtl.data.index)
	-- end
end

function PersonalListPage:ReUploadingPersonPicThumbnail(cellCtl)
	PersonalPictureManager.Instance():log("ReUploadingPersonPicThumbnail")
	PersonalPictureManager.Instance():UploadPhoto(cellCtl.data.index,cellCtl.data.time)
end

function PersonalListPage:DelPersonPicThumbnail(cellCtl)
	PersonalPictureManager.Instance():log("DelPersonPicThumbnail")
	if(cellCtl and cellCtl.data)then
		MsgManager.ConfirmMsgByID(993, function ()
			PersonalPictureManager.Instance():removePhotoFromeAlbum(cellCtl.data.index,cellCtl.data.time)
		end, nil)
	end
end

function PersonalListPage:ReplacePersonPicThumbnail(cellCtl)
	if(cellCtl and cellCtl.data)then
		MsgManager.ConfirmMsgByID(992, function ()
			if(self.callback)then
				PersonalPictureManager.Instance():log("ReplacePersonPicThumbnail:",cellCtl.data.index)
				self.callback(cellCtl.data.index)
			end
			self.container:CloseSelf()
		end, nil)
	end	
end

function PersonalListPage:PhotoCmdPhotoUpdateNtf( note )
	self:UpdateList(true)
end

function PersonalListPage:initView()
	self.gameObject = self:FindGO("PersonalListPage")
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
	self.wraplist:AddEventListener(PersonalPicturePanel.ReplacePersonPicThumbnail, self.ReplacePersonPicThumbnail, self);
	self.wraplist:AddEventListener(PersonalPicturePanel.ReUploadingPersonPicThumbnail, self.ReUploadingPersonPicThumbnail, self);
	self.wraplist:AddEventListener(PersonalPicturePanel.DelPersonPicThumbnail, self.DelPersonPicThumbnail, self);
	self.wraplist:AddEventListener(PersonalPicturePanel.CancelPersonPicThumbnail, self.CancelPersonPicThumbnail, self);

	self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView);
	self.scrollView.OnStop = function ()
		self:ScrollViewRevert();
	end

	self.emptyCt = self:FindGO("emptyCt")
	local emptyDes = self:FindComponent("emptyDes",UILabel)
	emptyDes.text = ZhString.PersonalPicturePanel_AlbumStateEmpty
	local emptySp = self:FindComponent("emptySp",UISprite)
	emptySp:UpdateAnchors()
	
	self.albumState = self:FindComponent("albumState",UILabel)
	self.albumState.text = ZhString.PersonalPicturePanel_AlbumStateFull

	self.curState = self:FindComponent("CurState",UILabel)

	self.EditorModeLabel = self:FindComponent("EditorModeLabel",UILabel)
	self.EditorMode = self:FindGO("EditorMode")
	self:AddClickEvent(self.EditorMode,function (  )
		-- body
		if(self.showMode == PersonalPicturePanel.ShowMode.NormalMode)then
			self.showMode = PersonalPicturePanel.ShowMode.EditorMode
		else
			self.showMode = PersonalPicturePanel.ShowMode.NormalMode
		end
		self:RefreshUIByMode()
	end)

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
	self.categoryList = self:FindGO("PeronalTabPanel")
end

local tempPos = LuaVector3.zero
function PersonalListPage:RefreshUIByMode()
	if(self.showMode == PersonalPicturePanel.ShowMode.ReplaceMode)then
		self:Show(self.albumState.gameObject)
		self:Hide(self.EditorMode)
		tempPos:Set(-262,308,0)
		self.categoryList.transform.localPosition = tempPos
		self.albumState:UpdateAnchors()
	elseif(self.showMode == PersonalPicturePanel.ShowMode.EditorMode)then
		self.EditorModeLabel.text = ZhString.PersonalPicturePanel_ShowModeEditor_1
		self:Show(self.EditorMode)
	else
		self:Show(self.EditorMode)
		self.EditorModeLabel.text = ZhString.PersonalPicturePanel_ShowModeEditor
		self:Hide(self.albumState.gameObject)
	end
	local cells = self:GetItemCells()
	if(cells and #cells >0)then
		for i=1,#cells do
			local single = cells[i]
			single:setMode(self.showMode)
		end
	end
end

function PersonalListPage:initData(  )
	-- body
	self.showMode = self.container.showMode
	self.showMode = self.showMode and self.showMode or PersonalPicturePanel.ShowMode.NormalMode
	self.callback = self.container.callback
	self.SortLabel = {{id = 1,Name = ZhString.PersonalPictureCell_AscentSort},{id = 2,Name = ZhString.PersonalPictureCell_DescentSort},{id = 3,Name = ZhString.PersonalPictureCell_CurrentShow}}
	self:initCategoryData()
	self:UpdateList()
	TimeTickManager.Me():CreateTick(1000,500,self.refreshLRIndicator,self,PersonalListPage.ClickId.RefreshIndicator)
	local datas = PhotoDataProxy.Instance:getAllPhotoes()	
	PersonalPictureManager.Instance():AddMyThumbnailInfos(datas)
end

function PersonalListPage:refreshLRIndicator()
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

function PersonalListPage:checkSelect( )
	-- body
	if(self.itemTabs.isOpen)then
		self:Show(self.ItemTabsBgSelect)
	else
		self:Hide(self.ItemTabsBgSelect)
	end
end

function PersonalListPage:tabClick( noResetPos)
	-- body
	self:UpdateList(noResetPos)
end

function PersonalListPage:initCategoryData(  )
	-- body
	local list = {}
	for i=1,#self.SortLabel do
		local single = self.SortLabel[i]
		table.insert(list,single)
	end

	self:Show(self.itemTabs.gameObject)

	self.itemTabs:Clear()
	for i=1,#list do
		local single = list[i]
		if(single.id)then
			self.itemTabs:AddItem(single.Name,single)
		end 
	end
	if(#list>1)then
		self.itemTabs.value = list[1].Name
	end
end

function PersonalListPage:OnEnter()
	-- body
	TimeTickManager.Me():CreateTick(0,100,self.checkSelect,self,PersonalListPage.ClickId.CheckSelect)
end

function PersonalListPage:OnExit()
	TimeTickManager.Me():ClearTick(self)
end

function PersonalListPage:UpdateList(noResetPos)
	local datas = PhotoDataProxy.Instance:getAllPhotoes()

	local sortMode = 1
	if(self.selectTabData)then
		sortMode = self.selectTabData.id
	end

	if(sortMode == 3)then
		local list = {}
		for i=1,#datas do
			local single = datas[i]
			if(PhotoDataProxy.Instance:checkPhotoFrame(single))then
				list[#list+1] = single
			end
		end
		datas = list
	end

	if(not datas or #datas == 0)then
		self:Show(self.emptyCt)
	else
		self:Hide(self.emptyCt)
	end
	local total = PhotoDataProxy.Instance:getPictureAblumSize()
	local cur = #datas
	if(cur>total)then
		self.curState.text = "[c][FF1212FF]"..cur.."/"..total.."[-][/c]"
	else
		self.curState.text = "[c][ADADADFF]"..cur.."/"..total.."[-][/c]"
	end

	table.sort(datas,function ( l,r )
		-- body
		if(sortMode == 2)then
			return l.time < r.time
		else
			return l.time > r.time
		end
	end)
	self:SetData(datas, noResetPos);
	self:RefreshUIByMode()	
end

function PersonalListPage:SetData(datas, noResetPos)
	local newdata = self:ReUnitData(datas, 4);
	self.wraplist:UpdateInfo(newdata);
	if(not noResetPos)then
		self.wraplist:ResetPosition()
	end
end

function PersonalListPage:ReUnitData(datas, rowNum)
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

function PersonalListPage:GetPersonPicThumbnail(cellCtl)
	if(cellCtl and cellCtl.data)then
		PersonalPictureManager.Instance():GetPersonPicThumbnail(cellCtl)
	end
end

function PersonalListPage:HandleClickItem(cellCtl)
	if(cellCtl and cellCtl.data and self.showMode ~= PersonalPicturePanel.ShowMode.ReplaceMode)then
		PersonalPictureManager.Instance():log("HandleClickItem")
		if(cellCtl.status == PersonalPictureCell.PhotoStatus.Success or 
			cellCtl.status == PersonalPictureCell.PhotoStatus.CanReUploading or
			cellCtl.status == PersonalPictureCell.PhotoStatus.Uploading)then
				local viewdata = {PhotoData = cellCtl.data}
				PersonalPictureDetailPanel.ViewType = UIViewType.PopUpLayer
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.PersonalPictureDetailPanel, viewdata = viewdata});
		end
	end
end

function PersonalListPage:GetItemCellById(index)
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

function PersonalListPage:GetItemCells()
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