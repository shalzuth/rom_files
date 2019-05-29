SetViewEffectState = class("SetViewEffectState", SubView)
local resolutionLabTab = {}
local resolutionIndex = 1
local TargetFrameRate = {
  {
    name = ZhString.SetView_LowFrameRate,
    count = 30,
    index = 1
  },
  {
    name = ZhString.SetView_HightFrameRate,
    count = 60,
    index = 2
  }
}
function SetViewEffectState:Init()
  self:FindObj()
  self:InitFrameRateData()
  self:AddEvts()
  self:Show()
end
function SetViewEffectState:FindObj()
  if self:FindGO("OutlineToggle") then
    self.outlineToggle = self:FindGO("OutlineToggle"):GetComponent("UIToggle")
    self.effectToggle = self:FindGO("EffectToggle"):GetComponent("UIToggle")
    self.toonLightToggle = self:FindGO("ToonLightToggle"):GetComponent("UIToggle")
    self.slimToggle = self:FindGO("SlimToggle"):GetComponent("UIToggle")
    self.selfPeakToggle = self:FindGO("SelfPeakToggle"):GetComponent("UIToggle")
    self.otherPeakToggle = self:FindGO("OtherPeakToggle"):GetComponent("UIToggle")
    self.screenCountToggleLow = self:FindGO("ScreenCountToggleLow"):GetComponent("UIToggle")
    self.screenCountToggleMid = self:FindGO("ScreenCountToggleMid"):GetComponent("UIToggle")
    self.screenCountToggleHigh = self:FindGO("ScreenCountToggleHigh"):GetComponent("UIToggle")
    self.ShowOtherNameToggle = self:FindGO("ShowOtherNameToggle"):GetComponent("UIToggle")
    self.ShowOtherCharToggle = self:FindGO("ShowOtherCharToggle"):GetComponent("UIToggle")
    self.ResolutionFilter = self:FindGO("ResolutionFilter"):GetComponent("UIPopupList")
    self.targetFrameRate = self:FindGO("FrameRatePop"):GetComponent("UIPopupList")
    local frameLabel = self:FindGO("Label", self.targetFrameRate.gameObject):GetComponent(UILabel)
    self.targetFrameRate.fontSize = 19
    frameLabel.fontSize = 21
    OverseaHostHelper:FixLabelOverV1(frameLabel, 3, 145)
    local resLabel = self:FindGO("Label", self.ResolutionFilter.gameObject):GetComponent(UILabel)
    self.ResolutionFilter.fontSize = 19
    resLabel.fontSize = 21
    OverseaHostHelper:FixLabelOverV1(resLabel, 3, 145)
    self.showExterior = {}
    self.showExterior[0] = self:FindGO("ShowExteriorHeadToggle"):GetComponent("UIToggle")
    self.showExterior[1] = self:FindGO("ShowExteriorBackToggle"):GetComponent("UIToggle")
    self.showExterior[2] = self:FindGO("ShowExteriorFaceToggle"):GetComponent("UIToggle")
    self.showExterior[3] = self:FindGO("ShowExteriorTailToggle"):GetComponent("UIToggle")
    self.showExterior[4] = self:FindGO("ShowExteriorMouthToggle"):GetComponent("UIToggle")
    self.SavingMode = self:FindGO("SavingMode")
    self.SavingModeToggle = self:FindGO("SavingMode/SavingModeToggle"):GetComponent("UIToggle")
    self.resolutionSetTempSprite = self:FindGO("ResolutionSetTempSprite")
    self.FpsFrameExtraSet = self:FindGO("FpsFrameExtraSet")
    self.FpsFrameExtraSetTitle = self:FindGO("Title", self.FpsFrameExtraSet)
    self.FpsFrameExtraSetTitle_UILabel = self.FpsFrameExtraSetTitle:GetComponent(UILabel)
    self.FpsFrameExtraSetTitle_UILabel.text = ZhString.SetView_HightFpsHint
    self.FpsFrameExtraSet.transform.localPosition = Vector3(-4, -38, 0)
    self.WhiteBg = self:FindGO("WhiteBg")
    self.GameEffectSet = self:FindGO("GameEffectSet")
    self.PeakEffectSet = self:FindGO("PeakEffectSet")
    self.ScreenCountSet = self:FindGO("ScreenCountSet")
    self.ShowOtherSet = self:FindGO("ShowOtherSet")
    self.MoveTable = {
      self.WhiteBg,
      self.GameEffectSet,
      self.PeakEffectSet,
      self.ScreenCountSet,
      self.ShowOtherSet
    }
    self.poplistLeanTween = LeanTween.delayedCall(0.1, function()
      self.resolutionSetTempSprite:SetActive(true)
      self.poplistLeanTween:cancel()
      self.poplistLeanTween = nil
    end)
  end
end
function SetViewEffectState:OnEnter()
  SetViewEffectState.super.OnEnter(self)
  self.OnEnterTag = true
end
function SetViewEffectState:OnExit()
  self.OnEnterTag = false
  self.FirstEnter = nil
  SetViewEffectState.super.OnExit(self)
