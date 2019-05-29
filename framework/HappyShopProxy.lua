HappyShopProxy = class("HappyShopProxy", pm.Proxy)
HappyShopProxy.Instance = nil
HappyShopProxy.NAME = "HappyShopProxy"
HappyShopProxy.Config = {PicId = 50, ChipId = 110}
HappyShopProxy.LimitType = {
  OneDay = SessionShop_pb.ESHOPLIMITTYPE_USER,
  OneTime = SessionShop_pb.ESHOPLIMITTYPE_ONE_ONLY,
  AccUser = SessionShop_pb.ESHOPLIMITTYPE_ACC_USER,
  AccUserAlways = SessionShop_pb.ESHOPLIMITTYPE_ACC_USER_ALWAYS,
  UserWeek = SessionShop_pb.ESHOPLIMITTYPE_USER_WEEK,
  AccWeek = SessionShop_pb.ESHOPLIMITTYPE_ACC_WEEK,
  AccMonth = SessionShop_pb.ESHOPLIMITTYPE_ACC_MONTH,
  GuildMaterialWeek = SessionShop_pb.ESHOPLIMITTYPE_GUILD_MATERIAL_MAXCOUNT
}
HappyShopProxy.SourceType = {
  User = SessionShop_pb.ESHOPSOURCE_USER,
  Guild = SessionShop_pb.ESHOPSOURCE_GUILD,
  UserGuild = SessionShop_pb.ESHOPSOURCE_USER_GUILD
}
local temp = {}
local totalCostList = {}
local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.shop
local _SourceShop = ProtoCommon_pb.ESOURCE_SHOP
local GUILD_MATERIAL_TYPE = 988
function HappyShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or HappyShopProxy.NAME
  if HappyShopProxy.Instance == nil then
    HappyShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:PreProcessServant()
end
function HappyShopProxy:Init()
  self.shopItems = {}
  self.myProfessionItems = {}
  self.limitCountMap = {}
  self.tabItems = {}
end
function HappyShopProxy:InitShop(npcdata, params, shopType)
  self.npc = npcdata
  self.params = params
  self.shopType = shopType
  self.npcStaticid = npcdata and npcdata.data and npcdata.data.staticData and npcdata.data.staticData.id or 0
  self:InitMoneyType()
  self:InitAnimationConfig()
  self:InitShopData(shopType)
  self:CallQueryShopConfig()
end
function HappyShopProxy:RecvQueryShopConfig(data)
  if self.shopType == data.type then
    self:InitShopData(data.type)
  end
end
function HappyShopProxy:RecvUpdateShopConfigCmd(data)
  if self.shopType == data.type then
    self:InitShopData(data.type)
  end
end
function HappyShopProxy:InitMoneyType()
  self.defaultDesc = ZhString.HappyShop_defaultDesc
  local desc
  if self.shopType then
    local nfcfg = Table_NpcFunction[self.shopType]
    self.moneyTypes = nfcfg and nfcfg.Parama.ItemID or nil
    desc = nfcfg and nfcfg.Parama.Desc
  end
  self.desc = desc or self.defaultDesc
end
function HappyShopProxy:InitAnimationConfig()
  self.aniConfig = {}
  if self.shopType then
    local nfcfg = Table_NpcFunction[self.shopType]
    if nfcfg and nfcfg.Parama then
      self.aniConfig[1] = nfcfg.Parama.ShowSkip
      self.aniConfig[2] = nfcfg.Parama.AnimationName
      self.aniConfig[3] = nfcfg.Parama.SkipType
      self.aniConfig[4] = nfcfg.Parama.Effect
      self.aniConfig[5] = nfcfg.Parama.Audio
    end
  end
end
function HappyShopProxy:InitShopData(shopType)
  TableUtility.ArrayClear(self.shopItems)
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(shopType, self.params)
  if shopData then
    local config = shopData:GetGoods()
    for k, v in pairs(config) do
      TableUtility.ArrayPushBack(self.shopItems, k)
    end
    table.sort(self.shopItems, HappyShopProxy._SortItem)
    if shopData:CheckScreen() then
      self:SetMyProfessionItems(self.shopItems)
    end
    if shopData:CheckTab() then
      self:DivideByTab(self.shopItems)
    end
  end
