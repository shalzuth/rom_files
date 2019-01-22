NpcData = reusableClass("NpcData",CreatureDataWithPropUserdata)
NpcData.PoolSize = 100

local NpcMonsterUtility = NpcMonsterUtility

NpcData.NpcType = {
	Npc=1,
	Monster=2,
	Pet=3,
}

NpcData.NpcDetailedType = {
	NPC="NPC",
	GatherNPC="GatherNPC",
	SealNPC="SealNPC",
	WeaponPet="WeaponPet",
	Monster="Monster",
	MINI="MINI",
	MVP="MVP",
	Escort="Escort",
	SkillNpc="SkillNpc",
	FoodNpc = "FoodNpc",
	PetNpc="PetNpc",
	CatchNpc="CatchNpc",
	BeingNpc="BeingNpc",
}

NpcData.ZoneType = {
	ZONE_MIN = 0,
	ZONE_FIELD = 1,
	ZONE_TASK = 2,
	ZONE_ENDLESSTOWER = 3,
	ZONE_LABORATORY = 4,
	ZONE_SEAL = 5,
	ZONE_DOJO = 6,
	ZONE_MAX = 7,
}

local tempArray = {}
-- local num = 0
-- Npc??????
function NpcData:ctor()
	NpcData.super.ctor(self)
	--npc????????????
	self.staticData = nil
	--????????????id
	self.uniqueid = nil
	--????????????
	self.behaviourData = BehaviourData.new()
	--??????
	self.charactors = ReusableTable.CreateArray()
	--?????????????????????????????????
	self.useServerDressData = false
end

function NpcData:GetCamp()
	if(self.campHandler and self.campHandler.dirty) then
		self:SetCamp(self.campHandler:GetCamp())
	end
	return self.camp
end

function NpcData:GetDefaultGear()
	return self.staticData.DefaultGear
end

function NpcData:NoPlayIdle()
	return 1 == self.staticData.DisableWait
end

function NpcData:NoPlayShow()
	return 1 == self.staticData.DisablePlayshow
end

function NpcData:NoAutoAttack()
	return 1 == self.staticData.NoAutoAttack
end

function NpcData:GetAccessRange()
	return self.staticData.AccessRange or 2
end

function NpcData:IsNpc()
	return self.type == NpcData.NpcType.Npc
end

function NpcData:IsMonster()
	return self.type == NpcData.NpcType.Monster
end

function NpcData:IsPet()
	return self.type == NpcData.NpcType.Pet
end

function NpcData:IsMonster_Detail()
	return self.detailedType == NpcData.NpcDetailedType.Monster
end

function NpcData:IsBoss()
	return self.detailedType == NpcData.NpcDetailedType.MVP
end

function NpcData:IsMini()
	return self.detailedType == NpcData.NpcDetailedType.MINI
end

function NpcData:IsSkillNpc_Detail()
	return self.detailedType == NpcData.NpcDetailedType.SkillNpc
end

function NpcData:IsCatchNpc_Detail()
	return self.detailedType == NpcData.NpcDetailedType.CatchNpc
end

function NpcData:IsBeingNpc_Detail()
	return self.detailedType == NpcData.NpcDetailedType.BeingNpc
end

function NpcData:IsMusicBox()
	return self.staticData.id == GameConfig.Joy.music_npc_id or self.staticData.id == GameConfig.System.musicboxnpc;
end

local normal_card_npc = GameConfig.CardRaid.normal_card_npc
local boss_card_npc = GameConfig.CardRaid.boss_card_npc
function NpcData:IsPveCardEffect()
	local sid = self.staticData and self.staticData.id or 0;
	return sid == normal_card_npc or sid == boss_card_npc;
end

function NpcData:GetStaticID()
	return self.staticData.id
end

function NpcData:GetBaseLv()
	local level
	if( nil ~= self.userdata ) then
		level = self.userdata:Get(UDEnum.ROLELEVEL)
	end
	if( nil == level ) then
		if( nil ~= self.staticData and nil ~= self.staticData.Level )then
			level = self.staticData.Level
		else
			level = 1
		end
	end
	return level
end

function NpcData:NoHitEffectMove()
	if(self.behaviourData:GetNonMoveable()==1) then
		return true
	end
	return NpcData.super.NoHitEffectMove(self)
end

