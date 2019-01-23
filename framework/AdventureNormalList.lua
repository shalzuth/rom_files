autoImport("ItemNormalList")
AdventureNormalList = class("AdventureNormalList", ItemNormalList);
autoImport("WrapCellHelper")
autoImport("BagCombineItemCell");
autoImport("PhotographResultPanel")

AdventureNormalList.UpdateCellRedTip = "AdventureNormalList_UpdateCellRedTip"

function AdventureNormalList:ctor(go,tipHolder, control,isAddMouseClickEvent)
	if(go)then
		self.gameObject = go
		self.control = control or BagCombineItemCell;
		self.tipHolder = tipHolder
		if(isAddMouseClickEvent==true or isAddMouseClickEvent==nil)then
			self.isAddMouseClickEvent=true
		else
			self.isAddMouseClickEvent=false
		end
		self.ItemTabLst={}
		self.NewTagLst={}
		self:Init();
		self.itemDatas = nil
	else
		error("can not find itemListObj");
	end
	self.selectData = nil
end

function AdventureNormalList:ShowItemTip( data )
	-- body
	self:removeTip()
	if(not data)then
		return;
	end
	self:Show(self.normalListSp)
	if(data.type == SceneManual_pb.EMANUALTYPE_NPC)then
		self.tip = self:ShowNpcScoreTip(self.tipHolder,data)
	elseif(data.type == SceneManual_pb.EMANUALTYPE_PET)then
		self.tip = self:ShowPetScoreTip(self.tipHolder,data)
	elseif(data.type == SceneManual_pb.EMANUALTYPE_MONSTER)then
		self.tip = self:ShowMonsterScoreTip(self.tipHolder,data)
	elseif(data.type == SceneManual_pb.EMANUALTYPE_COLLECTION)then
		if(data.tabData.id == AdventureDataProxy.MonthCardTabId)then
			self.tip = self:ShowMonthScoreTip(self.tipHolder,data)
		-- elseif(data.__cname == "AdventureCollectionGroupData")then
		else
			self.tip = self:ShowCollectScoreTip(self.tipHolder,data)
		end
	elseif(data:isCollectionGroup())then
		self:Hide(self.normalListSp)
		self.tip = self:ShowCollectGroupScoreTip(self.tipHolder,data)
	else
		self.tip = self:ShowItemScoreTip(self.tipHolder,data)
	end
end

function AdventureNormalList:CheckCanReUseTip(data)
	if(not self.tip)then
		return 
	end
	local tipData = self.tip.data
	if(tipData.type == data.type)then
		if(not data:isCollectionGroup())then
			if(data.tabData.id ~= tipData.tabData.id)then
				return false
			end
		end
		return true
	end

end

function AdventureNormalList:ShowPetScoreTip(container, itemdata)
	local scoreTip = PetScoreTip.new(container);
	scoreTip:SetData(itemdata);
	return scoreTip;
end

function AdventureNormalList:ShowItemScoreTip(container, itemdata)
	local scoreTip = ItemScoreTip.new(container);
	scoreTip:SetData(itemdata);
	return scoreTip;
end

function AdventureNormalList:ShowMonthScoreTip(container, itemdata)
	local scoreTip = MonthScoreTip.new(container);
	scoreTip:SetData(itemdata);
	return scoreTip;
end

function AdventureNormalList:ShowCollectGroupScoreTip(container, itemdata)
	local scoreTip = CollectGroupScoreTip.new(container);
	scoreTip:SetData(itemdata);
	return scoreTip;
end

function AdventureNormalList:ShowCollectScoreTip(container, itemdata)
	local scoreTip = CollectScoreTip.new(container);
	scoreTip:SetData(itemdata);
	return scoreTip;
end

function AdventureNormalList:ShowMonsterScoreTip(container, monsterdata)
	local scoreTip = MonsterScoreTip.new(container);
	scoreTip:SetData(monsterdata);
	return scoreTip;
end

function AdventureNormalList:ShowNpcScoreTip(container, npcdata)
	local scoreTip = NpcScoreTip.new(container);
	scoreTip:SetData(npcdata);
	return scoreTip;
end

