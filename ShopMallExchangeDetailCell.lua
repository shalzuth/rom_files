ShopMallExchangeDetailCell = class("ShopMallExchangeDetailCell", ItemCell)

function ShopMallExchangeDetailCell:Init()

	self.cellContainer = self:FindGO("CellContainer")
	if self.cellContainer then
		local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
		obj.transform.localPosition = Vector3.zero

		self.cellContainer:AddComponent(UIDragScrollView)
	end

	ShopMallExchangeDetailCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
	self:AddCellClickEvent()
end

function ShopMallExchangeDetailCell:FindObjs()
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.money = self:FindGO("Money"):GetComponent(UILabel)
	self.choose = self:FindGO("Choose")
	self.expire = self:FindGO("Expire")
	self.publicity = self:FindGO("Publicity")
	if self.publicity then
		self.publicity = self.publicity:GetComponent(UILabel)
	end
	self.bgSp = self.gameObject:GetComponent(UIMultiSprite)
	self.boothIcon = self:FindGO("BoothIcon")
end

function ShopMallExchangeDetailCell:AddEvts()
	self:AddClickEvent(self.cellContainer,function (g)
		self:ShowTips()
	end)
end

function ShopMallExchangeDetailCell:SetData(data)
	self.gameObject:SetActive(data ~= nil)

	if data then
		if data.itemid then
			local item = Table_Item[data.itemid]
			if item ~= nil then
				self.name.text = item.NameZh
				UIUtil.WrapLabel(self.name)
			else
				errorLog(string.format("ShopMallExchangeDetailCell SetData : Table_Item[%s] is nil",tostring(data.itemid)))
			end
		else
			errorLog("ShopMallExchangeDetailCell SetData : data.itemid is nil")
		end

		ShopMallExchangeDetailCell.super.SetData(self, data:GetItemData())

		self.data = data

		--??????itemcell??????????????????
		self.newTag:SetActive(false)

		if data.count and data.count > 999 then
			self.numLab.text = "999+"
		end

		if data.price then
			self.money.text = StringUtil.NumThousandFormat(data:GetPrice())
		else
			errorLog("ShopMallExchangeDetailCell SetData : data.price is nil")
		end

		if self.expire then
			if data.isExpired then
				self.expire:SetActive(true)
			else
				self.expire:SetActive(false)
			end
		end

		if self.choose then
			self.choose:SetActive(false)
		end

		if self.publicity then
			if data.publicityId == 0 then
				self.publicity.gameObject:SetActive(false)
			else
				self.publicity.gameObject:SetActive(true)
				if self.timeTick == nil then
					self.timeTick = TimeTickManager.Me():CreateTick(0,1000,self.UpdatePublicity,self)
				end
				self:UpdatePublicity()
			end
		end

		if self.bgSp then
			self.bgSp.CurrentState = data.isBooth and 1 or 0
		end

		if self.boothIcon then
			self.boothIcon:SetActive(data.isBooth)
		end
	end
end

function ShopMallExchangeDetailCell:SetChoose(isChoose)
	if isChoose then
		self.choose:SetActive(true)
	else
		self.choose:SetActive(false)
	end
end

function ShopMallExchangeDetailCell:ShowTips()
	TipManager.Instance:ShowItemTip(self.data:GetItemData(), {}, self.bg, NGUIUtil.AnchorSide.Right, {205,0})
end

function ShopMallExchangeDetailCell:UpdatePublicity()
	if self.data then
		local time = self.data.endTime - ServerTime.CurServerTime()/1000
		local min,sec
		if time > 0 then
			min,sec = ClientTimeUtil.GetFormatSecTimeStr( time )
		else
			min = 0
			sec = 0
		end
		self.publicity.text = string.format("%02d:%02d", min , sec)
	end
end

function ShopMallExchangeDetailCell:OnDestroy() 
	TimeTickManager.Me():ClearTick(self)
end