function NpcData:NoAttackEffectMove()
	if(self.behaviourData:GetNonMoveable()==1) then
		return true
	end
	return NpcData.super.NoAttackEffectMove(self)
end

--????????????
function NpcData:GetShape()
	return self.staticData.Shape
end

--?????????id
function NpcData:GetGroupID()
	return self.staticData.GroupID
end

--????????????
function NpcData:GetRace()
	return self.staticData.Race_Parsed
end

--??????????????????
function NpcData:GetOriginName()

	if self.staticData==nil or self.staticData.NameZh==nil then
		return "none"
	end	

	return self.staticData.NameZh
end

----[[ todo xde ?????? npc ?????????????????????
--]]
-- function NpcData:GetName()
function NpcData:GetName(skipTranslation)
	-- todo xde start ??????npc???????????????????????????[c][FF0000]?????????[-][/c]\n??????
	local temp = (self.name and self.name or self:GetOriginName())
	----[[ todo xde 0002969: ?????? ?????????????????? ????????????????????? ????????????????????????????????? ??????????????????????????????????????????Yoyo
	if skipTranslation ~= nil then
		temp = AppendSpace2Str(temp)
	end
	--]]
	temp = OverSea.LangManager.Instance():GetLangByKey(temp)
	return NpcData.WithCharactorName(self.charactors)..temp
	-- return NpcData.WithCharactorName(self.charactors)..(self.name and self.name or self:GetOriginName())
end

function NpcData:GetNpcID()
	return self.staticData.id
end

function NpcData:GetDefaultScale()
	if(self.staticData) then
		return self.staticData.Scale or 1
	end
	return 1
end

function NpcData:GetClassID()
	return 0
end

--features start
function NpcData:GetFeature(bit)
	if(self.staticData.Features) then
		return self.staticData.Features & bit >0
	end
	return false
end

function NpcData:GetFeature_ChangeLinePunish()
	return self:GetFeature(1)
end

function NpcData:GetFeature_BeHold()
	return self:GetFeature(4)
end

function NpcData:GetFeature_FakeMini()
	return self:GetFeature(16);
end

function NpcData:GetFeature_IgnoreNavmesh()
	return self:GetFeature(32);
end

--features end

