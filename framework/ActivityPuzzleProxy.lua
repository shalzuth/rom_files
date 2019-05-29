ActivityPuzzleProxy = class("ActivityPuzzleProxy", pm.Proxy)
ActivityPuzzleProxy.Instance = nil
ActivityPuzzleProxy.NAME = "ActivityPuzzleProxy"
function ActivityPuzzleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityPuzzleProxy.NAME
  if ActivityPuzzleProxy.Instance == nil then
    ActivityPuzzleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end
local GetActivityPuzzleData = function(activityId, puzzleId)
  if Table_ActivityPuzzle then
    for i, v in ipairs(Table_ActivityPuzzle) do
      if v.ActivityID == activityId and v.PuzzleID == puzzleId then
        return v
      end
    end
  end
  return nil
end
function ActivityPuzzleProxy:InitProxy()
  self.activityPuzzleDataMap = {}
  self:InitActivityPuzzleData()
end
function ActivityPuzzleProxy:InitProxyData()
  TableUtility.TableClear(self.activityPuzzleDataMap)
end
function ActivityPuzzleProxy:GetActivityPuzzleDatas(actId)
  return self.activityPuzzleDataMap[actId]
end
function ActivityPuzzleProxy:GetActivityPuzzleItemData(actId, puzzleId)
  local puzzleData = self.activityPuzzleDataMap[actId]
  if puzzleData and puzzleData.puzzleItemMap then
    return puzzleData.puzzleItemMap[puzzleId]
  end
  return nil
