autoImport("TeamMemberData");

TeamData = class("TeamData")

TeamData.INVALID_TEAMID = 0

TeamGoalType = {
	Around = 10010,
	EndlessTower = 10100,
	Laboratory = 10200,
	Dojo = 10300,
	RepairSeal = 10400,
}

TeamSummaryType = {
	-- [SessionTeam_pb.ETEAMDATA_ID] = "id",
	[SessionTeam_pb.ETEAMDATA_TYPE] = "type",
	[SessionTeam_pb.ETEAMDATA_MINLV] = "minlv",
	[SessionTeam_pb.ETEAMDATA_MAXLV] = "maxlv",
	[SessionTeam_pb.ETEAMDATA_OVERTIME] = "overtime",
	[SessionTeam_pb.ETEAMDATA_MEMBERCOUNT] = "membercount",
	[SessionTeam_pb.ETEAMDATA_AUTOACCEPT] = "autoaccept",
	[SessionTeam_pb.ETEAMDATA_PICKUP_MODE] = "pickupmode",
}

function TeamData:ctor(teamData)
	self.name = "No TeamName";
	self.membersMap = {};
	self.memberList = {};
	self.memberNum = 0;

	self.applysMap = {};
	self:SetData(teamData);
end

function TeamData:SetData(teamData)
	if(teamData)then
		self.id = teamData.guid;
		if(teamData.items)then
			self:SetSummary(teamData.items, teamData.name);
		end
		self:SetMembers(teamData.members);
		self:SetApplys(teamData.applys);
	end
end

function TeamData:SetSummary(summaryes, name)
	if(name and name~="")then
		self.name = name;
		--[[
			todo xde RecvEnterTeam???????????? oiusn_?????????
			??????????????????, ??????????????????????????????
		]]
		if string.match(tostring(self.name), '_?????????') then
			local suffix = "_?????????"
			local partyName = self.name:gsub(suffix, "")
			self.name = partyName .. OverSea.LangManager.Instance():GetLangByKey(suffix)
		end

	end
	-- local updateStr = "TeamData: | name:";
	-- updateStr = updateStr..self.name.." | ";
	for i=1,#summaryes do
		local item = summaryes[i];
		if(item and item.type)then
			local key = TeamSummaryType[item.type];
			if(key)then
				self[key] = item.value;
				-- updateStr = updateStr..string.format("%s:%s | ", key, tostring(item.value));
			end
		end
	end
	-- helplog(updateStr);
end

function TeamData:SetSeal(teamSealData)

end

function TeamData:SetMembers(datas)
	for i=1,#datas do
		self:SetMember(datas[i]);
	end
end

function TeamData:SetMember(data)
	local member = self:GetMemberByGuid(data.guid);
	if(not member)then
		member = self:AddMember(data);
	else
		member:SetData(data);
	end
	return member;
end

function TeamData:AddMember(data)
	if(data and data.guid)then
		self.memberList_dirty = true;

		local newMember = TeamMemberData.new(data);
		self.membersMap[data.guid] = newMember;
		self.memberNum = self.memberNum+1;
		-- TeamData.SetTeamIdToPlayer(data.guid,self.id,self.name)
		return newMember;
	end
end

function TeamData:RemoveMembers(deletelst)
	for i=1,#deletelst do
		self:RemoveMember(deletelst[i]);
	end
end

function TeamData:RemoveMember(guid)
	local catchMember = self:GetMemberByGuid(guid);
	if(catchMember)then
		self.memberList_dirty = true;

		self.membersMap[guid] = nil;
		self.memberNum = self.memberNum-1;
		-- TeamData.SetTeamIdToPlayer(guid,TeamData.INVALID_TEAMID,self.name)
	end
	return catchMember;
end

function TeamData:GetMemberByGuid(guid)
	return self.membersMap[guid];
end

function TeamData:IsTeamFull()
	local memberList = self:GetMembersList();
	local memNum = 0;
	for i=1,#memberList do
		if(not memberList[i]:IsHireMember())then
			memNum = memNum + 1;
		end
	end
	return memNum >= 5;
end

function TeamData:GetMembersList()
	if(self.memberList_dirty)then
		self.memberList_dirty = false;

		TableUtility.ArrayClear(self.memberList);
		
		for _,v in pairs(self.membersMap)do
			table.insert(self.memberList, v);
		end
		table.sort(self.memberList, TeamData.SortTeamMember);
	end
	return self.memberList;
end

function TeamData.SortTeamMember(ma, mb)
	if(ma.id ~= mb.id)then
		return ma.id < mb.id;
	end
	if(ma.cat ~= nil and mb.cat ~= nil)then
		return ma.cat < mb.cat;
	end
	return false;
end

function TeamData:GetMemberMap()
	return self.membersMap;
end

function TeamData:SetApplys(applys)
	for i=1,#applys do
		self:SetApply(applys[i]);
	end
end

function TeamData:SetApply(apply)
 	local catchApply = self:GetApplyByGuid(apply.guid);
	if(not catchApply)then
		catchApply = self:AddApply(apply); 
	else
		catchApply:SetData(apply);
	end
	return catchApply;
end

function TeamData:AddApply(apply)
	if(apply and apply.guid)then
		local catchApply = TeamMemberData.new(apply);
		self.applysMap[apply.guid] = catchApply;
		return catchApply;
	end
end

function TeamData:RemoveApplys(deletelst)
	for i=1,#deletelst do
		self:RemoveApply(deletelst[i]);
	end
end

function TeamData:RemoveApply(guid)
	local catchApply = self:GetApplyByGuid(guid);
	if(catchApply)then
		self.applysMap[guid] = nil;
	end
	return catchApply;
end

function TeamData:GetApplyByGuid(guid)
	return self.applysMap[guid];
end

function TeamData:GetApplyList()
	local result = {};
	for k,v in pairs(self.applysMap) do
		table.insert(result, v);
	end
	return result;
end

function TeamData:ClearApplyList()
	TableUtility.TableClear(self.applysMap);
end

function TeamData:GetLeader()
	for _,mdata in pairs(self.membersMap)do
		if(mdata.job == SessionTeam_pb.ETEAMJOB_LEADER)then
			return mdata;
		end
	end
end

function TeamData:GetTempLeader()
	for _,mdata in pairs(self.membersMap)do
		if(mdata.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER)then
			return mdata;
		end
	end
end

function TeamData:GetNowLeader()
	local leader = self:GetLeader();
	if(leader and leader.offline==0)then
		return leader;
	end
	return self:GetTempLeader();
end

function TeamData:CheckInTeam(playerid)
	return self.membersMap[playerid] ~= nil;
end

function TeamData:ClearTeamMembers()
	for key,member in pairs(self.membersMap)do
		member:Exit();
		self.membersMap[key] = nil;
	end
end

function TeamData:Exit()
	self:ClearTeamMembers();
end










