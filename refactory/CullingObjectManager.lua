CullingObjectManager = class("CullingObjectManager")
local CullingType = {
  CullingObject = Game.GameObjectType.CullingObject,
  ExitPoint = 100,
  Trap = 101,
  Creature = 200
}
local UpdateInterval = 0.1
local FindCreature = SceneCreatureProxy.FindCreature
local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9
local CreatureGUIDMap = {}
function CullingObjectManager:ctor()
end
function CullingObjectManager:DistanceToLevel(distance)
  if nil == self.boundingDistances then
    self.boundingDistances = Game.Object_GameObjectMap.cullingGroupBoundingDistances
  end
  local maxLevel = #self.boundingDistances
  for i = 1, maxLevel do
    if distance < self.boundingDistances[i] then
      return i - 1
    end
  end
  return maxLevel
end
function CullingObjectManager:SetCamera(camera)
  Game.Object_GameObjectMap:SetCullingGroupCamera(camera)
end
function CullingObjectManager:ClearCamera(camera)
  Game.Object_GameObjectMap:ClearCullingGroupCamera(camera)
end
function CullingObjectManager:ReferenceToMyself(on)
  if not on or not Game.Myself.assetRole.completeTransform then
    local ref
  end
  Game.Object_GameObjectMap.cullingGroupReference = ref
end
function CullingObjectManager:Register_CullingObject(obj)
  local radius = tonumber(obj:GetProperty(0))
  self:_Register(CullingType.CullingObject, obj.ID, obj.transform, radius)
end
function CullingObjectManager:Unregister_CullingObject(obj)
  if not self.running then
    return
  end
  self:_Unregister(CullingType.CullingObject, obj.ID)
end
function CullingObjectManager:Clear_CullingObject()
  self:Clear(CullingType.CullingObject)
end
function CullingObjectManager:Register_ExitPoint(ep, effectHandler)
  self:_Register(CullingType.ExitPoint, ep.ID, effectHandler.transform, 1.5)
end
function CullingObjectManager:Unregister_ExitPoint(ep)
  if not self.running then
    return
  end
  self:_Unregister(CullingType.ExitPoint, ep.ID)
end
function CullingObjectManager:Clear_ExitPoint()
  self:_Clear(CullingType.ExitPoint)
end
function CullingObjectManager:Register_Trap(trap, effectHandler)
  self:_Register(CullingType.Trap, trap.cullingID, effectHandler.transform, 1.5)
end
function CullingObjectManager:Unregister_Trap(trap)
  if not self.running then
    return
  end
  self:_Unregister(CullingType.Trap, trap.cullingID)
end
function CullingObjectManager:Clear_Trap()
  self:_Clear(CullingType.Trap)
end
function CullingObjectManager:Register_Creature(creature)
  if CompatibilityMode_V9 then
    CreatureGUIDMap[creature.data.cullingID] = creature.data.id
  end
  self:_Register(CullingType.Creature, creature.data.cullingID, creature.assetRole.completeTransform, 1)
end
function CullingObjectManager:Unregister_Creature(creature)
  if CompatibilityMode_V9 then
    CreatureGUIDMap[creature.data.cullingID] = nil
  end
  if not self.running then
    return
  end
  self:_Unregister(CullingType.Creature, creature.data.cullingID)
end
function CullingObjectManager:Clear_Creature()
  self:_Clear(CullingType.Creature)
  if CompatibilityMode_V9 then
    TableUtility.TableClear(CreatureGUIDMap)
  end
end
function CullingObjectManager:SyncLocalPosition_Creature(creature, x, y, z)
  self:_SyncLocalPosition(CullingType.Creature, creature.data.cullingID, x, y, z)
end
function CullingObjectManager:SyncLocalEulerAngleY_Creature(creature, v)
  self:_SyncLocalEulerAngleY(CullingType.Creature, creature.data.cullingID, v)
end
function CullingObjectManager:SyncLocalScaleAll_Creature(creature, v)
  self:_SyncLocalScaleAll(CullingType.Creature, creature.data.cullingID, v)
end
function CullingObjectManager:ClearAll()
  Game.Object_GameObjectMap:ClearAll()
  if CompatibilityMode_V9 then
    TableUtility.TableClear(CreatureGUIDMap)
  end
end
function CullingObjectManager:_Register(type, key, transform, radius)
  Game.Object_GameObjectMap:Register_TransformForCulling(type, key, transform, radius)
end
function CullingObjectManager:_Unregister(type, key)
  Game.Object_GameObjectMap:Unregister(type, key)
end
function CullingObjectManager:_Clear(type)
  Game.Object_GameObjectMap:Clear(type)
end
function CullingObjectManager:_GetSyncInfo(type, key)
  local infoMap = self.syncInfos[type]
  if nil == infoMap then
    infoMap = ReusableTable.CreateTable()
    self.syncInfos[type] = infoMap
  end
  local info = infoMap[key]
  if nil == info then
    info = CullingObjectSyncInfo.new()
    info[key] = info
  end
  return info
end
function CullingObjectManager:_SyncLocalPosition(type, key, x, y, z)
  GameObjectMap.SetLocalPosition(type, key, x, y, z)
end
function CullingObjectManager:_SyncLocalEulerAngles(type, key, x, y, z)
  GameObjectMap.SetLocalEulerAngles(type, key, x, y, z)
end
function CullingObjectManager:_SyncLocalScale(type, key, x, y, z)
  GameObjectMap.SetLocalScale(type, key, x, y, z)
end
function CullingObjectManager:_SyncLocalEulerAngleY(type, key, v)
  GameObjectMap.SetLocalEulerAngleY(type, key, v)
end
function CullingObjectManager:_SyncLocalScaleAll(type, key, v)
  GameObjectMap.SetLocalScale(type, key, v, v, v)
end
function CullingObjectManager:_SyncPosition(type, key, x, y, z)
  GameObjectMap.SetPosition(type, key, x, y, z)
end
function CullingObjectManager:_SyncEulerAngles(type, key, x, y, z)
  GameObjectMap.SetEulerAngles(type, key, x, y, z)
end
function CullingObjectManager:Launch()
  if self.running then
    return
  end
  self.running = true
  self.nextUpdateTime = 0
end
function CullingObjectManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self:ClearAll()
end
local cullingStateChangedArray = {}
function CullingObjectManager:LateUpdate(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + UpdateInterval
  GameObjectMapHelper.GetChangedCullingStates(cullingStateChangedArray)
  local index = 1
  local objType = cullingStateChangedArray[index]
  while nil ~= objType do
    if CullingType.Creature == objType then
      local creatureGUID = cullingStateChangedArray[index + 1]
      if CompatibilityMode_V9 then
        creatureGUID = CreatureGUIDMap[creatureGUID]
      end
      local creature = FindCreature(creatureGUID)
      if nil ~= creature then
        creature:CullingStateChange(cullingStateChangedArray[index + 2], cullingStateChangedArray[index + 3])
      end
    elseif CullingType.ExitPoint == objType then
      Game.AreaTrigger_ExitPoint:CullingStateChange(cullingStateChangedArray[index + 1], cullingStateChangedArray[index + 2], cullingStateChangedArray[index + 3])
    elseif CullingType.Trap == objType then
      SceneTrapProxy.Instance:CullingStateChange(cullingStateChangedArray[index + 1], cullingStateChangedArray[index + 2], cullingStateChangedArray[index + 3])
    end
    index = index + 4
    objType = cullingStateChangedArray[index]
  end
  if index > 1 then
    TableUtility.ArrayClearWithCount(cullingStateChangedArray, index - 1)
  end
end
