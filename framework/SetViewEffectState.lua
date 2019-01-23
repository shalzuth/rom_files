SetViewEffectState = class("SetViewEffectState",SubView)

local resolutionLabTab = {}
local resolutionIndex = 1

function SetViewEffectState:Init ()
     self:FindObj()
     self:AddEvts()
     self:Show()
    
    --todo xde
    local label = self:FindGO("Label",self.ShowOtherCharToggle.gameObject):GetComponent(UILabel)
    OverseaHostHelper:FixLabelOverV1(label,3,170)
end

function SetViewEffectState:FindObj ()
    if self:FindGO("OutlineSet/OutlineToggle") then
        self.outlineToggle = self:FindGO("OutlineSet/OutlineToggle"):GetComponent("UIToggle")
        self.effectToggle = self:FindGO("EffectSet/EffectToggle"):GetComponent("UIToggle")
        self.toonLightToggle = self:FindGO("ToonLightSet/ToonLightToggle"):GetComponent("UIToggle")
        self.slimToggle = self:FindGO("SlimToggle"):GetComponent("UIToggle")
        self.selfPeakToggle = self:FindGO("SelfPeakToggle"):GetComponent("UIToggle")
        self.otherPeakToggle = self:FindGO("OtherPeakToggle"):GetComponent("UIToggle")
        self.screenCountToggleLow = self:FindGO("ScreenCountToggleLow"):GetComponent("UIToggle")
    	self.screenCountToggleMid = self:FindGO("ScreenCountToggleMid"):GetComponent("UIToggle")
    	self.screenCountToggleHigh = self:FindGO("ScreenCountToggleHigh"):GetComponent("UIToggle")
        self.ShowOtherNameToggle = self:FindGO("ShowOtherNameToggle"):GetComponent("UIToggle")
        self.ShowOtherCharToggle = self:FindGO("ShowOtherCharToggle"):GetComponent("UIToggle")
        self.ResolutionFilter = self:FindGO("ResolutionFilter"):GetComponent("UIPopupList")

        self.showExterior = {}
        self.showExterior[0] = self:FindGO("ShowExteriorHeadToggle"):GetComponent("UIToggle")
        self.showExterior[1] = self:FindGO("ShowExteriorBackToggle"):GetComponent("UIToggle")
        self.showExterior[2] = self:FindGO("ShowExteriorFaceToggle"):GetComponent("UIToggle")
        self.showExterior[3] = self:FindGO("ShowExteriorTailToggle"):GetComponent("UIToggle")
        self.showExterior[4] = self:FindGO("ShowExteriorMouthToggle"):GetComponent("UIToggle")

        self.SavingMode = self:FindGO("SavingMode")
        self.SavingModeToggle = self:FindGO("SavingMode/SavingModeToggle"):GetComponent("UIToggle")
    end
end

function SetViewEffectState:AddEvts()
    EventDelegate.Add(self.ResolutionFilter.onChange, function()
        if(ApplicationInfo.IsRunOnWindowns())then
            local setting = FunctionPerformanceSetting.Me()
            local saveIndex = setting:GetSetting().resolution;
            local nowIndex = resolutionLabTab[self.ResolutionFilter.value];
            if(saveIndex == nowIndex)then
                return;
            end
            local resolution = Game.ScreenResolutions[nowIndex];
            helplog(resolution[1], resolution[2], nowIndex);
            Screen.SetResolution(resolution[1], resolution[2], index == 1);
            setting:SetResolution(nowIndex);
            resolutionIndex = nowIndex;
        else
            resolutionIndex = resolutionLabTab[self.ResolutionFilter.value]
        end
    end)

end

