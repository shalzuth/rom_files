NStageNpc = reusableClass("NStageNpc", NNpc)
NStageNpc.PoolSize = 5
local PartIndex = Asset_Role.PartIndex
local _ReplacePart = function(iLeft, iRight, left, right)
  if nil ~= right[iRight] and 0 ~= right[iRight] then
    left[iLeft] = right[iRight]
  end
end
function NStageNpc:ctor(aiClass)
  self.assetManager = Game.AssetManager_StageManager
  NStageNpc.super.ctor(self)
end
function NStageNpc:GetCreatureType()
  return Creature_Type.Stage
end
function NStageNpc:DoDeconstruct(asArray)
  NStageNpc.super.DoDeconstruct(self, asArray)
end
local _GetUserDataTypeValue = function(edenum)
  return ProtoCommon_pb["EUSERDATATYPE_" .. edenum]
end
function NStageNpc:GetDressParts()
  if not self:IsDressEnable() then
    return NSceneNpcProxy.Instance:GetNpcEmptyParts(), true
  end
  local parts = self.data:GetDressParts()
  if not self.data.useServerDressData then
    local newParts = Asset_Role.CreatePartArray()
    for k, v in pairs(parts) do
      newParts[k] = v
    end
    parts = newParts
  end
  local replaceData = StageProxy.Instance:GetStageReplace()
  if nil ~= replaceData then
    _ReplacePart(PartIndex.Hair, _GetUserDataTypeValue(UDEnum.HAIR), parts, replaceData)
    _ReplacePart(PartIndex.LeftWeapon, _GetUserDataTypeValue(UDEnum.LEFTHAND), parts, replaceData)
    _ReplacePart(PartIndex.RightWeapon, _GetUserDataTypeValue(UDEnum.RIGHTHAND), parts, replaceData)
    _ReplacePart(PartIndex.Head, _GetUserDataTypeValue(UDEnum.HEAD), parts, replaceData)
    _ReplacePart(PartIndex.Wing, _GetUserDataTypeValue(UDEnum.BACK), parts, replaceData)
  end
  return parts, false
end
