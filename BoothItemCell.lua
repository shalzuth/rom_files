BoothItemCell = class("BoothItemCell", ItemCell)

function BoothItemCell:Init()
	self.itemContainer = self:FindGO("ItemContainer")
	if self.itemContainer then
		local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
		obj.transform.localPosition = Vector3.zero
	end

	BoothItemCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
end

function BoothItemCell:FindObjs()
	self.addRoot = self:FindGO("AddRoot")
	self.itemRoot = self:FindGO("ItemRoot")
	self.publicity = self:FindGO("Publicity"):GetComponent(UILabel)
	self.money = self:FindGO("Money"):GetComponent(UILabel)
	self.risePrice = self:FindGO("RisePrice"):GetComponent(UILabel)
	self.salePrice = self:FindGO("SalePrice"):GetComponent(UILabel)
	self.soldOut = self:FindGO("SoldOut")
	self.expire = self:FindGO("Expire")
end

function BoothItemCell:AddEvts()
	self:AddClickEvent(self.itemContainer, function ()
		self:PassEvent(MouseEvent.MouseClick, self)
	end)

	self:AddClickEvent(self.addRoot, function ()
		self:PassEvent(BoothEvent.AddItem, self)
	end)
end

function BoothItemCell:SetData(data)
	self.data = data
	
	if data ~= nil then
		if data == true then
			self:ShowAddRoot(true)
		else
			self:ShowAddRoot(false)

			if data.publicityId == 0 then
				self.publicity.gameObject:SetActive(false)
			else
				self.publicity.gameObject:SetActive(true)
				if self.timeTick == nil then
					self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdatePublicity, self)
				end
				self:UpdatePublicity()
			end

			local price = data.price * data:GetPriceRate()
			self.money.text = StringUtil.NumThousandFormat(price)

			if data.upRate == 0 then
				self.risePrice.gameObject:SetActive(false)
			else
				self.risePrice.gameObject:SetActive(true)
				self.risePrice.text = string.format("%d%%", data.upRate / 10)
			end

			if data.downRate == 0 then
				self.salePrice.gameObject:SetActive(false)
			else
				self.salePrice.gameObject:SetActive(true)
				self.salePrice.text = string.format("%d%%", 100 - data.downRate / 10)
			end

			self:ShowSoldOut(data.count == 0)

			if data.isExpired then
				self.expire:SetActive(true)

				self.risePrice.gameObject:SetActive(false)
				self.salePrice.gameObject:SetActive(false)
			else
				self.expire:SetActive(false)
			end

			BoothItemCell.super.SetData(self, data:GetItemData())
		end
	else
		self.gameObject:SetActive(false)
	end

	self.data = data
end

function BoothItemCell:UpdatePublicity()
	if self.data then
		local time = self.data.endTime - ServerTime.CurServerTime() / 1000
		local min, sec
		if time > 0 then
			min, sec = ClientTimeUtil.GetFormatSecTimeStr(time)
		else
			min = 0
			sec = 0
		end
		self.publicity.text = string.format("%02d:%02d", min , sec)
	end
end

function BoothItemCell:ShowAddRoot(isShow)
	self.gameObject:SetActive(true)
	self.addRoot:SetActive(isShow)
	self.itemRoot:SetActive(not isShow)
end

function BoothItemCell:ShowSoldOut(isShow)
	self.soldOut:SetActive(isShow)
end

function BoothItemCell:OnDestroy()
	if self.timeTick ~= nil then
		TimeTickManager.Me():ClearTick(self)
		self.timeTick = nil
	end
end