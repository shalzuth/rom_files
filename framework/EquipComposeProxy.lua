autoImport("Table_EquipComposeProduct")
autoImport("EquipComposeItemData")
EquipComposeProxy = class("EquipComposeProxy", pm.Proxy)
EquipComposeProxy.Instance = nil
EquipComposeProxy.NAME = "EquipComposeProxy"
local _PushArray = TableUtility.ArrayPushBack
local COMPOSE_TYPE = GameConfig.EquipComposeType
function EquipComposeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipComposeProxy.NAME
  if EquipComposeProxy.Instance == nil then
    EquipComposeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function EquipComposeProxy:Init()
  self.composeData = {}
  self.classifiedMap = {}
  self:InitData()
end
function EquipComposeProxy:InitData()
  for k, v in pairs(Table_EquipCompose) do
    local itemData = EquipComposeItemData.new(v)
    _PushArray(self.composeData, itemData)
  end
  for k, v in pairs(COMPOSE_TYPE) do
    for i = 1, #self.composeData do
      if 0 ~= TableUtility.ArrayFindIndex(v.types, self.composeData[i]:GetItemType()) then
        if nil == self.classifiedMap[k] then
          self.classifiedMap[k] = {}
        end
        self.classifiedMap[k].name = v.name
        _PushArray(self.classifiedMap[k], self.composeData[i])
      end
    end
  end
  for k, v in pairs(self.classifiedMap) do
    table.sort(v, function(l, r)
      return l.composeID < r.composeID
    end)
  end
end
function EquipComposeProxy:GetTypeFilterData(index, professionCheck)
  local data = {}
  if 1 == index then
    for k, v in pairs(self.classifiedMap) do
      if k ~= 1 then
        if professionCheck then
          local result = {}
          for i = 1, #v do
            if v[i]:CanEquip() then
              result[#result + 1] = v[i]
            end
          end
          if #result > 0 then
            result.name = v.name
            _PushArray(data, result)
          end
        else
          _PushArray(data, v)
        end
      end
    end
    return data
  end
  if self.classifiedMap[index] then
    if professionCheck then
      local result = {}
      for i = 1, #self.classifiedMap[index] do
        if self.classifiedMap[index][i]:CanEquip() then
          result[#result + 1] = self.classifiedMap[index][i]
        end
      end
      if #result > 0 then
        result.name = self.classifiedMap[index].name
        _PushArray(data, result)
      end
    else
      _PushArray(data, self.classifiedMap[index])
    end
  end
  return data
end
function EquipComposeProxy:SetCurrentData(data)
  if self.curData ~= data then
    self.curData = data
    if self.curData then
      self.curData:ResetChooseMat()
    end
  end
end
function EquipComposeProxy:SetChooseMat(index, id)
  if not self.curData then
    return
  end
  self.curData:SetChooseMat(index, id)
end
function EquipComposeProxy:GetCurData()
  return self.curData
end
