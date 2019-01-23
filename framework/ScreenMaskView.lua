ScreenMaskView = class("ScreenMaskView",BaseView)

ScreenMaskView.ViewType = UIViewType.LoadingLayer

function ScreenMaskView:Init()
	self:FindBg()
end

function ScreenMaskView:FindBg()
	self.bgMask = self:FindGO("BgMask"):GetComponent(UISprite)
	self.bgMask.color = self.viewdata.color
end

function ScreenMaskView:OnEnter()
	self:FadeIn()
end

function ScreenMaskView:OnExit()
	LeanTween.cancel(self.gameObject)
end

function ScreenMaskView:FadeIn()
	LeanTween.value(self.gameObject, function(f)
				self.bgMask.alpha = f
			end, 0,1, self.viewdata.fadeInTime):setOnComplete(function ()
				if(self.viewdata.fadeInCallBack) then
					self.viewdata.fadeInCallBack()
				end
				self:FadeOut()
			end):setDestroyOnComplete(true);
end

function ScreenMaskView:FadeOut()
	LeanTween.value(self.gameObject, function(f)
				self.bgMask.alpha = f
			end, 1,0, self.viewdata.fadeOutTime):setOnComplete(function ()
				if(self.viewdata.fadeOutCallBack) then
					self.viewdata.fadeOutCallBack()
				end
				self:CloseSelf()
			end):setDestroyOnComplete(true);
end

function ScreenMaskView:FadeMask(fadeInTime,fadeOutTime,fadeInCallBack,fadeOutCallBack,color)
	-- body
end