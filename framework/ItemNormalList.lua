ItemNormalList = class("ItemNormalList", CoreView);

autoImport("WrapCellHelper")
autoImport("BagCombineItemCell");


local FoodPackPage = GameConfig.FoodPackPage;
ItemNormalList.TabConfig = {
	[1] = {Config = nil},
	[2] = {Config = GameConfig.ItemPage[1]},
	[3] = {Config = GameConfig.ItemPage[2]},
	[4] = {Config = GameConfig.ItemPage[3]},
	[5] = {Config = GameConfig.ItemPage[4]},
	[6] = {Config = FoodPackPage[1]},
	[7] = {Config = FoodPackPage[2]},
}

local Func_IsFoodPackageConfig = function (tabConfig)
	for i=1,#FoodPackPage do
		if(tabConfig == FoodPackPage[i])then
			return true;
		end
	end
	return false;
end

ItemNormalList.PullRefreshTip = ZhString.ItemNormalList_PullRefresh;
ItemNormalList.BackRefreshTip = ZhString.ItemNormalList_CanRefresh;
ItemNormalList.RefreshingTip = ZhString.ItemNormalList_Refreshing;

function ItemNormalList:ctor(go, control, isAddMouseClickEvent, scrollType)
	if(go)then
		self.scrollType = scrollType or ROUIScrollView;

		ItemNormalList.super.ctor(self, go);
		self.control = control or BagCombineItemCell;
		if(isAddMouseClickEvent==true or isAddMouseClickEvent==nil)then
			self.isAddMouseClickEvent=true
		else
			self.isAddMouseClickEvent=false
		end
		self:Init();
	else
		error("can not find itemListObj");
	end
end

function ItemNormalList:Init()
	self.nowTab = 1
	self.tabMap = {};
	for i=1,#ItemNormalList.TabConfig do
		local obj = self:FindGO("ItemTab"..i);
		if obj then
			local comps = UIUtil.GetAllComponentsInChildren(obj, UISprite);
			for i=1,#comps do
				comps[i]:MakePixelPerfect();
			end
			local index = i;
			self:AddClickEvent(obj, function (go)
				self.nowTab = index;
				self:UpdateList();
			end);
			self.tabMap[i] = obj:GetComponent(UIToggle);
		end
	end

	local itemContainer = self:FindGO("bag_itemContainer");
	local control = self.control;
	local wrapConfig = {
		wrapObj = itemContainer, 
		pfbNum = 7, 
		cellName = "BagCombineItemCell", 
		control = control, 
		dir = 1,
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	if(self.isAddMouseClickEvent)then
		self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);
		self.wraplist:AddEventListener(MouseEvent.DoubleClick, self.HandleDClickItem, self);
	end

	self.waitting = self:FindComponent("Waitting", UILabel);
	self.scrollView = self:FindComponent("ItemScrollView", self.scrollType);
	self.panel = self.scrollView.gameObject:GetComponent(UIPanel)
	self.scrollView.OnBackToStop = function ()
		if(not self.waitting)then
			return;
		end
		self.waitting.text = self.RefreshingTip;
	end
	self.scrollView.OnStop = function ()
		self:ScrollViewRevert();
	end
	self.scrollView.OnPulling = function (offsetY, triggerY)
		if(not self.waitting)then
			return;
		end
		self.waitting.text = offsetY<triggerY and self.PullRefreshTip or self.BackRefreshTip;
	end
	self.scrollView.OnRevertFinished = function ()
		if(not self.waitting)then
			return;
		end
		self.waitting.text = self.PullRefreshTip;
		if(self.revertCallBack)then
			self.revertCallBack();
		end
	end
	self.scrollView.onDragStarted = function ()
		if self.initPanelClipMove == nil then
			self:AddPanelClipMove()
			self.initPanelClipMove = true
		end
		if self.scrollView.canMoveVertically then
			self.panelClipOffset = self.panel.clipOffset.y
		elseif self.scrollView.canMoveHorizontally then
			self.panelClipOffset = self.panel.clipOffset.x
		end
	end

	self.scrollView.onDragFinished = function ()
		self.panelClipOffset = nil
		self.isDrag = false
		self:SetCellScrollView(false)
	end

	self.itemTabs = self:FindComponent("ItemTabs", UIGrid);
