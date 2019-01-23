autoImport("PvpTeamData");

PvpRoomData = class("PvpRoomData");

local Room_MaxIndex = 3;

function PvpRoomData:ctor(guid)
	self.guid = guid

	self.teamList = {};
	for i=1,Room_MaxIndex do
		self.teamList[i] = PvpTeamData.new();
		self.teamList[i]:SetIndex(i);
	end

	self.endtime = 0;
end

function PvpRoomData:SetData(roomBriefInfo)
	self.state = roomBriefInfo.state
	self.roomid = roomBriefInfo.roomid
	self.zoneid = roomBriefInfo.zoneid
	self.name = roomBriefInfo.name;
	self.player_num = roomBriefInfo.player_num;
	self.type = roomBriefInfo.type;

	for i=1,Room_MaxIndex do
		local tmData = self.teamList[i];
		local memberNum = roomBriefInfo["num"..i];
		tmData:SetMemberNum(memberNum);
	end
end

function PvpRoomData:SetRoomDetailInfo(roomDetailInfo)
	local matchTeamDatas = roomDetailInfo.team_datas;

	for i=1,Room_MaxIndex do
		self.teamList[i]:ResetMembersData();
	end
	for i=1,#matchTeamDatas do
		local matchTeamData = matchTeamDatas[i];
		local index = matchTeamData.index;

		local teamData = self.teamList[index];
		if(teamData)then
			teamData:SetMatchTeamData(matchTeamData);
		end
	end
end

function PvpRoomData:RemoveTeamByGuid(guid)
	for i=Room_MaxIndex,1,-1 do
		local teamData = self.teamList[i];
		helplog("RemoveTeamByGuid", guid, teamData.id);
		if(teamData.id == guid)then
			teamData:ResetMembersData();
		end
	end
end

function PvpRoomData:GetTeamMemberNumByPos(pos)
	local teamData = self.teamList[pos];
	if(teamData)then
		return teamData.memberNum;
	end
end

function PvpRoomData:GetRoomTeamList()
	return self.teamList;
end

function PvpRoomData:GetRoomTeamDataByPos(pos)
	return self.teamList[pos]
end

function PvpRoomData:IsFull()
	local isFull = true;
	for i=1,Room_MaxIndex do
		local teamData = self.teamList[i];
		if(teamData.memberNum == 0)then
			isFull = false;
			break;
		end
	end
	return isFull;
end

function PvpRoomData:SetIndex(index)
	self.index = index;
end

function PvpRoomData:GetZoneString()
	if self.zoneid then
		local zoneid = self.zoneid % 10000
		return ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
	end

	return 0
end

function PvpRoomData:GetTeamByGuid(guid)
	for i=1,#self.teamList do
		if(self.teamList[i].id == guid)then
			return self.teamList[i];
		end
	end
end

function PvpRoomData:SetEndTime(endtime)
	self.endtime = endtime;
end

function PvpRoomData:GetEndTime()
	return self.endtime;
end

--TestSet
function PvpRoomData:TestSetRoomDetail()
	local matchTeamData1 = 
	{
		guid = 100001,
		zoneid = 1,
		name = "TestTeam1",
		index = 2,
		members = 
		{
			{
				guid = 1000011,
				name = "Test_Member1",
				datas = 
				{
					{type = SessionTeam_pb.EMEMBERDATA_PROFESSION, value = 13},				
					{type = SessionTeam_pb.EMEMBERDATA_PORTRAIT, value = 56005},	
					{type = SessionTeam_pb.EMEMBERDATA_BASELEVEL, value = 13},
				},
			},
			{
				guid = 1000012,
				name = "Test_Member2",
				datas = 
				{
					{type = SessionTeam_pb.EMEMBERDATA_PROFESSION, value = 13},				
					{type = SessionTeam_pb.EMEMBERDATA_PORTRAIT, value = 56005},	
					{type = SessionTeam_pb.EMEMBERDATA_BASELEVEL, value = 41},
				},
			},
		},
	};
	local testServerData = 
	{
		guid = self.guid,
		name = self.name,
		team_datas = {
			matchTeamData1,
		},
	};

	self:SetRoomDetailInfo(testServerData);
end

function PvpRoomData:OnRemove()
end
