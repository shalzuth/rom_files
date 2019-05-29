FunctionChangeScene = class("FunctionChangeScene")
function FunctionChangeScene.Me()
  if nil == FunctionChangeScene.me then
    FunctionChangeScene.me = FunctionChangeScene.new()
  end
  return FunctionChangeScene.me
end
function FunctionChangeScene:ctor()
end
function FunctionChangeScene:Reset()
end
function FunctionChangeScene:TryPreLoadResources()
  Game.GOLuaPoolManager:ClearAllPools()
  FunctionPreload.Me():SceneNpcs(Game.Myself:GetPosition(), 33)
end
function FunctionChangeScene:TryLoadScene(data)
  self.sceneProxy = SceneProxy.Instance
  EventManager.Me():DispatchEvent(ServiceEvent.PlayerMapChange, data.mapID)
  local mapInfo = self:PrepareData(data)
  local sameScene = self.sceneProxy:IsCurrentScene(data)
  local currentSceneLoaded = self.sceneProxy.currentScene ~= nil and self.sceneProxy.currentScene.loaded or false
  if sameScene then
    if currentSceneLoaded then
      self:LoadSameLoadedScene(data)
    else
      local lastNeedLoad = SceneProxy.Instance:GetLastNeedLoad()
      if lastNeedLoad then
        SceneProxy.Instance:RemoveNeedLoad(2)
      end
      return
    end
  else
    self:WaitForLoad(data)
  end
  self:StartLoadScene()
end
function FunctionChangeScene:PrepareData(data)
  LogUtility.InfoFormat("\229\135\134\229\164\135\229\138\160\232\189\189map: {0} ,raidID: {1}", data.mapID, data.dmapID)
  local mapInfo = SceneProxy.Instance:GetMapInfo(data.mapID)
  if mapInfo == nil then
    error("\230\156\170\230\137\190\229\136\176\229\156\176\229\155\190id:" .. data.mapID .. "\231\154\132\228\191\161\230\129\175")
  end
  return mapInfo
end
function FunctionChangeScene:SetRaidID(raidID, playSceneAnim, mapInfo, isSameScene)
  FunctionDungen.Me():Shutdown()
  if raidID > 0 then
    FunctionDungen.Me():Launch(raidID)
  else
  end
end
function FunctionChangeScene:LoadSameLoadedScene(data)
  LogUtility.InfoFormat("\229\183\178\229\156\168\229\156\176\229\155\190{0}\228\184\173\239\188\140\232\175\183\230\177\130\233\135\141\230\150\176\229\138\160\232\189\189\239\188\136\229\143\170\233\135\141\232\174\190\228\189\141\231\189\174\239\188\140\229\146\140\233\135\141\230\150\176\230\183\187\229\138\160\229\175\185\232\177\161\239\188\137", data.mapID)
  self:ClearScene()
  local sceneInfo = SceneProxy.Instance.currentScene
  if sceneInfo then
    sceneInfo.mapNameZH = data.mapName
  end
  Game.MapManager:SetMapName(data)
  ServicePlayerProxy.Instance:CallChangeMap("", 0, 0, 0, data.mapID)
  MyselfProxy.Instance:ResetMyPos(data.pos.x, data.pos.y, data.pos.z)
  Game.AreaTrigger_ExitPoint:Shutdown()
  Game.AreaTrigger_ExitPoint:SetInvisibleEPs(data.invisiblexit)
  Game.AreaTrigger_ExitPoint:Launch()
  GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
  EventManager.Me():PassEvent(LoadSceneEvent.FinishLoadScene, sceneInfo)
  GameFacade.Instance:sendNotification(MiniMapEvent.ExitPointReInit)
end
function FunctionChangeScene:StartLoadScene()
  if SceneProxy.Instance:CanLoad() then
    self:CacheReceiveNet(true)
    FunctionBGMCmd.Me():Reset()
    self:ClearScene(true)
    SceneProxy.Instance:StartLoadFirst()
    EventManager.Me():PassEvent(LoadSceneEvent.BeginLoadScene)
    local data = SceneProxy.Instance.currentScene
    Game.MapManager:SetCurrentMap(data.serverData, true)
    local sameScene = self.sceneProxy:IsCurrentScene(data)
    local currentSceneLoaded = self.sceneProxy.currentScene ~= nil and self.sceneProxy.currentScene.loaded or false
    self:SetRaidID(data.dungeonMapId, data.preview, Table_Map[data.mapID], sameScene and currentSceneLoaded)
    return true
  end
  return false
