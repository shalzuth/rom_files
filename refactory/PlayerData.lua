autoImport("CampHandler")
PlayerData = reusableClass("PlayerData",CreatureDataWithPropUserdata)
PlayerData.PoolSize = 80

local UDEnum = UDEnum
-- 玩家数据
function PlayerData:ctor()
	PlayerData.super.ctor(self)
	self.race = CommonFun.Race.DemiHuman
	self:SetCamp(RoleDefines_Camp.FRIEND)
	self.campHandler = CampHandler.new()
	self.transformData = TransformData.new()
	self.transformData:CacheOrigin(self)

	self.occupations = {}
	self.currentOcc = nil
end

function PlayerData:GetName()
	return self.name
end

function PlayerData:GetTeamID()
	return self.teamID
end

function PlayerData:SetCamp(camp)
	PlayerData.super.SetCamp(self,camp)
	if(Game.Myself and self.id == Game.LockTargetEffectManager:GetLockedTargetID()) then
		Game.LockTargetEffectManager:RefreshEffect()
	end
end

--获取阵营
function PlayerData:GetCamp()
	if(self.campHandler.dirty) then
		self:SetCamp(self.campHandler:GetCamp())
	end
	return self.camp
end

--获取职业
function PlayerData:GetProfesstion()
	return self.userdata:Get(UDEnum.PROFESSION)
end

function PlayerData:Camp_SetIsInMyTeam(val)
	-- LogUtility.InfoFormat("PlayerData:Camp_SetIsInMyTeam {0}", val)
	self.campHandler:SetIsSameTeam(val)
	self.campChanged = self.campHandler.dirty
end

function PlayerData:Camp_SetIsInPVP(val)
	-- LogUtility.InfoFormat("PlayerData:Camp_SetIsInPVP {0}", val)
	self.campHandler:SetIsInPvpScene(val)
	self.campChanged = self.campHandler.dirty
end

function PlayerData:Camp_SetIsInMyGuild(val)
	-- LogUtility.InfoFormat("PlayerData:Camp_SetIsInMyTeam {0}", val)
	self.campHandler:SetIsSameGuild(val)
	self.campChanged = self.campHandler.dirty
end

function PlayerData:Camp_SetIsInGVG(val)
	-- LogUtility.InfoFormat("PlayerData:Camp_SetIsInPVP {0}", val)
	self.campHandler:SetIsInGVGScene(val)
	self.campChanged = self.campHandler.dirty
end

function PlayerData:Camp_SetIsOtherTransformedAtk(val)
	self.campHandler:SetIsOtherTransformedAtk(val)
	self.campChanged = self.campHandler.dirty
end

function PlayerData:Camp_SetIsSelfTransformedAtk(val)
	self.campHandler:SetIsSelfTransformedAtk(val)
	self.campChanged = self.campHandler.dirty
end

local tempArray = {}
function PlayerData:getOccupationByType( type )
	-- body
	TableUtility.ArrayClear(tempArray)	
	if(self.occupations)then
		for i=1,#self.occupations do
			local single = self.occupations[i]
			if(single.professionData.Type == type)then									
				table.insert(tempArray,single)
			end
		end
	end
	return tempArray
end

