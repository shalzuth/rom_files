autoImport("PvpRoomData");
autoImport("YoyoRoomData");
autoImport("MvpBattleTeamData")

PvpProxy = class('PvpProxy', pm.Proxy)
PvpProxy.Instance = nil;
PvpProxy.NAME = "PvpProxy"

PvpProxy.Type = {
	Yoyo = MatchCCmd_pb.EPVPTYPE_LLH,		--溜溜猴
	DesertWolf = MatchCCmd_pb.EPVPTYPE_SMZL,		--沙漠之狼
	GorgeousMetal = MatchCCmd_pb.EPVPTYPE_HLJS,	--华丽金属
	PoringFight = MatchCCmd_pb.EPVPTYPE_POLLY,	--波利大乱斗
	MvpFight = MatchCCmd_pb.EPVPTYPE_MVP or MatchCCmd_pb.EPVPTYPE_POLLY,	--波利大乱斗
	SuGVG = MatchCCmd_pb.EPVPTYPE_SUGVG,
	TutorMatch = MatchCCmd_pb.EPVPTYPE_TUTOR, -- 导师匹配借用
}

PvpProxy.RoomStatus = {
	WaitJoin = MatchCCmd_pb.EROOMSTATE_WAIT_JOIN,
	ReadyForFight = MatchCCmd_pb.EROOMSTATE_READY_FOR_FIGHT,
	Fighting = MatchCCmd_pb.EROOMSTATE_FIGHTING,
	Success = MatchCCmd_pb.EROOMSTATE_MATCH_SUCCESS,
	End = MatchCCmd_pb.EROOMSTATE_END,   
}

function PvpProxy:ctor(proxyName, data)
	self.proxyName = proxyName or PvpProxy.NAME
	if(PvpProxy.Instance == nil) then
		PvpProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function PvpProxy:Init()
	self.pvpStatusMap = {};

	self.roomListMap = {};
	self.detail_roomid_map = {};

	--追踪信息
	self.fightStatInfo = {}
	self.fightStatInfo.ranks = {}
	self:ClearBosses()
end

function PvpProxy:ClearBosses()
	self.bosses = {}
end

function PvpProxy:ResetMyRoomInfo()
	if(self.myRoomData)then
		self.myRoomData = nil;
	end
end

