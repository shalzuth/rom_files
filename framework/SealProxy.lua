SealProxy = class('SealProxy', pm.Proxy)
SealProxy.Instance = nil;
SealProxy.NAME = "SealProxy"

autoImport("SealData");

function SealProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SealProxy.NAME
	if(SealProxy.Instance == nil) then
		SealProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:InitSeal();
end

function SealProxy:InitSeal()
	self.sealDataMap = {};
	self.nowAcceptSeal = nil;
	self.nowSealPos = LuaVector3();
	self.nowSealTasks = {};
end

function SealProxy:SetNowSealTasks(serverlist)
	TableUtility.ArrayClear(self.nowSealTasks)
	for i=1, #serverlist do
		table.insert(self.nowSealTasks, serverlist[i])
	end
end

function SealProxy:SetNowAcceptSeal(sealId, sealPos)
	self:ResetAcceptSealInfo();

	self.nowAcceptSeal = sealId;
	if(sealPos == nil)then
		self.nowSealPos:Set(0, 0, 0);
	else
		self.nowSealPos:Set(sealPos.x/1000, sealPos.y/1000, sealPos.z/1000);
	end
end

function SealProxy:ResetAcceptSealInfo()
	self.nowAcceptSeal = 0;

	self.nowSealPos:Set(0,0,0);
	self.speed = 0;
	self.curvalue = 0;
	self.maxvalue = 1;
end

function SealProxy:SetSealTimer(data)
	if(data)then
		self.speed = data.speed;
		self.curvalue = data.curvalue;
		self.maxvalue = data.maxvalue;
		self.stoptime = data.stoptime;
		self.maxtime = data.maxtime;
	end
end

function SealProxy:ResetSealData()
	self.sealDataMap = {};
end

function SealProxy:SetSealData(datas)
	for i=1,#datas do
		local data = datas[i];
		if(data)then
			local sealData = self.sealDataMap[data.mapid];
			if(not sealData)then
				sealData = SealData.new(data);
				self.sealDataMap[data.mapid] = sealData;
			else
				sealData:SetData(data);
			end
		end
	end
end

function SealProxy:UpdateSeals(newdatas, deldatas)
	self:SetSealData(newdatas);
	-- delete
	for i=1,#deldatas do
		local tempDel = deldatas[i];
		local catchData = self.sealDataMap[tempDel.mapid];
		if(catchData)then
			catchData:DeleteSealItem(tempDel.items);
		end
	end
end

function SealProxy:GetSealData(mapid)
	return self.sealDataMap[mapid];
end

function SealProxy:GetSealItem(mapid, sealid)
	local sealData = self.sealDataMap[mapid];
	if(sealData)then
		return sealData.itemMap[sealid];
	end
end

function SealProxy:GetSealingItem()
	for mapid,sealData in pairs(self.sealDataMap)do
		for sealid,sealItem in pairs(sealData.itemMap)do
			if(sealItem.issealing)then
				return sealItem;
			end
		end
	end
end




