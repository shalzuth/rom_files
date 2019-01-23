local BaseCell = autoImport("BaseCell");
TeamInviteMembCell = class("TeamInviteMembCell", BaseCell)

autoImport("PlayerFaceCell"); 

TeamInviteMemberType = {
	Friend = 1,
	GuildMember = 2,
	NearlyTeamMember = 3,
	MemberCat = 4,
}

function TeamInviteMembCell:Init()
	self:InitCell();
end

function TeamInviteMembCell:InitCell()
	local portrait = self:FindGO("Portrait");
	self.faceCell = PlayerFaceCell.new(portrait);
	self:AddClickEvent(portrait, function (go)
		if(self.data)then
			local type, sdata = self.data.type, self.data.data;
			local ptdata = PlayerTipData.new();
			local funckeys;
			if(type == TeamInviteMemberType.Friend or type == TeamInviteMemberType.NearlyTeamMember)then
				ptdata:SetByFriendData(sdata);
			elseif(type == TeamInviteMemberType.GuildMember)then
				ptdata:SetByGuildMemberData(sdata);
			elseif(type == TeamInviteMemberType.MemberCat)then
				funckeys = {"ShowDetail", "FireHireman"};
				ptdata:SetByTeamMemberData(sdata);
			end
			local tipData = {
				playerData = ptdata,
				funckeys = funckeys,
			};
			local sp = portrait:GetComponent(UIWidget);
			local playerTip = FunctionPlayerTip.Me():GetPlayerTip(sp, NGUIUtil.AnchorSide.Right);
			playerTip:SetData(tipData);
			playerTip.clickcallback = function (funcData)
				if(funcData.key == "SendMessage")then
					self.eventType = "CloseUI";
					self:PassEvent(MouseEvent.MouseClick, self);
				end
			end
		end
	end);

	self.name = self:FindComponent("Name", UILabel);
	self.lv = self:FindComponent("Lv", UILabel);
	self.pro = self:FindComponent("Pro", UILabel);

	self.restTip = self:FindGO("RestTip");
	self.restTime = self:FindComponent("RestTime", UILabel);

	self.inviteButton = self:FindGO("InviteButton");

	self:AddClickEvent(self.inviteButton, function (go)
		if(self.buttonActive)then
			self:PassEvent(MouseEvent.MouseClick, self);
			-- self:ActiveInviteButton(false);
		end
	end);

	self.inviteLabel = self:FindComponent("Label", UILabel, self.inviteButton);
end

function TeamInviteMembCell:SetData(data)
	self.data = data;
	if(data)then
		self:Show(self.gameObject);
		local sdata = data.data;
		if(data.type == TeamInviteMemberType.Friend or
			data.type == TeamInviteMemberType.NearlyTeamMember)then
			self.name.text = sdata.name;
			----[[ todo xde 不翻译玩家名字
			self.name.text = AppendSpace2Str(sdata.name)
			--]]
			local proData = sdata.profession and Table_Class[sdata.profession]
			if(proData)then
				self.lv.text = "Lv."..sdata.level;
				self.pro.text = proData.NameZh;
			end

			local headImageData = HeadImageData.new();
			headImageData:TransByFriendData(sdata);
			self.faceCell:SetData(headImageData);
		elseif(data.type == TeamInviteMemberType.GuildMember)then
			self.name.text = sdata.name;
			self.lv.text = "Lv."..sdata.baselevel;
			local proData = sdata.profession and Table_Class[sdata.profession]
			if(proData)then
				self.pro.text = proData.NameZh;
			end

			local headImageData = HeadImageData.new();
			headImageData:TransByGuildMemberData(sdata);
			self.faceCell:SetData(headImageData);

		elseif(data.type == TeamInviteMemberType.MemberCat)then
			self.name.text = sdata.name;
			self.lv.text = "Lv."..tostring(sdata.baselv);
			if(sdata:IsHireMember())then
				self.pro.text = string.format(ZhString.TeamInviteMembCell_MasterTip, sdata.mastername);
			else
				local proData = sdata.profession and Table_Class[sdata.profession]
				if(proData)then
					self.pro.text = proData.NameZh;
				end
			end
			UIUtil.WrapLabel (self.pro);

			local headImageData = HeadImageData.new();
			headImageData:TransByTeamMemberData(sdata);
			self.faceCell:SetData(headImageData);
		end
		
		local isInTeam = TeamProxy.Instance:IsInMyTeam(data.id);
		self:ActiveInviteButton(not isInTeam);

	else
		self:Hide(self.gameObject);
	end

	self:UpdateRestTip();
end

function TeamInviteMembCell:ActiveInviteButton(b, nosetlab)
	self.buttonActive = b;
	
	if(nosetlab ~= true)then
		self.inviteLabel.text = b and ZhString.TeamInviteMembCell_Invite or ZhString.TeamInviteMembCell_Invited;
	end
	if(b)then
		self:SetTextureColor(self.inviteButton, Color(1,1,1));
	else
		self:SetTextureGrey(self.inviteButton);
	end
end

function TeamInviteMembCell:UpdateRestTip()
	if(self.data == nil or TeamInviteMemberType.MemberCat ~= self.data.type)then
		self:RemoveRestTimeTick();
		self.eventType = "Invite";
		self.restTip:SetActive(false);
		return;
	end

	local sdata = self.data.data;
	local expiretime = sdata.expiretime;

	local curtime = ServerTime.CurServerTime()/1000;
	if(expiretime~=0 and curtime >= expiretime)then
		self.eventType = "Hire";

		self.faceCell:SetIconActive(false);
		
		self.restTip:SetActive(true);
		self.restTime.text = ZhString.TeamInviteMembCell_ExpireTime;

		self.inviteLabel.text = ZhString.TeamInviteMembCell_ReHire;
		if(sdata.masterid ~= Game.Myself.data.id)then
			self:ActiveInviteButton(false, true);
		end
	else
		self.eventType = "Invite";

		local resttime = sdata and sdata.resttime;
		resttime = resttime or 0;
		local restSec = resttime - curtime;
		if(restSec > 0)then
			self.restTip:SetActive(true);

			if(not self.restTimeTick)then
				self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRestTime, self)
			end
			self.faceCell:SetIconActive(false);
		else
			self.restTip:SetActive(false);

			self:RemoveRestTimeTick();
		end
	end
end

function TeamInviteMembCell:UpdateRestTime()
	local sdata = self.data.data;
	local resttime = sdata and sdata.resttime;
	resttime = resttime or 0;
	local restSec = resttime - ServerTime.CurServerTime()/1000;
	if(restSec > 0)then
		local min,sec = ClientTimeUtil.GetFormatSecTimeStr( restSec )
		self.restTime.text = string.format(ZhString.TeamInviteMembCell_RestTime, min , sec)
	else
		self:RemoveRestTimeTick();
	end
end

function TeamInviteMembCell:RemoveRestTimeTick()
	if(self.restTimeTick)then
		TimeTickManager.Me():ClearTick(self, 1)
		self.restTimeTick = nil;

		self.faceCell:SetIconActive(true);
		self.restTime.text = "";
	end
end

function TeamInviteMembCell:OnRemove()
	self:RemoveRestTimeTick();
end


