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
	-- 1.一转、二转身体和动画
	-- FunctionPreload.Me():PreloadJobs()
	-- 2.NPC
	FunctionPreload.Me():SceneNpcs(Game.Myself:GetPosition(),33)
end

function FunctionChangeScene:TryLoadScene(data)
	self.sceneProxy = SceneProxy.Instance
	EventManager.Me():DispatchEvent(ServiceEvent.PlayerMapChange,data.mapID)
	local mapInfo = self:PrepareData(data)
	local sameScene = self.sceneProxy:IsCurrentScene(data)
	local currentSceneLoaded = self.sceneProxy.currentScene ~= nil and self.sceneProxy.currentScene.loaded or false
	if(sameScene) then
		--相同场景
		if(currentSceneLoaded) then
			self:LoadSameLoadedScene(data)
		else
			--加载场景的队列永远只存两个，A正在加载，队列后还有B，此时又要加载A，那么只需要将B移除队列即可
			local lastNeedLoad = SceneProxy.Instance:GetLastNeedLoad()
			if(lastNeedLoad) then
				SceneProxy.Instance:RemoveNeedLoad(2)
			end
			return
		end
	else
		--不同场景
		self:WaitForLoad(data)
	end
	self:StartLoadScene()
end

function FunctionChangeScene:PrepareData(data)
	LogUtility.InfoFormat("准备加载map: {0} ,raidID: {1}",data.mapID,data.dmapID)
	local mapInfo = SceneProxy.Instance:GetMapInfo(data.mapID)
	if(mapInfo==nil) then
		error("未找到地图id:"..data.mapID.."的信息")
	end
	return mapInfo
end

function FunctionChangeScene:SetRaidID(raidID,playSceneAnim,mapInfo,isSameScene)
	-- Player.Me.handleRaid = true
	-- if(isSameScene==false) then
	-- 	Player.Me.playSceneAnimation = (playSceneAnim == 1)
	-- end
	FunctionDungen.Me():Shutdown()
	if(raidID>0) then
	-- 	Player.Me.activeRaidID = raidID
	-- 	Player.Me.playMode = Player.PlayMode.Raid
	-- 	print(string.format("<color=red>call FunctionDungen Launch %s</color>", tostring(raidID) ) )
		FunctionDungen.Me():Launch(raidID)
	else
	-- 	print(string.format("<color=red>call FunctionDungen Shutdown</color>"))
	-- 	Player.Me.activeRaidID = SceneRaid.INVALID_ID
	-- 	if(mapInfo.PVPmap==1) then
	-- 		Player.Me.playMode = Player.PlayMode.PVP
	-- 	else
	-- 		Player.Me.playMode = Player.PlayMode.PVE
	-- 	end
	end
end

function FunctionChangeScene:LoadSameLoadedScene(data)
	LogUtility.InfoFormat("已在地图{0}中，请求重新加载（只重设位置，和重新添加对象）",data.mapID)
	self:ClearScene()
	local sceneInfo = SceneProxy.Instance.currentScene
	if(sceneInfo) then
		sceneInfo.mapNameZH = data.mapName
	end
	Game.MapManager:SetMapName(data)
	ServicePlayerProxy.Instance:CallChangeMap("", 0, 0, 0, data.mapID)
	-- self:ChangeSceneAddMode()
	MyselfProxy.Instance:ResetMyPos(data.pos.x,data.pos.y,data.pos.z)
	--处理地图传送点
	Game.AreaTrigger_ExitPoint:Shutdown()
	Game.AreaTrigger_ExitPoint:SetInvisibleEPs(data.invisiblexit)
	Game.AreaTrigger_ExitPoint:Launch()
	GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
	EventManager.Me():PassEvent(LoadSceneEvent.FinishLoadScene,sceneInfo)
	GameFacade.Instance:sendNotification(MiniMapEvent.ExitPointReInit)
end

