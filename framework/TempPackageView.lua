TempPackageView = class("TempPackageView", ContainerView)

TempPackageView.ViewType = UIViewType.PopUpLayer

autoImport("TempBagItemCell");
autoImport("BaseCombineCell");

function TempPackageView:Init()
	self:InitView();
	self:MapEvent();
end

function TempPackageView:InitView()
	self.normalStick = self:FindComponent("NormalStick", UIWidget);

	local itemContainer = self:FindGO("ItemContainer");
	local wrapConfig = {
		wrapObj = itemContainer,
		pfbNum = 4, 
		cellName = "BagCombineItemCell", 
		control = BaseCombineCell,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)

	local cells = self.itemWrapHelper:GetCellCtls();
	self.itemCells = {};
	for i=1,#cells do
		cells[i]:InitCells(4, "TempBagItemCell", TempBagItemCell);

		local childCells = cells[i]:GetCells();
		for k=1,#childCells do
			table.insert(self.itemCells, childCells[k]);
		end
	end
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self);

	self:AddButtonEvent("GetOutButton", function (go)
		local datas = BagProxy.Instance.tempBagData:GetItems();
		local canPick = false;
		for i=1,#datas do
			local itemid = datas[i].staticData.id;
			if(BagProxy.Instance:CheckItemCanPutIn(nil, itemid))then
				canPick = true;
				break;
			end
		end
		if(canPick)then
			ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFTEMP, nil, "");
		else
			MsgManager.ShowMsgByIDTable(3101);
		end
	end);

	self.closeComp = self:FindComponent("Anchor_Down", CloseWhenClickOtherPlace);
	self.closeComp.callBack = function (go)
		self:CloseSelf();
	end
end

function TempPackageView:ClickItem(cellCtl)
	local data = cellCtl and cellCtl.data;
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

function TempPackageView:ShowPackageItemTip(data, ignoreBounds)
	if(data == nil)then
		self:ShowItemTip();
		self.closeComp:ReCalculateBound();
		return;
	end

	local callback = function ()
		self.chooseId = 0;
		for _,cell in pairs(self.itemCells) do
			cell:SetChooseId(self.chooseId);
		end
	end;

	if(not self.tipData)then
		self.tipData = {};
		self.tipOffset = {-190, -50};
	else
		TableUtility.TableClear(self.tipData);
	end

	self.tipData.itemdata = data;
	self.tipData.funcConfig = {34};
	self.tipData.ignoreBounds = ignoreBounds;
	self.tipData.callback = callback;
	self.tipData.showDelTime = true;

	local cell = self:ShowItemTip(self.tipData, self.normalStick, nil, self.tipOffset);

	if(not self:ObjIsNil(cell.gameObject))then
		self.closeComp:AddTarget(cell.gameObject.transform);
	end
end

function TempPackageView:OnEnter()
	TempPackageView.super.OnEnter(self);
	self:UpdateTempBag();
end

function TempPackageView:GetTestTempItems()
	local result = {};
	local items = BagProxy.Instance.bagData:GetItems();
	for i=1,10 do
		local testItem = items[i];
		local curServerTime = ServerTime.CurServerTime()/1000;
		if(i < 5)then
			testItem.deltime = curServerTime + 23.5 * 3600 + 5 * i;
		else
			testItem.deltime = curServerTime + 24 * 3600 + 5 * (i - 5);
		end
		table.insert(result, testItem);

		FunctionTempItem.Me():AddTempItemDelCheck(testItem.id, testItem.deltime);
	end
	return result;
end

function TempPackageView:UpdateTempBag()
	-- local datas = self:GetTestTempItems();
	local datas = BagProxy.Instance.tempBagData:GetItems();
	self.itemWrapHelper:ResetDatas(self:CombineTempBagData(datas, 4));
end

function TempPackageView:CombineTempBagData(datas, rowNum)
	if(not self.combineData)then
		self.combineData = {};
	else
		TableUtility.ArrayClear(self.combineData);
	end

	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/4)+1;
			local i2 = math.floor((i-1)%4)+1;
			self.combineData[i1] = self.combineData[i1] or {};
			if(datas[i] == nil or datas[i].staticData == nil)then
				self.combineData[i1][i2] = nil;
			else
				self.combineData[i1][i2] = datas[i];
			end
		end
	end
	return self.combineData
end

function TempPackageView:MapEvent()
	self:AddListenEvt(ItemEvent.TempBagUpdate, self.UpdateTempBag);
	self:AddListenEvt(TempItemEvent.TempWarnning, self.HandleWarningItem);
end

function TempPackageView:HandleWarningItem(note)
	local itemguid = note.body;
	
	for i=1,#self.itemCells do
		self.itemCells[i]:RefreshDelWarning();
	end
end

function TempPackageView:OnExit()
	TempPackageView.super.OnExit(self);
	self:ShowPackageItemTip();

	ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_PACK_TEMP);
end