end
function HappyShopProxy._SortItem(l, r)
  local _HappyShopProxy = HappyShopProxy.Instance
  local ldata = _HappyShopProxy:GetShopItemDataByTypeId(l)
  local rdata = _HappyShopProxy:GetShopItemDataByTypeId(r)
  if ldata.CanOpen ~= rdata.CanOpen then
    return not ldata:GetLock()
  elseif ldata.ShopOrder == rdata.ShopOrder then
    return ldata.id < rdata.id
  else
    return ldata.ShopOrder < rdata.ShopOrder
  end
end
function HappyShopProxy:UpdateQueryShopGotItem(data)
  self.cachedHaveBoughtItemCount = nil
  local items = data.items
  if items then
    for i = 1, #items do
      self:CachedHaveBoughtItemCount(items[i].id, items[i].count)
    end
  end
  if self.discountItemMap == nil then
    self.discountItemMap = {}
  else
    TableUtility.TableClear(self.discountItemMap)
  end
  for i = 1, #data.discountitems do
    local item = data.discountitems[i]
    self.discountItemMap[item.id] = item.count
  end
  if self.limitItemMap == nil then
    self.limitItemMap = {}
  else
    TableUtility.TableClear(self.limitItemMap)
  end
  for i = 1, #data.limititems do
    local item = data.limititems[i]
    self.limitItemMap[item.id] = item.count
  end
end
function HappyShopProxy:UpdateShopGotItem(data)
  local item = data.item
  if item then
    self:CachedHaveBoughtItemCount(item.id, item.count)
  end
  local discountitem = data.discountitem
  if discountitem then
    self.discountItemMap[discountitem.id] = discountitem.count
  end
  local limititem = data.limititem
  if limititem then
    self.limitItemMap[limititem.id] = limititem.count
  end
end
function HappyShopProxy:JudgeCanBuy(data)
  local canBuy = false
  local temp
  if data.goodsID then
    temp = Table_Equip[data.goodsID]
  else
    errorLog("HappyShopProxy JudgeCanBuy : data.goodsID = nil")
  end
  if temp then
    if #temp.CanEquip == 1 and temp.CanEquip[1] == 0 then
      canBuy = true
      return canBuy
    end
    for i = 1, #temp.CanEquip do
      if temp.CanEquip[i] == MyselfProxy.Instance:GetMyProfession() then
        canBuy = true
        return canBuy
      end
    end
  else
    canBuy = true
  end
  return canBuy
end
function HappyShopProxy:CachedHaveBoughtItemCount(id, count)
  if self.cachedHaveBoughtItemCount == nil then
    self.cachedHaveBoughtItemCount = {}
  end
  self.cachedHaveBoughtItemCount[id] = count
end
function HappyShopProxy:GetCachedHaveBoughtItemCount()
  return self.cachedHaveBoughtItemCount
end
function HappyShopProxy:GetNPC()
  return self.npc
end
function HappyShopProxy:GetShopItems()
  return self.shopItems
end
function HappyShopProxy:SetMyProfessionItems(datas)
  TableUtility.ArrayClear(self.myProfessionItems)
  for i = 1, #datas do
    local data = self:GetShopItemDataByTypeId(datas[i])
    if self:JudgeCanBuy(data) then
      TableUtility.ArrayPushBack(self.myProfessionItems, datas[i])
    end
  end
end
function HappyShopProxy:GetMyProfessionItems()
  return self.myProfessionItems
end
function HappyShopProxy:SetSelectId(id)
  self.selectId = id
end
function HappyShopProxy:GetSelectId()
  return self.selectId
end
function HappyShopProxy:GetMoneyType()
  return self.moneyTypes
end
function HappyShopProxy:GetScreen()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.params)
  if shopData then
    return shopData:CheckScreen()
  end
  return false
end
function HappyShopProxy:BuyShopItem(id, count)
  if self.buyItemList == nil then
    self.buyItemList = {}
  end
  if self.buyItemList[id] == nil then
    self.buyItemList[id] = count
  else
    self.buyItemList[id] = self.buyItemList[id] + count
  end
  if self.buyItemList[id] then
    self:BuyItem(id, self.buyItemList[id])
    self.buyItemList[id] = nil
  end
