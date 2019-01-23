AdventureBagData = class("AdventureBagData")
autoImport("AdventureTab")
autoImport("AdventureItemData")
autoImport("Table_AdventureValue")
function AdventureBagData:ctor(tabClass,type)
	self.tabs = {}
	self.itemMapTab = {}
	self.type = type
	self.tableData = Table_ItemTypeAdventureLog[self.type]
	self.totalScore = 0
	self.totalCount = 0
	self.curUnlockCount = 0
	self.allScore = 0
	self.allCount = 0
	self.wholeTab = AdventureTab.new()
	self.wholeTab:setBagTypeData(self.type)
	self:initTabDatas()	
end

function AdventureBagData:initTabDatas(  )
	-- body
	local categorys = AdventureDataProxy.Instance:getTabsByCategory(self.type)
	if(categorys and categorys.childs)then
		for k,v in pairs(categorys.childs) do
			local tabData = AdventureTab.new(v.staticData)
			self.tabs[k] = tabData
			for i=1,#v.types do
				self.itemMapTab[v.types[i]] = tabData
			end	
		end
	end

	if(self.type == SceneManual_pb.EMANUALTYPE_MONSTER)then
		-- self.allScore = Table_AdventureValue["monster"]
		self.allCount = Table_AdventureValue["monster"].monster.count
		self.allCount = self.allCount + Table_AdventureValue["monster"].mvp.count
		self.allCount = self.allCount + Table_AdventureValue["monster"].mini.count
	elseif(self.type == SceneManual_pb.EMANUALTYPE_PET)then
		-- self.allCount = Table_AdventureValue["monster"].petnpc.count
	elseif(self.type == SceneManual_pb.EMANUALTYPE_MAP)then
		-- self.allScore = Table_AdventureValue["map"]
		self.allCount = Table_AdventureValue["map"]
	elseif(self.type == SceneManual_pb.EMANUALTYPE_NPC)then
		-- self.allScore = Table_AdventureValue["NPC"]
		self.allCount = AdventureDataProxy.Instance.NpcCount
	elseif(self.type == SceneManual_pb.EMANUALTYPE_FASHION)then		
		self.allCount = Table_AdventureValue["item"].fashionClothes.count
	elseif(self.type == SceneManual_pb.EMANUALTYPE_MOUNT)then
		-- self.allScore = Table_AdventureValue["item"][2]
		self.allCount = Table_AdventureValue["item"].ride.count
	elseif(self.type == SceneManual_pb.EMANUALTYPE_CARD)then
		self.allCount = Table_AdventureValue["item"].card.count
		-- self.allScore = Table_AdventureValue["item"][3]
	elseif(self.type == SceneManual_pb.EMANUALTYPE_SCENERY)then
		self.allCount = Table_AdventureValue["viewSpot"].count
	elseif(self.type == SceneManual_pb.EMANUALTYPE_COLLECTION)then
		self.allCount = Table_AdventureValue["monthlyVIP"].count
	end
end

