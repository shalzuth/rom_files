autoImport("DefaultLoadModeView")
SwitchRoleLoadingView = class("SwitchRoleLoadingView",DefaultLoadModeView)

local tmpPos = LuaVector3.zero
function SwitchRoleLoadingView:Init()
	SwitchRoleLoadingView.super.Init(self)
	self:initView()
	self:initData()
end

function SwitchRoleLoadingView:initView()
	LeanTween.delayedCall(0.05, function ()
		local barWidget = self.bar.gameObject:GetComponent(UIWidget)
		if(barWidget) then
			barWidget:ResetAndUpdateAnchors()
			self.barWidth = barWidget.width
			local barForeground = self:FindGO("Foreground"):GetComponent(UISprite)
			barForeground.width = self.barWidth
			self.bar.value = 0
		end
	end)
end

function SwitchRoleLoadingView:initData()
	self:TryLoadPic("loading")
	self:CardMode()
	self.bar.gameObject:SetActive(true)
end

-- function SwitchRoleLoadingView:Update(delta)
-- 	self:Progress(50+SceneProxy.Instance:LoadingProgress()/2)
-- end