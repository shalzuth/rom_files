AdventureDataProxy = class("AdventureDataProxy", pm.Proxy)
AdventureDataProxy.Instance = nil
AdventureDataProxy.NAME = "AdventureDataProxy"
autoImport("AdventureBagData")
autoImport("AdventureCollectionGroupData")
autoImport("WholeQuestData")
autoImport("Table_ItemBeTransformedWay")
autoImport("Table_AdventureValue")
autoImport("Table_AdventureItem")
autoImport("Table_AdventureSkill")
autoImport("PersonalPictureManager")
autoImport("MySceneryPictureManager")
AdventureDataProxy.Instance = nil
AdventureDataProxy.InitBag = {
  SceneManual_pb.EMANUALTYPE_FASHION,
  SceneManual_pb.EMANUALTYPE_CARD,
  SceneManual_pb.EMANUALTYPE_EQUIP,
  SceneManual_pb.EMANUALTYPE_ITEM,
  SceneManual_pb.EMANUALTYPE_MOUNT,
  SceneManual_pb.EMANUALTYPE_MONSTER,
  SceneManual_pb.EMANUALTYPE_NPC,
  SceneManual_pb.EMANUALTYPE_MAP,
  SceneManual_pb.EMANUALTYPE_ACHIEVE,
  SceneManual_pb.EMANUALTYPE_SCENERY,
  SceneManual_pb.EMANUALTYPE_COLLECTION,
  SceneManual_pb.EMANUALTYPE_RESEARCH,
  SceneManual_pb.EMANUALTYPE_HAIRSTYLE,
  SceneManual_pb.EMANUALTYPE_PET,
  SceneManual_pb.EMANUALTYPE_MATE,
  SceneManual_pb.EMANUALTYPE_TOY
}
AdventureDataProxy.NoServerSyncType = {
  SceneManual_pb.EMANUALTYPE_EQUIP,
  SceneManual_pb.EMANUALTYPE_HAIRSTYLE,
  SceneManual_pb.EMANUALTYPE_ITEM
}
AdventureDataProxy.DeathDrop = {
  SceneManual_pb.EMANUALTYPE_CARD,
  SceneManual_pb.EMANUALTYPE_FASHION,
  SceneManual_pb.EMANUALTYPE_EQUIP,
  SceneManual_pb.EMANUALTYPE_ITEM,
  SceneManual_pb.EMANUALTYPE_MOUNT,
  SceneManual_pb.EMANUALTYPE_COLLECTION
}
AdventureDataProxy.FilterPropType = {
  "AttrChange",
  "AddBuff",
  "BattleAttr",
  "ChangeScale",
  "ForceAttr",
  "ImmuneStatus",
  "ResistStatus",
  "StatusChange",
  "HSPChange"
}
AdventureDataProxy.FilterSkillType = {
  "AffactSkill",
  "DeepHide",
  "AddSkillCD",
  "BuffSpeedUp",
  "DelSkillStatus",
  "GetSkill",
  "ReplaceSkill",
  "UseSkill"
}
AdventureDataProxy.MonthCardTabId = 1052
local tempArrayData = {}
function AdventureDataProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AdventureDataProxy.NAME
  if AdventureDataProxy.Instance == nil then
    AdventureDataProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:initTableItemTypeAdventure()
  self.bagMap = {}
  self.NpcCount = 0
  self.NpcCount = Table_AdventureValue.npc.count
  for k, v in pairs(AdventureDataProxy.InitBag) do
    local bagData = AdventureBagData.new(nil, v)
    self.bagMap[v] = bagData
  end
  self.finishGenThumbnail = true
  self.tobeGenList = {}
  self.collectionGroupDatas = {}
  self.tempScenerys = {}
  self.tempAlbumTime = 0
  self:initBagData()
  self.hasCountNpsDeathDrop = {}
  self.hasCountNps = {}
  self.hasCountMap = {}
  self.hasCountMenu = {}
  self.hasCountCollection = {}
  self.adventurePropClassify = {}
  self.fashionGroupData = {}
  self.propTypeDatas = {}
  self.zoneProcessDatas = {}
  self:initFashionGroupData()
