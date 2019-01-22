TeamMemberData = class("TeamMemberData");

TeamMemberData.KeyType = {
	[SessionTeam_pb.EMEMBERDATA_NAME] = "name",

	[SessionTeam_pb.EMEMBERDATA_CAT] = "cat",
	-- ????????????
	[SessionTeam_pb.EMEMBERDATA_BASELEVEL] = "baselv",
	-- ??????
	[SessionTeam_pb.EMEMBERDATA_PROFESSION] = "profession",
	-- ??????id
  	[SessionTeam_pb.EMEMBERDATA_MAPID] = "mapid",
	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_PORTRAIT] = "portrait",
	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_FRAME] = "frame",
	-- ??????id
  	[SessionTeam_pb.EMEMBERDATA_RAIDID] = "raid",
	-- ???????????? 0:?????? ~0:??????
  	[SessionTeam_pb.EMEMBERDATA_OFFLINE] = "offline",
	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_HP] = "hp",
  	[SessionTeam_pb.EMEMBERDATA_MAXHP] = "hpmax",
	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_SP] = "sp",
  	[SessionTeam_pb.EMEMBERDATA_MAXSP] = "spmax",
	-- ??????????????? 1:?????? 2:??????
  	[SessionTeam_pb.EMEMBERDATA_JOB] = "job",
  	-- ?????????????????????
  	[SessionTeam_pb.EMEMBERDATA_TARGETID] = "targetid",
  	-- ????????????id
  	[SessionTeam_pb.EMEMBERDATA_JOINHANDID] = "joinhandid",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_BODY] = "body",
  	-- ????????????
  	[SessionTeam_pb.EMEMBERDATA_CLOTHCOLOR] = "bodycolor",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_HAIR] = "hair",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_EYE] = "eye",
  	-- ????????????
  	[SessionTeam_pb.EMEMBERDATA_HAIRCOLOR] = "haircolor",
  	-- ????????????
  	[SessionTeam_pb.EMEMBERDATA_RIGHTHAND] = "rightWeapon",
  	-- ????????????
  	[SessionTeam_pb.EMEMBERDATA_LEFTHAND] = "leftWeapon",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_HEAD] = "head",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_BACK] = "back",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_FACE] = "face",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_MOUTH] = "mouth",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_TAIL] = "tail",
  	-- ??????id
  	[SessionTeam_pb.EMEMBERDATA_GUILDID] = "guildid",
  	-- ????????????
  	[SessionTeam_pb.EMEMBERDATA_GUILDNAME] = "guildname",
  	-- ??????
  	[SessionTeam_pb.EMEMBERDATA_GENDER] = "gender",
  	-- ??????????????????
  	[SessionTeam_pb.EMEMBERDATA_BLINK] = "blink",
  	-- ??????id
  	[SessionTeam_pb.EMEMBERDATA_ZONEID] = "zoneid",
	-- ??????????????????  	
  	[SessionTeam_pb.EMEMBERDATA_AUTOFOLLOW] = "autofollow",

  	[SessionTeam_pb.EMEMBERDATA_RELIVETIME] = "resttime",
  	-- ????????????
  	[SessionTeam_pb.EMEMBERDATA_EXPIRETIME] = "expiretime",
  	
  	[SessionTeam_pb.EMEMBERDATA_CAT_OWNER] = "masterid",

  	[SessionTeam_pb.EMEMBERDATA_GUILDRAIDINDEX or 38] = "guildraidindex",
}

TeamMemberDataStringType = {
	["name"] = 1,
	["guildname"] = 1,
}

function TeamMemberData:ctor(teamMember, index)
	self.index = index;

	self.pos = LuaVector3();

	self:SetData(teamMember);
end

function TeamMemberData:SetData(tmdata)
	if(tmdata)then
		-- guid
		if(tmdata.guid)then
			self.id = tmdata.guid;
		end
		-- ??????
		if(tmdata.name)then
			self.name = tmdata.name;
		end
		-- ?????????(?????????????????????)
		if(tmdata.time)then
			self.time = tmdata.time;
		end
		if(tmdata.datas)then
			self:SetMemberData(tmdata.datas);
		end
	end
end

function TeamMemberData:SetMemberData(memberDatas)
	-- local updateStr = "TeamMemberData: | ".." id:"..tostring(self.id).." | ".." name:"..tostring(self.name).." | ";
	for i=1,#memberDatas do
		local data = memberDatas[i];
		local key = self.KeyType[data.type];
		if(key)then
			local isKeyString = TeamMemberDataStringType[key];
			if(isKeyString)then
				self[key] = data.data;
			else
				self[key] = data.value;
			end
			-- updateStr = updateStr..string.format("%s:%s | ", key, tostring(data.value));
		end
	end
	-- helplog(updateStr);

	self:UpdateHireMemberInfo();
end

function TeamMemberData:UpdatePos(pos)
	-- ??????
	self.pos:Set(pos.x/1000, pos.y/1000, pos.z/1000);
end

function TeamMemberData:IsOffline()
	if(self.offline and self.offline == 1)then
		return true;
	end
	return false;
end

function TeamMemberData:CanBlink()
	return self.blink == 1 or self.blink == true;
end

function TeamMemberData:IsHireMember()
	if(self.cat == nil)then
		return false;
	end
	return self.cat ~= 0;
end

-- CatInfo begin
function TeamMemberData:UpdateHireMemberInfo()
	if(self.cat ~= nil)then
		self.catdata = Table_MercenaryCat[self.cat];
		if(self.catdata)then
			local MonsterID = self.catdata.MonsterID;
			local monsterData = MonsterID and Table_Monster[MonsterID];
			if(monsterData)then
				self.name = monsterData.NameZh;
				self.profession = nil;

				-- bodyInfo
				self.body = monsterData.Body;
				-- self.bodycolor = monsterData.BodyColor;
				self.hair = monsterData.Hair;
				self.eye = monsterData.Eye;
				-- self.haircolor = monsterData.HairColor;
				self.rightWeapon = monsterData.RightHand;
				self.leftWeapon = monsterData.LeftHand;	
				self.head = monsterData.Head;
				self.back = monsterData.Wing;
				self.face = monsterData.Face;
				self.mouth = monsterData.Mount;
				self.tail = monsterData.tail;
			end
		end
	else
		self.catdata = nil;
	end
end

function TeamMemberData:SetMasterName(mastername)
	self.mastername = mastername;
end

function TeamMemberData:SetRestTime(time)
	self.resttime = time or 0;
end
-- CatInfo end

function TeamMemberData:Exit()
	self.pos:Destroy();
	self.pos = nil;
end






