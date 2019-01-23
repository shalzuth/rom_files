FunctionTeam = class("FunctionTeam")

FunctionTeam.EndlessTowerID = 31

function FunctionTeam.Me()
	if nil == FunctionTeam.me then
		FunctionTeam.me = FunctionTeam.new()
	end
	return FunctionTeam.me
end

function FunctionTeam:ctor()
	self.canInviteFollow = true;
end

function FunctionTeam:ChangeRepairSealGoal()
	local sealDailyTime = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_SEAL);
	sealDailyTime = sealDailyTime or 0;
	if(sealDailyTime == GameConfig.Seal.maxSealNum)then
		FunctionTeam.Me():ChangeTeamGoal( TeamGoalType.Around );
	elseif(sealDailyTime < GameConfig.Seal.maxSealNum)then
		local sealId = SealProxy.Instance.nowAcceptSeal;
		local repairSealData = sealId and Table_RepairSeal[sealId];
		if(repairSealData)then
			local goalId = repairSealData.TeamGoal;
			if(goalId == nil or Table_TeamGoals[goalId] == nil)then
				goalId = TeamGoalType.RepairSeal;
			end
			FunctionTeam.Me():ChangeTeamGoal( goalId );
		end
	end
end

function FunctionTeam:ChangeEndlessTowerGoal()
	local curlayer = EndlessTowerProxy.Instance.curChallengeLayer;
	if(curlayer)then
		local teamGoal = 0;
		if(curlayer>0 and curlayer<=20)then
			teamGoal = 10101;
		elseif(curlayer>20 and curlayer<=40)then
			teamGoal = 10102;
		elseif(curlayer>40 and curlayer<=60)then
			teamGoal = 10103;
		elseif(curlayer>60)then
			teamGoal = 10104;
		elseif(curlayer>80)then
			teamGoal = 10105;
		end
		if(teamGoal~=0)then
			FunctionTeam.Me():ChangeTeamGoal( teamGoal );
		end
	end
end

function FunctionTeam:CheckChangeTeamGoal()
	if(not TeamProxy.Instance:IHaveTeam())then
		return;
	end

	local myTeam = TeamProxy.Instance.myTeam;
	if(myTeam)then
		local goalId = myTeam.type;
		local goalData = Table_TeamGoals[goalId];
		if(not Game.MapManager:IsRaidMode())then
			if(goalData.type == TeamGoalType.Laboratory or
				goalData.type == TeamGoalType.Dojo)then

				self:ChangeTeamGoal( TeamGoalType.Around );

			elseif(goalData.type == TeamGoalType.EndlessTower)then
				-- 无限塔在恩德勒斯岛的时候不需要改变目标
				if(Game.MapManager:GetMapID() ~= FunctionTeam.EndlessTowerID )then
					self:ChangeTeamGoal( TeamGoalType.Around );
				end
			end
		else
			local mapid = Game.MapManager:GetMapID();
			local raidData = Table_MapRaid[mapid];

			if(raidData.Type == FunctionDungen.LaboratoryType)then
				FunctionTeam.Me():ChangeTeamGoal( TeamGoalType.Laboratory );
			elseif(raidData.Type == FunctionDungen.DojoType)then
				FunctionTeam.Me():ChangeTeamGoal( TeamGoalType.Dojo );
			elseif(raidData.Type == FunctionDungen.EndlessTowerType)then
				self:ChangeEndlessTowerGoal();
			end
		end
	end
end

function FunctionTeam:ChangeTeamGoal( goalId )
	if( not TeamProxy.Instance:CheckIHaveLeaderAuthority() )then
		return;
	end

	local myTeam = TeamProxy.Instance.myTeam;
	if(myTeam and myTeam.type ~= goalId)then
		local changeOption = {};
		local newGoal = {
			type = SessionTeam_pb.ETEAMDATA_TYPE,
			value = goalId,
		};
		table.insert(changeOption, newGoal);
		ServiceSessionTeamProxy.Instance:CallSetTeamOption(nil, changeOption);
	end
end

function FunctionTeam:InviteMemberFollow()
	self:TryInviteMemberFollow();
end

function FunctionTeam:TryInviteMemberFollow(charid, follow)
	if(TeamProxy.Instance:IHaveTeam())then
		local myTeam = TeamProxy.Instance.myTeam;
		local memberlist = myTeam:GetMembersList();
		if(#memberlist > 1)then
			self:DoInviteMemberFollow(charid, follow);
		else
			MsgManager.ShowMsgByIDTable(345)
		end
	end
end

function FunctionTeam:DoInviteMemberFollow(charid, follow)
	if(follow == false)then
		ServiceNUserProxy.Instance:CallInviteFollowUserCmd(charid, follow)
		return;
	end

	if(self.canInviteFollow)then
		self.canInviteFollow = false;
		MsgManager.ShowMsgByIDTable(342)
		ServiceNUserProxy.Instance:CallInviteFollowUserCmd(charid, follow)

		if(self.inviteFollow_LT)then
			self.inviteFollow_LT:cancel();
			self.inviteFollow_LT = nil;
		end
		self.inviteFollow_LT = LeanTween.delayedCall(20, function ()
			self.canInviteFollow = true;
		end);
	else
		MsgManager.ShowMsgByIDTable(343)
	end
end

function FunctionTeam:MyTeamJobChange(newjob)
	if(newjob~=SessionTeam_pb.ETEAMJOB_LEADER or newjob~=SessionTeam_pb.ETEAMJOB_TEMPLEADER)then
		RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
		TeamProxy.Instance.myTeam:ClearApplyList();
	end
end














