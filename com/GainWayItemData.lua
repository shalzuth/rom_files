GainWayItemData = class("GainWayItemData")
autoImport("GainWayItemCellData")
GainWayItemData.TypeOrder = {
  [1] = 3,
  [2] = 4,
  [3] = 2,
  [4] = 5,
  [5] = 1
}
GainWayItemData.MonsterOrigin_ID = 1
GainWayItemData.GuildBossOrigin_ID = 1101
GainWayItemData.FoodOrigin_ID = 1120
function GainWayItemData:ctor(itemOriginData, staticID)
  self.itemOriginData = itemOriginData
  self.staticID = staticID
  self.datas = {}
  self:ParseEquipComposeGainWay()
  self:ParseNormalGainWay()
  self:ParseMonsterGainWay()
  self:ParseGuildBossGainWay()
  self:ParseFoodGainWay()
  self:LastSort()
end
local _Table_EquipCompose, _BagProxy
function GainWayItemData:ParseEquipComposeGainWay()
  if _Table_EquipCompose == nil then
    _Table_EquipCompose = Table_EquipCompose
  end
  if _Table_EquipCompose[self.staticID] ~= nil then
    local srcId = _Table_EquipCompose[self.staticID].Material[1].id
    local cellData = GainWayItemCellData.new(self.staticID)
    cellData:ParseItemGainWay(srcId, 2)
    table.insert(self.datas, cellData)
  end
  if _BagProxy == nil then
    _BagProxy = BagProxy.Instance
  end
  local srdIDs, srcType = BagProxy.GetSurceEquipIds(self.staticID)
  if srdIDs and #srdIDs > 0 and srcType & 1 > 0 then
    local cellData = GainWayItemCellData.new(self.staticID)
    cellData:ParseItemGainWay(srdIDs[1], 3)
    table.insert(self.datas, cellData)
  end
end
function GainWayItemData:ParseNormalGainWay()
  local normalOrigins = self.itemOriginData[1]
  if normalOrigins then
    for i = 1, #normalOrigins do
      local addWayID = normalOrigins[i]
      if addWayID and addWayID ~= GainWayItemData.MonsterOrigin_ID and addWayID ~= GainWayItemData.GuildBossOrigin_ID and addWayID ~= GainWayItemData.FoodOrigin_ID then
        local cellData = GainWayItemCellData.new(self.staticID)
        local parseSuc = cellData:ParseSingleNormalGainWay(addWayID)
        if parseSuc and cellData.isOpen then
          if cellData:IsTradeOrigin() then
            if ItemData.CheckItemCanTrade(self.staticID) then
              table.insert(self.datas, cellData)
            end
          else
            table.insert(self.datas, cellData)
          end
        end
      end
    end
  end
end
function GainWayItemData:ParseMonsterGainWay()
  local monsterOrigins = self.itemOriginData[2]
  if monsterOrigins then
    do
      local monsterCellDatas, bossCellDatas = {}, {}
      local filterMap = {}
      for i = 1, #monsterOrigins do
        local mOriData = monsterOrigins[i]
        if mOriData then
          local cellData = GainWayItemCellData.new(self.staticID)
          local parseSuc = cellData:ParseSingleMonsterGainWay(mOriData)
          if parseSuc and not filterMap[cellData.monsterID] then
            filterMap[cellData.monsterID] = 1
            if cellData.monsterType == "Monster" then
              table.insert(monsterCellDatas, cellData)
            elseif cellData.monsterType == "MINI" or cellData.monsterType == "MVP" then
              table.insert(bossCellDatas, cellData)
            end
          end
        end
      end
      local limitlv = MyselfProxy.Instance:RoleLevel() + 5
      local sortRules = function(a, b)
        local aDeltalv = limitlv - a.level
        local bDeltalv = limitlv - b.level
        local aUnderlv = aDeltalv >= 0
        local bUnderLv = bDeltalv >= 0
        if aUnderlv ~= bUnderLv then
          return aUnderlv
        elseif not aUnderlv and aDeltalv ~= bDeltalv then
          return aDeltalv > bDeltalv
        end
        return a.dropProbability > b.dropProbability
      end
      if #monsterCellDatas > 0 then
        if #monsterCellDatas > 1 then
          table.sort(monsterCellDatas, sortRules)
        end
        for i = 1, 2 do
          local mdata = monsterCellDatas[i]
          if mdata then
            table.insert(self.datas, mdata)
          end
        end
        self.firstMonsterCellData = monsterCellDatas[1]
      elseif #bossCellDatas > 0 then
        if #bossCellDatas > 1 then
          table.sort(bossCellDatas, sortRules)
        end
        table.insert(self.datas, bossCellDatas[1])
        self.firstMonsterCellData = bossCellDatas[1]
      end
    end
  else
  end
end
function GainWayItemData:ParseGuildBossGainWay()
  local guildBossOrigins = self.itemOriginData[3]
  if guildBossOrigins then
    for i = 1, #guildBossOrigins do
      local origin = guildBossOrigins[i]
      local cellData = GainWayItemCellData.new(self.addWayID)
      cellData:ParseGuildBossGainWay(origin)
      table.insert(self.datas, cellData)
    end
  end
end
function GainWayItemData:ParseFoodGainWay()
  local foodOrigins = self.itemOriginData[4]
  if foodOrigins then
    for i = 1, #foodOrigins do
      local origin = foodOrigins[i]
      local cellData = GainWayItemCellData.new(self.staticID)
      cellData:ParseFoodGainWay(origin)
      table.insert(self.datas, cellData)
    end
  end
end
function GainWayItemData:LastSort()
  local itemData = Table_Item[self.staticID]
  local orderTable = Table_ItemType[itemData.Type]
  orderTable = orderTable and orderTable.Order1
  local selfOrderType = self.staticID
  local typeOrder = GainWayItemData.TypeOrder
  table.sort(self.datas, function(a, b)
    if a.isOpen ~= b.isOpen then
      return a.isOpen == true
    end
    if a.addWayType and b.addWayType and a.addWayType ~= b.addWayType then
      local aI = typeOrder[a.addWayType] or 10000
      local bI = typeOrder[b.addWayType] or 10000
      return aI < bI
    end
    if orderTable and a.addWayID and b.addWayID and a.addWayID ~= b.addWayID then
      local aIndex = TableUtil.FindKeyByValue(orderTable, a.addWayID) or 10000
      local bIndex = TableUtil.FindKeyByValue(orderTable, b.addWayID) or 10000
      return aIndex < bIndex
    end
    return false
  end)
end
function GainWayItemData:GetFirstMonsterOrigin()
  return self.firstMonsterCellData
end
