GainWayItemCellData = class("GainWayItemCellData")

GainWayItemCellType = {
	Normal = "GainWayItemCellType_Normal",
	Monster = "GainWayItemCellType_Monster",
}

GainWayItemCellData.TradeOrigin_ID = 1000;

function GainWayItemCellData:ctor(staticID)
	self.staticID = staticID;
end

function GainWayItemCellData:CheckOpenByAddWayData(addWayData)
	if(addWayData.menu)then
		return FunctionUnLockFunc.Me():CheckCanOpen(addWayData.menu)
	end
	return true
end

function GainWayItemCellData:ParseSingleNormalGainWay(addWayID)
	local d = Table_AddWay[addWayID]
	if(d)then
		self.itemID = self.staticID;
		self.addWayID = addWayID
		self.name = d.NameEn
		self.icon = d.Icon
		self.type = GainWayItemCellType.Normal;
		self.addWayType = d.Type

		self.desc = d.Desc
		local shortid = d.GotoMode and d.GotoMode[1];
		local shortData = shortid and Table_ShortcutPower[shortid];
		if(shortData and shortData.Event.npcid)then
			local npcData = Table_Npc[shortData.Event.npcid];
			if(npcData)then
				self.desc = string.format(self.desc, npcData.NameZh) or ''
				if(self.icon == "")then
					self.npcFace = npcData.Icon
				end
			end
		end

		self.isOpen = self:CheckOpenByAddWayData(d)
		self.dropProbability = 0
		self.level = 0

		return true;
	else
		errorLog("Not Find addWayID "..tostring(addWayID));
	end
	return false;
end

function GainWayItemCellData:ParseSingleMonsterGainWay(mOriData)
	local monsterId, dropProbability = mOriData[1], mOriData[2];
	local monsterData = Table_Monster[monsterId]
	if(monsterData and monsterData.Zone == "Field")then
		self:ParseByMonsterData(monsterData, dropProbability);
		return true;
	end
	return false;
end

function GainWayItemCellData:ParseByMonsterData(monsterData, dropProbability)
	self.itemID = self.staticID;
	self.type = GainWayItemCellType.Monster;		
	self.addWayID = 1
	self.addWayType = Table_AddWay[self.addWayID].Type;
	self.dropProbability = dropProbability

	self.isOpen = true;

	self.monsterID = monsterData.id
	self.name = monsterData.NameZh
	self.icon = monsterData.Icon
	self.monsterType = monsterData.Type
	self.level = monsterData.Level

	self.desc = "";
	local oriMaps = GainWayTipProxy.Instance:GetMonsterOrderOriMap(self.monsterID);
	if(oriMaps and #oriMaps>0)then
		-- 优先显示该魔物数量最多的前2个地图
		self.origins = {oriMaps[1], oriMaps[2]};
		for i=1,#self.origins do
			local single = self.origins[i] and self.origins[i][1];
			if(single.mapID)then
				local mapData = Table_Map[single.mapID]
				if(mapData and mapData.CallZh and mapData.CallZh~="")then
					self.desc = self.desc..mapData.CallZh..", "
				end
			end
		end
		if(self.desc~="")then
			self.desc = string.sub(self.desc, 1, -3);
		end
	end
end

function GainWayItemCellData:ParseGuildBossGainWay(mOriData)
	local monsterId, dropProbability = mOriData[1], mOriData[2];
	local monsterData = Table_Monster[monsterId]
	if(monsterData)then
		self:ParseByMonsterData(monsterData, dropProbability);
		self.desc = Table_AddWay[GainWayItemData.GuildBossOrigin_ID].Desc;
		return true;
	end
	return false;
end

function GainWayItemCellData:ParseFoodGainWay(foodOriData)
	local monsterId, dropProbability = foodOriData[1], foodOriData[2];
	local monsterData = Table_Monster[monsterId]
	if(monsterData)then
		self:ParseByMonsterData(monsterData, dropProbability);
		-- self.desc = Table_AddWay[GainWayItemData.FoodOrigin_ID].Desc;
		return true;
	end
end

function GainWayItemCellData:IsTradeOrigin()
	if(self.addWayID and self.addWayID == GainWayItemCellData.TradeOrigin_ID)then
		return true;
	end
	return false;
end