end
function FunctionChangeScene:WaitForLoad(data)
  LogUtility.InfoFormat("\230\183\187\229\138\160\229\156\176\229\155\190\229\138\160\232\189\189:{0} {1}", data.mapID, data.mapName)
  FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene, false)
  FunctionMapEnd.Me():Reset()
  SceneProxy.Instance:AddLoadingScene(data)
  MyselfProxy.Instance:ResetMyBornPos(data.pos.x, data.pos.y, data.pos.z)
end
function FunctionChangeScene:LoadedScene(data)
  if data then
    LogUtility.InfoFormat("{0} {1} \229\156\186\230\153\175\229\138\160\232\189\189\229\174\140\230\175\149", data.mapID, data.mapName)
    self:TryPreLoadResources()
    local sceneQueue = SceneProxy.Instance:FinishLoadScene(data)
    self:EnterScene()
    if sceneQueue == nil or #sceneQueue == 0 then
      self:AllFinishLoad(data)
    else
      GameFacade.Instance:sendNotification(LoadingSceneView.ServerReceiveLoaded)
      self:StartLoadScene()
    end
  end
end
function FunctionChangeScene:EnterScene()
  SceneProxy.Instance:EnterScene()
  SceneProxy.Instance.sceneLoader:SetAllowSceneActivation()
end
function FunctionChangeScene:AllFinishLoad(sceneInfo)
  LogUtility.Info(string.format("send change map: %d", sceneInfo.mapID))
  LogUtility.Info(string.format("TotalFinishLoad raid: %s", tostring(sceneInfo.dmapID)))
  if nil ~= sceneInfo.dmapID and sceneInfo.dmapID > 0 then
    local rotationOffsetY = Table_MapRaid[sceneInfo.dmapID].CameraAdj
    LogUtility.Info(string.format("TotalFinishLoad rotationOffsetY: %s", tostring(rotationOffsetY)))
    if nil ~= rotationOffsetY and 0 ~= rotationOffsetY then
      local cameraController = CameraController.Instance
      if nil ~= cameraController then
        cameraController.cameraRotationEulerOffset = Vector3(0, rotationOffsetY, 0)
        cameraController:ApplyCurrentInfo()
      end
    end
  end
  FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene, true)
  ServicePlayerProxy.Instance:CallChangeMap("", 0, 0, 0, sceneInfo.mapID)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "MainView"})
  GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
  FunctionDungen.Me():HandleSceneLoaded()
  FunctionMapEnd.Me():TempSetDurationToTimeLine()
  FunctionActivity.Me():UpdateNowMapTraceInfo()
  self:CacheReceiveNet(false)
  EventManager.Me():PassEvent(LoadSceneEvent.FinishLoadScene, sceneInfo)
  AssetManager.Me():TryUnLoadAllUnused()
  Game.MapManager:Launch()
  MyLuaSrv.ClearLuaMapAsset()
  local go = GameObject.Find("static")
  if not Slua.IsNull(go) then
    local t1 = os.clock()
    StaticBatchingUtility.Combine(go)
    helplog("Static Batching Cost:", os.clock() - t1)
  else
    redlog("not find static")
  end
  if not self.setPreloaded then
    self.setPreloaded = true
    Game.AssetManager_Role:SetPreLoad(true)
  end
  Game.AssetManager_Role:StartDelayPreload()
  if not self.setRecordFrequency_UI then
    self.setRecordFrequency_UI = true
    FunctionPreload.Me():RecordFrequency_UI(true)
  end
end
function FunctionChangeScene:CacheReceiveNet(v)
  NetProtocol.CachingSomeReceives = v
  if not v then
    NetProtocol.CallCachedReceives()
  end
end
function FunctionChangeScene:GC()
  LuaGC.CallLuaGC()
  ResourceManager.Instance:GC()
  GameObjPool.Instance:ClearAll()
end
function FunctionChangeScene:ClearScene(loadOtherScene)
  if loadOtherScene then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles, {
      MyselfProxy.Instance.myself
    })
    FunctionCameraEffect.Me():Shutdown()
    FunctionCameraAdditiveEffect.Me():Shutdown()
    FunctionMapEnd.Me():BeginIgnoreAreaTrigger()
  end
  SceneObjectProxy.ClearAll()
  GvgProxy.Instance:ClearRuleGuildInfos()
end
