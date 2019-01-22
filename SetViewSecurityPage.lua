SetViewSecurityPage = class("SetViewSecurityPage",SubView)
autoImport("LangSwitchPanel")
autoImport("SecurityPanel")
local resolutionLabTab = {}
local resolutionIndex = 1

SetViewSecurityPage.SecurityTable = Table_SecuritySetting
function SetViewSecurityPage:Init ()
    
    -- todo xde
     self:InitLanguageSet()
    
     self:AddEvts()
     self:initView()
     self:AddViewEvents()
     self:initData()
end

function SetViewSecurityPage:initView ()
    self.table = self:FindGO("Table"):GetComponent(UITable)
    local obj = self:FindGO("SecuritySetting")
    local Label = self:FindComponent("Label",UILabel,obj)
    Label.text = ZhString.SetViewSecurityPage_TabText

    self.gameObject = self:FindGO("SecurityPage")
    self.securityBtnGrid = self:FindComponent("securityBtnGrid",UIGrid)
    local securityEventTip = self:FindComponent("securityEventTip",UILabel)
    securityEventTip.text = ZhString.SetViewSecurityPage_SecurityEventTipText
    self.tipLabel = self:FindComponent("tipLabel",UILabel)
    self.tipLabel2 = self:FindComponent("tipLabel2",UILabel)
    
    -- self.tipLabel.text = ZhString.SetViewSecurityPage_TipLabelText
    self.securityEventContent = self:FindComponent("securityEventContent",UILabel)
    self.securityEventContent.text = ""

    self.securitySetBtnText = self:FindComponent("securitySetBtnText",UILabel)
    self.securityModifyBtn = self:FindGO("securityModifyBtn")

    self.showDetailToggleAll = self:FindGO("ShowDetailAll/ShowDetailToggleAll"):GetComponent("UIToggle")
    self.showDetailToggleFriend = self:FindGO("ShowDetailFriend/ShowDetailToggleFriend"):GetComponent("UIToggle")
    self.showDetailToggleClose = self:FindGO("ShowDetailClose/ShowDetailToggleClose"):GetComponent("UIToggle")

    self.weddingSet = self:FindGO("WeddingSet")
    self.showWeddingToggleAll = self:FindGO("ShowWeddingToggleAll"):GetComponent(UIToggle)
    self.showWeddingToggleFriend = self:FindGO("ShowWeddingToggleFriend"):GetComponent(UIToggle)
    self.showWeddingToggleClose = self:FindGO("ShowWeddingToggleClose"):GetComponent(UIToggle)

    local securityModifyBtnText = self:FindComponent("securityModifyBtnText",UILabel)
    securityModifyBtnText.text = ZhString.SetViewSecurityPage_SecurityModifyBtnText

    self.pushSet = self:FindGO("PushSet")
    self.pushToggle = {}
    self.pushToggle[0] = self:FindGO("PushPoringToggle"):GetComponent(UIToggle)
    self.pushToggle[1] = self:FindGO("PushGuildToggle"):GetComponent(UIToggle)
    self.pushToggle[2] = self:FindGO("PushAuctionToggle"):GetComponent(UIToggle)
    self.pushToggle[3] = self:FindGO("PushMonsterToggle"):GetComponent(UIToggle)
    self.pushToggle[4] = self:FindGO("PushBigCatToggle"):GetComponent(UIToggle)

    if GameConfig.SystemForbid.JPushForbid then
        self.PushAuction = self:FindGO("PushAuction")
        self.PushGuild= self:FindGO("PushGuild")
        self.PushPoring = self:FindGO("PushPoring")
        self.PushBigCat = self:FindGO("PushBigCat")
        self.PushMonster = self:FindGO("PushMonster")

        self.PushBigCat.gameObject.transform.localPosition = Vector3(10000,0,0)
        self.PushAuction.gameObject.transform.localPosition = Vector3(10000,0,0)
        self.PushGuild.gameObject.transform.localPosition = Vector3(10000,0,0)
        self.PushMonster.gameObject.transform.localPosition = Vector3(62.3,-79.4,0)
    end 

    self.switchedRoleName = self:FindComponent("SwitchedRoleName",UILabel)
end

