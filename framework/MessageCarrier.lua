local baseCell = autoImport("BaseCell")
MessageCarrier = class("MessageCarrier", baseCell)
MessageCarrier.resID = ResourcePathHelper.UICell("MessageCarrier")

function MessageCarrier:ctor()
	
end

function MessageCarrier:Initialize(str, rotationTime)
	print("FUN >>> MessageCarrier:Initialize")
	self.lab = self:FindGO("Label"):GetComponent("UILabel")
	self.lab.text = str
	self.rotationTime = rotationTime
	self.deltaRotationTime = 0

	TimeTickManager.Me():ClearTick(self)
	self.deltaTime = 10
	TimeTickManager.Me():CreateTick(0, self.deltaTime, self.OnUpdate, self, 1002, true)
	self.switch = false
end

function MessageCarrier:Start()
	
end

function MessageCarrier:AttachGO(parent)
	self.gameObject = self:CreateObj(MessageCarrier.resID, parent)
	self.transform = self.gameObject.transform
	self.transform.localPosition = Vector3(0, 10000, 0)
end

function MessageCarrier:ByFlyer(flyerGO, flyer)
	self.flyerGO = flyerGO
	self.flyer = flyer
end

function MessageCarrier:UnbyFlyer()
	local anchor = self.gameObject:GetComponent(UIAnchor)
	anchor.container = nil
end

function MessageCarrier:OnUpdate(deltaTime)
	if (self.switch) then
		if (self.flyerGO ~= nil) then
			self.transform.position = self.flyerGO.transform.position
		end

		self.deltaRotationTime = self.deltaRotationTime + deltaTime
		if (self.deltaRotationTime >= self.rotationTime) then
			self.lab.text = ""
		end
	end
end

function MessageCarrier:Fly()
	print("FUN >>> MessageCarrier:Fly")
	self.flyer:Start()
	self.switch = true
end

function MessageCarrier:StopFly()
	self.flyer:Stop()
	self.switch = false
end

function MessageCarrier:Reset()
	self:ResetLab()
	TimeTickManager.Me():ClearTick(self)
	GameObject.Destroy(self.gameObject)
end

function MessageCarrier:ResetLab()
	self.lab.text = ""
end