WorldMapProxy = class('WorldMapProxy', pm.Proxy)
WorldMapProxy.Instance = nil;
WorldMapProxy.NAME = "WorldMapProxy"

autoImport("MapAreaData");

WorldMapCellSize = {
	x = 120,
	y = 120,
}

WorldMapProxy.OriginalPoint_X = -1;
WorldMapProxy.OriginalPoint_Y = -1;

function WorldMapProxy:ctor(proxyName, data)
	self.proxyName = proxyName or WorldMapProxy.NAME
	if(WorldMapProxy.Instance == nil) then
		WorldMapProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function WorldMapProxy:Init()
	self.worldQuestMap = {};

	self.tableMapDatas={}
	self:InitMapDatas()

	self:NInit();
end

function WorldMapProxy:InitMapDatas()
	for k,v in pairs(Table_Map)do
		if(v.Position and #v.Position==2)then
			table.insert(self.tableMapDatas,v)
		end
	end
	self.activeMaps = {}
	-- print("TableMapDatas "..#self.tableMapDatas)
end

function WorldMapProxy:GetMapDataByPosition(x,y)
	local temp = {}
	if(x and y)then
		for k,v in pairs(self.tableMapDatas)do
			if(x==v.Position[1] and y==v.Position[2])then
				temp=v
				break
			end
		end
	end
	return temp
end

-- ???????????????????????????ids..
function WorldMapProxy:RecvGoToListUser(data)
	for i=1, #data.mapid do
		local mapid = data.mapid[i];
		self.activeMaps[mapid] = 1;
	end
end

function WorldMapProxy:AddActiveMap(mapID)
	self.activeMaps[mapID] = 1;
end

function WorldMapProxy:GetFreyjaDatasByMapIDs(mapids)
	local datas = {}
	for i=1,#mapids do
		for k,v in pairs(Table_Freyja)do
			if(v.MapID==mapids[i])then
				table.insert(datas,v)
				break
			end
		end
	end
	-- printGreen("GetFreyjaDataByMapID", datas)
	return datas
end

function WorldMapProxy:IsThisFreyjaActived(GearID)
	for i=1,#self.curgears do
		if(self.curgears[i]==GearID)then
			return true
		end
	end
	return false
end


------------------------------------------------------------------------------

function WorldMapProxy:NInit()
	self.mapAreaDatas = {};
	for id,mapSData in pairs(Table_Map)do
		local x = mapSData.Position[1];
		local y = mapSData.Position[2];
		if(x and y and id==mapSData.MapArea)then
			local areaData = MapAreaData.new(id);
			self.mapAreaDatas[x] = self.mapAreaDatas[x] or {};
			self.mapAreaDatas[x][y] = areaData;
		end
	end
end

function WorldMapProxy:GetMapAreaDataByMapId(mapid)
	local mapData = Table_Map[mapid];
	if(mapData == nil)then
		helplog( string.format("MapData Is Nil(id:%s)", mapid) );
		return;
	end
	
	local areaid = mapData.MapArea;
	if(areaid)then
		local mapSData = Table_Map[areaid];
		local x,y = mapSData.Position[1], mapSData.Position[2];
		if(x and y)then
			return self:GetMapAreaDataByPos(x, y);
		end
	end
end

function WorldMapProxy:GetMapAreaDataByPos(x, y)
	if(x and y)then
		if(self.mapAreaDatas[x])then
			return self.mapAreaDatas[x][y]
		end
	end
end

function WorldMapProxy:ActiveMapAreaData(mapid, active,isNew)
	local areaData = self:GetMapAreaDataByMapId(mapid);
	if(active==nil)then
		active = true;
	end
	if(areaData)then
		areaData:SetActive(active);
		areaData:SetIsNew(isNew);

		FunctionGuide.Me():RemoveMapGuide(mapid)
	end
end

function WorldMapProxy:SetWorldQuestInfo( server_quests )
	if(server_quests)then
		TableUtility.TableClear( self.worldQuestMap );

		for i=1,#server_quests do
			local server_quest = server_quests[i];
			if(server_quest)then
				local client_quest = self.worldQuestMap[ server_quest.mapid ];
				if(client_quest == nil)then
					client_quest = {};
					client_quest[1] = server_quest.type_main;
					client_quest[2] = server_quest.type_branch;
					client_quest[3] = server_quest.type_daily;
					self.worldQuestMap[ server_quest.mapid ] = client_quest;
				end
			end
		end
	end
end

function WorldMapProxy:GetWorldQuestInfo(mapid)
	return self.worldQuestMap[mapid];
end
