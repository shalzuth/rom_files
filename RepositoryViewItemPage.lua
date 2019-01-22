RepositoryViewItemPage = class("RepositoryViewItemPage", SubView)

autoImport("ItemNormalList");
autoImport("RepositoryItemCombineItemCell")

function RepositoryViewItemPage:Init()
	self:InitUI();
end

function RepositoryViewItemPage:InitUI()
	self.normalStick = self:FindComponent("NormalStick", UISprite);

	self.leftBord=self:FindGO("leftBord")
	local listObj = self:FindGO("ItemNormalList",self.leftBord);
	self.itemlist = ItemNormalList.new(listObj,RepositoryItemCombineItemCell);

	self.itemlist.PullRefreshTip = ZhString.RepositoryNormalList_PullRefresh;
	self.itemlist.BackRefreshTip = ZhString.RepositoryNormalList_CanRefresh;

	self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self);
	self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)

	self.itemCells = self.itemlist:GetItemCells();

	self.tip = string.format(ZhString.Repository_takeoutLv , GameConfig.Item.store_takeout_baselv_req )
end

function RepositoryViewItemPage:InitShow()
	self.viewTab = self.container.viewTab

	if self.viewTab == RepositoryView.Tab.RepositoryTab then
		self.itemlist:SetScrollPullDownEvent(RepositoryViewItemPage.RepositoryPackageSort)
		self.itemlist.GetTabDatas = RepositoryViewItemPage.RepositoryTab
	elseif self.viewTab == RepositoryView.Tab.CommonTab then
		self.itemlist:SetScrollPullDownEvent(RepositoryViewItemPage.CommonPackageSort)
		self.itemlist.GetTabDatas = RepositoryViewItemPage.CommonTab
	end

	self.funcConfigId = 31
	if self.viewTab == RepositoryView.Tab.RepositoryTab then
		self.funcConfigId = 33
	end

	self:HandleItemUpdate()

	self:SetCellsLock()
	self.lock = not RepositoryViewProxy.Instance:CanTakeOut()
end

function RepositoryViewItemPage.RepositoryTab(tabConfig)
	return RepositoryViewItemPage.GetTabDatas( BagProxy.Instance:GetPersonalRepositoryBagData(), tabConfig )
end

function RepositoryViewItemPage.CommonTab(tabConfig)
	return RepositoryViewItemPage.GetTabDatas( BagProxy.Instance:GetRepositoryBagData(), tabConfig )
end

local tabDatas = {}
function RepositoryViewItemPage.GetTabDatas(bagData,tabConfig)
	TableUtility.ArrayClear(tabDatas)

	local datas = bagData:GetItems(tabConfig)
	for i=1,#datas do
		table.insert(tabDatas, datas[i])
	end
	-- ??????????????????
	local uplimit = bagData:GetUplimit()
	if uplimit>0 then
		for i=#tabDatas+1, uplimit do
			table.insert(tabDatas, BagItemEmptyType.Empty)
		end
	elseif uplimit == 0 then
		local leftEmpty = (5-#tabDatas%5)%5
		for i=1, leftEmpty do
			table.insert(tabDatas, BagItemEmptyType.Empty)
		end
	end

	if(bagData.type == BagProxy.BagType.PersonalStorage)then
		local unlockData = BagProxy.Instance:GetBagUnlockSpaceData();
		if(unlockData)then
			-- for i=1,unlockData.pstore do
				table.insert(tabDatas, {id = BagItemEmptyType.Unlock, unlockData=unlockData});
			-- end
		end
	end
	
	-- ??????5?????????
	local leftEmpty = (5-#tabDatas%5)%5
	for i=1, 10+leftEmpty do
		table.insert(tabDatas, BagItemEmptyType.Grey)
	end
	-- ????????????
	for i=#tabDatas+1, 35 do
		table.insert(tabDatas, BagItemEmptyType.Grey)
	end
	return tabDatas
end

function RepositoryViewItemPage.RepositoryPackageSort()
	ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_PERSONAL_STORE)
end

function RepositoryViewItemPage.CommonPackageSort()
	ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_STORE)