--?????????????????????
function NpcData.WithCharactorName(charactors)
	local charactorNames = ""
	local charactorConf
	for i=1,#charactors do
		charactorConf = Table_Character[charactors[i]]
		-- todo xde ?????? [c][FF0000]?????????[-][/c]\n??????
		charactorConf.Name = OverSea.LangManager.Instance():GetLangByKey(charactorConf.Name)
		ZhString.NpcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
		-- todo xde end
		if(charactorConf) then
			charactorNames = charactorNames..string.format(GameConfig.MonsterCharacterColor[charactorConf.NameColor],charactorConf.Name..(i==#charactors and ZhString.NpcCharactorSplit or ""))
		else
			errorLog(string.format("creature id:%s charactor cannot find config %s",self.id,charactors[i]))
		end
	end
	return charactorNames
end

function NpcData:SetBehaviourData(num)
	self.behaviourData:Set(num or 0)
	self.noPicked = self.behaviourData:GetSkillNonSelectable()
end

function NpcData:GetZoneType()
	local str = self.staticData.Zone
	if(str == "Field") then
		return NpcData.ZoneType.ZONE_FIELD
	elseif(str == "Task") then
		return NpcData.ZoneType.ZONE_TASK
	elseif(str == "EndlessTower") then
		return NpcData.ZoneType.ZONE_ENDLESSTOWER
	elseif(str == "Laboratory") then
		return NpcData.ZoneType.ZONE_LABORATORY
	elseif(str == "Repair") then
		return NpcData.ZoneType.ZONE_SEAL
	elseif(str == "Dojo") then
		return NpcData.ZoneType.ZONE_DOJO
	end
end

function NpcData:SetUseServerDressData(v)
	self.useServerDressData = v
end

function NpcData:GetDressParts()
	local parts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.staticData)
	if(self.useServerDressData) then
		--????????????,??????userdata
		local userData = self.userdata
		if(userData~=nil) then
			local cloned = NpcData.super.GetDressParts(self)
			for k,v in pairs(cloned) do
				if(v==0) then
					cloned[k] = parts[k]
				end
			end
			return cloned
		end
	end
	return parts
end

function NpcData:Camp_SetIsInMyGuild(val)
	if(self.campHandler) then
		self.campHandler:SetIsSameGuild(val)
		self.campChanged = self.campHandler.dirty
	end
end

function NpcData:Camp_SetIsInGVG(val)
	if(self.campHandler) then
		self.campHandler:SetIsInGVGScene(val)
		self.campChanged = self.campHandler.dirty
	end
end

-- override begin
function NpcData:IsImmuneSkill(skillID)
	local immuneSkills = self.staticData.ImmuneSkill
	if(immuneSkills and #immuneSkills>0) then
		return TableUtility.ArrayFindIndex(immuneSkills, skillID) > 0
	end
	return false
end

function NpcData:IsFly()
	return nil ~= self.behaviourData 
		and self.behaviourData:IsFly()
end

function NpcData:DamageAlways1()
    return nil ~= self.behaviourData 
		and 0 < self.behaviourData:GetDamageAlways1() or false
end

function NpcData:SetOwnerID(serverData)
	self.ownerID = serverData.owner
end

function NpcData:DoConstruct(asArray, serverData)
	NpcData.super.DoConstruct(self,asArray,serverData)
	self.dressEnable = true
	self.id = serverData.id
	self.uniqueid = serverData.uniqueid
	self.name = serverData.name
	self.idleAction = serverData.waitaction == '' and nil or serverData.waitaction
	if(serverData.character and #serverData.character>0) then
		TableUtility.ArrayShallowCopy(self.charactors, serverData.character)
	end
	if(self.staticData==nil or self.staticData.id ~= serverData.npcID) then
		self.staticData = Table_Monster[serverData.npcID]
		if(self.staticData==nil) then
			self.staticData = Table_Npc[serverData.npcID]
		end
		if(self.staticData==nil) then
			errorLog(string.format("?????????Npc??????,%s",serverData.npcID))
			LogUtility.InfoFormat("<color=red>?????????Npc??????,{0}</color>", serverData.npcID )
			return
		end
		self.shape = self.staticData.Shape
		self.race = self.staticData.Race_Parsed
		self.detailedType = NpcData.NpcDetailedType[self.staticData.Type]
	end

	self.camp = RoleDefines_Camp.NEUTRAL
	local npcmonsterUtility = NpcMonsterUtility
	if(npcmonsterUtility.IsMonsterByData(self.staticData)) then
		self.type = NpcData.NpcType.Monster
		self.camp = RoleDefines_Camp.ENEMY
	elseif(npcmonsterUtility.IsPetByData(self.staticData))then
		self.type = NpcData.NpcType.Pet
	else
		self.type = NpcData.NpcType.Npc
		if(npcmonsterUtility.IsNpcByData(self.staticData))then
			self.camp = RoleDefines_Camp.NEUTRAL
		elseif(npcmonsterUtility.IsFriendNpcByData(self.staticData)) then
			self.camp = RoleDefines_Camp.FRIEND
		end
		--?????????????????????????????????
		if(self.staticData.Type == "WeaponPet" or self.staticData.Type == "SkillNpc") then
			self.camp = RoleDefines_Camp.FRIEND
		end
	end

	if(serverData.guildid and serverData.guildid~=0) then
		self.campHandler = CampHandler.new(self.camp)
		TableUtility.ArrayClear(tempArray);
		tempArray[1] = serverData.guildid;
		tempArray[2] = serverData.guildname;
		tempArray[3] = serverData.guildicon;
		tempArray[4] = serverData.guildjob;
		
		self:SetGuildData(tempArray);
	end

	self.boss = self:IsBoss()
	self.mini = self:IsMini() or self:GetFeature_FakeMini()
	self.zoneType = self:GetZoneType()
	self:SetBehaviourData(serverData.behaviour)
	self.changelinepunish = self:GetFeature_ChangeLinePunish()
	--??????cullingid
	self:SpawnCullingID()
	self.bodyScale = self:GetDefaultScale()

	self.search = serverData.search
	self.searchrange = serverData.searchrange
	self:SetOwnerID(serverData)
end

function NpcData:DoDeconstruct(asArray)
	NpcData.super.DoDeconstruct(self,asArray)
	self.staticData = nil
	self.campHandler = nil
	self.useServerDressData = false
	TableUtility.ArrayClear(self.charactors)
end
-- override end