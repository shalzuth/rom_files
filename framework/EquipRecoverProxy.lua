EquipRecoverProxy = class('EquipRecoverProxy', pm.Proxy)
EquipRecoverProxy.Instance = nil;
EquipRecoverProxy.NAME = "EquipRecoverProxy"

EquipRecoverProxy.RecoverType = {
	EmptyStrength = "EmptyStrength",
	Strength = "Strength",
	EmptyCard = "EmptyCard",
	EmptyEnchant = "EmptyEnchant",
	Enchant = "Enchant",
	EmptyUpgrade = "EmptyUpgrade",
}

local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.restore

function EquipRecoverProxy:ctor(proxyName, data)
	self.proxyName = proxyName or EquipRecoverProxy.NAME
	if(EquipRecoverProxy.Instance == nil) then
		EquipRecoverProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function EquipRecoverProxy:Init()
	self.recoverList = {}
	self.recoverToggleList = {}
end

function EquipRecoverProxy:GetRecoverEquips()
	local _BagProxy = BagProxy.Instance
	TableUtility.ArrayClear(self.recoverList)
	for i=1,#packageCheck do
		local items = _BagProxy:GetBagByType(packageCheck[i]):GetItems()
		for j=1,#items do
			local equip = items[j]
			if equip and equip.equipInfo then
				if EquipRecoverProxy.IsEquipNeedRecover(equip) then
					TableUtility.ArrayPushBack( self.recoverList , equip )
				end
			end
		end
	end
	return self.recoverList	
end

--卸卡魔石
function EquipRecoverProxy:GetMagicStoneRecover()
	TableUtility.ArrayClear(self.recoverList)
	local equipDatas = BagProxy.Instance:GetBagEquipItems()
	for i=1,#equipDatas do
		local equip = equipDatas[i]
		if equip then
			if EquipRecoverProxy.IsEquipNeedMagicStoneRecover(equip) then
				TableUtility.ArrayPushBack( self.recoverList , equip )
			end
		end
	end
	return self.recoverList
end

function EquipRecoverProxy.IsEquipNeedRecover(itemData)
	local equipInfo = itemData.equipInfo;
	if equipInfo and equipInfo.strengthlv > 0 then
		return true
	elseif equipInfo and equipInfo.strengthlv2 > 0 then
		return true
	elseif itemData:HasEquipedCard() then
		return true
	elseif itemData.enchantInfo and #itemData.enchantInfo:GetEnchantAttrs() > 0 then
		return true
	elseif equipInfo and equipInfo.equiplv > 0 then
		return true
	end
	return false
end

--卸卡魔石
function EquipRecoverProxy.IsEquipNeedMagicStoneRecover(itemData)
	local equipInfo = itemData.equipInfo
	if itemData:GetEquipedCardNum() >0 then
		return true
	end
	return false
end

function EquipRecoverProxy:GetRecoverToggle(item)
	TableUtility.ArrayClear(self.recoverToggleList)
	if item and item.equipInfo and (item.equipInfo.strengthlv > 0 or item.equipInfo.strengthlv2 > 0) then
		TableUtility.ArrayPushBack( self.recoverToggleList , self.RecoverType.Strength )
	else
		TableUtility.ArrayPushBack( self.recoverToggleList , self.RecoverType.EmptyStrength )
	end
	for i=1,2 do
		if item and item.equipedCardInfo and item.equipedCardInfo[i] then
			TableUtility.ArrayPushBack( self.recoverToggleList , item.equipedCardInfo[i] )
		else
			TableUtility.ArrayPushBack( self.recoverToggleList , self.RecoverType.EmptyCard )
		end
	end
	if item and item.enchantInfo and #item.enchantInfo:GetEnchantAttrs() > 0 then
		TableUtility.ArrayPushBack( self.recoverToggleList , self.RecoverType.Enchant )
	else
		TableUtility.ArrayPushBack( self.recoverToggleList , self.RecoverType.EmptyEnchant )
	end
	if item and item.equipInfo and item.equipInfo.equiplv > 0 then
		TableUtility.ArrayPushBack( self.recoverToggleList , item.equipInfo.equiplv )
	else
		TableUtility.ArrayPushBack( self.recoverToggleList , self.RecoverType.EmptyUpgrade )
	end
	return self.recoverToggleList	
end

--卸卡魔石
function EquipRecoverProxy:GetMagicStoneRecoverToggle(item)
	TableUtility.ArrayClear(self.recoverToggleList)
	for i=1,2 do
		if item and item.equipedCardInfo and item.equipedCardInfo[i] then
			TableUtility.ArrayPushBack( self.recoverToggleList , item.equipedCardInfo[i] )
		else
			TableUtility.ArrayPushBack( self.recoverToggleList , self.RecoverType.EmptyCard )
		end
	end
	return self.recoverToggleList
end

function EquipRecoverProxy:SetCurrency(currency)
	self.currency = currency
end

function EquipRecoverProxy:GetCurrency()
	return self.currency or GameConfig.MoneyId.Zeny
end

function EquipRecoverProxy:GetRecoverCost(itemData, card_rv, upgrade_rv, strength_rv, enchant_rv, strength_rv2)
	if(itemData == nil)then
		return 0;
	end
	local recoverConfig = GameConfig.EquipRecover;

	local resultCost = 0;
	if(card_rv)then
		local equipCards = itemData.equipedCardInfo;
		if(equipCards and #equipCards>0)then
			local maxIndex = #recoverConfig.Card;
			for k,v in pairs(equipCards)do
				local q = v.cardInfo.Quality;
				q = math.clamp(q, 1, maxIndex);
				resultCost = resultCost + recoverConfig.Card[q];
			end
		end
	end

	if(upgrade_rv)then
		local equiplv = itemData.equipInfo.equiplv;
		if(equiplv > 0)then
			equiplv = math.clamp(equiplv, 1, #recoverConfig.Upgrade);
			resultCost = resultCost + recoverConfig.Upgrade[equiplv];
		end
	end

	local strength_addCost = false;
	if(strength_rv)then
		if(itemData.equipInfo.strengthlv > 0)then
			strength_addCost = true;
			resultCost = resultCost + recoverConfig.Strength;
		end
	end

	if(strength_rv2 and strength_addCost == false)then
		if(itemData.equipInfo.strengthlv2 > 0)then
			resultCost = resultCost + recoverConfig.Strength;
		end
	end

	if(enchant_rv)then
		if(itemData.enchantInfo and itemData.enchantInfo:HasAttri())then
			resultCost = resultCost + recoverConfig.Enchant;
		end
	end

	return resultCost;
end