-- todo xde
function SetViewSecurityPage:InitLanguageSet()
    self.langSet = self:FindGO("LanguageSet")
    self.langSet:SetActive(true)
    self.LanguageFilter = self:FindGO("LanguageFilter",self.langSet):GetComponent("UIPopupList")
    self.LanguageFilter:Clear()
    
    local lc = LangSwitchPanel:GetCurLanguageConf()
    self.LanguageFilter.value = lc.title

    -- ???????????????
    for _,v in pairs(LangSwitchPanel.NeedLanguage) do
        self.LanguageFilter:AddItem(v.title)
    end

    EventDelegate.Add(self.LanguageFilter.onChange, function()
        local selectValue = self.LanguageFilter.value
        if selectValue ~= LangSwitchPanel:GetCurLanguageConf().title then
            UIUtil.PopUpConfirmYesNoView(ZhString.NoticeTitle,
                string.format(ZhString.ChangeLangDes,OverSea.LangManager.Instance():GetLangByKey(selectValue)),function()
                    LangSwitchPanel:ReloadLanguage(LangSwitchPanel:GetCurLanguageKey(selectValue))
                end,function ()
                end,nil,ZhString.UniqueConfirmView_Confirm,ZhString.UniqueConfirmView_CanCel)
        end
    end)
end

function SetViewSecurityPage:AddViewEvents()
    self:AddButtonEvent("securitySetBtn",function ( )
        -- body
        if( not self.hasSet)then
            GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.SecurityPanel,viewdata = {ActionType = SecurityPanel.ActionType.Setting}})
        elseif(self.hasReSet)then
            MsgManager.ConfirmMsgByID(6008,function (  )
                -- body
                -- ??????
                ServiceAuthorizeProxy.Instance:CallResetAuthorizeUserCmd(false)
            end)
        else
            MsgManager.ConfirmMsgByID(6003,function (  )
                -- body
                 ServiceAuthorizeProxy.Instance:CallResetAuthorizeUserCmd(true)
            end)
        end
    end)

    self:AddClickEvent(self.securityModifyBtn,function (  )
        -- body
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.SecurityPanel,viewdata = {ActionType = SecurityPanel.ActionType.Modify}})
    end)

    for i=0,4 do
        --IPHONE???????????????????????????????????????????????????
        self:AddClickEvent(self.pushToggle[i].gameObject,function(obj)
            if(self.pushToggle[i].value) then
                if ExternalInterfaces.isUserNotificationEnable() then

                else
                    ExternalInterfaces.ShowHintOpenPushView (ZhString.Push_title,ZhString.Push_message,ZhString.Push_cancelButtonTitle,ZhString.Push_otherButtonTitles)
                end 
            else
                
            end
        end)
    end 
end

function SetViewSecurityPage:AddEvts()
    self:AddListenEvt(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd,self.HandleRecvAuthorizeInfo)
end

function SetViewSecurityPage:HandleRecvAuthorizeInfo ()
     self:SettingUI()
end

function SetViewSecurityPage:initData ()   
    local str = ""
    for k,v in pairs(SetViewSecurityPage.SecurityTable) do
        local desc = v.Desc
        desc = string.format(desc,v.param and v.param[1] or "")
        str = str..desc.."\n"
    end
    self.securityEventContent.text = str
end

