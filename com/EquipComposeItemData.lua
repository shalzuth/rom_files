autoImport("EquipComposeCellItemData")
EquipComposeItemData = class("EquipComposeItemData")
local PACKAGECHECK = GameConfig.PackageMaterialCheck.equipcompose
local _PushArray = TableUtility.ArrayPushBack
function EquipComposeItemData:ctor(cfg_data)
  self:SetData(cfg_data)
end
function EquipComposeItemData:SetData(cfg_data)
  if not Table_EquipCompose then
    redlog("\231\173\150\229\136\146\230\156\170\231\148\159\230\136\144Table_EquipCompose")
    return
  end
  self.composeID = cfg_data.id
  self.itemStaticData = Table_Item[cfg_data.id]
  if nil == self.itemStaticData then
    helplog("cfg_data.id: ", cfg_data.id)
  end
  self.staticData = cfg_data
  self.material = {}
  local _bagproxy = BagProxy.Instance
  for i = 1, #self.staticData.MaterialCost do
    local cellMatCost = self.staticData.MaterialCost[i]
    local data = ItemData.new("cost", cellMatCost.id)
    data:SetItemNum(cellMatCost.num)
    _PushArray(self.material, data)
  end
  self.cost = self.staticData.Cost
  self:ResetMatData()
  self.itemdata = ItemData.new("composeItem", self.composeID)
  self:ResetChooseMat()
end
function EquipComposeItemData:ResetMatData()
  self.MatArray = {}
  for i = 2, #self.staticData.Material do
    local matData = EquipComposeCellItemData.new("mat", self.staticData.Material[i].id)
    matData:SetEquipLv(self.staticData.Material[i].lv)
    self.MatArray[#self.MatArray + 1] = matData
  end
  self.mainMat = EquipComposeCellItemData.new("mainMat", self.staticData.Material[1].id)
  self.mainMat:SetEquipLv(self.staticData.Material[1].lv)
end
function EquipComposeItemData:GetMatLimitedLv(id)
  for i = 1, #self.MatArray do
    if self.MatArray[i].staticData.id == id then
      return self.MatArray[i].equipLvLimited
    end
  end
  if self.mainMat.staticData.id == id then
    return self.mainMat.equipLvLimited
  end
end
function EquipComposeItemData:SetTypeName(name)
  self.name = name
end
function EquipComposeItemData:GetItemType()
  return Table_Item[self.staticData.id].Type
end
function EquipComposeItemData:SetChooseMat(index, id)
  if not index or not self.chooseMat[index] then
    return
  end
  self.chooseMat[index] = id
  if self.MatArray[index] then
    local matData = EquipComposeCellItemData.new("mat", id)
    matData:SetEquipLv(self.MatArray[index].equipLvLimited)
    self.MatArray[index] = matData
  end
end
function EquipComposeItemData:GetChooseMat(index)
  if not index then
    return nil
  end
  return self.chooseMat[index]
end
function EquipComposeItemData:IsMatLimited()
  local mat, mainMat = self:GetChooseMatArray()
  if not mat or #mat <= 0 or not mainMat then
    return true
  end
  return false
end
function EquipComposeItemData:GetChooseMatArray()
  local chooseMatArray = {}
  for k, v in pairs(self.chooseMat) do
    if 0 == v then
      return nil
    else
      chooseMatArray[#chooseMatArray + 1] = v
    end
  end
  return chooseMatArray, self.chooseMat[self.staticData.Material[1].id]
end
function EquipComposeItemData:SetMainChooseMat(main_guid)
  if main_guid ~= self.chooseMainMat then
    self.chooseMainMat = main_guid
  end
end
function EquipComposeItemData:GetMainChooseMat()
  return self.chooseMainMat
end
function EquipComposeItemData:CanEquip()
  local canEquipArray = Table_Equip[self.staticData.id] and Table_Equip[self.staticData.id].CanEquip or {}
  return 0 ~= TableUtility.ArrayFindIndex(canEquipArray, Game.Myself.data.userdata:Get(UDEnum.PROFESSION))
end
function EquipComposeItemData:ResetChooseMat()
  self.chooseMainMat = nil
  self.chooseMat = {}
  for i = 1, #self.staticData.Material do
    self.chooseMat[self.staticData.Material[i].id] = 0
  end
  self:ResetMatData()
end
function EquipComposeItemData:IsCostLimited()
  return MyselfProxy.Instance:GetROB() < self.cost
end
