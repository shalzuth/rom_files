autoImport("BaseTip")
TabNameTip = class("TabNameTip", BaseTip)
TNTStateEnum = {
  FADE_IN = 0,
  IDLE = 1,
  FADE_OUT = 2
}
TNTFadeDirEnum = {
  LEFT = "LEFT",
  RIGHT = "RIGHT",
  DOWN = "DOWN",
  UP = "UP"
}
TabNameTip.MaxWidth = 300
TabNameTip.DefaultFadeInDirection = TNTFadeDirEnum.LEFT
TabNameTip.DefaultFadeInDuration = 0.25
TabNameTip.DefaultFadeInDistance = 50
TabNameTip.DefaultFadeOutDirection = TNTFadeDirEnum.RIGHT
TabNameTip.DefaultFadeOutDuration = 0.25
TabNameTip.DefaultFadeOutDistance = 0
TabNameTip.DefaultIdleDuration = 0.5
function TabNameTip:ctor(prefabName, stick, side, offset)
  TabNameTip.super.ctor(self, prefabName, stick.gameObject)
  self.stick = stick
  self.side = side
  self.offset = offset
  self:InitTip()
end
function TabNameTip:InitTip()
  self.tabName = self:FindComponent("TabName", UILabel)
  self.tabBack = self:FindComponent("Back", UISprite)
  self.tweenPosition = self:FindComponent("Main", TweenPosition)
  self.tweenAlpha = self:FindComponent("Main", TweenAlpha)
end
function TabNameTip:SetData(data)
  self:CancelTween()
  self.longPressEnded = false
  self.tabName.text = data.tabName or ""
  self.fadeInDirection = data.fadeInDirection or TabNameTip.DefaultFadeInDirection
  self.fadeInDuration = data.fadeInDuration or TabNameTip.DefaultFadeInDuration
  self.fadeInDistance = data.fadeInDistance or TabNameTip.DefaultFadeInDistance
  self.idleDuration = data.idleDuration or TabNameTip.DefaultIdleDuration
  self.fadeOutDirection = data.fadeOutDirection or TabNameTip.DefaultFadeOutDirection
  self.fadeOutDuration = data.fadeOutDuration or TabNameTip.DefaultFadeOutDuration
  self.fadeOutDistance = data.fadeOutDistance or TabNameTip.DefaultFadeOutDistance
  TabNameTip.FadeInPositionOffset = {
    LEFT = Vector3(self.fadeInDistance, 0, 0),
    RIGHT = Vector3(-self.fadeInDistance, 0, 0),
    DOWN = Vector3(0, self.fadeInDistance, 0),
    UP = Vector3(0, -self.fadeInDistance, 0)
  }
  TabNameTip.FadeOutPositionOffset = {
    LEFT = Vector3(-self.fadeOutDistance, 0, 0),
    RIGHT = Vector3(self.fadeOutDistance, 0, 0),
    DOWN = Vector3(0, -self.fadeOutDistance, 0),
    UP = Vector3(0, self.fadeOutDistance, 0)
  }
  if data.fadeInDirection == TNTFadeDirEnum.LEFT then
    self.tabName.pivot = UIWidget.Pivot.Right
  elseif data.fadeInDirection == TNTFadeDirEnum.RIGHT then
    self.tabName.pivot = UIWidget.Pivot.Left
  else
    self.tabName.pivot = UIWidget.Pivot.Center
  end
  self.tabBack:ResetAndUpdateAnchors()
end
function TabNameTip:OnEnter()
  TabNameTip.super.OnEnter(self)
  self:FadeIn()
end
function TabNameTip:FadeIn()
  self.currentState = TNTStateEnum.FADE_IN
  self:PlayFade()
end
function TabNameTip:TryFadeOut()
  self.longPressEnded = true
  if self.currentState == TNTStateEnum.IDLE and not self.delayedFadeOutTween then
    self:FadeOut()
  end
end
function TabNameTip:FadeOut()
  self.currentState = TNTStateEnum.FADE_OUT
  self:PlayFade()
end
function TabNameTip:PlayFade()
  self.tweenPosition:ResetToBeginning()
  self.tweenAlpha:ResetToBeginning()
  self:SetTweenPosition()
  self:SetTweenAlpha()
  self.tweenPosition:PlayForward()
  self.tweenAlpha:PlayForward()
  self.tweenAlpha:SetOnFinished(function()
    if self.currentState == TNTStateEnum.FADE_IN then
      self.currentState = TNTStateEnum.IDLE
      self.delayedFadeOutTween = LeanTween.delayedCall(self.idleDuration, function()
        if self.longPressEnded then
          self:FadeOut()
        end
        self.delayedFadeOutTween = nil
      end)
    elseif self.currentState == TNTStateEnum.FADE_OUT then
      TipManager.Instance:CloseTabNameTip()
    end
  end)
end
function TabNameTip:DestroySelf()
  self:CancelTween()
  TabNameTip.super.DestroySelf(self)
end
function TabNameTip:CancelTween()
  if self.delayedFadeOutTween then
    self.delayedFadeOutTween:cancel()
    self.delayedFadeOutTween = nil
  end
  if self.tweenPosition then
    self.tweenPosition.enabled = false
  end
  if self.tweenAlpha then
    self.tweenAlpha.enabled = false
  end
end
function TabNameTip:SetTweenPosition()
  self.tweenPosition.from = LuaVector3.zero
  self.tweenPosition.to = LuaVector3.zero
  if self.currentState == TNTStateEnum.FADE_IN then
    self.tweenPosition.duration = self.fadeInDuration
    self.tweenPosition.from = TabNameTip.FadeInPositionOffset[self.fadeInDirection]
  elseif self.currentState == TNTStateEnum.FADE_OUT then
    self.tweenPosition.duration = self.fadeOutDuration
    self.tweenPosition.to = TabNameTip.FadeOutPositionOffset[self.fadeOutDirection]
  end
end
function TabNameTip:SetTweenAlpha()
  if self.currentState == TNTStateEnum.FADE_IN then
    self.tweenAlpha.duration = self.fadeInDuration
    self.tweenAlpha.from = 0
    self.tweenAlpha.to = 1
  elseif self.currentState == TNTStateEnum.FADE_OUT then
    self.tweenAlpha.duration = self.fadeOutDuration
    self.tweenAlpha.from = 1
    self.tweenAlpha.to = 0
  end
end
