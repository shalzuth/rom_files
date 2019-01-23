
autoImport ("EnviromentManager")
autoImport ("AreaTriggerManager")
autoImport ("DungeonManager")
autoImport ("LockTargetEffectManager")
autoImport ("FunctionScenicSpot")
autoImport ("ClickGroundEffectManager")
autoImport ("SkillWorkerManager")
autoImport ("DynamicObjectManager")
autoImport ("CullingObjectManager")
autoImport ("SceneSeatManager")
autoImport ("QuestMiniMapEffectManager")
autoImport ("PlotStoryManager")
autoImport ("HandUpManager");
autoImport ("PictureWallManager");
autoImport ("WeddingWallPicManager");


MapManager = class("MapManager")

MapManager.Mode = {
	PVE = 1,
	PVP = 2,
	Raid = 3
}

-- MapInfo = {
-- 	[1] = ID, -- int
-- 	[2] = name, -- string or nil
-- 	[3] = bornPosition, -- LuaVector3
-- 	[4] = preview, -- bool or nil
-- 	[5] = creatureMaskDistanceLevel,
-- 	[6] = raidID,
-- }

function MapManager:ctor()
	self.mapInfo = {0,nil,LuaVector3.zero,false,0}
	self.enviromentManager = EnviromentManager.new()
	self.areaTriggerManager = AreaTriggerManager.new()
	self.dungeonManager = DungeonManager.new()
	self.lockTargetEffectManager = LockTargetEffectManager.new()
	self.clickGroundManager = ClickGroundEffectManager.new()
	self.skillWorkerManager = SkillWorkerManager.new()
	self.dynamicObjectManager = DynamicObjectManager.new()
	self.cullingObjectManager = CullingObjectManager.new()
	self.sceneSeatManager = SceneSeatManager.new()
	self.questMiniMapEffectManager = QuestMiniMapEffectManager.new()
	self.plotStoryManager = PlotStoryManager.new()
	self.handUpManager = HandUpManager.new()
	self.pictureWallManager = PictureWallManager.new()
	self.weddingWallPicManager = WeddingWallPicManager.new()
	self.scenicManager = FunctionScenicSpot.Me()

	-- set global objects
	Game.EnviromentManager = self.enviromentManager
	Game.AreaTriggerManager = self.areaTriggerManager
	Game.DungeonManager = self.dungeonManager
	Game.LockTargetEffectManager = self.lockTargetEffectManager
	Game.ClickGroundEffectManager = self.clickGroundManager
	Game.SkillWorkerManager = self.skillWorkerManager
	Game.DynamicObjectManager = self.dynamicObjectManager
	Game.CullingObjectManager = self.cullingObjectManager
	Game.SceneSeatManager = self.sceneSeatManager
	Game.QuestMiniMapEffectManager = self.questMiniMapEffectManager
	Game.PlotStoryManager = self.plotStoryManager
	Game.HandUpManager = self.handUpManager
	Game.PictureWallManager = self.pictureWallManager
	Game.WeddingWallPicManager = self.weddingWallPicManager

	self:_Reset()
end

function MapManager:_Reset()
	self.sceneInfo = nil
	self.mode = nil
	self.sceneAnimation = nil
	self.sceneAnimationAnimator = nil
	self.sceneAnimationPlaying = false
	self.running = false
	self.diableInput = false
	self.sceneAnimationShutdownTime = -1;
end

function MapManager:SetInputDisable(disable)
	if self.diableInput == disable then
		return
	end
	self.diableInput = disable
	Game.InputManager.disable = disable
	LogUtility.InfoFormat("<color=yellow>SetInputDisable: </color>{0}", 
		disable)
end

function MapManager:GetMapID()
	return self.mapInfo[1]
end

function MapManager:GetRaidID()
	return self.mapInfo[6]
end

function MapManager:GetMapName()
	return self.mapInfo[2]
end

function MapManager:SetMapName(serverData)
	-- todo xde 服务器返回 无限塔普通层1，试图从客户端翻译
	local lastNumbers = string.match(serverData.mapName, "%d+$")
	if (lastNumbers) then
		local mapName = serverData.mapName:gsub(lastNumbers, "")
		serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(mapName) .. lastNumbers
	end
	self.mapInfo[2] = serverData.mapName
end

function MapManager:GetCreatureMaskRange()
	return self.mapInfo[5]
end

function MapManager:GetSceneInfo()
	return self.sceneInfo
end

function MapManager:GetMode()
	return self.mode
end

