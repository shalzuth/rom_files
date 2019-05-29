autoImport("EquipInfo")
autoImport("SuitInfo")
autoImport("EnchantInfo")
autoImport("LoveLetterData")
autoImport("PetEggInfo")
autoImport("CodeData")
autoImport("WeddingData")
ItemData = class("ItemData")
ItemTarget_Type = {
  Player = 1,
  Npc = 2,
  Monster = 4
}
Item_CardType = {
  Get = 1,
  Born = 2,
  Raffle = 4,
  Decompose = 8,
  BossCompose = 16
}
local _MyItemStatusCheck = ItemsWithRoleStatusChange:Instance()
function ItemData:ctor(id, staticId)
  self.id = ""
  self.bagtype = nil
  self.staticData = nil
  self.equipInfo = nil
  self.cardInfo = nil
  self.enchantInfo = nil
  self.equipedCardInfo = nil
  self.cardSlotNum = 0
  self.index = 0
  self.num = 0
  self.bind = false
  self.expireTime = 0
  self.equiped = 0
  self.cdTime = 0
  self.configCdTime = 0
  self.battlepoint = 0
  self.isNew = false
  self.isFashion = false
  self.tempHint = true
  self.isactive = false
  self.couldUseWithRoleStatus = nil
  self.replaceCount = 0
  self:ResetData(id, staticId)
  self.CodeData = nil
  self.source = nil
end
function ItemData:ResetData(id, staticId)
  self.cdTime = 0
  self.id = id
  self.staticData = Table_Item[staticId]
  if self.staticData ~= nil then
    self.staticData.id = staticId
  elseif staticId ~= nil and staticId ~= 0 then
    LogUtility.InfoFormat("\230\160\185\230\156\172\230\137\190\228\184\141\229\136\176id\228\184\186{0}\231\154\132\233\129\147\229\133\183", tostring(staticId))
  end
  local equipData = Table_Equip[staticId]
  if equipData ~= nil then
    self.equipInfo = EquipInfo.new(equipData)
    self.cardSlotNum = equipData.CardSlot
    self.replaceCount = 0
    if equipData.SubstituteID then
      local cData = Table_Compose[equipData.SubstituteID]
      local nextEquipId = cData.Product.id
      if nextEquipId then
        while true do
          if nextEquipId ~= nil and self.replaceCount < 5 then
            self.replaceCount = self.replaceCount + 1
            do
              local eData = Table_Equip[nextEquipId]
              if eData and eData.SubstituteID then
                cData = Table_Compose[eData.SubstituteID]
                if cData then
                  nextEquipId = cData.Product.id
                else
                  nextEquipId = nil
                end
              end
              nextEquipId = nil
            end
            else
              self.equipInfo = nil
              self.cardSlotNum = 0
            end
          end
        end
      end
    end
  local useItemData = Table_UseItem[staticId]
  self.configCdTime = useItemData and useItemData.CDTime or 0
  self.cardInfo = Table_Card[staticId]
  if self.equipInfo then
    local suitIds = BagProxy.GetSuitIds(staticId)
    if #suitIds > 0 then
      self.suitInfo = SuitInfo.new(suitIds)
    end
  end
end
function ItemData:GetCdConfigTime()
  local useItemData = Table_UseItem[self.staticData.id]
  if useItemData == nil then
    return
  end
  if useItemData.PVPCDtime and Game.MapManager:IsPVPMode() then
    return useItemData.PVPCDtime
  end
  return useItemData.CDTime or 0
end
function ItemData:SetEquipCards(cards)
  self.equipedCardInfo = {}
  if cards then
    for i = 1, #cards do
      local single = cards[i]
      local equipedCard = ItemData.new(single.guid, single.id)
      if single.pos then
        equipedCard.index = single.pos
        self.equipedCardInfo[single.pos] = equipedCard
      else
        table.insert(self.equipedCardInfo, equipedCard)
      end
    end
  end
