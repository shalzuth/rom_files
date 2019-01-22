GOManager_Camera = class("GOManager_Camera")

GOManager_Camera.CameraID = {
	MainCamera = 1,
	SceneUICamera = 2,
	SceneUIBackgroundCamera = 3,
	Count = 3
}

local CameraID = GOManager_Camera.CameraID

local function ApplyVRMode(camera, enable, setSkybox)
	if nil ~= camera then
		local vrCamera = camera:GetComponent(VRCamera)
		if nil == vrCamera then
			if not enable then
				return
			end
			vrCamera = camera.gameObject:AddComponent(VRCamera)
		end
		vrCamera.leftCamera = camera
		vrCamera.enable = enable
		if enable and setSkybox then
			local rightCamera = vrCamera.rightCamera
			if nil ~= rightCamera then
				local leftSkybox = camera:GetComponent(Skybox)
				vrCamera.leftSkybox = leftSkybox
				if nil ~= leftSkybox then
					local rightSkybox = rightCamera:GetComponent(Skybox)
					if nil == rightSkybox then
						rightSkybox = rightCamera.gameObject:AddComponent(Skybox)
					end
					vrCamera.rightSkybox = rightSkybox
				end
			end
		end
	end
end

function GOManager_Camera:ctor()
	self.cameras = {}
	self.vrMode = false
end

function GOManager_Camera:Clear()
	for i=1, CameraID.Count do
		self:SetCamera(nil, i, (CameraID.SceneUIBackgroundCamera == i))
	end
end

function GOManager_Camera:SetVRMode(enable)
	if enable == self.vrMode then
		return
	end
	self.vrMode = enable
	for i=1, CameraID.Count do
		ApplyVRMode(self.cameras[i], enable, CameraID.SceneUIBackgroundCamera==i)
	end
end

function GOManager_Camera:DeterminMainCamera()
	local mainCamera = self.cameras[CameraID.MainCamera]
	if nil == mainCamera then
		mainCamera = Camera.main
		if nil ~= mainCamera then
			self:SetCamera(mainCamera, CameraID.MainCamera)
		end
	end

	Game.CullingObjectManager:SetCamera(mainCamera)
end

function GOManager_Camera:ClearMainCamera()
	local mainCamera = self.cameras[CameraID.MainCamera]
	self.cameras[CameraID.MainCamera] = nil
	Game.CullingObjectManager:ClearCamera(mainCamera)
end

function GOManager_Camera:GetCamera(ID)
	return self.cameras[ID]
end

function GOManager_Camera:SetCamera(camera, ID)
	self.cameras[ID] = camera

	local setSkybox = false
	if CameraID.SceneUIBackgroundCamera == ID then
		local material = nil
		if nil ~= camera then
			local skyboxRender = camera.gameObject:GetComponent(Skybox)
			Debug_AssertFormat(nil ~= skyboxRender, "SetSkyboxCamera({0}) no skybox render: {1}", camera, ID)
			Debug_AssertFormat(nil ~= skyboxRender.material, "SetSkyboxCamera({0}) no skybox material: {1}", camera, ID)
		
			material = skyboxRender.material
		end
		Game.EnviromentManager:SetSkyboxCamera(camera, material)

		setSkybox = true
	end

	ApplyVRMode(camera, self.vrMode, setSkybox)
end

function GOManager_Camera:ClearCamera(obj)
	local cameraID = obj.ID
	local camera = self.cameras[cameraID]
	if nil ~= camera and camera.gameObject == obj.gameObject then
		self:SetCamera(nil, cameraID)
		return true
	end
	return false
end

function GOManager_Camera:RegisterGameObject(obj)
	local objID = obj.ID
	Debug_AssertFormat((0 < objID and CameraID.Count >=objID), "RegisterLight({0}) invalid id: {1}", obj, objID)
	
	local camera = obj.gameObject:GetComponent(Camera)
	Debug_AssertFormat(nil ~= camera, "RegisterCamera({0}) no camera: {1}", obj, objID)
	
	self:SetCamera(camera, objID)

	return true
end

function GOManager_Camera:UnregisterGameObject(obj)
	if not self:ClearCamera(obj) then
		Debug_AssertFormat(false, "UnregisterCamera({0}) failed: {1}", obj, obj.ID)
		return false
	end

	return true
end

function GOManager_Camera:ActiveMainCamera(b)
	local main_cameraid = GOManager_Camera.CameraID.MainCamera;
	local camera = self.cameras[main_cameraid];
	if(camera ~= nil)then

		if(self.activiteLt)then
			self.activiteLt:cancel();
			self.activiteLt = nil;
		end

		local state = camera.enabled;
		if(state == b)then
			return;
		end

		if(not b)then
			-- Camera??????Activity false?????????OnGui???Event.current????????????????????????LayOut, ?????????????????????FadeOut
			self.activiteLt = LeanTween.delayedCall(2,function ()
					camera.enabled = false;
					self.activiteLt = nil;
				end);
		else
			camera.enabled = true;
		end
	end
end

function GOManager_Camera:CancelActiviteLt()
	if(self.activiteLt == nil)then
		return;
	end

end