function MapManager:IsPVEMode()
	return MapManager.Mode.PVE == self.mode
end

function MapManager:IsPVPMode()
	return MapManager.Mode.PVP == self.mode or self.dungeonManager:IsPVPRaidMode()
end

function MapManager:IsPVPMode_GVGDetailed()
	return self.dungeonManager:IsGVG_Detailed()
end

function MapManager:IsPVPMode_PoringFight()
	return self.dungeonManager:IsPVPMode_PoringFight();
end

function MapManager:IsPVPMode_MvpFight()
	return self.dungeonManager:IsPVPMode_MvpFight();
end

function MapManager:IsPveMode_PveCard()
	return self.dungeonManager:IsPveMode_PveCard();
end

function MapManager:IsPveMode_AltMan()
	return self.dungeonManager:IsPveMode_AltMan();
end

function MapManager:IsGvgMode_Droiyan()
	return self.dungeonManager:IsGvgMode_Droiyan();
end

function MapManager:IsRaidMode()
	return MapManager.Mode.Raid == self.mode
end

function MapManager:IsNoSelectTarget()
	return self.dungeonManager:IsNoSelectTarget()
end

function MapManager:IsEndlessTower()
	if self:IsRaidMode() then
		return self.dungeonManager:IsEndlessTower()
	end

	return false
end

function MapManager:GetBornPointArray()
	return self.sceneInfo and self.sceneInfo.bps or nil
end

function MapManager:GetExitPointArray()
	return self.sceneInfo and self.sceneInfo.eps or nil
end

function MapManager:GetNPCPointArray()
	return self.sceneInfo and self.sceneInfo.nps or nil
end

function MapManager:GetBornPointMap()
	return self.sceneInfo and self.sceneInfo.bpMap or nil
end

function MapManager:GetExitPointMap()
	return self.sceneInfo and self.sceneInfo.epMap or nil
end

function MapManager:GetNPCPointMap()
	return self.sceneInfo and self.sceneInfo.npMap or nil
end

function MapManager:FindBornPoint(ID)
	local map = self:GetBornPointMap()
	return map and map[ID] or nil
end

function MapManager:FindExitPoint(ID)
	local map = self:GetExitPointMap()
	return map and map[ID] or nil
end

function MapManager:FindNPCPoint(ID)
	local map = self:GetNPCPointMap()
	return map and map[ID] or nil
end

function MapManager:SetCurrentMap(serverData, force)
	local currentMapID = self.mapInfo[1]
	local currentRaidID = self.mapInfo[6]
	local mapID = serverData.mapID
	local raidID = serverData.dmapID
	if not force 
		and currentMapID == mapID 
		and currentRaidID == raidID then
		return
	end
	-- 1. shutdown
	self:Shutdown()

	-- 2. set
	local staticData = Table_Map[mapID]
	local mode = staticData.Mode

	local sceneName = staticData.NameEn
	local sceneInfo = autoImport("Scene_"..sceneName)
	local scenePartInfo = nil
	if MapManager.Mode.PVE == mode then
		LogUtility.InfoFormat("<color=yellow>Switch Map PVE: </color>{0}", 
			mapID)
		scenePartInfo = sceneInfo.PVE
	elseif MapManager.Mode.PVP == mode then
		LogUtility.InfoFormat("<color=yellow>Switch Map PVP: </color>{0}", 
			mapID)
		scenePartInfo = sceneInfo.PVP
	elseif MapManager.Mode.Raid == mode then
		LogUtility.InfoFormat("<color=yellow>Switch Map Raid: </color>{0}, {1}", 
			mapID, raidID)
		scenePartInfo = sceneInfo.Raids[raidID]
	end

	if nil ~= scenePartInfo then
		Game.DoPreprocess_ScenePartInfo(scenePartInfo)
	end

	self.mapInfo[1] = mapID
	-- todo xde 服务器返回 无限塔普通层1，试图从客户端翻译
	local lastNumbers = string.match(serverData.mapName, "%d+$")
	if (lastNumbers) then
		local mapName = serverData.mapName:gsub(lastNumbers, "")
		serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(mapName) .. lastNumbers
	end

	self.mapInfo[2] = serverData.mapName
	ProtolUtility.Better_S2C_Vector3(serverData.pos, self.mapInfo[3])
	self.mapInfo[4] = (nil ~= serverData.preview and 0 ~= serverData.preview)
	local creatureMaskRange = staticData.MapUi or 0
	if 0 < creatureMaskRange then
		self.mapInfo[5] = Game.CullingObjectManager:DistanceToLevel(creatureMaskRange)
	else
		self.mapInfo[5] = 99999
	end
	self.mapInfo[6] = raidID
	LogUtility.InfoFormat("<color=yellow>Creature Mask Range: </color>{0}, {1}", 
			self.mapInfo[5], creatureMaskRange)
	Game.AreaTrigger_ExitPoint:SetInvisibleEPs(serverData.invisiblexit)

	self.mode = mode	
	self.sceneInfo = scenePartInfo

	Game.Myself.data:ResetRandom()
