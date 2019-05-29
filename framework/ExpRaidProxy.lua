autoImport("DojoRewardData")
ExpRaidProxy = class("ExpRaidProxy", pm.Proxy)
function ExpRaidProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "ExpRaidProxy"
  if not ExpRaidProxy.Instance then
    ExpRaidProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end
function ExpRaidProxy:Init()
  self.raidType = 0
end
function ExpRaidProxy:InitShop(npc, raidType)
  self.shopNpc = npc
  self.raidType = raidType
  self:InitShopNpcItemDataMap()
  self:InitItemPriceMap()
end
function ExpRaidProxy:InitShopNpcItemDataMap()
  if not self.shopNpcItemDataMap then
    self.shopNpcItemDataMap = {}
    for _, data in pairs(Table_ExpRaidshop) do
      local npcId = type(data.Npcid) ~= "table" and data.Npcid or data.Npcid[1]
      if not self.shopNpcItemDataMap[npcId] then
        self.shopNpcItemDataMap[npcId] = {}
      end
      table.insert(self.shopNpcItemDataMap[npcId], ItemData.new(tostring(npcId), data.id))
    end
    for _, itemDataTable in pairs(self.shopNpcItemDataMap) do
      table.sort(itemDataTable, function(l, r)
        return l.staticData.id < r.staticData.id
      end)
    end
  end
end
function ExpRaidProxy:InitItemPriceMap()
  if not self.itemPriceMap then
    self.itemPriceMap = {}
    for _, data in pairs(Table_ExpRaidshop) do
      self.itemPriceMap[data.id] = data.Price
    end
  end
end
local MakeSortedArrayFromDataTable = function(dataTable, sortBy)
  local array = {}
  for _, data in pairs(dataTable) do
    table.insert(array, data)
  end
  table.sort(array, function(l, r)
    return l[sortBy] < r[sortBy]
  end)
  return array
end
local MakeSortedArrayFromExpRaidTable = function(sortBy)
  return MakeSortedArrayFromDataTable(Table_ExpRaid, sortBy)
end
function ExpRaidProxy:GetExpRaidDataArray()
  if not self.raidDataArray then
    self.raidDataArray = MakeSortedArrayFromExpRaidTable("id")
  end
  return self.raidDataArray
end
function ExpRaidProxy:GetRaidIdWithSuitableLevel(roleLevel)
  if not self.levelSortedRaidDataArray then
    self.levelSortedRaidDataArray = MakeSortedArrayFromExpRaidTable("Level")
  end
  for i = #self.levelSortedRaidDataArray, 1, -1 do
    local raidData = self.levelSortedRaidDataArray[i]
    if roleLevel >= raidData.Level then
      return raidData.id
    end
  end
  return 0
end
function ExpRaidProxy:GetExpRaidTimesLeft()
  local clearCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_EXP_RAID) or 0
  return GameConfig.TeamExpRaid.day_count - clearCount
end
function ExpRaidProxy:GetExpRaidScore()
  return MyselfProxy.Instance:GetExpRaidScore()
end
function ExpRaidProxy:GetExpRaidScoreInRaid()
  return MyselfProxy.Instance:GetExpRaidScoreInRaid()
end
function ExpRaidProxy:GetAllExpRaidScore()
  return self:GetExpRaidScore() + self:GetExpRaidScoreInRaid()
end
function ExpRaidProxy:GetShopNpc()
  return self.shopNpc
end
function ExpRaidProxy:GetShopItemDataOfCurrentNpc()
  return self:GetShopItemDataOfNpc(self.shopNpc.data.staticData.id)
end
function ExpRaidProxy:GetShopItemDataOfNpc(npcId)
  return self.shopNpcItemDataMap[npcId]
end
function ExpRaidProxy:GetPriceOfItem(itemId)
  return self.itemPriceMap[itemId]
end
function ExpRaidProxy:GetRemainingCountOfShopItem(itemId)
  return 1
end
function ExpRaidProxy:CallBuyItem(itemId, count)
  ServiceFuBenCmdProxy.Instance:CallBuyExpRaidItemFubenCmd(itemId, count)
end
function ExpRaidProxy:CallBeginRaid()
  ServiceFuBenCmdProxy.Instance:CallBeginFireFubenCmd()
end
function ExpRaidProxy:RecvExpRaidResult(data)
  if not data then
    LogUtility.Warning("RecvExpRaidResult with data == nil")
    return
  end
  LogUtility.InfoFormat("Recv ExpRaidResult baseExp:{0}, jobExp:{1}, closeTime:{2}", data.baseexp, data.jobexp, data.closetime)
  LogUtility.InfoFormat("NowTime:{0}", math.floor(ServerTime.CurServerTime() / 1000))
  if not data.baseexp or not data.jobexp or not data.closetime then
    LogUtility.Warning("RecvExpRaidResult with the wrong data")
    return
  end
  self:CopyExpRaidResultData(data)
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "BattleResultView",
    callback = function()
      self:sendNotification(UIEvent.JumpPanel, self.showResultNotifyBody)
    end
  })
end
function ExpRaidProxy:CopyExpRaidResultData(data)
  if not self.showResultNotifyBody then
    self.showResultNotifyBody = {}
    self.showResultNotifyBody.view = PanelConfig.ExpRaidResultView
    self.showResultNotifyBody.viewdata = {}
  end
  local viewdata = self.showResultNotifyBody.viewdata
  viewdata.baseexp = data.baseexp
  viewdata.jobexp = data.jobexp
  viewdata.closetime = data.closetime
  self.rewardDataArray = self.rewardDataArray or {}
  if next(self.rewardDataArray) then
    TableUtility.ArrayClear(self.rewardDataArray)
  end
  if data.items then
    for i = 1, #data.items do
      table.insert(self.rewardDataArray, DojoRewardData.new(data.items[i]))
    end
  end
  viewdata.items = self.rewardDataArray
end
