PackageBarrowBagPage = class("PackageBarrowBagPage", SubView)

PackageBarrowBagPage.PfbPath = "part/BarrowBag";

function PackageBarrowBagPage:Init()
	self:AddViewEvts();

	self.initPage = false;
end

function PackageBarrowBagPage:InitPage()
	self.initPage = true;

	self.holder = self:FindGO("BarrowBagHolder");
	self.gameObject = self:LoadPreferb(PackageBarrowBagPage.PfbPath, self.holder, true);
	local closeBord = self:FindGO("CloseSpecialBord");
	self:AddClickEvent(closeBord, function (go)
		self.container:SetLeftViewState(PackageView.LeftViewState.Default);
	end);

	local listObj = self:FindGO("ItemNormalList");
	self.itemlist = ItemNormalList.new(listObj, BagCombineDragItemCell);

	self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self);
	self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self);
	self.itemlist:SetScrollPullDownEvent( PackageBarrowBagPage.PullDownPackage, self );

	self.itemlist.GetTabDatas = PackageBarrowBagPage.GetTabDatas;
	self.itemlist.scrollView.onDragStarted = function () 
		self:ShowItemTip()
	end

	self.itemCells = self.itemlist:GetItemCells();

	self.normalStick = self.container.normalStick;
end

local tabDatas = {};
function PackageBarrowBagPage.GetTabDatas(tabConfig)
	TableUtility.ArrayClear(tabDatas);

	local bagData = BagProxy.Instance.barrowBag;
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

function PackageBarrowBagPage:PullDownPackage()
	self:RemoveReArrageSafeLT();
	self.reArrageSafeLT = LeanTween.delayedCall(3, function ()
		self:HandleItemReArrage();		
	end);

	ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_BARROW); 
end

function PackageBarrowBagPage:ClickItem(cellCtl)
	local data = cellCtl and cellCtl.data;
	if(data=="Empty" or data == "Grey")then
		data = nil;
	end

	local go = cellCtl and cellCtl.gameObject;
	local newChooseId = data and data.id or 0;
	if(self.chooseId~=newChooseId)then
		self.chooseId = newChooseId;
		self:ShowPackageItemTip(data, {go});
	else
		self.chooseId = 0;
		self:ShowPackageItemTip();
	end
	for _,cell in pairs(self.itemCells) do
		cell:SetChooseId(self.chooseId);
	end
end

function PackageBarrowBagPage:DoubleClickItem(cellCtl)
	local data = cellCtl.data;
	if(data=="Empty" or data == "Grey")then
		data = nil;
	end
	
	if(data)then
		local funcId = 38;
		if(type(funcId) == "number")then
			-- 如果不处于人物装备状态 非时装装备装备时需要切换回人物装备面板
			local func = FunctionItemFunc.Me():GetFuncById(funcId);
			if(type(func)=="function")then
				func(data);
			end
		end
		self:ShowPackageItemTip();
		self.chooseId = 0;
		for _,cell in pairs(self.itemCells) do
			cell:SetChooseId(self.chooseId);
		end
	end
end

function PackageBarrowBagPage:ShowPackageItemTip(data, ignoreBounds)
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
		funcConfig = {38},
		ignoreBounds = ignoreBounds,
		callback = callback,
	};

	self:ShowItemTip(sdata, self.normalStick, nil, {210,0});
end

function PackageBarrowBagPage:Open()
	if(self.initPage == false)then
		self:InitPage();
	end

	self.itemlist:ChooseTab(1);
end

function PackageBarrowBagPage:Close()
	self:RemoveReArrageSafeLT();
	-- cancel choose
	self.chooseId = 0;
	self:ShowPackageItemTip();
	for _,cell in pairs(self.itemCells) do
		cell:SetChooseId(self.chooseId);
	end

	ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_BARROW);

	PackageBarrowBagPage.super.OnExit(self);
end

function PackageBarrowBagPage:UpdateList()
	self.itemlist:UpdateList(true);
end

function PackageBarrowBagPage:AddViewEvts()
	self:AddListenEvt(ItemEvent.BarrowUpdate,self.HandleItemUpdate);
	self:AddListenEvt(ItemEvent.ItemReArrage,self.HandleItemReArrage);
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleItemUpdate);
end

function PackageBarrowBagPage:HandleItemReArrage(note)
	if(not self.initPage)then
		return;
	end

	self:RemoveReArrageSafeLT();

	AudioUtility.PlayOneShot2D_Path( ResourcePathHelper.AudioSEUI(AudioMap.UI.ReArrage) )
	local callback = function ()
		self:UpdateList();
	end
	self.itemlist:ScrollViewRevert(callback);
end

function PackageBarrowBagPage:HandleItemUpdate()
	if(not self.initPage)then
		return;
	end

	self:UpdateList();
end

function PackageBarrowBagPage:RemoveReArrageSafeLT()
	if(self.reArrageSafeLT)then
		self.reArrageSafeLT:cancel();
		self.reArrageSafeLT = nil;
	end
end





