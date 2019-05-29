GOManager_InteractNpc = class("GOManager_InteractNpc")
function GOManager_InteractNpc:ctor()
  self.objects = {}
end
function GOManager_InteractNpc:GetInteractObject(id)
  return self.objects[id]
end
function GOManager_InteractNpc:RegisterGameObject(obj)
  local objID = obj.ID
  self.objects[objID] = obj
  Game.InteractNpcManager:AddInteractObject(objID)
  return true
end
function GOManager_InteractNpc:UnregisterGameObject(obj)
  local objID = obj.ID
  local testObj = self.objects[objID]
  if testObj ~= nil and testObj == obj then
    self.objects[objID] = nil
    Game.InteractNpcManager:RemoveInteractObject(objID)
    return true
  end
  return false
end