end

function MapManager:SetEnviroment(enviromentID, duration)
	self.enviromentManager:SetBaseInfo(enviromentID, duration)
end

function MapManager:SetSceneAnimation(a)
	self.sceneAnimation = a
	if nil ~= a then
		self.sceneAnimationAnimator = a.animator
	else
		self.sceneAnimationAnimator = nil
	end
end

function MapManager:Previewing()
	return self.sceneAnimationPlaying
end

function MapManager:StartPreview()
	if nil ~= self.sceneAnimation and self.sceneAnimationShutdownTime < 0 then
		self.sceneAnimation:Play()
		return true
	end
	return false
end

function MapManager:StopPreview()
	if nil ~= self.sceneAnimation then
		self.sceneAnimation:Stop()
	end
end

function MapManager:SceneAnimationLaunch(animName, time)
	if(self.sceneAnimationPlaying)then
		return;
	end

	if(self.sceneAnimationAnimator == nil)then
		return;
	end

	if(time > 0)then
		self.sceneAnimationShutdownTime = Time.time + time;
	else
		self.sceneAnimationShutdownTime = 0;
	end

	local cameraController = CameraController.singletonInstance
	if(cameraController ~= nil)then
		GameObjectUtil.SetBehaviourEnabled(cameraController , false);
		cameraController.updateCameras = true;
	end

	GameObjectUtil.SetBehaviourEnabled(self.sceneAnimationAnimator , true);
	self.sceneAnimationAnimator:Play(animName)
end

function MapManager:SceneAnimationShutdown()
	if(self.sceneAnimationShutdownTime < 0)then
		return;
	end

	self.sceneAnimationShutdownTime = -1;

	local cameraController = CameraController.singletonInstance
	if(cameraController ~= nil)then
		GameObjectUtil.SetBehaviourEnabled(cameraController , true);
		cameraController.updateCameras = false;
	end

	if(self.sceneAnimationAnimator)then
		GameObjectUtil.SetBehaviourEnabled(self.sceneAnimationAnimator , false);
	end
end

function MapManager:OnPreviewStart()
	if self.sceneAnimationPlaying then
		return
	end
	self.sceneAnimationPlaying = true

	local cameraController = CameraController.singletonInstance
	if nil ~= cameraController then
		cameraController.updateCameras = true
	end

	GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "SceneAnimationPanel"})
end

function MapManager:OnPreviewStop()
	if not self.sceneAnimationPlaying then
		return
	end
	self.sceneAnimationPlaying = false

	local cameraController = CameraController.singletonInstance
	if nil ~= cameraController then
		cameraController.updateCameras = false
	end
	
	GameFacade.Instance:sendNotification(UIEvent.CloseUI,SceneAnimationPanel.ViewType)
end

function MapManager:_CameraFocusMyself()
	local cameraController = CameraController.singletonInstance
	if nil ~= cameraController then
		local myselfTransform = Game.Myself.assetRole.completeTransform
		local cameraInfo = cameraController.defaultInfo
		if nil ~= cameraInfo then
			cameraInfo.focus = myselfTransform
			cameraController:RestoreDefault(0, nil)
		end
		cameraInfo = cameraController.photographInfo
		if nil ~= cameraInfo then
			cameraInfo.focus = myselfTransform
		end
	end
	EventManager.Me():PassEvent(PlayerEvent.CapturedCamera)
end

function MapManager:_LaunchAfterPreview()
	self:_CameraFocusMyself()

	self:SetInputDisable(false)

	self.areaTriggerManager:Launch()

	if MapManager.Mode.Raid == self.mode then
		self.dungeonManager:Launch()
	end

	self.handUpManager:Launch();
	self.plotStoryManager:Launch();

	self.cullingObjectManager:ReferenceToMyself(true)

	-- 根据地图限制刷新道具状态
	GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate);
	GameFacade.Instance:sendNotification(LoadSceneEvent.SceneAnimEnd);
end

