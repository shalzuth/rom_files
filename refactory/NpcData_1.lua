NpcData = reusableClass("NpcData", CreatureDataWithPropUserdata)
NpcData.PoolSize = 100
local NpcMonsterUtility = NpcMonsterUtility
NpcData.NpcType = {
  Npc = 1,
  Monster = 2,
  Pet = 3
}
NpcData.NpcDetailedType = {
  NPC = "NPC",
  GatherNPC = "GatherNPC",
  SealNPC = "SealNPC",
  WeaponPet = "WeaponPet",
  Monster = "Monster",
  MINI = "MINI",
  MVP = "MVP",
  Escort = "Escort",
  SkillNpc = "SkillNpc",
  FoodNpc = "FoodNpc",
  PetNpc = "PetNpc",
  CatchNpc = "CatchNpc",
  BeingNpc = "BeingNpc",
  StageNpc = "StageNpc",
  DeadBoss = "DeadBoss"
}
NpcData.ZoneType = {
  ZONE_MIN = 0,
  ZONE_FIELD = 1,
  ZONE_TASK = 2,
  ZONE_ENDLESSTOWER = 3,
  ZONE_LABORATORY = 4,
  ZONE_SEAL = 5,
  ZONE_DOJO = 6,
  ZONE_MAX = 7
}
local tempArray = {}
function NpcData:ctor()
  NpcData.super.ctor(self)
  self.staticData = nil
  self.uniqueid = nil
  self.behaviourData = BehaviourData.new()
  self.charactors = ReusableTable.CreateArray()
  self.useServerDressData = false
end
function NpcData:GetCamp()
  if self.campHandler and self.campHandler.dirty then
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
  return self.staticData.id == GameConfig.Joy.music_npc_id or self.staticData.id == GameConfig.System.musicboxnpc
end
local ElementNpcMap
local GetElementNpcMap = function()
  local nowRaid = Game.MapManager:GetRaidID()
  if ElementNpcMap then
    return ElementNpcMap[nowRaid] or next(ElementNpcMap)
  end
  ElementNpcMap = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    ElementNpcMap[raidId] = {}
    local elementNpcsID = config.ElementNpcsID
    for i = 1, #elementNpcsID do
      ElementNpcMap[raidId][elementNpcsID[i].npcid] = 1
    end
  end
  return ElementNpcMap[nowRaid] or next(ElementNpcMap)
end
function NpcData:IsElementNpc()
  local map = GetElementNpcMap()
  if map == nil then
    return
  end
  local npcid = self.staticData and self.staticData.id
  return npcid and map[npcid] == 1
end
local ElementNpcMap_Mid
local GetElementNpcMap_Mid = function()
  local nowRaid = Game.MapManager:GetRaidID()
  if ElementNpcMap_Mid then
    return ElementNpcMap_Mid[nowRaid] or next(ElementNpcMap_Mid)
  end
  ElementNpcMap_Mid = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    local buffConfig = config.BuffEffect
    ElementNpcMap_Mid[raidId] = {}
    for npcid, _ in pairs(buffConfig) do
      ElementNpcMap_Mid[raidId][npcid] = 1
    end
  end
  return ElementNpcMap_Mid[nowRaid] or next(ElementNpcMap_Mid)
end
function NpcData:IsElementNpc_Mid()
  if not Game.MapManager:IsPVPMode_TeamPws() then
    return false
  end
  local map = GetElementNpcMap_Mid()
  if map == nil then
    return false
  end
  local npcid = self.staticData and self.staticData.id
  return npcid and map[npcid] == 1
end
local normal_card_npc = GameConfig.CardRaid.normal_card_npc
local boss_card_npc = GameConfig.CardRaid.boss_card_npc
function NpcData:IsPveCardEffect()
  local sid = self.staticData and self.staticData.id or 0
  return sid == normal_card_npc or sid == boss_card_npc
end
function NpcData:GetStaticID()
  return self.staticData.id
