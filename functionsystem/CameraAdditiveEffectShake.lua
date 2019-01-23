CameraAdditiveEffectShake = class("CameraAdditiveEffectShake", CameraPositionOffsetEffect)

CameraAdditiveEffectShake.CURVE_DEGRESSION = 1
CameraAdditiveEffectShake.CURVE_UNIFORM = 2

function CameraAdditiveEffectShake:SetParams(range, duration, curve)
	self.maxRange = range or 0.3
	self.duration = duration or -1
	self.curve = curve or CameraAdditiveEffectShake.CURVE_DEGRESSION
end

function CameraAdditiveEffectShake:OnStart()
	CameraAdditiveEffectShake.super.OnStart(self)

	self.range = self.maxRange
	self.timeEscaped = 0
	TimeTickManager.Me():CreateTick(0,16,self.Update,self)
end

function CameraAdditiveEffectShake:OnEnd()
	CameraAdditiveEffectShake.super.OnEnd(self)

	TimeTickManager.Me():ClearTick(self)

	self:SetParams()
end

function CameraAdditiveEffectShake:Update(deltaTime)
	local deltaTimeSeconds = deltaTime / 1000

	self:Apply(LuaUtils.RandomInsideSphere(self.range))

	self.timeEscaped = self.timeEscaped + deltaTimeSeconds
	if 0 < self.duration then
		if self.timeEscaped >= self.duration then
			self:Shutdown()
		elseif CameraAdditiveEffectShake.CURVE_DEGRESSION == self.curve then
			local progress = self.timeEscaped / self.duration
			self.range = self.maxRange * (1-progress)
		end
	end
end