end
function HappyShopProxy:BuyItem(id, count)
  local item = self:GetShopItemDataByTypeId(id)
  if item == nil then
    return
  end
  self:BuyItemByShopItemData(item, count)
end
function HappyShopProxy:BuyItemByShopItemData(item, count)
  if item:CheckCanRemove() then
    MsgManager.ShowMsgByID(990)
    self:CallQueryShopConfig()
    return
  end
  if item.curProduceNum == 0 then
    MsgManager.ShowMsgByID(13000)
    return
  end
  local goodsID = item.goodsID
  local foreverLimitCount = GameConfig.Shop.forever_limit_item[goodsID]
  if foreverLimitCount ~= nil and foreverLimitCount <= self:GetLimitItemCount(goodsID) then
    MsgManager.ShowMsgByID(3436)
    return
  end
  if item.BaseLv == nil or MyselfProxy.Instance:RoleLevel() >= item.BaseLv then
    local canBuyCount, limitType = self:GetCanBuyCount(item)
    if canBuyCount ~= nil and (count > canBuyCount or canBuyCount == 0) then
      if limitType == self.LimitType.OneDay then
        MsgManager.ShowMsgByID(76)
      else
        MsgManager.ShowMsgByID(78)
      end
      return
    end
    local goodsStaticData = Table_Item[goodsID]
    local limitCfg = goodsStaticData.GetLimit
    if self:CheckLimitCount(limitCfg) then
      local limitCount = ItemData.Get_GetLimitCount(goodsID)
      local haveCount = self.limitCountMap[itemid] or 0
      limitCount = limitCount - haveCount
      if limitCount < 0 then
        limitCount = 0
      end
      if count > limitCount then
        local msgId
        if limitCfg.type == 1 then
          msgId = 64
        elseif limitCfg.type == 7 then
          msgId = 63
        end
        MsgManager.ShowMsgByID(msgId, goodsStaticData.NameZh)
        return
      end
    end
    TableUtility.ArrayClear(totalCostList)
    for i = 1, 5 do
      local temp = i
      if temp == 1 then
        temp = ""
      end
      local ItemID = item["ItemID" .. temp]
      if ItemID then
        totalCostList[i] = item:GetBuyFinalPrice(item["ItemCount" .. temp], count)
        local itemName = ""
        itemName = Table_Item[ItemID] and (Table_Item[ItemID].NameZh or "")
        local moneyCount = self:GetItemNum(ItemID, item.source)
        if moneyCount < totalCostList[i] then
          if itemName == "Zeny" then
            MsgManager.ShowMsgByIDTable(1)
          else
            MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_NotEnough, itemName)
          end
          return
        end
      end
    end
    if item.IfMsg ~= nil then
      local itemName = ""
      itemName = Table_Item[item.ItemID] and (Table_Item[item.ItemID].NameZh or "")
      MsgManager.ConfirmMsgByID(item.IfMsg, function()
        ServiceSessionShopProxy.Instance:CallBuyShopItem(item.id, count, totalCostList[1], totalCostList[2])
      end, nil, nil, item.ItemCount, itemName, goodsStaticData.NameZh or "")
    elseif item.presentMsgid ~= nil and item:CheckPresentMenu() then
      MsgManager.ConfirmMsgByID(item.presentMsgid, function()
        ServiceSessionShopProxy.Instance:CallBuyShopItem(item.id, count, totalCostList[1], totalCostList[2])
      end)
    else
      ServiceSessionShopProxy.Instance:CallBuyShopItem(item.id, count, totalCostList[1], totalCostList[2])
    end
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_levelNotEnough)
  end
end
function HappyShopProxy:CallQueryShopConfig()
  ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.params)
end
function HappyShopProxy:GetShopItemDataByTypeId(id)
  return ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.params, id)
