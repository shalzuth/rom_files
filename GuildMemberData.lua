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
-- ????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_BASELEVEL,"baselevel")
-- ??????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_PORTRAIT,"portrait")
-- ??????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_FRAME,"frame")
-- ??????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_PROFESSION,"profession")
-- ?????????????????????????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_CONTRIBUTION,"contribution")
-- ????????????????????????????????????????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_TOTALCONTRIBUTION,"totalcontribution")
-- ???????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKCONTRIBUTION,"weekcontribution")
-- ??????????????????????????? ?????????????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKASSET,"weekasset")
-- ??????????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_ENTERTIME,"entertime")
-- ????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_OFFLINETIME,"offlinetime")
-- ????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_JOB,"job")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HAIR,"hair")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_EYE,"eye")
-- ????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HAIRCOLOR,"haircolor")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_BODY,"body")
-- ??????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HEAD,"head")
-- ??????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_FACE,"face")
-- ??????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_MOUTH,"mouth")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_LEVELUPEFFECT,"levelupeffect")
-- ??????????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_ZONEID,"zoneid")
-- ??????????????? ????????????????????????
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_GENDER,"gender")

mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKBCOIN,"weekbcoin")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_TOTALBCOIN,"totalcoin")
--??????
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
			--???????????????????????????????????????????????????nil
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
--??????????????????
function GuildMemberData:IsRealtimevoice()
	return self.realtimevoice == true or  self.realtimevoice == 1
end
--???????????????????????????????????????
function GuildMemberData:SetRealtimevoiceValue(value)
	self.realtimevoice = value
end

function GuildMemberData:GetCharId()
	return self.id
end



