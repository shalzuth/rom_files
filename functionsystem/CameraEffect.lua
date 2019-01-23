
CameraEffect = class("CameraEffect")

function CameraEffect:ctor()
	self:Reset()
end

function CameraEffect:Reset()
	self:ResetCameraController(nil)
end

function CameraEffect:ResetCameraController(newCameraController)
	local oldCameraController = self.cameraController
	if oldCameraController == newCameraController then
		return
	end
	self.cameraController = newCameraController

	if nil ~= oldCameraController and not GameObjectUtil.Instance:ObjectIsNULL(oldCameraController) then
		self:DoEnd(oldCameraController)
		oldCameraController.beSingleton = true
	end

	if nil ~= newCameraController then
		self:DoStart(newCameraController)
		newCameraController.beSingleton = false
	end
end

function CameraEffect:Bussy()
	return nil ~= self.cameraController and not GameObjectUtil.Instance:ObjectIsNULL(self.cameraController)
end

function CameraEffect:Start(cameraController)
	self:ResetCameraController(cameraController)
end

function CameraEffect:End()
	self:Reset()
end

function CameraEffect:DoStart(cameraController)
	
end

function CameraEffect:DoEnd(cameraController)
	
end

