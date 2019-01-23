PetInfoData = class("PetInfoData");

PetInfoData.KeyValue = {
	[ScenePet_pb.EPETDATA_NAME] = "name",
	[ScenePet_pb.EPETDATA_LV] = "lv",
	[ScenePet_pb.EPETDATA_EXP] = "exp",
	[ScenePet_pb.EPETDATA_FRIENDLV] = "friendlv",
	[ScenePet_pb.EPETDATA_FRIENDEXP] = "friendexp",
	[ScenePet_pb.EPETDATA_REWARDEXP] = "rewardexp",
	[ScenePet_pb.EPETDATA_RELIVETIME] = "relivetime",
	[ScenePet_pb.EPETDATA_TIME_HAPPLY] = "time_happly",
	[ScenePet_pb.EPETDATA_TIME_EXCITE] = "time_excite",
	[ScenePet_pb.EPETDATA_TIME_HAPPINESS] = "time_happiness",
	[ScenePet_pb.EPETDATA_TOUCH_TICK] = "touch_tick",
	[ScenePet_pb.EPETDATA_TOUCH_COUNT] = "touch_count",
	[ScenePet_pb.EPETDATA_FEED_TICK] = "feed_tick",
	[ScenePet_pb.EPETDATA_FEED_COUNT] = "feed_count",
	[ScenePet_pb.EPETDATA_REWARD_COUNT] = "reward_count",
	[ScenePet_pb.EPETDATA_BODY] = "body",
	[ScenePet_pb.EPETDATA_SKILL] = "skills",
	[ScenePet_pb.EPETDATA_SKILLSWITCH] = "skilloff",
}

function PetInfoData:ctor()
	
end

function PetInfoData:Server_SetData(serverData)
	self.petid = serverData.petid;
	self.guid = serverData.guid;
	self.name = serverData.name;

	self.staticData = Table_Pet and Table_Pet[self.petid];
	self.monsterData = Table_Monster[self.petid];

	if(Table_Pet_FriendLevel)then
		self.friendlyData = Table_Pet_FriendLevel[self.petid];

		self.events = {};
		self.events_map = {
			equip = {},
			adventure = {},
			body = {},
		};

		self.equip_events = {};
		self.body_events = {};
		self.adventure_events = {};
		local eventKey, eventConfig;
		for i=1,10 do
			eventKey = "Event_" .. i;
			eventConfigs = self.friendlyData[eventKey];
			if(eventConfigs)then
				for j=1,#eventConfigs do
					local eventConfig = eventConfigs[j];

					local edata = {};
					edata[0] = i;

					for k=1,#eventConfig do
						edata[k] = eventConfig[k]
					end
					table.insert(self.events, edata);

					local mapTable = self.events_map[ eventConfig[1] ];
					if(mapTable)then
						table.insert(mapTable, edata);
					end
				end
			end
		end
	end

	-- local petSetStr = "";
	
	for k,v in pairs(self.KeyValue)do
		local server_v = serverData[v];
		if(server_v ~= nil)then
			if(type(server_v) == "boolean")then
				if(server_v == true)then
					self[v] = 1;
				else
					self[v] = 0;
				end

				-- petSetStr = petSetStr .. v .. ":" .. tostring(self[v]) .. " | "

			elseif(type(server_v) == "table")then
				self[v] = {};

				-- petSetStr = petSetStr .. v .. ":" .. tostring(self[v]);

				for i=1,#server_v do
					-- petSetStr = petSetStr .. server_v[i]
					table.insert(self[v], server_v[i]);
				end

				-- petSetStr = petSetStr .. " | ";
			else
				self[v] = server_v;

				-- petSetStr = petSetStr .. v .. ":" .. tostring(self[v]) .. " | "

			end
		end
	end

 	local server_equips = serverData.equips;
 	if(server_equips)then
 		self.equips = {};
		local server_equips = serverData.equips;

		-- petSetStr = petSetStr .. " | " .. "equips:";

		for i=1,#server_equips do
			local itemData = ItemData.new();
			itemData:ParseFromServerData(server_equips[i]);
			table.insert(self.equips, itemData);

			-- petSetStr = petSetStr .. tostring(server_equips[i]) .. " "
		end
 	end
	
  	self.unlock_equip = {};
  	local server_unlock_equip = serverData.unlock_equip;
  	if(server_unlock_equip)then
		-- petSetStr = petSetStr .. " | " .. "unlockEquips:";
	  	for i=1,#server_unlock_equip do
	  		table.insert(self.unlock_equip, server_unlock_equip[i]);
			-- petSetStr = petSetStr .. tostring(server_unlock_equip[i]) .. " "
	  	end
  	end

	self.unlock_body = {};
  	local server_unlock_body = serverData.unlock_body;
  	if(server_unlock_body)then
		-- petSetStr = petSetStr .. " | " .. "unlock_body:";
  		for i=1,#server_unlock_body do
  			if(TableUtility.ArrayFindIndex(self.unlock_body, server_unlock_body[i]) == 0)then
	  			table.insert(self.unlock_body, server_unlock_body[i]);
  			end
			-- petSetStr = petSetStr .. tostring(server_unlock_body[i]) .. " ";
  		end
  	end

	-- helplog(string.format("PetInfoData Update(petid:%s):", self.petid), petSetStr);