end

function RepositoryViewItemPage:OnExit()
	RepositoryViewItemPage.super.OnExit(self);
end

function RepositoryViewItemPage:ClickItem(cellCtl)
	local data = cellCtl and cellCtl.data;

	if(data ~= nil and data.id == BagItemEmptyType.Unlock)then
		MsgManager.ShowMsgByIDTable(3108, {data.unlockData.id, data.unlockData.pstore})
		return;
	end

	local go = cellCtl and cellCtl.gameObject;
	local newChooseId = data and data.id or 0;
	if(self.chooseId~=newChooseId)then
		self.chooseId = newChooseId;
		self:ShowRepositoryItemTip(data, {go});
	else
		self.chooseId = 0;
		self:ShowRepositoryItemTip();
	end
	for _,cell in pairs(self.itemCells) do
		cell:SetChooseId(self.chooseId);
	end
end

function RepositoryViewItemPage:DoubleClickItem(cellCtl)
	local data = cellCtl.data
	if data then
		self.chooseId = 0
		self:ShowRepositoryItemTip()

		if self.viewTab == RepositoryView.Tab.CommonTab then
			FunctionItemFunc.WthdrawnRepositoryEvt(data)
		else
			FunctionItemFunc.PersonalWthdrawnRepositoryEvt(data)
		end
	end
end

function RepositoryViewItemPage:ShowRepositoryItemTip(data, ignoreBounds)
	if not RepositoryViewProxy.Instance:CheckData(data) then
		self:ShowItemTip();
		return;
	end

	local callback = function ()
		self.chooseId = 0;
		for _,cell in pairs(self.itemCells) do
			cell:SetChooseId(self.chooseId);
		end
	end;

	local sdata = ReusableTable.CreateTable()
	sdata.itemdata = data
	sdata.funcConfig = {self.funcConfigId}
	sdata.ignoreBounds = ignoreBounds
	sdata.callback = callback
	if self.lock then
		sdata.tip = self.tip
	end
	self:ShowItemTip(sdata, self.normalStick, nil, {180,0});
	ReusableTable.DestroyAndClearTable(sdata)
end

function RepositoryViewItemPage:ShowPrompt()
	local data = self.container.repositoryViewBagPage.itemlist.chooseItemData
	if(data)then
		local index = 1
		for i=1,#GameConfig.ItemPage do
			for j=1,#GameConfig.ItemPage[i].types do
				if(data.staticData.Type==GameConfig.ItemPage[i].types[j])then
					index=index+i
					break
				end
			end
		end
		MsgManager.ShowEightTypeMsgByIDTable(820,{self.container.repositoryViewBagPage.itemlist.chooseItemData.num}
			,self.itemlist.ItemTabLst[index].transform.position,{0,10})
		--self.itemlist.NewTagLst[index]:SetActive(true)
	end
end

function RepositoryViewItemPage:UpdateList()
	local index = self.itemlist.nowTab or 1;
	local config = ItemNormalList.TabConfig[index].Config;
	local datas = self.itemlist.GetTabDatas(config);
	self.itemlist:SetData(datas);
end

function RepositoryViewItemPage:HandleItemUpdate(note)
	self:UpdateList();
	if(RepositoryViewProxy.Instance.curOperation==RepositoryViewProxy.Operation.DepositRepositoryEvt)then
		-- self:ShowPrompt()
		RepositoryViewProxy.Instance.curOperation=RepositoryViewProxy.Operation.Default
	end
end

--????????????
function RepositoryViewItemPage:HandleItemReArrage(note)
	AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.ReArrage));

	self:UpdateList();
	self.itemlist:ScrollViewRevert();
end

function RepositoryViewItemPage:HandleLevelUp(note)
	self:SetCellsLock()
	self.lock = not RepositoryViewProxy.Instance:CanTakeOut()
end

function RepositoryViewItemPage:SetCellsLock()
	for i=1,#self.itemCells do
		self.itemCells[i]:SetCellLock()
	end
end