end
function SetViewEffectState:InitFrameRateData()
  self.targetFrameRate:Clear()
  for i = 1, #TargetFrameRate do
    local single = TargetFrameRate[i]
    self.targetFrameRate:AddItem(single.name, single)
  end
end
function SetViewEffectState:AddEvts()
  EventDelegate.Add(self.ResolutionFilter.onChange, function()
    resolutionIndex = resolutionLabTab[self.ResolutionFilter.value]
    if ApplicationInfo.IsRunOnWindowns() then
      local saveIndex = LocalSaveProxy.Instance:GetWindowsResolution(resolutionIndex)
      if saveIndex == resolutionIndex then
        return
      end
      LocalSaveProxy.Instance:SetWindowsResolution(resolutionIndex)
      Game.SetResolution(resolutionIndex)
    end
  end)
  EventDelegate.Add(self.targetFrameRate.onChange, function()
    local data = self.targetFrameRate.data
    UnityEngine.Application.targetFrameRate = data.count
    if data.count == 30 then
      if self.OnEnterTag ~= true then
        return
      end
      if self.FirstEnter == nil then
        self.FirstEnter = true
        return
      end
      if self.currentRate == 30 then
        return
      end
      self.currentRate = 30
      for k, v in pairs(self.MoveTable) do
        LeanTween.cancel(v.gameObject)
        self.startX = v.gameObject.transform.localPosition.x
        self.startY = v.gameObject.transform.localPosition.y
        self.startZ = v.gameObject.transform.localPosition.z
        LeanTween.value(v.gameObject, function(f)
          v.gameObject.transform.localPosition = Vector3(self.startX, f, self.startZ)
        end, self.startY, self.startY + 40, 0.5):setDestroyOnComplete(true)
        break
      end
    elseif data.count == 60 then
      if self.OnEnterTag ~= true then
        return
      end
      if self.currentRate == 60 then
        return
      end
      self.currentRate = 60
      if self.FirstEnter ~= true then
        for k, v in pairs(self.MoveTable) do
          LeanTween.cancel(v.gameObject)
          self.startX = v.gameObject.transform.localPosition.x
          self.startY = v.gameObject.transform.localPosition.y
          self.startZ = v.gameObject.transform.localPosition.z
          v.gameObject.transform.localPosition = Vector3(self.startX, self.startY - 40, self.startZ)
        end
        self.FirstEnter = true
        return
      end
      for k, v in pairs(self.MoveTable) do
        LeanTween.cancel(v.gameObject)
        self.startX = v.gameObject.transform.localPosition.x
        self.startY = v.gameObject.transform.localPosition.y
        self.startZ = v.gameObject.transform.localPosition.z
        LeanTween.value(v.gameObject, function(f)
          v.gameObject.transform.localPosition = Vector3(self.startX, f, self.startZ)
        end, self.startY, self.startY - 40, 0.5):setDestroyOnComplete(true)
        break
      end
    end
  end)
end
function SetViewEffectState:SettingUI()
  if self.ResolutionFilter then
    self.ResolutionFilter:Clear()
    resolutionLabTab = {}
    local tab = Game.GetResolutionNames()
    for i = 1, #tab do
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
    local rateKey = setting:GetSetting().targetFrameRate
    self.targetFrameRate.value = TargetFrameRate[rateKey].name
    if ApplicationInfo.IsRunOnWindowns() then
      resolutionIndex = LocalSaveProxy.Instance:GetWindowsResolution()
    else
      resolutionIndex = setting:GetSetting().resolution
    end
    self.ResolutionFilter.value = tab[resolutionIndex]
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
    for i = 0, #self.showExterior do
      self.showExterior[i].value = self:GetBitByInt(showExterior, i)
    end
  end
end
function SetViewEffectState:Show()
  self:SettingUI()
  self:ShowFpsFrameHintMsgBox()
end
function SetViewEffectState:ShowFpsFrameHintMsgBox()
end
function SetViewEffectState:Save()
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
  local frameRate = self.targetFrameRate.data
  setting:SetFrameRate(frameRate.index)
  setting:SetShowExterior(self:SetShowExterior())
  if not BackwardCompatibilityUtil.CompatibilityMode_V9 then
    setting:SetPowerMode(self.SavingModeToggle.value)
  end
  setting:SetEnd()
end
function SetViewEffectState:SetShowExterior()
  local showExterior = 0
  for i = 0, #self.showExterior do
    showExterior = self:GetIntByBit(showExterior, i, not self.showExterior[i].value)
  end
  return showExterior
end
function SetViewEffectState:Exit()
  local setting = FunctionPerformanceSetting.Me()
  local rateKey = setting:GetSetting().targetFrameRate
  UnityEngine.Application.targetFrameRate = TargetFrameRate[rateKey].count
end
function SetViewEffectState:SwitchOn()
end
function SetViewEffectState:SwitchOff()
end
function SetViewEffectState:GetBitByInt(num, index)
  return num >> index & 1 == 0
end
function SetViewEffectState:GetIntByBit(num, index, b)
  if b then
    num = num + (1 << index)
  end
  return num
end
