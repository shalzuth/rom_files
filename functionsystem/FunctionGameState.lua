autoImport("EventDispatcher")
autoImport("LStateMachine")
autoImport("GameLoadSceneState")
autoImport("GameEnteredSceneState")
autoImport("GameAfterLoadSceneState")
FunctionGameState = class("FunctionGameState", EventDispatcher)
function FunctionGameState.Me()
  if nil == FunctionGameState.me then
    FunctionGameState.me = FunctionGameState.new()
  end
  return FunctionGameState.me
end
function FunctionGameState:ctor()
  self.stateMachine = LStateMachine.new()
  self.loadState = GameLoadSceneState.new()
  self.enteredSceneState = GameEnteredSceneState.new()
  self.afterLoadedState = GameAfterLoadSceneState.new()
end
function FunctionGameState:Reset()
end
function FunctionGameState:NeedLoadScene(data)
  EventManager.Me():DispatchEvent(ServiceEvent.PlayerMapChange, data.mapID)
  local mapInfo = SceneProxy.Instance:GetMapInfo(data.mapID)
  if mapInfo ~= nil then
    data.mapName = "Scene" .. mapInfo.NameEn
  else
    error("\230\156\170\230\137\190\229\136\176\229\156\176\229\155\190id:" .. data.mapID .. "\231\154\132\228\191\161\230\129\175")
  end
  if SceneProxy.Instance:IsCurrentScene(data) == true then
    if SceneProxy.Instance.currentScene.loaded == false then
      local lastNeedLoad = SceneProxy.Instance:GetLastNeedLoad()
      if lastNeedLoad then
        SceneProxy.Instance:RemoveNeedLoad(2)
      end
      return
    end
  else
    SceneProxy.Instance:AddLoadingScene(data)
  end
  self.stateMachine:SwitchState(self.loadState)
end
function FunctionGameState:AfterLoadScene()
  self.stateMachine:SwitchState(self.afterLoadedState)
end
function FunctionGameState:EnteredScene()
  self.stateMachine:SwitchState(self.enteredSceneState)
end
