GuildProxy = class('GuildProxy', pm.Proxy)
GuildProxy.Instance = nil;
GuildProxy.NAME = "GuildProxy"

autoImport("MyselfGuildData");

GuildItemConfig = {
	-- GuildAssetId = 146, -- guildData -- 从guildData取
	GuildItemId = 5500,
}

GuildAuthorityMap = {
	InviteJoin = 1,
	PermitJoin = 2,
	SetBordInfo = 4,
	SetRecruitInfo = 5,
	SetIcon = 6,
	UpgradeGuild = 7,
	KickMember = 11,
	SetJob = 13,
	SetJobname = 14,
	ChangePresident = 15,
	DismissGuild = 16,
	ChangeLine = 17,
	OpenGuildRaid = 18,
	EditPicture = 19,
	ChangeName = 20,
	GiveUpLand = 21,
	OpenGuildFunction = 22,
	Guild = 23,
	ArtifactQuest = 24,
	ArtifactProduce = 25,
	ArtifactOption = 26,
	Treasure = 27,
	Shop = 28,
	Voice = 29,
}

Guild_GateState = {
	Lock = FuBenCmd_pb.EGUILDGATESTATE_LOCK,
	Close = FuBenCmd_pb.EGUILDGATESTATE_CLOSE,
	Open = FuBenCmd_pb.EGUILDGATESTATE_OPEN,
}

function GuildProxy:ctor(proxyName, data)
	self.proxyName = proxyName or GuildProxy.NAME
	if(GuildProxy.Instance == nil) then
		GuildProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:InitProxy();
end

function GuildProxy:InitProxy()
	self.guildList = {};
	self.sceneGuildDataMap = {};
	self.sceneGuildGateMap = {};
	self.donateItems = {};
	
	self.myGuildData = nil;
end

function GuildProxy:UpdateGuildList(guildSummarys)
	-- TableUtility.ArrayClear(self.guildList);
	self.guildList = {};
	for i=1,#guildSummarys do
		local gd = {summary = guildSummarys[i]};
		local guildData = GuildData.new(gd);
		table.insert(self.guildList, guildData); 
	end
end

function GuildProxy:GetGuildList()
	return self.guildList;
end

function GuildProxy:InitMyGuildData(guildData)
	self.myGuildData = MyselfGuildData.new(guildData);

	UnionLogo.Ins():SetUnionID(self.myGuildData.id)
end

function GuildProxy:UpdateMyGuildData(updates)
	if(not self.myGuildData)then
		errorLog("Not Find MyGuildData (UpdateMyGuildData)" );
		return;
	end

	self.myGuildData:UpdateData(updates);
end

function GuildProxy:UpdateMyGuildJob(server_job)
	if(not self.myGuildData)then
		return;
	end

	self.myGuildData:UpdateGuildJobInfo(server_job);
end

function GuildProxy:UpdateMyMembers(guildMembers, dels)
	if(not self.myGuildData)then
		errorLog("Not Find MyGuildData (UpdateMyMembers)" );
		return;
	end

	if(guildMembers)then
		self.myGuildData:SetMembers(guildMembers);
	end
	if(dels)then
		self.myGuildData:RemoveMembers(dels);
	end
end

function GuildProxy:UpdateMyGuildMemberData(charid, updates)
	if(not self.myGuildData)then
		errorLog("Not Find MyGuildData (UpdateMyGuildMemberData)" );
		return;
	end

	local memberData = self.myGuildData:GetMemberByGuid(charid);
	if(memberData)then
		memberData:UpdateData(updates);
	end
end

function GuildProxy:UpdateMyGuildApplyData(charid, updates)
	if(not self.myGuildData)then
		errorLog("Not Find MyGuildData (UpdateMyGuildApplyData)" );
		return;
	end

	local applyData = self.myGuildData:GetApplyByGuid(charid);
	if(applyData)then
		applyData:UpdateData(updates);
	end
end

function GuildProxy:UpdateMyApplys(guildApplys, dels)
	if(not self.myGuildData)then
		errorLog("Not Find MyGuildData (UpdateMyApplys)");
		return;
	end
	
	if(guildApplys)then
		self.myGuildData:SetApplys(guildApplys);
	end
	if(dels)then
		self.myGuildData:RemoveApplys(dels);
	end
	-- 添加红点
	-- local _,apply = next(self.myGuildData.applysMap);

	-- local myGuildMemberData = self:GetMyGuildMemberData();
 -- 	local canLetIn = GuildProxy.Instance:CanJobDoAuthority(myGuildMemberData.job, GuildAuthorityMap.PermitJoin);
	-- if(canLetIn and apply)then
	-- 	RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_GUILD_APPLY)
	-- else
	-- 	RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_GUILD_APPLY)
	-- end
