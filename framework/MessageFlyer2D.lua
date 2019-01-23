local baseCell = autoImport("BaseCell")
MessageFlyer2D = class("MessageFlyer2D", baseCell)
MessageFlyer2D.resID = ResourcePathHelper.UICell("MessageFlyer2D")

function MessageFlyer2D:ctor()
	
end

function MessageFlyer2D:AttachGO(parent)
	self.parent = parent
	self.gameObject = self:CreateObj(MessageFlyer2D.resID, parent)
	self.transform = self.gameObject.transform
end

function MessageFlyer2D:Initialize(str, color, speed, angleXZ, angleYZ)
	self.lab = self.gameObject:GetComponentInChildren("UILabel")
	self.lab.text = str
	self.lab.color = Color(color.r / 255, color.g / 255, color.b / 255, 1)
	self.lab.alpha = 0
	local ta = TweenAlpha.Begin(self.gameObject, 1, 1)

	self.speed = speed

	self.flyingMessageOffset = self.gameObject:GetComponent("FlyingMessageOffset2")
	self.flyingMessageOffset:Initialize(speed, angleXZ, angleYZ)
end

function MessageFlyer2D:Start()
	self.flyingMessageOffset:DoStart()
end

function MessageFlyer2D:Stop()
	self.flyingMessageOffset:DoStop()
end

function MessageFlyer2D:Reset()
	GameObject.Destroy(self.gameObject)
end

function MessageFlyer2D:ResetLab()
	self.lab.text = ""
end