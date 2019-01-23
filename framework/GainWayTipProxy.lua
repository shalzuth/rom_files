autoImport("GainWayItemData")
autoImport('Table_ItemOrigin')

GainWayTipProxy = class('GainWayTipProxy', pm.Proxy)
GainWayTipProxy.Instance = nil;
GainWayTipProxy.NAME = "GainWayTipProxy"

function GainWayTipProxy:ctor(proxyName, data)
	self.proxyName = proxyName or GainWayTipProxy.NAME
	if(GainWayTipProxy.Instance == nil) then
		GainWayTipProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function GainWayTipProxy:Init()
	--缓存已查过的道具的获取途径信息
	self.GainWayItemDataDic={}

	self:InitItemAccess();
end

local ItemAccessSort = function (a,b)
	return a.id < b.id;
end
function GainWayTipProxy:InitItemAccess()
	self.itemAccess_map = {};

	if(Table_ItemAccess)then
		for k,v in pairs(Table_ItemAccess)do
			if(self.itemAccess_map[ v.ItemID ] == nil)then
				self.itemAccess_map[ v.ItemID ] = {};
			end
			
			table.insert(self.itemAccess_map[ v.ItemID ], v)
		end
		
		for k,v in pairs(self.itemAccess_map)do
			table.sort(v, ItemAccessSort);
		end
	end
end

function GainWayTipProxy:GetItemAccessByItemId(itemid)
	-- 月饼配方特殊处理
	if itemid == 900012 then
		return;
	end

	return self.itemAccess_map[itemid];
end

function GainWayTipProxy:GetDataByStaticID(id)
	local data=self.GainWayItemDataDic[id]
	if(data)then
		return data
	else
		data=Table_ItemOrigin[id]
		if(data)then
			local temp = GainWayItemData.new(data,id)
			self.GainWayItemDataDic[id]=temp
			return temp	
		end
	end
end

function GainWayTipProxy:GetItemOriginMonster(staticId)
	local gainData = self:GetDataByStaticID(staticId);
	if(gainData)then
		return gainData:GetFirstMonsterOrigin();
	end
end

function GainWayTipProxy:GetMonsterOrderOriMap(monsterId)
	local result = {};

	local oriMaps = Table_MonsterOrigin[monsterId]
	if(oriMaps and #oriMaps>0)then
		local list = {};
		for i=1,#oriMaps do
			local single = oriMaps[i];
			local mapID = single.mapID;
			list[mapID] = list[mapID] or {};
			table.insert(list[mapID], single);
		end
		for _,mapCfgs in pairs(list)do
			table.insert(result, mapCfgs);
		end

		table.sort(result, function (a ,b)
			return #a > #b;
		end);
	end

	return result;
end















