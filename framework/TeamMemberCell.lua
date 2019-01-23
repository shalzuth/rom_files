local BaseCell = autoImport("BaseCell");
TeamMemberCell = class("TeamMemberCell", BaseCell)

autoImport("PlayerFaceCell");

function TeamMemberCell:Init()
	local portrait = self:FindGO("TeamPortrait");
	self.portraitCell = PlayerFaceCell.new(portrait);
	self.portraitCell:AddEventListener(MouseEvent.MouseClick, self.ClickHead, self);
	self.portraitCell:SetMinDepth(4);

	self.lv = self:FindComponent("Lv", UILabel);
	self.name = self:FindComponent("Name", UILabel);
	self.mapname = self:FindComponent("MapName", UILabel);
	self.bg = self:FindComponent("Bg", UISprite);
	self.zoneId = self:FindComponent("ZoneId", UILabel);
	self.roleTexture = self:FindComponent("RoleTexture", UITexture);
	self.restTip = self:FindGO("RestTip");
	self.restTime = self:FindComponent("RestTime", UILabel);
	self.following = self:FindGO("Following");
	self.inviteFollow = self:FindGO("InviteFollow");

	self.memberState = self:FindGO("MemberState");
	self.addState = self:FindGO("AddState");
	self.addButton = self:FindGO("AddButton");
	self:AddClickEvent(self.addButton, function ()
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamInvitePopUp});
	end);

	self:AddClickEvent(self.inviteFollow, function ()
		if(self.data and self.data ~= MyselfTeamData.EMPTY_STATE)then
			FunctionTeam.Me():TryInviteMemberFollow(self.data.id, true);
		end
	end);
	self.cancelInviteFollow = self:FindGO("CancelInviteFollow");
	self:AddClickEvent(self.cancelInviteFollow, function (go)
		if(self.data and self.data ~= MyselfTeamData.EMPTY_STATE)then
			FunctionTeam.Me():TryInviteMemberFollow(self.data.id, false);
		end
	end);

	self:AddIconEvent();
end

function TeamMemberCell:ClickHead()
	self:PassEvent(MouseEvent.MouseClick, self);
end

function TeamMemberCell:SetData(data)
	self:ActiveCatRestTip(false);

	self.data = data;
	if(data == MyselfTeamData.EMPTY_STATE)then
		self.addState:SetActive(true);
		self.memberState:SetActive(false);
	elseif(data ~= nil)then
		self.addState:SetActive(false);
		self.memberState:SetActive(true);

		self.lv.text = "Lv."..tostring(data.baselv);
		self.name.text = data.name;
		----[[ todo xde 不翻译玩家名字
		self.name.text = AppendSpace2Str(data.name)
		--]]

		local headData = HeadImageData.new();
		headData:TransByTeamMemberData(data);
		self.portraitCell:SetData(headData);

		local isCat = data:IsHireMember();
		local isOnline = not data:IsOffline();
		local isSameline = data.zoneid==MyselfProxy.Instance:GetZoneId();

		if(isCat)then
			self.mapname.gameObject:SetActive(true);
			self.mapname.text = string.format(ZhString.TeamMemberListPopUp_HireTip, tostring(data.mastername));
		else
			if(isOnline)then
				if(isSameline)then
					self.mapname.gameObject:SetActive(true);
					local data = data.mapid and Table_Map[data.mapid]
					self.mapname.text = data and data.NameZh or "";
				else
					self.mapname.gameObject:SetActive(false);
				end
			else
				self.mapname.gameObject:SetActive(true);
				self.mapname.text = ZhString.TeamMemberCell_Offline;
			end
		end

		if(not isCat and isOnline and not isSameline)then
			self.zoneId.gameObject:SetActive(true);

			self.zoneId.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid); -- ZhString.TeamMemberCell_line
		else
			self.zoneId.gameObject:SetActive(false);
		end

		if(isOnline)then
			if(isCat)then
				self:UpdateRestTip();
			else
				self.portraitCell:SetIconActive(true, true)
			end
		else
			self.portraitCell:SetIconActive(false, true)
		end

		self:UpdateRoleTexture();
	end

	self:UpdateFollow();
end

