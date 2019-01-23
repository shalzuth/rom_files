PlayerTipData = class("PlayerTipData")

function PlayerTipData:ctor()
end

function PlayerTipData:SetByCreature(creature)
	self.id = creature.data.id;

	self.level = creature.data.userdata:Get(UDEnum.ROLELEVEL);

	self.name = creature.data.name;
	local guildData = creature.data.guildData;
	if(guildData)then
		self.guildid = guildData.id;
		self.guildname = guildData.name;
	end

	self.headData = HeadImageData.new();
	self.headData:TransByLPlayer(creature);

	self.zoneid = creature.data.userdata:Get(UDEnum.ZONEID) or MyselfProxy.Instance:GetZoneId()
end

function PlayerTipData:SetByFriendData(frienddata)
	self.id = frienddata.guid;
	self.name = frienddata.name;
	self.level = frienddata.level;
	self.guildname = frienddata.guildname;
	self.zoneid = frienddata.zoneid;

	self.headData = HeadImageData.new();
	self.headData:TransByFriendData(frienddata);
	
	-- 离线时间
	self.offlinetime = frienddata.offlinetime
end

function PlayerTipData:SetByTeamMemberData(teamMemberData)
	self.id = teamMemberData.id;
	self.name = teamMemberData.name;
	if(teamMemberData.cat and teamMemberData.cat~=0)then
		self.cat = teamMemberData.cat;
		self.expiretime = teamMemberData.expiretime;
	else
		self.cat = nil;
		self.expiretime = nil;
	end

	if(teamMemberData:IsHireMember())then
		self.mastername = teamMemberData.mastername;
		self.masterid = teamMemberData.masterid;
	else
		self.guildname = teamMemberData.guildname;
		self.guildid = teamMemberData.guildid;
		self.zoneid = teamMemberData.zoneid;
	end
	if(self.id == Game.Myself.data.id)then
		self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
	else
		self.level = teamMemberData.baselv;
	end

	self.headData = HeadImageData.new();
	self.headData:TransByTeamMemberData(teamMemberData);
end

function PlayerTipData:SetByChatMessageData(chatMessageData)
	self.id = chatMessageData:GetId()
	self.name = chatMessageData:GetName()
	local myid = Game.Myself.data.id
	if(self.id == myid)then
		self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
	else
		self.level = chatMessageData:GetLevel()
	end
	self.guildname = chatMessageData:GetGuildname()

	self.headData = HeadImageData.new();
	self.headData:TransByChatMessageData(chatMessageData);
end

function PlayerTipData:SetByChatZoneMemberData(chatZoneMember)
	self.id = chatZoneMember.id
	self.name = chatZoneMember.name
	local myid = Game.Myself.data.id
	if(self.id == myid)then
		self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
	else
		self.level = chatZoneMember.level
	end
	self.guildname = chatZoneMember.guildname

	self.headData = HeadImageData.new();
	self.headData:TransByChatZoneMemberData(chatZoneMember);
end

function PlayerTipData:SetByGuildMemberData(guildMember)
	self.id = guildMember.id;
	self.name = guildMember.name;
	self.guildid = guildMember.guildData.id;
	self.guildname = guildMember.guildData.name;
	self.zoneid = guildMember.zoneid;
	local myid = Game.Myself.data.id;
	if(self.id == myid)then
		self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
	else
		self.level = guildMember.baselevel;
	end

	self.headData = HeadImageData.new();
	self.headData:TransByGuildMemberData(guildMember);

	self.parama = guildMember;
end

function PlayerTipData:SetByPetInfoData(petInfoData)
	self.id = petInfoData.guid;
	self.name = petInfoData.name;
	self.level = petInfoData.level;

	self.headData = HeadImageData.new();
	self.headData:TransByPetInfoData(petInfoData);

	self.petid = petInfoData.petid;
	self.friendlv = petInfoData.friendlv;
end

function PlayerTipData:SetByBeingInfoData(beingInfoData)
	self.id = beingInfoData.guid;
	self.name = beingInfoData.name;
	self.level = beingInfoData.lv;

	self.headData = HeadImageData.new();
	self.headData:TransByBeingInfoData(beingInfoData);

	self.beingid = beingInfoData.beingid;
end

function PlayerTipData:SetTeamId( teamid )
	self.teamid = teamid;
end

function PlayerTipData:SetByWeddingcharData(weddingcharData,colorName)
	self.id = weddingcharData.charid
	if(colorName)then
		self.name = string.format(ZhString.Wedding_CharNameTip,weddingcharData.name);
	else
		self.name = weddingcharData.name
	end
	self.level = weddingcharData.level;
	self.guildname = weddingcharData.guildname;

	self.headData = HeadImageData.new();
	self.headData:TransByWeddingCharData(weddingcharData);
end

function PlayerTipData:SetBySocialData(socialData)
	self.id = socialData.guid
	self.name = socialData.name
	self.level = socialData.level
	self.guildname = socialData.guildname

	self.headData = HeadImageData.new()
	self.headData:TransBySocialData(socialData)
end

function PlayerTipData:SetByMatcherData(matcherdata)
	self.id = matcherdata.charid;
	self.name = matcherdata.name;
	self.level = matcherdata.level;
	self.headData = HeadImageData.new();
	self.headData:TransByMatcherData(matcherdata);
	
end