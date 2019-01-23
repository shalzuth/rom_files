autoImport("WrapCellHelper")
autoImport("ShopSaleItemCell")
ShopSaleItemPage = class("ShopSaleItemPage",SubView)

local temp = {}
temp.stDatas = {}

function ShopSaleItemPage:OnEnter()
	ShopSaleItemPage.super.OnEnter(self)
	self:InitShow()
end

function ShopSaleItemPage:OnExit()
	for i=#self.waitSellData,1,-1 do
		local data = self.waitSellData[i];
		if(data)then
			ShopSaleProxy.Instance:RemoveOutWaitSaleItems(data.guid ,data.nums)
		end
	end
	ShopSaleItemPage.super.OnExit(self);
end

function ShopSaleItemPage:Init()
	self:FindObjs()
	self:AddEvts()
end

function ShopSaleItemPage:FindObjs()
	self.LeftBord=self:FindGO("LeftBord")
	self.ItemScrollView=self:FindGO("ItemScrollView",self.LeftBord):GetComponent(UIScrollView)
	self.totalCostNums=self:FindGO("totalCostNums",self.LeftBord):GetComponent(UILabel)
	self.SaleButton=self:FindGO("SaleButton",self.LeftBord)
	self.nonetip = self:FindGO("NoneTip");
	self.leftBg = self:FindComponent("leftBg" , UISprite)
	self.salePrice = self:FindGO("SalePrice", self.LeftBord)
	self.salePriceTip = self:FindGO("Tip", self.salePrice):GetComponent(UILabel)
end

function ShopSaleItemPage:ShopSaleData()
	return ShopSaleProxy.Instance.waitSaleItems
end

function ShopSaleItemPage:UpdateShopSaleInfo(datas)
	if(datas == nil)then
		datas = self:ShopSaleData();
		print("UpdateShopSaleInfo : "..#datas)
	end
	self.waitSellData = datas or {}

	self.itemCtl:ResetDatas(datas)
	self.nonetip:SetActive(#datas == 0)

	local discount = 20 / 100
	local totalCost, pureTotalCost = ShopSaleProxy.Instance:GetTotalPrice()
	local discount, discountCount, discountTotal = ShopSaleProxy.Instance:GetTotalSellDiscount(pureTotalCost)

	self.totalCostNums.text= StringUtil.NumThousandFormat(discountTotal + (totalCost - pureTotalCost))
	self:UpdateSale(discount, discountCount)

	local canMove=#datas>3
	if(not canMove)then
		self.ItemScrollView:ResetPosition()
	end
end

function ShopSaleItemPage:ResetPosition()
	self.ItemScrollView:ResetPosition()
end

function ShopSaleItemPage:UpdateSale(discount, totalCost)
	local isDiscount = discount ~= 0
	self.salePrice:SetActive(isDiscount)
	if isDiscount then
		self.salePriceTip.text = string.format(ZhString.ShopSale_SellExpensive, 
			discount * 100, 
			StringUtil.NumThousandFormat(totalCost))
	end
end

function ShopSaleItemPage:HandleClickCanelSale(cellctl)
	if(cellctl and cellctl.data)then
		ShopSaleProxy.Instance:RemoveOutWaitSaleItems(cellctl.data.guid,cellctl.data.nums)
		self:UpdateShopSaleInfo()
		self.container.ShopSaleBagPage.itemlist:UpdateList(true)
	end
end

function ShopSaleItemPage:HandleClickIconSprite(cellctl)
	if cellctl.bagData then
		local tipData = {
			itemdata = cellctl.bagData,
			funcConfig = {},
		};
		self:ShowItemTip(tipData, self.leftBg,NGUIUtil.AnchorSide.Right, {-200,0});
	else
		errorLog("ShopSaleItemPage:HandleClickIconSprite cellctl.bagData = nil")
	end
end

function ShopSaleItemPage:AddEvts()
	self:AddClickEvent(self.SaleButton,function (g)
		self:ClickSaleButton(g)
	end)

	local saleGrid = self:FindGO("saleGrid",self.LeftBord):GetComponent(UIGrid)
	self.itemCtl = UIGridListCtrl.new(saleGrid, ShopSaleItemCell, "ShopSaleItemCell")
	self.itemCtl:AddEventListener(ShopSaleEvent.canelSale, self.HandleClickCanelSale, self)
	self.itemCtl:AddEventListener(ShopSaleEvent.SelectIconSprite, self.HandleClickIconSprite, self)
end

function ShopSaleItemPage:InitShow()

	self.npc = self.viewdata.viewdata.npcdata

	self:UpdateShopSaleInfo()
	self:ResetPosition()
end

function ShopSaleItemPage:ClickSaleButton(go)
	if(#ShopSaleProxy.Instance.waitSaleItems>0)then

		local _ShopSaleProxy = ShopSaleProxy.Instance

		TableUtility.ArrayClear(temp.stDatas)
		temp.npcId = self.npc.data.id
		for i=1,#_ShopSaleProxy.waitSaleItems do
			local data=_ShopSaleProxy:GetItemByGuid(_ShopSaleProxy.waitSaleItems[i].guid)
			if data and data.staticData then
				TableUtility.ArrayPushBack(temp.stDatas, data.staticData)
			end
		end

		FunctionSecurity.Me():SellItem_Shop(function (arg)
			local isSaleConfirmMsg = ShopSaleProxy.Instance:IsSaleConfirmMsg()
			if isSaleConfirmMsg then
				MsgManager.ConfirmMsgByID(1405, function ()
					ServiceItemProxy.Instance:CallSellItem(arg.npcId)
				end, nil)
			else
				ServiceItemProxy.Instance:CallSellItem(arg.npcId)
			end
		end, temp)
	else
		MsgManager.FloatMsgTableParam(nil,ZhString.ShopSale_notItems)
	end
end

function ShopSaleItemPage:HandleItemUpdate( )
	ShopSaleProxy.Instance.waitSaleItems={}
	ShopSaleProxy.Instance.waitSaleItemsDic={}
	self:UpdateShopSaleInfo()
end
