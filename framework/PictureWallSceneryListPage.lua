autoImport("SceneryListPage")
autoImport("PersonalPictureDetailPanel")

PictureWallSceneryListPage = class("PictureWallSceneryListPage",SceneryListPage)

function PictureWallSceneryListPage:initData()
	self:initCategoryData()	
	self:UpdateList()
	TimeTickManager.Me():CreateTick(1000,500,self.refreshLRIndicator,self,SceneryListPage.ClickId.RefreshIndicator)
	local datas = self:getDatas()
	MySceneryPictureManager.Instance():AddMySceneryThumbnailInfos(datas)	
end
function PictureWallSceneryListPage:initView()
	self.gameObject = self:FindGO("SceneryListPage")
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
	EventDelegate.Add(self.itemTabs.onChange, function()
		if self.selectTabData ~= self.itemTabs.data then
			self.selectTabData = self.itemTabs.data
			self:tabClick()
		end
	end)
end

function PictureWallSceneryListPage:HandleClickItem(cellCtl)
	if(cellCtl and cellCtl.data)then
		MySceneryPictureManager.Instance():log("HandleClickItem")
		if(cellCtl.status == PersonalPictureCell.PhotoStatus.Success)then
				local viewdata = {PhotoData = cellCtl.data,from = self.container.from,frameId = self.container.frameId}
				PersonalPictureDetailPanel.ViewType = UIViewType.Lv4PopUpLayer
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.PersonalPictureDetailPanel, viewdata = viewdata});
		end
	end
end

function PictureWallSceneryListPage:CellSelectedChange(cellCtl)
	if(cellCtl and cellCtl.data)then
		local isselect = cellCtl:IsSelected()
		if(isselect)then
			self.container:RemovePhotoData(cellCtl)
		else
			self.container:AddPhotoData(cellCtl)
		end
	end
end

function PictureWallSceneryListPage:CheckDirection(anglez,frameDir)
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

function PictureWallSceneryListPage:UpdateList(noResetPos)
	local bag = AdventureDataProxy.Instance.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
	if(bag)then
		local allDatas = self:getDatas()
		local datas = {}
		local frameData = self.container.frameId and Table_ScenePhotoFrame[self.container.frameId]
		local dir = 0
		if(frameData)then
			dir = frameData.Dir
		end

		for i=1,#allDatas do
			local single = allDatas[i]
			local anglez = single.anglez
			if(self:CheckDirection(anglez,dir))then
				datas[#datas +1] = single
			end
		end

		if(not datas or #datas == 0)then
			self:Show(self.emptyCt)
		else
			self:Hide(self.emptyCt)
		end
		self:SetData(datas, noResetPos);
	end
end

function PictureWallSceneryListPage:CheckCurPicIsShow(cellCtl)
	if(cellCtl and cellCtl.data)then
		self.container:CheckCurPicIsShow(cellCtl)
	end
end