function PvpProxy:SetMyRoomBriefInfo(type, brief_info)
	-- local myRoomType = PvpProxy.Instance:GetMyRoomType()
	-- if(myRoomType and myRoomType~=type)then
	-- 	return
	-- end

	if(brief_info == nil or brief_info.type == nil)then
		redlog("PvpProxy-->ReSetMyRoomBriefInfo",brief_info.roomid);
		self:ResetMyRoomInfo();
	else
		local roomid = brief_info.roomid;
		redlog("PvpProxy-->SetMyRoomBriefInfo", string.format("reqType:%s Roomid:%s Type:%s State:%s", type, roomid,brief_info.type, brief_info.state));
		self.myRoomData = PvpRoomData.new(roomid);
		self.myRoomData:SetData(brief_info);

		local roomlist = self:GetRoomList(type);
		if(roomlist)then
			local find = false
			for i=1,#roomlist do
				if(roomlist[i].guid == roomid)then
					roomlist[i]:SetData(brief_info);
					find = true
					break;
				end
			end
			if(not find) then
				if(type==PvpProxy.Type.DesertWolf)then
					local myRoom = PvpRoomData.new(roomid);
					myRoom:SetData(brief_info);
					roomlist[#roomlist+1] = myRoom
					table.sort(roomlist, function (l,r)
							return self:SortDesertRoomData(l,r)
						end )
				end
			end
		end
	end
	
end

function PvpProxy:UpdateMyRoomStatus(pvp_type, roomid, state, endtime)
	if(self.myRoomData and self.myRoomData.guid == roomid)then
		redlog("PvpProxy-->UpdateMyRoomStatus", string.format("Type:%s Roomid:%s State:%s", pvp_type, roomid, state));
		self.myRoomData.state = state;
		self.myRoomData:SetEndTime(endtime);
	end
end

function PvpProxy:GetMyRoomType()
	if(self.myRoomData)then
		return self.myRoomData.type;
	end
end

function PvpProxy:GetMyRoomState(type)
	if(self.myRoomData and self.myRoomData.type == type)then
		return self.myRoomData.state;
	end
	return PvpProxy.RoomStatus.WaitJoin;
end


function PvpProxy:GetMyRoomGuid()
	if(self.myRoomData)then
		return self.myRoomData.roomid;
	end
end


function PvpProxy:SetRoomList(type, room_lists)
	local detailRoomData = nil;
	local detail_roomid = self.detail_roomid_map[type];
	if(detail_roomid)then
		detailRoomData = self:GetRoomData(type, detail_roomid);
	end
	helplog("SetRoomList", type, detail_roomid, detailRoomData);
	local roomlist = {};

	local roomids = "";
	for i=1,#room_lists do
		local list = room_lists[i];
		roomids = roomids .. " " .. list.roomid;
		if(detailRoomData and list.roomid == detailRoomData.guid)then
			detailRoomData:SetData(list);
			detailRoomData:SetIndex(i);
			table.insert(roomlist, detailRoomData);
		else
			local roomdata = PvpRoomData.new(list.roomid);
			roomdata:SetData(list);
			roomdata:SetIndex(i);
			table.insert(roomlist, roomdata);
		end
	end
	helplog("RoomList IDS:", roomids);
	if(type==PvpProxy.Type.DesertWolf)then
			table.sort(roomlist, function (l,r)
					return self:SortDesertRoomData(l,r)
				end )
	end
	self.roomListMap[type] = roomlist;
end

function PvpProxy:SetYoyoRoomList(type,roomList)
	local yoyoRoomData=YoyoRoomData.new();
	yoyoRoomData:SetData(roomList);
	self.roomListMap[type]=yoyoRoomData:GetyoyoRoomData();
end

function PvpProxy:SortDesertRoomData(l,r)
	if(l.roomid==self:GetMyRoomGuid())then
		return true
	elseif(r.roomid==self:GetMyRoomGuid())then
		return false
	else
		return l.roomid<r.roomid
	end
end


function PvpProxy:GetRoomList(type)
	local roomlist = self.roomListMap[type];
	if(roomlist)then
		if(type == PvpProxy.Type.GorgeousMetal)then
			if(self.gorgeousMetal_SortFunc == nil)then
				self.gorgeousMetal_SortFunc = function(a, b)
					local ina = false;
					local inb = false;
					if(self.myRoomData ~= nil and self.myRoomData.type == type)then
						ina = a.guid == self.myRoomData.guid;
						inb = b.guid == self.myRoomData.guid;
					end
					if(ina ~= inb)then
						return ina == true;
					end
					return a.index < b.index;
				end
			end
			table.sort(roomlist, self.gorgeousMetal_SortFunc);
		end
		return roomlist;
	end
end

function PvpProxy:GetRoomData(type, guid)
	local roomlist = self.roomListMap[type];
	local roomData = nil;
	if(roomlist)then
		for i=1,#roomlist do
			if(roomlist[i].guid == guid)then
				roomData = roomlist[i];
				break;
			end
		end
	end
	return roomData;
end

function PvpProxy:SetRoomDetailInfo(type, guid, detail_info)
	if(type == nil)then
		return;
	end

	local roomData = self:GetRoomData(type, guid);

	if(roomData)then
		roomData:SetRoomDetailInfo(detail_info);
	else
		helplog("Not Find RoomData:" .. tostring(guid));
	end

	self.detail_roomid_map[type] = guid;
end

-- function PvpProxy:TestRoomBriefInfo()
-- 	local testRoomData = {};
-- 	for i=1,20 do
-- 		local roombriefInfo = {};
-- 		roombriefInfo.guid = 10000 + i;
-- 		roombriefInfo.name = "华丽金属房间" .. i
-- 		roombriefInfo.player_num = math.random(3,5);
-- 		roombriefInfo.num1 = 0;
-- 		roombriefInfo.num2 = 2;
-- 		roombriefInfo.num3 = 0;
-- 		table.insert(testRoomData, roombriefInfo);
-- 	end
-- 	self:SetRoomList(PvpProxy.Type.GorgeousMetal, testRoomData);

-- 	local reqRoomData = 
-- 	{
-- 		type = PvpProxy.Type.GorgeousMetal,
-- 	};
-- 	self:sendNotification(ServiceEvent.MatchCCmdReqRoomListCCmd, reqRoomData);
-- end



-- function PvpProxy:TestYoyoRoom()
-- 	local testRoomData = {};
-- 	for i=1,60 do
-- 		local roombriefInfo = {};
-- 		roombriefInfo.roomid = i;
-- 		roombriefInfo.name = "溜溜猴房间" .. i
-- 		roombriefInfo.player_num = math.random(15,20);
-- 		table.insert(testRoomData, roombriefInfo);
-- 	end
-- 	self:SetRoomList(PvpProxy.Type.Yoyo, testRoomData);
-- end


function PvpProxy:GetFightStatInfo(  )
	-- body
	return self.fightStatInfo
end

function PvpProxy:RecvNtfRankChangeCCmd(data)
	local ranks = data.ranks
	local rankDatas = {}
	for i=1,#ranks do
		local tb = {}
		tb.name = ranks[i].name
		tb.apple = ranks[i].apple
		rankDatas[#rankDatas+1] = tb
	end

	self.fightStatInfo.ranks = rankDatas
end

function PvpProxy:NtfFightStatCCmd(data)
	self.fightStatInfo.pvp_type = data.pvp_type
	self.fightStatInfo.starttime = data.starttime
	self.fightStatInfo.player_num = data.player_num
	self.fightStatInfo.score = data.score
	self.fightStatInfo.my_teamscore = data.my_teamscore
	self.fightStatInfo.enemy_teamscore = data.enemy_teamscore
	self.fightStatInfo.remain_hp = data.remain_hp
	if(data.myrank == 9999)then
		self.fightStatInfo.myrank = nil
	else
		self.fightStatInfo.myrank = data.myrank 
	end
end

function PvpProxy:HandlePvpResult(result)
	local data = {}
	data.result = result
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.UIVictoryView, viewdata = data})
end