end
function HappyShopProxy:GetItemNum(itemid, source)
  local moneyCount = 0
  if source == self.SourceType.Guild then
    moneyCount = GuildProxy.Instance:GetGuildPackItemNumByItemid(itemid)
  else
    local moneyId = GameConfig.MoneyId
    if itemid == moneyId.Zeny then
      moneyCount = MyselfProxy.Instance:GetROB()
    elseif itemid == moneyId.PvpCoin then
      moneyCount = MyselfProxy.Instance:GetPvpCoin()
    elseif itemid == moneyId.Lottery then
      moneyCount = MyselfProxy.Instance:GetLottery()
    elseif itemid == moneyId.GuildHonor then
      moneyCount = MyselfProxy.Instance:GetGuildHonor()
    elseif itemid == moneyId.Contribute then
      moneyCount = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CONTRIBUTE) or 0
    elseif itemid == moneyId.Gods then
      moneyCount = GuildProxy.Instance:GetGuildPackItemNumByItemid(itemid)
    elseif itemid == moneyId.Quota then
      moneyCount = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA) or 0
    else
      moneyCount = self:GetItemNumByStaticID(itemid)
    end
  end
  return moneyCount
end
function HappyShopProxy:GetItemNumByStaticID(itemid)
  local _BagProxy = BagProxy.Instance
  local count = 0
  for i = 1, #packageCheck do
    count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
  end
  return count
end
function HappyShopProxy:GetCanBuyCount(data)
  local isOneDay = data:CheckLimitType(self.LimitType.OneDay)
  local isAccUser = data:CheckLimitType(self.LimitType.AccUser)
  local isAccUserAlways = data:CheckLimitType(self.LimitType.AccUserAlways)
  local isUserWeek = data:CheckLimitType(self.LimitType.UserWeek)
  local isAccWeek = data:CheckLimitType(self.LimitType.AccWeek)
  local isAccMonth = data:CheckLimitType(self.LimitType.AccMonth)
  local isGuildMaterial = data:CheckLimitType(self.LimitType.GuildMaterialWeek)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData and isGuildMaterial then
    local limitCount = GuildBuildingProxy.Instance:GetGuildMaterialLimitCount()
    if limitCount and limitCount ~= 0 then
      return limitCount - myGuildData.material_machine_count, self.LimitType.GuildMaterialWeek
    end
  end
  if data.LimitNum ~= 0 and (isOneDay or isAccUser or isAccUserAlways or isUserWeek or isAccWeek or isAccMonth) then
    local boughtCount = 0
    local haveBoughtItemCount = self:GetCachedHaveBoughtItemCount()
    if haveBoughtItemCount ~= nil then
      boughtCount = haveBoughtItemCount[data.id] or 0
    end
    if isOneDay then
      return data.LimitNum - boughtCount, self.LimitType.OneDay
    elseif isAccUser then
      return data.LimitNum - boughtCount, self.LimitType.AccUser
    elseif isAccUserAlways then
      return data.LimitNum - boughtCount, self.LimitType.AccUserAlways
    elseif isAccWeek then
      return data.LimitNum - boughtCount, self.LimitType.AccWeek
    elseif isAccMonth then
      return data.LimitNum - boughtCount, self.LimitType.AccMonth
    elseif isUserWeek then
      return data.LimitNum - boughtCount, self.LimitType.UserWeek
    end
  end
  return nil
end
function HappyShopProxy:IsShowSkip()
  return self.aniConfig and self.aniConfig[1] or false
end
local ActionConfig = {
  ActionId = 506,
  IdleActionId = 505,
  LeanTime = 1.5
}
local defaultEff, defaultAudio, defaultAni = "Common/Lottery", "Common/LotteryMech", "functional_action"
function HappyShopProxy:PlayAnimationEff()
  local isSkip = LocalSaveProxy.Instance:GetSkipAnimation(self.aniConfig[3])
  if isSkip then
    return
  end
  local npcID = self.npc.data:GetGuid()
  local npcRole = SceneCreatureProxy.FindCreature(npcID)
  if npcRole then
    local ani = self.aniConfig[2] or defaultAni
    self:PlayAction(npcRole, ActionConfig.ActionId)
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    local effect = self.aniConfig[4] or defaultEff
    self.effect = npcRole:PlayEffect(nil, effect, 0, nil, nil, true)
    self.effect:RegisterWeakObserver(self)
    local audio = self.aniConfig[5] or defaultAudio
    npcRole:PlayAudio(audio)
  end
  self:RemoveLeanTween()
  self.lean = LeanTween.delayedCall(ActionConfig.LeanTime, function()
    self:PlayAction(npcRole, ActionConfig.IdleActionId)
  end)
