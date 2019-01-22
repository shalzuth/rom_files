TeamProxy = class('TeamProxy', pm.Proxy)
TeamProxy.Instance = nil;
TeamProxy.NAME = "TeamProxy"

autoImport("MyselfTeamData");

TeamProxy.ExitType = {
	ServerExit = "TeamProxy_ExitType_ServerExit",
	ClearData = "TeamProxy_ExitType_ClearData",
}

function TeamProxy:ctor(proxyName, data)
	self.proxyName = proxyName or TeamProxy.NAME
	if(TeamProxy.Instance == nil) then
		TeamProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:InitTeamProxy();
end

function TeamProxy:InitTeamProxy()
	self.myTeam = nil;
	self.teamlst = {};
	self.quickEnterTime = 0;

	-- ????????????????????????
	self:InitTeamGoals();
end

function TeamProxy:InitTeamGoals()
	local fatherGoals = {};
	local childGoals = {};
	for k,v in pairs(Table_TeamGoals)do
		if(v.id ~= v.type)then
			local temp = childGoals[v.type];
			if(not temp)then
				temp = {};
				childGoals[v.type] = temp;
			end
			table.insert(temp, v);
		else
			table.insert(fatherGoals, v);
		end
	end
	self.goals = {};
	for k,v in pairs(fatherGoals)do
		local combine = {};
		combine.fatherGoal = v;
		combine.childGoals = childGoals[v.id];
		table.insert(self.goals, combine);
	end
	table.sort(self.goals, function (a,b)
		return a.fatherGoal.id<b.fatherGoal.id;
	end);
end

function TeamProxy:GetTeamGoals()
	local myself = Game.Myself;
	local mylv = myself.data.userdata:Get(UDEnum.ROLELEVEL);
	local result = {};
	for i=1,#self.goals do
		local v = self.goals[i];
		local newGoal = {};
		if(v.fatherGoal)then
			if(v.fatherGoal and v.fatherGoal.Level<=mylv)then
				newGoal.fatherGoal = v.fatherGoal;
				newGoal.childGoals = {};
				if(v.childGoals)then
					for ck,cv in pairs(v.childGoals)do
						if(cv.Level and cv.Level<=mylv)then
							table.insert(newGoal.childGoals, cv);
						end
					end
					table.sort(newGoal.childGoals, function (a,b) return a.id<b.id; end);
				end
				table.insert(result, newGoal);
			end
		end
	end
	return result;
end

function TeamProxy:CreateMyTeam(myTeamData)
	if(self.myTeam)then
		self:ExitTeam();
	end
	
	self.myTeam = MyselfTeamData.new();
	self.myTeam:SetData(myTeamData);

	if(self.myTeam.id ~= 0)then
		local myself = Game.Myself;
		myself.data:SetTeamID(self.myTeam.id);
	end
end

function TeamProxy:UpdateMyTeamData(summaryDatas, name, dojo)
	if(not self.myTeam)then
		errorLog("Not Find MyTeam (UpdateMyTeamData)");
		return;
	end

	self.myTeam:SetSummary(summaryDatas, name);
	if(dojo)then
		self.myTeam:SetDojo(data.dojo);
	end
end

function TeamProxy:LockTeamTarget(targetId)
	if(not self.myTeam)then
		errorLog("Not Find MyTeam (LockTeamTarget)");
		return;
	end

	self.myTeam.target = targetId;
end

function TeamProxy:UpdateTeamMember(updates, dels)
	if(not self.myTeam)then
		errorLog("Not Find MyTeam (UpdateMyTeamData)");
		return;
	end
	self.myTeam:SetMembers(updates);
	self.myTeam:RemoveMembers(dels);
end

function TeamProxy:UpdateMyTeamMemberData(memberid, memberData)
	if(not self.myTeam)then
		errorLog("I'm Not EnterTeam When Recv(UpdateMyTeamData)");
		return;
	end

	local teamMemberData = self.myTeam:GetMemberByGuid(memberid);
	if( teamMemberData )then
		local tempData = { guid = memberid, datas = memberData};
		self.myTeam:SetMember(tempData);
	else
		errorLog(string.format("Member:%s Not EnterTeam When Recv(MemberDataUpdate)", memberid));
	end
end