function PvpProxy:IsSelfInPvp()
	local mapid = Game.MapManager:GetMapID()
	if mapid then
		local mapRaid = Table_MapRaid[mapid]
		if mapRaid then
			if mapRaid.Type == FunctionDungen.YoyoType or
				mapRaid.Type == FunctionDungen.DesertWolfType or
				mapRaid.Type == FunctionDungen.GorgeousMetalType then
				return true
			end
		end
	end
	return false
end

function PvpProxy:IsSelfInGuildBase()
	return Game.MapManager:GetMapID() == 10001 or DojoProxy.Instance:IsSelfInDojo()
end

function PvpProxy:RecvSyncMvpInfoFubenCmd(initInfo)
	self:ClearBosses()
	self.usernum = initInfo.usernum
	local liveBosses = initInfo.liveboss
	local deadBosses = initInfo.dieboss
	for i=1,#liveBosses do
		local single = liveBosses[i]
		local data = self.bosses[single] 
		if(not data)then
			data = {live = 1,total = 1}
			self.bosses[single] = data
		else
			data.live = data.live + 1
			data.total = data.total + 1
		end
	end

	for i=1,#deadBosses do
		local single = deadBosses[i]
		local data = self.bosses[single] 
		if(not data)then
			data = {live = 0,total = 1}
			self.bosses[single] = data
		else
			data.total = data.total + 1
		end
	end

end