-- 待优化
function TeamMemberCell:UpdateRoleTexture()
	local parts = Asset_Role.CreatePartArray();

	local partIndex = Asset_Role.PartIndex;
	local partIndexEx = Asset_Role.PartIndexEx;
	if(self.data.id == Game.Myself.data.id)then
		local userdata = Game.Myself.data.userdata;
		parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0;
		parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0;
		parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0;
		parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0;
		parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0;
		parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0;
		parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0;
		parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0;
		parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0;
		parts[partIndex.Mount] = 0
		parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0;

		parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0;
		parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0;
		parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0;
		parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
	else
		parts[partIndex.Body] = self.data.body or 0
		parts[partIndex.Hair] = self.data.hair or 0
		parts[partIndex.LeftWeapon] = self.data.rightWeapon or 0
		parts[partIndex.RightWeapon] = self.data.leftWeapon or 0
		parts[partIndex.Head] = self.data.head or 0
		parts[partIndex.Wing] = self.data.back or 0
		parts[partIndex.Face] = self.data.face or 0
		parts[partIndex.Tail] = self.data.tail or 0
		parts[partIndex.Eye] = self.data.eye or 0
		parts[partIndex.Mount] = 0
		parts[partIndex.Mouth] = self.data.mouth or 0

		parts[partIndexEx.Gender] = self.data.gender or 0
		parts[partIndexEx.HairColorIndex] = self.data.haircolor or 0
		parts[partIndexEx.BodyColorIndex] = self.data.bodycolor or 0
	end
	
	UIModelUtil.Instance:SetRoleModelTexture(self.roleTexture, parts, UIModelCameraTrans.Team)

	Asset_Role.DestroyPartArray(parts);
end

function TeamMemberCell:UpdateRestTip()
	local resttime, expiretime = 0,0;
	if(self.data)then
		resttime = self.data.resttime or 0;
		expiretime = self.data.expiretime or 0;
	end

	local curtime = ServerTime.CurServerTime()/1000;

	if(expiretime~=0 and curtime >= expiretime)then
		self.restTip:SetActive(true);
		self.portraitCell:SetIconActive(false);
		
		self.restTime.text = ZhString.TeamMemberCell_Expire;
	else
		self:ActiveCatRestTip(resttime~=0 and resttime > curtime);
	end
end

function TeamMemberCell:ActiveCatRestTip(b)
	if(b)then
		self.restTip:SetActive(true);
		self.portraitCell:SetIconActive(false);

		if(not self.restTimeTick)then
			self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRestTime, self)
		end
	else
		self.restTip:SetActive(false);
		self.portraitCell:SetIconActive(true);
		self:RemoveRestTimeTick();
	end
end

function TeamMemberCell:UpdateRestTime()
	local resttime = self.data and self.data.resttime;
	resttime = resttime or 0;
	local restSec = resttime - ServerTime.CurServerTime()/1000;
	if(restSec > 0)then
		local min,sec = ClientTimeUtil.GetFormatSecTimeStr( restSec )
		self.restTime.text = ZhString.TeamMemberCell_CatRest .. string.format("%02d:%02d", min , sec)
	else
		self:ActiveCatRestTip(false);
	end
end

function TeamMemberCell:RemoveRestTimeTick()
	if(self.restTimeTick)then
		TimeTickManager.Me():ClearTick(self, 1)
		self.restTimeTick = nil;
	end
end

function TeamMemberCell:UpdateFollow()
	if(self.data == MyselfTeamData.EMPTY_STATE or self.data == nil)then
		self.following:SetActive(false);
		self.inviteFollow:SetActive(false);
		return;
	end

	if(not TeamProxy.Instance:CheckIHaveLeaderAuthority())then
		self.following:SetActive(false);
		self.inviteFollow:SetActive(false);
		return;
	end

	if(self.data:IsHireMember())then
		self.following:SetActive(false);
		self.inviteFollow:SetActive(false);
		return;
	end

	if(self.data.id == Game.Myself.data.id)then
		self.following:SetActive(false);
		self.inviteFollow:SetActive(false);
		return;
	end

	if(self.data:IsOffline())then
		self.following:SetActive(false);
		self.inviteFollow:SetActive(false);
		return;
	end

	local followers = Game.Myself:Client_GetAllFollowers()
	if(followers == nil)then
		self.following:SetActive(false);
		self.inviteFollow:SetActive(false);
		return;
	end

	if(not followers[ self.data.id ])then
		self.inviteFollow:SetActive(true);
		self.following:SetActive(false);
	else
		self.inviteFollow:SetActive(false);
		self.following:SetActive(true);
	end
end

function TeamMemberCell:UpdateMemberPos()
end

function TeamMemberCell:AddIconEvent()
	if(self.portraitCell)then
		self.portraitCell:AddIconEvent();
	end
end

function TeamMemberCell:RemoveIconEvent()
	if(self.portraitCell)then
		self.portraitCell:RemoveIconEvent();
	end
end

function TeamMemberCell:OnRemove()
	self:RemoveRestTimeTick();
	self:RemoveIconEvent();
end
