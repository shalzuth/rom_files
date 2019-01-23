
CameraEffectFaceTo = class("CameraEffectFaceTo", CameraEffectFocusAndRotateTo)

function CameraEffectFaceTo:CalcCameraRotation(cameraController)
	local gameObjectUtil = GameObjectUtil.Instance
	if not gameObjectUtil:ObjectIsNULL(cameraController) and not gameObjectUtil:ObjectIsNULL(self.focus) then
		local angle = self.focus.rotation.eulerAngles
		local y = angle.y+180
		local y = y- math.floor(y / 360) * 360
		local newAngle = cameraController.cameraRotationEuler
		
		newAngle.y = y
		if nil ~= self.rotation then
			newAngle.x = self.rotation.x
			newAngle.z = self.rotation.z
		end

		return newAngle
	end
	return nil
end

-- override begin
function CameraEffectFaceTo:DoStart(cameraController)
	self.rotation = self:CalcCameraRotation(cameraController)
	CameraEffectFaceTo.super.DoStart(self, cameraController)

	-- TimeTickManager.Me():CreateTick(100, 100, function(timerOwner, deltaTime)
	-- 	local rotation = self:CalcCameraRotation(cameraController)
	-- 	if nil ~= rotation then
	-- 		cameraController:RotateTo(rotation)
	-- 	end
	-- end, self)
end

function CameraEffectFaceTo:DoEnd(cameraController)
	CameraEffectFaceTo.super.DoEnd(self, cameraController)
	-- TimeTickManager.Me():ClearTick(self)
end
-- override end