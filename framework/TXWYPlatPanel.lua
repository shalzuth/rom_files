TXWYPlatPanel = class("TXWYPlatPanel",BaseView)
TXWYPlatPanel.ViewType = UIViewType.PopUpLayer

function TXWYPlatPanel:Init()

    local server = FunctionLogin.Me():getCurServerData()
    local serverID = (server ~= nil) and server.serverid or 1

    
    local resVersion = VersionUpdateManager.CurrentVersion
    if(resVersion==nil) then resVersion = "Unknown" end
    local currentVersion = CompatibilityVersion.version
    local bundleVersion = GetAppBundleVersion.BundleVersion
    local version = string.format("%s,%s,%s",resVersion,currentVersion,bundleVersion)

    self.logoutBtn = self:FindGO("Logout")
    self:AddClickEvent(self.logoutBtn, function (go)
        self:CloseSelf();
        FunctionSDK.Instance:EnterPlatform()
    end)

    self.serviceBtn = self:FindGO("ServiceBtn")
    self:AddClickEvent(self.serviceBtn, function (go)
        FunctionSDK.Instance:EnterBugReport(serverID,'未登入',version)
    end)

    self.actBtn = self:FindGO("ActBtn")
    self:AddClickEvent(self.actBtn, function (go)
        FunctionSDK.Instance:EnterUserCenter(serverID,'未登入',version)
    end)

    self.langBtn = self:FindGO("LangBtn")
    self:AddClickEvent(self.langBtn, function (go)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.LangSwitchPanel});
        self:CloseSelf();
    end)
    
end

function TXWYPlatPanel:OnEnter()
    TXWYPlatPanel.super.OnEnter(self);
end

function TXWYPlatPanel:OnExit()
    TXWYPlatPanel.super.OnExit(self);
end