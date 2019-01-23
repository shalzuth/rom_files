local baseCell = autoImport("BaseCell")
MessageFlyer3dTo2d = class("MessageFlyer3dTo2d", baseCell)
MessageFlyer3dTo2d.resID = ResourcePathHelper.UICell("MessageFlyer2D")

function MessageFlyer3dTo2d:ctor()
	self.jobPos = 0
end

function MessageFlyer3dTo2d:AttachGO(parent)
	self.parent = parent
	self.gameObject = self:CreateObj(MessageFlyer3dTo2d.resID, parent)
	self.transform = self.gameObject.transform
end

function MessageFlyer3dTo2d:Initialize(str, color, speed, pos)
	self.speed = speed
	self.lab = self.gameObject:GetComponentInChildren("UILabel")
	self.lab.text = str
	self.lab.color = Color(color.r / 255, color.g / 255, color.b / 255, 1)
	self.lab.alpha = 0
	TweenAlpha.Begin(self.gameObject, 1, 1)
	if self.idFlyingInfo then
		FMEmission.ins.posSimulation:ResetFI(self.idFlyingInfo, Vector3(pos.x, pos.y, pos.z), speed)
		FMEmission.ins.posSimulation:InitializeFI(self.idFlyingInfo)
	else
		self:RegisterPosSimulation(pos, speed)
	end
end

function MessageFlyer3dTo2d:Start()
	FMEmission.ins.posSimulation:StartFI(self.idFlyingInfo)
end

function MessageFlyer3dTo2d:Stop()
	FMEmission.ins.posSimulation:StopFI(self.idFlyingInfo)
end

function MessageFlyer3dTo2d:Reset()
	GameObject.Destroy(self.gameObject)
end

function MessageFlyer3dTo2d:ResetLab()
	self.lab.text = ""
end

function MessageFlyer3dTo2d:RegisterPosSimulation(pos, speed)
	self.idFlyingInfo = FMEmission.Ins().posSimulation:Register(Vector3(pos.x, pos.y, pos.z), speed, false, function ( currentPos, angleSum )
		local mainCamera = FMEmission.Ins().transMainCamera.gameObject:GetComponent("Camera")
		local viewPort = mainCamera:WorldToViewportPoint(Vector3(currentPos.x, currentPos.y, currentPos.z))
		self.lab.enabled = viewPort.z > 0
		if viewPort.z > 0 then
			if angleSum > 360 then
				self:Stop()
				local ta = TweenAlpha.Begin(self.gameObject, 1, 0)
				EventDelegate.Set(ta.onFinished, function ()
					if ta.value == 0 then
						self:ResetLab()

						FMEmission.ins:RemoveFromFlyersOnJob(self.jobPos)
						FMEmission.ins:BackBerth(self)
						local berthFlyerCount = FMEmission.ins.flyerCount
						berthFlyerCount = berthFlyerCount + 1
						FMEmission.ins.flyerCount = berthFlyerCount
						FMEmission.ins:QueueLaunch()
					end
				end)
			else
				local uiWidth = 1280
				local uiHeight = Screen.height * uiWidth / Screen.width
				local screenPosRaw = Vector3(uiWidth * viewPort.x, uiHeight * viewPort.y, 0)
				local screenPos = Vector3(screenPosRaw.x - uiWidth / 2, screenPosRaw.y - uiHeight  / 2, 0)
				self.transform.localPosition = screenPos
			end
		end
		local zAngleMainCamera = FMEmission.Ins().transMainCamera.rotation.eulerAngles.z
		local selfQuaternion = self.transform.localRotation
		local selfEulerAngles = selfQuaternion.eulerAngles
		selfEulerAngles.z = -zAngleMainCamera
		selfQuaternion.eulerAngles = selfEulerAngles
		self.transform.localRotation = selfQuaternion
	end)
end