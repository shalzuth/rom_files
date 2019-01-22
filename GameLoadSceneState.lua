autoImport("LState")
GameLoadSceneState = class("GameLoadSceneState", LState)

function GameLoadSceneState:Enter()
	if(GameLoadSceneState.super.Enter(self)) then
		printOrange("GameLoadSceneState Enter")
		local sceneData = SceneProxy.Instance:GetFirstNeedLoad()
		self:HandlePreLoad(sceneData)
		self:HandleLoad(sceneData)
	end
end

function GameLoadSceneState:Exit()
	printOrange("GameLoadSceneState Exit")
	self:ReInit()
end

function GameLoadSceneState:HandlePreLoad(sceneData)
	--????????????????????????
	if(sceneData) then
		local data = sceneData
		local mapInfo = SceneProxy.Instance:GetMapInfo(data.mapID)
		self:SetRaidID(data.dmapID,data.preview,mapInfo)
		--????????????????????????????????????
		if(SceneProxy.Instance:IsCurrentScene(data)==true) then
			if(SceneProxy.Instance.currentScene.loaded == true) then
				print("load same scene")
				self:ClearScene()
				ServicePlayerProxy.Instance:CallChangeMap("", 0, 0, 0, data.mapID)
				GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
				-- self:ChangeSceneAddMode()
				MyselfProxy.Instance:ResetMyPos(data.pos.x,data.pos.y,data.pos.z)
				FunctionGameState.Me():EnteredScene()
			else
				return
			end
		else
			FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene,false)
			FunctionMapEnd.Me():Reset()
			-- Player.Me:ResetWhenChangeMap()
			MyselfProxy.Instance:ResetMyBornPos(data.pos.x,data.pos.y,data.pos.z)
		end
	end
end

function GameLoadSceneState:HandleLoad(sceneData)
	if(sceneData) then
		self:StartLoad()
	else
		--????????????????????????
		FunctionGameState.Me():EnteredScene()
	end
end

function GameLoadSceneState:StartLoad()
	if(SceneProxy.Instance:CanLoad()) then
		FunctionBGMCmd.Me():Reset()
		self:ClearScene(true)
		SceneProxy.Instance:StartLoadFirst()
	end
end

function GameLoadSceneState:SetRaidID(raidID,playSceneAnim,mapInfo)
	-- Player.Me.handleRaid = true
	-- if(raidID>0) then
	-- 	Player.Me.activeRaidID = raidID
	-- 	Player.Me.playMode = Player.PlayMode.Raid
	-- 	print(string.format("<color=red>call FunctionDungen Launch %s</color>", tostring(raidID) ) )
	-- 	FunctionDungen.Me():Launch(raidID)
	-- else
	-- 	print(string.format("<color=red>call FunctionDungen Shutdown</color>"))
	-- 	FunctionDungen.Me():Shutdown()
	-- 	Player.Me.activeRaidID = SceneRaid.INVALID_ID

	-- 	Player.Me.playSceneAnimation = (playSceneAnim == 1)
	-- 	if(mapInfo.PVPmap==1) then
	-- 		Player.Me.playMode = Player.PlayMode.PVP
	-- 	else
	-- 		Player.Me.playMode = Player.PlayMode.PVE
	-- 	end
	-- end
	
	print("????????????????????????"..tostring(Player.Me.playSceneAnimation))
	-- print("??????raid id:"..Player.Me.activeRaidID)
end

function GameLoadSceneState:ClearScene(loadOtherScene)
	-- print("remove me.."..MyselfProxy.Instance.myself.id)
	if(loadOtherScene)then
		--?????????????????????UI??????
		GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,{MyselfProxy.Instance.myself})
		FunctionCameraEffect.Me():Shutdown()
		FunctionCameraAdditiveEffect.Me():Shutdown()
		FunctionMapEnd.Me():BeginIgnoreAreaTrigger()
	end
	SceneObjectProxy.ClearAll()
end