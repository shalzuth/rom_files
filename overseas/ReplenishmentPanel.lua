autoImport("ReplenishCell");
ReplenishmentPanel = class("ReplenishmentPanel",ContainerView)
ReplenishmentPanel.ViewType = UIViewType.PopUpLayer


function ReplenishmentPanel:Init()
    
    EventManager.Me():AddEventListener("replenisPaySuccess",self.refreshList, self)

    local warning = self:FindGO("warning")
    self:AddClickEvent(warning, function (go)
        local server = FunctionLogin.Me():getCurServerData()
        local serverID = (server ~= nil) and server.serverid or 1

        local resVersion = VersionUpdateManager.CurrentVersion
        if(resVersion==nil) then resVersion = "Unknown" end
        local currentVersion = CompatibilityVersion.version
        local bundleVersion = GetAppBundleVersion.BundleVersion
        local version = string.format("%s,%s,%s",resVersion,currentVersion,bundleVersion)
        FunctionSDK.Instance:EnterUserCenter(serverID,'未登入',version)
    end)
    self.datas = self.viewdata.viewdata
    self:resetData()
end

function ReplenishmentPanel:refreshList(data)
    helplog("ReplenishmentPanel:refreshList",data.data)
    for i=1,#self.datas do
        if self.datas[i].orderid == data.data then
            self.datas[i].status = 1
        end
    end
    self:resetData()
end

function ReplenishmentPanel:OnExit()
    EventManager.Me():RemoveEventListener("replenisPaySuccess", self.refreshList, self)
end

function ReplenishmentPanel:resetData()
    if(self.replenish == nil)then
        local scrollViewObj = self:FindGO("ScrollView");
        self.scrollView = scrollViewObj:GetComponent(UIScrollView);
        local giftsGrid = self:FindGO("Grid", scrollViewObj):GetComponent(UIGrid);
        self.replenish = UIGridListCtrl.new(giftsGrid, ReplenishCell, "ReplenishCell");
    end

    table.sort(self.datas,function(l,r)
        return l.status < r.status
    end)

    for i=1,#self.datas do
        self.datas[i].id = i
    end

    self.replenish:ResetDatas(self.datas);
    self.scrollView:ResetPosition();
end



