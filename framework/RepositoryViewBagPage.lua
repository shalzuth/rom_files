RepositoryViewBagPage = class("RepositoryViewBagPage", SubView)

autoImport("ItemNormalList");
autoImport("RepositoryBagCombineItemCell")

function RepositoryViewBagPage:Init()
	self:InitUI();
end

function RepositoryViewBagPage:InitUI()
	self.normalStick = self:FindComponent("NormalStick", UISprite);

	self.rightBord=self:FindGO("rightBord")
	local listObj = self:FindGO("ItemNormalList",self.rightBord);
	self.itemlist = ItemNormalList.new(listObj,RepositoryBagCombineItemCell)
	self.itemlist:SetScrollPullDownEvent(function ()
		ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN); 
	end);
	self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self);
	self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)
	self.itemCells = self.itemlist:GetItemCells();

	self:UpdateList();

	self.tip = string.format(ZhString.Repository_storeLv , GameConfig.Item.store_baselv_req )
end

function RepositoryViewBagPage:InitShow()
	self.viewTab = self.container.viewTab

	self.funcConfigId = 30
	if self.viewTab == RepositoryView.Tab.RepositoryTab then
		self.funcConfigId = 32
	end

	self:SetCellsLock()
	self.lock = self.viewTab == RepositoryView.Tab.CommonTab and MyselfProxy.Instance:RoleLevel() < GameConfig.Item.store_baselv_req
end

function RepositoryViewBagPage:ClickItem(cellCtl)
	local data = cellCtl and cellCtl.data;
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

function RepositoryViewBagPage:DoubleClickItem(cellCtl)
	local data = cellCtl.data
	if data then
		self.chooseId = 0
		self:ShowRepositoryItemTip()

		if self.viewTab == RepositoryView.Tab.CommonTab then
			FunctionItemFunc.DepositRepositoryEvt(data)
		else
			FunctionItemFunc.PersonalDepositRepositoryEvt(data)
		end
	end
end

function RepositoryViewBagPage:ShowRepositoryItemTip(data, ignoreBounds)
	if(data == nil)then
		self:ShowItemTip();
		return;
	end

	local callback = function ()
		local itemdata = BagProxy.Instance:GetItemByGuid(self.chooseId)
		if itemdata then
			if self.viewTab == RepositoryView.Tab.CommonTab then
				if itemdata.equipInfo and itemdata.equipInfo.strengthlv>0 then
					MsgManager.ShowMsgByID(2001)
					return
				end
			end
		end

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
	self:ShowItemTip(sdata, self.normalStick, nil, {-180,0});
	ReusableTable.DestroyAndClearTable(sdata)
end

function RepositoryViewBagPage:ShowPrompt()
	local data = self.container.repositoryViewItemPage.itemlist.chooseItemData
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
		MsgManager.ShowEightTypeMsgByIDTable(820,{self.container.repositoryViewItemPage.itemlist.chooseItemData.num}
			,self.itemlist.ItemTabLst[index].transform.position,{0,10})
	end
end

function RepositoryViewBagPage:UpdateList(note)
	self.itemlist:UpdateList(true);
end

function RepositoryViewBagPage:HandleItemUpdate(note)
	self:UpdateList(note);
	if(RepositoryViewProxy.Instance.curOperation==RepositoryViewProxy.Operation.WthdrawnRepositoryEvt)then
		RepositoryViewProxy.Instance.curOperation=RepositoryViewProxy.Operation.Default
	end
	self:SetCellsLock()
end

--装备更新
function RepositoryViewBagPage:HandleItemReArrage(note)
	AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.ReArrage));

	self:UpdateList();
	self.itemlist:ScrollViewRevert();
	self:SetCellsLock()
end

function RepositoryViewBagPage:HandleLevelUp(note)
	self:SetCellsLock()
	self.lock = self.viewTab == RepositoryView.Tab.CommonTab and MyselfProxy.Instance:RoleLevel() < GameConfig.Item.store_baselv_req
end

function RepositoryViewBagPage:SetCellsLock()
	for i=1,#self.itemCells do
		self.itemCells[i]:SetCellLock()
	end
end