function TeamProxy:UpdateMyTeamApply(updates, dels)
	if(not self.myTeam)then
		errorLog("Not Find MyTeam (UpdateMyTeamData)");
		return;
	end

	self.myTeam:SetApplys(updates);
	self.myTeam:RemoveApplys(dels);

	-- local canAdd = self:CheckIHaveLeaderAuthority();
	-- local applyList = self.myTeam:GetApplyList();
	-- if(canAdd and #applyList > 0)then
	-- 	local isTeamFull = self.myTeam:IsTeamFull();
	-- 	if(not isTeamFull)then
	-- 		RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
	-- 	end
	-- else
	-- 	RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
	-- end
end

function TeamProxy:UpdateMyTeamMemberPos(id, pos)
	if(not self.myTeam)then
		errorLog("Not Find MyTeam (UpdateMyTeamMemberPos)");
		return;
	end

	local member = self.myTeam:GetMemberByGuid(id);
	if(not member)then
		errorLog(string.format("No Member In Team When Update Member Pos %s", id));
		return;
	end

	member:UpdatePos(pos);
end

function TeamProxy:SetMyHireTeamMembers(cats)
	if(self.myTeam)then
		self.myTeam:Server_SetHireTeamMembers(cats);
	end
end

function TeamProxy:RemoveMyHireTeamMembers(dels)
	if(self.myTeam)then
		self.myTeam:Server_RemoveHireTeamMembers(dels);
	end
end

function TeamProxy:ClearHireTeamMembers()
	if(self.myTeam)then
		self.myTeam:ClearHireTeamMembers();
	end
end

function TeamProxy:GetMyHireTeamMembers()
	if(self.myTeam)then
		return self.myTeam:GetHireTeamMembers();
	end
	return {};
end

function TeamProxy:ExitTeam(exitType)
	exitType = exitType or TeamProxy.ExitType.ServerExit;

	if(self.myTeam)then
		if(self.myTeam.id ~= 0)then
			local myself = Game.Myself;
			if(myself and myself.data) then
				myself.data:SetTeamID(self.myTeam.id);
			end
		end

		self.myTeam:Exit(exitType);
		self.myTeam = nil;
		-- remove RedTip
		-- RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
	end
	
	GameFacade.Instance:sendNotification(TeamEvent.ExitTeam, exitType);
	GameFacade.Instance:sendNotification(ServiceEvent.SessionTeamExitTeam, exitType);
end

function TeamProxy:IHaveTeam()
	return self.myTeam~=nil and self.myTeam.id~=0;
end

function TeamProxy:IsInMyTeam(playerid)
	if(self.myTeam)then
		return self.myTeam:GetMemberByGuid(playerid)~=nil;
	end
	return false;
end

function TeamProxy:CheckImTheLeader()
	local myMemberData = self:GetMyTeamMemberData();
	if(myMemberData)then
		return myMemberData.job == SessionTeam_pb.ETEAMJOB_LEADER;
	end
	return false;
end

function TeamProxy:CheckIHaveLeaderAuthority()
	local myMemberData = self:GetMyTeamMemberData();
	if(myMemberData)then
		return myMemberData.job == SessionTeam_pb.ETEAMJOB_LEADER 
		or myMemberData.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER;
	end
	return false;
end

function TeamProxy:GetMyTeamMemberData()
	if(not Game.Myself)then
		return;
	end
	if(not self.myTeam)then
		return;
	end
	return self.myTeam:GetMemberByGuid(Game.Myself.data.id);
end

function TeamProxy:UpdateAroundTeamList(list)
	self.aroundTeamList = {};
	for i=1,#list do
		local teamData = TeamData.new(list[i]);
		table.insert(self.aroundTeamList, teamData);
	end
end

function TeamProxy:GetAroundTeamList()
	return self.aroundTeamList;
end

function TeamProxy:SetItemImageUser(userid)
	self.imageUser = userid;
end

function TeamProxy:GetItemImageUser( )
	return self.imageUser;
end

function TeamProxy:SetQuickEnterTime( time )
	self.quickEnterTime = time;
end

function TeamProxy:IsQuickEntering( )
	if(self.quickEnterTime ~= nil)then
		return ServerTime.CurServerTime()/1000 < self.quickEnterTime
	end
	return false;
end

function TeamProxy:CheckIsCatByPlayerId(id)
	if(self.myTeam)then
		local memberData = self.myTeam:GetMemberByGuid(id);
		if(memberData and memberData.cat)then
			return memberData.cat ~= 0;
		end
	end
	return false;
end

function TeamProxy:GetCatMasterName(catid)
	if(self.myTeam)then
		local memberData = self.myTeam:GetMemberByGuid(catid);
		if(memberData)then
			return memberData.mastername;
		end
	end
end