end

function GuildProxy:ExitGuild()
	-- 移除红点
	-- RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_GUILD_APPLY)
	if(self.myGuildData)then
		ArtifactProxy.Instance:ClearData();
		self.myGuildData:Exit();
	end
	
	UnionLogo.Ins():SetUnionID(nil)

	FunctionGuild.Me():ResetGuildItemQueryState()
	FunctionGuild.Me():ResetGuildEventQueryState()

	self.myGuildData = nil;
	self:ClearGuildPackItems();
end


--------------------------------------------------------------

function GuildProxy:GetMyGuildMemberData()
	if(self.myGuildData)then
		local myid = Game.Myself.data.id;
		return self.myGuildData:GetMemberByGuid(myid);
	end
end


function GuildProxy:IHaveGuild()
	return self.myGuildData ~= nil;
end

function GuildProxy:ImGuildChairman()
	return self.myGuildData and self.myGuildData:GetChairMan() and self.myGuildData:GetChairMan().id == Game.Myself.data.id;
end

function GuildProxy:IsDismissing()
	return self.myGuildData and self.myGuildData.dismisstime > ServerTime.CurServerTime()/1000;
end

-- 检测该公会职位是否可以执行该功能 (authority Table_GuildJob)
function GuildProxy:CanJobDoAuthority(job, authorityType)

	
	if(self.myGuildData == nil)then
		return;
	end

	if(job and authorityType)then
		local authorityType_value = 1 << (authorityType-1);
		local authority_value = self.myGuildData:GetJobAuthValue(job);


		Debug.Log("authority_value:"..authority_value.."	authorityType_value:"..authorityType_value)

		return authority_value & authorityType_value > 0;
	end
	return false;
end

function GuildProxy:CanIDoAuthority(authorityType)
	local mygm = self:GetMyGuildMemberData();
	if(mygm)then
		helplog("@@@ mygm.job"..mygm.job)
		return self:CanJobDoAuthority(mygm.job, authorityType);
	end
	helplog("@@@ mygm false")
	return false;
end

function GuildProxy:CanIEditAuthority(job, authorityType)
	local mygm = self:GetMyGuildMemberData();
	if(mygm)then
		local myjob = mygm.job;
		if(myjob < job)then
			local editvalue = self.myGuildData:GetJobEditAuth(myjob);
			-- local editvalue = Table_GuildJob[myjob].EditAuthority;
			return editvalue & (1 << (authorityType-1)) > 0;
		end
	end
	return false;
end

function GuildProxy:GetJobEditAuthority(job)
	local config = Table_GuildJob[job];
	local editvalue = config and config.EditAuthority;
	if(editvalue > 0)then
		local result = {};
		for _,gtype in pairs(GuildAuthorityMap)do
			local typevalue = 1 << (gtype-1);
			if((editvalue & typevalue)>0)then
				table.insert(result, gtype)
			end
		end
		return result;
	end
end

function GuildProxy:GetFaithAttri(prayType, level)
	local config = Table_Guild_Faith[prayType];
	local result = {};
	for key,value in pairs(config.BaseValue)do
		result[key] = value;
	end
	for key,value in pairs(config.GrowValue)do
		if(result[key])then
			result[key] = result[key] + value;
		else
			result[key] = value;
		end
	end
	return result;
end

function GuildProxy:GetFaithCost(prayType, level)
	local config = Table_Guild_Faith[prayType];
	local result = {};
	result.sliver = config.Money * (level + 1);
	result.contribution = config.Contribution[1] * (level + 1);
	return result;
end

function GuildProxy:CheckPlayerInMyGuild(playerid)
	local myGuildData = self.myGuildData;
	if(myGuildData)then
		return myGuildData:GetMemberByGuid(playerid)~=nil;
	end
	return false;
end

function GuildProxy:GetGuildMaxLevel()
	if(not self.maxlevel)then
		self.maxlevel = #Table_Guild;
	end
	return self.maxlevel;
end

function GuildProxy:SetMyGuildDonateItems(items)
	if(items)then
		for i=1,#items do
			self:AddOrUpdateGuildDonateItem(items[i]);			
		end
	end
end

function GuildProxy:ClearGuildDonateItems()
	TableUtility.TableClear(self.donateItems);
end