end
function NpcData:GetBaseLv()
  local level
  if nil ~= self.userdata then
    level = self.userdata:Get(UDEnum.ROLELEVEL)
  end
  if nil == level then
    if nil ~= self.staticData and nil ~= self.staticData.Level then
      level = self.staticData.Level
    else
      level = 1
    end
  end
  return level
end
function NpcData:NoHitEffectMove()
  if self.behaviourData:GetNonMoveable() == 1 then
    return true
  end
  return NpcData.super.NoHitEffectMove(self)
end
function NpcData:NoAttackEffectMove()
  if self.behaviourData:GetNonMoveable() == 1 then
    return true
  end
  return NpcData.super.NoAttackEffectMove(self)
end
function NpcData:GetShape()
  return self.staticData.Shape
end
function NpcData:GetGroupID()
  return self.staticData.GroupID
end
function NpcData:GetRace()
  return self.staticData.Race_Parsed
end
function NpcData:GetOriginName()
  if self.staticData == nil or self.staticData.NameZh == nil then
    return "none"
  end
  return self.staticData.NameZh
end
function NpcData:GetName()
  local temp = self.name and self.name or self:GetOriginName()
  temp = OverSea.LangManager.Instance():GetLangByKey(temp)
  return NpcData.WithCharactorName(self.charactors) .. temp
end
function NpcData:GetNpcID()
  return self.staticData.id
end
function NpcData:GetDefaultScale()
  if self.staticData then
    return self.staticData.Scale or 1
  end
  return 1
end
function NpcData:GetClassID()
  return 0
end
function NpcData:GetFeature(bit)
  if self.staticData.Features then
    return self.staticData.Features & bit > 0
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
  return self:GetFeature(16)
end
function NpcData:GetFeature_IgnoreNavmesh()
  return self:GetFeature(32)
end
function NpcData:GetFeature_NotifyMove()
  return self:GetFeature(64)
end
function NpcData:GetFeature_StayVisitRot()
  return self:GetFeature(128)
