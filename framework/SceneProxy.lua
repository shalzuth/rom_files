local SceneProxy = class('SceneProxy', pm.Proxy)
autoImport("SceneData")
autoImport("Table_Map")
SceneLoader = autoImport("SceneLoader")
SceneProxy.Instance = nil;
SceneProxy.NAME = "SceneProxy"

--临时添加状态
SceneProxy.SceneState = {
	None = 1,
	Loading = 2,
	Loaded = 3,
	Entered = 4
}

local guildRaidType = 13

--场景管理，场景的加载队列管理等

function SceneProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SceneProxy.NAME
	if(SceneProxy.Instance == nil) then
		SceneProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	-- self.isLoadingScene = false
	self.currentScene = nil
	self.LoadingScenes = {}
	self.sceneLoader = SceneLoader.new()
	--temp
	self.state = SceneProxy.SceneState.None
end

function SceneProxy:onRegister()
end

function SceneProxy:onRemove()
end

function SceneProxy:GetMapInfo(id)
	return Table_Map[id]
end

function SceneProxy:IsSameMapOrRaid(id)
	if(self.currentScene) then
		return self.currentScene:IsSameMapOrRaid(id)
	end
	return false
end

function SceneProxy:IsPvPScene()
	if(self.currentScene)then
		return self.currentScene:IsPvPMap()
	end
	return false;
end

function SceneProxy:IsDungeonScene()
	return self.currentScene:IsInDungeonMap()
end

function SceneProxy:GetCurMapID()
	return self.currentScene.mapID
end

function SceneProxy:GetCurRaidID()
	return self.currentScene.dungeonMapId
end

function SceneProxy:GetCurImageID()
	return self.currentScene.imageid or 0;
end

function SceneProxy:SyncLoad(name)
	self.sceneLoader:SyncLoad(name)
end

function SceneProxy:StartChangeScene(sceneInfo)
	self.sceneLoader:StartLoad(sceneInfo.mapName,sceneInfo:GetBundleName())
end

function SceneProxy:GetFirstNeedLoad()
	return self.LoadingScenes[1]
end

function SceneProxy:GetLastNeedLoad()
	return self.LoadingScenes[#self.LoadingScenes]
end

function SceneProxy:RemoveNeedLoad(index)
	self.LoadingScenes[index] = nil
end

function SceneProxy:EnableLoaderFadeBGM( value )
	self.sceneLoader:EnableFadeBGM(value)
end

function SceneProxy:StartLoadFirst()
	-- print("load")
	if(#self.LoadingScenes >0) then
		self.sceneLoader.isLoading = true
		self.state = SceneProxy.SceneState.Loading
		self.sceneLoader:RestoreLimitLoadTime()
		if(self.currentScene == nil) then
			local sceneData = SceneData.new(self.LoadingScenes[1])
			self.currentScene = sceneData
			self.lastMapID = self.currentScene.mapID
		else
			local lastDmap = self.currentScene.dungeonMapId
			self.lastMapID = self.currentScene.mapID
			self.currentScene:Reset(self.LoadingScenes[1])
			local nowDmap = self.currentScene.dungeonMapId
			local lastMapRaid = Table_MapRaid[lastDmap]
			local nowMapRaid = Table_MapRaid[nowDmap]
			if(nowMapRaid~=nil and lastMapRaid~=nil) then
				if(lastMapRaid.Type == nowMapRaid.Type and nowMapRaid.Type == guildRaidType) then
					self.currentScene:SetQuickLoadWithoutProgress(-1)
					self.sceneLoader:SetLimitLoadTime(-1,100)
				end
			end
		end
		LogUtility.InfoFormat("start load scene {0}",self.currentScene.mapID)
		-- FunctionQuest.Me():playMediaQuest(self.currentScene.mapID)
		local pic = FunctionQuest.Me():getIllustrationQuest( self.currentScene.mapID )
		if(pic) then
			self.currentScene:SetIllustrationLoadMode(pic)
		else
			local mapArea = WorldMapProxy.Instance:GetMapAreaDataByMapId(self.currentScene.mapID)
			if(mapArea and mapArea.isNew) then
			-- if(mapArea) then
				self.currentScene:SetNewExploreMapArea(mapArea)
			end
		end
		self:OpenCurrentLoadingView()
		self:sendNotification(LoadEvent.SceneFadeOut)
		-- self:SyncLoad("LoadScene")
	end
end

function SceneProxy:ASyncLoad()
	local sceneInfo = self.currentScene
	self:StartChangeScene(sceneInfo)
	self:OpenCurrentLoadingView()
	self:sendNotification(LoadEvent.StartLoadScene,self.LoadingScenes[1])
end

function SceneProxy:OpenCurrentLoadingView()
	if(SwitchRolePanel and SwitchRolePanel.isSwitchRoleIng) then
		return
	end
	if(self.currentScene.loadMode == SceneData.LoadMode.Default) then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.LoadingViewDefault}) 
	elseif(self.currentScene.loadMode == SceneData.LoadMode.Illustration) then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.LoadingViewIllustration,viewdata = self.currentScene.param}) 
	elseif(self.currentScene.loadMode == SceneData.LoadMode.NewExplore) then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.LoadingViewNewExplore,viewdata = self.currentScene.param}) 
	elseif(self.currentScene.loadMode == SceneData.LoadMode.QuickLoadWithoutProgress) then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.LoadingViewQuickWithoutProgress,viewdata = self.currentScene.param}) 
	end
