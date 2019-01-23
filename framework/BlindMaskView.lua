BlindMaskView = class("BlindMaskView",ContainerView)

BlindMaskView.ViewType = UIViewType.BlindLayer

function BlindMaskView:Init()
	self:AddEvts()
end

function BlindMaskView:AddEvts()
	self:AddListenEvt(MyselfEvent.UpdateAttrEffect , self.UpdateAttrEffect)
end

function BlindMaskView:UpdateAttrEffect()
	if Game.Myself.data.attrEffect:BlindnessState() then
		if self.initialized == nil or self.initialized == false then
			self.initialized = self:InitPage()
		end

		if self.initialized then
			self.tweenAlpha:ResetToBeginning()
			self.tweenAlpha:PlayForward()
			self.timeTick:StartTick()
		end
	else
		if self.initialized then
			self.tweenAlpha.enabled = false
			self.tweenAlpha.value = self.tweenAlpha.from
			self.timeTick:StopTick()
		end
	end
end

-- initialize
function BlindMaskView:InitPage()
	self:FindObjs()	
	self:InitShow()

	return self:InitMaskTexture()
end

function BlindMaskView:FindObjs()
	self.maskTex = self:FindGO("BlindMask"):GetComponent(UITexture)
	self.tweenAlpha = self.maskTex.gameObject:GetComponent(TweenAlpha)
end

function BlindMaskView:InitShow()
	local offsetTotal = 1
	self.offsetHalf = offsetTotal / 2
	self.size = 1.5
	self.rect = Rect(0,0,1,1)

	self.timeTick = TimeTickManager.Me():CreateTick(0,33,self.FollowMyself,self)
end

function BlindMaskView:InitMaskTexture()

	if Game.Myself.assetRole == nil then
		return false
	end

	if Camera.main == nil then
		return false
	end

	self.ep = Game.Myself.assetRole:GetCPOrRoot(RoleDefines_CP.Face)

	local aspectRatio = Screen.width / Screen.height
	local screenPos = Camera.main:WorldToScreenPoint(self.ep.transform.position)
	self:SetMaskPos(screenPos.x , screenPos.y , aspectRatio * self.size , self.size)

	return true
end

function BlindMaskView:SetMaskRect(x,y,width,height)
	self.rect.x = x
	self.rect.y = y
	self.rect.width = width
	self.rect.height = height

	self.maskTex.uvRect = self.rect
end

function BlindMaskView:SetMaskPos(posx,posy,width,height)
	if width == nil then
		width = self.maskTex.uvRect.width
	end
	if height == nil then
		height = self.maskTex.uvRect.height
	end
	local x = self.offsetHalf - (posx / Screen.width) * width
	local y = self.offsetHalf - (posy / Screen.height) * height

	self:SetMaskRect(x, y, width , height )
end

function BlindMaskView:FollowMyself()
	if Camera.main and self.ep then
		local screenPos = Camera.main:WorldToScreenPoint(self.ep.transform.position)
		self:SetMaskPos(screenPos.x , screenPos.y )
	end
end