end
function NpcData.WithCharactorName(charactors)
  local charactorNames = ""
  local charactorConf
  for i = 1, #charactors do
    charactorConf = Table_Character[charactors[i]]
    charactorConf.Name = OverSea.LangManager.Instance():GetLangByKey(charactorConf.Name)
    ZhString.NpcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
    if charactorConf then
      charactorNames = charactorNames .. string.format(GameConfig.MonsterCharacterColor[charactorConf.NameColor], charactorConf.Name .. (i == #charactors and ZhString.NpcCharactorSplit or ""))
    else
      errorLog(string.format("creature id:%s charactor cannot find config %s", self.id, charactors[i]))
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
  if str == "Field" then
    return NpcData.ZoneType.ZONE_FIELD
  elseif str == "Task" then
    return NpcData.ZoneType.ZONE_TASK
  elseif str == "EndlessTower" then
    return NpcData.ZoneType.ZONE_ENDLESSTOWER
  elseif str == "Laboratory" then
    return NpcData.ZoneType.ZONE_LABORATORY
  elseif str == "Repair" then
    return NpcData.ZoneType.ZONE_SEAL
  elseif str == "Dojo" then
    return NpcData.ZoneType.ZONE_DOJO
  end
end
function NpcData:SetUseServerDressData(v)
  self.useServerDressData = v
end
function NpcData:GetDressParts()
  local parts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.staticData)
  if self.useServerDressData then
    local userData = self.userdata
    if userData ~= nil then
      local cloned = NpcData.super.GetDressParts(self)
      for k, v in pairs(cloned) do
        if v == 0 then
          cloned[k] = parts[k]
        end
      end
      return cloned
    end
  end
  return parts
end
function NpcData:Camp_SetIsInMyGuild(val)
  if self.campHandler then
    self.campHandler:SetIsSameGuild(val)
    self.campChanged = self.campHandler.dirty
  end
end
function NpcData:Camp_SetIsInGVG(val)
  if self.campHandler then
    self.campHandler:SetIsInGVGScene(val)
    self.campChanged = self.campHandler.dirty
  end
end
function NpcData:IsImmuneSkill(skillID)
  local immuneSkills = self.staticData.ImmuneSkill
  if immuneSkills and #immuneSkills > 0 then
    return 0 < TableUtility.ArrayFindIndex(immuneSkills, skillID)
  end
  return false
end
function NpcData:IsFly()
  return nil ~= self.behaviourData and self.behaviourData:IsFly()
end
function NpcData:DamageAlways1()
  return nil ~= self.behaviourData and 0 < self.behaviourData:GetDamageAlways1() or false
end
function NpcData:SetOwnerID(serverData)
  self.ownerID = serverData.owner
end
function NpcData:DoConstruct(asArray, serverData)
  NpcData.super.DoConstruct(self, asArray, serverData)
  self.dressEnable = true
  self.id = serverData.id
  self.uniqueid = serverData.uniqueid
  self.name = serverData.name
  if serverData.waitaction == "" then
  end
  self.idleAction = serverData.waitaction
  if serverData.character and #serverData.character > 0 then
    TableUtility.ArrayShallowCopy(self.charactors, serverData.character)
  end
  if self.staticData == nil or self.staticData.id ~= serverData.npcID then
    self.staticData = Table_Monster[serverData.npcID]
    if self.staticData == nil then
      self.staticData = Table_Npc[serverData.npcID]
    end
    if self.staticData == nil then
      errorLog(string.format("\230\137\190\228\184\141\229\136\176Npc\233\133\141\231\189\174,%s", serverData.npcID))
      LogUtility.InfoFormat("<color=red>\230\137\190\228\184\141\229\136\176Npc\233\133\141\231\189\174,{0}</color>", serverData.npcID)
      return
    end
    self.shape = self.staticData.Shape
    self.race = self.staticData.Race_Parsed
    self.detailedType = NpcData.NpcDetailedType[self.staticData.Type]
  end
  self.camp = RoleDefines_Camp.NEUTRAL
  local npcmonsterUtility = NpcMonsterUtility
  if npcmonsterUtility.IsMonsterByData(self.staticData) then
    self.type = NpcData.NpcType.Monster
    self.camp = RoleDefines_Camp.ENEMY
  elseif npcmonsterUtility.IsPetByData(self.staticData) then
    self.type = NpcData.NpcType.Pet
  else
    self.type = NpcData.NpcType.Npc
    if npcmonsterUtility.IsNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.NEUTRAL
    elseif npcmonsterUtility.IsFriendNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.FRIEND
    end
    if self.staticData.Type == "WeaponPet" or self.staticData.Type == "SkillNpc" then
      self.camp = RoleDefines_Camp.FRIEND
    end
  end
  if serverData.guildid and serverData.guildid ~= 0 then
    self.campHandler = CampHandler.new(self.camp)
    TableUtility.ArrayClear(tempArray)
    tempArray[1] = serverData.guildid
    tempArray[2] = serverData.guildname
    tempArray[3] = serverData.guildicon
    tempArray[4] = serverData.guildjob
    self:SetGuildData(tempArray)
  end
  self.boss = self:IsBoss()
  self.mini = self:IsMini() or self:GetFeature_FakeMini()
  self.zoneType = self:GetZoneType()
  self:SetBehaviourData(serverData.behaviour)
  self.changelinepunish = self:GetFeature_ChangeLinePunish()
  self:SpawnCullingID()
  self.bodyScale = self:GetDefaultScale()
  self.search = serverData.search
  self.searchrange = serverData.searchrange
  self:SetOwnerID(serverData)
end
function NpcData:DoDeconstruct(asArray)
  NpcData.super.DoDeconstruct(self, asArray)
  self.staticData = nil
  self.campHandler = nil
  self.useServerDressData = false
  TableUtility.ArrayClear(self.charactors)
end
