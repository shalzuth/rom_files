autoImport("ShopSaleSellItemCell")

ShopSaleBagPage = class("ShopSaleBagPage", SubView)

autoImport("ItemNormalList");
autoImport("ShopSaleCombineBagCell")

ShopSaleBagPage.TabName = {
	BagTab = ZhString.ShopSale_BagTabName,
	FoodTab = ZhString.ShopSale_FoodTabName,
	PetTab = ZhString.ShopSale_PetTabName,
	TempTab = ZhString.ShopSale_TempTabName
}
ShopSaleBagPage.LongPressEvent = "ShopSaleBagPage_LongPress"

function ShopSaleBagPage:OnEnter()
	ShopSaleBagPage.super.OnEnter(self)
	self:InitUI()
end

function ShopSaleBagPage:Init()
	self:FindSaleItemPopUp()
	self:AddEvts()
	self:InitShow()
end

function ShopSaleBagPage:FindSaleItemPopUp()

	local go = self:LoadCellPfb("ShopSaleSellItemCell")
	self.saleCell = ShopSaleSellItemCell.new(go)
	self.saleCell:AddEventListener(ShopSaleEvent.SaleSuccess, self.UpdatePage, self)

	self.bagTab = self:FindGO("BagTab", self.rightBord):GetComponent(UIToggle)
	self.tempTab = self:FindGO("TempTab", self.rightBord)
	self.foodTab = self:FindGO("FoodTab", self.rightBord)
	self.petTab = self:FindGO("PetTab", self.rightBord)

	self.tabGrid = self:FindComponent("TabGrid", UIGrid)
end

function ShopSaleBagPage:InitShow()

	self.rightBord=self:FindGO("rightBord")
	self.scrollView = self:FindGO("ItemScrollView", self.rightBord):GetComponent(ROUIScrollView);
	local listObj = self:FindGO("ItemNormalList",self.rightBord);
	self.itemlist = ItemNormalList.new(listObj,ShopSaleCombineBagCell,false);
	self.itemlist.GetTabDatas = function(tabConfig)
		return ShopSaleProxy.Instance:GetBagItemDatas(tabConfig)
	end

	self.itemlist:SetScrollPullDownEvent(function ()
		ServiceItemProxy.Instance:CallPackageSort(ShopSaleProxy.Instance:GetBagType())
	end);

	self.itemlist:AddCellEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);
	self.scrollView.PreDragEffect=2

	self.comps = {}
	for i=1,#ItemNormalList.TabConfig do
		local obj = self:FindGO("ItemTab"..i);
		self.comps[i] = obj:GetComponent(BoxCollider)
	end
end

function ShopSaleBagPage:AddEvts()
	self:AddClickEvent(self.bagTab.gameObject,function (g)
		self:UpdateBag(BagProxy.BagType.MainBag)
	end)
	self:AddClickEvent(self.foodTab,function (g)
		self:UpdateBag(BagProxy.BagType.Food)
	end)
	self:AddClickEvent(self.petTab,function (g)
		
	end)
	self:AddClickEvent(self.tempTab,function (g)
		self:UpdateBag(BagProxy.BagType.Temp)
	end)

	-- LongPress for TabNameTip
	self.tabList = {self.bagTab.gameObject,self.foodTab,self.petTab,self.tempTab}
	for i,v in ipairs(self.tabList) do
		local longPress = v:GetComponent(UILongPress)
		longPress.pressEvent = function (obj, state)
			self:PassEvent(ShopSaleBagPage.LongPressEvent, {state, obj.gameObject});
		end
	end
	self:AddEventListener(ShopSaleBagPage.LongPressEvent, self.HandleLongPress, self)
end