local function SortMvpResult(l, r)
	local lMvpCount = l:GetKillMvpCount()
	local rMvpCount = r:GetKillMvpCount()
	if lMvpCount == rMvpCount then
		local lMiniCount = l:GetKillMiniCount()
		local rMiniCount = r:GetKillMiniCount()
		if lMiniCount == rMiniCount then
			return l.teamid < r.teamid
		else
			return lMiniCount > rMiniCount
		end
	else
		return lMvpCount > rMvpCount
	end
end

function PvpProxy:RecvMvpBattleReportFubenCmd(data)
	if self.mvpResultList == nil then
		self.mvpResultList = {}
	else
		TableUtility.ArrayClear(self.mvpResultList)
	end

	for i=1,#data.datas do
		local mvpData = MvpBattleTeamData.new(data.datas[i])
		self.mvpResultList[#self.mvpResultList + 1] = mvpData
	end

	table.sort(self.mvpResultList, SortMvpResult)
end

function PvpProxy:RecvUpdateUserNumFubenCmd(data)
	self.usernum = data.usernum
end

function PvpProxy:RecvBossDieFubenCmd(data)
	local data = self.bosses[data.npcid] 
	if(not data)then
		data = {live = 0,total = 1}
		self.bosses[single] = data
	else
		local live = data.live
		if(live and live >0)then
			data.live = data.live - 1
		else
			data.live = 0
		end
	end
end

function PvpProxy:PvpTeamMemberUpdateCCmd(matchTeamMemUpdateInfo)
	if(matchTeamMemUpdateInfo == nil)then
		return;
	end

	local roomid = matchTeamMemUpdateInfo.roomid;
	local teamid = matchTeamMemUpdateInfo.teamid;
	local isfirst = matchTeamMemUpdateInfo.isfirst;
	local index =matchTeamMemUpdateInfo.index;

	if(roomid and teamid)then
		local roomData = self:GetRoomData(PvpProxy.Type.GorgeousMetal, roomid);
		if(roomData)then
			local teamData = roomData:GetRoomTeamDataByPos(index);
			if(teamData)then
  				teamData.id = teamid;
				teamData.roomid = roomid;
				teamData.zoneid = zoneid;

				local updates = matchTeamMemUpdateInfo.updates;
				if(updates)then
					teamData:SetMembers(updates);
				end
				local deletes = matchTeamMemUpdateInfo.deletes;
				if(deletes)then
					teamData:RemoveMembers(deletes);
				end

				local myTeam = TeamProxy.Instance.myTeam;
				if(myTeam == nil or (myTeam.id == teamData.id and teamData.memberNum == 0))then
					self:ResetMyRoomInfo();
				end
			else
				redlog("PVP: Pos Is illegal", index, tostring(teamData));
			end
		end
	end

	local myID = Game.Myself.data.id
	local deletesId = matchTeamMemUpdateInfo.deletes;
	for _,v in pairs(deletesId) do
		if(v==myID)then
			self:ResetMyRoomInfo()
			break
		end
	end
end

function PvpProxy:PvpMemberDataUpdate(matchTeamMemDataUpdateInfo)
	if(matchTeamMemDataUpdateInfo == nil)then
		return;
	end

	local roomid = matchTeamMemDataUpdateInfo.roomid;
	local teamid = matchTeamMemDataUpdateInfo.teamid;
	local charid = matchTeamMemDataUpdateInfo.charid;
	local members = matchTeamMemDataUpdateInfo.members;

	if(roomid and teamid and charid and members)then
		local roomData = self:GetRoomData(PvpProxy.Type.GorgeousMetal, roomid);
		if(roomData)then
			local teamData = roomData:GetTeamByGuid(teamid);
			if(teamData)then
				local teamMemberData = teamData:GetMemberByGuid(charid);
				if(teamMemberData)then
					teamMemberData:SetMemberData(members);
				end
			end
		end
	end
end

function PvpProxy:DoKickTeamCCmd(type, roomid, zoneid, teamid)
	local roomList = self:GetRoomList(type);
	if(roomList)then
		for i=1,#roomList do
			local roomData = roomList[i];
			if(roomData and roomData.guid == roomid)then
				roomData:RemoveTeamByGuid(teamid);
			end
		end
	end
	if(self.myRoomData and self.myRoomData.guid == roomid)then
		local myTeam = TeamProxy.Instance.myTeam;
		if(myTeam and myTeam.id == teamid)then
			-- helplog("kick 时清空自己房间，myRoomID ",self.myRoomData.guid)
			self:ResetMyRoomInfo();
		end
	end
	if(type==PvpProxy.Type.DesertWolf)then
		ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(type, roomid)
	end
end

function PvpProxy:Req_Server_MyRoomMatchCCmd()
	if(not self.reqMyRoom)then
		self.reqMyRoom = true;
		ServiceMatchCCmdProxy.Instance:CallReqMyRoomMatchCCmd();
	end
end

function PvpProxy:PoringFightResult(server_rank, server_rewards, server_apple)
	if(server_rank == nil)then
		return;
	end

	self.poringFight_viewdata = {};
	self.poringFight_viewdata.rank = {};

	local myRank = 1;
	local myCharid = Game.Myself.data.id;
	local poringList = GameConfig.PoliFire and GameConfig.PoliFire.trans_buffid;

	local npclist = {};
	for i=1,#server_rank do
		local info = {};
		info.charid = server_rank[i].charid;
		info.index = server_rank[i].index;
		info.rank = server_rank[i].rank;
		info.name = server_rank[i].name;
		table.insert(self.poringFight_viewdata.rank, info);

		if(info.charid == myCharid)then
			myRank = info.rank;
		end
		local listdata = {};
		listdata.npcid = poringList and poringList[info.index].monster or 10001;
		listdata.name = info.name;
		npclist[info.rank] = listdata;
	end

	self.poringFight_viewdata.myRank = myRank or 1;

	if(server_rewards)then
		self.poringFight_viewdata.rewards = {};
		for i=1,#server_rewards do
			local reward = server_rewards[i];
			local item = ItemData.new(nil, reward.itemid);
			item.num = reward.count;
			table.insert(self.poringFight_viewdata.rewards, item)
		end
	end

	self.poringFight_viewdata.apple = server_apple;

	if(myRank == 9999)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.PoringFightResultView});
	else
		Game.PlotStoryManager:Start(1, nil, nil, PlotConfig_Prefix.Anim, npclist);
	end
