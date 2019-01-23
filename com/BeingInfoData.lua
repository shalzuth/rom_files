BeingInfoData = class("BeingInfoData");

BeingInfoData.KeyValue = {
	[SceneBeing_pb.EBEINGDATA_GUID] = "guid",
	[SceneBeing_pb.EBEINGDATA_LV] = "lv",
	[SceneBeing_pb.EBEINGDATA_EXP] = "exp",
	[SceneBeing_pb.EBEINGDATA_BATTLE] = "battle",
	[SceneBeing_pb.EBEINGDATA_LIVE] = "live",
	[SceneBeing_pb.EBEINGDATA_SUMMON or 11] = "summon",
	[SceneBeing_pb.EBEINGDATA_BODY or 12] = "body",
}

function BeingInfoData:ctor()
end

function BeingInfoData:Server_SetData(server_BeingInfo)
	self.beingid = server_BeingInfo.beingid;

	if(self.beingid)then
		self.staticData = Table_Monster[self.beingid];
		self.name = self.staticData.NameZh;
	end

	-- local log_str = "";

	for k,v in pairs(self.KeyValue)do
		local s_value = server_BeingInfo[v];
		if(s_value ~= nil)then
			if(type(s_value) == "boolean")then
				if(s_value == true)then
					self[v] = 1;
				else
					self[v] = 0;
				end
			else
				self[v] = s_value;
			end

			-- log_str = log_str .. v .. ":" .. tostring(self[v]) .. " | "
		end
	end

	if(server_BeingInfo.bodylist)then
		self.bodylist = {};

		-- log_str = log_str .. "bodylist:";

		local list_value = server_BeingInfo.bodylist;
		for i=1,#list_value do
			local v = list_value[i];
			table.insert(self.bodylist, v);
			-- log_str = log_str .. v .. " ";
		end
	else
		self.bodylist = {};
	end

	if(self.body == nil or self.body == 0)then
		self.body = self.beingid;
	end

	-- helplog(string.format("BeingInfoData Set(name:%s guid:%s beingid:%s):", self.name, self.guid, self.beingid), log_str);
end

function BeingInfoData:Server_UpdateData(server_BeingMemberDatas)
	if(server_BeingMemberDatas == nil)then
		return;
	end

	-- local log_str = "BeingInfoData:" .. "";

	local oldSummon = self.summon;
	local oldLive = self.live;

	for i=1,#server_BeingMemberDatas do
		local single = server_BeingMemberDatas[i];

		if(single.etype == SceneBeing_pb.EBEINGDATA_BODYLIST)then
			self.bodylist = {};

			local values = single.values;
			for i=1,#values do
				table.insert(self.bodylist, values[i]);
			end
		else
			local v = self.KeyValue[single.etype];
			if(v ~= nil)then
				self[v] = single.value;
				-- log_str = log_str .. v .. ":" .. single.value .. " | "
			end
		end
	end

	if(self.body == nil or self.body == 0)then
		self.body = self.beingid;
	end
	
	-- helplog(string.format("BeingInfoData Update(guid:%s beingid:%s):", self.guid, self.beingid), log_str);
end

function BeingInfoData:IsAutoFighting()
	return self.battle == 1;
end

function BeingInfoData:IsSummoned()
	return self.summon == 1;
end

function BeingInfoData:IsAlive()
	return self.live == 1;
end

function BeingInfoData:SetUnlockBodys(server_unlockbodys)
	
end

function BeingInfoData:GetBeingBodys()
	if(self.bodylist and #self.bodylist > 0)then
		local result = { self.beingid };
		for i=1,#self.bodylist do
			table.insert(result, self.bodylist[i]);
		end

		return result;
	end
	return _EmptyTable;
end

function BeingInfoData:GetHeadIcon()
	local bodyId = self.body;
	if(bodyId == 0)then
		bodyId = self.beingid;
	end
	
	local bodyData = Table_Monster[bodyId];
	if(bodyData)then
		return bodyData.Icon;
	end
end