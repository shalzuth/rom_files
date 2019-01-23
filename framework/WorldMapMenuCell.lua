local BaseCell = autoImport("BaseCell");
WorldMapMenuCell = class("WorldMapMenuCell", BaseCell)

autoImport("MapInfoCell");
autoImport("MonsterHeadCell");

WorldMapMenuEvent = {
	StartTrace = "WorldMapMenuEvent_StartTrace",
}

local tempArray = {};

function WorldMapMenuCell:Init()
	self:InitCell();
end

function WorldMapMenuCell:InitCell()
	self.mapname = self:FindComponent("MapName", UILabel);
	self.lvname = self:FindComponent("LvName", UILabel);
	self.table = self:FindComponent("Table", UITable);

	local infoGrid = self:FindComponent("InfoGrid", UIGrid);
	self.infoCtl = UIGridListCtrl.new(infoGrid, MapInfoCell, "MapInfoCell");
	self.infoCtl:AddEventListener(MouseEvent.MouseClick, self.clickMapInfo, self);

	local monsterGrid = self:FindComponent("MonsterGrid", UIGrid);
	self.monsterCtl = UIGridListCtrl.new(monsterGrid, MonsterHeadCell, "MonsterHeadCell");
	self.monsterCtl:AddEventListener(MouseEvent.MouseClick, self.clickMonsterCell, self);

	self.questSymbolGrid = self:FindComponent("QuestGrid", UIGrid);
	self.questSymbol1 = self:FindGO("Symbol1", self.questSymbolGrid.gameObject);
	self.questSymbol2 = self:FindGO("Symbol2", self.questSymbolGrid.gameObject);
	self.questSymbol3 = self:FindGO("Symbol3", self.questSymbolGrid.gameObject);

	self.sealSymbol = self:FindComponent("SealSymbol", UISprite);

	self.questSymbol = self:FindGO("QuestSymbol");
	self.goBtn = self:FindGO("GoBtn");
	self:AddClickEvent(self.goBtn, function(go)
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
end

function WorldMapMenuCell:clickMapInfo(mapInfo)
	local data = mapInfo.data;
	if(not data)then
		return;
	end

	local cmd;
	if(data.type == MapInfoType.Npc)then
		local cmdArgs = {
			targetMapID = self.data.id,
			npcID = data.id,
			npcUID = data.uid,
		}
		cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandVisitNpc)	
	elseif(data.type == MapInfoType.ExitPoint)then
		local cmdArgs = {
			targetMapID = data.id,
		}
		cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)	
	end
	if(cmd)then
		Game.Myself:Client_SetMissionCommand( cmd );
		self:PassEvent(WorldMapMenuEvent.StartTrace);
	end
end

function WorldMapMenuCell:clickMonsterCell(monsterCell)
	local data = monsterCell.data;
	if(data)then
		helplog("ClickMonsterCell:", tostring(data.id), Table_Monster[data.id] and  Table_Monster[data.id].NameZh);
		local oriMonster = Table_MonsterOrigin[ data.id ] or {};
		local oriPos = nil;
		for i=1,#oriMonster do
			if(oriMonster[i].mapID == self.data.id)then
				oriPos = oriMonster[i].pos;
			end
		end
		if(oriPos)then
			local cmdArgs = {
				targetMapID = self.data.id,
				npcID = data.id,
				targetPos = TableUtil.Array2Vector3(oriPos),
			}
			local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)	
			if(cmd)then
				Game.Myself:Client_SetMissionCommand( cmd );
				self:PassEvent(WorldMapMenuEvent.StartTrace);
			end
		else
			errorLog(string.format("Monster:%s Not Find In MonsterOriginal", data.id));
		end
		
	end
end

function WorldMapMenuCell:SetData(data)
	self.data = data
	
	self.mapname.text = data.NameZh;
	if(data.LvRange and data.LvRange[2])then
		self.lvname.text = string.format(ZhString.WorldMapMenuCell_LvTip, data.LvRange[1], data.LvRange[2]);
		self:Show(self.lvname);
		self.table.transform.localPosition = Vector3(7.4,77.5,0);
	else
		self:Hide(self.lvname);
		self.table.transform.localPosition = Vector3(7.4,99.5,0);
	end

	local nowScene = SceneProxy.Instance.currentScene;
	local nowMapId = nowScene.mapID;

	self.goBtn:SetActive(nowMapId ~= data.id );
	-- self.buttonActive = nowMapId ~= data.id;
	-- local sprite = self.goBtn:GetComponent(UISprite);
	-- sprite.color = self.buttonActive and Color(1,1,1) or Color(1/255,2/255,3/255);

	self:UpdateMapInfo();

	self:UpdateQuestSymbol();
	self:UpdateSealSymbol();
	self.table:Reposition();
end

