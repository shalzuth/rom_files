autoImport("HappyShopBuyItemCell")
WeddingRingBuyCell = class("WeddingRingBuyCell", HappyShopBuyItemCell)

function WeddingRingBuyCell:SetData(data)
	WeddingRingBuyCell.super.SetData(self, data)

	self.maxcount = 1
end

function WeddingRingBuyCell:UpdateOwnInfo()
	if self.shopdata then
		local own = 0
		if self.shopdata.goodsID == WeddingProxy.Instance:GetWeddingRingid() then
			own = 1
		end
		self.ownInfo.text = string.format(ZhString.HappyShop_OwnInfo, own)
	end
end

function WeddingRingBuyCell:Confirm()
	if self.shopdata then
		local goodsID = self.shopdata.goodsID
		if goodsID == WeddingProxy.Instance:GetWeddingRingid() then
			MsgManager.ShowMsgByID(9642)
			return
		end

		local moneyid = self.shopdata.ItemID
		if moneyid ~= nil then
			local moneyCount = self.shopdata.ItemCount
			local itemName = ""
			local item = Table_Item[moneyid]
			if item ~= nil then
				itemName = item.NameZh
			end

			local isEnough = WeddingProxy.Instance:GetItemCount(moneyid) >= moneyCount
			if isEnough then
				local sb = LuaStringBuilder.CreateAsTable()
				sb:Append(StringUtil.NumThousandFormat(moneyCount))
				sb:Append(itemName)
				itemName = sb:ToString()
				sb:Destroy()

				local ringName = ""
				local staticData = Table_Item[goodsID]
				if staticData ~= nil then
					ringName = staticData.NameZh
				end

				MsgManager.ConfirmMsgByID(9618, function ()
					ServiceWeddingCCmdProxy.Instance:CallBuyWeddingRingCCmd(self.shopdata.id, moneyid)
					self.gameObject:SetActive(false)
				end, nil, nil, itemName, ringName)
			else
				MsgManager.ShowMsgByID(9620, itemName)
			end
		end
	end
end