autoImport("PersonalListPage")
autoImport("PersonalPictureDetailPanel")
PictureWallPersonalListPage = class("PictureWallPersonalListPage",PersonalListPage)

function PictureWallPersonalListPage:initData()	
	self.SortLabel = {{id = 1,Name = ZhString.PersonalPictureCell_AscentSort},{id = 2,Name = ZhString.PersonalPictureCell_DescentSort},{id = 3,Name = ZhString.PersonalPictureCell_CurrentShow}}
	self:initCategoryData()	
	TimeTickManager.Me():CreateTick(1000,500,self.refreshLRIndicator,self,PersonalListPage.ClickId.RefreshIndicator)
	local datas = PhotoDataProxy.Instance:getAllPhotoes()	
	PersonalPictureManager.Instance():AddMyThumbnailInfos(datas)
	self:UpdateList()
end

function PictureWallPersonalListPage:initView()
	self.gameObject = self:FindGO("PersonalListPage")
	local itemContainer = self:FindGO("bag_itemContainer");
	local pfbNum = 7

	local wrapConfig = {
		wrapObj = itemContainer,
		pfbNum = pfbNum,		
		cellName = "PersonalPicturCombineItemWallCell",
		control = PersonalPicturCombineItemWallCell,
		dir = 2,
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);
	self.wraplist:AddEventListener(PersonalPicturePanel.GetPersonPicThumbnail, self.GetPersonPicThumbnail, self);
	-- self.wraplist:AddEventListener(PicutureWallSyncPanel.CellSelectedChange, self.CellSelectedChange, self);
	self.wraplist:AddEventListener(PicutureWallSyncPanel.CheckCurPicIsShow, self.CheckCurPicIsShow, self);

	self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView);
	self.scrollView.OnStop = function ()
		self:ScrollViewRevert();
	end

	self.emptyCt = self:FindGO("emptyCt")
	local emptyDes = self:FindComponent("emptyDes",UILabel)
	emptyDes.text = ZhString.PersonalPicturePanel_AlbumStateEmpty
	local emptySp = self:FindComponent("emptySp",UISprite)
	emptySp:UpdateAnchors()

	self.leftIndicator = self:FindGO("leftIndicator")
	self.rightIndicator = self:FindGO("rightIndicator")

	self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
	self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
	EventDelegate.Add(self.itemTabs.onChange,function()
		if self.selectTabData ~= self.itemTabs.data then
			self.selectTabData = self.itemTabs.data
			self:tabClick()
		end
	end)
end

function PictureWallPersonalListPage:CheckCurPicIsShow(cellCtl)
	if(cellCtl and cellCtl.data)then
		self.container:CheckCurPicIsShow(cellCtl)
	end
end

function PictureWallPersonalListPage:CellSelectedChange(cellCtl)
	if(cellCtl and cellCtl.data)then
		local isselect = cellCtl:IsSelected()
		if(isselect)then
			self.container:RemovePhotoData(cellCtl)
		else
			self.container:AddPhotoData(cellCtl)
		end
	end
end

function PictureWallPersonalListPage:RefreshUIByMode()

end

function PictureWallPersonalListPage:HandleClickItem(cellCtl)
	if(cellCtl and cellCtl.data)then
		MySceneryPictureManager.Instance():log("HandleClickItem")
		if(cellCtl.status == PersonalPictureCell.PhotoStatus.Success)then
				local viewdata = {PhotoData = cellCtl.data,from = self.container.from,frameId = self.container.frameId}
				PersonalPictureDetailPanel.ViewType = UIViewType.Lv4PopUpLayer
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.PersonalPictureDetailPanel, viewdata = viewdata});
		end
	end
end

function PictureWallPersonalListPage:CheckDirection(anglez,frameDir)
	local dir = 0
	if(anglez >=45 and anglez <= 135)then
		dir = 1
	elseif(anglez >= 225 and anglez <= 315)then
		dir = 1
	end
	if(self.container.frameId == 0)then
		dir = frameDir
	end
	return dir == frameDir
end

function PictureWallPersonalListPage:UpdateList(noResetPos)
	local allDatas = PhotoDataProxy.Instance:getAllPhotoes()
	local datas = {}
	local frameData = self.container.frameId and Table_ScenePhotoFrame[self.container.frameId]
	local dir = 0
	if(frameData)then
		dir = frameData.Dir
	end	

	for i=1,#allDatas do
		local single = allDatas[i]
		local anglez = single.anglez
		if(self:CheckDirection(anglez,dir) and single.isupload)then
			datas[#datas +1] = single
		end
	end
	
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