function SetViewEffectState:SettingUI()

    if self.ResolutionFilter then
        self.ResolutionFilter:Clear()
        resolutionLabTab = {}
        local tab = Game.GetResolutionNames()
        for i=1,#tab do
            local str = tab[i]
            self.ResolutionFilter:AddItem(str)
            resolutionLabTab[str] = i
        end

        local setting = FunctionPerformanceSetting.Me()
        local screenCount = setting:GetSetting().screenCount

        self.outlineToggle.value = setting:GetSetting().outLine
        self.toonLightToggle.value = setting:GetSetting().toonLight
        self.effectToggle.value = not setting:GetSetting().effectLow
        self.selfPeakToggle.value = setting:GetSetting().selfPeak
        self.otherPeakToggle.value = setting:GetSetting().otherPeak
        self.ShowOtherNameToggle.value = setting:GetSetting().isShowOtherName
        self.ShowOtherCharToggle.value = setting:GetSetting().showOtherChar
        self.ResolutionFilter.value = tab[setting:GetSetting().resolution]
        resolutionIndex = setting:GetSetting().resolution
        self.screenCountToggleMid.value = screenCount == GameConfig.Setting.ScreenCountMid and true or false
        self.screenCountToggleHigh.value = screenCount == GameConfig.Setting.ScreenCountHigh and true or false
        self.screenCountToggleLow.value = screenCount == GameConfig.Setting.ScreenCountLow and true or false

        local option = Game.Myself.data.userdata:Get(UDEnum.OPTION)
        if option ~= nil then
            self.slimToggle.value = BitUtil.band(option, SceneUser2_pb.EOPTIONTYPE_USE_SLIM) > 0
        else
            self.slimToggle.value = true
        end

        self.SavingMode:SetActive(not BackwardCompatibilityUtil.CompatibilityMode_V9)
        self.SavingModeToggle.value = setting:GetSetting().powerMode

        local showExterior = MyselfProxy.Instance:GetFashionHide()
        for i=0,#self.showExterior do
            self.showExterior[i].value = self:GetBitByInt(showExterior, i)
        end
    end    
end

function SetViewEffectState:Show ()
    self:SettingUI()
end

function SetViewEffectState:Save ()
    self:SetNormalModeData()
end

function SetViewEffectState:SetNormalModeData()
    local setting = FunctionPerformanceSetting.Me()
    local screenCount
    if self.screenCountToggleMid.value == true then
        screenCount = GameConfig.Setting.ScreenCountMid
    elseif self.screenCountToggleHigh.value == true then
        screenCount = GameConfig.Setting.ScreenCountHigh
    else
        screenCount = GameConfig.Setting.ScreenCountLow
    end

    setting:SetBegin()
    setting:SetOutLine(self.outlineToggle.value)
    setting:SetToonLight(self.toonLightToggle.value)
    setting:SetEffectLow(not self.effectToggle.value)
    setting:SetSlim(self.slimToggle.value)
    setting:SetSelfPeak(self.selfPeakToggle.value)
    setting:SetOtherPeak(self.otherPeakToggle.value)
    setting:SetScreenCount(screenCount)
    setting:SetShowOtherName(self.ShowOtherNameToggle.value)
    setting:SetShowOtherChar(self.ShowOtherCharToggle.value)
    setting:SetResolution(resolutionIndex)
    setting:SetShowExterior(self:SetShowExterior())
    if not BackwardCompatibilityUtil.CompatibilityMode_V9 then
        setting:SetPowerMode(self.SavingModeToggle.value)
    end
    setting:SetEnd()
end

function SetViewEffectState:SetShowExterior()
    local showExterior = 0
    for i=0,#self.showExterior do
        showExterior = self:GetIntByBit(showExterior, i, not self.showExterior[i].value)
    end
    return showExterior
end

function SetViewEffectState:Exit ()
    
end

function SetViewEffectState:SwitchOn ()
    
end

function SetViewEffectState:SwitchOff ()
    
end

function SetViewEffectState:GetBitByInt(num, index)
    return ((num >> index) & 1) == 0
end

function SetViewEffectState:GetIntByBit(num, index, b)
    if b then
        num = num + (1<<index)
    end
    return num
end