end
function ItemData:HasEquipedCard()
  if self.equipedCardInfo == nil then
    return false
  end
  return next(self.equipedCardInfo) ~= nil
end
function ItemData:GetEquipedCardNum()
  if self.equipedCardInfo == nil then
    return 0
  end
  local count = 0
  for k, v in pairs(self.equipedCardInfo) do
    count = count + 1
  end
  return count
end
function ItemData:SetEnchantInfo(enchantData)
  if not self.staticData then
    return
  end
  if not self.equipInfo then
    return
  end
  if self.enchantInfo == nil then
    self.enchantInfo = EnchantInfo.new(self.staticData.id)
  end
  self.enchantInfo:SetServerData(enchantData)
end
function ItemData:SetPreEnchantInfo(enchantData)
  if self.enchantInfo then
    self.enchantInfo:SetCacheServerData(enchantData)
  end
end
function ItemData:SetCdStamp(stamp)
  local configCdTime = self:GetCdConfigTime()
  if configCdTime and configCdTime > 0 and stamp > 0 then
    local delta = math.max(0, -ServerTime.ServerDeltaSecondTime(stamp))
    if configCdTime > delta and delta >= 0 then
      self.cdTime = configCdTime - delta
    end
  end
end
function ItemData:RefreshCD(deltaTime)
  self.cdTime = self.cdTime - deltaTime
  if self.cdTime <= 0 then
    self.cdTime = 0
    return true
  end
  return false
end
function ItemData:GetName(hideRefinelv, hideDamageColor)
  if self.staticData then
    local name = self.staticData.NameZh
    if self.petEggInfo and self.petEggInfo.name ~= "" then
      return string.format(ZhString.ItemData_PetEggName, self.petEggInfo.name)
    end
    if self.equipInfo then
      if self.equipInfo.refinelv > 0 and hideRefinelv ~= true then
        name = string.format("+%d%s", self.equipInfo.refinelv, tostring(name))
      end
      if 0 < self.equipInfo.equiplv then
        name = name .. StringUtil.IntToRoman(self.equipInfo.equiplv)
      end
      if self.equipInfo.damage and hideDamageColor ~= true then
        name = string.format("[c][CF1C0F]%s[-][/c]", tostring(name))
      end
    end
    return name
  end
  return ""
end
function ItemData.CheckIsEquip(itemid)
  return Table_Equip[itemid] ~= nil
end
function ItemData:IsEquip()
  return self.equipInfo ~= nil
end
function ItemData:IsFashion()
  local result = false
  result = self.staticData and self.staticData.Type and BagProxy.fashionType[self.staticData.Type] ~= nil
  if result == false and self.equipInfo and self.equipInfo.equipData.Body then
    result = true
  end
  return result
end
function ItemData:IsMount()
  return self.staticData.Type == 90
end
function ItemData:IsNew()
  return self.isNew ~= nil and self.isNew or false
end
function ItemData:IsHint()
  return self.isHint ~= nil and self.isHint or false
end
function ItemData:IsLoveLetter()
  return self.loveLetter ~= nil and self.loveLetter:CheckValid()
end
function ItemData:CanEquip(isSkipSkillCheck)
  if self:IsPetEgg() then
    return self.petEggInfo and self.petEggInfo:PetMountCanEquip()
  end
  local myself = Game.Myself
  local sid = self.staticData.id
  local otherLimit = GameConfig.EquipedLimitBySkill
  if otherLimit and not isSkipSkillCheck then
    local skillConfig = otherLimit[sid]
    if skillConfig and myself.data:GetLernedSkillLevel(skillConfig[1]) < skillConfig[2] then
      return false
    end
  end
  if self.equipInfo then
    local sites = self.equipInfo:GetEquipSite()
    if _MyItemStatusCheck:CanEquipWithCurrentStatus(sites) == false then
      return false
    end
    local myPro = myself.data.userdata:Get(UDEnum.PROFESSION)
    if self.equipInfo:CanUseByProfess(myPro) then
      local sexEquip = self.equipInfo.equipData.SexEquip or 0
      local mySex = myself.data.userdata:Get(UDEnum.SEX)
      return sexEquip == 0 or sexEquip == mySex
    end
  else
    return false
  end
