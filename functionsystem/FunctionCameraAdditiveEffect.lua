
autoImport ("CameraAdditiveEffect")
autoImport ("CameraPositionOffsetEffect")
autoImport ("CameraAdditiveEffectShake")

FunctionCameraAdditiveEffect = class("FunctionCameraAdditiveEffect")

function FunctionCameraAdditiveEffect.Me()
	if nil == FunctionCameraAdditiveEffect.me then
		FunctionCameraAdditiveEffect.me = FunctionCameraAdditiveEffect.new()
	end
	return FunctionCameraAdditiveEffect.me
end

-- static function begin

function FunctionCameraAdditiveEffect.LaunchEffect(effect)
	if nil ~= effect then
		local cameraController = CameraController.Instance
		if not GameObjectUtil.Instance:ObjectIsNULL(cameraController) then
			effect:Launch(cameraController)
		end
	end
end

function FunctionCameraAdditiveEffect.ShutdownEffect(effect)
	if nil ~= effect then
		effect:Shutdown()
	end
end

function FunctionCameraAdditiveEffect.EffectRunning(effect)
	return nil ~= effect and effect.running
end

-- static function end

function FunctionCameraAdditiveEffect:ctor()
	self.effects = {}
	for k,v in pairs(CameraAdditiveEffect.Type) do
		self.effects[v] = self
	end
end

function FunctionCameraAdditiveEffect:Reset()
	if nil == self.effects then
		return
	end
	for i = 1, #self.effects do
		local effect = self.effects[i]
		if self ~= effect then
			FunctionCameraAdditiveEffect.ShutdownEffect(effect)
		end
	end
end

function FunctionCameraAdditiveEffect:Shutdown()
	self:Reset()
end

function FunctionCameraAdditiveEffect:GetEffect(effectType)
	local effect = self.effects[effectType]
	if self ~= effect then
		return effect
	end
	return nil
end

function FunctionCameraAdditiveEffect:SetEffect(effect)
	self.effects[effect.type] = effect
end

function FunctionCameraAdditiveEffect:EffectBussy(effectType)
	local effect = self:GetEffect(effectType)
	if nil ~= effect then
		return FunctionCameraAdditiveEffect.EffectRunning(effect)
	end
	return false
end

function FunctionCameraAdditiveEffect:StartEffect(effect)
	local effectType = effect.type
	if self:EffectBussy(effectType) then
		return false
	end
	self:SetEffect(effect)
	FunctionCameraAdditiveEffect.LaunchEffect(effect)
	return true
end

function FunctionCameraAdditiveEffect:EndEffect(effect)
	local effectType = effect.type
	local currentEffect = self:GetEffect(effectType)
	if currentEffect ~= effect then
		return false
	end
	FunctionCameraAdditiveEffect.ShutdownEffect(currentEffect)
	return true
end

function FunctionCameraAdditiveEffect:EndEffectByType(effectType)
	local currentEffect = self:GetEffect(effectType)
	FunctionCameraAdditiveEffect.ShutdownEffect(currentEffect)
end



