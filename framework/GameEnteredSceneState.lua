autoImport("LState")
GameEnteredSceneState = class("GameEnteredSceneState", LState)

function GameEnteredSceneState:Enter()
	if(GameEnteredSceneState.super.Enter(self)) then
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
	for i=1,#sceneInfo.invisiblexit do
		local exitPoint = ExitPointManager.Instance:GetExitPoint(sceneInfo.invisiblexit[i])
		if(exitPoint) then
			print("隐藏传送点",sceneInfo.invisiblexit[i])
			exitPoint.gameObject:SetActive(false)
		else
			printRed("服务器发送了一个场景不存在的exitpoint "..sceneInfo.invisiblexit[i].." (也可能是场景正在加载中)")
		end
		GameFacade.Instance:sendNotification(MiniMapEvent.ExitPointStateChange, {id = exitPoint.ID, state = false});
	end
end