ItemUtil = {}
ItemUtil.staticRewardDropsItems = {}
function ItemUtil.GetRewardItemIdsByTeamId(teamId)
  return Game.Config_RewardTeam[teamId]
end
function ItemUtil.getAssetPartByItemData(itemId, parent)
  local partIndex = ItemUtil.getItemRolePartIndex(itemId)
  if partIndex then
    local model = Asset_RolePart.Create(partIndex, itemId)
    model:ResetParent(parent.transform)
    LogUtility.InfoFormat("getAssetPartByItemData parent.layer:{0}", LogUtility.ToString(parent.layer))
    model:SetLayer(parent.layer)
    return model
  end
end
function ItemUtil.CheckDateValidByItemId(id)
  local staticData = Table_Item[id]
  if staticData == nil then
    redlog("not find itemid", id)
    return
  end
  local array = {}
  array[1] = staticData.ValidDate
  array[2] = staticData.TFValidDate
  return ItemUtil.CheckDateValid(array)
end
function ItemUtil.CheckDateValidByAchievementId(id)
  local staticData = Table_Achievement[id]
  local array = {}
  if staticData then
    array[1] = staticData.ValidDate
    array[2] = staticData.TFValidDate
    return ItemUtil.CheckDateValid(array)
  end
end
function ItemUtil.GetValidDateByPetId(petid)
  local validDateArray = {}
  local itemid = Table_Pet[petid] and Table_Pet[petid].EggID
  if itemid then
    local staticdata = Table_Item[itemid]
    if staticdata then
      validDateArray[1] = staticdata.ValidDate
      validDateArray[2] = staticdata.TFValidDate
    end
  end
  return validDateArray
end
function ItemUtil.CheckDateValid(validArray)
  if not validArray or #validArray ~= 2 or not validArray[1] or not validArray[2] then
    return true
  end
  if StringUtil.IsEmpty(validArray[1]) and StringUtil.IsEmpty(validArray[2]) then
    return true
  end
  local validDate = validArray[1]
  if not StringUtil.IsEmpty(validDate) then
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, min, sec = validDate:match(p)
    local ddd = tonumber(os.date("%z", 0)) / 100
    local offset = (8 - ddd) * 3600
    local startDate = os.time({
      day = day,
      month = month,
      year = year,
      hour = hour,
      min = min,
      sec = sec
    })
    startDate = startDate - offset
    local curServerTime = ServerTime.CurServerTime()
    if curServerTime and startDate > curServerTime / 1000 then
      return false
    end
  end
  return true
end
function ItemUtil.getComposeMaterialsByComposeID(id)
  local compData = Table_Compose[id]
  local all, materials, failStay = {}, {}, {}
  if compData then
    if compData.BeCostItem then
      for i = 1, #compData.BeCostItem do
        local id = compData.BeCostItem[i].id
        local num = compData.BeCostItem[i].num
        local tempItem = ItemData.new("Compose", id)
        tempItem.num = num
        table.insert(all, tempItem)
      end
    end
    if compData.FailStayItem then
      local indexMap = {}
      for i = 1, #compData.FailStayItem do
        local index = compData.FailStayItem[i]
        if index then
          indexMap[index] = 1
        end
      end
      for i = 1, #all do
        if indexMap[i] then
          table.insert(failStay, all[i])
        else
          table.insert(materials, all[i])
        end
      end
    end
  end
  return all, materials, failStay
end
function ItemUtil.getItemModel(itemData, parent)
  local rid = ItemUtil.getResourceIdByItemData(itemData)
  local result
  if rid then
    if parent then
      result = GameObjPool.Instance:RGet(rid, "Pool_Item", parent)
    else
      result = GameObjPool.Instance:RGet(rid, "Pool_Item")
    end
  end
  return result
end
function ItemUtil.checkEquipIsWeapon(type)
  for i = 1, #Table_WeaponType do
    local single = Table_WeaponType[i]
    if single.NameEn == type then
      return true
    end
  end
end
function ItemUtil.checkIsFashion(itemId)
  local itemData = Table_Item[itemId]
  if itemData then
    for k, v in pairs(GameConfig.ItemFashion) do
      for i = 1, #v.types do
        local single = v.types[i]
        if single == itemData.Type then
          return true
        end
      end
    end
  end
end
function ItemUtil.getEquipPos(equipId)
  if Table_Item[equipId] then
    local type = Table_Item[equipId].Type
    for k, v in pairs(GameConfig.CardComposeType) do
      for kk, vv in pairs(v.types) do
        if vv == type then
          return k
        end
      end
    end
  end
end
function ItemUtil.getFashionDefaultEquipFunc(data)
  if data.bagtype == BagProxy.BagType.RoleFashionEquip then
    return FunctionItemFunc.Me():GetFunc("GetoutFashion")
  elseif data.bagtype == BagProxy.BagType.RoleEquip then
    return FunctionItemFunc.Me():GetFunc("Discharge")
  elseif data.bagtype == BagProxy.BagType.MainBag then
    return FunctionItemFunc.Me():GetFunc("Dress")
  end