end
function ActivityPuzzleProxy:GetActivityPuzzleDataList()
  local serverTime = ServerTime.CurServerTime() / 1000
  local activityPuzzleDataList = {}
  for k, v in pairs(self.activityPuzzleDataMap) do
    local single = Table_ActivityInfo[k]
    if single and serverTime > single.StartTimeStamp and serverTime < single.EndTimeStamp then
      activityPuzzleDataList[#activityPuzzleDataList + 1] = v
    end
  end
  return activityPuzzleDataList
end
function ActivityPuzzleProxy:GetActivityPuzzleProgress(actId)
  local puzzleData = self.activityPuzzleDataMap[actId]
  local progress = 0
  if puzzleData then
    local itemList = puzzleData.puzzleItemList
    if itemList and #itemList > 0 then
      local lastBigestUnlockTime = 0
      for i = 1, #itemList do
        local staticData = GetActivityPuzzleData(itemList[i].actid, itemList[i].puzzled)
        if staticData and staticData.UnlockType == 100 and staticData.UnlockTime and lastBigestUnlockTime < staticData.UnlockTime then
          progress = itemList[i].process
          lastBigestUnlockTime = staticData.UnlockTime
        end
      end
    end
  end
  return progress
end
function ActivityPuzzleProxy:HandleRecvActivityPuzzleDataCmd(data)
  local actItems = data.actitem
  if actItems and #actItems > 0 then
    for i = 1, #actItems do
      local actItem = actItems[i]
      local activityId = actItem.actid
      if (not activityId or activityId == 0) and actItem.items and 0 < #actItem.items then
        activityId = actItem.items[1].actid
      end
      if activityId and activityId ~= 0 then
        redlog("==activityId==>>>>", activityId)
        local oldData = self.activityPuzzleDataMap[activityId]
        if not oldData then
          activityPuzzleData = ActivityPuzzleData.new(actItem, activityId)
          self.activityPuzzleDataMap[activityId] = activityPuzzleData
        else
          oldData:updata(actItem, activityId)
        end
      end
    end
  end
end
function ActivityPuzzleProxy:InitActivityPuzzleData()
  if not Table_ActivityInfo then
    return
  end
  for k, v in pairs(Table_ActivityInfo) do
    if k ~= 0 then
      local actItem = {actid = k}
      local oldData = self.activityPuzzleDataMap[k]
      if not oldData then
        activityPuzzleData = ActivityPuzzleData.new(actItem, k)
        self.activityPuzzleDataMap[k] = activityPuzzleData
      end
    end
  end
end
function ActivityPuzzleProxy:HandleRecvActivityIdUpdateCmd(data)
  local updateIds = data.update_ids
  if updateIds and #updateIds > 0 then
    for i = 1, #updateIds do
      local actItem = {
        actid = updateIds[i]
      }
      local oldData = self.activityPuzzleDataMap[actItem.actid]
      if not oldData then
        local activityPuzzleData = ActivityPuzzleData.new(actItem, actItem.actid)
        self.activityPuzzleDataMap[actItem.actid] = activityPuzzleData
        redlog("new date", actItem.actid)
      else
        oldData:updata(actItem, actItem.actid)
        redlog("update date", actItem.actid)
      end
    end
  end
  local delIds = data.del_ids
  if delIds and #delIds > 0 then
    for i = 1, #delIds do
      self.activityPuzzleDataMap[delIds[i]] = nil
    end
  end
end
function ActivityPuzzleProxy:HandleRecvUpdatePuzzleItemCmd(data)
  local actItems = data.items
  if actItems and #actItems > 0 then
    for i = 1, #actItems do
      local item = actItems[i]
      local itemList = {}
      itemList[1] = item
      local actItem = {
        actid = item.actid,
        items = itemList
      }
      local oldData = self.activityPuzzleDataMap[actItem.actid]
      if not oldData then
        local activityPuzzleData = ActivityPuzzleData.new(actItem, actItem.actid)
        self.activityPuzzleDataMap[actItem.actid] = activityPuzzleData
      else
        oldData:updata(actItem, actItem.actid)
      end
    end
  end
end
function ActivityPuzzleProxy:IsRedTipNeedToShow()
  local serverTime = ServerTime.CurServerTime() / 1000
  local isRedTipNeedShow = false
  for k, v in pairs(self.activityPuzzleDataMap) do
    local single = Table_ActivityInfo[k]
    if single and serverTime >= single.StartTimeStamp and serverTime < single.EndTimeStamp then
      local itemList = v.puzzleItemList
      if itemList and #itemList > 0 then
        for i = 1, #itemList do
          local item = itemList[i]
          if item.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE then
            isRedTipNeedShow = true
            break
          end
        end
      end
    end
    if not isRedTipNeedShow then
    end
  end
  return isRedTipNeedShow
end
function ActivityPuzzleProxy:AddToActivityPuzzleDataMap(updateid)
  local actItem = {actid = updateid}
  local oldData = self.activityPuzzleDataMap[actItem.actid]
  if oldData then
    return false
  else
    local activityPuzzleData = ActivityPuzzleData.new(actItem, actItem.actid)
    self.activityPuzzleDataMap[actItem.actid] = activityPuzzleData
    return true
  end
end
function ActivityPuzzleProxy:RemoveFromActivityPuzzleDataMap(updateid)
  self.activityPuzzleDataMap[updateid] = nil
end
ActivityPuzzleData = class("ActivityPuzzleData")
function ActivityPuzzleData:ctor(data, activityId)
  self.actid = activityId
  if not self.puzzleItemList then
    self.puzzleItemList = {}
    self.puzzleItemMap = {}
  end
  local ai = Table_ActivityInfo[self.actid]
  if ai and ai.Size then
    for i = 1, ai.Size do
      local newPuzzleItem = ActivityPuzzleItem.new()
      self.puzzleItemMap[i] = newPuzzleItem
      self.puzzleItemList[#self.puzzleItemList + 1] = newPuzzleItem
    end
  end
  if data then
    self:updata(data, activityId)
  end
end
function ActivityPuzzleData:updata(data, activityId)
  self.actid = activityId
  local puzzleItems = data.items
  if not self.puzzleItemList then
    self.puzzleItemList = {}
    self.puzzleItemMap = {}
  end
  if puzzleItems and #puzzleItems > 0 then
    for i = 1, #puzzleItems do
      local item = puzzleItems[i]
      if type(item) ~= "table" then
        item = {item}
      end
      local puzzleId = item.puzzled
      local oldPuzzleItem = self.puzzleItemMap[puzzleId]
      if oldPuzzleItem then
        oldPuzzleItem:updata(item)
      else
        local newPuzzleItem = ActivityPuzzleItem.new(item)
        self.puzzleItemMap[puzzleId] = newPuzzleItem
        self.puzzleItemList[#self.puzzleItemList + 1] = newPuzzleItem
      end
    end
  end
end
ActivityPuzzleItem = class("ActivityPuzzleItem")
function ActivityPuzzleItem:ctor(data)
  self.puzzled = 0
  self.process = 0
  self.PuzzleState = EPUZZLESTATE_MIN
  if data then
    self:updata(data)
  end
end
function ActivityPuzzleItem:updata(data)
  self.actid = data.actid
  self.puzzled = data.puzzled
  self.process = data.process
  self.PuzzleState = data.state
end
