local BaseCell = autoImport("BaseCell");
TeamCell = class("TeamCell", BaseCell);

function TeamCell:Init()
	self.goal = self:FindComponent("Goal", UILabel);
	self.level = self:FindComponent("Level", UILabel);
	self.teamName = self:FindComponent("TeamName", UILabel);
	self.leaderName = self:FindComponent("LeaderName", UILabel);
	self.memberNum = self:FindComponent("MemberNum", UILabel);

	self.numSlider = self:FindComponent("NumSlider", UISlider);
	self.applyBtn = self:FindGO("ApplyButton");
	self.applyed = self:FindGO("Applyed");
	self.applyLabel = self:FindComponent("Label", UILabel, self.applyBtn);

	self:AddClickEvent(self.applyBtn, function (go)
		if(self.data)then
			self.applied = not self.applied;
			ServiceSessionTeamProxy.Instance:CallTeamMemberApply(self.data.id);
			self:SetButtonEnable(not self.applied);
		end
	end);
end

function TeamCell:SetButtonEnable(isEnabled)
	self.applyed:SetActive(not isEnabled);
	self.applyBtn:SetActive(isEnabled);
end

function TeamCell:SetData(data)
	self.data = data;
	if(data)then
		self.gameObject:SetActive(true);

		if(data.type and Table_TeamGoals[data.type])then
			self.goal.text = Table_TeamGoals[data.type].NameZh;
		end
		local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL);
		local islvOutRange = mylv < data.minlv or mylv > data.maxlv;
		if(islvOutRange)then
			self.level.text = string.format("[c][ff0000]Lv.%s ~ Lv.%s[-][/c]", tostring(data.minlv), tostring(data.maxlv));
		else
			self.level.text = string.format("Lv.%s ~ Lv.%s" , tostring(data.minlv), tostring(data.maxlv));
		end
		self.teamName.text = data.name;
		local leader = data:GetLeader();
		if(leader)then
			self.leaderName.text = leader.name;
		end
		local membercount = data.membercount or 1;
		self.memberNum.text =string.format("%d/%d", membercount, GameConfig.Team.maxmember);
		self.numSlider.value = membercount/GameConfig.Team.maxmember;

		self.applied = false;
		self:SetButtonEnable(not self.applied);
	else
		self.gameObject:SetActive(false);
	end
end