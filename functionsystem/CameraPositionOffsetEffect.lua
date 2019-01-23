CameraPositionOffsetEffect = class("CameraPositionOffsetEffect", CameraAdditiveEffect)

function CameraPositionOffsetEffect:Apply(offset)
	if not GameObjectUtil.Instance:ObjectIsNULL(self.cameraController) then
		self.cameraController.positionOffset = offset
	end
end

function CameraPositionOffsetEffect:OnCameraControllerChanged(oldCameraController, newCameraController)
	if nil ~= oldCameraController and not GameObjectUtil.Instance:ObjectIsNULL(oldCameraController) then
		oldCameraController.positionOffset = self.originOffset
	end

	if nil ~= newCameraController and not GameObjectUtil.Instance:ObjectIsNULL(newCameraController) then
		self.originOffset = newCameraController.positionOffset
	end
end