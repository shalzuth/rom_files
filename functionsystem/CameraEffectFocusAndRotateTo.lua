
CameraEffectFocusAndRotateTo = class("CameraEffectFocusAndRotateTo", CameraEffectFocusTo)

function CameraEffectFocusAndRotateTo:ctor(focus, offset, viewPort, rotation, duration, listener)
	CameraEffectFocusAndRotateTo.super.ctor(self, focus, viewPort, duration, listener)
	self.offset = offset
	self.rotation = rotation
	self.unusedListener = function(cameraController)
	end
end

function CameraEffectFocusAndRotateTo:SetRotationOffset(offsetLuaVec3)
	self.rotationOffset = VectorUtility.Asign_3(self.rotationOffset, offsetLuaVec3)
end

-- override begin
function CameraEffectFocusAndRotateTo:DoStart(cameraController)
	CameraEffectFocusAndRotateTo.super.DoStart(self, cameraController)
	if nil ~= self.rotationOffset then
		self.rotation.x = self.rotation.x+self.rotationOffset[1]
		self.rotation.y = self.rotation.y+self.rotationOffset[2]
		self.rotation.z = self.rotation.z+self.rotationOffset[3]
	end
	cameraController:RotateTo(self.rotation, self.duration, self.unusedListener)
end

function CameraEffectFocusAndRotateTo:DoEnd(cameraController)
	CameraEffectFocusAndRotateTo.super.DoEnd(self, cameraController)
	self.rotationOffset = VectorUtility.Destroy(self.rotationOffset)
end
-- override end