end
function ItemData:CanIOffEquip()
  if self.staticData == nil then
    return false
  end
  if self.equipInfo == nil then
    return false
  end
  return _MyItemStatusCheck:CanOffEquipWithCurrentStatus(self.staticData.Type, self.equipInfo:GetEquipSite())
end
function ItemData:EyeCanEquip()
  local mySex = Game.Myself.data.userdata:Get(UDEnum.SEX)
  local id = self.staticData.id
  local staticData = Table_Eye[id]
  if staticData and (mySex == staticData.Sex or staticData.Sex == 3) and staticData.IsPro == 1 and staticData.OnSale == 1 then
    return true
  end
  return false
end
function ItemData:HairCanEquip()
  if self.staticData == nil then
    return false
  end
  local id = self.staticData.id
  local hairid = ShopDressingProxy.Instance:GetHairStyleIDByItemID(id)
  if hairid == nil then
    return false
  end
  local hairSData = Table_HairStyle[hairid]
  if hairSData.IsPro == 1 and hairSData.OnSale == 1 then
    local mySex = Game.Myself.data.userdata:Get(UDEnum.SEX)
    return hairSData.Sex == mySex
  end
  return false
end
function ItemData:IsCodeCanSell()
  if self.CodeData then
    return self.CodeData:IsCodeCanSell()
  end
  return true
end
function ItemData:Clone()
  local item = ItemData.new(self.id, self.staticData and self.staticData.id or 0)
  item.num = self.num
  item.isNew = self.isNew
  item.bagtype = self.bagtype
  if item.equipInfo then
    item.equipInfo:Clone(self.equipInfo)
  end
  if self.equipedCardInfo then
    item.equipedCardInfo = {}
    for i = 1, #self.equipedCardInfo do
      TableUtility.ArrayPushBack(item.equipedCardInfo, self.equipedCardInfo[i]:Clone())
    end
  end
  return item
end
function ItemData:CompareTo(item)
  if item and item.equipInfo ~= nil and self.equipInfo ~= nil then
    if self.staticData.Quality >= item.staticData.Quality then
      if item.staticData.Quality == 1 and self.staticData.Quality > item.staticData.Quality then
        return true
      end
      local attrName, attrValue = item.equipInfo:GetEffect()
      local selfAttrName, selfAttrValue = self.equipInfo:GetEffect()
      if attrName ~= selfAttrName then
        return false
      end
      if attrValue ~= nil and selfAttrValue ~= nil then
        if attrValue < selfAttrValue then
          return true
        elseif selfAttrValue == attrValue then
          if item.equipInfo.equipData and self.equipInfo.equipData then
            local selfEquipCardSlot = self.equipInfo.equipData.CardSlot or 0
            local equipCardSlot = item.equipInfo.equipData.CardSlot or 0
            if selfEquipCardSlot > equipCardSlot then
              return true
            end
          end
          return self.equipInfo.refinelv > item.equipInfo.refinelv
        end
        return false
      end
    end
    return false
  end
  return true
end
function ItemData:CanUse()
  if self.equipInfo then
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local isValid = self.equipInfo:CanUseByProfess(myPro)
    if isValid then
      return self.num > 0 and 0 >= cdTime
    end
  end
  return self.num > 0 and 0 >= self.cdTime
end
function ItemData:IsJobLimit()
  local joblimit = self.staticData.JobLimit
  if joblimit and #joblimit > 0 then
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local canuse = false
    for i = 1, #joblimit do
      if myPro == joblimit[i] then
        canuse = true
        break
      end
    end
    if not canuse then
      return true
    end
  end
  return false
