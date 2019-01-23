FinanceCell = class("FinanceCell", ItemCell)

local _VecPos = LuaVector3.zero
local _redColor = LuaColor.New(208/255, 48/255, 38/255, 1)
local _greenColor = LuaColor.New(80/255, 200/255, 47/255, 1)

function FinanceCell:Init()

	self.itemContainer = self:FindGO("ItemContainer")
	self.itemContainer:AddComponent(UIDragScrollView)

	local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
	_VecPos:Set(0, 0, 0)
	obj.transform.localPosition = _VecPos

	FinanceCell.super.Init(self)

	self:FindObjs()
	self:InitShow()
end

function FinanceCell:FindObjs()
	self.cellBg = self.gameObject:GetComponent(UISprite)
	self.ratio = self:FindGO("Ratio"):GetComponent(UILabel)
	self.ratioArrow = self:FindGO("RatioArrow"):GetComponent(UISprite)
	self.sellBtn = self:FindGO("SellBtn"):GetComponent(UIMultiSprite)
	self.sellLabel = self:FindGO("Label", self.sellBtn.gameObject):GetComponent(UILabel)
end

function FinanceCell:InitShow()
	self:AddClickEvent(self.gameObject, function ()
		self:ShowDetail(not self.isShowDetail)

		self:PassEvent(FinanceEvent.ShowDetail, self)
	end)

	self:AddClickEvent(self.itemContainer, function ()
		local data = ReusableTable.CreateTable()
		data.itemdata = self.data:GetItemData()
		data.funcConfig = {}
		TipManager.Instance:ShowItemFloatTip(data, self.icon , NGUIUtil.AnchorSide.Left, {-220,0})
		ReusableTable.DestroyAndClearTable(data)
	end)

	self:AddClickEvent(self.sellBtn.gameObject, function ()
		if self.canSell then
			local itemData = BagProxy.Instance:GetNewestItemByStaticID(self.data.itemid)
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ShopMallExchangeSellInfoView, viewdata = { data = itemData , type = ShopMallExchangeSellEnum.Sell}})
		end
	end)
end

function FinanceCell:SetData(data)
	self.data = data

	if data then
		self:UpdateSellBtn()

		if data.rankType == FinanceRankTypeEnum.DealCount or data.rankType == FinanceRankTypeEnum.UpRatio then
			self.ratio.color = _redColor
			self.ratioArrow.color = _redColor
			self.ratioArrow.flip = 0

			_VecPos:Set(100, -58, 0)

			self.sellBtn.gameObject:SetActive(true)

		elseif data.rankType == FinanceRankTypeEnum.DownRatio then
			self.ratio.color = _greenColor
			self.ratioArrow.color = _greenColor
			self.ratioArrow.flip = 2

			_VecPos:Set(220, -58, 0)

			self.sellBtn.gameObject:SetActive(false)
		end
		self.ratio.transform.localPosition = _VecPos
		self.ratio.text = string.format(ZhString.Finance_Ratio, data.ratio / 10)

		self:ShowDetail(false)

		local itemData = data:GetItemData()
		if itemData ~= nil then
			FinanceCell.super.SetData(self, itemData)
		end
	end

	self.data = data
end

function FinanceCell:UpdateSellBtn()
	if self.data then
		self.canSell = BagProxy.Instance:GetItemNumByStaticID(self.data.itemid) > 0
		if self.canSell then
			self.sellBtn.CurrentState = 0
			self.sellLabel.effectColor = ColorUtil.ButtonLabelOrange
		else
			self.sellBtn.CurrentState = 1
			self.sellLabel.effectColor = ColorUtil.NGUIGray
		end		
	end
end

function FinanceCell:ShowDetail(isShow)
	self.isShowDetail = isShow
	if self.isShowDetail then
		self.cellBg.height = 264
	else
		self.cellBg.height = 112
	end
end