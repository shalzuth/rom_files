GvgProxy = class('GvgProxy', pm.Proxy)
GvgProxy.Instance = nil;
GvgProxy.NAME = "GvgProxy"

GvgProxy.MaxQuestRound = 3
GvgProxy.GvgQuestMap = {
	[FuBenCmd_pb.EGVGDATA_PARTINTIME] = "partin_time",
	[FuBenCmd_pb.EGVGDATA_KILLMON ]= "kill_monster",
	[FuBenCmd_pb.EGVGDATA_RELIVE] = "relive_other",
	[FuBenCmd_pb.EGVGDATA_EXPEL] = "expel_enemy",
	[FuBenCmd_pb.EGVGDATA_DAMMETAL] = "dam_metal",
	[FuBenCmd_pb.EGVGDATA_KILLMETAL] = "kill_metal",
	[FuBenCmd_pb.EGVGDATA_KILLUSER] = "kill_one_user",
	[FuBenCmd_pb.EGVGDATA_HONOR] = "get_honor",
}

GvgProxy.GvgQuestListp = {
	FuBenCmd_pb.EGVGDATA_HONOR,
	FuBenCmd_pb.EGVGDATA_KILLUSER,
	FuBenCmd_pb.EGVGDATA_PARTINTIME,
	FuBenCmd_pb.EGVGDATA_KILLMON,
	FuBenCmd_pb.EGVGDATA_RELIVE,
	FuBenCmd_pb.EGVGDATA_EXPEL,
	FuBenCmd_pb.EGVGDATA_DAMMETAL,
	FuBenCmd_pb.EGVGDATA_KILLMETAL,
}

function GvgProxy:ctor(proxyName, data)
	self.proxyName = proxyName or GvgProxy.NAME
	if(GvgProxy.Instance == nil) then
		GvgProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:InitProxy();
end

function GvgProxy:InitProxy()
	self.ruleGuild_Map = {};
	self.questInfoData = {}

	self.glandstatus_map = {};
end

function GvgProxy:ClearFightInfo()
	self.fire = false
	self.isFinish = false
	self.result = nil
end

function GvgProxy:ClearQuestInfo()
	TableUtility.TableClear(self.questInfoData)
end

-- 第二个参数区别数据类型
function GvgProxy:GetRuleGuildInfo(flagid)
	if(self.ruleGuild_Map[flagid])then
		return self.ruleGuild_Map[flagid], 1;
	end

	return self.glandstatus_map[flagid], 2;
end

function GvgProxy:SetRuleGuildInfos(server_GuildCityInfos)
	if(server_GuildCityInfos == nil)then
		return;
	end

	for i=1,#server_GuildCityInfos do
		self:SetRuleGuildInfo(server_GuildCityInfos[i]);
	end
end

function GvgProxy:SetRuleGuildInfo(server_GuildCityInfo)
	if(server_GuildCityInfo == nil)then
		return;
	end

	local info = self.ruleGuild_Map[ server_GuildCityInfo.flag ];

	if(server_GuildCityInfo.id == 0)then
		self.ruleGuild_Map[ server_GuildCityInfo.flag ] = nil;
		return;
	end

	if( info == nil )then
		info = {};
		self.ruleGuild_Map[ server_GuildCityInfo.flag ] = info;
	end

	info.id =  server_GuildCityInfo.id;
	info.flag = server_GuildCityInfo.flag;
	info.lv = server_GuildCityInfo.lv;
	info.membercount = server_GuildCityInfo.membercount;

	info.name = server_GuildCityInfo.name;
	info.portrait = server_GuildCityInfo.portrait;

	FunctionGuild.Me():SetGuildLandIcon(info.flag, info.portrait, info.id)
end

function GvgProxy:ClearRuleGuildInfos()
	TableUtility.TableClear(self.ruleGuild_Map);
end

function GvgProxy:IsInFightingTime()
	return self.gvg_isopen;
end

function GvgProxy:SetGvgOpenTime(isOpen, starttime)
	self.gvg_isopen = isOpen;
	self.gvg_opentime = starttime;
end

function GvgProxy:GetGvgOpenTime()
	return self.gvg_opentime;
end

function GvgProxy:RecvGuildFireDangerFubenCmd(data)
	self.danger = data.danger
	self.danger_time = data.danger_time
end

function GvgProxy:RecvGuildFireMetalHpFubenCmd(data)
	self.metal_hpper = data.hpper
end

function GvgProxy:RecvGuildFireRestartFubenCmd(data)
	self.metal_hpper = 100
	self.result = nil
	self.isFinish = false
end

function GvgProxy:RecvGuildFireStopFubenCmd(data)
	self.result = data.result
	self.isFinish = true
end

function GvgProxy:RecvGvgDefNameChangeFubenCmd(data)
	self.def_guildname = data.newname
end

function GvgProxy:RecvGuildFireNewDefFubenCmd(data)
	self.def_guildid = data.guildid
	self.def_guildname = data.guildname