end
function ItemData:IsLimitUse()
  local sid = self.staticData.id
  local sData = Table_UseItem[sid]
  if sData == nil then
    return false
  end
  local uselimit = sData.UseLimit
  if uselimit == nil then
    return false
  end
  if uselimit & 1 > 0 and Game.MapManager:IsPVPMode_GVGDetailed() then
    return true
  end
  if 0 < uselimit & 2 then
    local currentRaidID = Game.MapManager:GetRaidID()
    local raidData = currentRaidID and Table_MapRaid[currentRaidID]
    if raidData == nil or raidData.Type ~= 10 then
      return true
    end
  end
  if 0 < uselimit & 4 and not Game.MapManager:IsPVPMode() then
    return true
  end
  return false
end
function ItemData:CanUseForTarget(targetType)
  if self.staticData == nil then
    return false
  end
  local st = self.staticData.ItemTarget.type
  if st ~= nil then
    if st == 1 then
      return targetType == ItemTarget_Type.Player
    elseif st == 2 then
      return targetType == ItemTarget_Type.Monster
    elseif st == 3 then
      return targetType == ItemTarget_Type.Monster or targetType == ItemTarget_Type.Player
    end
  end
  return false
end
function ItemData:ToString()
  return string.format("Guid:%s Sid:%d Equiped:%d Type:%d Quality:%d Index:%d Num:%d", self.id, self.staticData.id, self.equiped, self.staticData.Type, self.staticData.Quality, self.index, self.num)
end
function ItemData:ToTestString()
  return string.format("Guid:%s Sid:%d Equiped:%d Type:%d Quality:%d Index:%d Num:%d", self.id, self.sid, self.equiped, self.type, self.qua, self.index, self.num)
end
function ItemData:ParseFromServerData(serverItem)
  local sItemData = serverItem.base
  local sEquipData = serverItem.equip
  local sECardInfo = serverItem.card
  if serverItem.equiped then
    self.equiped = 1
  else
    self.equiped = 0
  end
  self:ResetData(sItemData.guid, sItemData.id)
  if self.staticData == nil then
    errorLog("server send item ,which has no staticData " .. sItemData.id)
    return
  end
  self.num = sItemData.count
  self.battlepoint = serverItem.battlepoint
  self.isNew = serverItem.base.isnew
  self.isHint = serverItem.base.ishint
  self.index = sItemData.index
  self.createtime = sItemData.createtime
  self.deltime = sItemData.overtime
  self.usedtimes = sItemData.usedtimes
  self.usedtime = sItemData.usedtime
  self.isFavorite = sItemData.isfavorite
  self.isFashion = BagProxy.fashionType[self.staticData.Type] or false
  self.bind = sItemData.eBind == ProtoCommon_pb.EBINDTYPE_BIND
  self:SetCdStamp(sItemData.cd)
  if self.equipInfo and sEquipData then
    self.equipInfo:Set(sEquipData)
  end
  self:SetEquipCards(sECardInfo)
  if serverItem.enchant then
    self:SetEnchantInfo(serverItem.enchant)
    self:SetPreEnchantInfo(serverItem.previewenchant)
  end
  self:UpdateEnchantCombineEffect()
  local sLoveLetter = serverItem.letter
  if sLoveLetter then
    if self.loveLetter == nil then
      self.loveLetter = LoveLetterData.new()
    end
    self.loveLetter:SetDataByItemServerData(sItemData.id, sLoveLetter)
  end
  if serverItem.egg and serverItem.egg.id ~= nil and serverItem.egg.id ~= 0 then
    self.petEggInfo = PetEggInfo.new(self.staticData)
    self.petEggInfo:Server_SetData(serverItem.egg)
  end
  if serverItem.code then
    self.CodeData = CodeData.new(sItemData.guid, self.staticData)
    self.CodeData:Server_SetData(serverItem.code)
  end
  if serverItem.wedding and serverItem.wedding.id ~= 0 then
    if not self.weddingData then
      self.weddingData = WeddingData.new(self.staticData)
    end
    self.weddingData:Server_Update(serverItem.wedding)
  end
  local s_sender = serverItem.sender
  if s_sender and s_sender.charid ~= nil and s_sender.charid ~= 0 then
    self.sender_charid = s_sender.charid
    self.sender_name = s_sender.name
  end
