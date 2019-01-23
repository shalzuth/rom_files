TeamMemberData = class("TeamMemberData");

TeamMemberData.KeyType = {
	[SessionTeam_pb.EMEMBERDATA_NAME] = "name",

	[SessionTeam_pb.EMEMBERDATA_CAT] = "cat",
	-- 基础等级
	[SessionTeam_pb.EMEMBERDATA_BASELEVEL] = "baselv",
	-- 职业
	[SessionTeam_pb.EMEMBERDATA_PROFESSION] = "profession",
	-- 地图id
  	[SessionTeam_pb.EMEMBERDATA_MAPID] = "mapid",
	-- 头像
  	[SessionTeam_pb.EMEMBERDATA_PORTRAIT] = "portrait",
	-- 相框
  	[SessionTeam_pb.EMEMBERDATA_FRAME] = "frame",
	-- 副本id
  	[SessionTeam_pb.EMEMBERDATA_RAIDID] = "raid",
	-- 离线状态 0:在线 ~0:离线
  	[SessionTeam_pb.EMEMBERDATA_OFFLINE] = "offline",
	-- 血量
  	[SessionTeam_pb.EMEMBERDATA_HP] = "hp",
  	[SessionTeam_pb.EMEMBERDATA_MAXHP] = "hpmax",
	-- 蓝量
  	[SessionTeam_pb.EMEMBERDATA_SP] = "sp",
  	[SessionTeam_pb.EMEMBERDATA_MAXSP] = "spmax",
	-- 是否为队长 1:队长 2:队员
  	[SessionTeam_pb.EMEMBERDATA_JOB] = "job",
  	-- 队员的攻击目标
  	[SessionTeam_pb.EMEMBERDATA_TARGETID] = "targetid",
  	-- 牵手目标id
  	[SessionTeam_pb.EMEMBERDATA_JOINHANDID] = "joinhandid",
  	-- 身体
  	[SessionTeam_pb.EMEMBERDATA_BODY] = "body",
  	-- 身体颜色
  	[SessionTeam_pb.EMEMBERDATA_CLOTHCOLOR] = "bodycolor",
  	-- 头发
  	[SessionTeam_pb.EMEMBERDATA_HAIR] = "hair",
  	-- 眼镜
  	[SessionTeam_pb.EMEMBERDATA_EYE] = "eye",
  	-- 头发颜色
  	[SessionTeam_pb.EMEMBERDATA_HAIRCOLOR] = "haircolor",
  	-- 右手武器
  	[SessionTeam_pb.EMEMBERDATA_RIGHTHAND] = "rightWeapon",
  	-- 左手武器
  	[SessionTeam_pb.EMEMBERDATA_LEFTHAND] = "leftWeapon",
  	-- 头饰
  	[SessionTeam_pb.EMEMBERDATA_HEAD] = "head",
  	-- 背部
  	[SessionTeam_pb.EMEMBERDATA_BACK] = "back",
  	-- 脸部
  	[SessionTeam_pb.EMEMBERDATA_FACE] = "face",
  	-- 嘴巴
  	[SessionTeam_pb.EMEMBERDATA_MOUTH] = "mouth",
  	-- 尾巴
  	[SessionTeam_pb.EMEMBERDATA_TAIL] = "tail",
  	-- 公会id
  	[SessionTeam_pb.EMEMBERDATA_GUILDID] = "guildid",
  	-- 公会名字
  	[SessionTeam_pb.EMEMBERDATA_GUILDNAME] = "guildname",
  	-- 性别
  	[SessionTeam_pb.EMEMBERDATA_GENDER] = "gender",
  	-- 是否可以眨眼
  	[SessionTeam_pb.EMEMBERDATA_BLINK] = "blink",
  	-- 分线id
  	[SessionTeam_pb.EMEMBERDATA_ZONEID] = "zoneid",
	-- 是否自动上车  	
  	[SessionTeam_pb.EMEMBERDATA_AUTOFOLLOW] = "autofollow",

  	[SessionTeam_pb.EMEMBERDATA_RELIVETIME] = "resttime",
  	-- 雇用时间
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
		-- 名字
		if(tmdata.name)then
			self.name = tmdata.name;
		end
		-- 倒计时(申请的玩家需要)
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
	-- 位置
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