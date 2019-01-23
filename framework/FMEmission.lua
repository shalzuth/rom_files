autoImport("MessageFlyer3dTo2d")

FMEmission = class("FMEmission")

FMEmission.ViewType = UIViewType.NormalLayer;

FMEmission.ins = nil
function FMEmission.Ins()
	if (FMEmission.ins == nil) then
		FMEmission.ins = FMEmission.new()
	end
	return FMEmission.ins
end

function FMEmission:ctor()
	
end

function FMEmission:AttachGO(go)
	self.gameObject = go
end

function FMEmission:Init()
	if (GameObjectUtil.Instance:ObjectIsNULL(self.transFlyerRoot)) then
		self.transFlyerRoot = GameObject.Find("MessageFlyerRoot").transform
	end
	if (GameObjectUtil.Instance:ObjectIsNULL(self.transPosSimulation)) then
		self.transPosSimulation = GameObjectUtil.Instance:DeepFind(self.gameObject, "PosSimulation").transform
	end
	if self.posSimulation == nil then
		self.posSimulation = self.transPosSimulation:GetComponent("FMPosSimulation")
	end

	if self.flyersOnJob == nil then
		self.flyersOnJob = {}
	end
	if self.flyerBerth == nil then
		self.flyerBerth = {}
	end
	if (self.queue == nil) then
		self.queue = {}
	end
	self.flyerCount = 50

	self.isRuning = false

	if self.transMainCamera == nil then
		self.transMainCamera = GameObject.FindGameObjectWithTag("MainCamera").transform
	end
end

function FMEmission:Launch(str, color, pos)
	if (self.flyerCount > 0) then
		local mf = nil
		local isFromBerth = false
		if #self.flyerBerth > 0 then
			mf = self.flyerBerth[1]
			isFromBerth = true
		else
			mf = MessageFlyer3dTo2d.new()
			mf:AttachGO(self.transFlyerRoot.gameObject)
		end

		if (GameObjectUtil.Instance:ObjectIsNULL(mf.gameObject)) then
			mf:AttachGO(self.transFlyerRoot.gameObject)
		end

		local speed = math.random(5, 20)
		mf:Initialize(str, color, speed, pos)
		mf:Start()
		if isFromBerth then
			table.remove(self.flyerBerth, 1)
		end
		local pos = self:AddIntoFlyersOnJob(mf)
		mf.jobPos = pos

		self.flyerCount = self.flyerCount - 1
	else
		table.insert(self.queue, {str = str, color = color, pos = pos})
	end
end

function FMEmission:Open()
	if (not self:IsPronteraSouthGate()) then return end

	if (self.isRuning) then return end

	self.isRuning = true
	self.gameObject:SetActive(true)
end

function FMEmission:Close()
	if (not self:IsPronteraSouthGate()) then return end

	if (not self.isRuning) then return end

	self.isRuning = false

	while #self.flyersOnJob > 0 do
		local flyer = self.flyersOnJob[1]
		flyer:Stop()
		flyer:ResetLab()
		table.remove(self.flyersOnJob, 1)
		self:BackBerth(flyer)
	end

	self.gameObject:SetActive(false)

	EventManager.Me():RemoveEventListener(ServiceEvent.NUserUserBarrageMsgCmd, self.OnReceiveFlyingMessage, self)
end

function FMEmission:AngleOfSend()
	local transMainCamera = GameObject.FindGameObjectsWithTag("MainCamera")[1].transform
	local eulerY = transMainCamera.rotation.eulerAngles.y;
	eulerY = eulerY + 45
	if eulerY > 360 then
		eulerY = eulerY - 360
	end
	return eulerY
end

function FMEmission:Reset()
	self:Close()
	Component.Destroy(self.posSimulation)
	self.posSimulation = nil
end

function FMEmission:PosOfSend()
	local quaternion = self.transMainCamera.rotation
	local tempRotation = quaternion.eulerAngles
	local oldXRotation = tempRotation.x
	tempRotation.x = 0
	quaternion.eulerAngles = tempRotation
	self.transMainCamera.rotation = quaternion

	local pos = self.transMainCamera:TransformPoint(Vector3(0, math.random(2000, 5000), 10000))

	tempRotation.x = oldXRotation
	quaternion.eulerAngles = tempRotation
	self.transMainCamera.rotation = quaternion
	return pos
end

function FMEmission:IsPronteraSouthGate()
	return Game.MapManager:GetMapID() == 2
end

function FMEmission:QueueLaunch()
	if self.queue ~= nil and #self.queue > 0 then
		local waitingMan = self.queue[1]
		table.remove(self.queue, 1)
		local str = waitingMan.str
		local color = waitingMan.color
		local pos = waitingMan.pos
		self:Launch(str, color, pos)
	end
end

function FMEmission:BackBerth(mf)
	if mf ~= nil then
		if self.flyerBerth == nil then
			self.flyerBerth = {}
		end
		table.insert(self.flyerBerth, mf)
	end
end

function FMEmission:AddIntoFlyersOnJob(mf)
	if mf == nil then return end
	if self.flyersOnJob == nil then
		self.flyersOnJob = {}
	end
	table.insert(self.flyersOnJob, mf)
	return #self.flyersOnJob
end

function FMEmission:RemoveFromFlyersOnJob(pos)
	if self.flyersOnJob ~= nil then
		table.remove(self.flyersOnJob, pos)
	end
end