end

function ItemNormalList:InitTabList()
	self:UpdateTabList( BagProxy.BagType.MainBag )
end

function ItemNormalList:AddPanelClipMove()
	self.panel.onClipMove = {"+=", function (panel)
		if self.panelClipOffset and not self.isDrag then
			local clipOffset
			if self.scrollView.canMoveVertically then
				clipOffset = self.panel.clipOffset.y
			elseif self.scrollView.canMoveHorizontally then
				clipOffset = self.panel.clipOffset.x
			end			
			if math.abs(self.panelClipOffset - clipOffset) > 1 then
				self.isDrag = true

				self:SetCellScrollView(true)
			end
		end
	end}
end

function ItemNormalList:SetCellScrollView(isDrag)
	local combineCells = self.wraplist:GetCellCtls()
	for i=1,#combineCells do
		local cell = combineCells[i]
		for j=1,#cell:GetCells() do
			local childCell = cell:GetCells()[j]
			if childCell.data then
				if childCell.dragDrop then
					childCell.dragDrop:SetScrollView(isDrag)
				else
					break
				end
			end
		end
	end
end

function ItemNormalList:UpdateTabList( bagType )
	self.nowTab = 1
	self.nowBagType = bagType
	if bagType == BagProxy.BagType.Food then
		for i=2,7 do
			local tab = self.tabMap[i]
			if tab then
				self.tabMap[i].gameObject:SetActive(i > 5)
				self.tabMap[i]:Set(false)
			end
		end
	else
		for i=2,7 do
			local tab = self.tabMap[i]
			if tab then
				self.tabMap[i].gameObject:SetActive(i < 6)
				self.tabMap[i]:Set(false)
			end
		end
	end
	self.itemTabs:Reposition()
	self.tabMap[1]:Set(true)
end

function ItemNormalList:HandleClickItem(cellCtl)
	self:PassEvent(ItemEvent.ClickItem, cellCtl);
end

function ItemNormalList:HandleDClickItem(cellCtl)
	self:PassEvent(ItemEvent.DoubleClickItem, cellCtl);
end

function ItemNormalList:ChooseTab(tab)
	self.tabMap[tab].value = true;
	self.nowTab = tab;
	self:UpdateList();
end

function ItemNormalList:UpdateList(noResetPos)
	local index = self.nowTab or 1;
	local config = ItemNormalList.TabConfig[index].Config;
	local datas = self.GetTabDatas(config);
	self:SetData(datas, noResetPos);
end

function ItemNormalList:SetData(datas, noResetPos)
	if(not noResetPos)then
		self:ResetPosition();
	end
	self.wraplist:UpdateInfo(self:ReUnitData(datas, 5));
end

function ItemNormalList:ResetPosition()
	if(self.wraplist == nil)then
		return;
	end

	self.wraplist:ResetPosition();
end

function ItemNormalList:ReUnitData(datas, rowNum)
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

function ItemNormalList:SetScrollPullDownEvent(evt, evtParam)
	self.scrollView.OnStop = function ()
		if(type(evt) == "function")then
			evt(evtParam);
		end
	end
end

function ItemNormalList:ScrollViewRevert(callback)
	self.revertCallBack = callback;
	self.scrollView:Revert();
end

-- cannot insert when outside do
local tabDatas = {};
function ItemNormalList.GetTabDatas(tabConfig)
	TableUtility.ArrayClear(tabDatas);

	local datas
	if(Func_IsFoodPackageConfig(tabConfig))then
		datas = BagProxy.Instance.foodBagData:GetItems(tabConfig);
	else
		datas = BagProxy.Instance.bagData:GetItems(tabConfig);
	end
	for i=1,#datas do
		table.insert(tabDatas, datas[i]);
	end
	return tabDatas;
end

function ItemNormalList:AddCellEventListener(eventType,handler,handlerOwner)
	self.wraplist:AddEventListener(eventType, handler, handlerOwner);
end

function ItemNormalList:GetItemCells()
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