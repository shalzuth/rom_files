autoImport("TeamData");

PvpTeamData = class("PvpTeamData", TeamData)

PvpHeadData_Empty = 0;

function PvpTeamData:ctor(teamData)
	PvpTeamData.super.ctor(self, teamData);
	
	self.memberNum = 0;
end

function PvpTeamData:SetIndex(index)
	self.index = index;
end

function PvpTeamData:SetMemberNum(num)
	self.memberNum = num or 0;
end

function PvpTeamData:SetMatchTeamData(matchTeamData)
	self.name = matchTeamData.name;
	self.id = matchTeamData.teamid;
	self.roomid = matchTeamData.roomid;
	self.zoneid = matchTeamData.zoneid;

	self:SetMembers(matchTeamData.members);
end

function PvpTeamData:ResetMembersData()
	for id,_ in pairs(self.membersMap)do
		self:RemoveMember(id);
	end

	self.name = "";
	self.roomid = 0;
	self.zoneid = 0;
	self.memberNum = 0;
end

function PvpTeamData:GetMemberHeadImageDatas()
	local teamMembers = self:GetMembersList();
	if(not self.headDatas)then
		self.headDatas = {};
	else
		TableUtility.ArrayClear(self.headDatas);
	end
	for i=1,5 do
		local headData = self.headDatas[i];
		local teamMemberData = teamMembers[i];
		if(teamMemberData)then
			if(headData == nil)then
				headData = HeadImageData.new();
				self.headDatas[i] = headData;
			end
			headData:TransByTeamMemberData(teamMemberData);
		else
			self.headDatas[i] = PvpHeadData_Empty;
		end
	end

	return self.headDatas
end