end

function PetInfoData:Server_UpdateData(petMemberDatas)
	if(petMemberDatas == nil)then
		return;
	end
	-- local petInfoStr = "";
	for i=1,#petMemberDatas do
		local single = petMemberDatas[i];
		local v = PetInfoData.KeyValue[single.etype];
		self[v] = single.value;
		-- petInfoStr = petInfoStr .. v .. ":" .. single.value .. " | "

		if(single.etype == ScenePet_pb.EPETDATA_SKILL and single.values)then
			self.skills = {};
			for j=1,#single.values do
				table.insert(self.skills, single.values[j]);
			end
		elseif(single.etype == ScenePet_pb.EPETDATA_NAME and single.data)then
			self.name = single.data;
		end
	end

	-- helplog(string.format("PetInfoData Update(petid:%s):", self.petid), petInfoStr);
end

function PetInfoData:Server_UpdatePetEquip(serverItem)
	if(serverItem == nil)then
		return;
	end

	local guid = serverItem.base.guid;
	if(guid == nil or guid == "")then
		return;
	end

	local item = nil;
	for i=1,#self.equips do
		if(self.equips[i].id == guid)then
			item = self.equips[i];
		end
	end

	if(item == nil)then
		item = ItemData.new();
		table.insert(self.equips, item)
	end
	item:ParseFromServerData(serverItem);
end

