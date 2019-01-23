ShopItemData = class("ShopItemData")

ShopItemData.LockType = {
	Quest = SessionShop_pb.ESHOPLOCKTYPE_QUEST,
	GuildBuilding = SessionShop_pb.ESHOPLOCKTYPE_GUILDBUILDING,
}

function ShopItemData:ctor(data)
	self:SetData(data)
end

function ShopItemData:SetData(data)
	self.id = data.id
	self.ShopOrder = data.shoporder
	if data.itemid ~= 0 then
		self.goodsID = data.itemid
	end
	if data.num ~= 0 then
		self.goodsCount = data.num
	end
	if data.skillid ~= 0 then
		self.SkillID = data.skillid
	end
	if data.haircolorid ~= 0 then
		self.hairColorID = data.haircolorid
	end
	if data.clothcolorid ~= 0 then
		self.clothColorID = data.clothcolorid
	end
	self.PreCost = data.precost
	self.ItemID = data.moneyid
	self.ItemCount = data.moneycount
	if data.moneyid2 ~= 0 then
		self.ItemID2 = data.moneyid2
		self.ItemCount2 = data.moneycount2
	end
	self.business = data.business
	self.des = data.des
	self.LevelDes = data.levdes
	self.BaseLv = data.lv
	self.Discount = data.discount
	self.discountMax = data.discountmax	--折扣活动商品最大打折次数
	self.actDiscount = data.actdiscount --折扣活动商品折扣
	self.LimitType = data.limittype
	self.LimitNum = data.maxcount
	if data.ifmsg ~= 0 then
		self.IfMsg = data.ifmsg
	end
	if data.removedate ~= 0 then
		self.RemoveDate = data.removedate
	end
	self.lockType = data.locktype
	self.lockArg = data.lockarg
	self.produceNum = data.producenum	--总数量
	self.MenuID = data.menuid
	self.source = data.source

	self:_SetMenu(data.shoptype)
end

function ShopItemData:_SetMenu(shoptype)
	self.menuLockDesc = nil
	self.lockReasonDesc = nil

	if self.lockType == ShopItemData.LockType.GuildBuilding then
		self.lock = GuildBuildingProxy.Instance:ShopGoodsLocked(shoptype, self.id)
		if self.lock then
			self.lockReasonDesc = self.lockArg
		end
	elseif self.MenuID ~= 0 and not FunctionUnLockFunc.Me():CheckCanOpen(self.MenuID) then
		self.lock = true

		local data = Table_MenuUnclock[self.goodsID]
		if data ~= nil and #data.MenuDes > 0 then
			self.menuLockDesc = data.MenuDes
		end
		if self.lockType == ShopItemData.LockType.Quest then
			self.lockReasonDesc = string.format(ZhString.HappyShop_Lock, self.lockArg)
		elseif self.lockArg ~= "" then
			self.menuLockDesc = self.lockArg
		end
	else
		self.lock = false
	end	
end

--参数：已售数量
function ShopItemData:SetCurProduceNum(num)
	if num and self.produceNum and self.produceNum > 0 then
		local curNum = self.produceNum - num
		if curNum < 0 then
			curNum = 0
		end

		self.curProduceNum = curNum
	end
end

--检查商品是否已下架，true为已下架
function ShopItemData:CheckCanRemove()
	if self.RemoveDate then
		if ServerTime.CurServerTime()/1000 >= self.RemoveDate then
			return true
		end
	end

	return false
end

function ShopItemData:CheckLimitType(index)
	if self.LimitType then
		return self.LimitType & index > 0
	end

	return false
end

function ShopItemData:GetItemData()
	if self.goodsID and self.itemData == nil then
		self.itemData = ItemData.new("shop", self.goodsID)
	end

	return self.itemData
end

--商品是否解锁，true为未解锁
function ShopItemData:GetLock()
	return self.lock
end

--商品未解锁描述，优先使用Table_MenuUnclock的MenuDes，没有则使用服务器的
function ShopItemData:GetMenuDes()
	local desc = self:GetLockDesc()
	if desc == nil then
		return self.lockReasonDesc
	end
	return desc
end

--商品的任务未解锁描述
function ShopItemData:GetQuestLockDes()
	if self.lockType == ShopItemData.LockType.Quest then
		return self.lockReasonDesc
	end
	return nil
end

--商品Table_MenuUnclock的MenuDes
function ShopItemData:GetLockDesc()
	return self.menuLockDesc
end

--商品未解锁原因
function ShopItemData:GetLockType()
	return self.lockType
end

--打折后购买价格
--参数：1、单价
--	   2、数量
--返回：总价格
function ShopItemData:GetBuyDiscountPrice(price, count)
	local discount = self.Discount
	local actDiscount = self.actDiscount
	local leftCount = 0
	local discountPrice = 0

	if actDiscount ~= 0 then
		--限购后 剩余可买数量
		local canBuyCount = self.discountMax - HappyShopProxy.Instance:GetDiscountItemCount(self.id)
		if canBuyCount < 0 then
			canBuyCount = 0
		end
		leftCount = count - canBuyCount
		if leftCount > 0 then
			discountPrice = price * canBuyCount * actDiscount / 100
		else
			return price * count * actDiscount / 100, actDiscount
		end
	end

	if leftCount > 0 then
		return discountPrice + (price * leftCount * discount / 100), discount
	else
		return price * count * discount / 100, discount
	end
end

--商人/盗贼技能打折后购买价格
--参数：总价格
--返回：1、折扣（不为0时为有折扣）
--	   2、节省总金额
--	   3、折扣后总价格
function ShopItemData:GetTotalBuyDiscount(totalCost)
	if self.business == 1 then
		local buyDiscount = Game.Myself.data.props.BuyDiscount:GetValue() / 1000
		local discount = math.floor(totalCost * buyDiscount)
		return buyDiscount, discount, totalCost - discount
	else
		return 0, 0, totalCost
	end
end

--打折 + 技能打折 购买价格
function ShopItemData:GetBuyFinalPrice(price, count)
	local totalPrice = self:GetBuyDiscountPrice(price, count)
	local discount, discountCount
	discount, discountCount, totalPrice = self:GetTotalBuyDiscount(totalPrice)
	return totalPrice
end

-- 设置出售数量
function ShopItemData:SetSoldCount(server_soldCount)
	self.soldCount = server_soldCount;
end