end

function SceneProxy:EnterScene()
	self.state = SceneProxy.SceneState.Entered
end

function SceneProxy:IsInScene()
	return (self.state == SceneProxy.SceneState.Entered)
end

function SceneProxy:IsLoading()
	return self.state ~= SceneProxy.SceneState.Entered and self.state ~= SceneProxy.SceneState.None
	-- return self.sceneLoader ~= nil and self.sceneLoader.isLoading or false
end

function SceneProxy:CanLoad()
	return (self:IsLoading() ==false and #self.LoadingScenes>0)==true
end

function SceneProxy:IsCurrentScene(sceneInfo)
	return (self.currentScene ~=nil and sceneInfo.mapID == self.currentScene.mapID
		and sceneInfo.dmapID == self.currentScene.dungeonMapId
		and SceneData.MapIDIsPVPMap(sceneInfo.mapID) == self.currentScene:IsPvPMap()) ==true
end

function SceneProxy:IsSameScene(sceneInfo1,sceneInfo2)
	return (sceneInfo1 ~=nil and sceneInfo1.mapID == sceneInfo2.mapID
		and sceneInfo1.dmapID == sceneInfo2.dmapID
		and SceneData.MapIDIsPVPMap(sceneInfo1.mapID) == SceneData.MapIDIsPVPMap(sceneInfo2.mapID)) ==true
end

function SceneProxy:LoadingProgress()
	if(self.sceneLoader == nil) then
		return 0
	else
		return self.sceneLoader.Progress
	end
end

function SceneProxy:SetLoadFinish( callback )
	self.sceneLoader:SetDoneCallBack(callback)
end

function SceneProxy:AddLoadingScene(sceneInfo)
	--如果加载场景列表超过两个，则只需更新第二个
	if(#self.LoadingScenes>1) then
		self.LoadingScenes[2] = sceneInfo
	else
		table.insert( self.LoadingScenes, sceneInfo)
	end
	return true
end

function SceneProxy:FinishLoadScene(sceneInfo)
	self.currentScene:Reset(sceneInfo)
	self.currentScene.loaded = true
	self.state = SceneProxy.SceneState.Loaded
	for _, o in pairs(self.LoadingScenes) do
 		if o.mapID == sceneInfo.mapID then
 			table.remove(self.LoadingScenes, _)
 			break
 		end
 	end
 	return self.LoadingScenes
end

function SceneProxy:LoadedSceneAwaked()
	self.sceneLoader:SceneAwake()
end

function SceneProxy:SetGameTime(data)
	-- print(string.format("<color=yellow>Receive Set Game Time: </color>opt=%d, sec=%d, speed=%d", data.opt, data.sec, data.speed))
	-- local timelineController = TimeLineController.Instance
	-- if nil ~= timelineController then
	-- 	if SceneUser2_pb.EGAMETIMEOPT_SYNC == data.opt then
	-- 		timelineController.speed = data.speed
	-- 		local progress = DateTimeHelper.GetTimeProgressInDay(data.sec)
	-- 		timelineController:EndSpeedTo()
	-- 		timelineController:ResetProgress(progress)
	-- 		-- print(string.format("<color=yellow>Set Game Time: </color>progress=%f, speed=%f", progress, data.speed))
	-- 	elseif SceneUser2_pb.EGAMETIMEOPT_ADJUST == data.opt then
	-- 		local toProgress = DateTimeHelper.GetTimeProgressInDay(data.sec)
	-- 		local fromProgress = timelineController.progress
	-- 		if fromProgress < toProgress then
	-- 			timelineController:SpeedToProgress(data.speed, toProgress)
	-- 			-- print(string.format("<color=yellow>Game Time Speed To: </color>toProgress=%f, speed=%f", toProgress, data.speed))
	-- 		end
	-- 	end
	-- end
end

return SceneProxy