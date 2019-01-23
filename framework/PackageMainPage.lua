PackageMainPage = class("PackageMainPage", SubView)

autoImport("ItemNormalList");
autoImport("BagCombineDragItemCell");
autoImport("QuestPackagePart");
autoImport("FoodPackagePart");

local petAdventureItemId = 5504
function PackageMainPage:Init()
	self:AddViewEvts();
	self:InitUI();
end

function PackageMainPage:OnEnter()
	PackageMainPage.super.OnEnter(self);
	
	self:UpdateCoins();

	self.itemlist:ChooseTab(1);
	-- self.itemlist:UpdateList(false, 1);
end


local tabDatas = {};
local addGreyDatas = {};
function PackageMainPage:InitUI()
	self.normalStick = self:FindComponent("NormalStick", UISprite);
	-- 背包装备列表 ItemNormalList
	local listObj = self:FindGO("ItemNormalList");
	self.itemlist = ItemNormalList.new(listObj, BagCombineDragItemCell, nil, PullStopScrollView);	
	self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self);
	self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self);
	self.itemlist.GetTabDatas = PackageMainPage.GetTabDatas;
	self.itemlist.scrollView.onDragStarted = function () 
		self:ShowItemTip()
	end

	self.itemCells = self.itemlist:GetItemCells();
	-- 背包界面的角色货币信息
	local coins = self:FindChild("TopCoins");
	self.lottery = self:FindChild("Lottery", coins);
	self.lotterylabel = self:FindComponent("Label", UILabel, self.lottery);
	local icon = self:FindComponent("symbol", UISprite, self.lottery);
	IconManager:SetItemIcon(Table_Item[151].Icon, icon);
	self.userRob = self:FindChild("Silver", coins);
	self.robLabel = self:FindComponent("Label", UILabel, self.userRob);

	local storeButton = self:FindGO("StoreButton");
	self:AddClickEvent(storeButton, function (go)
		self:TryeDoQuick();
	end);
	local saleButton = self:FindGO("SaleButton");
	self:AddClickEvent(saleButton, function (go)
		self:DoSaleButton();
	end);
	local rearrayButton = self:FindGO("RearrayButton");
	self:AddClickEvent(rearrayButton, function (go)
		self:DoRearrayButton();
	end);
end

function PackageMainPage:TryeDoQuick()
	self.st = ReusableTable.CreateArray();
	BagProxy.Instance:CollectQuickStorageItems(self.st);

	if(#self.st == 0)then
		TableUtility.ArrayClear(self.st)
		ReusableTable.DestroyArray(self.st);
		MsgManager.ShowMsgByIDTable(25426);
		return;
	end

	local dont = LocalSaveProxy.Instance:GetDontShowAgain(25424)
	if(dont == nil)then
		MsgManager.DontAgainConfirmMsgByID(25424, function ()
			self:DoQuickStore();
		end, nil, nil)
	else
		self:DoQuickStore();
	end
end

function PackageMainPage:DoQuickStore() 
	helplog("Do QuickStore");
	self.st = ReusableTable.CreateArray();
	BagProxy.Instance:CollectQuickStorageItems(self.st);

	local items = ReusableTable.CreateArray();
	for i=1,#self.st do
		local item = self.st[i];

		local sitem = SceneItem_pb.SItem()
		sitem.guid, sitem.count = item.id, item.num or 0;
		table.insert(items, sitem);
	end

	ServiceItemProxy.Instance:CallQuickStoreItemCmd(items);

	ReusableTable.DestroyArray(items);

	TableUtility.ArrayClear(self.st)
	ReusableTable.DestroyArray(self.st);
end

function PackageMainPage:DoSaleButton()
	helplog("DoSaleButton In");
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.CollectSaleConfirmPopUp});
end

function PackageMainPage:DoRearrayButton()
	helplog("DoRearrayButton In");
	ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN); 
end

function PackageMainPage:GetQuestPackageBord()
	if(self.init_questPacakgeBord)then
		return self.questPackageBord
	end
	self.init_questPacakgeBord = true;

	local qpParent = self:FindGO("QuestPackageParent");
	self.questPackageBord = QuestPackagePart.new();
	self.questPackageBord:CreateSelf(qpParent);
	self.questPackageBord:Hide();

	return self.questPackageBord;