end
function ItemUtil.getBufferDescById(bufferid)
  if Table_Buffer[bufferid] then
    local bufferStr = Table_Buffer[bufferid].Dsc
    if not bufferStr or bufferStr == "" then
      bufferStr = Table_Buffer[bufferid].BuffName .. ZhString.ItemUtil_NoBufferDes
    end
    return bufferStr
  else
    printRed("Can not find buffer" .. tostring(bufferid))
    return ""
  end
end
function ItemUtil.getBufferDescByIdNotConfigDes(bufferid)
  local result = ""
  local config = Table_Buffer[bufferid]
  if config and config.BuffEffect and config.BuffEffect.type == "AttrChange" then
    for key, value in pairs(config.BuffEffect) do
      local kprop = RolePropsContainer.config[key]
      if kprop and kprop.displayName and value > 0 then
        result = result .. kprop.displayName .. " [c][9fc33dff]+" .. value .. "[-][/c] "
      end
    end
  end
  return result
end
function ItemUtil.getFashionItemRoleBodyPart(itemid, isMale)
  local equipData = Table_Equip[itemid]
  if not equipData or not equipData.GroupID then
    return equipData
  end
  local GroupID = equipData.GroupID
  local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
  if not equipDatas or #equipDatas == 0 then
    return
  end
  for i = 1, #equipDatas do
    local single = equipDatas[i]
    if isMale and single.RealShowModel == 1 then
      return single
    elseif not isMale and single.RealShowModel == 2 then
      return single
    end
  end
  return equipDatas[1]
end
function ItemUtil.getItemRolePartIndex(itemid)
  if Table_Mount[itemid] then
    return Asset_Role.PartIndex.Mount
  elseif Table_Equip[itemid] then
    local typeId = Table_Equip[itemid].EquipType
    if typeId == 1 or typeId == 21 then
      return Asset_Role.PartIndex.RightWeapon
    elseif typeId == 8 then
      return Asset_Role.PartIndex.Head
    elseif typeId == 9 then
      return Asset_Role.PartIndex.Wing
    elseif typeId == 10 then
      return Asset_Role.PartIndex.Face
    elseif typeId == 11 then
      return Asset_Role.PartIndex.Tail
    elseif typeId == 13 then
      return Asset_Role.PartIndex.Mouth
    elseif Table_Equip[itemid].Body then
      return Asset_Role.PartIndex.Body
    else
      local mtype = Table_Equip[itemid].Type
      if mtype == "Head" then
        return Asset_Role.PartIndex.Head
      elseif mtype == "Wing" then
        return Asset_Role.PartIndex.Wing
      end
    end
  else
    local itemType = Table_Item[itemid].Type
    if itemType == 823 or itemType == 824 then
      return Asset_Role.PartIndex.Eye
    elseif itemType == 820 or itemType == 821 or itemType == 822 then
      return Asset_Role.PartIndex.Hair
    end
  end
  return 0
end
function ItemUtil.AddItemsTrace(datas)
  local traceDatas = {}
  for i = 1, #datas do
    local data = datas[i]
    local staticId = data.staticData.id
    local cell = QuestProxy:GetTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id)
    if not cell then
      local odata = GainWayTipProxy.Instance:GetItemOriginMonster(staticId)
      local itemName = odata.name
      local haveNum = BagProxy.Instance:GetAllItemNumByStaticID(staticId)
      local origin = odata.origins and odata.origins[1]
      if origin then
        local traceData = {
          type = QuestDataType.QuestDataType_ITEMTR,
          questDataStepType = QuestDataStepType.QuestDataStepType_MOVE,
          id = staticId,
          map = origin.mapID,
          pos = origin.pos,
          traceTitle = ZhString.MainViewSealInfo_TraceTitle,
          traceInfo = string.format(ZhString.ItemUtil_ItemTraceInfo, itemName, haveNum)
        }
        table.insert(traceDatas, traceData)
      else
        errorLog(string.format(ZhString.ItemUtil_NoMonsterDrop, staticId))
      end
    end
  end
  if #traceDatas > 0 then
    QuestProxy.Instance:AddTraceCells(traceDatas)
  end
end
function ItemUtil.CancelItemTrace(data)
  QuestProxy.Instance:RemoveTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id)
end
function ItemUtil.CheckItemIsSpecialInAdventureAppend(itemType)
  for i = 1, #GameConfig.AdventureAppendSpecialItemType do
    local single = GameConfig.AdventureAppendSpecialItemType[i]
    if single == itemType then
      return true
    end
  end
end
function ItemUtil.GetComposeItemByBlueItem(itemData)
  if itemData and 50 == itemData.Type then
    local compose = Table_Compose[itemData.id]
    if compose then
      return compose.Product.id
    end
  end
