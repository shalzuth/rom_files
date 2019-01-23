autoImport("ItemData")

AdventureTab = class("AdventureTab")

function AdventureTab:ctor(tab)
	self:Reset()
	self.tab = tab
	self.dirty = false
	self.totalScore = 0
	self.totalCount = 0
	self.curUnlockCount = 0
	if(self.tab)then
		self:setBagTypeData(tab.type)
	end
end

function AdventureTab:setBagTypeData( type )
	-- body
	self.bagTypeData = Table_ItemTypeAdventureLog[type]
end

function AdventureTab:SetDirty(val)
	-- val = val or true
	self.dirty = val or true
end

function AdventureTab:AddItems(items)
	if(items ~=nil) then
		for i=1,#items do
			self:AddItem(items[i])
		end
	end
end

function AdventureTab:AddItem(item)
	if(item ~=nil) then
		self.itemsMap[item.staticId] = item
		self.dirty = true
		-- table.insert(self.items,item)
		self.items[#self.items+1] = item
		-- print("index:"..item.staticId)
		-- print(#self.items)
	end
end

function AdventureTab:RemoveItems(itemIds)
	-- body
end

function AdventureTab:GetItems()
	-- if(self.dirty==true) then
		self.parsedItems = {}
		for i=1,#self.items do
			local single = self.items[i]
			if(single:IsValid())then
				self.parsedItems[#self.parsedItems+1] = single
			end
		end
		table.sort(self.parsedItems,function(l,r)
			return self:sortFunc(l,r)
		end)
	-- 	self.dirty = false
	-- end
	return self.parsedItems
end

function AdventureTab:sortFunc(left,right)
	-- if(left.status == right.status)then	
		-- if(self.tab == nil)then -- 所有排序			
		-- 	local lTabData = left.tabData
		-- 	local rTabData = right.tabData
		-- 	if(lTabData and rTabData)then
		-- 		local lTabOrder = left.tabData.Order
		-- 		local rTabOrder = right.tabData.Order
		-- 		if(lTabOrder == rTabOrder)then					
		-- 			local lQuality = left.staticData.Quality
		-- 			local rQuality = right.staticData.Quality
		-- 			if(lQuality)then
		-- 				if(lQuality == rQuality)then
		-- 					return left.staticId < right.staticId
		-- 				else
		-- 					return lQuality > rQuality
		-- 				end
		-- 			else
		-- 				return left.staticId < right.staticId
		-- 			end
		-- 		else
		-- 			return lTabOrder < rTabOrder
		-- 		end
		-- 	else
		-- 		-- printRed("tabdatais nil ")
		-- 		return false
		-- 	end
		-- else --tab 内部排序
		-- 	local lQuality = left.staticData.Quality
		-- 	local rQuality = right.staticData.Quality
		-- 	if(lQuality)then
		-- 		if(lQuality == rQuality)then
		-- 			return left.staticId < right.staticId
		-- 		else
		-- 			return lQuality > rQuality
		-- 		end
		-- 	else
		-- 		return left.staticId < right.staticId
		-- 	end
		-- end
	-- else
	-- 	return left.status > right.status
	-- end
	local lAdSort = left.staticData.AdventureSort
	local rAdSort = right.staticData.AdventureSort
	if(lAdSort == rAdSort)then
		return left.staticId < right.staticId
	else
		if(lAdSort == nil)then
			return false
		elseif rAdSort == nil then
			return true
		else
			return lAdSort < rAdSort
		end
	end
end

function AdventureTab:GetItemByStaticID(staticID)
	for _, o in pairs(self.items) do
        if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
            return o
        end
    end
    return nil
end

function AdventureTab:GetItemNumByStaticID(staticID)
	local num = 0
	for _, o in pairs(self.items) do
        if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
        	num = num + o.num
            -- return o
        end
    end
    return num
end

function AdventureTab:GetItemNumByStaticIDs(staticIDs)
	local numMap = {}
	for i=1,#staticIDs do
		numMap[staticIDs[i]] = 0
	end
	local num
	for _, o in pairs(self.items) do
        if o.staticData ~= nil and o:IsValid() then
	        num = numMap[o.staticData.id]
	        if(num~=nil) then
	        	num = num + o.num
	        	numMap[o.staticData.id] = num
	        end
        end
    end
    return numMap
end

function AdventureTab:GetItemsByType(typeID,sortFunc)
	local res = {}
	for _, o in pairs(self.items) do
        if o.staticData ~= nil and o.staticData.Type == typeID and o:IsValid() then
            res[#res+1] = o
        end
    end
    if(sortFunc~=nil) then
    	table.sort(res,function(l,r)
			return sortFunc(self,l,r)
		end)
    end
    return res
end

function AdventureTab:Reset()
	self.items = {}
	self.itemsMap = {}
	self.parsedItems = {}
end
-- return Prop