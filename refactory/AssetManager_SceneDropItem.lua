AssetManager_SceneDropItem = class("AssetManager_SceneDropItem")
local GetFromSceneDropPool = GOLuaPoolManager.GetFromSceneDropPool
local AddToSceneDropPool = GOLuaPoolManager.AddToSceneDropPool
local IsNull = Slua.IsNull
function AssetManager_SceneDropItem:ctor(assetManager)
  self.goLuaPoolManager = Game.GOLuaPoolManager
  self.assetManager = assetManager
end
function AssetManager_SceneDropItem:GetGoLuaPoolManager()
  if self.goLuaPoolManager == nil then
    self.goLuaPoolManager = Game.GOLuaPoolManager
  end
  return self.goLuaPoolManager
end
function AssetManager_SceneDropItem:CreateSceneDrop(key, parent)
  local sceneDrop = GetFromSceneDropPool(self:GetGoLuaPoolManager(), key, parent)
  if sceneDrop == nil then
    local asset = self.assetManager:Load(ResourcePathHelper.Item(key))
    if asset ~= nil then
      sceneDrop = GameObject.Instantiate(asset)
    end
  end
  return sceneDrop
end
function AssetManager_SceneDropItem:DestroySceneDrop(key, gameobject)
  if nil == gameobject or IsNull(gameobject) then
    return
  end
  if AddToSceneDropPool(self:GetGoLuaPoolManager(), key, gameobject) then
    return
  end
  LuaGameObject.DestroyObject(gameobject)
end