function AdventureNormalList:Init()

	local itemContainer = self:FindGO("bag_itemContainer");
	local control = self.control;
	local pfbNum = 6
	-- printRed(self.gameObject.name)
	-- local comContentPanel = self.gameObject:GetComponent(UIPanel)
	local rt = Screen.height/Screen.width
	if(rt > 0.5625)then
		pfbNum = 10
	end

	local wrapConfig = {
		wrapObj = itemContainer,
		pfbNum = pfbNum,
		cellName = "AdventureBagCombineItemCell",
		control = control,
		dir = 1,
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	if(self.isAddMouseClickEvent)then
		self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);
		self.wraplist:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self);
	end

	self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView);
	self.scrollView.OnStop = function ()
		self:ScrollViewRevert();
	end
	self.normalListSp = self:FindGO("normalListSp")
end

-- function AdventureNormalList:HandleClickItemTmp(cellCtl  )
-- 	-- body
-- 	self:HandleClickItem(cellCtl)
-- end

function AdventureNormalList:updateCellTip(cellCtl)
	self:PassEvent(AdventureNormalList.UpdateCellRedTip,cellCtl)
end

function AdventureNormalList:UpdateList(noResetPos)
	local datas = self:GetTabDatas();
	self:SetData(datas, noResetPos);
end