function GuildProxy:AddOrUpdateGuildDonateItem(serverItem)
	if(serverItem)then
		local key = string.format("%s_%s", serverItem.time, serverItem.configid)
		local donateItem = self.donateItems[key];
		if(not donateItem)then
			donateItem = {};
			donateItem.cid = key;
			donateItem.configid = serverItem.configid;

			donateItem.itemid = serverItem.itemid;
			donateItem.itemcount = serverItem.itemcount;
			donateItem.contribute = serverItem.contribute;
			donateItem.medal = serverItem.medal;

			donateItem.time = serverItem.time;
			self.donateItems[key] = donateItem;
		end
		donateItem.count = serverItem.count;
	end
end

function GuildProxy:RemoveGuildDonateItem(serverItem)
	if(serverItem)then
		local key = string.format("%s_%s", serverItem.time, serverItem.configid)
		local item = self.donateItems[key];
		if(item)then
			self.donateItems[key] = nil;
		end
	end
end

function GuildProxy:GetGuildDonateItemList()
	if(self.donateItems)then
		local result = {};
		for _,donateItem in pairs(self.donateItems) do
			table.insert(result, donateItem)
		end
		table.sort(result, GuildProxy.SortDonateItems);
		return result;
	end
end

function GuildProxy.SortDonateItems(a, b)
	if(a.time~=b.time)then
		return a.time > b.time;
	end
	return a.configid > b.configid;
end



-- Guild Pack begin