function FunctionChangeScene:StartLoadScene()
	if(SceneProxy.Instance:CanLoad()) then
		self:CacheReceiveNet(true)
		--如果允许加载（判断当前是否已经进入场景，以及剩余队列是否还有需要加载的场景）
		FunctionBGMCmd.Me():Reset()
		self:ClearScene(true)
		SceneProxy.Instance:StartLoadFirst()
		EventManager.Me():PassEvent(LoadSceneEvent.BeginLoadScene)
		local data = SceneProxy.Instance.currentScene
		Game.MapManager:SetCurrentMap(data.serverData, true)
		local sameScene = self.sceneProxy:IsCurrentScene(data)
		local currentSceneLoaded = self.sceneProxy.currentScene ~= nil and self.sceneProxy.currentScene.loaded or false
		self:SetRaidID(data.dungeonMapId,data.preview,Table_Map[data.mapID],sameScene and currentSceneLoaded)
		return true
	end
	return false
end

function FunctionChangeScene:WaitForLoad(data)
	LogUtility.InfoFormat("添加地图加载:{0} {1}",data.mapID,data.mapName)
	FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene,false)
	FunctionMapEnd.Me():Reset()
	SceneProxy.Instance:AddLoadingScene(data)
	MyselfProxy.Instance:ResetMyBornPos(data.pos.x,data.pos.y,data.pos.z)
end

function FunctionChangeScene:LoadedScene(data)
	if(data) then
		LogUtility.InfoFormat("{0} {1} 场景加载完毕",data.mapID,data.mapName)
		self:TryPreLoadResources()
		local sceneQueue = SceneProxy.Instance:FinishLoadScene(data)
		self:EnterScene()
		if(sceneQueue == nil or #sceneQueue ==0) then
			self:AllFinishLoad(data)
		else
			GameFacade.Instance:sendNotification(LoadingSceneView.ServerReceiveLoaded)
			self:StartLoadScene()
			-- if(not self:LoadNext()) then
			-- 	FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene,true)
			-- 	Player.Me:TryPlaySceneAnimation()
			-- end
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
	if nil ~= sceneInfo.dmapID and 0 < sceneInfo.dmapID then
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
	FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene,true)
	ServicePlayerProxy.Instance:CallChangeMap("", 0, 0, 0, sceneInfo.mapID)
	GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "MainView"})
	GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
	FunctionDungen.Me():HandleSceneLoaded()
	FunctionMapEnd.Me():TempSetDurationToTimeLine()

	-- 活动更新追踪信息
	FunctionActivity.Me():UpdateNowMapTraceInfo()
	-- 网络取消缓存部分消息 begin
	self:CacheReceiveNet(false)
	-- 网络取消缓存部分消息 end
	EventManager.Me():PassEvent(LoadSceneEvent.FinishLoadScene,sceneInfo)
	AssetManager.Me():TryUnLoadAllUnused()
	Game.MapManager:Launch()

	MyLuaSrv.ClearLuaMapAsset();
end

function FunctionChangeScene:CacheReceiveNet(v)
	NetProtocol.CachingSomeReceives = v
	if(not v) then
		NetProtocol.CallCachedReceives()
	end
end

function FunctionChangeScene:GC()
	LuaGC.CallLuaGC()
	ResourceManager.Instance:GC()
	GameObjPool.Instance:ClearAll()
end

function FunctionChangeScene:ClearScene(loadOtherScene)
	-- print("remove me.."..MyselfProxy.Instance.myself.id)
	if(loadOtherScene)then
		GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,{MyselfProxy.Instance.myself})
		
		FunctionCameraEffect.Me():Shutdown()
		FunctionCameraAdditiveEffect.Me():Shutdown()

		FunctionMapEnd.Me():BeginIgnoreAreaTrigger()
	end
	SceneObjectProxy.ClearAll()

	-- 清除Gvg旗帜信息
	GvgProxy.Instance:ClearRuleGuildInfos()
end