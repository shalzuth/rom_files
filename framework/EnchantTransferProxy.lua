EnchantTransferProxy = class('EnchantTransferProxy', pm.Proxy)
EnchantTransferProxy.Instance = nil;
EnchantTransferProxy.NAME = "EnchantTransferProxy"

local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack
local _FilterCfg = GameConfig.Lottery.TransferFilter

function EnchantTransferProxy:ctor(proxyName, data)
	self.proxyName = proxyName or EnchantTransferProxy.NAME
	if(EnchantTransferProxy.Instance == nil) then
		EnchantTransferProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end


function EnchantTransferProxy:Init()
	self.lotteryStaticId={}
	self.enchantInData={}
	self.enchantOutData={}
	self.chooseTransferInData=false
end

function EnchantTransferProxy:ResetPhase(var)
	self.chooseTransferInData=var
end

function EnchantTransferProxy:GetLotteryIDs()
	return self.lotteryStaticId
end

function EnchantTransferProxy:HandleLotteryHeadItem(data)
	TableUtility.ArrayClear(self.lotteryStaticId)
	for i=1,#data do
		_ArrayPushBack(self.lotteryStaticId,data[i])
	end
end

function EnchantTransferProxy:ResetChooseData(data)
	self.chooseData=data
end

function EnchantTransferProxy:GetEnchantInData()
	_ArrayClear(self.enchantInData)
	local equipEquips = BagProxy.Instance.roleEquip:GetItems() or {};
	local bagEquips = BagProxy.Instance:GetBagEquipItems()
	for i=1,#equipEquips do
		local equip = equipEquips[i]
		if(0~=TableUtility.ArrayFindIndex(self.lotteryStaticId,equip.staticData.id) and _FilterCfg[equip.staticData.Type])then
			if(0< #equip.enchantInfo:GetEnchantAttrs())then
				_ArrayPushBack(self.enchantInData,equip)
			end
		end
	end
	for i=1,#bagEquips do
		local equip = bagEquips[i]
		if(0~=TableUtility.ArrayFindIndex(self.lotteryStaticId,equip.staticData.id) and _FilterCfg[equip.staticData.Type])then
			if(0< #equip.enchantInfo:GetEnchantAttrs())then
				_ArrayPushBack(self.enchantInData,equip)
			end
		end
	end
	return self.enchantInData
end

function EnchantTransferProxy:GetEnchantOutData()
	_ArrayClear(self.enchantOutData)
	local equipEquips = BagProxy.Instance.roleEquip:GetItems() or {};
	local bagEquips = BagProxy.Instance:GetBagEquipItems()
	for i=1,#equipEquips do
		local equip = equipEquips[i]
		if(0~=TableUtility.ArrayFindIndex(self.lotteryStaticId,equip.staticData.id) and _FilterCfg[equip.staticData.Type])then
			if equip.equipInfo:CanEnchant() and self.chooseData.staticData.Type==equip.staticData.Type and equip.staticData.id~=self.chooseData.staticData.id then
				_ArrayPushBack(self.enchantOutData,equip)
			end
		end
	end
	for i=1,#bagEquips do
		local equip = bagEquips[i]
		if(0~=TableUtility.ArrayFindIndex(self.lotteryStaticId,equip.staticData.id) and _FilterCfg[equip.staticData.Type])then
			if equip.equipInfo:CanEnchant() and self.chooseData.staticData.Type==equip.staticData.Type and equip.staticData.id~=self.chooseData.staticData.id then
				_ArrayPushBack(self.enchantOutData,equip)
			end
		end
	end
	return self.enchantOutData
end

local filterList = {}
function EnchantTransferProxy:GetFilterData(type)
	local data = self.chooseTransferInData and self.enchantInData or self.enchantOutData
	if 0==type then
		return data
	end
	_ArrayClear(filterList)
	for i=1,#data do
		if(data[i].staticData and data[i].staticData.Type == type)then
			_ArrayPushBack(filterList,data[i])
		end
	end
	return filterList
end