--items数据，tabtype标签
function AdventureBagData:AddItems(items,tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			tab:AddItems(items)
		end
	end
	self.wholeTab:AddItems(items)
end

function AdventureBagData:getTabByItemAndType( item,type )
	-- body
	if(item == nil or not item.staticData)then
		return
	end
	local tab
	if(type == SceneManual_pb.EMANUALTYPE_NPC)then
		tab = self.itemMapTab[GameConfig.AdventureCategoryMonsterType.NPC]
		-- print("npc:"..GameConfig.AdventureCategoryMonsterType.NPC)
	elseif(type == SceneManual_pb.EMANUALTYPE_MONSTER or type == SceneManual_pb.EMANUALTYPE_PET)then
		tab = self.itemMapTab[GameConfig.AdventureCategoryMonsterType[item.staticData.Type]]
		-- print("monster:"..item.staticData.Type,GameConfig.AdventureCategoryMonsterType[item.staticData.Type])
	elseif(type == SceneManual_pb.EMANUALTYPE_ACHIEVE)then
		
	elseif(type == SceneManual_pb.EMANUALTYPE_MAP)then
	elseif(type == SceneManual_pb.EMANUALTYPE_MATE)then
		tab = self.itemMapTab[GameConfig.AdventureCategoryMonsterType.MercenaryCat]
	elseif(type == SceneManual_pb.EMANUALTYPE_SCENERY)then
		local mapData = Table_Map[item.staticData.MapName]
		if(mapData)then
			tab = self.itemMapTab[mapData.Range]
		end
	else
	 	tab = self.itemMapTab[item.staticData.Type]	 	
	 	-- print(tab)
	 	-- print(item.staticId)
	 	-- print(type)
	 	-- print("item:"..item.staticData.Type)
	end
	if(not tab)then
		-- printRed("tab is nil id:")
	 -- 	print(item.staticId)
	 -- 	print(type)
	 -- 	print("item type:")
	 -- 	print(item.staticData.Type)
	end
	return tab
end


function AdventureBagData:AddItem(item,type)
	local tab = self:getTabByItemAndType(item,type)
	if(tab ~=nil) then
		tab:AddItem(item)
		item.tabData = tab.tab
		tab.totalCount = tab.totalCount + 1
	end
	self.wholeTab:AddItem(item)
	if(type == SceneManual_pb.EMANUALTYPE_MAP)then
		AdventureDataProxy.Instance:NewMapAdd(item.staticId)
	end
	if(item.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and item.status ~=SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
		self.totalScore = self.totalScore + item.AdventureValue
		self.curUnlockCount = self.curUnlockCount + 1
		if(tab ~=nil) then
			tab.curUnlockCount = tab.curUnlockCount + 1
			tab.totalScore = tab.totalScore + item.AdventureValue
		end
	end				
	self.totalCount = self.totalCount+1
end

function AdventureBagData:UpdateItems(manualData,type)	
	local serverItems = manualData.items
	-- printRed("UpdateItems:")
	-- printRed(#serverItems)
	-- print(type)
	local updateSceneIds = {}
	for i=1,#serverItems do
		local sItem = serverItems[i]
		-- print(sItem)
		local item = self:GetItemByStaticID(sItem.id)
		if(item ~=nil) then
			local oldStatus = item.status	
			self:UpdateItem(item,sItem)
			local tab = self:getTabByItemAndType(item,type)
			if(tab)then
				tab:SetDirty()
			end
			if(oldStatus == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT and item.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT )then				
				self.totalScore = self.totalScore + item.AdventureValue
				self.curUnlockCount = self.curUnlockCount + 1
				if(tab)then
					tab.curUnlockCount = tab.curUnlockCount + 1
					tab.totalScore = tab.totalScore + item.AdventureValue
				end
			end

			if(type == SceneManual_pb.EMANUALTYPE_SCENERY)then
				if(oldStatus == SceneManual_pb.EMANUALSTATUS_DISPLAY and 
					item.staticData.Type == 1 and 
					(item.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY))then
					table.insert(updateSceneIds,item.staticId)
				end
			end

		else
			item = AdventureItemData.new(sItem,type)
			self:UpdateItem(item,sItem)
			if(item.staticData ~=nil) then
				self:AddItem(item,type)				
			else
				-- self.wholeTab:ResetPlaceHolder(sItemData)
			end
		end		 
	end	

	if(#updateSceneIds > 0)then
		GameFacade.Instance:sendNotification(AdventureDataEvent.SceneItemsUpdate, updateSceneIds)
	end
end

function AdventureBagData:UpdateItem(item,serverItem)
	item = item or self:GetItemByStaticID(serverItem.id)
	if(item ~=nil) then
		item:updateManualData(serverItem)
		self.wholeTab:SetDirty(true)
	end
end

function AdventureBagData:Reset()
	self.wholeTab:Reset()
	for k,v in pairs(self.tabs) do
		v:Reset()
	end
end

function AdventureBagData:GetTab(tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			return tab
		end
	end
	return self.wholeTab
end

--tabtype 见gameconfig下的itempage和itemfashion
function AdventureBagData:GetItems(tabType)
	if(tabType ~=nil) then
		local tab = self.tabs[tabType]
		if(tab ~=nil) then
			return tab:GetItems()
		end
	end
	return self.wholeTab:GetItems()
end

function AdventureBagData:GetItemByStaticID(id)
	return self.wholeTab:GetItemByStaticID(id)
end

function AdventureBagData:GetUnlockNum()
	local items = self:GetItems()
	local count = 0
	if(items and #items>0)then
		for i=1,#items do
			local item = items[i]
			if(item.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and item.status ~=SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
				count = count +1
			end
		end
	end
	return count
end

-- return Prop