end

function PvpProxy:GetPoringFight_viewdata()
	return self.poringFight_viewdata;
end

function PvpProxy:NtfMatchInfo(etype, ismatch, isfighting)
	if(etype == nil)then
		return;
	end
	if(self.matchStateMap == nil)then
		self.matchStateMap = {};
	end
	self.matchStateMap[etype] = {}
	self.matchStateMap[etype].ismatch = ismatch;
	self.matchStateMap[etype].isfighting = isfighting
end

function PvpProxy:GetMatchState(etype)
	if(self.matchStateMap == nil)then
		return nil;
	end
	return self.matchStateMap[etype];
end

function PvpProxy:GetNowMatchInfo()
	if(self.matchStateMap == nil)then
		return;
	end

	return next(self.matchStateMap);
end

function PvpProxy:Is_polly_match()
	local matchStatus = self:GetMatchState(PvpProxy.Type.MvpFight);
	if(matchStatus == nil)then
		return false;
	end
	return matchStatus.ismatch;
end

function PvpProxy:ClearMatchInfo()
	if(self.matchStateMap == nil)then
		return;
	end
	TableUtility.TableClear(self.matchStateMap);
end

function PvpProxy:RecvGodEndTime(endtime)
	self.godendtime = endtime;
end

function PvpProxy:GetGodEndTime()
	return self.godendtime;
end

function PvpProxy:GetMvpResult()
	return self.mvpResultList
end