function SetViewSecurityPage:SettingUI()
    TimeTickManager.Me():ClearTick(self)
    local tipText = ""
    local myself = FunctionSecurity.Me()
    local resetTime = myself.verifySecuriyResettime   
    self.hasSet = myself.verifySecuriyhasSet
    -- local sus = myself.verifySecuriySus

    -- self:Log(code,resetTime,sus)
    self.hasReSet = resetTime and resetTime ~= 0
    if( not self.hasSet)then
        self:Hide(self.securityModifyBtn)
        tipText = "[c][D91E1DFF]"..ZhString.SetViewSecurityPage_UnSet.."[-][/c]" --string.format(ZhString.SetViewSecurityPage_TipLabelText,"[c][D91E1DFF]"..ZhString.SetViewSecurityPage_UnSet.."[-][/c]")
         self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecuritySetBtnText
    else
        if(self.hasReSet)then
            self:Hide(self.securityModifyBtn)
            TimeTickManager.Me():CreateTick(0,1000,self.ChangetipText,self)
            self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecurityCancelBtnText
        else
            self:Show(self.securityModifyBtn)
            tipText = "[c][13C433FF]"..ZhString.SetViewSecurityPage_valiable.."[-][/c]" --string.format(ZhString.SetViewSecurityPage_TipLabelText,"[c][13C433FF]"..ZhString.SetViewSecurityPage_valiable.."[-][/c]")
             self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecurityResetBtnText
        end
    end
    self.tipLabel2.text = tipText

    self.securityBtnGrid:Reposition()
    self.switchedRoleName.text = Game.Myself.data.name

    local setting = FunctionPerformanceSetting.Me()

    local showDetail = setting:GetSetting().showDetail
    if showDetail == SettingEnum.ShowDetailFriend then
        self.showDetailToggleFriend.value = true
        self.showDetailToggleClose.value = false
        self.showDetailToggleAll.value = false
    elseif showDetail == SettingEnum.ShowDetailClose then
        self.showDetailToggleFriend.value = false
        self.showDetailToggleClose.value = true
        self.showDetailToggleAll.value = false
    else
        self.showDetailToggleFriend.value = false
        self.showDetailToggleClose.value = false
        self.showDetailToggleAll.value = true
    end

    if WeddingProxy.Instance:IsSelfSingle() then
        self.weddingSet:SetActive(false)
    else
        self.weddingSet:SetActive(true)

        local showWedding = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUERYWEDDINGTYPE) or 0
        if showWedding == SettingEnum.ShowWeddingFriend then
            self.showWeddingToggleFriend.value = true
        elseif showWedding == SettingEnum.ShowWeddingClose then
            self.showWeddingToggleClose.value = true
        else
            self.showWeddingToggleAll.value = true
        end
    end

    if BackwardCompatibilityUtil.CompatibilityMode_V19 then
        self.pushSet:SetActive(false)
    else
        self.pushSet:SetActive(false) --todo xde

        local push = setting:GetSetting().push
        for i=0,#self.pushToggle do
            self.pushToggle[i].value = self:GetBitByInt(push, i)
        end
    end

    if ExternalInterfaces.isUserNotificationEnable() then
        Debug.Log("?????????????????? ????????????")
    else
        if (ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android) then

        else
            for i=0,4 do
                Debug.Log("?????????????????? ????????????false")
                self.pushToggle[i].value = false
            end 
        end 

    end 

    self.table:Reposition()
end

function SetViewSecurityPage:ChangetipText ()
    local myself = FunctionSecurity.Me()
    local resetTime = myself.verifySecuriyResettime 

    local leftTime = resetTime - ServerTime.CurServerTime()/1000
    if(leftTime < 0)then
        ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(myself.verifySecuriyCode)
        leftTime = 0
        TimeTickManager.Me():ClearTick(self)
    end
    leftTime = math.floor(leftTime)

    local day = math.floor(leftTime / 3600/24)
    local hour = math.floor((leftTime-day*24*3600) / 3600)
    local m = math.floor((leftTime-day*24*3600 - hour * 3600) / 60)    

    local timeStr = string.format(ZhString.SetViewSecurityPage_SecurityResetTimeLeft,day,hour,m)
    -- local tipText = string.format(ZhString.SetViewSecurityPage_ResetPassDelay,timeStr)
    self.tipLabel2.text = timeStr
end

function SetViewSecurityPage:Exit () 
end

function SetViewSecurityPage:Save ()
    local showDetail = 0
    if self.showDetailToggleAll.value then
        showDetail = SettingEnum.ShowDetailAll
    elseif self.showDetailToggleFriend.value then
        showDetail = SettingEnum.ShowDetailFriend
    elseif self.showDetailToggleClose.value then
        showDetail = SettingEnum.ShowDetailClose
    end

    local showWedding = 0
    if self.showWeddingToggleAll.value then
        showWedding = SettingEnum.ShowWeddingAll
    elseif self.showWeddingToggleFriend.value then
        showWedding = SettingEnum.ShowWeddingFriend
    elseif self.showWeddingToggleClose.value then
        showWedding = SettingEnum.ShowWeddingClose
    end

    local setting = FunctionPerformanceSetting.Me()
    setting:SetBegin()
    setting:SetShowDetail(showDetail)
    setting:SetShowWedding(showWedding)
    setting:SetPush(self:SetPush())
    setting:SetEnd()
end

function SetViewSecurityPage:OnExit ()    
    TimeTickManager.Me():ClearTick(self)
end

function SetViewSecurityPage:SwitchOn ()
    self:SettingUI()
end

function SetViewSecurityPage:SwitchOff ()
    
end

function SetViewSecurityPage:SetPush()
    local push = 0

    for i=0,#self.pushToggle do
        push = self:GetIntByBit(push, i, not self.pushToggle[i].value)
    end

    return push
end

function SetViewSecurityPage:GetBitByInt(num, index)
    return ((num >> index) & 1) == 0
end

function SetViewSecurityPage:GetIntByBit(num, index, b)
    if b then
        num = num + (1<<index)
    end
    return num
end