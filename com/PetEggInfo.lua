PetEggInfo = class("PetEggInfo")

function PetEggInfo:ctor(staticData)
	self.itemid = staticData.id;
	
	self:InitData();
end

function PetEggInfo:InitData()
	
end

function PetEggInfo:Server_SetData(serverdata)
	self.name = serverdata.name;

	self.petid = serverdata.id;
	self.lv = serverdata.lv;
	self.exp = serverdata.exp;
	self.friendlv = serverdata.friendlv;
	self.friendexp = serverdata.friendexp;
	self.rewardexp = serverdata.rewardexp;

	self.body = serverdata.body;
	self.relivetime = serverdata.relivetime;

	self.hp = serverdata.hp;

	self.restoretime = serverdata.restoretime;

	self.time_happly = serverdata.time_happly;
	self.time_excite = serverdata.time_excite;
	self.time_happiness = serverdata.time_happiness;
	self.friendlyData=Table_Pet_FriendLevel[self.petid]
	local petCfg = Table_Pet[self.petid] and Table_Pet[self.petid].Skill_5
	local server_skillids = serverdata.skillids;
	if(server_skillids)then
		self.skillids = {};
		for i=1,#server_skillids do
			local server_skill = server_skillids[i]
			table.insert(self.skillids, server_skill)
			if(petCfg and #petCfg>0 and math.floor(server_skill/1000)==math.floor(petCfg[1]/1000))then
				self.petWorkSkillID = server_skill
				-- helplog("petWorkSkillID: ",self.petWorkSkillID)
			end
		end
	end

	local server_equips = serverdata.equips;
	if(server_equips)then
		self.equips = {};
		for i=1,#server_equips do
			local serverEquip = server_equips[i];
			local itemData = ItemData.new();
			itemData:ParseFromServerData(serverEquip);
			if(itemData.staticData)then
				table.insert(self.equips, itemData)
			else
				helplog("PetEggInfo EquipError:", serverEquip.base.id);
			end
		end
	end
end

function PetEggInfo:GetNatureIcon()
	local data = Table_Monster[self.petid];
	if(data)then
		return data.Nature
	end
end


function PetEggInfo:GetRaceIcon()
	local data = Table_Monster[self.petid];
	if(data)then
		local race = data.Race
		for _,v in pairs(Table_Pet_AdventureCond) do
			if(v.TypeID=='Race' and v.Param[1]==race)then
				return v.Icon
			end
		end
	end
end

function PetEggInfo:GetPetFriendPercent()
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

function PetEggInfo:GetHeadIcon()
	local bodyId = self.body;
	if(bodyId == 0)then
		bodyId = self.petid;
	end

	local bodyData = Table_Monster[bodyId];
	if(bodyData)then
		return bodyData.Icon;
	end
end

function PetEggInfo:GetPartsId()
	if(self.body and self.body~=0)then
		return self.body
	end
	return self.petid
end

function PetEggInfo:CanExchange()
	return false;
end

function PetEggInfo:GetPetSkillLvl(skillID)
	for i=1,#self.skillids do
		if(math.floor(self.skillids[i]/1000) == skillID)then
			return self.skillids[i]%1000
		end
	end
	return nil
end

function PetEggInfo:bOwnSkill(skillParam)
	if(nil==skillParam or #skillParam<2)then
		helplog("skillParam 配置错误")
		return false
	end
	local lvl = self:GetPetSkillLvl(skillParam[1])
	if(lvl and lvl>=skillParam[2])then
		return true
	end
	return false
end

function PetEggInfo.GetPetDessParts(petid, equips)
	local roleParts = Asset_RoleUtility.CreateMonsterRoleParts(petid);

	if(equips == nil or #equips == 0)then
		return roleParts;
	end

	local sData = Table_Monster[petid];
	if(sData == nil)then
		return;
	end
	local equipFake = sData.EquipFake;
	local GameConfig_Equip = GameConfig.EquipType;
	for i=1,#equips do
		local eid = equips[i].staticData.id;
		local dressEquipData;
		-- if(equipFake[eid])then
		-- 	dressEquipData = Table_EquipFake[equipFake[eid]];
		-- else
			dressEquipData = Table_Equip[eid];
		-- end
		local equipBodyIndex = GameConfig_Equip[dressEquipData.EquipType].equipBodyIndex
		local bodyIndex = equipBodyIndex and RoleDefines_EquipBodyIndex[ equipBodyIndex ];

		if(bodyIndex)then
			roleParts[bodyIndex] = eid;
		end
	end
	return roleParts;
end