function ShopSaleBagPage:InitUI()
	self.params = self.viewdata.viewdata.params

	for i=1,#self.comps do
		if self.params == 2 then
			if i ~= self.params then
				self.comps[i].enabled = false
			else
				self.comps[i].enabled = true
			end
		else
			self.comps[i].enabled = true
		end
	end

	self.bagTab:Set(true)
	ShopSaleProxy.Instance:SetBagType(BagProxy.BagType.MainBag)

	ShopSaleProxy.Instance:InitBagData()
	self.itemlist:UpdateTabList( BagProxy.BagType.MainBag )
	self.itemlist:ChooseTab(self.params)
	self.itemlist:UpdateList()
	self.saleCell.gameObject:SetActive(false)
	self.tempTab:SetActive( #BagProxy.Instance.tempBagData:GetItems() > 0 )
	self.foodTab:SetActive( #BagProxy.Instance.foodBagData:GetItems() > 0 )
	self.petTab:SetActive(false)
	self.tabGrid:Reposition()

	-- Switch icon or text for TabNameTip
	local iconActive, nameLabelActive
	if not GameConfig.SystemForbid.TabNameTip then -- 显示图标和气泡
		iconActive=true;nameLabelActive=false;
	else -- 不显示图标和气泡
		iconActive=false;nameLabelActive=true;
	end
	self.tabIconSpList = {}
	for i,v in ipairs(self.tabList) do
		local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
		self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
		if v.activeSelf then
			icon:SetActive(iconActive)
			local label = GameObjectUtil.Instance:DeepFindChild(v, "Label")
			label:SetActive(nameLabelActive)
		end
	end

	self:SetCurrentTabIconColor(self.tabIconSpList[1])
end

function ShopSaleBagPage:HandleClickItem(cellCtl)
	if(cellCtl and cellCtl.data)then
		local data = cellCtl.data
		self.selectItemData=data

		local equipInfo=data.equipInfo
		if ShopSaleProxy.Instance:IsThisItemCanSale(data.id) then
			if equipInfo and equipInfo.strengthlv >0 then
				MsgManager.ConfirmMsgByID(1404 , function ()
  					self:AddItem(self.selectItemData)
  				end)
  				return
			elseif data:HasEquipedCard() then
				MsgManager.ConfirmMsgByID(1404 , function ()
  					self:AddItem(self.selectItemData)
  				end)
  				return
			end

			self:AddItem(data)
		else
			if data.staticData.Type==65 then
				MsgManager.FloatMsgTableParam(nil,ZhString.ShopSale_cantSale)
			elseif equipInfo then
				if equipInfo.refinelv > GameConfig.Item.sell_equip_max_refine_lv then
					MsgManager.ShowMsgByID(1403)
				end
			end
		end
	end
end

function ShopSaleBagPage:AddItem(data)
	if(data.num>1)then
		local canSaleNums = ShopSaleProxy.Instance:CanSaleNums(data.id)
		if(canSaleNums<0)then
			canSaleNums=0
		end
		self:UpdateSaleItemPopUp()
	else
		if(ShopSaleProxy.Instance:IsCanSaleItemNums(data.id,1))then
			ShopSaleProxy.Instance:AddToWaitSaleItems(data.id,1, ShopSaleProxy.Instance:GetPrice(data) )
			self.container.ShopSaleItemPage:UpdateShopSaleInfo()
			self.itemlist:UpdateList(true)
		end
	end

	self.container.ShopSaleItemPage:ResetPosition()
end

function ShopSaleBagPage:UpdateSaleItemPopUp()
	local data = self.selectItemData
	if(data)then
		data.moneycount = data.staticData.SellPrice
		data.maxcount = ShopSaleProxy.Instance:CanSaleNums(data.id)
		self.saleCell:SetData(data)
	end
end

function ShopSaleBagPage:UpdateBag(bagType)
	if bagType ~= nil then
		ShopSaleProxy.Instance:SetBagType(bagType)
	end
	self.itemlist:UpdateTabList( bagType )
	self.itemlist:UpdateList(false)

	local currentTabGo
	if bagType == BagProxy.BagType.MainBag then
		currentTabGo = self.bagTab.gameObject
	elseif bagType == BagProxy.BagType.Food then
		currentTabGo = self.foodTab
	elseif bagType == BagProxy.BagType.Temp then
		currentTabGo = self.tempTab
	end
	if currentTabGo then
		self:SetCurrentTabIconColor(self:FindComponent("Icon", UISprite, currentTabGo))
	end
end

function ShopSaleBagPage:UpdateList()
	self.itemlist:UpdateList(true);
end

function ShopSaleBagPage:HandleItemUpdate(note)
	ShopSaleProxy.Instance:InitBagData()
	self:UpdateList()
end

function ShopSaleBagPage:UpdatePage()
	self.container.ShopSaleItemPage:UpdateShopSaleInfo()
	self.itemlist:UpdateList(true)
end

function ShopSaleBagPage:HandleItemReArrage(note)
	AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.ReArrage))
	ShopSaleProxy.Instance:InitBagData()
	self:UpdateList()
	self.itemlist:ScrollViewRevert()
end

function ShopSaleBagPage:LoadCellPfb(cName)
	local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
	if(cellpfb == nil) then
		error ("can not find cellpfb"..cName)
	end
	cellpfb.transform:SetParent(self.gameObject.transform,false)
	return cellpfb
end

function ShopSaleBagPage:OnExit()
	ShopSaleBagPage.super.OnExit(self)
	self.saleCell:Exit()
end

function ShopSaleBagPage:HandleLongPress(param)
	local isPressing, go = param[1], param[2];

	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			local backgroundSp = go:GetComponent(UISprite);
			TipManager.Instance:TryShowHorizontalTabNameTip(ShopSaleBagPage.TabName[go.name],
					backgroundSp, NGUIUtil.AnchorSide.Left)
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end

function ShopSaleBagPage:ResetTabIconColor()
	for i,v in ipairs(self.tabIconSpList) do
		v.color = ColorUtil.TabColor_White
	end
end

function ShopSaleBagPage:SetCurrentTabIconColor(currentTabIcon)
	self:ResetTabIconColor()
	if not currentTabIcon then return end
	currentTabIcon.color = ColorUtil.TabColor_DeepBlue
end