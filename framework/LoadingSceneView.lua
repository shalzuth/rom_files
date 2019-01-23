autoImport("DefaultLoadModeView")
autoImport("IllustrationModeView")
autoImport("NewExploreModeView")
autoImport("QuickWithoutProgressView")
LoadingSceneView = class("LoadingSceneView",ContainerView)
LoadingSceneView.ViewType = UIViewType.LoadingLayer
LoadingSceneView.ServerReceiveLoaded = "LoadingSceneView.ServerReceiveLoaded"

function LoadingSceneView:Init()
	self.currentView = nil
	self:InitSubs()
	local panel = self.gameObject:GetComponent(UIPanel)
	self.loadingViewDepth = panel.depth
	if(self.viewdata.view and self.viewdata.view.tab)then
		self:TabChangeHandler(self.viewdata.view.tab)
	else
		self:TabChangeHandler(PanelConfig.LoadingViewDefault.tab)
	end
	-- self.timeTick = TimeTick.new(0,5,self.Update,self,1)
	self.timeTick = TimeTickManager.Me():CreateTick(0,16,self.Update,self,1)
	self:AddViewListeners()
	self.blackBg = self:FindGO("BlackBg"):GetComponent(UISprite)
	self:AddClickEvent(self.blackBg.gameObject,nil,{hideClickSound = true})
end

function LoadingSceneView:InitSubs()
	self:AddTabChangeEvent(nil,self:FindGO("DefaultMode"),PanelConfig.LoadingViewDefault)
	self:AddTabChangeEvent(nil,self:FindGO("IllustrationMode"),PanelConfig.LoadingViewIllustration)
	self:AddTabChangeEvent(nil,self:FindGO("NewExploreMode"),PanelConfig.LoadingViewNewExplore)
	self:AddTabChangeEvent(nil,self:FindGO("QuickWithoutProgress"),PanelConfig.LoadingViewQuickWithoutProgress)
end

function LoadingSceneView:TabChangeHandler(key)
	LoadingSceneView.super.TabChangeHandler(self,key)
	if(key == PanelConfig.LoadingViewDefault.tab) then
		self.currentView = self:AddSubView("DefaultLoadModeView",DefaultLoadModeView)
	elseif(key == PanelConfig.LoadingViewIllustration.tab)then
		self.currentView = self:AddSubView("IllustrationModeView",IllustrationModeView)
	elseif(key == PanelConfig.LoadingViewNewExplore.tab)then
		self.currentView = self:AddSubView("NewExploreModeView",NewExploreModeView)
	elseif(key == PanelConfig.LoadingViewQuickWithoutProgress.tab)then
		self.currentView = self:AddSubView("QuickWithoutProgressView",NewExploreModeView)
	end
end

function LoadingSceneView:OnExit()
	LoadingSceneView.super.OnExit(self)
	self.timeTick:ClearTick()
	FunctionBGMCmd.Me():GetDefaultBGM()
end

function LoadingSceneView:AddViewListeners()
	self:AddListenEvt(LoadEvent.SceneFadeOut,self.SceneFadeOut)
	self:AddListenEvt(LoadEvent.StartLoadScene,self.StartLoadScene)
	self:AddListenEvt(LoadEvent.FinishLoadScene,self.HandlerLogin)
	self:AddListenEvt(ServiceEvent.Error,self.HandlerServiceError)
	self:AddListenEvt(ServiceEvent.ConnNetDown,self.HandlerConnDown)
	-- self:AddListenEvt(MediaPanel.PlayVideoFinish,self.FinishPlayVideo)
end

function LoadingSceneView:HandlerServiceError(note)
	self.serverError = true
	self:CheckNetError()
end

function LoadingSceneView:HandlerConnDown(note)
	self.serverError = true
	self:CheckNetError()
end

function LoadingSceneView:SceneFadeOut(note)
	LeanTween.cancel(self.blackBg.gameObject)
	self.currentView:SceneFadeOut()
end

function LoadingSceneView:DoFadeOut(duration)
	duration = duration~=nil and duration or 0.1
	local videoQuest = FunctionQuest.Me():getMediaQuest(SceneProxy.Instance.currentScene.mapID)
	if(videoQuest) then
		duration = 2
	end
	self.blackBg.alpha = 0
	-- use tween alpha
	local tweenAlpha = TweenAlpha.Begin(self.blackBg.gameObject,duration,1)
	tweenAlpha:SetOnFinished(function ()
		--防止策划又变卦，改为注释掉
		-- self:StepPlayVideo()
		if(videoQuest) then
			-- FunctionBGMCmd.Me():SetVolume(0)
		    SceneProxy.Instance:EnableLoaderFadeBGM(false)
		end
		self:StartLoad()
	end)
	-- LogUtility.Info("LoadingSceneView:DoFadeOut")
end

function LoadingSceneView:DoFadeIn(duration)
	duration = duration~=nil and duration or 1.5
	self.blackBg.alpha = 1
	LeanTween.cancel (self.blackBg.gameObject)
	local lt = LeanTween.value(self.blackBg.gameObject, function (v) 
						self.blackBg.alpha = v									
					end, 1, 0, duration)
	lt:setOnComplete(function()
		self:SceneFadeInFinish()
	end)
	lt:setDestroyOnComplete(true)
end

function LoadingSceneView:StepPlayVideo()
	self.needPlayVideo = FunctionQuest.Me():playMediaQuest(SceneProxy.Instance.currentScene.mapID)
	if(not self.needPlayVideo) then
		self:StartLoad()
	else
		-- FunctionBGMCmd.Me():SetVolume(0)
	    SceneProxy.Instance:EnableLoaderFadeBGM(false)
	end
end

function LoadingSceneView:StartLoad()
	-- LogUtility.Info("LoadingSceneView:StartLoad")
	self:SceneFadeOutFinish()
	SceneProxy.Instance:SyncLoad("LoadScene")
end

function LoadingSceneView:FinishPlayVideo()
	if(self.needPlayVideo) then
		self:StartLoad()
	end
end

function LoadingSceneView:SceneFadeOutFinish()
	FunctionQuest.Me():playMediaQuest(SceneProxy.Instance.currentScene.mapID)
	self.currentView:SceneFadeOutFinish()
end

function LoadingSceneView:SceneFadeInFinish()
	self.currentView:SceneFadeInFinish()
end

function LoadingSceneView:LoadFinish()
	self.currentView:LoadFinish()
end

function LoadingSceneView:CheckNetError()
	if(self.serverError and self.Loaded) then
		FunctionMapEnd.Me():Launch()
	end
end

function LoadingSceneView:FireLoadFinishEvent()
	self:CheckNetError()
    self:sendNotification(ServiceEvent.PlayerMapChange,self.sceneInfo,LoadSceneEvent.FinishLoad)
end

function LoadingSceneView:StartLoadScene(note)
	self.currentView:StartLoadScene(note)
	self.sceneInfo = note.body
	self.Loaded = false
	SceneProxy.Instance:SetLoadFinish(function(info)
		self.Loaded = true
		self.timeTick:ClearTick()
		self:LoadFinish()
	end)
	self.timeTick:Restart()
end

function LoadingSceneView:Update(delta)
	self.currentView:Update(delta)
end

-- function LoadingSceneView:CloseSelf()
-- 	FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene,true)
-- 	Player.Me:TryPlaySceneAnimation()
-- 	LoadingSceneView.super.CloseSelf(self)
-- 	GameFacade.Instance:sendNotification(EnterSceneCommand.EnteredSceneEvt)
-- end