end

function GvgProxy:RecvGvgDataSyncCmd(data)
	local datas = data.datas
	for i=1,#datas do
		local single = datas[i]
		self.questInfoData[single.type] = single.value
	end
end

function GvgProxy:RecvGvgDataUpdateCmd(data)
	local gvgData = data.data
	self:CheckIfAchieve(self.questInfoData[gvgData.type],gvgData)
	self.questInfoData[gvgData.type] = gvgData.value
end

function GvgProxy:CheckIfAchieve(oldData,data)
	local key = data.type
	local value = data.value
	local configData = GameConfig.GVGConfig.reward[GvgProxy.GvgQuestMap[key]]
	-- helplog("CheckIfAchieve",key,value)
	if(configData)then
		local index = 1
		local dataInfo
		local maxRound = #configData > index and #configData or index
		if(key == FuBenCmd_pb.EGVGDATA_KILLUSER)then			
			return
		end
		while true do
			if((configData[index] and configData[index].times > value) or index > maxRound)then
				if(configData[maxRound].times <= value)then
					if((oldData and oldData < configData[maxRound].times ) or not oldData)then
						GameFacade.Instance:sendNotification(GVGEvent.ShowNewAchievemnetEffect)
					end
				elseif(configData[index-1] and ((oldData and oldData < configData[index-1].times) or not oldData))then
					GameFacade.Instance:sendNotification(GVGEvent.ShowNewAchievemnetEffect)
				end
				break
			end
			index = index+1
		end
	end
end

function GvgProxy:RecvGuildFireInfoFubenCmd(data)
	self.fire = data.fire
	self.def_guildid = data.def_guildid
	self.endfire_time = data.endfire_time
	self.danger = data.danger
	self.danger_time = data.danger_time
	self.metal_hpper = data.metal_hpper
	self.calmdown = data.calmdown
	self.calm_time = data.calm_time
	self.def_guildname = data.def_guildname
	self.def_perfect = data.def_perfect
end

function GvgProxy:Get_Guild_StrongHold_Config(flagid)
	if(Table_Guild_StrongHold == nil)then
		return;
	end

	for k,v in pairs(Table_Guild_StrongHold)do
		if(v.FlagId == flagid)then
			return v;
		end
	end
end

function GvgProxy:Test_Update_GLandStatusInfos()
	local tdatas = {};
	for k,v in pairs(Table_Guild_StrongHold)do
		local tdata = {};
		tdata.cityid = v.id;
		tdata.state = math.random(1, 7);
		tdata.guildid = math.random(1000, 2000);
		tdata.name = "测试公会" .. tdata.guildid;
		tdata.portrait = "";
		table.insert(tdatas, tdata);
	end
	self:Update_GLandStatusInfos(tdatas);
end
local _GLandStatusInfos = {};
local _GLandStatusInfos_dirty = true;
function GvgProxy:Update_GLandStatusInfos(server_infos)
	TableUtility.TableClear(self.glandstatus_map);
	if(server_infos == nil)then
		return;
	end

	for i=1,#server_infos do
		local server_info = server_infos[i];

		local cityid = server_info.cityid;
		local tdata = self.glandstatus_map[cityid];
		if(tdata == nil)then
			tdata = {
				cityid = cityid,
			};
			self.glandstatus_map[tdata.cityid] = tdata;
		end
		tdata.state = server_info.state;
		tdata.guildid = server_info.guildid;
		tdata.name = server_info.name;
		tdata.portrait = server_info.portrait;
		tdata.membercount = server_info.membercount;
		tdata.lv = server_info.lv;
	end

	_GLandStatusInfos_dirty = true;
end

function GvgProxy:Get_GLandStatusInfos()
	if(_GLandStatusInfos_dirty ~= true)then
		return _GLandStatusInfos;
	end

	_GLandStatusInfos_dirty = false;

	TableUtility.ArrayClear(_GLandStatusInfos);
	for k,v in pairs(self.glandstatus_map)do
		table.insert(_GLandStatusInfos, v);
	end
	table.sort(_GLandStatusInfos, function (a, b)
		return a.cityid < b.cityid;
	end)

	return _GLandStatusInfos;
end

function GvgProxy:WardInfos()
end

function GvgProxy:GetGuildInfos()

	local testDatas = {}
	for i=1,4 do
		local guildData = {id = 12312,customIconUpTime = 215456464,customicon = 1545}
		guildData.pieces = i
		guildData.metal = i
		guildData.occupationValue = 100
		testDatas[#testDatas+1] = guildData
	end
	return testDatas
end

function GvgProxy:ShowGvgFinalFightTip( stick )
	-- body
	TipManager.Instance:ShowGvgFinalFightTip(stick,NGUIUtil.AnchorSide.Right,{-450,0})
end

function GvgProxy:SetGvgOpenFireState(b)
	self.gvgOpenFireState = b;
end

function GvgProxy:GetGvgOpenFireState()
	return self.gvgOpenFireState;
end
