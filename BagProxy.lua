autoImport("BagData")
autoImport("FashionBagData")
autoImport("RoleEquipBagData")
autoImport("CardBagData")
autoImport("Table_ItemBeTransformedWay")
autoImport('ItemFun')
local BagProxy = class('BagProxy', pm.Proxy)

BagProxy.Instance = nil;

BagProxy.NAME = "BagProxy"

BagProxy.BagType = {
	--?????????
	MainBag = SceneItem_pb.EPACKTYPE_MAIN,
	--????????????????????????
	RoleEquip = SceneItem_pb.EPACKTYPE_EQUIP,
	--????????????????????????
	RoleFashionEquip = SceneItem_pb.EPACKTYPE_FASHIONEQUIP,
	--????????????
	Storage = SceneItem_pb.EPACKTYPE_STORE,
	--????????????
	Card = SceneItem_pb.EPACKTYPE_CARD,
	--????????????
	Fashion = SceneItem_pb.EPACKTYPE_FASHION,
	--??????????????????
	PersonalStorage = SceneItem_pb.EPACKTYPE_PERSONAL_STORE or 7,
	--????????????
	Temp = SceneItem_pb.EPACKTYPE_TEMP_MAIN or 8,
	--???????????????
	Barrow = SceneItem_pb.EPACKTYPE_BARROW or 9,
	--????????????
	Quest = SceneItem_pb.EPACKTYPE_QUEST or 10,
	--????????????
	Food = SceneItem_pb.EPACKTYPE_FOOD or 11,
}

BagProxy.ItemTypeGroup = {
	Card = 2
}

BagProxy.EquipUpgrade_RefreshBagType = 
{
	[1] = 1, 
	[2] = 1,
};

--????????????????????????

function BagProxy:ctor(proxyName, data)
	self.proxyName = proxyName or BagProxy.NAME
	if(BagProxy.Instance == nil) then
		BagProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end
	self:InitItemKind()
	self.bagData = BagData.new({
			{data = GameConfig.ItemPage[1],class = BagEquipTab},
			{data = GameConfig.ItemPage[2]},
			{data = GameConfig.ItemPage[3]},
			{data = GameConfig.ItemPage[4]}
			},nil,BagProxy.BagType.MainBag)
	self:InitFashionBag()
	self.repositoryBag=BagData.new({
			{data = GameConfig.ItemPage[1],class = BagEquipTab},
			{data = GameConfig.ItemPage[2]},
			{data = GameConfig.ItemPage[3]},
			{data = GameConfig.ItemPage[4]}
			},nil,BagProxy.BagType.Storage)
	self.personalRepositoryBag=BagData.new({
			{data = GameConfig.ItemPage[1],class = BagEquipTab},
			{data = GameConfig.ItemPage[2]},
			{data = GameConfig.ItemPage[3]},
			{data = GameConfig.ItemPage[4]}
			},nil,BagProxy.BagType.PersonalStorage)
	self.barrowBag = BagData.new({
			{data = GameConfig.ItemPage[1],class = BagEquipTab},
			{data = GameConfig.ItemPage[2]},
			{data = GameConfig.ItemPage[3]},
			{data = GameConfig.ItemPage[4]}
			},nil,BagProxy.BagType.Barrow);
	self.tempBagData = BagData.new(nil,nil,BagProxy.BagType.Temp)

	self.questBagData = BagData.new(nil,nil,BagProxy.BagType.Quest);

	local FoodPackPage = GameConfig.FoodPackPage;
	if(FoodPackPage)then
		self.foodBagData = BagData.new({
			{data = FoodPackPage[1]},
			{data = FoodPackPage[2]},
		},nil,BagProxy.BagType.Food);
	end

	self.bagMap = {}
	self.bagMap[BagProxy.BagType.MainBag] = self.bagData
	self.bagMap[BagProxy.BagType.RoleEquip] = self.roleEquip
	self.bagMap[BagProxy.BagType.RoleFashionEquip] = self.fashionEquipBag
	self.bagMap[BagProxy.BagType.Storage]=self.repositoryBag
	self.bagMap[BagProxy.BagType.PersonalStorage]=self.personalRepositoryBag
	self.bagMap[BagProxy.BagType.Temp]=self.tempBagData

	self.bagMap[BagProxy.BagType.Fashion] = self.fashionBag
	self.bagMap[BagProxy.BagType.Card]=self.cardBag
	self.bagMap[BagProxy.BagType.Barrow]=self.barrowBag

	self.bagMap[BagProxy.BagType.Quest]=self.questBagData
	self.bagMap[BagProxy.BagType.Food]=self.foodBagData

	FunctionCDCommand.Me():StartCDProxy(BagCDRefresher,33)
	FunctionCDCommand.Me():StartCDProxy(AssociateRemoveFunctionCD,16,self)

	--??????
	self._moneyGet = {}
	self._moneyGet[GameConfig.MoneyId.Zeny] = function ()
		return MyselfProxy.Instance:GetROB()
	end