end
function ItemData:ExportServerItem()
  if not self.staticData then
    return
  end
  local serverItem = SceneItem_pb.ItemData()
  serverItem.base.id = self.staticData.id
  if self.equipInfo then
    serverItem.equip.refinelv = self.equipInfo.refinelv
    serverItem.equip.damage = self.equipInfo.damage
    serverItem.equip.lv = self.equipInfo.equiplv
  end
  if self.enchantInfo then
    local attrs = self.enchantInfo:GetEnchantAttrs()
    if #attrs > 0 then
      serverItem.enchant.type = self.enchantInfo.enchantType
      local serverAttris = {}
      for i = 1, #attrs do
        local serverAttri = SceneItem_pb.EnchantAttr()
        serverAttri.type = attrs[i].type
        serverAttri.value = attrs[i].serverValue
        table.insert(serverItem.enchant.attrs, serverAttri)
      end
      local combineEffect = self.enchantInfo:GetCombineEffects()
      for i = 1, #combineEffect do
        local serverExtra = SceneItem_pb.EnchantExtra()
        serverExtra.configid = combineEffect[i].configid
        serverExtra.buffid = combineEffect[i].buffid
        table.insert(serverItem.enchant.extras, serverExtra)
      end
    end
  end
  return serverItem
end
function ItemData:UpdateEnchantCombineEffect()
  if self.enchantInfo and self.equipInfo then
    self.enchantInfo:UpdateCombineEffectWork(self.equipInfo.refinelv)
  end
end
function ItemData:SetDelWarningState(b)
  self.delWarning = b
end
function ItemData:GetDelWarningState()
  return self.delWarning
end
function ItemData:CheckItemCardType(item_CardType)
  if self.cardInfo and self.cardInfo.Type then
    return self.cardInfo.Type & item_CardType > 0
  end
  return false
end
function ItemData:GetFoodSData()
  local sid = self.staticData.id
  return Table_Food[sid]
end
function ItemData:IsFood()
  return self:GetFoodSData() ~= nil
end
function ItemData:IsCard()
  return self.cardInfo ~= nil
end
function ItemData:IsPic()
  if self.staticData then
    return self.staticData.Type == 50
  end
  return false
end
function ItemData:IsPetEgg()
  if self.staticData then
    return self.staticData.Type == 101
  end
  return false
end
function ItemData:IsMountPet()
  if self:IsPetEgg() then
    for _, v in pairs(Table_Pet) do
      if v.EggID == self.staticData.id and v.CanEquip == 1 then
        return true
      end
    end
  end
  return false
end
function ItemData:IsUseItem()
  if self.staticData == nil then
    return false
  end
  return Table_UseItem[self.staticData.id] ~= nil
end
function ItemData:IsMarryInviteLetter()
  if self.staticData and self.weddingData then
    return self.staticData.Type == 167
  end
  return false
end
function ItemData:IsMarriageCertificate()
  if self.staticData and self.weddingData then
    return self.staticData.Type == 166
  end
  return false
end
function ItemData:IsMarriageRing()
  if self.staticData and self.weddingData then
    return self.staticData.Type == 540
  end
  return false
end
function ItemData:GetFoodEffectDesc()
  if self.buffDesc == nil then
    self.buffDesc = ""
    local sid = self.staticData.id
    if sid == FoodProxy.FailFood_ItemID then
      self.buffDesc = "??????????"
    else
      local foodSData = self:GetFoodSData()
      if foodSData then
        local buffids = foodSData.BuffEffect
        local buff_SData
        for i = 1, #buffids do
          buff_SData = Table_Buffer[buffids[i]]
          self.buffDesc = self.buffDesc .. buff_SData.Dsc
          if i < #buffids then
            self.buffDesc = self.buffDesc .. "\n"
          end
        end
      else
        self.buffDesc = ""
      end
    end
  end
  return self.buffDesc
