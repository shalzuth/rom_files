autoImport("WeddingBuyDescCell")

local baseCell = autoImport("BaseCell")
WeddingBuyCell = class("WeddingBuyCell", baseCell)

function WeddingBuyCell:Init()
	self:FindObjs()
	self:InitCell()
end

function WeddingBuyCell:FindObjs()
	self.title = self:FindGO("Title"):GetComponent(UILabel)
	self.buyBtn = self:FindGO("BuyBtn"):GetComponent(UIMultiSprite)
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
	self.price = self:FindGO("Price"):GetComponent(UILabel)
	self.purchased = self:FindGO("Purchased")
	self.table = self:FindGO("Table"):GetComponent(UITable)
	self.background = self:FindGO("Background"):GetComponent(UITexture)
end

function WeddingBuyCell:InitCell()
	self.ctrl = UIGridListCtrl.new(self.table, WeddingBuyDescCell, "WeddingBuyDescCell")

	self:AddClickEvent(self.buyBtn.gameObject,function ()
		self:PassEvent(WeddingEvent.Buy, self)
	end)
end

function WeddingBuyCell:SetData(data)
	self:UnLoadPic()

	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data then
		local staticData = Table_Item[data.id]
		if staticData ~= nil then
			self.title.text = staticData.NameZh
		end

		self.ctrl:ResetDatas(data:GetDescList())
		self.table:Reposition()

		if data.isPurchased then
			self.purchased:SetActive(true)
			self.buyBtn.CurrentState = 1

			self.icon.gameObject:SetActive(false)
		else
			self.purchased:SetActive(false)
			self.buyBtn.CurrentState = 0

			self.icon.gameObject:SetActive(true)

			local price = data:GetPrice()
			if price ~= nil then
				local money = Table_Item[price.id]
				if money ~= nil then
					IconManager:SetItemIcon(money.Icon, self.icon)
				end

				self.price.text = StringUtil.NumThousandFormat(price.num)
			end
		end

		local serviceData = Table_WeddingService[data.id]
		if serviceData ~= nil then
			PictureManager.Instance:SetWedding(serviceData.Background, self.background)
		end
	end
end

function WeddingBuyCell:UnLoadPic()
	if self.data then
		local serviceData = Table_WeddingService[self.data.id]
		if serviceData ~= nil then
			PictureManager.Instance:UnLoadWedding(serviceData.Background, self.background)
		end
	end
end