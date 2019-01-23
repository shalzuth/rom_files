autoImport("ItemData")

AdventureAchieveTab = class("AdventureAchieveTab")

function AdventureAchieveTab:ctor(tab)
	self:Reset()
	self.tab = tab
	self.dirty = false
	self.itemsMap = {}
	if(self.tab)then
		self:setBagTypeData(tab.SubGroup)
		-- helplog("AdventureAchieveTab:redtip",tab.RedTip,tab.id,tab.Name)
	end
end

function AdventureAchieveTab:setBagTypeData( type )
	-- body
	self.bagTypeData = Table_ItemTypeAdventureLog[type]
end

function AdventureAchieveTab:SetDirty(val)
	-- val = val or true
	self.dirty = val or true
end

function AdventureAchieveTab:AddItems(items)
	if(items ~=nil) then
		for i=1,#items do
			self:AddItem(items[i])
		end
	end
end

function AdventureAchieveTab:AddItem(item)
	if(item ~=nil) then
		self.itemsMap[item.id] = item
		self.dirty = true
		-- table.insert(self.items,item)
		self.items[#self.items+1] = item
		-- print("index:"..item.staticId)
		-- print(#self.items)
	end
end

function AdventureAchieveTab:RemoveItems(itemIds)
	-- body
end

function AdventureAchieveTab:GetItems()
	if(self.dirty==true) then
		self.parsedItems = {}
		local tempItems = {unpack(self.items)}
		for i=1,#tempItems do
			local single = tempItems[i]
			if(single.staticData.Visibility ~= 1 or single:getCompleteString())then
				self.parsedItems[#self.parsedItems +1] = single
			end
		end
		-- table.sort(self.items,self.sortFunc)
		-- printRed("table soft")
		table.sort(self.parsedItems,function(l,r)
			return self:sortFunc(l,r)
		end)
		self.dirty = false
	end
	return self.parsedItems
end

function AdventureAchieveTab:sortFunc(left,right)
	local lAdSort = left.staticData.AdventureSort
	local rAdSort = right.staticData.AdventureSort
	if(left:canGetReward() == right:canGetReward())then
		-- if(left:getCompleteString() == right:getCompleteString())then
			if(lAdSort == rAdSort)then
				return left.id < right.id
			else
				if(lAdSort == nil)then
					return false
				elseif rAdSort == nil then
					return true
				else
					return lAdSort < rAdSort
				end
			end
		-- else
		-- 	if(left:getCompleteString() == nil)then
		-- 		helplog("left:getCompleteString()",tostring(left:getCompleteString()))
		-- 		return false
		-- 	elseif(left:getCompleteString() ~= nil and right:getCompleteString()~=nil)then
		-- 		return left.finishtime > right.finishtime
		-- 	else
		-- 		return true
		-- 	end
		-- end
	else
		-- helplog("left:canGetReward()",tostring(left:canGetReward()))
		return left:canGetReward()
	end	
end

function AdventureAchieveTab:GetItemByStaticID(staticID)
	for _, o in pairs(self.items) do
        if o.staticData ~= nil and o.staticData.id == staticID then
            return o
        end
    end
    return nil
end

function AdventureAchieveTab:GetItemNumByStaticID(staticID)
	local num = 0
	for _, o in pairs(self.items) do
        if o.staticData ~= nil and o.staticData.id == staticID then
        	num = num + o.num
            -- return o
        end
    end
    return num
end

function AdventureAchieveTab:GetItemNumByStaticIDs(staticIDs)
	local numMap = {}
	for i=1,#staticIDs do
		numMap[staticIDs[i]] = 0
	end
	local num
	for _, o in pairs(self.items) do
        if o.staticData ~= nil then
	        num = numMap[o.staticData.id]
	        if(num~=nil) then
	        	num = num + o.num
	        	numMap[o.staticData.id] = num
	        end
        end
    end
    return numMap
end

function AdventureAchieveTab:GetItemsByType(typeID,sortFunc)
	local res = {}
	for _, o in pairs(self.items) do
        if o.staticData ~= nil and o.staticData.Type == typeID then
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

function AdventureAchieveTab:Reset()
	self.items = {}
	self.itemsMap = {}
	self.parsedItems = {}
end