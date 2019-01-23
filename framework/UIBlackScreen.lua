UIBlackScreen = class('UIBlackScreen')

function UIBlackScreen.Begin(originAlpha, targetAlpha, sp, duration, completeCallback)
	if sp ~= nil then
		sp.alpha = originAlpha
		local ta = TweenAlpha.Begin(sp.gameObject, duration, targetAlpha)
		if completeCallback ~= nil then
			ta:SetOnFinished(function ()
				completeCallback()
			end)
		end
	end
end

function UIBlackScreen.DoFadeIn(sp, duration, completeCallback)
	UIBlackScreen.Begin(0, 1, sp, duration, completeCallback)
end

function UIBlackScreen.DoFadeOut(sp, duration, completeCallback)
	UIBlackScreen.Begin(1, 0, sp, duration, completeCallback)
end

function UIBlackScreen.FadeIn(duration, completeCallback)
	local spMask = UIBlackScreen.GetMask()
	if spMask ~= nil then
		UIBlackScreen.DoFadeIn(spMask, duration, completeCallback)
	end
end

function UIBlackScreen.FadeOut(duration, completeCallback)
	local spMask = UIBlackScreen.GetMask()
	if spMask ~= nil then
		UIBlackScreen.DoFadeOut(spMask, duration, completeCallback)
	end
end

function UIBlackScreen.GetMask()
	local goUIRoot = GameObject.Find("UIRoot")
	if goUIRoot ~= nil then
		local transUICamera = goUIRoot.transform:Find("Camera")
		if transUICamera ~= nil then
			local transPanelOfMask = transUICamera:FindChild('PanelOfMask')
			if transPanelOfMask ~= nil then
				local transMask = transPanelOfMask:FindChild('Mask')
				if transMask ~= nil then
					local spMask = transMask:GetComponent('UISprite')
					return spMask
				end
			end
		end
	end
	return nil
end

function UIBlackScreen.SetAlpha(alpha)
	local spMask = UIBlackScreen.GetMask()
	if spMask ~= nil then
		spMask.alpha = alpha
	end
end

function UIBlackScreen.SetAlpha0()
	UIBlackScreen.SetAlpha(0)
end

function UIBlackScreen.SetAlpha1()
	UIBlackScreen.SetAlpha(1)
end