function GuildProxy:SetGuildPackItems( serverItems )
	if(not self.myGuildData)then
		return;
	end
	-- helplog("GuildProxy SetGuildPackItems  ----> serverItems count : ",#serverItems)
	self.myGuildData:SetGuildPackItems(serverItems)
end

function GuildProxy:RemoveGuildPackItems( dels )
	if(not self.myGuildData or not dels)then
		return;
	end
	self.myGuildData:RemoveGuildPackItems(dels)
end

function GuildProxy:ClearGuildPackItems()
	if(not self.myGuildData)then
		return;
	end
	self.myGuildData:ClearGuildPackItems()
end

function GuildProxy:GetGuildPackItemByItemid( itemid )
	if(not self.myGuildData)then
		return nil;
	end
	return self.myGuildData:GetGuildPackItemByItemid(itemid);
end

function GuildProxy:GetGuildPackItemNumByItemid( itemid )
	if(not self.myGuildData)then
		return 0;
	end
	return self.myGuildData:GetGuildPackItemNumByItemid(itemid);
end
-- Guild Pack end


function GuildProxy:SetGuildGateInfo(gatedatas)
	for i=1,#gatedatas do
		local gatedata = gatedatas[i];
		local npcid = gatedata.gatenpcid;

		local client_gatedata = self.sceneGuildGateMap[npcid];
		if(client_gatedata == nil)then
			client_gatedata = {};

			client_gatedata.gatenpcid = npcid;

			self.sceneGuildGateMap[npcid] = client_gatedata;
		end

		client_gatedata.killedbossnum = gatedata.killedbossnum;
		client_gatedata.haveteamer = gatedata.haveteamer;
		client_gatedata.closetime = gatedata.closetime;
		client_gatedata.level = gatedata.level;
		client_gatedata.isspecial = gatedata.isspecial;
		client_gatedata.state = gatedata.state;
		client_gatedata.groupindex = gatedata.groupindex;

		-- local str = "";
		-- str = str .. "npcguid:" .. tostring(npcid) .. " | ";
		-- str = str .. "killedbossnum:" .. tostring(gatedata.killedbossnum) .. " | ";
		-- str = str .. "haveteamer:" .. tostring(gatedata.haveteamer) .. " | ";
		-- str = str .. "groupindex:" .. tostring(gatedata.groupindex) .. " | ";
		-- str = str .. "closetime:" .. os.date("%Y-%m-%d-%H-%M-%S", gatedata.closetime) .. " | ";
		-- str = str .. "level:" .. tostring(gatedata.level) .. " | ";
		-- str = str .. "isspecial:" .. tostring(gatedata.isspecial) .. " | ";
		-- str = str .. "state:" .. tostring(gatedata.state) .. " | ";

		-- helplog("SetGuildGateInfo:", str);
	end
end

function GuildProxy:GetGuildGateInfoByNpcId(roleid)
	return self.sceneGuildGateMap[roleid];
	-- return {
	-- 	killedbossnum = 2,
	-- 	haveteamer = true,
	-- 	closetime = 10000000000,
	-- 	level = 40,
	-- 	isspecial = false,
	-- 	state = 2,
	-- };
end

function GuildProxy:GetGuildGateInfoMap()
	return self.sceneGuildGateMap;
end

function GuildProxy:ClearGuildGateInfo()
	TableUtility.TableClear(self.sceneGuildGateMap);
end




-------------------------------------------------------
function GuildProxy:GetGuildActivityList()
	local result = {};
	for _,data in pairs(Table_GuildFunction)do
		if(self:_CheckGuildActivityData(data))then
			table.insert(result, data);
		end
	end
	return result;
end

local GUILD_TASK_CHALLENGE_PANELID = 549;
function GuildProxy:_CheckGuildActivityData(data)
	if(data == nil or data.Display ~= 1)then
		return false;
	end

	if(data.PanelId == GUILD_TASK_CHALLENGE_PANELID)then
		if(not self.myGuildData:CheckFunctionOpen(GuildCmd_pb.EGUILDFUNCTION_BUILDING))then
			return false;
		end
	end

	if(data.FinishTime == '' or data.AppearTime == '')then
		return false;
	end

	local startDate = string.split(data.AppearTime, " ");
	local endDate = string.split(data.FinishTime, " ");

	local appearTimeRange = data.AppearTimeRange;
	if(appearTimeRange and appearTimeRange[1])then
		for _,range in pairs(appearTimeRange)do
			local startTime, endTime = range[1], range[2];
			if(startTime~='' and endTime~='')then
				startTime = string.gsub(startTime, ":", "-");
				endTime = string.gsub(endTime, ":", "-");
				local startTimeStr = string.format("%s-%s-00", startDate[1], startTime);
				local endTimeStr = string.format("%s-%s-00", endDate[1], endTime);
				return ClientTimeUtil.IsCurTimeInRegion(startTimeStr, endTimeStr);
			end
			
		end
	else
		local startTimeStr = "-00-00-00";
		if(startDate[2])then
			startTimeStr = "-"..string.gsub(startDate[2], ":", "-");
		end
		local endTimeStr = "-23-59-59";
		if(endTimeStr)then
			endTimeStr = "-"..string.gsub(endDate[2], ":", "-");
		end
		return ClientTimeUtil.IsCurTimeInRegion(startDate[1]..startTimeStr, endDate[1]..endTimeStr);
	end
end


function GuildProxy:Server_ResetGuildEventList(serverEventlist)
	if(not self.myGuildData)then
		return;
	end

	self.myGuildData:Server_ResetGuildEventList(serverEventlist);
end

function GuildProxy:Server_AddGuildEventData(serverEventData)
	if(not self.myGuildData)then
		return;
	end

	self.myGuildData:Server_AddGuildEventData(serverEventData);
end

function GuildProxy:Server_RemoveGuildEventData(id)
	if(not self.myGuildData)then
		return;
	end

	self.myGuildData:Server_RemoveGuildEventData(id);
end

function GuildProxy:ClearGuildEventList()
	if(not self.myGuildData)then
		return;
	end

	self.myGuildData:ClearGuildEventList();
end


function GuildProxy:UpdateMyGuildHeadDatas(server_infos, server_dels)
	if(self.myGuildData == nil)then
		return;
	end

	self.myGuildData:Server_SetCustomIcons(server_infos, server_dels);
end

function GuildProxy:UpdateMyGuildHeadDataState(index, state, createtime, isdelete, type)
	if(self.myGuildData == nil)then
		return;
	end
	
	self.myGuildData:Server_UpdateCustomIcon(index, state, createtime, isdelete, type);
end

function GuildProxy:SetGuildWelfareState(welfare)
	if(self.myGuildData == nil)then
		return;
	end

	self.myGuildData.get_welfare = welfare;
end

function GuildProxy:GetGuildWelfareState()
	if(self.myGuildData == nil)then
		return false;
	end
	return self.myGuildData.get_welfare;
end

function GuildProxy:GetWelfareNpcId()
	return GameConfig.GuildBuilding and GameConfig.GuildBuilding.npcid_getwelfare or 0;
end

-- 更新公会任务 begin
function GuildProxy:UpdateGuildChallengeTasks(updates, dels, refreshtime)
	if(self.myGuildData == nil)then
		return;
	end

	self.myGuildData:Server_UpdateTasks(updates, dels, refreshtime);
end
-- 更新公会任务 end


function GuildProxy:SetExitTimeTick(timetick)
	self.exit_timetick = timetick;
end

function GuildProxy:GetExitTimeTick()
	if(self.exit_timetick == nil)then
		return 0;
	end

	local cdTime = GameConfig.Guild.enterpunishtime or 3600;
	return self.exit_timetick + cdTime;
end

function GuildProxy:IsInJoinCD()
	local exittimetick = self:GetExitTimeTick();
	if(exittimetick == 0)then
		return false;
	end
	return ServerTime.ServerDeltaSecondTime(exittimetick * 1000) > 0;
end