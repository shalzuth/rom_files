AdventureAchieveBagData = class("AdventureAchieveBagData")
autoImport("AdventureAchieveTab")
autoImport("AdventureAchieveData")
function AdventureAchieveBagData:ctor(tabClass,type)
	self.tabs = {}
	self.itemMapTab = {}
	self.type = type
	self.tableData = Table_Achievement[self.type]
	self.wholeTab = AdventureAchieveTab.new()
	self.wholeTab:setBagTypeData(self.type)
	self:initTabDatas()	
end

function AdventureAchieveBagData:initTabDatas(  )
	-- body
	local categorys = AdventureAchieveProxy.Instance:getTabsByCategory(self.type)
	if(categorys and categorys.childs)then
		for k,v in pairs(categorys.childs) do
			local tabData = AdventureAchieveTab.new(v.staticData)
			self.tabs[k] = tabData
			for i=1,#v.types do
				self.itemMapTab[v.types[i].id] = tabData
			end	
		end
	end
end

function AdventureAchieveBagData:getTabByItemAndType( item )
	-- body
	return self.itemMapTab[item.staticData.id]
end

function AdventureAchieveBagData:AddItems(items,tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			tab:AddItems(items)
		end
	end
	self.wholeTab:AddItems(items)
end

function AdventureAchieveBagData:AddItem(item)
	local tab = self:getTabByItemAndType(item)
	if(tab ~=nil) then
		tab:AddItem(item)
		item.tabData = tab.tab
	end
	self.wholeTab:AddItem(item)
end

function AdventureAchieveBagData:UpdateItems(manualData)
	local serverItems = manualData.items
	for i=1,#serverItems do
		local sItem = serverItems[i]
		-- print(sItem)
		local item = self:GetItemByStaticID(sItem.id)
		-- helplog("UpdateItems",sItem.id,sItem.process,sItem.finishtime)
		-- helplog("UpdateItems",#sItem.params)

		if(item ~=nil) then
			self:UpdateItem(item,sItem)
			local tab = self:getTabByItemAndType(item)
			if(tab)then
				tab:SetDirty()
			end
		else
			item = AdventureAchieveData.new(sItem)
			if(item.staticData)then
				self:UpdateItem(item,sItem)
				if(item.staticData ~= nil) then
					local tab = self:getTabByItemAndType(item)
					self:AddItem(item)				
				end
			end
		end		 
	end	
end

function AdventureAchieveBagData:UpdateItem(item,serverItem)
	item = item or self:GetItemByStaticID(serverItem.id)
	if(item ~=nil) then
		item:updateServerData(serverItem)
		local tab = self:getTabByItemAndType(item)
		if(tab ~=nil) then
			tab:SetDirty(true)
		end
		self.wholeTab:SetDirty(true)
	end
end

function AdventureAchieveBagData:GetTab(tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			return tab
		end
	end
	return self.wholeTab
end

--tabtype 见gameconfig下的itempage和itemfashion
function AdventureAchieveBagData:GetItems(tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			return tab:GetItems()
		end
	end
	return self.wholeTab:GetItems()
end

function AdventureAchieveBagData:GetItemByStaticID(id)
	return self.wholeTab:GetItemByStaticID(id)
end
