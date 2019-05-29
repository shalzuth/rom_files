FunctionTempItem = class("FunctionTempItem")
FunctionTempItem.WarnningMin = 1440
function FunctionTempItem.Me()
  if nil == FunctionTempItem.me then
    FunctionTempItem.me = FunctionTempItem.new()
  end
  return FunctionTempItem.me
end
function FunctionTempItem:ctor()
  self.tempItemCount = 0
  self.tempItemMap = {}
  self.useIntervalCheckCount = 0
  self.useIntervalCheckMap = {}
  self.useIntervalCount = 0
  self.useIntervalMap = {}
end
function FunctionTempItem:CheckItemInDelCD(itemguid)
  if itemguid ~= nil then
    return self.tempItemMap[itemguid] ~= nil
  end
  return false
end
function FunctionTempItem:AddTempItemDelCheck(itemguid, delTime)
  if not self.tempItemMap[itemguid] then
    self.tempItemCount = self.tempItemCount + 1
  end
  self.tempItemMap[itemguid] = delTime
  self:CheckTempItemDelTime()
end
function FunctionTempItem:RemoveTempItemDelCheck(itemguid)
  if self.tempItemMap[itemguid] then
    self.tempItemCount = self.tempItemCount - 1
  end
  self.tempItemMap[itemguid] = nil
  self:CheckTempItemDelTime()
end
function FunctionTempItem:CheckTempItemDelTime()
  if self.tempItemCount > 0 then
    if not self.timeTick then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.RefreshTempItemDelTime, self, 1)
    end
  elseif self.timeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
end
function FunctionTempItem:RefreshTempItemDelTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  for itemguid, delTime in pairs(self.tempItemMap) do
    local leftTotalSec = delTime - curServerTime
    if leftTotalSec <= 0 then
      self:RemoveTempItemDelCheck(itemguid)
    elseif leftTotalSec <= FunctionTempItem.WarnningMin * 60 then
      local itemData = BagProxy.Instance:GetItemByGuid(itemguid, BagProxy.BagType.Temp)
      if itemData and not itemData:GetDelWarningState() then
        itemData:SetDelWarningState(true)
        GameFacade.Instance:sendNotification(TempItemEvent.TempWarnning, itemguid)
      end
    end
  end
end
function FunctionTempItem:AddUseIntervalCheck(item, interval)
  local itemguid = item.id
  local canIntervalUse = item:CanIntervalUse()
  self:UpdateUseIntervalMap(itemguid, canIntervalUse)
  if canIntervalUse then
    GameFacade.Instance:sendNotification(ItemEvent.UseTimeUpdate)
    return
  end
  if not self.useIntervalCheckMap[itemguid] then
    self.useIntervalCheckCount = self.useIntervalCheckCount + 1
  end
  local usedtime = item.usedtime or 0
  self.useIntervalCheckMap[itemguid] = usedtime + interval
  self:CheckUseInterval()
end
function FunctionTempItem:CheckUseInterval()
  if self.useIntervalCheckCount > 0 then
    if not self.useTimeTick then
      self.useTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.RefreshTempItemUseTime, self, 1)
    end
  elseif self.useTimeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.useTimeTick = nil
  end
end
function FunctionTempItem:RefreshTempItemUseTime()
  local dirty = false
  for itemguid, useTime in pairs(self.useIntervalCheckMap) do
    local item = BagProxy.Instance:GetItemByGuid(itemguid, BagProxy.BagType.MainBag)
    if item:CanIntervalUse() then
      dirty = true
      GameFacade.Instance:sendNotification(ItemEvent.UseTimeUpdate)
      self:RemoveItemIntervalUseCheck(itemguid)
      self:UpdateUseIntervalMap(itemguid, true)
    end
  end
  if dirty then
    self:CheckUseInterval()
  end
end
function FunctionTempItem:RemoveItemIntervalUseCheck(itemguid)
  self.useIntervalCheckCount = self.useIntervalCheckCount - 1
  if self.useIntervalCheckCount == 0 then
    GameFacade.Instance:sendNotification(ItemEvent.UseTimeUpdate)
  end
  self.useIntervalCheckMap[itemguid] = nil
end
FunctionTempItem.UseIntervalRedTip = 800
function FunctionTempItem:UpdateUseIntervalMap(itemguid, active)
  local In = self.useIntervalMap[itemguid] ~= nil
  if In ~= active then
    if active then
      self.useIntervalMap[itemguid] = 1
      self.useIntervalCount = self.useIntervalCount + 1
    else
      self.useIntervalMap[itemguid] = nil
      self.useIntervalCount = self.useIntervalCount - 1
    end
    if self.useIntervalCount == 1 then
      redlog("FunctionTempItem Add IntervalMap!!!!!!!", FunctionTempItem.UseIntervalRedTip)
      RedTipProxy.Instance:UpdateRedTip(FunctionTempItem.UseIntervalRedTip)
    elseif self.useIntervalCount == 0 then
      redlog("FunctionTempItem Remove IntervalMap!!!!!!!", FunctionTempItem.UseIntervalRedTip)
      RedTipProxy.Instance:RemoveWholeTip(FunctionTempItem.UseIntervalRedTip)
    end
  end
end
function FunctionTempItem:ClearUseIntervalMap()
  self.useIntervalMap = {}
  self.useIntervalCount = 0
end
function FunctionTempItem:RemoveIntervalUseItem(itemguid)
  self:RemoveItemIntervalUseCheck(itemguid)
  self:UpdateUseIntervalMap(itemguid, false)
end
