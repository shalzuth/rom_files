local baseCell = autoImport("BaseCell")
WebCell = class("WebCell", baseCell)

function WebCell:ctor(viewObj)
	-- body
	self.gameObject = viewObj
	self:Init()
end

function WebCell:Init()
	-- body
	self.Btn = UIUtil.DirectFind("Btn",self.gameObject):GetComponent(UIEventListener)
	self.BtnToggle = UIUtil.DirectFind("Btn",self.gameObject):GetComponent(UIToggle)
	self.Label1 = UIUtil.DirectFind("Btn/DarkSprite/Label",self.gameObject):GetComponent(UILabel)
	self.Label2 = UIUtil.DirectFind("Btn/LightSprite/Label",self.gameObject):GetComponent(UILabel)
end

function WebCell:SetData(data)
	if not data then return end
	if not data.liveName or not data.url then return end
	self.data = data
	self.Label1.text = data.liveName
	self.Label2.text = data.liveName

	self.Btn.onClick = function (go)
		WebPanelProxy.Instance:ChooseWebCell(self.data.id)
	end
end

function WebCell:ShowView()
	-- print(self.data.id,self.data.liveName,self.data.url)
	if self.webView then
		self.webView:ShowToolBar(true)
		self.webView:Show()
		self.webView:Reload()
	else 
		-- print("WebCell.ShowView()",self.data.url)
		self.webView = WebView.new()
		self.webView:CreateView(self.gameObject,self:GetInsets())
		self.webView:ShowToolBar(true)
		self.webView:Show()
		self.webView:Load(self.data.url)
		print(self.webView:GetUserAgent())
	end
end

function WebCell:HideView(fade)
	if self.webView then 
		self.webView:ShowToolBar(false)
		self.webView:Hide(fade) 
	end
end

function WebCell:Clear()
	if self.webView then self.webView:ClearCache() end
end

function WebCell:SelectCell(id)
	if self.BtnToggle then
		if id and id == self.data.id then
			self:ShowView()
			self.BtnToggle:Set(true)
		else
			self:HideView(false) -- 如果有过度效果的话，会出现有空窗的BUG
			self.BtnToggle:Set(false)
		end
	end
end

function WebCell:GetInsets()
	local anchor = WebPanelProxy.Instance:GetAnchor()
	if not anchor then return end
	return WebViewConfig.new(nil,FSWebView.GetInsets(anchor))
end