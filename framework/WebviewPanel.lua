autoImport("WebView")
WebviewPanel = class("WebviewPanel", ContainerView)
WebviewPanel.ViewType = UIViewType.BoardLayer
function WebviewPanel:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddCloseButtonEvent()
  self:SetData()
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
  self:AddClickEvent(self.backwardBtn, function()
    self:ClickBackwardBtn()
  end)
  self:AddClickEvent(self.forwardBtn, function()
    self:ClickForwardBtn()
  end)
  self:AddClickEvent(self.refreshBtn, function()
    self:ClickRefreshBtn()
  end)
end
function WebviewPanel:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    self:HideView(true)
    self:CloseSelf()
  end)
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
    self.directurl = self.viewdata.viewdata.directurl
  end
end
function WebviewPanel:OnEnter()
  self:ShowView()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    self:HideView(true)
    self:CloseSelf()
  end)
  self:ClickRefreshBtn()
end
function WebviewPanel:OnExit()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    if UIManagerProxy.Instance:GetModalPopCount() > 0 then
      helplog("close")
      UIManagerProxy.Instance:PopView()
    else
      MsgManager.ConfirmMsgByID(27000, function()
        Application.Quit()
      end, function()
      end, nil, nil)
    end
  end)
end
function WebviewPanel:ShowView()
  if ApplicationInfo.IsWindows() then
    self.BG.gameObject:SetActive(false)
  end
  local final = Screen.height / 10
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    final = final / 2
  end
  local finalurl = string.format("https://api.xd.com/v1/user/get_login_url?access_token=%s&redirect=https://rotr.xd.com", self.token)
  if ROWebView.Instance.webView ~= nil then
    helplog("\229\156\168\232\191\153\228\184\128\230\173\165\230\138\138webview\229\136\157\229\167\139\229\140\150")
  end
  ROWebView.Instance.toolBarShow = false
  ROWebView.Instance:SetSavedInsets(final, 0, 0, 0)
  UIManagerProxy.Instance:DoMobileScreenAdaptionOfViewCtl(self, function(key, data)
    if key == "SavedInsets" and type(data) == "table" and #data >= 4 then
      ROWebView.Instance:SetSavedInsets(data[1], data[2], data[3], data[4])
    end
  end)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
  elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    ROWebView.Instance:SetUserAgent("Mozilla/5.0 (iPhone) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 ro uniwebview")
  end
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    final = Screen.height / 30
  end
  if self.directurl then
    if ApplicationInfo.IsWindows() then
    else
      ROWebView.Instance.url = self.directurl
      ROWebView.Instance:OpenButtonClicked()
      ROWebView.Instance:SetInsets(final, 0, 0, 0)
    end
    self.directurl = nil
  else
    Game.WWWRequestManager:SimpleRequest(finalurl, 5, function(www)
      local content = www.text
      local jsonRequest = json.decode(content)
      if jsonRequest and jsonRequest.login_url then
        if ApplicationInfo.IsWindows() then
        else
          ROWebView.Instance.url = jsonRequest.login_url
          ROWebView.Instance:OpenButtonClicked()
          ROWebView.Instance:SetInsets(final, 0, 0, 0)
        end
      elseif ApplicationInfo.IsWindows() then
      else
        ROWebView.Instance.url = "https://rotr.xd.com"
        ROWebView.Instance:OpenButtonClicked()
        ROWebView.Instance:SetInsets(final, 0, 0, 0)
      end
    end, function(www, error)
      if ApplicationInfo.IsWindows() then
      else
        helplog("wrong www")
        ROWebView.Instance.url = "https://rotr.xd.com"
        ROWebView.Instance:OpenButtonClicked()
        ROWebView.Instance:SetInsets(final, 0, 0, 0)
      end
    end, function(www)
      if ApplicationInfo.IsWindows() then
      else
        ROWebView.Instance.url = "https://rotr.xd.com"
        ROWebView.Instance:OpenButtonClicked()
        ROWebView.Instance:SetInsets(final, 0, 0, 0)
      end
    end)
  end
end
function WebviewPanel:HideView(fade)
  ROWebView.Instance:Hide(fade)
end
function WebviewPanel:Clear()
  ROWebView.Instance:CleanCache()
end
