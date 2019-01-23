SceneGuildDoor = class("SceneGuildDoor", SubView);

function SceneGuildDoor:Init()
	self:MapListenEvent();
end

function SceneGuildDoor:UpdateGuildGateInfoByRole(role)
	local roleid = role.data.id;
	local gatedata = GuildProxy.Instance:GetGuildGateInfoByNpcId(roleid);
	if(gatedata)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			if(gatedata.state == Guild_GateState.Lock)then
				sceneUI.roleTopUI:RemoveGuildGateInfo();
			else
				local level, killedbossnum, haveteamer = gatedata.level, gatedata.killedbossnum, false;
				local groupindex = gatedata.groupindex;
				if(groupindex and groupindex~=0)then
					local myTeam = TeamProxy.Instance.myTeam;
					if(myTeam)then
						local myMembers = myTeam:GetMembersList();
						for i=1,#myMembers do
							local memberData = myMembers[i];
							local memberIndex = memberData.guildraidindex;
							if(memberIndex and math.floor(memberIndex/1000) == groupindex)then
								haveteamer = true;
								break;
							end
						end
					end
				end
				if(level == nil or level == 0)then
					local config = GameConfig.GuildRaid;
					local npcid = role.data.staticData.id;
					if(config and config[npcid] and config[npcid].Level)then
						level = config[npcid].Level[1];
					end
				end
				sceneUI.roleTopUI:SetGuildGateInfo(level, killedbossnum, haveteamer);
			end
		end
	end
end

function SceneGuildDoor:MapListenEvent()
	self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcRole)
	self:AddListenEvt(ServiceEvent.FuBenCmdUserGuildRaidFubenCmd, self.HandleUserGuildRaidFubenCmd)
	-- self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleSceneRemoveNpcs)

	self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.HandleGateTeamUpdate);
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleGateTeamUpdate);
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleGateTeamUpdate);
	self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.HandleGateTeamUpdate);
end

function SceneGuildDoor:HandleAddNpcRole(note)
	local npcs = note.body;
	for _,role in pairs(npcs)do
		self:UpdateGuildGateInfoByRole(role);
	end
end

function SceneGuildDoor:HandleUserGuildRaidFubenCmd(note)
	local gatedatas = note.body.gatedata;
	for i=1,#gatedatas do
		local data = gatedatas[i];
		local role = NSceneNpcProxy.Instance:Find(data.gatenpcid);
		if(role)then
			self:UpdateGuildGateInfoByRole(role);
		end
	end
end

-- 可优化
function SceneGuildDoor:HandleGateTeamUpdate(note)
	local guildMap = GuildProxy.Instance:GetGuildGateInfoMap();
	for npcguid, gatedata in pairs(guildMap)do
		local role = NSceneNpcProxy.Instance:Find(npcguid);
		if(role)then
			self:UpdateGuildGateInfoByRole(role);
		end
	end
end