end

function BagProxy:InitFashionBag()
	local tabs = {}
	for i=1,#GameConfig.ItemFashion do
		tabs[#tabs+1] = {data = GameConfig.ItemFashion[i]}
	end
	self.fashionBag = FashionBagData.new(tabs,BagFashionTab,BagProxy.BagType.Fashion)
	self.fashionEquipBag = RoleEquipBagData.new(nil,nil,BagProxy.BagType.RoleFashionEquip);
	self.roleEquip = RoleEquipBagData.new(nil,nil,BagProxy.BagType.RoleEquip)
	tabs = {}
	for i=1,#GameConfig.CardPage do
		tabs[#tabs+1] = {data = GameConfig.CardPage[i]}
	end
	self.cardBag = CardBagData.new(tabs,nil,BagProxy.BagType.Card)
end

function BagProxy:InitItemKind()
	BagProxy.fashionType = {}
	local types = nil
	for i=1,#GameConfig.ItemFashion do
		types = GameConfig.ItemFashion[i].types
		for k,v in pairs(types) do
			BagProxy.fashionType[v] = true
		end
	end
end

function BagProxy:onRegister()
end

function BagProxy:onRemove()
end

function BagProxy:SetIsNewFlag(package,value)
	local bag = self.bagMap[package]
	local items = bag:GetItems()
	for i=1,#items do
		items[i].isNew = value
	end
end

function BagProxy:GetBagByType(t)
	return self.bagMap[t]
end

function BagProxy:GetBagUseTab()
	return self.bagData:GetTab(GameConfig.ItemPage[4])
end

function BagProxy:GetBagEquipTab()
	return self.bagData:GetTab(GameConfig.ItemPage[1])
end

function BagProxy:GetBagEquipItems()
	local items = self.bagData:GetItems();

	if(self.equips == nil)then
		self.equips = {};
	else
		TableUtility.ArrayClear(self.equips);
	end
	for i=1,#items do
		if(items[i].equipInfo)then
			table.insert(self.equips, items[i]);
		end
	end
	return self.equips;
end

function BagProxy:GetBagChipTab()
	return self.bagData:GetTab(GameConfig.ItemPage[3])
end

function BagProxy:GetMainBag()
	return self.bagData
end

function BagProxy:GetRepositoryBagData()
	return self.repositoryBag
end

function BagProxy:GetPersonalRepositoryBagData()
	return self.personalRepositoryBag
end

function BagProxy:GetRoleEquipBag()
	return self.roleEquip
end

-- ??????????????????????????????????????????
function BagProxy:GetBagItemsByType(type, bagType)
	local bagData = self:GetBagByType(bagType) or self.bagData;
	local bagItems = bagData:GetItems();
	local result = {};
	for _,item in pairs(bagItems)do
		if(item.staticData and item.staticData.Type == type)then
			table.insert(result, item);
		end
	end
	return result;
end

-- ??????????????????????????????????????????
local tmpTypes = {}
function BagProxy:GetBagItemsByTypes(types, bagType)
	if(types == nil or type(types)~='table') then
		return nil
	end
	bagType = bagType or BagProxy.BagType.MainBag
	local bagItems = self.bagMap[bagType]:GetItems();
	local result = {};
	TableUtility.TableClear(tmpTypes)
	for k,v in pairs(types) do
		tmpTypes[v] = 1
	end
	for _,item in pairs(bagItems)do
		if(item.staticData and tmpTypes[item.staticData.Type] ~=nil)then
			table.insert(result, item);
		end
	end
	return result;
end

--??????????????????????????????ID???????????????
function BagProxy:GetItemNumByStaticIDInCard(staticID)
	return self:GetItemNumByStaticID(staticID,BagProxy.BagType.Card)
end

-- ????????????+????????????????????????
function BagProxy:GetAllItemNumByStaticID(staticID)
	local itemInMain = self:GetItemNumByStaticID(staticID);
	local itemInStore = self:GetItemNumByStaticID(staticID, BagProxy.BagType.Storage);
	local itemInPersonalStore = self:GetItemNumByStaticID(staticID, BagProxy.BagType.PersonalStorage)
	return itemInMain + itemInStore + itemInPersonalStore
end

function BagProxy:GetItemByGuid(guid, bagType)
	local type_bagType = type(bagType);

	if(type_bagType == "number")then
		local bagData =	self.bagMap[bagType];
		return bagData and bagData:GetItemByGuid(guid);
	elseif(type_bagType == "table")then
		for i=1,#bagType do
			local item = self:GetItemByGuid(guid, bagType[i]);
			if(item ~= nil)then
				return item;
			end
		end
	else
		for _,bagData in pairs(self.bagMap)do
			local item = bagData:GetItemByGuid(guid);
			if(item)then
				return item;
			end
		end
	end
end

--???????????????????????????????????????????????????id??????????????? bagType?????????table
function BagProxy:GetItemNumByStaticID(staticID,bagType)
	local func = self._moneyGet[staticID]
	if(func~=nil) then
		return func()
	end

	local staticData = Table_Item[staticID]

	local v_type = type(bagType);
	if(v_type== "nil")then
		bagType = BagProxy.BagType.MainBag;
	elseif(v_type== "table")then

		local count = 0;
		for i=1,#bagType do
			count = count + self:GetItemNumByStaticID( staticID, bagType[i]);
		end
		
		return count;
	end
		
	local bag = self.bagMap[bagType]
	if(staticData) then
		local tab = bag.itemMapTab[staticData.Type] or bag.wholeTab
		return tab:GetItemNumByStaticID(staticID)
	end

	return 0
end

--???????????????????????????????????????????????????id???????????????
function BagProxy:GetItemsByStaticID(staticID,bagType)
	local staticData = Table_Item[staticID]
	bagType = bagType or BagProxy.BagType.MainBag
	local bag = self.bagMap[bagType]
	if(staticData) then
		local tab = bag.itemMapTab[staticData.Type] or bag.wholeTab
		return tab:GetItemsByStaticID(staticID)
	end
	return nil
end

-- ????????????ID ??????????????????????????????
function BagProxy:GetNewestItemByStaticID(staticID, bagType)
	local items = self:GetItemsByStaticID(staticID, bagType);
	local resultItem;
	if(items)then
		local maxtime = 0;
		for i=1,#items do
			if(items[i].createtime > maxtime)then
				maxtime = items[i].createtime;
				resultItem = items[i];
			end
		end
	end
	return resultItem;
end

function BagProxy:GetItemNumByStaticIDs(staticIDs,page)
	local tab = self.bagData:GetTab(page)
	if(tab) then
		return tab:GetItemNumByStaticIDs(staticIDs)
	end
	return nil
end

--?????????????????????????????????
-- Type ???????????????item ??? Type???
-- cardType ?????????????????????????????????????????????????????????
function BagProxy:FilterEquipedCardItems(Type)
	local filterItems = {}
	self:FilterEquipedCardItemsByBagType(BagProxy.BagType.RoleEquip,Type,filterItems)
	self:FilterEquipedCardItemsByBagType(BagProxy.BagType.MainBag,Type,filterItems)
	return filterItems
end

function BagProxy:FilterEquipedCardItemsByBagType( bagType,Type,filterItems )
	-- body
	local items = self.bagMap[bagType]:GetItems()
	local item
	for i=1,#items do
		item = items[i]
		-- print("Type:"..Type.."  staticData.type"..item.staticData.Type.."   cardSlotNum:"..item.cardSlotNum.."")
		if(self.CheckEquipTypeInCardComposeType(Type,item.staticData.Type) and item.cardSlotNum ~= nil and item.cardSlotNum > 0 )then			
			filterItems[#filterItems+1] = item
		end
	end
end

function BagProxy.CheckIsCoinTypeItem( type)
	-- body
	local tb = Table_ItemType[type]
	if(tb and tb.EffectShow)then
		return tb.EffectShow & 2 > 0;
	else		
		printRed("can't find itemType data by type:"..(type or 0))
	end
end

function BagProxy.CheckIs3DTypeItem( type)
	-- body
	local tb = Table_ItemType[type]
	if(tb and tb.EffectShow)then
		return tb.EffectShow & 1 > 0;
	else		
		printRed("can't find itemType data by type:"..(type or 0))
	end
end

function BagProxy.CheckIsCardTypeItem(type)
	--body
	local tb = Table_ItemType[type]
	if(tb and tb.EffectShow)then
		return tb.EffectShow & 4 > 0;
	else		
		printRed("can't find itemType data by type:"..(type or 0))
	end
end

function BagProxy.CheckIsFoodTypeItem(type)
	--body
	local tb = Table_ItemType[type]
	if(tb and tb.EffectShow)then
		return tb.EffectShow & 8 > 0;
	else		
		printRed("can't find itemType data by type:"..(type or 0))
	end
end

function BagProxy.CheckEquipTypeInCardComposeType( type ,equipType)
	local types = GameConfig.CardComposeType[type].types
	for i=1,#types do
		if(types[i] == equipType)then
			return true
		end
	end
end

function BagProxy:GetItemByStaticID(staticID, bagType)
	local staticData = Table_Item[staticID]
	if(staticData) then
		bagType = bagType or BagProxy.BagType.MainBag;
		local bagData = self.bagMap[bagType];
		local tab = bagData.itemMapTab[staticData.Type]
		tab = tab or bagData.wholeTab;
		return tab:GetItemByStaticID(staticID)
	end
	return nil
end

function BagProxy:GetItemByStaticIDWithoutCard(staticID)
	local staticData = Table_Item[staticID]
	if(staticData) then
		local tab = self.bagData.itemMapTab[staticData.Type]
		if(tab)then
			local items = tab:GetItemsByStaticID(staticID)
			if(items and #items>0)then
				for i=1,#items do
					local noEquipCard = not items[i]:HasEquipedCard()
					local noStrengthlv = true
					local equipInfo = items[i].equipInfo
					if(equipInfo)then
						noStrengthlv = equipInfo.strengthlv == 0
					end
					if(noEquipCard and noStrengthlv)then
						return items[i]
					end
				end
			end
		end
	end
	return nil
end

function BagProxy:SetProToEquipTab( pro )
	self:GetBagEquipTab():SetProfess(pro)
end

function BagProxy:SetToEquipPos(pos)
	self.ToEquipPos = pos;
end

function BagProxy:GetToEquipPos()
	return self.ToEquipPos;
end

function BagProxy:GetNowActiveItem()
	return self.bagData:GetActiveItem();
end

function BagProxy.CheckEquipIsClean(item, expRefine)
	local equipInfo = item.equipInfo;
	local enchantInfo = item.enchantInfo;
	local nocards = not item:HasEquipedCard();
	if(equipInfo)then
		if(equipInfo.strengthlv <= 0
			and equipInfo.strengthlv2 <= 0
			and equipInfo.equiplv <= 0 
			and (nocards)
			and (not enchantInfo or not enchantInfo:HasAttri()))then
			if(expRefine == true)then
				return true;
			else
				return equipInfo.refinelv <= 0;
			end
		end
	end
	return false;
end

function BagProxy:CheckCanReplace(staticID, material_checkFunc, filter_guid)
	local composeId = Table_Equip[staticID] and Table_Equip[staticID].SubstituteID;
	if(composeId)then
		local composeData = Table_Compose[composeId];
		if(composeData)then
			return true, composeData.Product.id;
		end
	end

	return false;
end

function BagProxy:ServerSetBagUpLimit(bagType, limit)
	if(not bagType)then
		return;
	end
	local bagData = self.bagMap[bagType];
	if(bagData)then
		local msgId;
		if(bagType == BagProxy.BagType.MainBag)then
			msgId = 3103;
		elseif(bagType == BagProxy.BagType.PersonalStorage)then
			msgId = 3109;
		end
		if(msgId)then
			local oldlimit = bagData:GetUplimit();
			if(oldlimit~=0 and limit > oldlimit)then
				MsgManager.ShowMsgByIDTable(msgId , { limit - oldlimit });
			end
		end

		bagData:SetUplimit(limit)
	end
end

function BagProxy:GetBagUpLimit(bagType)
	if(not bagType)then
		return;
	end
	local bagData = self.bagMap[bagType];
	if(bagData)then
		return bagData:GetUplimit();
	end
end

function BagProxy:CheckBagIsFull(bagType)
	bagType = bagType or BagProxy.BagType.MainBag;
	local bagData = self.bagMap[bagType];
	if(bagData)then
		return bagData:IsFull();
	end
	return false;
end

function BagProxy:GetItemFreeSpaceByStaticId(bagType, itemid)
	bagType = bagType or BagProxy.BagType.MainBag;
	local bagData = self.bagMap[bagType];
	if(bagData)then
		return bagData:GetItemFreeSpaceByStaticId(itemid);
	end
	return 0;
end

-- moneyType always can putinBag
function BagProxy:CheckItemCanPutIn(bagType, itemid, num, withTip, tipId)
	local itype = itemid and Table_Item[itemid] and Table_Item[itemid].Type;
	local moneyTypeValues = ProtoCommon_pb.EMONEYTYPE.values;
	for i=1,#moneyTypeValues do
		local value = moneyTypeValues[i] and moneyTypeValues[i].number;
		if(itype == value)then
			return true;
		end
	end
	
	local spaceNum = self:GetItemFreeSpaceByStaticId(bagType, itemid);
	num = num or 1;
	local can = spaceNum >= num;
	if(not can and withTip)then
		tipId = tipId or 3101;
		MsgManager.ShowMsgByIDTable(tipId);
	end
	return can;
end

local tempEggs = {};
function BagProxy:GetMyPetEggs(bagType)
	bagType = bagType or BagProxy.BagType.MainBag;
	local bagData = self.bagMap[bagType];
	if(bagData)then
		local items = bagData:GetItems();

		TableUtility.ArrayClear(tempEggs);
		for i=1,#items do
			if(items[i].petEggInfo and (items[i].petEggInfo.name~=nil and items[i].petEggInfo.name~=""))then
				table.insert(tempEggs, items[i]);
			end
		end
		return tempEggs;
	end
end


local initEquipUpdate = false;
local initEquipReplace = false;
local upgradeProductKeyMap = {};
local replaceProductKeyMap = {};
local suitIdsMap = {};
function BagProxy.GetSuitIds(itemid)
	local ids = suitIdsMap[itemid];
	if(ids ~= nil)then
		return ids;
	end

	ids = {};
	suitIdsMap[itemid] = ids;

	local s1 = Table_Equip[itemid] and Table_Equip[itemid].SuitID;
	for i=1,#s1 do
		table.insert(ids, s1[i]);
	end

	local surEquips = BagProxy.Instance:GetSurceEquipIds(itemid);
	for i=1,#surEquips do
		local equipId = surEquips[i];

		local suitids = BagProxy.GetSuitIds(equipId);
		for i=1,#suitids do
			if(TableUtility.ArrayFindIndex(ids, suitids[i]) == 0)then
				table.insert(ids, suitids[i]);
			end
		end
	end

	return ids;
end

function BagProxy:GetSurceEquipIds(equipId)
	if(self.upgradeProductKeyMap == nil or self.replaceProductKeyMap == nil)then
		self.upgradeProductKeyMap = {};
		for upgradeid, upgradeData in pairs(Table_EquipUpgrade)do
			local productId = upgradeData.Product;
			if(productId)then
				if(self.upgradeProductKeyMap[productId] == nil)then
					self.upgradeProductKeyMap[productId] = {};
				end
				table.insert(self.upgradeProductKeyMap[productId], upgradeData);
			end
		end

		self.replaceProductKeyMap = {};
		for id, equipData in pairs(Table_Equip)do
			if(equipData.SubstituteID)then
				local composeData = Table_Compose[equipData.SubstituteID];
				local productId = composeData and composeData.Product.id;
				if(productId == nil)then
					error(string.format("ComposeData:%s not Find ProductId", equipData.SubstituteID));
					return;
				end
				if(self.replaceProductKeyMap[productId] == nil)then
					self.replaceProductKeyMap[productId] = {};
				end
				table.insert(self.replaceProductKeyMap[productId], composeData);
			end
		end

		self.sourceEquipMap = {};
	end

	local equipIds = self.sourceEquipMap[equipId];
	if(equipIds == nil)then
		equipIds = {};
		self.sourceEquipMap[equipId] = equipIds;

		local upgradeDatas = self.upgradeProductKeyMap[equipId];
		if(upgradeDatas)then
			for i=1,#upgradeDatas do
				local baseid = upgradeDatas[i].id;
				if(TableUtility.ArrayFindIndex(equipIds, baseid) == 0)then
					table.insert(equipIds, baseid)
				end

				local surIds = BagProxy.Instance:GetSurceEquipIds(baseid);
				if(surIds)then
					for j=1,#surIds do
						if(TableUtility.ArrayFindIndex(equipIds, surIds[j]) == 0)then
							table.insert(equipIds, surIds[j]);
						end
					end
				end
			end
		end

		local replaceDatas = self.replaceProductKeyMap[ equipId ];
		if(replaceDatas)then
			for i=1,#replaceDatas do
				local baseid = replaceDatas[i].BeCostItem[1].id;
				if(TableUtility.ArrayFindIndex(equipIds, baseid) == 0)then
					table.insert(equipIds, baseid)
				end

				local surIds = BagProxy.Instance:GetSurceEquipIds(baseid);
				if(surIds)then
					for j=1,#surIds do
						if(TableUtility.ArrayFindIndex(equipIds, surIds[j]) == 0)then
							table.insert(equipIds, surIds[j]);
						end
					end
				end
			end
		end
	end

	return equipIds;
end

local suitEquipMap = {};
function BagProxy:MatchEquipSuitBySuitId(suitId)
	local suitData = Table_EquipSuit[suitId];
	if(suitData == nil)then
		return 0;
	end

	local suitEquips = suitData.Suitid;
	for i=1,#suitEquips do
		suitEquipMap[ suitEquips[i] ] = 0;
	end

	local items = self.roleEquip:GetItems();
	for i=1,#items do
		local itemid = items[i].staticData.id;

		local find = false;
		if(suitEquipMap[itemid])then
			find = true;
			suitEquipMap[itemid] = suitEquipMap[itemid] + 1;
		end

		if(not find)then
			local surEquips = self:GetSurceEquipIds(itemid);
			if(surEquips)then
				for j=1,#surEquips do
					local surId = surEquips[j];
					if( suitEquipMap[surId])then
						find = true;
						suitEquipMap[surId] = suitEquipMap[surId] + 1;
						break;
					end
				end
			end
		end
	end

	local matchCount = 0;
	for k,v in pairs(suitEquipMap)do
		if(v > 0)then
			matchCount = matchCount + 1;
		end
	end

	TableUtility.TableClear(suitEquipMap);

	return matchCount;
end

local initUnlockSpace;
function BagProxy:GetBagUnlockSpaceData()
	if(not initUnlockSpace)then
		initUnlockSpace = true;

		self.unloceSpaceLvs = {};

		for id,data in pairs(Table_UnlockSpace)do
			table.insert(self.unloceSpaceLvs, data.id);
		end

		table.sort(self.unloceSpaceLvs, function (ida, idb)
			return ida < idb;
		end)
	end

	local mylv = MyselfProxy.Instance:RoleLevel();
	local index = 0;
	for i=1,#self.unloceSpaceLvs do
		if(mylv < self.unloceSpaceLvs[i])then
			index = i;
			break;
		end
	end
	return Table_UnlockSpace[ self.unloceSpaceLvs[index] ];
end

function BagProxy:CheckFashionCanMake(itemid)
	local cid = Table_ItemBeTransformedWay[itemid] and Table_ItemBeTransformedWay[itemid].composeWay;
	if(cid == nil)then
		-- error(tostring(cid) .. " not Fashion");
		return false;
	end
	local costData = Table_Compose[cid]
	if(costdata)then
		for i=1,#costdata.BeCostItem do
			local hasNum = self:GetItemByStaticID(costdata.BeCostItem[i].id);
			if(hasNum < costdata.BeCostItem[i].num)then
				return false;
			end
		end
		return true;
	end
end

function BagProxy:GetMaterialItems_ByItemId(itemid, bagTypes, matchCall, matchCallParam)
	if(bagTypes == nil)then
		return self:GetItemsByStaticID(itemid);
	else
		local result = {};

		local bagData, mItems;
		for i=1, #bagTypes do
			mItems = self:GetItemsByStaticID(itemid, bagTypes[i]);
			if(mItems)then
				for j=1,#mItems do
					if(matchCall)then
						matchCall(matchCallParam, mItems[j]);
					end
					table.insert(result, mItems[j])
				end
			end
		end

		return result;
	end
end

local upgrade_checkbagtypes_map;
function BagProxy:RefreshUpgradeCheckInfo(bagData)
	if(bagData == nil)then
		return;
	end

	if(upgrade_checkbagtypes_map == nil)then
		upgrade_checkbagtypes_map = {};
		local upgradeCheckTypes = EquipInfo.GetEquipCheckTypes();
		for i=1,#upgradeCheckTypes do
			upgrade_checkbagtypes_map[ upgradeCheckTypes[i] ] = 1;
		end
	end

	if(upgrade_checkbagtypes_map[bagData.type] == nil)then
		return;
	end
	
	local bagData, bagTab, items;
	for bagType,v in pairs(self.EquipUpgrade_RefreshBagType)do
		bagData = self.bagMap[bagType];
		bagTab = bagData:GetTab(GameConfig.ItemPage[1]) or bagData.wholeTab;
		items = bagTab:GetItems();
		for j=1,#items do
			if(items[j].equipInfo)then
				items[j].equipInfo:SetUpgradeCheckDirty();
			end
		end
	end
end

BagProxy.MaterialCheckBag_Type = 
{
	Produce = "produce",
	Upgrade = "upgrade",
	Equipexchange = "equipexchange",
	Exchange = "exchange",
	Refine = "refine",
	Repair = "repair",
	Enchant = "enchant",
	Guilddonate = "guilddonate",
	Restore = "restore",
	Shop = "shop",
	adventureProduce = "adventureProduce",
}
function BagProxy:Get_PackageMaterialCheck_BagTypes(key)
	local packageMaterialCheck = GameConfig.PackageMaterialCheck;
	if(packageMaterialCheck == nil)then
		return;
	end

	if(packageMaterialCheck[key] == nil)then
		return packageMaterialCheck.default;
	end

	return packageMaterialCheck[key];
end

function BagProxy:GetMarryInviteLetters()
	local result = {};
	local mainBag = self:GetBagByType(BagProxy.BagType.MainBag);
	local items = mainBag:GetItems();
	for i=1,#items do
		if(items[i]:IsMarryInviteLetter())then
			table.insert(result, items[i]);
		end
	end
	return result;
end

function BagProxy:NeedShowEnchantTip()
	FunctionUnLockFunc.Me():CheckCanOpenByPanelId(305, withTip, unlockType)
end

-- ????????????
local t_srched = {};
function BagProxy:CollectQuickStorageItems(ref_recv)
	if(ref_recv == nil)then
		error("ref_recv is nil");
	end

	local items = self.personalRepositoryBag:GetItems();

	if(items == nil)then
		return;
	end

	for i=1, #items do
		local sid = items[i].staticData.id;
		if(items[i]:CanStack())then
			if(t_srched[sid] == nil)then
				t_srched[sid] = 1;

				local bitems = self.bagData.wholeTab:GetItemsByStaticID(sid, BagProxy.BagType.MainBag);
				if(bitems)then
					for k,bitem in pairs(bitems)do
						if(bitem:CanStack())then
							table.insert(ref_recv, bitem);
						end
					end
				end
				
			end
		end
	end

	TableUtility.TableClear(t_srched);
end

-- ????????????
function BagProxy:CollectQuickSaleItems(ref_recv)
	if(ref_recv == nil)then
		error("ref_recv is nil");
	end

	local items = self.bagData:GetItems();

	if(items == nil)then
		return;
	end

	local item, sData;
	for i=1,#items do
		item = items[i];
		if(self:CanQuickSell(item))then
			table.insert(ref_recv, item);
		end
	end
end

function BagProxy:CanQuickSell(item)
	if(item == nil)then
		return false;
	end
	if(item.equipInfo == nil)then
		return false;
	end
	local sData = item.staticData;
	if(not ItemFun.canQuickSell(sData.id))then
		return false;
	end
	if(item.equipInfo.refinelv >= 5)then
		return false;
	end
	local equipedCards = item.equipedCardInfo;
	if(equipedCards ~= nil)then
		for i=1,item.cardSlotNum do
			if(equipedCards[i])then
				return false;
			end
		end
	end
	if(item.equipInfo.strengthlv > 0)then
		return false;
	end
	local enchantInfo = item.enchantInfo;
	local enchantAttrs = enchantInfo and enchantInfo:GetEnchantAttrs();
	if(enchantAttrs and #enchantAttrs > 0)then
		return false;
	end

	return true;
end

return BagProxy