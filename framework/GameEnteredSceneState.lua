autoImport("LState")
GameEnteredSceneState = class("GameEnteredSceneState", LState)
function GameEnteredSceneState:Enter()
  if GameEnteredSceneState.super.Enter(self) then
    printOrange("GameEnteredSceneState Enter")
    local sceneData = SceneProxy.Instance:GetFirstNeedLoad()
    local data = sceneData.serverData
    self:HandleExitPoints(data)
  end
end
function GameEnteredSceneState:Exit()
  printOrange("GameEnteredSceneState Exit")
  self:ReInit()
end
function GameEnteredSceneState:HandleExitPoints(sceneInfo)
  for i = 1, #sceneInfo.invisiblexit do
    local exitPoint = ExitPointManager.Instance:GetExitPoint(sceneInfo.invisiblexit[i])
    if exitPoint then
      exitPoint.gameObject:SetActive(false)
    else
      printRed("\230\156\141\229\138\161\229\153\168\229\143\145\233\128\129\228\186\134\228\184\128\228\184\170\229\156\186\230\153\175\228\184\141\229\173\152\229\156\168\231\154\132exitpoint " .. sceneInfo.invisiblexit[i] .. " (\228\185\159\229\143\175\232\131\189\230\152\175\229\156\186\230\153\175\230\173\163\229\156\168\229\138\160\232\189\189\228\184\173)")
    end
    GameFacade.Instance:sendNotification(MiniMapEvent.ExitPointStateChange, {
      id = exitPoint.ID,
      state = false
    })
  end
end
