CSharpObjectForLogin = class('CSharpObjectForLogin')

CSharpObjectForLogin.ins = nil
function CSharpObjectForLogin:Ins()
	if CSharpObjectForLogin.ins == nil then
		CSharpObjectForLogin.ins = CSharpObjectForLogin.new()
	end
	return CSharpObjectForLogin
end

local goGameRoleReadyForLogin = nil
local transCamera = nil
local cameraController = nil

function CSharpObjectForLogin:Initialize(completeCallback)
	self:GetObjects()

	if ObjectsIsGetted then
		if completeCallback ~= nil then
			completeCallback()
		end
	else
		if self.tick == nil then
			self.tick = TimeTickManager.Me():CreateTick(0, 500, self.OnTick, self, 1)
		end
		self.completeCallback = completeCallback
	end
end

function CSharpObjectForLogin:GetCameraController()
	return cameraController
end

function CSharpObjectForLogin:GetTransCamera()
	return transCamera
end

function CSharpObjectForLogin:Release()
	transCamera = nil
	cameraController = nil

	GameObject.Destroy(goGameRoleReadyForLogin)
	goGameRoleReadyForLogin = nil
end

function CSharpObjectForLogin:Reset()
	self:Release()
end

function CSharpObjectForLogin:OnTick()
	self:GetObjects()

	if self:ObjectsIsGetted() then
		TimeTickManager.Me():ClearTick(self, 1)
		self.tick = nil

		if self.completeCallback ~= nil then
			self.completeCallback()
		end
	end
end

function CSharpObjectForLogin:GetObjects()
	goGameRoleReadyForLogin = GameObject.Find('GameRoleReadyForLogin(Clone)')
	if goGameRoleReadyForLogin ~= nil then
		transCamera = goGameRoleReadyForLogin.transform:Find('Camera')
		local transCameraController = goGameRoleReadyForLogin.transform:Find('CameraController')
		cameraController = transCameraController:GetComponent('CameraControllerForLoginScene')
	end
end

function CSharpObjectForLogin:ObjectsIsGetted()
	return goGameRoleReadyForLogin
end

function resetForLoginUnity()
	
end