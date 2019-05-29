TXWYPlatPanel = class("TXWYPlatPanel", BaseView)
TXWYPlatPanel.ViewType = UIViewType.PopUpLayer
function TXWYPlatPanel:Init()
  local server = FunctionLogin.Me():getCurServerData()
  local serverID = server ~= nil and server.serverid or 1
  local resVersion = VersionUpdateManager.CurrentVersion
  if resVersion == nil then
    resVersion = "Unknown"
  end
  local currentVersion = CompatibilityVersion.version
  local bundleVersion = GetAppBundleVersion.BundleVersion
  local version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
  self.logoutBtn = self:FindGO("Logout")
  self:AddClickEvent(self.logoutBtn, function(go)
    self:CloseSelf()
    FunctionSDK.Instance:EnterPlatform()
  end)
  self.serviceBtn = self:FindGO("ServiceBtn")
  local sTitle = self:FindGO("Title", self.serviceBtn):GetComponent(UILabel)
  sTitle.text = "\227\129\138\229\149\143\227\129\132\229\144\136\227\130\143\227\129\155"
  self:AddClickEvent(self.serviceBtn, function(go)
    OverseaHostHelper:OpenWebView("https://ragnarokm.gungho.jp/member/support")
  end)
  self.actBtn = self:FindGO("ActBtn")
  self:AddClickEvent(self.actBtn, function(go)
    OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/rules/terms.html")
  end)
  self.actBtn = self:FindGO("System")
  self:AddClickEvent(self.actBtn, function(go)
    OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/rm/privacy")
  end)
  self.accId = self:FindGO("AccID"):GetComponent(UILabel)
  local accid = OverseaHostHelper.accId
  self.accId.text = string.format(ZhString.ACCIDJP, accid)
  self.cpBtn = self:FindGO("Copy")
  self:AddClickEvent(self.cpBtn, function(go)
    ApplicationInfo.CopyToSystemClipboard(accid)
  end)
  self.userCenterBtn = self:FindGO("UserCenter")
  self:AddClickEvent(self.userCenterBtn, function(go)
    FunctionSDK.Instance:EnterUserCenter(serverID, "\230\156\170\231\153\187\229\133\165", version)
  end)
end
function TXWYPlatPanel:OnEnter()
  TXWYPlatPanel.super.OnEnter(self)
end
function TXWYPlatPanel:OnExit()
  TXWYPlatPanel.super.OnExit(self)
end