end
local tempTable = {}
function AdventureDataProxy:initFashionGroupData()
  TableUtility.ArrayClear(self.fashionGroupData)
  for k, v in pairs(Table_Equip) do
    if v.GroupID and not v.GroupID ~= k then
      local tb = self.fashionGroupData[v.GroupID] or {}
      tb[#tb + 1] = v
      self.fashionGroupData[v.GroupID] = tb
    end
  end
  for k, v in pairs(self.fashionGroupData) do
    table.sort(v, function(l, r)
      return l.id < r.id
    end)
  end
end
function AdventureDataProxy:initBagData()
  for i = 1, #Table_AdventureItem do
    local id = Table_AdventureItem[i]
    tempTable.id = id
    tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
    for i = 1, #AdventureDataProxy.NoServerSyncType do
      local type = AdventureDataProxy.NoServerSyncType[i]
      local bagData = self.bagMap[type]
      local item = AdventureItemData.new(tempTable, type)
      local tab = bagData:getTabByItemAndType(item, type)
      if tab and tab.tab.id ~= AdventureDataProxy.MonthCardTabId then
        bagData:AddItem(item, type)
        break
      end
    end
  end
  local type = SceneManual_pb.EMANUALTYPE_MATE
  local bagData = self.bagMap[type]
  for k, v in pairs(Table_MercenaryCat) do
    if v.AdventureValue == -1 and v.MonsterID then
      tempTable.id = v.MonsterID
      tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
      local item = AdventureItemData.new(tempTable, type)
      item:setCatId(v.id)
      local tab = bagData:getTabByItemAndType(item, type)
      if tab then
        bagData:AddItem(item, type)
      end
    end
  end
  type = SceneManual_pb.EMANUALTYPE_COLLECTION
  bagData = self.bagMap[type]
  for k, v in pairs(Table_Collection) do
    local groupData = AdventureCollectionGroupData.new(k)
    self.collectionGroupDatas[#self.collectionGroupDatas + 1] = groupData
    for i = 1, #v.ItemId do
      local single = v.ItemId[i]
      local oldItem = bagData:GetItemByStaticID(single)
      if oldItem then
        oldItem:setCollectionGroupId(v.GroupID)
      else
        tempTable.id = single
        tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
        local item = AdventureItemData.new(tempTable, type)
        item:setCollectionGroupId(k)
        local tab = bagData:getTabByItemAndType(item, type)
        if tab then
          bagData:AddItem(item, type)
          groupData:addCollectionData(item)
        end
      end
    end
  end
  local tb = GameConfig.Pet.Adventure_Init_Shielded or {}
  local type = SceneManual_pb.EMANUALTYPE_PET
  bagData = self.bagMap[type]
  for k, v in pairs(Table_Pet) do
    if TableUtility.ArrayFindIndex(tb, v.id) == 0 then
      tempTable.id = v.id
      tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
      local item = AdventureItemData.new(tempTable, type)
      if item:IsValid() then
        local tab = bagData:getTabByItemAndType(item, type)
        if tab then
          bagData:AddItem(item, type)
        end
      end
    end
  end
end
function AdventureDataProxy:initTableItemTypeAdventure()
  self.categoryDatas = {}
  self.categoryDatas[SceneManual_pb.EMANUALTYPE_HOMEPAGE] = {
    staticData = Table_ItemTypeAdventureLog[SceneManual_pb.EMANUALTYPE_HOMEPAGE]
  }
  for k, v in pairs(Table_ItemTypeAdventureLog) do
    if v.type then
      if not self.categoryDatas[v.type] then
        local categorys = {
          staticData = Table_ItemTypeAdventureLog[v.type]
        }
      end
      local childs = categorys.childs or {}
      if not childs[k] then
        local child = {staticData = v}
      end
      local types = child.types or {}
      for k1, v1 in pairs(Table_ItemType) do
        if v1.AdventureLogGroup and v1.AdventureLogGroup == k then
          table.insert(types, v1.id)
        end
      end
      child.types = types
      childs[k] = child
      categorys.childs = childs
      self.categoryDatas[v.type] = categorys
    end
    if v.Classify then
      local classifyData = Table_ItemTypeAdventureLog[v.Classify]
      if classifyData then
        if not self.categoryDatas[classifyData.type] then
          local categorys = {
            staticData = Table_ItemTypeAdventureLog[classifyData.type]
          }
        end
        local childs = categorys.childs or {}
        if not childs[classifyData.id] then
          local child = {staticData = classifyData}
        end
        local classifys = child.classifys or {}
        table.insert(classifys, v)
        child.classifys = classifys
        childs[classifyData.id] = child
        categorys.childs = childs
        self.categoryDatas[classifyData.type] = categorys
      end
    end
  end
end
function AdventureDataProxy:GetCollectionGroup(groupId)
  for i = 1, #self.collectionGroupDatas do
    local single = self.collectionGroupDatas[i]
    if single.staticId == groupId then
      return single
    end
  end
end
function AdventureDataProxy:GetAllCollectionGroups()
  return self.collectionGroupDatas
end
function AdventureDataProxy:GetAllUnlockCollectionGroups()
  local list = {}
  for i = 1, #self.collectionGroupDatas do
    local single = self.collectionGroupDatas[i]
    if single:IsUnlock() then
      list[#list + 1] = single
    end
  end
  return list
end
function AdventureDataProxy:GetCollectionsByGroup(groupId)
  local groupData = self:GetCollectionGroup(groupId)
  if groupData then
    return groupData.collections
  end
end
function AdventureDataProxy:CheckItemIsCollection(itemdata)
  local bagData = self.bagMap[SceneManual_pb.EMANUALTYPE_COLLECTION]
  if bagData then
    local tab = bagData:getTabByItemAndType(itemdata, SceneManual_pb.EMANUALTYPE_COLLECTION)
    if tab ~= nil then
      return true
    end
  end
  return false
end
function AdventureDataProxy:NewMapAdd(mapId)
  if self.hasCountMap[mapId] then
    return
  end
  self.hasCountMap[mapId] = true
  local mapData = Table_Map[mapId]
  if mapData then
    self:NewCollectionAdd(mapId)
    local sceneName = mapData.NameEn
    local sceneInfo = autoImport("Scene_" .. sceneName)
    local scenePartInfo
    if sceneInfo and sceneInfo.PVE then
      scenePartInfo = sceneInfo.PVE
      if scenePartInfo and scenePartInfo.nps and #scenePartInfo.nps > 0 then
        local nps = scenePartInfo.nps
        for i = 1, #nps do
          local npcId = nps[i].ID
          self:NewMonsterAdd(npcId)
        end
      end
    end
    for k, v in pairs(Table_Boss) do
      for i = 1, #v.Map do
        local single = v.Map[i]
        if mapId == single then
          self:NewMonsterAdd(k)
        end
      end
    end
  end
end
function AdventureDataProxy:NewMonsterAdd(monsterId)
  if self.hasCountNps[monsterId] then
    return
  end
  self.hasCountNps[monsterId] = true
  local type, data
  if NpcMonsterUtility.IsMonsterByID(monsterId) then
    type = SceneManual_pb.EMANUALTYPE_MONSTER
    self:NewMonsterDeathDropAdd(monsterId)
    data = Table_Monster[monsterId]
  elseif NpcMonsterUtility.IsNpcByID(monsterId) then
    type = SceneManual_pb.EMANUALTYPE_NPC
    data = Table_Npc[monsterId]
  end
  if type and data and data.AdventureValue and data.AdventureValue ~= 0 then
    tempTable.id = monsterId
    tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
    local item = AdventureItemData.new(tempTable, type)
    local bagData = self.bagMap[type]
    local tab = bagData:getTabByItemAndType(item, type)
    local oldItem = bagData:GetItemByStaticID(monsterId)
    if tab and not oldItem then
      bagData:AddItem(item, type)
    end
  end
end
function AdventureDataProxy:NewMonsterDeathDropAdd(monsterId)
  if self.hasCountNpsDeathDrop[monsterId] then
    return
  end
  self.hasCountNpsDeathDrop[monsterId] = true
  local items = ItemUtil.GetDeath_Drops(monsterId)
  if items and #items > 0 then
    for i = 1, #items do
      local itemData = items[i].itemData
      if itemData.AdventureValue and itemData.AdventureValue ~= 0 then
        tempTable.id = itemData.id
        tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
        for i = 1, #AdventureDataProxy.DeathDrop do
          local type = AdventureDataProxy.DeathDrop[i]
          local item = AdventureItemData.new(tempTable, type)
          local bagData = self.bagMap[type]
          local tab = bagData:getTabByItemAndType(item, type)
          local oldItem = bagData:GetItemByStaticID(itemData.id)
          if tab and not oldItem then
            bagData:AddItem(item, type)
          end
        end
      end
      local productId = ItemUtil.GetComposeItemByBlueItem(itemData)
      local productItem = Table_Item[productId]
      if productItem and productItem.AdventureValue and productItem.AdventureValue ~= 0 then
        tempTable.id = productItem.id
        tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
        for i = 1, #AdventureDataProxy.DeathDrop do
          local type = AdventureDataProxy.DeathDrop[i]
          local item = AdventureItemData.new(tempTable, type)
          local bagData = self.bagMap[type]
          local tab = bagData:getTabByItemAndType(item, type)
          local oldItem = bagData:GetItemByStaticID(productItem.id)
          if tab and not oldItem then
            bagData:AddItem(item, type)
          end
        end
      end
    end
  end
end
function AdventureDataProxy:NewMenusAdd(menuIds)
  if menuIds and #menuIds > 0 then
    for i = 1, #menuIds do
      self:NewMenuAdd(menuIds[i])
    end
  end
end
function AdventureDataProxy:NewMenuAdd(menuId)
  if self.hasCountMenu[menuId] then
    return
  end
  self.hasCountMenu[menuId] = true
  local menuData = Table_Menu[menuId]
  if menuData then
    local eventType = menuData.event.type
    if eventType and eventType == "unlockmanual" then
      if menuData.event.param and menuData.event.param[1] == SceneManual_pb.EMANUALTYPE_MONSTER then
        for i = 2, #menuData.event.param do
          self:NewMonsterAdd(menuData.event.param[i])
        end
      elseif menuData.event.param and menuData.event.param[1] == SceneManual_pb.EMANUALTYPE_COLLECTION then
        for i = 2, #menuData.event.param do
          self:NewSingleCollectionAdd(menuData.event.param[i])
        end
      elseif menuData.event.param and menuData.event.param[1] == SceneManual_pb.EMANUALTYPE_MAP then
        for i = 2, #menuData.event.param do
          self:NewCollectionAdd(menuData.event.param[i])
        end
      end
    elseif eventType and eventType == "scenery" then
      for i = 1, #menuData.event.param do
        self:NewSceneryAdd(menuData.event.param[i])
      end
    end
  end
end
function AdventureDataProxy:NewSingleCollectionAdd(itemId)
  local itemData = Table_Item[itemId]
  if itemData and itemData.AdventureValue and itemData.AdventureValue ~= 0 then
    tempTable.id = itemId
    tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
    local type = SceneManual_pb.EMANUALTYPE_COLLECTION
    local item = AdventureItemData.new(tempTable, type)
    local bagData = self.bagMap[type]
    local tab = bagData:getTabByItemAndType(item, type)
    local oldItem = bagData:GetItemByStaticID(itemId)
    if tab and not oldItem then
      bagData:AddItem(item, type)
    end
  end
end
function AdventureDataProxy:NewCollectionAdd(collectionId)
  if self.hasCountCollection[collectionId] then
    return
  end
  self.hasCountCollection[collectionId] = true
  for i = 1, #self.collectionGroupDatas do
    local single = self.collectionGroupDatas[i]
    if single.staticData.mapID == collectionId then
      single:setUnlock(true)
    end
  end
end
function AdventureDataProxy:NewSceneryAdd(sceneryId)
  local sceneryData = Table_Viewspot[sceneryId]
  if sceneryData and sceneryData.AdventureValue and sceneryData.AdventureValue ~= 0 then
    tempTable.id = sceneryId
    tempTable.status = SceneManual_pb.EMANUALSTATUS_DISPLAY
    local type = SceneManual_pb.EMANUALTYPE_SCENERY
    local item = AdventureItemData.new(tempTable, type)
    local bagData = self.bagMap[type]
    local tab = bagData:getTabByItemAndType(item, type)
    local oldItem = bagData:GetItemByStaticID(sceneryId)
    if tab and not oldItem then
      bagData:AddItem(item, type)
    end
  end
end
function AdventureDataProxy:thumbCpCallback(data)
  self:thumbnailCompleteCallback(data.baID, data.bytes)
end
function AdventureDataProxy:thumbPgCallback(data)
  self:thumbnailProgressCallback(data.baID, data.progress)
end
function AdventureDataProxy:onRegister()
end
function AdventureDataProxy:getRidTipsByCategoryId(id)
  local redTipIds = {}
  local categorys = AdventureDataProxy.Instance:getTabsByCategory(id)
  if categorys and categorys.childs then
    for k, v in pairs(categorys.childs) do
      local redId = v.staticData.RidTip
      if redId and type(redId) == "number" then
        table.insert(redTipIds, redId)
      elseif redId and type(redId) == "table" then
        for i = 1, #redId do
          table.insert(redTipIds, redId[i])
        end
      end
    end
  end
  return redTipIds
end
function AdventureDataProxy:checkSceneryRedTips(bagType)
  for k1, v1 in pairs(self.categoryDatas) do
    local categorys = v1
    if k1 ~= SceneManual_pb.EMANUALTYPE_ACHIEVE and (bagType and bagType == k1 or bagType == nil) then
      local bgData = self.bagMap[k1]
      if categorys and categorys.childs and bgData then
        for k, v in pairs(categorys.childs) do
          local redId = v.staticData.RidTip
          if redId then
            local list = bgData:GetItems(k)
            local addRed = false
            for i = 1, #list do
              local single = list[i]
              local append = single:getCompleteNoRewardAppend()
              if #append > 0 or single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT and not single:getCollectionGroupId() then
                addRed = true
                break
              end
            end
            if type(redId) == "number" then
              if addRed then
                RedTipProxy.Instance:UpdateRedTip(redId)
              else
                RedTipProxy.Instance:RemoveWholeTip(redId)
              end
            elseif type(redId) == "table" then
              for i = 1, #redId do
                if addRed then
                  RedTipProxy.Instance:UpdateRedTip(redId[i])
                else
                  RedTipProxy.Instance:RemoveWholeTip(redId[i])
                end
              end
            end
          end
        end
      end
      if bagType == SceneManual_pb.EMANUALTYPE_COLLECTION and bgData then
        self:checkCollectionRedTips()
      end
    end
    if not bagType then
    end
  end
end
function AdventureDataProxy:checkCollectionRedTips()
  for i = 1, #self.collectionGroupDatas do
    local single = self.collectionGroupDatas[i]
    local hasRed = single:hasToBeUnlockItem()
    if not single:IsUnlock() and not single:isTotalUnComplete() then
      single:setUnlock(true)
    end
    if hasRed then
      RedTipProxy.Instance:UpdateRedTip(single.staticData.RedTip)
    else
      RedTipProxy.Instance:RemoveWholeTip(single.staticData.RedTip)
    end
  end
end
function AdventureDataProxy:checkFoodRedTips()
  local food_cook_info = FoodProxy.Instance.food_cook_info
  local notifySv = true
  for k, v in pairs(food_cook_info) do
    local AdventureValue = v.itemData.staticData and v.itemData.staticData.AdventureValue
    if v.status == SceneFood_pb.EFOODSTATUS_ADD and AdventureValue and AdventureValue ~= 0 then
      notifySv = false
      RedTipProxy.Instance:UpdateRedTip(38)
      break
    end
  end
  if notifySv then
    RedTipProxy.Instance:RemoveWholeTip(38)
  end
end
function AdventureDataProxy:getTabsByCategory(categoryId)
  return self.categoryDatas[categoryId]
end
function AdventureDataProxy:isCard(type)
  local categorys = self.categoryDatas[SceneManual_pb.EMANUALTYPE_CARD]
  if categorys and categorys.childs then
    for k, v in pairs(categorys.childs) do
      for i = 1, #v.types do
        local single = v.types[i]
        if type == single then
          return true
        end
      end
    end
  end
end
function AdventureDataProxy:hasUnlockCard(Quality, cardType)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_CARD]
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.staticData and single.staticData.Quality == Quality and single.status == SceneManual_pb.EMANUALSTATUS_DISPLAY and single.cardInfo.CardType == cardType then
        return true
      end
    end
  end
end
function AdventureDataProxy:onRemove()
end
function AdventureDataProxy:SetIsNewFlag(package, value)
  local bag = self.bagMap[package]
  local items = bag:GetItems()
  for i = 1, #items do
    items[i].isNew = value
  end
end
function AdventureDataProxy:setPointData(value)
  self.totalData = value
end
function AdventureDataProxy:getPointData()
  return self.totalData or 0
end
function AdventureDataProxy:setSkillPoint(value)
  self.skillPoint = value
end
function AdventureDataProxy:getSkillPoint(value)
  return self.skillPoint or 0
end
function AdventureDataProxy:setManualLevel(value)
  local cur = self:getManualLevel()
  self.manualLevel = value
  if value > cur then
    GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, self, SceneUserEvent.ManualLevelUp)
  end
end
function AdventureDataProxy:getManualLevel()
  return self.manualLevel or 1
end
function AdventureDataProxy:IsNpcUnlock(npcId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_NPC]
  if bgData then
    local npcData = bgData:GetItemByStaticID(npcId)
    if npcData then
      return npcData.status == SceneManual_pb.EMANUALSTATUS_UNLOCK
    end
  end
end
function AdventureDataProxy:IsSceneryUnlock(sceneryId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    local data = bgData:GetItemByStaticID(sceneryId)
    if data then
      return data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK
    end
  end
end
function AdventureDataProxy:IsFashionUnlock(itemId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_FASHION]
  if bgData then
    local data = bgData:GetItemByStaticID(itemId)
    if data then
      return data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK
    end
  end
end
function AdventureDataProxy:IsFashionStored(itemId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_FASHION]
  if bgData then
    local data = bgData:GetItemByStaticID(itemId)
    if data then
      return data.store
    end
  end
end
function AdventureDataProxy:IsCardUnlock(itemId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_CARD]
  if bgData then
    local data = bgData:GetItemByStaticID(itemId)
    if data then
      return data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK
    end
  end
end
function AdventureDataProxy:IsCardStored(itemId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_CARD]
  if bgData then
    local data = bgData:GetItemByStaticID(itemId)
    if data then
      return data.store
    end
  end
end
function AdventureDataProxy:GetSceneryData(sceneryId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    return bgData:GetItemByStaticID(sceneryId)
  end
end
function AdventureDataProxy:IsSceneryHasTakePic(sceneryId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    local data = bgData:GetItemByStaticID(sceneryId)
    if data then
      return data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
    end
  end
end
function AdventureDataProxy:IsSceneryDisplay(sceneryId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    local data = bgData:GetItemByStaticID(sceneryId)
    if data then
      return data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY
    end
  end
end
function AdventureDataProxy:IsSceneryUpload(sceneryId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    local data = bgData:GetItemByStaticID(sceneryId)
    if data then
      return data.attrUnlock
    end
  end
end
function AdventureDataProxy:IsCollectionGained(collectionId)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_COLLECTION]
  if bgData then
    local data = bgData:GetItemByStaticID(collectionId)
    if data then
      return data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
    end
  end
end
function AdventureDataProxy:getAllUploadedScenerys()
  local ret = {}
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.attrUnlock then
        table.insert(ret, single)
      end
    end
  end
  return ret
end
function AdventureDataProxy:getCanAndHasUnlockedScenerys()
  local ret = {}
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK or single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
        table.insert(ret, single)
      end
    end
  end
  return ret
end
function AdventureDataProxy:getUnlockNumByType(type)
  local ret = {}
  local bgData = self.bagMap[type] or self.bagMap[SceneManual_pb.EMANUALTYPE_FASHION]
  local num = 0
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK then
        num = num + 1
      end
    end
  end
  return tostring(num)
end
function AdventureDataProxy:getUnuploadScenerys()
  local ret = {}
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if not single.attrUnlock then
        table.insert(ret, single)
      end
    end
  end
  return ret
end
function AdventureDataProxy:getUnLockMonsterByType(type, status)
  local ret = {}
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_MONSTER]
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.staticData and type == NpcData.NpcDetailedType[single.staticData.Type] and status < single.status then
        table.insert(ret, single)
      end
    end
  end
  return #ret
end
function AdventureDataProxy:getNextAchievement()
  local manualLevel = self:getManualLevel()
  for i = 1, #Table_AdventureLevel do
    local single = Table_AdventureLevel[i]
    if manualLevel < single.id then
      return single
    end
  end
end
function AdventureDataProxy:getNumOfStoredHeaddress(Quality)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_FASHION]
  local num = 0
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.staticData and single.staticData.Quality == Quality and single.store then
        num = num + 1
      end
    end
  end
  return num
end
function AdventureDataProxy:getNumOfStoredCard(Quality)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_CARD]
  local num = 0
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.staticData and single.staticData.Quality == Quality and single.store then
        num = num + 1
      end
    end
  end
  return num
end
function AdventureDataProxy:GetCurAdventureAppellation()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    return achData.id
  end
end
function AdventureDataProxy:getCurAchievement()
  local manualLevel = self:getManualLevel()
  for i = 1, #Table_AdventureLevel do
    local single = Table_AdventureLevel[i]
    if single.id == manualLevel then
      return single
    end
  end
end
function AdventureDataProxy:getAdventureSkillByAppellation(appellation)
  local skills = Table_AdventureSkill[appellation]
  if not skills then
    return
  end
  return {
    unpack(skills)
  }
end
function AdventureDataProxy:getAppendRewardByTargetId(targetId, type)
  TableUtility.ArrayClear(tempArrayData)
  for k, v in pairs(Table_AdventureAppend) do
    if v.targetID == targetId and type == v.Content and v.Reward then
      table.insert(tempArrayData, v.Reward)
    end
  end
  return tempArrayData
end
function AdventureDataProxy:checkHasMonsterDropCard(id)
  if id then
    local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_CARD]
    if bgData then
      local list = bgData:GetItems()
      for i = 1, #list do
        local single = list[i]
        if single.staticId == id and single.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY then
          return true
        end
      end
    end
  end
  return false
end
function AdventureDataProxy:getItemsByCategoryAndClassify(classify, profession, id)
  if classify then
    TableUtility.ArrayClear(tempArrayData)
    local types = {}
    for i, v in pairs(Table_ItemTypeAdventureLog) do
      local idFit = true
      if id ~= nil then
        idFit = id == v.id
      end
      if v.Classify == classify and idFit then
        table.insert(types, v)
      end
    end
    table.sort(types, function(l, r)
      return l.Order < r.Order
    end)
    for i = 1, #types do
      local single = types[i]
      local bgData = self.bagMap[single.type]
      if bgData then
        local list = bgData:GetItems(single.id)
        for i = 1, #list do
          local single = list[i]
          if profession and single.equipInfo then
            local profess = MyselfProxy.Instance:GetMyProfession()
            if single.equipInfo:CanUseByProfess(profess) then
              tempArrayData[#tempArrayData + 1] = single
            end
          else
            tempArrayData[#tempArrayData + 1] = single
          end
        end
      end
    end
    return tempArrayData
  end
end
function AdventureDataProxy:getItemsByCategoryAndClassifyNew(classify, profession, id, jobId)
  if classify then
    TableUtility.ArrayClear(tempArrayData)
    local types = {}
    for i, v in pairs(Table_ItemTypeAdventureLog) do
      local idFit = true
      if id ~= nil then
        idFit = id == v.id
      end
      if v.Classify == classify and idFit then
        table.insert(types, v)
      end
    end
    table.sort(types, function(l, r)
      return l.Order < r.Order
    end)
    for i = 1, #types do
      local single = types[i]
      local bgData = self.bagMap[single.type]
      if bgData then
        local list = bgData:GetItems(single.id)
        for i = 1, #list do
          local single = list[i]
          if profession and single.equipInfo then
            local profess = jobId
            if single.equipInfo:CanUseByProfess(profess) then
              tempArrayData[#tempArrayData + 1] = single
            end
          else
            tempArrayData[#tempArrayData + 1] = single
          end
        end
      end
    end
    return tempArrayData
  end
end
function AdventureDataProxy:getLockNumInfoByClassify(classify)
  local total = 0
  local unlock = 0
  if classify then
    for i, v in pairs(Table_ItemTypeAdventureLog) do
      if v.Classify == classify then
        local bgData = self.bagMap[v.type]
        if bgData then
          local list = bgData:GetItems(v.id)
          for i = 1, #list do
            local single = list[i]
            if single.type == SceneManual_pb.EMANUALTYPE_EQUIP then
              if self:checkEquipIsUnlock(single.staticId) then
                unlock = unlock + 1
              end
            elseif single.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE or single.type == SceneManual_pb.EMANUALTYPE_ITEM then
              if self:checkShopItemIsUnlock(single.staticId) then
                unlock = unlock + 1
              end
            elseif single.type == SceneManual_pb.EMANUALTYPE_MATE and self:checkMercenaryCatIsUnlock(single:getCatId()) then
              unlock = unlock + 1
            end
            total = total + 1
          end
        end
      end
    end
  end
  return unlock, total
end
function AdventureDataProxy:getMenuLockInfo()
  local total = 0
  local unlock = 0
  for i, v in pairs(Table_GameFunction) do
    local menuId = v.MenuID
    if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
      unlock = unlock + 1
    end
    total = total + 1
  end
  return unlock, total
end
function AdventureDataProxy:checkMercenaryCatIsUnlock(id)
  local data = Table_MercenaryCat[id]
  if data and data.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID) then
    return false
  end
  return true
end
function AdventureDataProxy:checkPetIsInManual(id)
  local type = SceneManual_pb.EMANUALTYPE_PET
  local bagData = self.bagMap[type]
  if not bagData then
    return
  end
  local itemData = bagData:GetItemByStaticID(id)
  if itemData then
    return true
  else
    return false
  end
end
function AdventureDataProxy:checkEquipIsUnlock(id)
  for k, v in pairs(Table_Compose) do
    if v.Product and v.Product.id == id and not FunctionUnLockFunc.Me():CheckCanOpen(v.MenuID) then
      return false
    end
  end
  return true
end
function AdventureDataProxy:checkShopItemIsUnlock(id)
  local staticData = Table_MenuUnclock[id]
  if staticData then
    local MenuID = staticData.MenuID
    if not FunctionUnLockFunc.Me():CheckCanOpen(MenuID) then
      return false
    end
  end
  return true
end
function AdventureDataProxy:GetMenuDesById(id)
  local staticData = Table_MenuUnclock[id]
  if staticData then
    local MenuDes = staticData.MenuDes
    return MenuDes
  end
  return nil
end
function NeedReverse(i)
  if i == 1 or i == 2 or i == 3 or i == 4 or i == 5 or i == 7 or i == 8 or i == 9 then
    return true
  end
  return false
end
function LinkWord(i)
  if i == 5 then
    return "\227\129\168"
  else
    return " "
  end
end
function AdventureDataProxy.getUnlockCondition(data, notItem)
  local str = ""
  if data.staticData and data.staticData.Condition then
    local condition = data.staticData.Condition
    local will_reverse = false
    if notItem then
      local pre = ""
      if data.staticData.Type ~= "MVP" and data.staticData.Type ~= "MINI" and data.type == SceneManual_pb.EMANUALTYPE_MONSTER then
        pre = ZhString.MonsterScoreTip_Condition
      end
      str = GameConfig.AdventureUnlockCodition[condition] or ""
      if NeedReverse(condition) then
        str = data:GetName() .. LinkWord(condition) .. str
        return str
      end
      str = pre .. str .. data:GetName()
    else
      local linkword = ""
      for i = 1, #GameConfig.AdventureUnlockCodition do
        if BitUtil.band(condition, i - 1) ~= 0 then
          if str == "" then
            str = GameConfig.AdventureUnlockCodition[i]
            if NeedReverse(i) then
              will_reverse = true
              linkword = LinkWord(i)
            end
          else
            str = str .. ZhString.Common_Comma .. GameConfig.AdventureUnlockCodition[i]
          end
        end
      end
      if will_reverse then
        str = data:GetName() .. linkword .. str
        return str
      end
      str = str .. data:GetName()
    end
    return str
  else
    str = "please check Excel!!!"
  end
  return str
end
function AdventureDataProxy:getUnlockRewardStr(staticData, splitStr)
  local advReward = staticData.AdventureReward
  splitStr = splitStr or "\n"
  if type(advReward) == "table" and type(advReward.buffid) == "table" then
    local str = ""
    for i = 1, #advReward.buffid do
      local value = advReward.buffid[i]
      local bufferData = Table_Buffer[value]
      if bufferData and bufferData.Dsc ~= "" then
        if str ~= "" then
          str = str .. splitStr
        end
        str = str .. (bufferData.Dsc or "")
      end
    end
    return str
  end
end
function AdventureDataProxy:QueryUnresolvedPhotoManualCmd(data)
  local photos = data.photos
  self.tempAlbumTime = data.time
  self.tempScenerys = {}
  if photos and #photos > 0 then
    for i = 1, #photos do
      local single = photos[i]
      local playerData = {}
      local scenerys
      playerData.name = single.name
      playerData.roleId = single.charid
      for j = 1, #single.photos do
        local singleData = single.photos[j]
        local tempData = {}
        tempData.staticId = singleData.id
        tempData.roleId = single.charid
        tempData.time = singleData.time
        scenerys = scenerys or {}
        scenerys[#scenerys + 1] = tempData
        MySceneryPictureManager.Instance():log("QueryUnresolvedPhotoManualCmd:", tostring(singleData.id), tostring(singleData.time), single.name, single.charid)
      end
      if scenerys then
        playerData.scenerys = scenerys
        self.tempScenerys[#self.tempScenerys + 1] = playerData
      end
    end
  end
end
function AdventureDataProxy:UpdateResolvedPhotoManualCmd(data)
  local roleId = data.charid
  local sceneryId = data.sceneryid
  if self.tempScenerys then
    for i = 1, #self.tempScenerys do
      local single = self.tempScenerys[i]
      if single.roleId == roleId and single.scenerys and #single.scenerys > 0 then
        for j = 1, #single.scenerys do
          local singleScenery = single.scenerys[j]
          if singleScenery.staticId == sceneryId then
            table.remove(single.scenerys, j)
            break
          end
        end
        if #single.scenerys == 0 then
          table.remove(self.tempScenerys, i)
          break
        end
      end
    end
  end
end
function AdventureDataProxy:GetAllTempScenerys()
  return self.tempScenerys
end
function AdventureDataProxy:HasTempSceneryExsit()
  return #self.tempScenerys > 0
end
function AdventureDataProxy:getIntoPackageRewardStr(staticData, splitStr)
  local advReward = staticData.StorageReward
  splitStr = splitStr or "\n"
  if type(advReward) == "table" and type(advReward.buffid) == "table" then
    local str = ""
    for i = 1, #advReward.buffid do
      local value = advReward.buffid[i]
      local bufferData = Table_Buffer[value]
      if bufferData and bufferData.Dsc ~= "" then
        if str ~= "" then
          str = str .. splitStr
        end
        str = str .. (bufferData.Dsc or "")
      end
    end
    return str
  end
end
function AdventureDataProxy:getNextAppellationProp()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  local str = ""
  if achData then
    local staticData = Table_Appellation[achData.staticData.PostID]
    if staticData then
      str = string.format(ZhString.AdventureHomePage_TitleDes, staticData.Name)
      for k, v in pairs(staticData.BaseProp) do
        local prop = Game.Config_PropName[k]
        if prop and v > 0 then
          str = str .. "\n" .. prop.RuneName .. "+" .. v
        end
      end
      str = str .. "[-][/c]"
    end
  end
  return str
end
function AdventureDataProxy:getNextAdventureLevelProp(curLv)
  curLv = curLv or self:getManualLevel()
  local str = ""
  local nextLv = curLv + 1
  local staticData = Table_AdventureLevel[nextLv]
  if staticData then
    if staticData.AdventureAttr and next(staticData.AdventureAttr) then
      local i = 0
      for k, v in pairs(staticData.AdventureAttr) do
        local prop = Game.Config_PropName[k]
        if prop and v > 0 then
          if i == 0 then
            str = prop.RuneName .. "+" .. v
          else
            str = str .. "\n" .. prop.RuneName .. "+" .. v
          end
        end
        i = i + 1
      end
    end
    if staticData.SkillPoint and 0 < staticData.SkillPoint then
      str = str .. string.format(ZhString.AdventureHomePage_manualPoint, staticData.SkillPoint)
    end
  end
  return str
end
function AdventureDataProxy:GetAppellationProp()
  TableUtility.ArrayClear(tempArrayData)
  local id = self:GetCurAdventureAppellation()
  local tempPropMap = {}
  if id then
    local count = id - 1000
    for i = 1, count do
      local num = i + 1000
      local staticData = Table_Appellation[num]
      if staticData and next(staticData.BaseProp) then
        for k, v in pairs(staticData.BaseProp) do
          local prop = Game.Config_PropName[k]
          if prop then
            local data = tempPropMap[k]
            if data then
              data.value = data.value + v
            else
              data = {}
              data.value = v
              data.prop = prop
              tempArrayData[#tempArrayData + 1] = data
            end
            tempPropMap[k] = data
          end
        end
      end
    end
  end
  return tempArrayData
end
function AdventureDataProxy:GetPropsByBufferId(buff, tempArrayData, tempMap)
  if buff and next(buff) then
    for j = 1, #buff do
      local bufferData = Table_Buffer[buff[j]]
      if bufferData and bufferData.BuffEffect.type == "AttrChange" and bufferData.Condition == _EmptyTable then
        for k, v in pairs(bufferData.BuffEffect) do
          local prop = Game.Config_PropName[k]
          if prop then
            local data = tempMap[k]
            if data then
              data.value = data.value + v
            else
              data = {}
              data.value = v
              data.prop = prop
              tempArrayData[#tempArrayData + 1] = data
            end
            tempMap[k] = data
          end
        end
      end
    end
  end
end
function AdventureDataProxy:GetPropsByItemData(type, props, tempMap)
  local bgData = self.bagMap[type]
  if bgData then
    local list = bgData:GetItems()
    for i = 1, #list do
      local single = list[i]
      if single.staticData and next(single.staticData.AdventureReward) and single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK then
        local buff = single.staticData.AdventureReward.buffid
        self:GetPropsByBufferId(buff, props, tempMap)
      end
      if single.staticData and next(single.staticData.StorageReward) and single.store then
        local buff = single.staticData.StorageReward.buffid
        self:GetPropsByBufferId(buff, props, tempMap)
      end
    end
  end
end
function AdventureDataProxy:GetPropsByPetData(props, tempMap)
  local bgData = self.bagMap[SceneManual_pb.EMANUALTYPE_PET]
  if not bgData then
    return
  end
  local list = bgData:GetItems()
  for i = 1, #list do
    local single = list[i]
    local petData = single.staticData
    if petData and next(petData.AdventureReward) and single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK then
      local buff = petData.AdventureReward.buffid
      self:GetPropsByBufferId(buff, props, tempMap)
    end
  end
end
function AdventureDataProxy:GetPropsByCollectGroupData(tempArrayData, tempMap)
  for i = 1, #self.collectionGroupDatas do
    local single = self.collectionGroupDatas[i]
    if single:isTotalComplete() and single.staticData.RewardProperty then
      for k, v in pairs(single.staticData.RewardProperty) do
        local prop = Game.Config_PropName[k]
        if prop then
          local data = tempMap[k]
          if data then
            data.value = data.value + v
          else
            data = {}
            data.value = v
            data.prop = prop
            tempArrayData[#tempArrayData + 1] = data
          end
          tempMap[k] = data
        end
      end
    end
  end
end
function AdventureDataProxy:GetPropsByTitleData(tempArrayData, tempMap)
  local props = TitleProxy.Instance:GetAllTitleProp()
  for k, v in pairs(props) do
    local prop = Game.Config_PropName[k]
    if prop then
      local data = tempMap[k]
      if data then
        data.value = data.value + v
      else
        data = {}
        data.value = v
        data.prop = prop
        tempArrayData[#tempArrayData + 1] = data
      end
      tempMap[k] = data
    end
  end
end
function AdventureDataProxy:GetPropsByAppellationData(tempArrayData, tempMap)
  local id = self:GetCurAdventureAppellation()
  if id then
    local count = id - 1000
    for i = 1, count do
      local num = i + 1000
      local staticData = Table_Appellation[num]
      if staticData and next(staticData.BaseProp) then
        for k, v in pairs(staticData.BaseProp) do
          local prop = Game.Config_PropName[k]
          if prop then
            local data = tempMap[k]
            if data then
              data.value = data.value + v
            else
              data = {}
              data.value = v
              data.prop = prop
              tempArrayData[#tempArrayData + 1] = data
            end
            tempMap[k] = data
          end
        end
      end
    end
  end
end
function AdventureDataProxy:GetPropsByBufferData(tempArrayData, tempMap)
end
function AdventureDataProxy:GetPropsByFoodData(tempArrayData, tempMap)
  local food_cook_info = FoodProxy.Instance.food_cook_info
  for k, cookInfo in pairs(food_cook_info) do
    if cookInfo.itemData and cookInfo.itemData.staticData and cookInfo.itemData.staticData.AdventureValue and cookInfo.itemData.staticData.AdventureValue ~= 0 then
      local foodInfo = Table_Food[cookInfo.itemid]
      if cookInfo and cookInfo.level == 10 and next(foodInfo.CookLvAttr) then
        for k, v in pairs(foodInfo.CookLvAttr) do
          local prop = Game.Config_PropName[k]
          if prop then
            local data = tempMap[k]
            if data then
              data.value = data.value + v
            else
              data = {}
              data.value = v
              data.prop = prop
              tempArrayData[#tempArrayData + 1] = data
            end
            tempMap[k] = data
          end
        end
      end
      local tasteInfo = FoodProxy.Instance:Get_FoodEatExpInfo(cookInfo.itemid)
      if tasteInfo and tasteInfo.level == 10 and next(foodInfo.TasteLvAttr) then
        for k, v in pairs(foodInfo.TasteLvAttr) do
          local prop = Game.Config_PropName[k]
          if prop then
            local data = tempMap[k]
            if data then
              data.value = data.value + v
            else
              data = {}
              data.value = v
              data.prop = prop
              tempArrayData[#tempArrayData + 1] = data
            end
            tempMap[k] = data
          end
        end
      end
    end
  end
end
function AdventureDataProxy:GetAllAdventureProp()
  TableUtility.ArrayClear(tempArrayData)
  local tempPropMap = {}
  self:GetPropsByItemData(SceneManual_pb.EMANUALTYPE_CARD, tempArrayData, tempPropMap)
  self:GetPropsByItemData(SceneManual_pb.EMANUALTYPE_FASHION, tempArrayData, tempPropMap)
  self:GetPropsByItemData(SceneManual_pb.EMANUALTYPE_COLLECTION, tempArrayData, tempPropMap)
  self:GetPropsByPetData(tempArrayData, tempPropMap)
  self:GetPropsByFoodData(tempArrayData, tempPropMap)
  self:GetPropsByTitleData(tempArrayData, tempPropMap)
  self:GetPropsByCollectGroupData(tempArrayData, tempPropMap)
  return tempArrayData
end
function AdventureDataProxy:CheckFashionCanMake(staticId)
  local cid = Table_ItemBeTransformedWay[staticId] and Table_ItemBeTransformedWay[staticId].composeWay or 0
  local composeData = Table_Compose[cid]
  if not composeData then
    return false
  end
  local costItem = composeData.BeCostItem
  local tbItem = Table_Item
  local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.adventureProduce)
  for i = 1, #costItem do
    local single = costItem[i]
    local itemData = tbItem[single.id]
    if itemData and itemData.Type ~= 50 then
      local itemDatas = BagProxy.Instance:GetMaterialItems_ByItemId(single.id, bagtype)
      local exsitNum = 0
      if itemDatas and #itemDatas > 0 then
        for j = 1, #itemDatas do
          local single = itemDatas[j]
          exsitNum = exsitNum + single.num
        end
      end
      local need = single.num or 0
      if exsitNum < need then
        return false
      end
    end
  end
  return true
end
function AdventureDataProxy:GetAllFixProp()
  TableUtility.ArrayClear(tempArrayData)
  local tempPropMap = {}
  self:GetPropsByFoodData(tempArrayData, tempPropMap)
  self:GetPropsByCollectGroupData(tempArrayData, tempPropMap)
  self:GetPropsByTitleData(tempArrayData, tempPropMap)
  self:GetPropsByAppellationData(tempArrayData, tempPropMap)
  self:GetPropsByBufferData(tempArrayData, tempPropMap)
  local props = RolePropsContainer.CreateAsTable()
  if props then
    for _, o in pairs(props.configs) do
      props:SetValueById(o.id, 0)
    end
  end
  local datas = {}
  for k, v in pairs(Game.Config_PropName) do
    local prop = props[k]
    local value = 0
    local buffValue = MyselfProxy.Instance.buffersProps:GetValueByName(k)
    local otherValue = 0
    if tempPropMap[k] and 0 < tempPropMap[k].value then
      otherValue = tempPropMap[k].value
    end
    value = otherValue + buffValue
    if value ~= 0 then
      local data = {}
      if prop.propVO.isPercent then
        value = value * 1000
      end
      prop:SetValue(value)
      data.prop = prop
      data.type = BaseAttributeView.cellType.fixed
      table.insert(datas, data)
    end
  end
  return datas
end
function AdventureDataProxy:checkFashionCanStore(itemData)
  local card = itemData.type == SceneManual_pb.EMANUALTYPE_CARD
  local toy = itemData.type == SceneManual_pb.EMANUALTYPE_TOY
  if card or toy then
    return BagProxy.Instance:GetItemByStaticID(itemData.staticId)
  end
  local tempArrayData = self:GetFashionEquipByStatic(itemData)
  if tempArrayData and #tempArrayData > 0 then
    return true
  end
end
function AdventureDataProxy:insertPropData(datas, roleDatas)
  for i = 1, #roleDatas do
    local single = roleDatas[i]
    datas[#datas + 1] = single
  end
end
function AdventureDataProxy:getSinglePropDatas(propData, keys)
  local datas = {}
  if not keys or #keys == 0 then
    if propData.subTable and next(propData.subTable) then
      for k, v in pairs(propData.subTable) do
        for k1, v1 in pairs(v) do
          if v1.roleDatas then
            self:insertPropData(datas, v1.roleDatas)
          end
        end
      end
    end
  else
    for i = 1, #keys do
      local single = keys[i]
      if single.roleDatas then
        self:insertPropData(datas, single.roleDatas)
      end
    end
  end
  return datas
end
function AdventureDataProxy:getCollectionItemsByFilterData(items, propData, keys)
  if propData.propId == 7 then
    TableUtility.ArrayClear(items)
    return items
  end
  local retDatas = {}
  local otherDatas = {}
  local datas = self:getSinglePropDatas(propData, keys)
  for i = 1, #items do
    local single = items[i]
    local find = false
    if single.staticData.RewardProperty then
      for j = 1, #datas do
        local singleProp = datas[j]
        if single.staticData.RewardProperty[singleProp.VarName] then
          retDatas[#retDatas + 1] = single
          find = true
          break
        end
      end
    end
    if not find then
      otherDatas[#otherDatas + 1] = single
    end
  end
  if propData.propId == 8 then
    return otherDatas
  else
    return retDatas
  end
end
function AdventureDataProxy:CheckBufferisSkillType(buffType)
  for k, v in pairs(AdventureDataProxy.FilterSkillType) do
    if buffType == v then
      return true
    end
  end
end
function AdventureDataProxy:CheckBufferisPropType(buffType)
  for k, v in pairs(AdventureDataProxy.FilterPropType) do
    if buffType == v then
      return true
    end
  end
end
function AdventureDataProxy:CheckBufferisOtherRequire(buff)
  for k, v in pairs(GameConfig.AdventurePropClassify) do
    local datas = self:getKeywords(k, v)
    if k ~= 8 then
      datas = self:getSinglePropDatas(datas)
      resutl = self:CheckBufferisRequire(buff, datas, k)
      if resutl then
        return true
      end
    end
  end
end
function AdventureDataProxy:CheckBufferisRequire(buff, datas, propid)
  if not buff or not next(buff) or not datas then
    return
  end
  for i = 1, #buff do
    local bufferData = Table_Buffer[buff[i]]
    if bufferData then
      if propid == 7 and self:CheckBufferisSkillType(bufferData.BuffEffect.type) then
        return true
      elseif self:CheckBufferisPropType(bufferData.BuffEffect.type) then
        if bufferData.BuffEffect.type == "AddBuff" then
          return self:CheckBufferisRequire(bufferData.BuffEffect.id, datas, propid)
        elseif bufferData.BuffEffect.type == "ImmuneStatus" or bufferData.BuffEffect.type == "ResistStatus" then
          local st = bufferData.BuffEffect.status[1]
          local propKey = GameConfig.Status2RoleData and GameConfig.Status2RoleData[st]
          prop = Game.Config_PropName[propKey]
          if prop then
            for j = 1, #datas do
              local singleProp = datas[j]
              if prop.id == singleProp.id then
                return true
              end
            end
          end
        end
        for k, v in pairs(bufferData.BuffEffect) do
          local prop = Game.Config_PropName[k]
          if prop then
            for j = 1, #datas do
              local singleProp = datas[j]
              if prop.id == singleProp.id then
                return true
              end
            end
          end
        end
      end
    end
  end
end
function AdventureDataProxy:getNorItemsByFilterData(items, propData, keys)
  local retDatas = {}
  local datas = self:getSinglePropDatas(propData, keys)
  local buffers = {}
  for i = 1, #items do
    local single = items[i]
    local beIn = false
    TableUtility.ArrayClear(buffers)
    if single.staticData and next(single.staticData.AdventureReward) then
      local buff = single.staticData.AdventureReward.buffid
      beIn = self:CheckBufferisRequire(buff, datas, propData.propId)
      buffers[#buffers + 1] = buff
    end
    if not beIn and single.staticData and next(single.staticData.StorageReward) then
      local buff = single.staticData.StorageReward.buffid
      beIn = self:CheckBufferisRequire(buff, datas, propData.propId)
      buffers[#buffers + 1] = buff
    end
    if not beIn and single.cardInfo then
      local buff = single.cardInfo.BuffEffect.buff
      beIn = self:CheckBufferisRequire(buff, datas, propData.propId)
      buffers[#buffers + 1] = buff
    end
    if not beIn and single.equipInfo and single.equipInfo.equipData then
      local buff = single.equipInfo.equipData.UniqueEffect.buff
      beIn = self:CheckBufferisRequire(buff, datas, propData.propId)
      buffers[#buffers + 1] = buff
      if propData.propId == GameConfig.AdventurePropMyProfessionIndex then
        local profess = MyselfProxy.Instance:GetMyProfession()
        beIn = single.equipInfo:CanUseByProfess(profess)
      end
    end
    if beIn then
      retDatas[#retDatas + 1] = single
    end
    if not beIn and propData.propId == 8 then
      local find = false
      for j = 1, #buffers do
        local single = buffers[j]
        find = self:CheckBufferisOtherRequire(single)
        if not find then
        end
      end
      if not find then
        retDatas[#retDatas + 1] = single
      end
    end
  end
  return retDatas
end
function AdventureDataProxy:getItemsByFilterData(type, items, propData, keys)
  if not propData or #items == 0 then
    return items
  end
  if type == SceneManual_pb.EMANUALTYPE_COLLECTION then
    items = self:getCollectionItemsByFilterData(items, propData, keys)
  else
    items = self:getNorItemsByFilterData(items, propData, keys)
  end
  return items
end
function AdventureDataProxy:getRoleDatas(filter, tag, id)
  local roleDatas = {}
  for k, v in pairs(Table_RoleData) do
    local ret = v[tag] and v[tag] & 2 ^ (id - 1) > 0
    if next(filter) then
      for k1, v1 in pairs(filter) do
        for i = 1, #v1 do
          local ret2 = v[k1] and 0 < v[k1] & 2 ^ (v1[i].id - 1)
          if ret and ret2 then
            roleDatas[#roleDatas + 1] = v
          end
        end
      end
    elseif ret then
      roleDatas[#roleDatas + 1] = v
    end
  end
  return roleDatas
end
function AdventureDataProxy:getKeywords(propId, data)
  local tRet = self.propTypeDatas[propId]
  if tRet then
    return tRet
  end
  local defaultGroup = data.defaultGroup
  local group = data.group
  local filterTable = {}
  for k, v in pairs(defaultGroup) do
    local fdata = filterTable[k] or {}
    local ptdata = GameConfig.PropTag[k]
    if ptdata then
      for k1, v1 in pairs(ptdata) do
        if v & 2 ^ (k1 - 1) > 0 then
          fdata[#fdata + 1] = {
            id = k1,
            name = v1,
            tag = k
          }
        end
      end
    end
    filterTable[k] = fdata
  end
  local subTable = {}
  for k, v in pairs(group) do
    local fdata = subTable[k] or {}
    local ptdata = GameConfig.PropTag[k]
    if ptdata then
      for k1, v1 in pairs(ptdata) do
        if v & 2 ^ (k1 - 1) > 0 then
          local roleDatas = self:getRoleDatas(filterTable, k, k1)
          fdata[#fdata + 1] = {
            id = k1,
            name = v1,
            tag = k,
            roleDatas = roleDatas
          }
        end
      end
    end
    subTable[k] = fdata
  end
  tRet = {
    subTable = subTable,
    filterTable = filterTable,
    propId = propId
  }
  self.propTypeDatas[propId] = tRet
  return tRet
end
function AdventureDataProxy:GetFashionEquipByStatic(itemData)
  local equipInfo = itemData.equipInfo
  if equipInfo and equipInfo.equipData then
    local GroupID = equipInfo.equipData.GroupID
    TableUtility.ArrayClear(tempArrayData)
    if GroupID then
      local equipDatas = self.fashionGroupData[GroupID]
      if equipDatas then
        for i = 1, #equipDatas do
          local single = equipDatas[i]
          local data = BagProxy.Instance:GetItemByStaticIDWithoutCard(single.id)
          if data then
            tempArrayData[#tempArrayData + 1] = data
          end
        end
      end
    else
      tempArrayData[#tempArrayData + 1] = BagProxy.Instance:GetItemByStaticIDWithoutCard(itemData.staticId)
    end
    return tempArrayData
  end
end
function AdventureDataProxy:GetFashionEquipByStaticNormal(itemData)
  local equipInfo = itemData.equipInfo
  if equipInfo and equipInfo.equipData then
    local GroupID = equipInfo.equipData.GroupID
    TableUtility.ArrayClear(tempArrayData)
    if GroupID then
      local equipDatas = self.fashionGroupData[GroupID]
      if equipDatas then
        for i = 1, #equipDatas do
          local single = equipDatas[i]
          local data = BagProxy.Instance:GetItemByStaticID(single.id)
          if data then
            tempArrayData[#tempArrayData + 1] = data
          end
        end
      end
    else
      tempArrayData[#tempArrayData + 1] = BagProxy.Instance:GetItemByStaticID(itemData.staticId)
    end
    return tempArrayData
  end
end
function AdventureDataProxy:FilterEquipByProp()
end
function AdventureDataProxy:RecvNpcZoneDataManualCmd(data)
  if data.bupdate == false then
    TableUtility.TableClear(self.zoneProcessDatas)
  end
  local serverDatas = data.datas
  local sData, cData
  for i = 1, #serverDatas do
    sData = serverDatas[i]
    cData = self.zoneProcessDatas[sData.id] or {}
    cData.id = sData.id
    cData.visitNum = sData.visit_num
    cData.killNum = sData.kill_num
    cData.photoNum = sData.photo_num
    cData.npcRewardGot = sData.npc_reward
    cData.goodRewardGot = sData.good_reward
    cData.perfectRewardGot = sData.perfect_reward
    self.zoneProcessDatas[sData.id] = cData
  end
end
function AdventureDataProxy:GetZoneProcessData(zoneID)
  return self.zoneProcessDatas[zoneID]
end
function AdventureDataProxy:Test()
  local list = {}
  for i = 1, 3 do
    local data = {}
    data.name = "xx\239\188\154" .. i
    data.charid = i * 10000 + i * 10
    local scenerys = {}
    for j = 1, 10 do
      local tempData = {}
      tempData.id = j
      tempData.time = 10000
      scenerys[#scenerys + 1] = tempData
    end
    data.photos = scenerys
    list[#list + 1] = data
  end
  local data = {}
  data.photos = list
  self:QueryUnresolvedPhotoManualCmd(data)
end