end
function ItemUtil.GetDeath_Dead_Reward(monsterId)
  local tempArray = {}
  local tempMap = {}
  for k, v in pairs(Table_Deadboss) do
    if v.MonsterID == monsterId then
      local Dead_Reward = v.Dead_Reward
      for i = 1, #Dead_Reward do
        local single = Dead_Reward[i]
        if not tempMap[single] then
          tempArray[#tempArray + 1] = single
          tempMap[single] = 1
        end
      end
    end
  end
  tempMap = nil
  return tempArray
end
function ItemUtil.GetDeath_Drops(monsterId)
  if ItemUtil.staticRewardDropsItems[monsterId] then
    return ItemUtil.staticRewardDropsItems[monsterId]
  end
  local tempArray = {}
  local staticData = Table_Monster[monsterId]
  if not staticData then
    return
  end
  local numLimit = false
  local Dead_Reward = staticData.Dead_Reward
  if not (#Dead_Reward > 0) or not Dead_Reward then
    Dead_Reward = nil
  end
  if not Dead_Reward then
    Dead_Reward = ItemUtil.GetDeath_Dead_Reward(monsterId)
    numLimit = true
  end
  if not Dead_Reward then
    return
  end
  for i = 1, #Dead_Reward do
    local rewardTeamID = Dead_Reward[i]
    local list = ItemUtil.GetRewardItemIdsByTeamId(rewardTeamID)
    if list then
      for j = 1, #list do
        local single = list[j]
        local hasAdd = false
        for j = 1, #tempArray do
          local tmp = tempArray[j]
          if tmp.itemData.id == single.id then
            if not numLimit then
              tmp.num = tmp.num + single.num
            end
            hasAdd = true
            break
          end
        end
        if not hasAdd then
          local data = {}
          data.itemData = Table_Item[single.id]
          if data.itemData then
            data.num = single.num
            table.insert(tempArray, data)
          end
        end
      end
    end
  end
  ItemUtil.staticRewardDropsItems[monsterId] = tempArray
  return ItemUtil.staticRewardDropsItems[monsterId]
end
function ItemUtil.GetEquipEnchantEffectSucRate(attriType)
end
local useCodeItemId
function ItemUtil.SetUseCodeCmd(data)
  useCodeItemId = data.id
end
function ItemUtil.HandleUseCodeCmd(data)
  if useCodeItemId and data.guid == useCodeItemId then
    useCodeItemId = nil
    local functionSdk = FunctionLogin.Me():getFunctionSdk()
    local url
    if functionSdk and functionSdk:getToken() then
      url = string.format(ZhString.KFCShareURL, Game.Myself.data.id, data.code, functionSdk:getToken())
    else
      url = ZhString.KFCShareURL_BeiFen
    end
    if ApplicationInfo.IsWindows() then
      Application.OpenURL(url)
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WebviewPanel,
        viewdata = {directurl = url}
      })
    end
  end
end
function ItemUtil.CheckIfNeedRequestUseCode(data)
  local type = data.staticData.Type
  if type and (type == 4000 or type == 4200 or type == 4201) then
    return true
  end
  return false
end
local CONFIGTIME_FORMAT = "%Y-%m-%d %H:%M:%S"
local getNowTimeString = function()
  return os.date(CONFIGTIME_FORMAT, ServerTime.CurServerTime() / 1000)
end
function ItemUtil.CheckCardCanComposeByTime(cardId)
  return ItemUtil.CheckCardCanGetByTime(cardId, "TFComposeDate", "ComposeDate")
end
function ItemUtil.CheckCardCanLotteryByTime(cardId)
  return ItemUtil.CheckCardCanGetByTime(cardId, "TFLotteryDate", "LotteryDate")
end
function ItemUtil.CheckCardCanGetByTime(cardId, tfkey, releaseKey)
  local sData = Table_Card[cardId]
  if sData == nil then
    return false
  end
  local timeKey
  if EnvChannel.IsTFBranch() then
    timeKey = tfkey
  elseif EnvChannel.IsReleaseBranch() then
    timeKey = releaseKey
  end
  if timeKey == nil then
    return true
  end
  local ct = sData[timeKey]
  if ct == nil or #ct == 0 then
    return true
  end
  local nowTimeStr = getNowTimeString()
  if #ct == 1 then
    return nowTimeStr > ct[1]
  elseif #ct == 2 then
    return nowTimeStr > ct[1] and nowTimeStr <= ct[2]
  end
  return false
end
function ItemUtil.CheckRecipeIsValidByTime(recipeId)
  return ItemUtil.CheckRecipeCanUseByTime(recipeId, "TFValidDate", "ValidDate", "Item")
end
function ItemUtil.CheckFoodCanMakeByTime(recipeId)
  return ItemUtil.CheckRecipeCanUseByTime(recipeId, "TFStartTime", "ReleaseStartTime", "Recipe")
end
function ItemUtil.CheckRecipeCanUseByTime(recipeId, tfKey, releaseKey, searchTableName)
  local recipeData = Table_Recipe[recipeId]
  if recipeData == nil then
    return false
  end
  local timeKey
  if EnvChannel.IsTFBranch() then
    timeKey = tfKey
  elseif EnvChannel.IsReleaseBranch() then
    timeKey = releaseKey
  end
  if timeKey == nil then
    return true
  end
  local searchTable = recipeData
  if searchTableName == "Item" then
    searchTable = Table_Item[recipeData.Product]
  end
  local validDate = searchTable[timeKey]
  if StringUtil.IsEmpty(validDate) then
    return true
  end
  return validDate < getNowTimeString()
end