function WorldMapMenuCell:UpdateMapInfo()
	local id = self.data and self.data.id;
	if(not id or not Table_MapInfo)then
		return;
	end

	local upInfos, monsters = {}, {};
	-- event Info
	local eventInfos = self:GetEventInfos(id);
	if(eventInfos)then
		for i=1,#eventInfos do
			table.insert(upInfos, eventInfos[i]);
		end
	end

	local mapInfo = Table_MapInfo[id];
	if(mapInfo)then
		local units = mapInfo.units;
		if(units == nil)then
			helplog("Mapid:" .. id .. " Not Find AreaData.");
			return;
		end
		self.hasDailyFunc = false;
		local monsterIDMap = {};
		for id,unit in pairs(units) do
			local idShadow = unit[1];
			local npcdata = id and Table_Npc[ id ];
			if(npcdata)then
				if(not self.hasDailyFunc)then
					self.hasDailyFunc = QuestSymbolCheck.HasDailySymbol(npcdata);
				end
				if(npcdata.MapIcon~='')then
					local temp = {
						id = id,
						uid = idShadow,
						type = MapInfoType.Npc,
						icon = npcdata.MapIcon,
						label = npcdata.NameZh,
					};
					table.insert(upInfos, temp);
				end
			else
				local monsterdata = id and Table_Monster[id];
				if(monsterdata and monsterdata.Hide~=1 and monsterdata.WmapHide~=1)then
					if(not monsterIDMap[id])then
						monsterIDMap[id] = 1;
						table.insert(monsters, monsterdata);
					end
				end
			end
		end
		
		local exitPoints = mapInfo.exitPoints;
		if(exitPoints)then
			for i=1,#exitPoints do
				if(exitPoints[i]~=id)then
					local mapdata = Table_Map[exitPoints[i]];
					if(mapdata)then
						local temp = {
							id = exitPoints[i],
							type = MapInfoType.ExitPoint,
							icon = "map_portal", 
							label = mapdata.NameZh,
						};
						table.insert(upInfos, temp);
					end
				end
			end
		end
	end
	
	self.infoCtl:ResetDatas(upInfos);
	self.monsterCtl:ResetDatas(monsters);
end

function WorldMapMenuCell:UpdateQuestSymbol()
	local hasMain, hasBranch, hasDaily = false, false, false;
	if(self.data)then
		local list = QuestProxy.Instance:getQuestListByMapAndSymbol(self.data.id) or {};
		for i=1,#list do
			local quest = list[i];
			if(quest.type == QuestDataType.QuestDataType_MAIN)then
				hasMain = true;
			elseif(quest.type == QuestDataType.QuestDataType_DAILY)then
				hasDaily = true;
			else
				hasBranch = true;
			end
			
			if(hasMain and hasBranch and hasDaily)then
				break;
			end
		end
	end

	if(hasMain == false or hasBranch == false or hasDaily == false)then
		local questMapInfo = WorldMapProxy.Instance:GetWorldQuestInfo(self.data.id);
		if(questMapInfo)then
			hasMain = questMapInfo[1] == true;
			hasBranch = questMapInfo[2] == true;
			hasDaily = questMapInfo[3] == true;
		end
	end

	if(hasDaily == false)then
		hasDaily = self.hasDailyFunc == true;
	end

	self.questSymbol1:SetActive(hasMain);
	self.questSymbol2:SetActive(hasBranch);
	self.questSymbol3:SetActive(hasDaily);
	self.questSymbolGrid:Reposition();
end

function WorldMapMenuCell:UpdateSealSymbol()
	local hasSeal, issealing = false, false;
	if(type(self.data)~="table")then
		return;
	end
	local mapid = self.data and self.data.id;
	if(mapid)then
		hasSeal, issealing = self:CheckHasSealByMapId(mapid);
	end
	if(hasSeal)then
		self.sealSymbol.gameObject:SetActive(true);
		if(issealing)then
			self.sealSymbol.spriteName = "seal_icon_02";
		else
			self.sealSymbol.spriteName = "seal_icon_01";
		end
		self.questSymbolGrid:Reposition();
	else
		self.sealSymbol.gameObject:SetActive(false);
	end
end

function WorldMapMenuCell:CheckHasSealByMapId(mapid)
	local hasSeal, issealing;
	local sealData = SealProxy.Instance:GetSealData(mapid);
	if(sealData)then
		for _,item in pairs(sealData.itemMap)do
			hasSeal = true;
			if(item.issealing)then
				issealing = true;
				break;
			end
		end
	end
	return hasSeal, issealing;
end

function WorldMapMenuCell:SetCellInfoActive(b)
	self.questSymbolGrid.gameObject:SetActive(b);
end

function WorldMapMenuCell:GetEventInfos(mapid)
	TableUtility.ArrayClear(tempArray);

	local events = FunctionActivity.Me():GetMapEvents(mapid);
	for i=1,#events do
		if(events[i].running)then
			local mapInfo = events[i]:GetMapInfo();
			if(mapInfo)then
				local info = {
					type = MapInfoType.Event,
					id = events[i].id;
					icon = mapInfo.icon;
					label = mapInfo.label;
					iconScale = mapInfo.iconScale;
				};
				table.insert(tempArray, info)
			end
		end
	end
	return tempArray;
end
