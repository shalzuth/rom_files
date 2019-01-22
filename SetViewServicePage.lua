SetViewServicePage = class("SetViewServicePage",SubView)

function SetViewServicePage:Init ()
    
    self.conditionBtn = self:FindGO("condition")
    self:AddClickEvent(self.conditionBtn, function (go)
        Application.OpenURL("https://www.ragnaroketernallove.com/introduction/service.html");
    end)


    self.policyBtn = self:FindGO("policy")
    self:AddClickEvent(self.policyBtn, function (go)
        Application.OpenURL("https://www.ragnaroketernallove.com/introduction/privacy.html");
    end)

    self.serviceBtn = self:FindGO("service")
    self:AddClickEvent(self.serviceBtn, function (go)
        local resVersion = VersionUpdateManager.CurrentVersion
        if(resVersion==nil) then resVersion = "Unknown" end
        local currentVersion = CompatibilityVersion.version
        local bundleVersion = GetAppBundleVersion.BundleVersion
        local version = string.format("%s,%s,%s",resVersion,currentVersion,bundleVersion)
        local server = FunctionLogin.Me():getCurServerData()
        local serverID = (server ~= nil) and server.serverid or 1
        ----[[ todo xde SDK bugReport ???????????????
        local playerName = "?????????"
        if Game ~= nil and Game.Myself ~=nil then
            playerName = Game.Myself.data:GetName()
        end
        lineName = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
        xdlog(playerName, lineName)
        playerName = playerName .. ' | ' .. lineName
        --]]
        FunctionSDK.Instance:EnterBugReport(serverID, playerName, version)
    end)


    --???http://member.gnjoy.com/mobile/inquiry/rom

    self.notiToggle = self:FindGO("noticeTog"):GetComponent("UIToggle")
    self.notiToggle.value = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
end

function SetViewServicePage:SwitchOn() 
end

function SetViewServicePage:SwitchOff()
end

function SetViewServicePage:Exit()
end

function SetViewServicePage:Save()
    helplog("save")
    helplog(self.notiToggle.value)
    OverSeas_TW.OverSeasManager.GetInstance():SetNotification(self.notiToggle.value)
end