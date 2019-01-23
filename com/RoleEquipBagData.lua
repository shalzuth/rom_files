autoImport("ItemData")
autoImport("BagTabData")
autoImport("BagMainTab")
autoImport("BagData")
RoleEquipBagData = class("RoleEquipBagData",BagData)

function RoleEquipBagData:ctor(tabs,tabClass,type)
	RoleEquipBagData.super.ctor(self,tabs,tabClass,type)
	self.siteMap = {}

	self.staticIdMap = {};
	self.itemTypeMap = {};
end

function RoleEquipBagData:UpdateItems(serverItems)
	RoleEquipBagData.super.UpdateItems(self, serverItems);
	self:UpdateItemIdMap();
end

function RoleEquipBagData:AddItem(item)
	RoleEquipBagData.super.AddItem(self,item)
	self.siteMap[item.index] = item

	if(item.staticData)then
		self.staticIdMap[item.staticData.id] = 1;
		local num = self.itemTypeMap[item.staticData.Type]
		if(num == nil) then
			num = 0
		end
		num = num + 1
		self.itemTypeMap[item.staticData.Type] = num
	end

	EventManager.Me():PassEvent(RoleEquipEvent.TakeOn,item)
end

function RoleEquipBagData:RemoveItemByGuid(itemId)
	local item = self:GetItemByGuid(itemId)
	RoleEquipBagData.super.RemoveItemByGuid(self,itemId)
	if(item) then
		self.siteMap[item.index] = nil
		if(item.staticData)then
			self.staticIdMap[item.staticData.id] = nil;
			local num = self.itemTypeMap[item.staticData.Type]
			if(num == nil) then
				num = 0
			end
			num = math.max(0,num - 1)
			self.itemTypeMap[item.staticData.Type] = num
		end

		EventManager.Me():PassEvent(RoleEquipEvent.TakeOff,item)
	end
end

function RoleEquipBagData:GetStaticIdMap()
	return self.staticIdMap;
end

function RoleEquipBagData:GetEquipBySite(site)
	if(type(site) == "number")then
		return self.siteMap[site];
	end
end

--cardid 为0,返回所有卡片数量。不为0，返回指定id数量
function RoleEquipBagData:GetEquipCardNumBySiteAndCardID(site,cardID)
	local equip = self:GetEquipBySite(site)
	if(equip and equip.equipedCardInfo) then
		if(cardID == nil or cardID == 0) then
			return equip:GetEquipedCardNum()
		end
		local count = 0
		local card
		for i=1,equip.cardSlotNum do
			card = equip.equipedCardInfo[i]
			if(card and card.staticData and card.staticData.id == cardID) then
				count = count + 1
			end
		end
		return count
	end
	return 0
end

function RoleEquipBagData:GetTypeMap()
	return self.itemTypeMap;
end

function RoleEquipBagData:GetNumByItemType(t)
	return self.itemTypeMap[t] or 0;
end

function RoleEquipBagData:GetEquipedItemNum( itemId )
	local count = 0;

	if(Table_Equip[itemId])then
		for _,item in pairs(self.siteMap)do
			if(item.staticData.id == itemId)then
				count = count + 1;
			end
		end
	elseif(Table_Card[itemId])then
		for _,item in pairs(self.siteMap)do
			if(item.equipedCardInfo)then
				for kk,card in pairs(item.equipedCardInfo) do
					if(card.id == itemId)then
						count = count + 1;
					end
				end
			end
		end
	end

	return count;
end

function RoleEquipBagData:GetEqiupedSuitCardIds()
	local equipCards = {};
	for k,item in pairs(self.siteMap)do
		if(item.equipedCardInfo)then
			for kk,card in pairs(item.equipedCardInfo) do
				if(card and card.suitInfo)then
					equipCards[card.staticData.id] = 1;
				end
			end
		end
	end
	return equipCards;
end

function RoleEquipBagData:GetActiveSuitMap()
	return self.activeSuitMap;
end

function RoleEquipBagData:UpdateItemIdMap()
	if(self.itemIdMap == nil)then
		self.itemIdMap = {};
	else
		TableUtility.TableClear(self.itemIdMap);
	end

	local items = self:GetItems();
	for i=1,#items do
		local itemid = items[i].staticData.id;
		self.itemIdMap[itemid] = 1;
	end

	return self.itemIdMap;
end

function RoleEquipBagData:GetItemIdMap()
	return self.itemIdMap;
end


function RoleEquipBagData.GetEquipSiteByItemid(itemid)
	local equipData = Table_Equip[itemid];
	if(equipData == nil)then
		return nil;
	end

	local equipType = equipData.EquipType;
	local equipConfig = GameConfig.EquipType[equipType];
	return equipConfig and equipConfig.site[1];
end

local siteName_init, siteNameZhMap = false, {};
function RoleEquipBagData.GetSiteNameZh(site)
	if(siteName_init == false)then
		siteName_init = true;

		siteNameZhMap[1] = ZhString.RoleEquipBagData_Shield;

		local euqipConfig = GameConfig.EquipType;
		for k,v in pairs(euqipConfig)do
			for m,n in pairs(v.site)do
				if(n ~= 1)then
					siteNameZhMap[n] = v.name;
				end
			end
		end
	end

	return siteNameZhMap[site] or "";
end

function RoleEquipBagData:GetBreakEquipSiteInfo()
	local curServerTime = math.floor(ServerTime.CurServerTime()/1000);
	local items = self:GetItems();

	local result = {};
	for i=1,#items do
		local item = items[i];
		local equipInfo = items[i].equipInfo;
		if(equipInfo.breakendtime and equipInfo.breakendtime > curServerTime)then
			local siteInfo = {};
			siteInfo.index = item.index;
			siteInfo.breakstarttime = equipInfo.breakstarttime;
			siteInfo.breakendtime = equipInfo.breakendtime;
			table.insert(result, siteInfo);
		end
	end
	return result;
end

-- 获取坐骑
function RoleEquipBagData:GetMount()
	local mountSite = 13;
	local item = self.siteMap[mountSite];
	if(item and item:IsMount())then
		return item;
	end
	return nil;
end