end
function ItemData:CanTrade()
  if self.petEggInfo then
    return self.petEggInfo:CanExchange()
  end
  if BagProxy.Instance:CheckIsFavorite(self) then
    return false
  end
  return ItemData.CheckItemCanTrade(self.staticData.id)
end
function ItemData.CheckItemCanTrade(itemid)
  local data = Table_Exchange[itemid]
  if data then
    if data.Trade ~= 1 then
      return false
    end
    local _FormatTime2TimeStamp = StringUtil.FormatTime2TimeStamp
    local serverTime = ServerTime.CurServerTime() / 1000
    local canTrade = true
    local isTFBranch = EnvChannel.IsTFBranch()
    local tradeTime
    if isTFBranch then
      tradeTime = data.TFTradeTime
    else
      tradeTime = data.TradeTime
    end
    if tradeTime ~= nil and tradeTime ~= "" then
      local t = _FormatTime2TimeStamp(tradeTime)
      canTrade = serverTime >= t
    end
    local unTradeTime
    if isTFBranch then
      unTradeTime = data.TFUnTradeTime
    else
      unTradeTime = data.UnTradeTime
    end
    if unTradeTime ~= nil and unTradeTime ~= "" then
      local t = _FormatTime2TimeStamp(unTradeTime)
      canTrade = serverTime <= t and canTrade
    end
    return canTrade
  end
  return false
end
function ItemData.Get_GetLimitCount(itemid)
  local limitCfg = Table_Item[itemid].GetLimit
  local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local limitCount = ItemData.Help_GetLimitCount(limitCfg.limit, mylv)
  if type(limitCount) == "table" then
    local hasMonthVIP = ServiceUserEventProxy.Instance:AmIMonthlyVIP()
    if hasMonthVIP then
      limitCount = limitCount[1] + limitCount[2]
    else
      limitCount = limitCount[1]
    end
  end
  return limitCount
end
local tempTable = {}
function ItemData.Help_GetLimitCount(map, mylv)
  local limitCount
  TableUtility.TableClear(tempTable)
  for lv, count in pairs(map) do
    table.insert(tempTable, {lv, count})
  end
  table.sort(tempTable, function(a, b)
    return a[1] < b[1]
  end)
  for i = 1, #tempTable do
    if mylv <= tempTable[i][1] then
      limitCount = tempTable[i][2]
      break
    end
  end
  if limitCount == nil then
    limitCount = tempTable[1][2]
  end
  return limitCount
end
function ItemData:CanStack()
  if self.staticData == nil then
    return
  end
  return self.staticData.MaxNum > 1
end
function ItemData:CanStorage(bagType)
  if self.staticData == nil then
    return false
  end
  local noStorage = self.staticData.NoStorage
  if noStorage == nil then
    return true
  end
  local Item_Nostorge_Type = {
    [BagProxy.BagType.Storage] = 1,
    [BagProxy.BagType.PersonalStorage] = 2,
    [BagProxy.BagType.Barrow] = 2
  }
  local forbidValue = Item_Nostorge_Type[bagType]
  if forbidValue == nil then
    return true
  end
  return noStorage & forbidValue <= 0
end
function ItemData:SetItemNum(num)
  self.num = num
end
function ItemData:CanIntervalUse()
  local sid = self.staticData.id
  if sid == nil then
    return false
  end
  local interval = Table_UseItem[sid] and Table_UseItem[sid].UseInterval
  if interval == nil then
    return false
  end
  local nextUseTime = self.usedtime or 0
  return 0 < ServerTime.CurServerTime() / 1000 - (nextUseTime + interval)
end
