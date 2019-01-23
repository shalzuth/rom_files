GuildMemberData = class("GuildMemberData")

GuildMemberDataType = {}

local function mapGuildEnumProp(enum,propName)
	if(enum) then
		GuildMemberDataType[enum] = propName
	else
		redlog(string.format("GuildCmd_pb enum is nil! propName is %s",propName))
	end
end

mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_NAME,"name")
-- 基础等级
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_BASELEVEL,"baselevel")
-- 头像
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_PORTRAIT,"portrait")
-- 相框
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_FRAME,"frame")
-- 职业
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_PROFESSION,"profession")
-- 当前贡献度（会有消耗）
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_CONTRIBUTION,"contribution")
-- 总贡献度（在这个公会的总贡献度）
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_TOTALCONTRIBUTION,"totalcontribution")
-- 每周贡献度
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKCONTRIBUTION,"weekcontribution")
-- 每周贡献的公会资金 跟贡献度不一样
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKASSET,"weekasset")
-- 进入公会时间
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_ENTERTIME,"entertime")
-- 离线时间
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_OFFLINETIME,"offlinetime")
-- 帮会职位
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_JOB,"job")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HAIR,"hair")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_EYE,"eye")
-- 头发颜色
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HAIRCOLOR,"haircolor")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_BODY,"body")
-- 头饰
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HEAD,"head")
-- 脸部
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_FACE,"face")
-- 嘴部
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_MOUTH,"mouth")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_LEVELUPEFFECT,"levelupeffect")
-- 公会成员切线
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_ZONEID,"zoneid")
-- 初始化赋值 不会更新到的属性
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_GENDER,"gender")

mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKBCOIN,"weekbcoin")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_TOTALBCOIN,"totalcoin")
--语音
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_REALTIMEVOICE,"realtimevoice")

GuildSummaryStringType = {
	["name"] = 1,
}

function GuildMemberData:ctor(guildMemberData, guildData)
	self.guildData = guildData;
	self:SetData(guildMemberData);
end

function GuildMemberData:SetData(gmdata)
	if(gmdata)then
		self.id = gmdata.charid;
		self.name = gmdata.name;
		if(gmdata and gmdata.building)then
			self.buildingLevelUp = gmdata.building.buildings
		end

		local updateStr = "GuildMemberData(Init): ";
		updateStr = updateStr..string.format("| %s:%s", "name", tostring(self.name));

		for _,key in pairs(GuildMemberDataType) do
			if(gmdata[key])then
				self[key] = gmdata[key];
				updateStr = updateStr..string.format("| %s:%s", key, gmdata[key]);
			end
		end

		if self.realtimevoice == nil then
			--这里假如没有授权服务器发过来的就是nil
			self.realtimevoice = false
		end	

		--helplog(updateStr);
	end
end

function GuildMemberData:UpdateData(updateDatas)
	local updateStr = "GuildMemberData(Update): ";
	updateStr = updateStr..string.format("| %s:%s", "name", self.name);
	local oldJob = member.job;

	for i=1,#updateDatas do
		local data = updateDatas[i];
		local key = GuildMemberDataType[data.type];
		if(key)then
			if(GuildSummaryStringType[key])then
				self[key] = data.data;
			else
				self[key] = data.value;
			end
			updateStr = updateStr..string.format("| %s:%s",key,tostring(data.value));
		end
	end

	--helplog(updateStr);
	if(self.id == Game.Myself.data.id and oldJob ~= self.job)then
		FunctionGuild.Me():MyGuildJobChange(oldJob, self.job);
	end
end

function GuildMemberData:GetJobName()
	if(self.guildData and self.job)then
		return self.guildData:GetJobName(self.job);
	end
end

function GuildMemberData:IsOffline()
	if(self.offlinetime)then
		return self.offlinetime ~= 0;
	end
	return false;
end

function GuildMemberData:IsBoy()
	return self.gender == ProtoCommon_pb.EGENDER_MALE;
end

function GuildMemberData:NeedPlayLevelUpEffect()
	return self.levelupeffect == true or self.levelupeffect == 1;
end

function GuildMemberData:GetBuildingLevelup()
	return self.buildingLevelUp
end
--语音是否禁言
function GuildMemberData:IsRealtimevoice()
	return self.realtimevoice == true or  self.realtimevoice == 1
end
--服务端说前端自己保存这个值
function GuildMemberData:SetRealtimevoiceValue(value)
	self.realtimevoice = value
end

function GuildMemberData:GetCharId()
	return self.id
end



