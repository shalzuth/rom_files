autoImport("ShopData")
ShopProxy = class("ShopProxy", pm.Proxy)
ShopProxy.Instance = nil
ShopProxy.NAME = "ShopProxy"
function ShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ShopProxy.NAME
  if ShopProxy.Instance == nil then
    ShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ShopProxy:Init()
  self.info = {}
  self.callTime = {}
end
function ShopProxy:CallQueryShopConfig(type, shopID)
  local currentTime = Time.unscaledTime
  local nextValidTime
  local infoMap = self.info[type]
  if infoMap and infoMap[shopID] then
    nextValidTime = infoMap[shopID]:GetNextValidTime()
  end
  if nextValidTime == nil or currentTime >= nextValidTime then
    if infoMap == nil then
      infoMap = {}
      self.info[type] = infoMap
    end
    if infoMap[shopID] == nil then
      infoMap[shopID] = ShopData.new()
      self.info[type][shopID] = infoMap[shopID]
    end
    infoMap[shopID]:SetNextValidTime(5)
    helplog("CallQueryShopConfigCmd", type, shopID)
    ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(type, shopID)
  end
end
function ShopProxy:RecvQueryShopConfig(servicedata)
  local type = servicedata.type
  local shopID = servicedata.shopid
  local goods = servicedata.goods
  local infoMap = self.info[type]
  if infoMap == nil then
    infoMap = {}
    self.info[type] = infoMap
  end
  if infoMap[shopID] == nil then
    infoMap[shopID] = ShopData.new(servicedata)
    self.info[type][shopID] = infoMap[shopID]
  else
    infoMap[shopID]:SetData(servicedata)
  end
  infoMap[shopID]:SetNextValidTime(60)
end
function ShopProxy:RecvServerLimitSellCountCmd(servicedata)
  local config = self:GetConfigByTypeId(servicedata.type, servicedata.shopID)
  if config then
    for i = 1, #servicedata.sell_infos do
      local data = servicedata.sell_infos[i]
      local shopItemData = config[data.id]
      if shopItemData ~= nil then
        shopItemData:SetCurProduceNum(data.sell_count)
      end
    end
  end
end
function ShopProxy:RecvShopDataUpdateCmd(servicedata)
  local infoMap = self.info[servicedata.type]
  if infoMap ~= nil then
    local shop = infoMap[servicedata.shopid]
    if shop ~= nil then
      shop:SetNextValidTime(0)
    end
  end
end
function ShopProxy:RecvUpdateShopConfigCmd(servicedata)
  local infoMap = self.info[servicedata.type]
  if infoMap ~= nil then
    local shop = infoMap[servicedata.shopid]
    if shop ~= nil then
      for i = 1, #servicedata.add_goods do
        shop:AddShopItemData(servicedata.add_goods[i])
      end
      for i = 1, #servicedata.del_goods_id do
        shop:RemoveShopItemData(servicedata.del_goods_id[i])
      end
    end
  end
end
function ShopProxy:GetConfigByType(type)
  return self.info[type] or {}
end
function ShopProxy:GetConfigByTypeId(type, shopID)
  local infoMap = self.info[type]
  if infoMap and infoMap[shopID] then
    return infoMap[shopID]:GetGoods()
  end
  return {}
end
function ShopProxy:GetShopDataByTypeId(type, shopID)
  local infoMap = self.info[type]
  if infoMap then
    return infoMap[shopID]
  end
  return nil
end
function ShopProxy:GetShopItemDataByTypeId(type, shopID, id)
  local config = self:GetConfigByTypeId(type, shopID)
  if config then
    return config[id]
  end
  return nil
end
function ShopProxy:Server_SetShopSoldCountCmdInfo(server_items)
  if server_items == nil or #server_items == 0 then
    return
  end
  for i = 1, #server_items do
    local item = server_items[i]
    local shopData = self:GetShopDataByTypeId(item.type, item.shopid)
    helplog(item.type, item.shopid)
    if shopData then
      local shopItemData = shopData.goods[item.id]
      if shopItemData then
        helplog(item.count)
        shopItemData:SetSoldCount(item.count)
      end
    end
  end
end
function ShopProxy:XDSDKPay(price, s_id, product_id, product_name, role_id, ext, product_count, order_id, on_pay_success, on_pay_fail, on_pay_cancel, on_pay_timeout, on_pay_product_illegal)
  EventManager.Me():PassEvent(ZenyShopEvent.OpenBoxCollider, nil)
  local on_pay_success_func = function()
    if on_pay_success then
      on_pay_success()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_fail_func = function()
    if on_pay_fail then
      on_pay_fail()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_cancel_func = function()
    if on_pay_cancel then
      on_pay_cancel()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_timeout_func = function()
    if on_pay_timeout then
      on_pay_timeout()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_product_illegal_func = function()
    if on_pay_product_illegal then
      on_pay_product_illegal()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  FunctionSDK.Instance:XDSDKPay(price, s_id, product_id, product_name, role_id, ext, product_count, order_id, on_pay_success_func, on_pay_fail_func, on_pay_cancel_func, on_pay_timeout_func, on_pay_product_illegal_func)
end
function ShopProxy:SelfDebug(msg)
  if false then
    helplog(msg)
  end
end
function ShopProxy:IsThisItemCanBuyNow(id)
  local data = Table_Deposit[id]
  if data.TF_OpenTime and data.TF_CloseTime and data.Release_OpenTime and data.Release_CloseTime then
  else
    self:SelfDebug("\233\133\141\231\189\174\232\161\168\230\156\137\233\151\174\233\162\152 \230\137\190\228\184\165\231\180\171\232\150\135")
    return false
  end
  local StartDate, FinishDate
  if EnvChannel.IsTFBranch() then
    StartDate = data.TF_OpenTime
    FinishDate = data.TF_CloseTime
  else
    StartDate = data.Release_OpenTime
    FinishDate = data.Release_CloseTime
  end
  if StartDate and FinishDate then
    if StartDate == "" and FinishDate == "" then
      self:SelfDebug("\230\176\184\228\185\133")
      return true
    elseif KFCARCameraProxy.Instance:CheckDateValid(StartDate, FinishDate) then
      return true
    else
      self:SelfDebug("\228\184\141\229\156\168\230\180\187\229\138\168\230\151\182\233\151\180")
      return false
    end
  else
    self:SelfDebug("\231\173\150\229\136\146\230\178\161\233\133\141\230\180\187\229\138\168\230\151\182\233\151\180")
    return false
  end
end
