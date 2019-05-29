EnchantAttri = class("EnchantAttri")
EnchantAttriQuality = {
  Good = "EnchantAttriQuality_Good",
  Normal = "EnchantAttriQuality_Normal",
  Bad = "EnchantAttriQuality_Bad"
}
function EnchantAttri:ctor(enchantType, attri, itemId)
  self.itemId = itemId
  self.itemType = Table_Item[itemId].Type
  self.enchantType = enchantType
  self.type = attri.type
  self.serverValue = attri.value
  self.propVO = EnchantEquipUtil.Instance:GetAttriPropVO(attri.type)
  self.value = self.propVO.isPercent and attri.value / 10 or attri.value
  self.name = self.propVO and self.propVO.displayName
  self.typekey = self.propVO.name
  local enchantData = EnchantEquipUtil.Instance:GetEnchantData(self.enchantType, self.typekey, self.itemType)
  if not enchantData then
    redlog(string.format("(%s %s) not Find EnchantData", self.typekey, self.propVO.displayName))
    return
  end
  self.staticData = enchantData
  local attriBound = self.staticData.AttrBound[1]
  if self.propVO.isPercent then
    self.isMax = self.value >= attriBound[2] * 100
  else
    self.isMax = self.value >= attriBound[2]
  end
  self.Quality = EnchantAttriQuality.Normal
  if self.staticData.ExpressionOfMaxUp then
    local maxJudge = self.staticData.ExpressionOfMaxUp * attriBound[2]
    if self.propVO.isPercent then
      maxJudge = maxJudge * 100
    end
    if self:IsValuable() and maxJudge <= self.value then
      self.Quality = EnchantAttriQuality.Good
    end
  end
  if self.staticData.ExpressionOfMaxDown then
    local minJudge = self.staticData.ExpressionOfMaxDown * attriBound[2]
    if self.propVO.isPercent then
      minJudge = minJudge * 100
    end
    if minJudge >= self.value then
      self.Quality = EnchantAttriQuality.Bad
    end
  end
end
function EnchantAttri:IsValuable()
  local compareValue = GameConfig.Exchange.GoodRate or 1.3
  local value = EnchantEquipUtil.Instance:GetPriceRate(self.typekey, self.itemType)
  return compareValue <= value
end
EnchantInfo = class("EnchantInfo")
EnchantType = {
  Primary = SceneItem_pb.EENCHANTTYPE_PRIMARY,
  Medium = SceneItem_pb.EENCHANTTYPE_MEDIUM,
  Senior = SceneItem_pb.EENCHANTTYPE_SENIOR
}
function EnchantInfo:ctor(itemId)
  self.itemId = itemId
  self.enchantAttrs = {}
  self.combineEffectlist = {}
  self.cacheEnchantAttrs = {}
  self.cacheCombineEffectlist = {}
end
function EnchantInfo:SetServerData(serverData)
  TableUtility.ArrayClear(self.enchantAttrs)
  TableUtility.ArrayClear(self.combineEffectlist)
  self.enchantType = serverData.type
  for i = 1, #serverData.attrs do
    local attri = serverData.attrs[i]
    table.insert(self.enchantAttrs, self:SetServerAttri(attri, self.enchantType))
  end
  local ebuffids = serverData.extras
  if ebuffids then
    for i = 1, #ebuffids do
      local ebuff = ebuffids[i]
      local id, configid = ebuff.buffid, ebuff.configid
      local cbeData = self:SetCombineEffect(id, configid, self.enchantAttrs)
      if cbeData then
        table.insert(self.combineEffectlist, cbeData)
      end
    end
  end