function PetInfoData:Server_DeletePetEquip(itemguid)
	if(#self.equips == 0 or itemguid == nil or itemguid == "")then
		return;
	end
	for i=#self.equips,1,-1 do
		if(self.equips[i].id == itemguid)then
			table.remove(self.equips, i);
		end
	end
end

function PetInfoData:Server_UpdateUnlockInfo(server_equips, server_bodys)
  	if(server_equips)then
	  	for i=1,#server_equips do
	  		local unlockid = server_equips[i];
  			if(TableUtility.ArrayFindIndex(self.unlock_equip, unlockid) == 0)then
		  		table.insert(self.unlock_equip, unlockid);
  			end
	  	end
  	end
  	if(server_bodys)then
  		for i=1,#server_bodys do
  			local unlockid = server_bodys[i];
  			if(TableUtility.ArrayFindIndex(self.unlock_body, unlockid) == 0)then
		  		table.insert(self.unlock_body, unlockid);
  			end
  		end
  	end
end

function PetInfoData:GetMyPetFriendPct()
	local config = self.friendlyData;
	if(config == nil)then
		return 0;
	end

	local exp_ConfigKey = "AmityReward_" .. self.friendlv;
	if(not config[exp_ConfigKey])then
		return 0;
	end

	local overflow_exp = math.max(0, self.friendexp - config[exp_ConfigKey][1]);

	local exp_next_ConfigKey = "AmityReward_" .. (self.friendlv + 1);
	local uplv_exp = 1;
	local next_exp = config[exp_next_ConfigKey] and config[exp_next_ConfigKey][1];
	if(next_exp)then
		uplv_exp = next_exp - config[exp_ConfigKey][1];
	end
	return math.min(1, overflow_exp/uplv_exp);
end

function PetInfoData:GeMyPetFriendEvents()
	return self.events;
end

function PetInfoData:GetPetFriendRatio()
	if(PetFriendRatio == nil)then
		return;
	end
	local petFriend = self.staticData.PetFriend;
	return PetFriendRatio[petFriend];
end

function PetInfoData:GetCanEquipItemIds()
	if(self.staticData)then
		return self.staticData.EquipID;
	end
end

function PetInfoData:GetGiftItems()
	if(self.staticData)then
		return self.staticData.HobbyItem;
	end
end

function PetInfoData:GetEquips()
	return self.equips;
end

function PetInfoData:GetMoodLevel()
	local curTime = ServerTime.CurServerTime()/1000;
	local level = 0;
	if(self.time_happly and self.time_happly > curTime)then
		level = level + 1;
	end
	if(self.time_excite and self.time_excite > curTime)then
		level = level + 1;
	end
	if(self.time_happiness and self.time_happiness > curTime)then
		level = level + 1;
	end
	return level;
end

function PetInfoData:GetUnLockBodyEvents()
	if(self.events_map)then
		return self.events_map.body
	end
end

function PetInfoData:GetUnLockEquipIds()
	return self.unlock_equip;
end

function PetInfoData:GetUnLockBodys()
	return self.unlock_body;
end

function PetInfoData:Get_Adventure_UnLockFriendlyLevel()
	if(self.events_map == nil)then
		return 1;
	end

	local adventure_event = self.events_map.adventure;
	if(adventure_event[1])then
		return adventure_event[1][0];
	end
end

function PetInfoData:Get_Equip_UnlockFriendlyLevel(equipid)
	if(self.events_map == nil)then
		return 1;
	end

	if(self.cache_equipid_friendlv_map == nil)then
		self.cache_equipid_friendlv_map = {};

		local equip_events = self.events_map.equip;
		for i=1,#equip_events do
			local event = equip_events[i];
			for j=2,#event do
				local equipid = event[j];
				self.cache_equipid_friendlv_map[ equipid ] = event[0];
			end
		end
	end

	return self.cache_equipid_friendlv_map[equipid] or 1;
end

function PetInfoData:Get_Body_UnlockFriendlyLevel(bodyid)
	if(self.events_map == nil)then
		return 1;
	end

	if(self.cache_bodyid_friendlv_map == nil)then
		self.cache_bodyid_friendlv_map = {};

		local body_events = self.events_map.body;
		for i=1,#body_events do
			local event = body_events[i];
			for j=2,#event do
				local bodyid = event[j];
				self.cache_bodyid_friendlv_map[ bodyid ] = event[0];
			end
		end
	end
	return self.cache_bodyid_friendlv_map[bodyid] or 1;
end

function PetInfoData:CheckBodyIsUnLock(bodyid)
	if(self.unlock_body)then
		for i=1,self.unlock_body do
			if(self.unlock_body[i] == bodyid)then
				return true;
			end
		end
	end
	return false;
end

function PetInfoData:CheckEquipIsUnlock(equipid)
	if(self.unlock_equip)then
		for i=1,#self.unlock_equip do
			if(self.unlock_equip[i] == equipid)then
				return true;
			end
		end
	end

	local unlocklv = self:Get_Equip_UnlockFriendlyLevel(equipid);
	if(self.friendlv >= unlocklv)then
		return true;
	end

	return false, unlocklv;
end

function PetInfoData:GetHeadIcon()
	local bodyId = self.body;
	if(bodyId == 0)then
		bodyId = self.petid;
	end

	local bodyData = Table_Monster[bodyId];
	if(bodyData)then
		return bodyData.Icon;
	end
end

function PetInfoData:IsAlive()
	local curtime = ServerTime.CurServerTime()/1000;
	return self.relivetime <= curtime;
end

function PetInfoData:CanHug()
	local limitFriendLv = GameConfig.Pet.Hug_LimitFriendLv or 1;
	return self.friendlv >= limitFriendLv;
end

function PetInfoData:IsSkillPerfect()
	if(#self.skills == 0)then
		return true
	end

	for i=1,4 do
		local skillRandomConfig = self.staticData[ "Skill_" .. i ];
		if(skillRandomConfig[1] and skillRandomConfig[2])then
			-- 101010001,10
			local fullSkillid = skillRandomConfig[1] - skillRandomConfig[1]%10 + skillRandomConfig[2];
			local isPerfect = true;
			for j=1,#self.skills do
				if(self.skills[j] < fullSkillid)then
					isPerfect = false;
					break;
				end
			end
			if(not isPerfect)then
				return false;
			end
		end
	end
	return true;
end

function PetInfoData:IsAutoFighting()
	return self.skilloff ~= 1;
end