end

function PackageMainPage:GetFoodPackageBord()
	if(self.init_foodPacakgeBord)then
		return self.foodPackageBord
	end
	self.init_foodPacakgeBord = true;
	
	local qpParent = self:FindGO("QuestPackageParent");
	self.foodPackageBord = FoodPackagePart.new();
	self.foodPackageBord:CreateSelf(qpParent);
	self.foodPackageBord:Hide();

	return self.foodPackageBord;
end

function PackageMainPage.GetTabDatas(tabConfig)
	TableUtility.ArrayClear(tabDatas);

	local bagData = BagProxy.Instance.bagData;
	local datas = bagData:GetItems(tabConfig);
	for i=1,#datas do
		table.insert(tabDatas, datas[i]);
	end
	
	-- 添加上限空格
	local uplimit = bagData:GetUplimit();
	if(uplimit>0)then
		for i=#tabDatas+1, uplimit do
			table.insert(tabDatas, BagItemEmptyType.Empty);
		end
	elseif(uplimit == 0)then
		local leftEmpty = (5-#tabDatas%5)%5;
		for i=1, leftEmpty do
			table.insert(tabDatas, BagItemEmptyType.Empty);
		end
	end

	local unlockData = BagProxy.Instance:GetBagUnlockSpaceData();
	if(unlockData)then
		-- for i=1,unlockData.pack do
			table.insert(tabDatas, {id = BagItemEmptyType.Unlock, unlockData=unlockData});
		-- end
	end
	
	-- 凑足5的倍数
	local leftEmpty = (5-#tabDatas%5)%5;
	for i=1, 10+leftEmpty do
		table.insert(tabDatas, BagItemEmptyType.Grey);
	end
	-- 格子拼满
	for i=#tabDatas+1, 35 do
		table.insert(tabDatas, BagItemEmptyType.Grey);
	end
	return tabDatas;
end

function PackageMainPage:RemoveReArrageSafeLT()
	if(self.reArrageSafeLT)then
		self.reArrageSafeLT:cancel();
		self.reArrageSafeLT = nil;
	end
end

function PackageMainPage:PullDownPackage()
	self:RemoveReArrageSafeLT();
	self.reArrageSafeLT = LeanTween.delayedCall(3, function ()
		self:HandleItemReArrage();		
	end);

	ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN); 
end

function PackageMainPage:ClickItem(cellCtl)
	local data = cellCtl and cellCtl.data;
	if(data == BagItemEmptyType.Empty or 
		data == BagItemEmptyType.Grey)then
		data = nil;
	end

	if(data ~= nil and data.id == BagItemEmptyType.Unlock)then
		MsgManager.ShowMsgByIDTable(3107, {data.unlockData.id, data.unlockData.pack})
		return;
	end

	local go = cellCtl and cellCtl.gameObject;
	local newChooseId = data and data.id or 0;
	if(self.chooseId~=newChooseId)then
		self.chooseId = newChooseId;

		if(type(data) == "table")then
			local sid = data.staticData.id;
			if(sid == 5045)then
				self:ShowQuestPackage();
			elseif(sid == 5047)then
				self:ShowFoodPackage();
			else
				self:ShowPackageItemTip(data, {go});
			end
		else
			self:ShowPackageItemTip(data, {go});
		end
	else
		self.chooseId = 0;
		self:ShowPackageItemTip();
	end
	for _,cell in pairs(self.itemCells) do
		cell:SetChooseId(self.chooseId);
	end
end

function PackageMainPage:DoubleClickItem(cellCtl)
	local data = cellCtl.data;
	if(data == BagItemEmptyType.Empty or 
		data == BagItemEmptyType.Grey)then
		data = nil;
	end

	if(data ~= nil and data.id == BagItemEmptyType.Unlock)then
		return;
	end
	
	if(data)then
		local func, funcId;
		if(self.container.viewState == PackageView.LeftViewState.BarrowBag)then
			func, funcId = FunctionItemFunc.Me():GetFuncById(37), 37;
		else
			func, funcId = self.container:GetItemDefaultFunc(data, FunctionItemFunc_Source.MainBag);
		end

		if(func)then
			-- 如果不处于人物装备状态 非时装装备装备时需要切换回人物装备面板
			if(self.container.viewState ~= PackageView.LeftViewState.Default and funcId==4)then
				self.container:SetLeftViewState(PackageView.LeftViewState.Default);
			end
			func(data);
		end

		self:ShowPackageItemTip();
		self.chooseId = 0;
		for _,cell in pairs(self.itemCells) do
			cell:SetChooseId(self.chooseId);
		end
	end
end

function PackageMainPage:ShowPackageItemTip(data, ignoreBounds)
	if(data == nil)then
		self:ShowItemTip();
		return;
	end

	local callback = function ()
		self.chooseId = 0;
		for _,cell in pairs(self.itemCells) do
			cell:SetChooseId(self.chooseId);
		end
	end;
	local sdata = {
		itemdata = data, 
		showUpTip = true,
		funcConfig = self.container:GetDataFuncs(data),
		ignoreBounds = ignoreBounds,
		callback = callback,
	};


	local comps, offset = {}, {-210,0};
	if(self.container.viewState ~= PackageView.LeftViewState.BarrowBag)then
		if(data.equipInfo or data:IsMount())then
			local site;
			if(data:IsMount())then
				site = GameConfig.EquipType[13].site;
			else
				site = data.equipInfo:GetEquipSite();
			end
			for i=1,#site do
				local comp = BagProxy.Instance.roleEquip:GetEquipBySite(site[i]);
				if(comp)then
					table.insert(comps, comp);
				end
			end
		end
	end
	sdata.compdata1 = comps[1];
	sdata.compdata2 = comps[2];
	if(comps[1])then
		offset = {0,0};
	end
	self:ShowItemTip(sdata, self.normalStick, nil, offset);
end

function PackageMainPage:ShowQuestPackage()
	local bord = self:GetQuestPackageBord();
	bord:UpdateInfo();
	bord:Show();
end

function PackageMainPage:ShowFoodPackage()
	local bord = self:GetFoodPackageBord();
	bord:UpdateInfo();
	bord:Show();
end

function PackageMainPage:SetItemDragEnabled(b)
	for i=1,#self.itemCells do
		self.itemCells[i]:CanDrag(b)
	end
end

function PackageMainPage:UpdateList()
	self.itemlist:UpdateList(true);
end

function PackageMainPage:UpdateCoins()
	-- self.goldLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetGold());
	self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB());
	self.lotterylabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery());
