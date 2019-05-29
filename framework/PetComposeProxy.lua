autoImport("PetComposeDendrogram")
PetComposeProxy = class("PetComposeProxy", pm.Proxy)
PetComposeProxy.Instance = nil
PetComposeProxy.NAME = "PetComposeProxy"
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
local mask_config = GameConfig.Pet.cancel_special_effects
local PET_SKIN_CFG = {
  [500010] = {700010, 700160},
  [500020] = {700020},
  [500030] = {700030},
  [500040] = {700040},
  [500050] = {700050}
}
function PetComposeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PetComposeProxy.NAME
  if PetComposeProxy.Instance == nil then
    PetComposeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.countPet = 1
  self:InitProxy()
end
function PetComposeProxy:InitProxy()
  self.petMap = {}
  self.unlockIgnorePosItems = {}
  self.unlockItems = {}
  self.petSkinCfg = GameConfig.PetAdvance and GameConfig.PetAdvance or PET_SKIN_CFG
  self:InitActivePetSkin()
end
local Equip_Pos = {
  8,
  9,
  10,
  11,
  12
}
function PetComposeProxy:InitActivePetSkin()
  self.staticActivePet = {}
  for k, v in pairs(Table_UseItem) do
    if v.UseEffect.type == "pet" and v.UseEffect.body then
      self.staticActivePet[v.UseEffect.body.id] = v.id
    end
  end
end
function PetComposeProxy:SetUnlockItems(specPetEquip)
  for i = 1, #specPetEquip do
    local bodyId = specPetEquip[i].bodyid
    local epos = specPetEquip[i].epos
    local itemId = specPetEquip[i].itemid
    if nil == self.unlockItems[bodyId] then
      self.unlockItems[bodyId] = {}
    end
    if 0 ~= epos then
      if nil == self.unlockItems[bodyId][epos] then
        self.unlockItems[bodyId][epos] = {}
      end
      table.insert(self.unlockItems[bodyId][epos], itemId)
    else
      for j = 1, #Equip_Pos do
        local pos = Equip_Pos[j]
        if nil == self.unlockItems[bodyId][pos] then
          self.unlockItems[bodyId][pos] = {}
        end
        table.insert(self.unlockItems[bodyId][pos], itemId)
      end
    end
  end
end
function PetComposeProxy:InitPetEquipList(serverData)
  for i = 1, #serverData.items do
    self.unlockIgnorePosItems[#self.unlockIgnorePosItems + 1] = serverData.items[i]
  end
  self:SetUnlockItems(serverData.bodyitems)
end
function PetComposeProxy:IsItemUnlock(bodyid, epos, itemid)
  if 0 ~= TableUtility.ArrayFindIndex(self.unlockIgnorePosItems, itemid) then
    return true
  end
  local unlockItems = self.unlockItems[bodyid] and self.unlockItems[bodyid] and self.unlockItems[bodyid][epos]
  if unlockItems then
    for i = 1, #unlockItems do
      if unlockItems[i] == itemid then
        return true
      end
    end
  end
  if AdventureDataProxy.Instance:IsFashionStored(itemid) then
    local forbidBit = Table_Equip[itemid] and Table_Equip[itemid].ForbidFuncBit
    if forbidBit then
      return 0 >= forbidBit & 8
    end
  end
  return false
end
function PetComposeProxy:ResetComposeGuilds()
  if nil == self.composeEggGuids then
    self.composeEggGuids = {}
  else
    TableUtility.TableClear(self.composeEggGuids)
  end
end
function PetComposeProxy:AddComposeGuid(index, guid)
  self.composeEggGuids[index] = guid
end
function PetComposeProxy:GetComposeGuid(index)
  if nil == self.composeEggGuids then
    return nil
  end
  return self.composeEggGuids[index]
end
function PetComposeProxy:GetGuids()
  return self.composeEggGuids
end
function PetComposeProxy:CanCompose()
  if nil == self.curPet then
    return false
  end
  local queryCfg = Table_PetCompose[self.curPet]
  for i = 1, 3 do
    local materialPet = queryCfg["MaterialPet" .. i]
    if materialPet and materialPet.id and nil == self.composeEggGuids[i] then
      return false
    end
  end
  return true
end
function PetComposeProxy:UpdatePetEquipList(serverData)
  for i = 1, #serverData.additems do
    self.unlockIgnorePosItems[#self.unlockIgnorePosItems + 1] = serverData.additems[i]
  end
  self:SetUnlockItems(serverData.addbodyitems)
end
local SortPetFunc = function(left, right)
  if left == nil or right == nil then
    return false
  end
end
function PetComposeProxy:GetPetData()
end
function PetComposeProxy:SetCurPet(id)
  self.curPet = id
end
function PetComposeProxy:GetCurPet()
  return self.curPet
end
function PetComposeProxy:GetDendrogramData(pet_id)
  local data = PetComposeDendrogram.new(pet_id)
  data = data:GetUIData()
  return data
end
local validDateArray = {}
function PetComposeProxy:InitStaticData()
  TableUtility.TableClear(self.petMap)
  for _, v in pairs(Table_Pet) do
    if AdventureDataProxy.Instance:checkPetIsInManual(v.id) then
      local staticdata = Table_Item[v.EggID]
      if staticdata then
        validDateArray[1] = staticdata.ValidDate
        validDateArray[2] = staticdata.TFValidDate
      end
      if ItemUtil.CheckDateValid(validDateArray) then
        if not self.petMap[v.Star] then
          self.petMap[v.Star] = {}
        end
        _ArrayPushBack(self.petMap[v.Star], v.id)
      end
    end
  end
end
function PetComposeProxy:GetPetsIDByStar()
  return self.petMap
end
local defaultLv = 1
function PetComposeProxy:GetPetAttr(classtype)
  return CommonFun.PetAttrShow(defaultLv, classtype)
end
function PetComposeProxy:GetAllPetsData()
end