function MapManager:Launch()
	if self.running then
		return
	end
	self.running = true

	Game.GameObjectManagers[Game.GameObjectType.Camera]:DeterminMainCamera()
	local cameraInfo = self.sceneInfo.cameraInfo
	if nil ~= cameraInfo then
		local cameraController = CameraController.singletonInstance
		if nil ~= cameraController then
			local cameraDefaultInfo = cameraController.defaultInfo
			cameraDefaultInfo.focusOffset = cameraInfo.focusOffset
			cameraDefaultInfo.focusViewPort = cameraInfo.focusViewPort
			cameraDefaultInfo.rotation = cameraInfo.rotation
			cameraDefaultInfo.fieldOfView = cameraInfo.fieldOfView
		end
	end

	Game.Myself:EnterScene()

	Game.Myself:Client_PlaceTo(self.mapInfo[3])

	self.cullingObjectManager:Launch()
	self.sceneSeatManager:Launch()
	self.enviromentManager:Launch()
	self.skillWorkerManager:Launch()
	self.dynamicObjectManager:Launch()
	self.questMiniMapEffectManager:Launch()
	self.pictureWallManager:Launch()
	self.weddingWallPicManager:Launch()

	if MapManager.Mode.Raid == self.mode then
		self.dungeonManager:SetRaidID(self.mapInfo[1])
	end

	if self.mapInfo[4] and self:StartPreview() then
		self:OnPreviewStart()
	else
		self:_LaunchAfterPreview()
	end

	self:ShowMapName();

	if self:IsPVPMode() then
		SkillInfo.SetMapMode(2)
	else
		SkillInfo.SetMapMode(1)
	end
end

function MapManager:ShowMapName()
	local nowMapId = self.mapInfo[1];
	local mapdata = nowMapId and Table_Map[nowMapId];
	if(mapdata~=nil and mapdata.MapTips == 1)then
		FloatingPanel.Instance:ShowMapName(mapdata.NameZh, mapdata.Desc);
	end
end

function MapManager:Shutdown()
	if(Game.Myself) then
		Game.Myself:RemoveObjsWhenLeaveScene()
	end
	if not self.running then
		return
	end
	self.running = false

	if(Game.Myself) then
		Game.Myself:LeaveScene()
	end

	self.cullingObjectManager:ReferenceToMyself(false)

	Game.GameObjectManagers[Game.GameObjectType.Camera]:ClearMainCamera()

	if nil ~= Camera.main then
		Camera.main.gameObject:SetActive(false)
	end
	self:SetInputDisable(true)

	self.sceneSeatManager:Shutdown()
	self.cullingObjectManager:Shutdown()
	self.enviromentManager:Shutdown()
	self.areaTriggerManager:Shutdown()
	self.dungeonManager:Shutdown()
	self.clickGroundManager:Shutdown()
	self.lockTargetEffectManager:ClearLockedTarget()
	self.skillWorkerManager:Shutdown()
	self.dynamicObjectManager:Shutdown()
	self.questMiniMapEffectManager:Shutdown()
	self.plotStoryManager:Shutdown();
	self.pictureWallManager:Shutdown();
	self.weddingWallPicManager:Shutdown();
	self:SceneAnimationShutdown();

	self:OnPreviewStop()

	self.sceneAnimation = nil
	self.sceneAnimationAnimator = nil
	self.sceneAnimationPlaying = false
end

function MapManager:Update(time, deltaTime)
	if not self.running then
		return
	end

	self.enviromentManager:Update(time, deltaTime)

	if self.sceneAnimationPlaying then
		if self.sceneAnimationAnimator.enabled then
			return
		else
			self:OnPreviewStop()
			self:_LaunchAfterPreview()
		end
	end

	self.areaTriggerManager:Update(time, deltaTime)
	self.dungeonManager:Update(time, deltaTime)
	self.skillWorkerManager:Update(time, deltaTime)
	self.dynamicObjectManager:Update(time, deltaTime)
	self.sceneSeatManager:Update(time, deltaTime)
	self.questMiniMapEffectManager:Update(time, deltaTime)
	self.plotStoryManager:Update(time, deltaTime)
	self.handUpManager:Update(time, deltaTime)
	self.scenicManager:Update(time, deltaTime)

	if(self.sceneAnimationShutdownTime > 0 and time >= self.sceneAnimationShutdownTime)then
		self:SceneAnimationShutdown();
	end
end

function MapManager:LateUpdate(time, deltaTime)
	if not self.running then
		return
	end

	self.cullingObjectManager:LateUpdate(time, deltaTime)
end