end
function HappyShopProxy:PlayAction(npc, actionId)
  if npc ~= nil and actionId ~= nil then
    local actionName
    local config = Table_ActionAnime[actionId]
    if config ~= nil then
      actionName = config.Name
    end
    if actionName ~= nil then
      npc:Client_PlayAction(actionName, nil, false)
    end
  end
end
local strengthenAnimName = "functional_action"
local waitAnimName = "wait"
function HappyShopProxy:PlayFunctionalAction()
  local npcID = self.npc.data:GetGuid()
  local npcRole = SceneCreatureProxy.FindCreature(npcID)
  local animParams = Asset_Role.GetPlayActionParams(strengthenAnimName, nil, 1)
  animParams[7] = function()
    animParams = Asset_Role.GetPlayActionParams(waitAnimName, nil, 1)
    npcRole.assetRole:PlayActionRaw(animParams)
  end
  npcRole.assetRole:PlayActionRaw(animParams)
end
function HappyShopProxy:RemoveLeanTween()
  if self.lean then
    local npcID = self.npc.data:GetGuid()
    local npcRole = SceneCreatureProxy.FindCreature(npcID)
    self:PlayAction(npcRole, ActionConfig.IdleActionId)
    self.lean:cancel()
    self.lean = nil
  end
end
function HappyShopProxy:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
  end
end
function HappyShopProxy:SetLimitCount(itemid, count)
  if itemid ~= nil then
    self.limitCountMap[itemid] = count or 0
  end
end
local _SourceShop = ProtoCommon_pb.ESOURCE_SHOP
function HappyShopProxy:CheckLimitCount(limitCfg)
  if limitCfg == nil then
    return false
  end
  if limitCfg.type == nil then
    return false
  end
  if limitCfg.source == nil then
    return true
  else
    for i = 1, #limitCfg.source do
      if limitCfg.source[i] == _SourceShop then
        return true
      end
    end
  end
  return false
end
function HappyShopProxy:GetDiscountItemCount(shopid)
  return self.discountItemMap[shopid] or 0
end
function HappyShopProxy:GetLimitItemCount(itemid)
  return self.limitItemMap[itemid] or 0
end
function HappyShopProxy:GetShopType()
  return self.shopType
end
function HappyShopProxy:isGuildMaterialType()
  return GUILD_MATERIAL_TYPE == self:GetShopType()
end
function HappyShopProxy:GetShopId()
  return self.params
end
function HappyShopProxy:DivideByTab(datas)
  TableUtility.ArrayClear(self.tabItems)
  local len = #datas
  for i = 1, len do
    local data = self:GetShopItemDataByTypeId(datas[i])
    if not self.tabItems[data.tabid] and data.tabid then
      self.tabItems[data.tabid] = {}
    end
    if data.tabid then
      TableUtility.ArrayPushBack(self.tabItems[data.tabid], datas[i])
    end
  end
end
function HappyShopProxy:GetTabItem(tabid)
  if self.tabItems then
    return self.tabItems[tabid] or {}
  end
  return {}
end
function HappyShopProxy:GetTab()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.params)
  if shopData then
    return shopData:CheckTab()
  end
  return false
end
function HappyShopProxy:PreProcessServant()
  if not self.servantShopMap then
    self.servantShopMap = {}
  else
    TableUtility.TableClear(self.servantShopMap)
  end
  local cfg = GameConfig.Servant.description
  for k, v in pairs(cfg) do
    local single = {}
    single.k = k
    single.npcid = v.id
    single.param = v.param
    single.type = v.type
    local npcdata = Table_Npc[v.id]
    single.icon = npcdata.Icon
    single.menuid = v.menuid or 0
    self.servantShopMap[v.id] = single
  end
end
function HappyShopProxy:GetServantShopMap()
  return self.servantShopMap
end
function HappyShopProxy:GetNPCStaticid()
  return self.npcStaticid
end