end

function PackageMainPage:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate,self.HandleItemUpdate);
	self:AddListenEvt(ItemEvent.EquipUpdate,self.HandleItemUpdate);
	self:AddListenEvt(ItemEvent.ItemReArrage,self.HandleItemReArrage);
	self:AddListenEvt(MyselfEvent.MyDataChange,self.UpdateCoins);
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleItemUpdate);
	self:AddListenEvt(ServiceEvent.ItemPackSlotNtfItemCmd, self.HandleItemUpdate);
	self:AddListenEvt(ServiceEvent.ItemPackageSort, self.HandleItemUpdate);
end

function PackageMainPage:HandleItemUpdate(note)
	self:UpdateList();
end

--装备更新
function PackageMainPage:HandleItemReArrage(note)
	self:RemoveReArrageSafeLT();

	AudioUtility.PlayOneShot2D_Path( ResourcePathHelper.AudioSEUI(AudioMap.UI.ReArrage) )
	local callback = function ()
		self:UpdateList();
	end
	self.itemlist:ScrollViewRevert(callback);
end

function PackageMainPage:OnShow()
	if(self.itemlist == nil)then
		return;
	end
	
	if(self.itemlist.panel)then
		self.itemlist.panel:SetDirty();
	end
	self.itemlist:ResetPosition();
end

function PackageMainPage:OnExit()
	self:RemoveReArrageSafeLT();
	-- cancel choose
	self.chooseId = 0;
	self:ShowPackageItemTip();
	for _,cell in pairs(self.itemCells) do
		cell:SetChooseId(self.chooseId);
	end
	
	PackageMainPage.super.OnExit(self);
end

-- Test