function AdventureNormalList:getDefaultSelectedItemData(  )
	-- body	
	local cells = self:GetItemCells() or {}
	if(#cells >0)then
		if(self.chooseItemData)then
			for i=1,#cells do
				local single = cells[i]
				if(single.data)then
					local awardList = single.data:getCompleteNoRewardAppend()
					local bRel = single.data.type == self.chooseItemData.type and single.data.staticId == self.chooseItemData.staticId
					-- bRel = bRel and single.data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT and #awardList < 1
					bRel = bRel and single.data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT
					if(bRel)then
						return single
					end
				end
			end	
		else
			for i=1,#cells do
				local cell = cells[i]
				if(cell.data)then
					local awardList = cell.data:getCompleteNoRewardAppend()
					if(cell.data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT and #awardList < 1)then
						return cell
					end
				end
			end
		end
	end
end

function AdventureNormalList:removeTip(  )
	-- body
	if(self.tipHolder.transform.childCount >0)then
		local tip = self.tipHolder.transform:GetChild(0)
		if(tip and self.tip)then
			self.tip:OnExit()
		end
	end
	self.tip = nil
end

function AdventureNormalList:checkUnlockData(  )
	-- body
	if(self.toBeUnlock)then
		local lockType = self.toBeUnlock.type
		local lockId = self.toBeUnlock.staticId
		local cells = self:GetItemCells()
		if(cells)then
			for i=1,#cells do
				local single = cells[i]
				if(single.data)then
					local singleId = single.data.staticId
					local singleType = single.data.type 
					local singleSt = single.data.status
					-- local canClick = single.data:canBeClick()
					if(lockType == singleType and singleId == lockId)then
						single:PlayUnlockEffect()
						self:HandleClickItem(single, true)
						self.toBeUnlock = nil
						return true		
					end
				end
			end			
		end		
	end
end

function AdventureNormalList:resetSelectState( datas,noResetPos )
	-- body
	if(not noResetPos)then
		self.wraplist:ResetPosition();
		if(self.chooseItem and self.chooseItemData)then			
			self.chooseItemData:setIsSelected(false)
			self.chooseItem:setIsSelected(false)
		end	
		self:ClearSelectData()
	end
	-- local cells = self:GetItemCells()
	-- if(cells)then
	-- 	for i=1,#cells do
	-- 		local single = cells[i]
	-- 		single:setIsSelected(false)
	-- 	end			
	-- end

	-- for i=1,#datas do
	-- 	local single = datas[i]
	-- 	single:setIsSelected(false)
	-- end
end

function AdventureNormalList:SetPropData(propData,keys)
	self.propData = propData
	self.keys = keys
end

function AdventureNormalList:SetData(datas, noResetPos)
	-- printRed("AdventureNormalList:SetData(datas, noResetPos)",noResetPos)
	self.itemDatas = datas or {}
	self:resetSelectState(self.itemDatas,noResetPos)
	local newdata = self:ReUnitData(self.itemDatas, 5);
	-- self:Log("AdventureNormalList:", newdata);
	self.wraplist:UpdateInfo(newdata);
	local defaultItem = self:getDefaultSelectedItemData()
	-- printRed("chooseItem:",self.chooseItemData and self.chooseItemData:GetName() or "nil")
	-- printRed("defaultItem:",defaultItem and defaultItem.data:GetName() or "nil")
	-- self.chooseItem = nil
	-- self.chooseItemData = nil
	self.selectData = nil
	-- self:SetChooseSymbol();	
	local handleSelect = self:checkUnlockData()
	if(not handleSelect)then
		self:HandleClickItem(defaultItem,true)
	end
	if(not noResetPos)then
		self.wraplist:ResetPosition();
	end
end

function AdventureNormalList:HandleClickItem(cellCtl,noClickSound)
	if(cellCtl and cellCtl.data)then
		local data = cellCtl.data
		if(not noClickSound)then
			if(data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
				ServiceSceneManualProxy.Instance:CallUnlock(data.type,data.staticId)
				self:PlayUISound(AudioMap.UI.maoxianshoucedianjijiesuo)
				self.toBeUnlock = data
				return
			elseif(data:canBeClick())then
				local appendData = data:getCompleteNoRewardAppend()
				-- printRed("appendData:",appendData and #appendData or "empty")
				appendData = appendData[1]
				self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AdventureAppendRewardPanel,viewdata = appendData})
				self.toBeUnlock = data
				return
			end				
		end
		if(self.chooseItem ~= cellCtl) or (data ~= self.chooseItemData ) or noClickSound then
			if(self.chooseItemData)then
				self.chooseItemData:setIsSelected(false)
			end

			if(self.chooseItem)then
				self.chooseItem:setIsSelected(false)
			end
			if(not noClickSound)then
				self:PlayUISound(AudioMap.UI.Click)
			end
			data:setIsSelected(true)
			cellCtl:setIsSelected(true)
			if(self:CheckCanReUseTip(data))then
				self.tip:SetData(data)
				if(self.tip.scrollView)then
					self.tip.scrollView:ResetPosition()
				end
			else
				self:ShowItemTip(data);
				if(self.tip and self.tip.scrollView)then
					self.tip.scrollView:ResetPosition()
				end
			end
			-- tip:AddIgnoreBounds(cellCtl.gameObject);
			self.chooseItem = cellCtl;
			self.chooseItemData=data
			-- TableUtil.Print(self.chooseItemData)
			-- TableUtil.Print(self.chooseItem)
			-- self:ShowItemTip();
		end
	end

	if(not cellCtl and self.chooseItemData)then
		local exsit = self:checkItemDataValid(self.chooseItemData)
		if(exsit)then
			if(noClickSound and self.tip)then
				self.tip:SetData(self.chooseItemData)
			else
				self:ShowItemTip(self.chooseItemData);
			end
		end
	end
end

function AdventureNormalList:checkItemDataValid(itemData)
	for i=1,#self.itemDatas do
		if(itemData.staticId == self.itemDatas[i].staticId)then
			return true
		end
	end
end

function AdventureNormalList:setCategoryAndTab(category,tab)
	self.category = category
	self.tab = tab
end

function AdventureNormalList:OnExit()
	-- body
	self:ClearSelectData()
	self:removeTip()
	self.itemDatas = nil
end

function AdventureNormalList:OnEnter()
	-- body
	-- self:ClearSelectData()
end

function AdventureNormalList:ClearSelectData( )
	-- body
	if(self.chooseItemData)then
		self.chooseItemData:setIsSelected(false)
	end

	if(self.chooseItem)then
		self.chooseItem:setIsSelected(false)
	end
	self.chooseItem = nil
	self.chooseItemData=nil
end

function AdventureNormalList:GetTabDatas()
	if(self.category)then
		-- print(self.category,self.tab)
		local type = self.category.staticData.id
		local tab = self.tab and self.tab.id or nil
		local bag = AdventureDataProxy.Instance.bagMap[type]
		if(bag)then
			-- helplog("tab:",tab)
			local items = bag:GetItems(tab)
			if(type == SceneManual_pb.EMANUALTYPE_COLLECTION)then
				local list = {}
				for i=1,#items do
					local single = items[i]
					if(not single:getCollectionGroupId())then
						list[#list+1] = single
					end
				end

				if(tab ~= 1052)then
					if(self.propData)then
						TableUtility.ArrayClear(list)
					end
					local groups = AdventureDataProxy.Instance:GetAllUnlockCollectionGroups()
					for i=1,#groups do
						list[#list+1] = groups[i]
					end
					list = AdventureDataProxy.Instance:getItemsByFilterData(type,list,self.propData,self.keys)
				elseif(self.propData)then
					TableUtility.ArrayClear(list)
				end
				return list
			end			
			items = AdventureDataProxy.Instance:getItemsByFilterData(type,items,self.propData,self.keys)
			return items
		end
	else
		printRed("category is nil")
	end
end