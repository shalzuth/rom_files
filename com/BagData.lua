autoImport("ItemData")
autoImport("BagTabData")
autoImport("BagMainTab")
autoImport("EquipCardInfo")
BagData = class("BagData")

function BagData:ctor(tabs,tabClass,type)
	self.uplimit = 0;
	self.tabs = {}
	self.itemMapTab = {}
	self.type = type
	self.wholeTab = BagMainTab.new()
	tabClass = tabClass or BagTabData
	if(tabs ~=nil) then
		for i=1,#tabs do
			local class = tabs[i].class or tabClass
			local tabData = class.new(tabs[i].data)
			self.tabs[tabs[i].data] = tabData
			local types = tabs[i].data.types
			for j=1,#types do
				self.itemMapTab[types[j]]=tabData
			end
		end
	end
end

--items数据，tabtype标签
function BagData:AddItems(items,tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			tab:AddItems(items)
		end
	end
	self.wholeTab:AddItems(items)

	BagProxy.Instance:RefreshUpgradeCheckInfo(self);
end

function BagData:AddItem(item)
	local tab = self.itemMapTab[item.staticData.Type]
	-- print(tab)
	if(tab ~=nil) then
		tab:AddItem(item)
	end
	self.wholeTab:AddItem(item)
end

function BagData:RemoveItems(items)
	for i=1,#items do 
		self:RemoveItemByGuid(items[i].base.guid)
	end
end

function BagData:RemoveItemsByGuid(itemIds)
	for i=1,#itemIds do 
		self:RemoveItemByGuid(itemIds[i])
	end
	BagProxy.Instance:RefreshUpgradeCheckInfo(self);
end

function BagData:RemoveItemByGuid(itemId)
	-- print("remove "..itemId)
	local item = self:GetItemByGuid(itemId)
	if(item ~=nil) then
		-- print("find then remove"..itemId)
		self.wholeTab:RemoveItemByGuid(itemId)
		local tab = self.itemMapTab[item.staticData.Type]
		if(tab ~=nil) then
			tab:RemoveItemByGuid(itemId)
		end
	end
end

function BagData:UpdateItems(serverItems)
	-- print(#serverItems)
	for i=1,#serverItems do
		local sItem = serverItems[i]
		local sItemData = sItem.base
		-- print(sItem)
		local item = self:GetItemByGuid(sItemData.guid)
		if(sItemData.index == self.wholeTab.holdPlaceData.index and sItemData.id ~=0) then
			self.wholeTab:ClearPlaceHolder()
		end
		if(item ~=nil) then
			self:UpdateItem(item,sItem)
		else
			item = ItemData.new(sItemData.guid,sItemData.id)
			self:UpdateItem(item,sItem)
			-- item.type = math.random(131,160)
			-- item.qua = math.random(1,5)
			-- item.sid = math.random(1,10000)

			-- item.staticData = 
			if(item.staticData ~=nil) then
				self:AddItem(item)
			elseif(sItemData.id ~= 0) then
				-- error("未找到物品配置"..sItemData.id)
			else
				self.wholeTab:ResetPlaceHolder(sItemData)
			end
		end
	end
	BagProxy.Instance:RefreshUpgradeCheckInfo(self);
end

function BagData:UpdateItem(item,serverItem)
	local sItemData = serverItem.base
	item = item or self:GetItemByGuid(sItemData.guid)
	if(item ~=nil) then
		if(sItemData.index~=item.index) then
			self.wholeTab:SetDirty(true)
		end
		item:ParseFromServerData(serverItem)
		item.isactive = sItemData.isactive;
		if(item.isactive)then
			self.activeItemId = item.id;
		else
			if(self.activeItemId == item.id)then
				self.activeItemId = nil;
			end
		end
	end
end

function BagData:GetActiveItem()
	if(self.activeItemId)then
		local item = self:GetItemByGuid(self.activeItemId);
		if(not item)then
			self.activeItemId = nil;
		end
		return item;
	end
end

function BagData:Reset()
	self.wholeTab:Reset()
	for k,v in pairs(self.tabs) do
		v:Reset()
	end
end

function BagData:GetTab(tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			return tab
		end
	end
	return self.wholeTab
end

--tabtype 见gameconfig下的itempage和itemfashion
function BagData:GetItems(tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			return tab:GetItems()
		end
	end
	return self.wholeTab:GetItems()
end

function BagData:GetItemByGuid(guid)
	return self.wholeTab:GetItemByGuid(guid)
end

function BagData:SetUplimit(limit)
	if(type(limit) == "number")then
		self.uplimit = limit;
	end
end

function BagData:GetUplimit()
	return self.uplimit;
end

function BagData:GetSpaceItemNum()
	local items = self:GetItems();
	local result = 0;
	if(items)then
		result = math.max(0, self.uplimit - #items);
	end
	return result;
end

function BagData:IsFull()
	if(self.uplimit == 0)then
		return false;
	end
	return self:GetSpaceItemNum() <= 0;
end

function BagData:GetItemFreeSpaceByStaticId(itemid)
	local items = self.wholeTab:GetItemsByStaticID(itemid);
	local freeSpace = 0;

	local maxnum = 1;
	local itemData = Table_Item[itemid];
	local typeData = Table_ItemType[ itemData.Type ];
	maxnum = typeData and typeData.UseNumber
	if(maxnum == nil)then
		maxnum = Table_Item[itemid].MaxNum or 1;
	end
	if(items)then
		for _, item in pairs(items) do
			local itemnum = math.max(item.num, 1);
			if(maxnum > itemnum)then
				freeSpace = freeSpace + (maxnum - itemnum);
			end
		end
	end

	local spaceItemNum = self:GetSpaceItemNum();
	return freeSpace + maxnum * spaceItemNum;
end
-- return Prop