AssetManager_StageManager = class("AssetManager_StageManager", AssetManager_Role)
function AssetManager_StageManager:ctor(assetManager)
  AssetManager_StageManager.super.ctor(self, assetManager)
  local ResPathHelperFuncs = self.ResPathHelperFuncs
  for k, v in pairs(ResPathHelperFuncs) do
    if k ~= Asset_Role.PartIndex.Body then
      ResPathHelperFuncs[k] = ResourcePathHelper.StagePart
    end
  end
  self.Table_Equip = Table_StageParts
end
function AssetManager_StageManager:CreatePart(part, ID, callback, owner, custom)
  local tag = self:NewTag()
  self:_AddObserver_Part(part, ID, tag, callback, owner, custom)
  return tag
end
function AssetManager_StageManager:DestroyPart(part, ID, obj)
  if nil == obj or LuaGameObject.ObjectIsNull(obj.gameObject) then
    return
  end
  LuaGameObject.DestroyObject(obj.gameObject)
end
