autoImport("WebView")
WebviewPanel = class("WebviewPanel",ContainerView)

WebviewPanel.ViewType = UIViewType.BoardLayer

--https://api.xd.com/v1/user/get_login_url?access_token=&redirect=https://rotr.xd.com

function WebviewPanel:Init()
	self:FindObjs()
	self:AddButtonEvt()
	self:AddCloseButtonEvent()
	self:SetData()
	self:ShowView()
end

function WebviewPanel:FindObjs()
	self.content = self:FindGO("Content")
	self.BG = self:FindGO("BG")
	self.backwardBtn = self:FindGO("Backward")
	self.forwardBtn = self:FindGO("Forward")
	self.refreshBtn = self:FindGO("Refresh")
	self.CloseButton = self:FindGO("CloseButton")

	self.Frame = self:FindGO("Frame")
	self.FrameWeb = self:FindGO("FrameWeb")
end

function WebviewPanel:AddButtonEvt()
	self:AddClickEvent(self.backwardBtn,function ()
		self:ClickBackwardBtn()
	end)

	self:AddClickEvent(self.forwardBtn,function ()
		self:ClickForwardBtn()
	end)

	self:AddClickEvent(self.refreshBtn,function ()
		self:ClickRefreshBtn()
	end)

end

function WebviewPanel:AddCloseButtonEvent()
	self:AddButtonEvent("CloseButton", function (go)
		self:HideView(true)
		self:CloseSelf();
	end);
end

function WebviewPanel:ClickBackwardBtn()
	ROWebView.Instance:GoBack()
end

function WebviewPanel:ClickForwardBtn()
	ROWebView.Instance:GoForward()
end

function WebviewPanel:ClickRefreshBtn()
	ROWebView.Instance:Reload()
end

function WebviewPanel:SetData()
	if self.viewdata and self.viewdata.viewdata then
		self.token = self.viewdata.viewdata.token
	end
end


function WebviewPanel:OnEnter()
end


function WebviewPanel:ShowView()
	
		local final =75* (Screen.height)/720
		local finalurl = string.format("https://api.xd.com/v1/user/get_login_url?access_token=%s&redirect=https://rotr.xd.com",self.token)
	


		if ROWebView.Instance.webView~=nil then
			helplog("在这一步把webview初始化")
		end	

		ROWebView.Instance.toolBarShow = false
		ROWebView.Instance:SetSavedInsets(final,0,0,0)

		if ApplicationInfo.IsIphoneX() then
			ROWebView.Instance:SetSavedInsets(40,35,20,35)
		end	


		Game.WWWRequestManager:SimpleRequest(finalurl,5,
		function (www)

			if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
				ROWebView.Instance:SetUserAgent("Android")
			elseif	ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
				ROWebView.Instance:SetUserAgent("iOS")
			end

			local content = www.text
			local jsonRequest = json.decode(content)
			
			if jsonRequest and jsonRequest.login_url then
				ROWebView.Instance.url = jsonRequest.login_url
				ROWebView.Instance:OpenButtonClicked() 
				ROWebView.Instance:SetInsets(final,0,0,0)
			else
				ROWebView.Instance.url = "https://rotr.xd.com"
				ROWebView.Instance:OpenButtonClicked() 
				ROWebView.Instance:SetInsets(final,0,0,0)
			end	
		end,
		function (www,error)

			if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
				ROWebView.Instance:SetUserAgent("Android")
			elseif	ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
				ROWebView.Instance:SetUserAgent("iOS")
			end

			ROWebView.Instance.url = "https://rotr.xd.com"
			ROWebView.Instance:OpenButtonClicked() 
			ROWebView.Instance:SetInsets(final,0,0,0)
		end,
		function (www)
			ROWebView.Instance.url = "https://rotr.xd.com"
			ROWebView.Instance:OpenButtonClicked() 
			ROWebView.Instance:SetInsets(final,0,0,0)
		end)

end

function WebviewPanel:HideView(fade)
	ROWebView.Instance:Hide(fade) 
end

function WebviewPanel:Clear()
	ROWebView.Instance:CleanCache() 
end
