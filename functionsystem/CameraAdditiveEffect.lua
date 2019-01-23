CameraAdditiveEffect = class("CameraAdditiveEffect")

CameraAdditiveEffect.Type = {
	POSITION_OFFSET = 1
}

function CameraAdditiveEffect:ctor()
	self:Reset()
end

function CameraAdditiveEffect:Reset()
	self:ResetCameraController(nil)
	self.running = false
end

function CameraAdditiveEffect:ResetCameraController(newCameraController)
	local oldCameraController = self.cameraController
	if oldCameraController == newCameraController then
		return
	end

	self.cameraController = newCameraController

	self:OnCameraControllerChanged(oldCameraController, newCameraController)
end

function CameraAdditiveEffect:Launch(cameraController)
	if self.running then
		return
	end

	self.running = true
	self:ResetCameraController(cameraController)
	self:OnStart()
end

function CameraAdditiveEffect:Shutdown()
	if not self.running then
		return
	end

	self:OnEnd()
	self:Reset()
end

function CameraAdditiveEffect:OnStart()
end

function CameraAdditiveEffect:OnEnd()
end

function CameraAdditiveEffect:OnCameraControllerChanged(oldCameraController, newCameraController)
end

