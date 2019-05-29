MyselfData = reusableClass("MyselfData", PlayerData)
autoImport("Occupation")
autoImport("GvGPvpPrayData")
autoImport("BuffLimit")
local _BuffType = BuffType
RandomFunction = class("RandomFunction")
function RandomFunction:ctor(a)
  self:UpdateArray(a, 1, #a)
  self.index = 1
end
function RandomFunction:ResetIndex(i)
  self.index = i
end
function RandomFunction:UpdateArray(a, begIndex, endIndex)
  if nil == self.array then
    self.array = {}
  end
  for i = begIndex, endIndex do
    self.array[i] = a[i - begIndex + 1]
  end
end
function RandomFunction:GetRandom()
  local p, newIndex = CommonFun.GetRandom(self.array, self.index)
  self.index = newIndex
  return p
end
HatredFunction = class("HatredFunction")
HatredFunction.ValidTime = 3
function HatredFunction.InfoValid(info, time)
  return time < info.lastAttackTime + HatredFunction.ValidTime
end
function HatredFunction:ctor()
  self.targets = {}
end
function HatredFunction:RefreshTargets()
  local invalidTargets = {}
  local time = Time.time
  for k, v in pairs(self.targets) do
    if not HatredFunction.InfoValid(v, time) then
      invalidTargets[#invalidTargets + 1] = k
    end
  end
  for i = 1, #invalidTargets do
    self.targets[invalidTargets[i]] = nil
  end
end
function HatredFunction:RefreshInfo(targetID)
  local info = self.targets[targetID]
  if nil == info then
    info = {}
    self.targets[targetID] = info
  end
  info.lastAttackTime = Time.time
end
function HatredFunction:CheckValid(targetID, time)
  local info = self.targets[targetID]
  if nil ~= info then
    return HatredFunction.InfoValid(info, time)
  end
  return false
end
function MyselfData:ctor()
  MyselfData.super.ctor(self)
  self.shape = CommonFun.Shape.M
  self.race = CommonFun.Race.DemiHuman
  self.transformData = TransformData.new()
  self.transformData:CacheOrigin(self)
  self:InitGuildPray()
end
function MyselfData:GetCamp()
  return RoleDefines_Camp.FRIEND
end
function MyselfData:GetName()
  return self.name
end
function MyselfData:GetTeamID()
  return self.teamID
end
function MyselfData:SetTeamID(teamID)
  self.teamID = teamID
end
local PartIndex, PartIndexEx
function MyselfData:GetDressParts()
  if PartIndex == nil then
    PartIndex = Asset_Role.PartIndex
  end
  if PartIndexEx == nil then
    PartIndexEx = Asset_Role.PartIndexEx
  end
  local parts = Asset_Role.CreatePartArray()
  if self.userdata then
    local userData = self.userdata
    parts[PartIndex.Body] = userData:Get(UDEnum.BODY) or 0
    parts[PartIndex.Hair] = userData:Get(UDEnum.HAIR) or 0
    parts[PartIndex.LeftWeapon] = userData:Get(UDEnum.LEFTHAND) or 0
    parts[PartIndex.RightWeapon] = userData:Get(UDEnum.RIGHTHAND) or 0
    parts[PartIndex.Head] = userData:Get(UDEnum.HEAD) or 0
    parts[PartIndex.Wing] = userData:Get(UDEnum.BACK) or 0
    parts[PartIndex.Face] = userData:Get(UDEnum.FACE) or 0
    parts[PartIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
    parts[PartIndex.Eye] = userData:Get(UDEnum.EYE) or 0
    parts[PartIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
    parts[PartIndex.Mount] = userData:Get(UDEnum.MOUNT) or 0
    parts[PartIndexEx.Gender] = userData:Get(UDEnum.SEX) or 0
    parts[PartIndexEx.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or 0
    parts[PartIndexEx.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR) or 0
    parts[PartIndexEx.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
  else
    for i = 1, 12 do
      parts[i] = 0
    end
  end
  return parts
end
function MyselfData:GetLernedSkillLevel(skillID)
  return SkillProxy.Instance:GetLearnedSkillLevelBySortID(skillID)
end
function MyselfData:GetArrowID()
  local item = BagProxy.Instance:GetNowActiveItem()
  if nil ~= item and nil ~= item.staticData then
    return item.staticData.id
  end
  return MyselfData.super.GetArrowID(self)
end
function MyselfData:GetEquipedRefineLv(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.equipInfo and nil ~= weaponData.equipInfo.refinelv then
    return weaponData.equipInfo.refinelv
  end
  return MyselfData.super.GetEquipedRefineLv(self, site)
end
function MyselfData:GetEquipedItemNum(itemid)
  return BagProxy.Instance.roleEquip:GetEquipedItemNum(itemid)
end
function MyselfData:GetEquipedWeaponType()
  return self:GetEquipedType(GameConfig.EquipType[1].site[1])
end
function MyselfData:GetEquipedType(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.staticData and nil ~= weaponData.staticData.Type then
    return weaponData.staticData.Type
  end
  return MyselfData.super:GetEquipedType(self, site)
end
function MyselfData:GetEquipedID(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.staticData and nil ~= weaponData.staticData.id then
    return weaponData.staticData.id
  end
  return MyselfData.super:GetEquipedID(self, site)
end
function MyselfData:getEquipLv(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.staticData and nil ~= weaponData.staticData.id then
    return weaponData.equipInfo and weaponData.equipInfo.equiplv or 0
  end
  return 0
end
function MyselfData:GetEnchantAttrsBySite(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if weaponData and weaponData.enchantInfo then
    return weaponData.enchantInfo:GetEnchantAttrs()
  end
  return MyselfData.super:GetEnchantAttrsBySite(self, site)
end
function MyselfData:GetCombineEffectsBySite(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if weaponData and weaponData.enchantInfo then
    return weaponData.enchantInfo:GetCombineEffects()
  end
  return MyselfData.super:GetCombineEffectsBySite(self, site)
end
function MyselfData:GetDynamicSkillInfo(skillID)
  return SkillProxy.Instance:GetDynamicSkillInfoByID(skillID)
end
function MyselfData:GetCartNums()
  local max = BagProxy.Instance.barrowBag:GetUplimit()
  local items = BagProxy.Instance.barrowBag:GetItems()
  return #items, max
end
function MyselfData:GetPackageItemNum(itemid)
  return BagProxy.Instance:GetItemNumByStaticID(itemid)
end
function MyselfData:GetEquipCardNum(site, cardID)
  return BagProxy.Instance.roleEquip:GetEquipCardNumBySiteAndCardID(site, cardID)
end
function MyselfData:GetRunePoint(specialEffectID)
  return AstrolabeProxy.Instance:GetSpecialEffectCount(specialEffectID)
end
function MyselfData:GetActiveAstrolabePoints()
  return AstrolabeProxy.Instance:GetActiveStarPoints()
end
function MyselfData:GetAdventureSavedHeadWear(quality)
  return AdventureDataProxy.Instance:getNumOfStoredHeaddress(quality)
end
function MyselfData:GetAdventureSavedCard(quality)
  return AdventureDataProxy.Instance:getNumOfStoredCard(quality)
end
function MyselfData:GetAdventureTitle()
  return AdventureDataProxy.Instance:GetCurAdventureAppellation()
end
function MyselfData:GetGuildData()
  if self.guildData == nil then
    return GuildProxy.Instance.myGuildData
  end
  return self.guildData
end
function MyselfData:GetMapInfo()
  local mapmanager = Game.MapManager
  local mode = 1
  if mapmanager:IsPVPMode() then
    mode = 2
    if mapmanager:IsPVPMode_GVGDetailed() then
      mode = 4
    end
  elseif mapmanager:IsRaidMode() then
    mode = 3
  end
  return mapmanager:GetMapID(), mode
end
function MyselfData:UpdateRandomFunc(array, begIndex, endIndex)
  if nil ~= self.randomFunc then
    self.randomFunc:UpdateArray(array, begIndex, endIndex)
  else
    self.randomFunc = RandomFunction.new(array, begIndex, endIndex)
  end
end
function MyselfData:GetRandom()
  return self.randomFunc and self.randomFunc:GetRandom() or MyselfData.super.GetRandom(self)
end
function MyselfData:ResetRandom()
  if self.randomFunc then
    self.randomFunc:ResetIndex(1)
  end
end
function MyselfData:RemoveInvalidHatred()
  if nil ~= self.hatredFunc then
    self.hatredFunc:RefreshTargets()
  end
end
function MyselfData:RefreshHatred(id)
  if nil == self.hatredFunc then
    self.hatredFunc = HatredFunction.new()
  end
  self.hatredFunc:RefreshInfo(id)
end
function MyselfData:CheckHatred(id, time)
  return nil ~= self.hatredFunc and self.hatredFunc:CheckValid(id, time)
end
function MyselfData:InitGuildPray()
  self.guildPray = {}
  self.gvgPvpPray = {}
  for _, data in pairs(Table_Guild_Faith) do
    if GuildCmd_pb.EPRAYTYPE_GODDESS == data.Type then
      local gpdata = {}
      gpdata.staticData = data
      gpdata.level = 0
      self.guildPray[data.id] = gpdata
    end
  end
end
function MyselfData:SetGuildPray(guildPray)
  for i = 1, #guildPray do
    local gp = guildPray[i]
    local prayData = GvGPvpPrayData.new()
    prayData:SetPrayData(gp)
    local t = prayData.type
    if t > 0 then
      if nil == self.gvgPvpPray[t] then
        self.gvgPvpPray[t] = {}
      end
      for i = 1, #self.gvgPvpPray do
        for j = 1, #self.gvgPvpPray[i] do
          if self.gvgPvpPray[i][j].id == prayData.id then
            self.gvgPvpPray[i][j] = prayData
            return
          end
        end
      end
      table.insert(self.gvgPvpPray[t], prayData)
    elseif gp.pray and gp.lv then
      local selfgp = self.guildPray[gp.pray]
      if selfgp then
        selfgp.level = gp.lv
      else
        errorLog(string.format("Not Find prayType:%s", gp.pray))
      end
    end
  end
end
function MyselfData:AddBuff(buffID, fromID, layer, level)
  if buffID == nil then
    return
  end
  local buffInfo = Table_Buffer[buffID]
  if nil == buffInfo then
    return
  end
  local buffeffect = buffInfo.BuffEffect
  if buffeffect.type == _BuffType.LimitSkill then
    self:_AddLimitBuff(buffInfo, fromID, buffeffect.id, buffeffect.IgnoreTarget, buffeffect.notid)
  elseif buffeffect.type == _BuffType.LimitUseItem then
    ItemsWithRoleStatusChange:Instance():AddBuffLimitUseItem(buffeffect.ok_type, buffeffect.forbid_all)
  elseif buffeffect.type == _BuffType.ForbidEquip then
    ItemsWithRoleStatusChange:Instance():AddBuffForbidEquip(buffeffect)
  end
  MyselfData.super.AddBuff(self, buffID, fromID, layer, level)
end
function MyselfData:RemoveBuff(buffID)
  if buffID == nil then
    return
  end
  local buffInfo = Table_Buffer[buffID]
  if nil == buffInfo then
    return
  end
  local buffeffect = buffInfo.BuffEffect
  if buffeffect.type == _BuffType.LimitSkill then
    self:_RemoveLimitBuff(buffInfo, fromID, buffeffect.id, buffeffect.notid)
  elseif buffeffect.type == _BuffType.LimitUseItem then
    ItemsWithRoleStatusChange:Instance():RemoveBuffLimitUseItem(buffeffect.ok_type, buffeffect.forbid_all)
  elseif buffeffect.type == _BuffType.ForbidEquip then
    ItemsWithRoleStatusChange:Instance():RemoveBuffForbidEquip(buffeffect)
  end
  MyselfData.super.RemoveBuff(self, buffID)
end
function MyselfData:_AddLimitBuff(buffInfo, fromID, skillIDs, ignoreTarget, notSkillIDs)
  if skillIDs ~= nil then
    if self.limitBuffs == nil then
      self.limitBuffs = ReusableTable.CreateTable()
      self.limitBuffs.count = 0
    end
    for i = 1, #skillIDs do
      self:_AddLimitSkillBuff(self.limitBuffs, skillIDs[i], fromID, ignoreTarget)
    end
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
  if notSkillIDs ~= nil then
    if self.limitNotBuffs == nil then
      self.limitNotBuffs = ReusableTable.CreateTable()
      self.limitNotBuffs.count = 0
    end
    for i = 1, #notSkillIDs do
      self:_AddLimitSkillBuff(self.limitNotBuffs, notSkillIDs[i], fromID, ignoreTarget)
    end
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
end
function MyselfData:_AddLimitSkillBuff(map, skillid, fromID, ignoreTarget)
  local limitBuff = map[skillid]
  if limitBuff == nil then
    limitBuff = BuffLimit.CreateAsTable(data)
    map[skillid] = limitBuff
    map.count = map.count + 1
  end
  limitBuff:SetData(fromID, ignoreTarget)
end
function MyselfData:_RemoveLimitBuff(buffInfo, fromID, skillIDs, notSkillIDs)
  if self.limitBuffs ~= nil and skillIDs ~= nil then
    for i = 1, #skillIDs do
      self:_RemoveLimitSkillBuff(self.limitBuffs, skillIDs[i])
    end
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
  if self.limitNotBuffs ~= nil and notSkillIDs ~= nil then
    for i = 1, #notSkillIDs do
      self:_RemoveLimitSkillBuff(self.limitNotBuffs, notSkillIDs[i])
    end
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
end
function MyselfData:_RemoveLimitSkillBuff(map, skillid)
  local limitBuff = map[skillid]
  if limitBuff ~= nil then
    limitBuff:Destroy()
    map[skillid] = nil
    map.count = map.count - 1
  end
end
function MyselfData:ForceClearWeakFreezeSkillBuff()
  if self.weakFreezeBuffs ~= nil then
    ReusableTable.DestroyAndClearTable(self.weakFreezeBuffs)
    self.weakFreezeBuffs = nil
  end
end
function MyselfData:CanBreakWeakFreezeBySkillID(skillIdAndLevel)
  return self:CanBreakWeakFreezeBySkillSortID(math.floor(skillIdAndLevel / 1000))
end
function MyselfData:CanBreakWeakFreezeBySkillSortID(sortID)
  if self.weakFreezeBuffs and self.weakFreezeBuffs.count > 0 then
    local skillBuff = self.weakFreezeBuffs[sortID]
    if skillBuff and #skillBuff == self.weakFreezeBuffs.count then
      return true
    end
  end
  return false
end
function MyselfData:_ClearBuffs()
  if self.limitBuffs ~= nil then
    for i = #self.limitBuffs, 1, -1 do
      self.limitBuffs[i]:Destroy()
      self.limitBuffs[i] = nil
    end
    ReusableTable.DestroyTable(self.limitBuffs)
    self.limitBuffs = nil
  end
  if self.limitNotBuffs ~= nil then
    for i = #self.limitNotBuffs, 1, -1 do
      self.limitNotBuffs[i]:Destroy()
      self.limitNotBuffs[i] = nil
    end
    ReusableTable.DestroyTable(self.limitNotBuffs)
    self.limitNotBuffs = nil
  end
  self:ForceClearWeakFreezeSkillBuff()
  MyselfData.super._ClearBuffs(self)
end
function MyselfData:HasLimitSkill()
  if self.limitBuffs then
    return self.limitBuffs.count > 0
  end
  return false
end
function MyselfData:HasLimitNotSkill()
  if self.limitNotBuffs and not self:HasLimitSkill() then
    return self.limitNotBuffs.count > 0
  end
  return false
end
function MyselfData:GetLimitSkill(skillID)
  if self.limitBuffs ~= nil then
    return self.limitBuffs[math.floor(skillID / 1000)]
  end
end
function MyselfData:GetLimitNotSkill(skillID)
  if self.limitNotBuffs ~= nil and not self:HasLimitSkill() then
    return self.limitNotBuffs[math.floor(skillID / 1000)]
  end
end
function MyselfData:GetLimitSkillTarget(skillID)
  return self:GetLimitSkillTargetBySortID(math.floor(skillID / 1000))
end
function MyselfData:GetLimitSkillTargetBySortID(sortID)
  if self.limitBuffs then
    local limitBuff = self.limitBuffs[sortID]
    if limitBuff ~= nil then
      return limitBuff:GetFromID()
    end
  end
  return nil
end
function MyselfData:InGuildZone()
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return false
  end
  local curZoneId = self.userdata:Get(UDEnum.ZONEID) or 0
  return curZoneId == myGuildData.zoneid
end
function MyselfData:InSuperGvg()
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return false
  end
  return myGuildData.insupergvg == true
end
function MyselfData:GetRangeEnemy(range)
  if range ~= nil then
    local me = Game.Myself
    if me then
      local count = 0
      local pos = me:GetPosition()
      local _DistanceXZ = VectorUtility.DistanceXZ
      local users = NSceneUserProxy.Instance:GetAll()
      for k, v in pairs(users) do
        if self.id ~= k and v ~= nil and self:IsEnemy(v.data) and range >= _DistanceXZ(pos, v:GetPosition()) then
          count = count + 1
        end
      end
      local npcs = NSceneNpcProxy.Instance:GetAll()
      for k, v in pairs(npcs) do
        if v ~= nil and self:IsEnemy(v.data) and range >= _DistanceXZ(pos, v:GetPosition()) then
          count = count + 1
        end
      end
      return count
    end
  end
  return MyselfData.super:GetRangeEnemy(self, range)
end
function MyselfData:GetBeingGUID()
  local beingInfo = PetProxy.Instance:GetMySummonBeingInfo()
  if beingInfo ~= nil then
    return beingInfo.guid
  end
  return MyselfData.super:GetBeingGUID(self)
end
function MyselfData:getCurElementElfID()
  return Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.SummonElement)
end
function MyselfData:DoConstruct(asArray, serverData)
  MyselfData.super.DoConstruct(self, asArray, serverData)
  self.id = serverData.id
  self.name = serverData.name
  self.dressEnable = true
end
function MyselfData:DoDeconstruct(asArray)
  MyselfData.super.DoDeconstruct(self, asArray)
end
