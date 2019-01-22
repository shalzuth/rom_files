autoImport("EquipInfo")
autoImport("SuitInfo")
autoImport("AdventureAppendData")
AdventureItemData = class("AdventureItemData")

function AdventureItemData:ctor(serverData,type)
	--??????????????????id
	self.type = type	
	self.cardSlotNum = 0
	self.num = 0	
	self.tabData = nil
	self.staticId = serverData.id
	self:updateManualData(serverData)
	self:initStaticData(self.staticId,serverData)
end

function AdventureItemData:test(  )
	-- body
	if(#self.setAppendDatas>0)then
		self.status = SceneManual_pb.EMANUALSTATUS_UNLOCK_STEP
		for i=1,#self.setAppendDatas do
			local single = self.setAppendDatas [i]
			single.finish = true
			single.rewardget = false
		end
	end
end

function AdventureItemData:GetFoodSData(  )

end

function AdventureItemData:IsLimitUse(  )
	return false
end

function AdventureItemData:isCollectionGroup(  )
	if(self.type == nil)then
		return true
	end
end

function AdventureItemData:canBeClick(  )
	-- body
	local bRet = self.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT
	local cps = self:getCompleteNoRewardAppend()
	if(cps and #cps>0)then
		bRet = true
	end
	return bRet
end

function AdventureItemData:updateManualData( serverData )
	-- body	
	self.status = serverData.status
	self.attrUnlock = serverData.unlock
	self.store = serverData.store
	if(serverData.data_params and self.type == SceneManual_pb.EMANUALTYPE_SCENERY)then
		self:updateSceneData(serverData.data_params)
	end
	
	if(serverData.quests)then
		self:updateAppendData(serverData.quests)
	end

	local item = serverData.item
	if(item and self.equipInfo)then
		self.equipInfo:SetStrengthRefine(item.equip.strengthlv,item.equip.refinelv)
	end
end

function AdventureItemData:updateSceneData( params )
	-- body
	self.anglez = params[1] or 0
	self.anglez = tonumber(self.anglez)
	self.time = params[2] or 0
	self.time = tonumber(self.time)
	self.roleId = params[3]
	if not self.oldRoleId then
		self.oldRoleId = self.roleId
	end 
	if(self.roleId)then
		self.roleId = tonumber(self.roleId)
	end

	if(self.oldRoleId)then
		self.oldRoleId = tonumber(self.oldRoleId)
	end
	MySceneryPictureManager.Instance():log("updateSceneData:",self.staticId,tostring(self.roleId),tostring(self.time),self.anglez,self.oldRoleId)
end

function AdventureItemData:updateAppendData( appends )
	-- body
	self.setAppendDatas = self.setAppendDatas or {}
	-- printRed("updateAppendData",#appends)
	for i=1,#appends do
		local single = appends[i]
		-- printRed(single.rewardget)
		-- printRed(single.process)
		-- printRed(single.finish)
		local appData = self:getAppendDataById(single.id)
		if(appData)then
			appData:updateData(single)
		else
			appData = AdventureAppendData.new(single)
			table.insert(self.setAppendDatas,appData)
		end
	end	
	table.sort(self.setAppendDatas,function ( l,r )
		-- body
		return l.staticId < r.staticId
	end)
end

function AdventureItemData:GetFoodSData(  )

end

function AdventureItemData:getAppendDataById( appendId )
	-- body
	if(self.setAppendDatas)then
		for i=1,#self.setAppendDatas do
			local single = self.setAppendDatas[i]
			if(single.staticId == appendId)then
				return single
			end
		end
	end
end

function AdventureItemData:setIsSelected( isSelected )
	-- body
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
	end
end

function AdventureItemData:initStaticData(staticId,serverData)
	self.staticId = staticId
	if(self.type == SceneManual_pb.EMANUALTYPE_NPC)then
		self.staticData = Table_Npc[staticId]
	elseif(self.type == SceneManual_pb.EMANUALTYPE_MONSTER or self.type == SceneManual_pb.EMANUALTYPE_MATE or self.type == SceneManual_pb.EMANUALTYPE_PET)then
		self.staticData = Table_Monster[staticId]
		-- printRed("initStaticData:self.status",self.status,self.staticData.NameZh)
	elseif(self.type == SceneManual_pb.EMANUALTYPE_MAP)then
		self.staticData = Table_Map[staticId]
	elseif(self.type == SceneManual_pb.EMANUALTYPE_ACHIEVE)then
		self.staticData = Table_Achievement[staticId]
	elseif(self.type == SceneManual_pb.EMANUALTYPE_SCENERY)then
		self.staticData = Table_Viewspot[staticId]
		-- printRed("AdventureItemData:ResetData(staticId)")
		-- printRed(staticId)
	else
		self.staticData = Table_Item[staticId]		
		local equipData = Table_Equip[staticId]
		if(equipData~=nil) then
			self.equipInfo = EquipInfo.new(equipData)
			local item = serverData.item
			if(item)then
				-- helplog("item.equip.strengthlv",item.equip.strengthlv,item.equip.refinelv)
				self.equipInfo:SetStrengthRefine(item.equip.strengthlv,item.equip.refinelv)
			end
		else
			self.equipInfo = nil
		end	
		self.cardInfo = Table_Card[staticId]
		-- init suit
		if(self.equipInfo)then
			local suitId = self.equipInfo.equipData.SuitID;
			local suitSData = Table_EquipSuit[suitId];
			if(suitSData)then
				self.suitInfo = SuitInfo.new(suitId);
			end
		end
		self.monthCardInfo = Table_MonthCard[staticId]
	end
	if(self.staticData and self.staticData.AdventureValue and self.staticData.AdventureValue > 0)then
		self.AdventureValue =  self.staticData.AdventureValue
	else
		self.AdventureValue = 0
	end
	-- self.setAppendDatas = AdventureAppendData.getAppendData(self.type,self.staticId)
end

function AdventureItemData:CanEquip(  )
	return false
end

function AdventureItemData:getAdventureValue(  )
	-- body
	return self.AdventureValue
end

function AdventureItemData:GetName()
    -- todo xde start ?????????
    local result = ""
	if(self.staticData) then
		if(self.equipInfo and self.equipInfo.refinelv>0) then
			result = "+"..self.equipInfo.refinelv..self.staticData.NameZh
		elseif(self.type == SceneManual_pb.EMANUALTYPE_SCENERY)then
			result = self.staticData.SpotName
		else
			result = self.staticData.NameZh
		end
	end
	return OverSea.LangManager.Instance():GetLangByKey(result)
    -- todo xde end
end

function AdventureItemData:IsEquip()
	return self.equipInfo~=nil
end

function AdventureItemData:IsFashion()
	if(self.staticData and self.staticData.Type)then
		return BagProxy.fashionType[self.staticData.Type];
	end
end

function AdventureItemData:IsMount()
	return self.staticData.Type==90;
end

function AdventureItemData:IsNew()
	return self.isNew or false
end

function AdventureItemData:Clone()
	local item = ItemData.new(self.id,self.staticData and self.staticData.id or 0)
	if(item.equipInfo) then
		item.equipInfo:Clone(self.equipInfo)
	end
	return item
end

function AdventureItemData:getCompleteNoRewardAppend(  )
	-- body
	local list = {}
	if(self.setAppendDatas)then
		for i=1,#self.setAppendDatas do
			local single = self.setAppendDatas [i]
			-- printRed("single.finish",single.finish)
			if(single.finish and not single.rewardget)then
				table.insert(list,single)
			end
		end
	end
	return list
end

function AdventureItemData:getNoRewardAppend(  )
	-- body
	local list = {}
	if(self.setAppendDatas)then
		for i=1,#self.setAppendDatas do
			local single = self.setAppendDatas [i]
			if(not single.rewardget)then
				table.insert(list,single)
			end
		end
	end
	return list
end

function AdventureItemData:getAppendDatas(  )
	-- body
	return self.setAppendDatas
end

function AdventureItemData:getCatId(  )
	-- body
	return self.CatId
end

function AdventureItemData:setCatId( CatId )
	-- body
	self.CatId = CatId
end

function AdventureItemData:IsValid( )
	return AdventureItemData.CheckValid(self.staticData )
end

function AdventureItemData.CheckValid( staticData )
	if(not staticData )then
		return true
	end

	if(StringUtil.IsEmpty(staticData.ValidDate) and StringUtil.IsEmpty(staticData.TFValidDate))then
		return true
	end
	
	--todo xde ????????????tf
	local validDate = staticData.ValidDate

--	if(EnvChannel.IsReleaseBranch())then
--		validDate = staticData.ValidDate
--	elseif(EnvChannel.IsTFBranch())then
--		validDate = staticData.TFValidDate
--	end
	if(not StringUtil.IsEmpty(validDate) and ServerTime.CurServerTime())then
		local p ="(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
		local year,month,day,hour,min,sec = validDate:match(p)
		local startDate = os.time({day=day,month=month,year=year,hour=hour,min=min,sec=sec})
		local server = ServerTime.CurServerTime()/1000
		if(server<startDate)then
			return false
		end
	end
	return true
end

function AdventureItemData:setCollectionGroupId( groupId )
	-- body
	self.collectionGroupId = groupId
end

function AdventureItemData:getCollectionGroupId(  )
	-- body
	return self.collectionGroupId
end

function AdventureItemData:CompareTo(item)
	if(item) then
		-- print(string.format("%s?????????%s,vs,%s?????????%s",self.staticData.NameZh,self.battlepoint,item.staticData.NameZh,item.battlepoint))
		return self.battlepoint - item.battlepoint
	end
	return self.battlepoint
end
-- return Prop