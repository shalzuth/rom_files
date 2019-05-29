autoImport("LState")
GameAfterLoadSceneState = class("GameAfterLoadSceneState", LState)
function GameAfterLoadSceneState:Enter()
  if GameAfterLoadSceneState.super.Enter(self) then
    printOrange("GameAfterLoadSceneState Enter")
    local data = SceneProxy.Instance:GetFirstNeedLoad()
    if data then
      local sceneQueue = SceneProxy.Instance:FinishLoadScene(data)
      if sceneQueue == nil or #sceneQueue == 0 then
        self:TotalFinishLoad(data)
      else
        GameFacade.Instance:sendNotification(LoadingSceneView.ServerReceiveLoaded)
      end
    end
  end
end
function GameAfterLoadSceneState:Exit()
  printOrange("GameAfterLoadSceneState Exit")
  self:ReInit()
end
function GameAfterLoadSceneState:TotalFinishLoad(sceneInfo)
  printRed(string.format("send change map: %d", sceneInfo.mapID))
  if Scene.Instance then
    Scene.Instance.ID = sceneInfo.mapID
  end
  printRed(string.format("TotalFinishLoad raid: %s", tostring(sceneInfo.dmapID)))
  if nil ~= sceneInfo.dmapID and sceneInfo.dmapID > 0 then
    local rotationOffsetY = Table_MapRaid[sceneInfo.dmapID].CameraAdj
    printRed(string.format("TotalFinishLoad rotationOffsetY: %s", tostring(rotationOffsetY)))
    if nil ~= rotationOffsetY and 0 ~= rotationOffsetY then
      local cameraController = CameraController.Instance
      if nil ~= cameraController then
        cameraController.cameraRotationEulerOffset = Vector3(0, rotationOffsetY, 0)
        cameraController:ApplyCurrentInfo()
      end
    end
  end
  ServicePlayerProxy.Instance:CallChangeMap("", 0, 0, 0, sceneInfo.mapID)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "MainView"})
  GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
  FunctionDungen.Me():HandleSceneLoaded()
  FunctionMapEnd.Me():TempSetDurationToTimeLine()
  ServiceHandlerOnLoadedProxy.Instance:Call()
  FunctionGameState.Me():EnteredScene()
end