end
function EnchantInfo:SetCacheServerData(serverData)
  TableUtility.ArrayClear(self.cacheEnchantAttrs)
  TableUtility.ArrayClear(self.cacheCombineEffectlist)
  self.cacheEnchantType = serverData.type
  local cacheServAttrs = serverData.attrs
  if cacheServAttrs and #cacheServAttrs > 0 then
    for i = 1, #cacheServAttrs do
      local csattr = cacheServAttrs[i]
      table.insert(self.cacheEnchantAttrs, self:SetServerAttri(csattr, self.cacheEnchantType))
    end
    local ebuffids = serverData.extras
    if ebuffids then
      for i = 1, #ebuffids do
        local ebuff = ebuffids[i]
        local id, configid = ebuff.buffid, ebuff.configid
        local cbeData = self:SetCombineEffect(id, configid, self.cacheEnchantAttrs)
        if cbeData then
          table.insert(self.cacheCombineEffectlist, cbeData)
        end
      end
    end
  end
end
function EnchantInfo:SetServerAttri(attri, enchantType)
  return EnchantAttri.new(enchantType, attri, self.itemId)
end
function EnchantInfo:SetCombineEffect(buffid, configid, attrlist)
  if buffid then
    local cbeData = {}
    cbeData.buffid = buffid
    cbeData.configid = configid
    cbeData.buffData = Table_Buffer[buffid]
    if not cbeData.buffData then
      redlog(string.format("Not Have Buff(%s)", tostring(buffid)))
      return nil
    end
    cbeData.isWork = false
    cbeData.Condition = {}
    local attriLst = {}
    for i = 1, #attrlist do
      table.insert(attriLst, attrlist[i].typekey)
    end
    local sdata = EnchantEquipUtil.Instance:GetCombineEffect(configid)
    if sdata then
      cbeData.Condition = sdata.Condition
      if sdata.Condition.type == 1 then
        cbeData.WorkTip = string.format(ZhString.EnchantInfo_RefineCondition, tostring(sdata.Condition.refinelv))
      end
    end
    cbeData.enchantData = sdata
    return cbeData
  end
  return nil
end
function EnchantInfo:UpdateCombineEffectWork(refinelv)
  for i = 1, #self.combineEffectlist do
    local combineEffect = self.combineEffectlist[i]
    if combineEffect.Condition and combineEffect.Condition.type == 1 then
      local needlv = combineEffect.Condition.refinelv
      combineEffect.isWork = refinelv >= needlv
    end
  end
  for i = 1, #self.cacheCombineEffectlist do
    local combineEffect = self.cacheCombineEffectlist[i]
    if combineEffect.Condition and combineEffect.Condition.type == 1 then
      local needlv = combineEffect.Condition.refinelv
      combineEffect.isWork = refinelv >= needlv
    end
  end
end
function EnchantInfo:GetEnchantAttrs()
  return self.enchantAttrs
end
function EnchantInfo:GetCombineEffects()
  return self.combineEffectlist
end
function EnchantInfo:GetCacheEnchantAttrs()
  return self.cacheEnchantAttrs
end
function EnchantInfo:GetCacheCombineEffects()
  return self.cacheCombineEffectlist
end
function EnchantInfo:HasAttri()
  return #self.enchantAttrs > 0
end
function EnchantInfo:HasUnSaveAttri()
  return #self.cacheEnchantAttrs > 0
end
function EnchantInfo:HasNewGoodAttri()
  local hasGood = false
  for i = 1, #self.cacheEnchantAttrs do
    local attir = self.cacheEnchantAttrs[i]
    if attir.Quality == EnchantAttriQuality.Good then
      hasGood = true
      break
    end
  end
  hasGood = hasGood or #self.cacheCombineEffectlist > 0
  return hasGood
end
local TradeBanBuffIdMap = {
  500061,
  500062,
  500063,
  500064,
  500001,
  500002,
  500003,
  500004
}
function EnchantInfo:IsShowWhenTrade()
  local itemType = Table_Item[self.itemId].Type
  local rateKey = EnchantEquipTypeRateMap[itemType]
  if rateKey and #self.combineEffectlist > 0 then
    for i = 1, #self.combineEffectlist do
      local combineEffect = self.combineEffectlist[i]
      if combineEffect.enchantData.NoExchangeEnchant[rateKey] == 1 then
        return false
      end
      local buffid = combineEffect.buffid
      if buffid and TradeBanBuffIdMap[buffid] == 1 then
        return false
      end
    end
    return true
  end
  return false
end
