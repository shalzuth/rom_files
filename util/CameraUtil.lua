CameraUtil = {}

function CameraUtil.SetCameraFitHeight(camera, aspect)
	local screenAspect = Screen.height / Screen.width
	if screenAspect <= aspect then
		return
	end
	local heightScale = aspect * (1/screenAspect)
	camera.rect = Rect(0,(1-heightScale)/2,1,heightScale)
end

function CameraUtil.SetAllCameraFitHeight(aspect)
	local camerasCount = Camera.allCamerasCount
	if 0 < camerasCount then
		local cameras = Camera.allCameras
		for i=1, camerasCount do
			CameraUtil.SetCameraFitHeight(cameras[i], aspect)
		end
	end
end

function CameraUtil.ReSetAllCameraViewPort()
	local camerasCount = Camera.allCamerasCount
	if 0 < camerasCount then
		local cameras = Camera.allCameras
		for i=1, camerasCount do
			cameras[i].rect = Rect(0,0,1,1)
		end
	end
end