function PlayerData:UpdateJobDatas( data )
	local occupation = nil
	local ocData = nil
	self.occupations = {}
	local currentOcc = self.userdata:Get(UDEnum.PROFESSION)
	for i=1,#data do 
		ocData = data[i].datas
		local jobLv = 1
		local profession = 1
		local jobExp = 1
		for i=1,#ocData do
			if(ocData[i].type == ProtoCommon_pb.EUSERDATATYPE_PROFESSION)then
				profession = ocData[i].value
			elseif(ocData[i].type == ProtoCommon_pb.EUSERDATATYPE_JOBLEVEL)then
				jobLv = ocData[i].value
			elseif(ocData[i].type == ProtoCommon_pb.EUSERDATATYPE_JOBEXP)then
				jobExp = ocData[i].value
			end
		end

		TableUtility.ArrayClear(tempArray)
		tempArray[1] = jobLv
		tempArray[2] = jobExp
		tempArray[3] = profession
		occupation = Occupation.CreateAsTable(tempArray)
		self.occupations[#self.occupations+1] = occupation
		if(occupation.isCurrent) then
			self.currentOcc = occupation
		end
	end
end

function PlayerData:UpdateProfession()
	local jobLv = self.userdata:Get(UDEnum.JOBLEVEL)
	local jobExp = self.userdata:Get(UDEnum.JOBEXP)
	local profession = self.userdata:Get(UDEnum.PROFESSION)
	local occupation 
	
	if(self.occupations)then
		for i=1,#self.occupations do
			local single = self.occupations[i]
			if(single.profession == profession)then									
				occupation = single
			end
		end
	end

	if(not occupation)then
		TableUtility.ArrayClear(tempArray)
		tempArray[1] = jobLv
		tempArray[2] = jobExp
		tempArray[3] = profession
		occupation = Occupation.CreateAsTable(tempArray)
		table.insert(self.occupations,occupation)
	end	
	self.currentOcc = occupation	
end

function PlayerData:GetCurOcc()
	-- body
	if not self.currentOcc then
		self:UpdateProfession()
	end
	return self.currentOcc
end

function PlayerData:SetBlink(b)
	self.blink = b;
end

function PlayerData:CanBlink()
	return self.blink == true;
end

function PlayerData:InitChatRoomData(chatRoomInfo)
	if(chatRoomInfo~=nil and chatRoomInfo.roomid>0 and chatRoomInfo.ownerid == self.id) then
		if(self.chatRoomData==nil) then
			self.chatRoomData = ChatZoneSummaryData.CreateAsTable(chatRoomInfo)
		else
			self.chatRoomData:Update(chatRoomInfo)
		end
	end
end

function PlayerData:UpdateBoothData(boothInfo)
	if boothInfo ~= nil then
		if self.boothData == nil then
			self.boothData = BoothData.CreateAsTable(boothInfo)
		else
			self.boothData:SetData(boothInfo)
		end
	end
end

function PlayerData:ClearBoothData()
	if self.boothData ~= nil then
		self.boothData:Destroy()
		self.boothData = nil
	end
end

function PlayerData:SetTeamID(teamID)
	self.teamID = teamID
end

function PlayerData:SetAchievementtitle(achievetitle)
	self.achievetitle = achievetitle
end

function PlayerData:GetAchievementtitle()
	return self.achievetitle
end

function PlayerData:GetEquipedWeaponType()
	if self.userdata ~= nil then
		local equipedWeaponId = self.userdata:Get(UDEnum.EQUIPED_WEAPON)
		local staticData = Table_Item[equipedWeaponId]
		if staticData ~= nil and staticData.Type ~= nil then
			return staticData.Type
		end
	end
	return PlayerData.super:GetEquipedWeaponType(self)
end

-- override begin
function PlayerData:DoConstruct(asArray, serverData)
	PlayerData.super.DoConstruct(self,asArray,serverData)
	self.id = serverData.guid
	self.name = serverData.name
	self.shape = CommonFun.Shape.M
	self.shape = CommonFun.Shape.M
	self.race = CommonFun.Race.DemiHuman
	if(not serverData.teamid or serverData.teamid == 0) then
		self.teamID = self.id
	else
		self.teamID = serverData.teamid
	end
	self.blink  = false;
	self.achievetitle = serverData.achievetitle
	TableUtility.ArrayClear(tempArray);
	tempArray[1] = serverData.guildid;
	tempArray[2] = serverData.guildname;
	tempArray[3] = serverData.guildicon;
	tempArray[4] = serverData.guildjob;

	self:SetGuildData(tempArray);
	--生成cullingid
	self:SpawnCullingID()
end

function PlayerData:DoDeconstruct(asArray)
	self.campHandler:Reset()
	if(self.chatRoomData~=nil) then
		self.chatRoomData:Destroy()
		self.chatRoomData = nil
	end
	self:ClearBoothData()
	PlayerData.super.DoDeconstruct(self,asArray)
end
-- override end