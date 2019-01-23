QuickWithoutProgressView = class("QuickWithoutProgressView",SubView)

function QuickWithoutProgressView:Init()
	self.gameObject = self:FindGO("QuickWithoutProgress")
	self.data = self.viewdata.viewdata and self.viewdata.viewdata or 1
	self:AddViewListeners()
end

function QuickWithoutProgressView:OnEnter()
	Game.AssetManager_Role:SetForceLoadAll(true)
	QuickWithoutProgressView.super.OnEnter(self)
end

function QuickWithoutProgressView:OnExit()
	Game.AssetManager_Role:SetForceLoadAll(false)
	QuickWithoutProgressView.super.OnExit(self)
end

function QuickWithoutProgressView:AddViewListeners()
end

function QuickWithoutProgressView:ServerReceiveLoadedHandler(note)
	-- self.pic.gameObject:SetActive(false)
	-- self.container:CloseSelf()
	-- self.serverReceiveLoaded = true
end

function QuickWithoutProgressView:SceneFadeOut(note)
	self:CancelTweenPic()
	self.container:DoFadeOut(1.5)
end

function QuickWithoutProgressView:SceneFadeInFinish()
	-- self.container:FireLoadFinishEvent()
	self.container:CloseSelf()
end

function QuickWithoutProgressView:LoadFinish()
	self.container:FireLoadFinishEvent()
	self:TweenPic(1,0,0.8)
	self.container:DoFadeIn(2.5)
end

function QuickWithoutProgressView:SceneFadeOutFinish()
end

function QuickWithoutProgressView:StartLoadScene(note)
end

function QuickWithoutProgressView:Update(delta)
end