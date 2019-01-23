CameraEffectTag = {
	NPC_Dialog = 1,
}

autoImport ("CameraEffect")
autoImport ("CameraEffectFocusTo")
autoImport ("CameraEffectFocusAndRotateTo")
autoImport ("CameraEffectFaceTo")

FunctionCameraEffect = class("FunctionCameraEffect")

function FunctionCameraEffect.Me()
	if nil == FunctionCameraEffect.me then
		FunctionCameraEffect.me = FunctionCameraEffect.new()
	end
	return FunctionCameraEffect.me
end

function FunctionCameraEffect:ctor()
	self.stack = LStack.new()
	self.paused = 0
	self:Reset()
end

function FunctionCameraEffect:Reset()
	
end

function FunctionCameraEffect:Paused()
	return 0 < self.paused
end

function FunctionCameraEffect:Pause()
	local oldPaused = self:Paused()
	self.paused = self.paused+1
	if not oldPaused and self:Paused() then
		self:EndTryResume()
		self:ResetEffect(nil)
	end
end

function FunctionCameraEffect:Resume()
	local oldPaused = self:Paused()
	self.paused = self.paused-1
	if oldPaused and not self:Paused() then
		self:BeginTryResume()
	end
end

function FunctionCameraEffect:DoResume()
	if nil ~= self.effect then
		local cameraController = CameraController.Instance
		if not GameObjectUtil.Instance:ObjectIsNULL(cameraController) then
			self.effect:Start(cameraController)
		end
	end
	self:EndTryResume()
end

function FunctionCameraEffect:BeginTryResume()
	if nil ~= CameraController.singletonInstance then
		if nil == self.cameraSingletonListener then
			self.cameraSingletonListener = function(cameraController, beSingleton)
				if beSingleton then
					self:EndTryResume()
					self:DoResume()
				end
			end
			CameraController.singletonInstance.singletonChangedListener = {"+=", self.cameraSingletonListener}
		end
	else
		if nil == self.tryResumeTick then
			self.tryResumeTick = TimeTickManager.Me():CreateTick(0,16,self.DoTrtResume,self)
		end
	end
end

function FunctionCameraEffect:EndTryResume()
	if nil ~= self.tryResumeTick then
		TimeTickManager.Me():ClearTick(self)
		self.tryResumeTick = nil
	end

	if nil ~= CameraController.singletonInstance and nil ~= self.cameraSingletonListener then
		CameraController.singletonInstance.singletonChangedListener = {"-=", self.cameraSingletonListener}
		self.cameraSingletonListener = nil
	end
end

function FunctionCameraEffect:DoTrtResume()
	if self:Paused() then
		self:EndTryResume()
		return
	end
	if nil == CameraController.singletonInstance then
		return
	end
	if nil ~= CameraController.Instance then
		self:EndTryResume()
		self:DoResume()
	else
		self:BeginTryResume()
	end
end

function FunctionCameraEffect:AddEffect(newEffect)
	if nil == newEffect then
		return
	end

	if self.stack:Has(newEffect) then
		return
	end

	self.stack:Push(newEffect)
	self:ResetEffect(newEffect)
end

function FunctionCameraEffect:RemoveEffect(effect)
	if not self.stack:Has(effect) then
		return
	end

	if 0 ~= self.stack:Remove(effect) then
		local newEffect = self.stack:Peek()
		self:ResetEffect(newEffect) -- mabe nil
	end
end

function FunctionCameraEffect:ClearAllEffect()
	self.stack:Clear()
	self:ResetEffect(nil)
end

function FunctionCameraEffect:ResetEffect(newEffect)
	local oldEffect = self.effect
	if oldEffect == newEffect then
		return
	end
	self.effect = newEffect

	local cameraController = CameraController.Instance
	if nil ~= oldEffect then
		cameraController = oldEffect.cameraController
		oldEffect:End()
	end

	if nil ~= newEffect then
		if not self:Paused() then
			if not GameObjectUtil.Instance:ObjectIsNULL(cameraController) then
				newEffect:Start(cameraController)
			end
		end
	end
end

function FunctionCameraEffect:TryGetCurrentEffect()
	return self.effect
end

function FunctionCameraEffect:Bussy()
	return nil ~= self.effect and self.effect:Bussy()
end

function FunctionCameraEffect:Start(effect)
	self:AddEffect(effect)
	return true
end

function FunctionCameraEffect:End(effect)
	self:RemoveEffect(effect)
end

function FunctionCameraEffect:Shutdown()
	self:ClearAllEffect()
end

function FunctionCameraEffect:GetCameraControllerDefaultInfo()
	if nil ~= Game.CameraPointManager.originalDefaultInfo then
		return Game.CameraPointManager.originalDefaultInfo;
	end
	if nil ~= CameraController.Me then
		return CameraController.Me.defaultInfo
	end
	return nil
end


