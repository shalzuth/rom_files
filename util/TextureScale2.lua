TextureScale2 = class('TextureScale2')

local _goTextureScale = nil
local _camera = nil
local _uiTexture = nil
local _screenShotHelper = nil
function TextureScale2.Get(texture2D, coefficient, complete_callback)
	if _goTextureScale == nil then
		_goTextureScale = GameObject.Find('TextureScale')
		_screenShotHelper = _goTextureScale:GetComponent(ScreenShotHelper)
		local transCamera = _goTextureScale.transform:Find('Camera')
		_camera = transCamera:GetComponent(Camera)
		_camera.hideFlags = HideFlags.HideAndDontSave
		_camera.enabled = false
		local transUITexture = _goTextureScale.transform:Find('Texture')
		_uiTexture = transUITexture:GetComponent(UITexture)
	end

	local texWidth = texture2D.width
	local texHeight = texture2D.height
	local coefficient = 0.25
	local newTexWidth = texWidth * coefficient
	local newTexHeight = texHeight * coefficient
	local ratio = newTexWidth / newTexHeight
	_camera.aspect = ratio

	_uiTexture.mainTexture = texture2D
	_uiTexture.height = _camera.pixelHeight
	_uiTexture.width = math.floor(_uiTexture.height * ratio)

	_screenShotHelper:Setting(newTexWidth, newTexHeight, TextureFormat.RGB24, 24, ScreenShot.AntiAliasing.None)
	_screenShotHelper:GetScreenShot(function (x)
		_uiTexture.mainTexture = nil

		if complete_callback ~= nil then
			complete_callback(x)
		end
	end, _camera)
end