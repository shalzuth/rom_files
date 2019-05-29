SetViewSecurityPage = class("SetViewSecurityPage", SubView)
autoImport("SecurityPanel")
local resolutionLabTab = {}
local resolutionIndex = 1
SetViewSecurityPage.SecurityTable = Table_SecuritySetting
function SetViewSecurityPage:Init()
  self:AddEvts()
  self:initView()
  self:AddViewEvents()
  self:initData()
  local SecurityStatusCt = self:FindGO("SecurityStatusCt")
  SecurityStatusCt:SetActive(false)
  local AccID = self:FindGO("AccID"):GetComponent(UILabel)
  AccID.text = "\227\129\178\227\129\191\227\129\164\227\129\174\227\130\179\227\131\188\227\131\137"
  local Back = self:FindGO("Back", self:FindGO("AccContent")):GetComponent(UISprite)
  Back.transform.localPosition = Vector3(110, 0, 0)
  Back.width = 160
  local ServiceContent = self:FindGO("ServiceContent")
  local cTitle = self:FindGO("Title", ServiceContent):GetComponent(UILabel)
  cTitle.text = "\227\129\138\229\149\143\227\129\132\229\144\136\227\130\143\227\129\155"
end
function SetViewSecurityPage:initView()
  local obj = self:FindGO("SecuritySetting")
  local Label = self:FindComponent("Label", UILabel, obj)
  Label.text = ZhString.SetViewSecurityPage_TabText
  self.gameObject = self:FindGO("SecurityPage")
  local securityEventTip = self:FindComponent("securityEventTip", UILabel)
  OverseaHostHelper:FixLabelOverV1(securityEventTip, 3, 580)
  securityEventTip.text = ZhString.SetViewSecurityPage_SecurityEventTipText
  self.tipLabel = self:FindComponent("tipLabel", UILabel)
  self.tipLabel.text = ZhString.SetViewSecurityPage_TipLabelText
  self.securityEventContent = self:FindComponent("securityEventContent", UILabel)
  self.securityEventContent.text = ""
  self.securitySetBtnText = self:FindComponent("securitySetBtnText", UILabel)
  self.securityModifyBtn = self:FindGO("securityModifyBtn")
  local securityModifyBtnText = self:FindComponent("securityModifyBtnText", UILabel)
  securityModifyBtnText.text = ZhString.SetViewSecurityPage_SecurityModifyBtnText
  local accId = self:FindGO("AccValue"):GetComponent(UILabel)
  accId.text = tostring(OverseaHostHelper.accId)
  local CopyBtn = self:FindGO("CopyBtn")
  self:AddClickEvent(CopyBtn, function(go)
    ApplicationInfo.CopyToSystemClipboard(OverseaHostHelper.accId)
  end)
  local GoServiceBtn = self:FindGO("GoServiceBtn")
  self:AddClickEvent(GoServiceBtn, function(go)
    OverseaHostHelper:OpenWebView("https://ragnarokm.gungho.jp/member/support")
  end)
end
function SetViewSecurityPage:AddViewEvents()
  self:AddButtonEvent("securitySetBtn", function()
    if not self.hasSet then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.SecurityPanel,
        viewdata = {
          ActionType = SecurityPanel.ActionType.Setting
        }
      })
    elseif self.hasReSet then
      MsgManager.ConfirmMsgByID(6008, function()
        ServiceAuthorizeProxy.Instance:CallResetAuthorizeUserCmd(false)
      end)
    else
      MsgManager.ConfirmMsgByID(6003, function()
        ServiceAuthorizeProxy.Instance:CallResetAuthorizeUserCmd(true)
      end)
    end
  end)
  self:AddClickEvent(self.securityModifyBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SecurityPanel,
      viewdata = {
        ActionType = SecurityPanel.ActionType.Modify
      }
    })
  end)
end
function SetViewSecurityPage:AddEvts()
  self:AddListenEvt(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, self.HandleRecvAuthorizeInfo)
end
function SetViewSecurityPage:HandleRecvAuthorizeInfo()
  self:SettingUI()
end
function SetViewSecurityPage:initData()
  local str = ""
  for k, v in pairs(SetViewSecurityPage.SecurityTable) do
    local desc = v.Desc
    desc = string.format(desc, v.param and v.param[1] or "")
    str = str .. desc .. "\n"
  end
  self.securityEventContent.text = str
end
function SetViewSecurityPage:SettingUI()
  TimeTickManager.Me():ClearTick(self)
  local tipText = ""
  local myself = FunctionSecurity.Me()
  local resetTime = myself.verifySecuriyResettime
  self.hasSet = myself.verifySecuriyhasSet
  self.hasReSet = resetTime and resetTime ~= 0
  if not self.hasSet then
    self:Hide(self.securityModifyBtn)
    tipText = string.format(ZhString.SetViewSecurityPage_TipLabelText, "[c][D91E1DFF]" .. ZhString.SetViewSecurityPage_UnSet .. "[-][/c]")
    self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecuritySetBtnText
  elseif self.hasReSet then
    self:Hide(self.securityModifyBtn)
    TimeTickManager.Me():CreateTick(0, 1000, self.ChangetipText, self)
    self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecurityCancelBtnText
  else
    self:Show(self.securityModifyBtn)
    tipText = string.format(ZhString.SetViewSecurityPage_TipLabelText, "[c][13C433FF]" .. ZhString.SetViewSecurityPage_valiable .. "[-][/c]")
    self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecurityResetBtnText
  end
  self.tipLabel.text = tipText
end
function SetViewSecurityPage:ChangetipText()
  local myself = FunctionSecurity.Me()
  local resetTime = myself.verifySecuriyResettime
  local leftTime = resetTime - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(myself.verifySecuriyCode)
    leftTime = 0
    TimeTickManager.Me():ClearTick(self)
  end
  leftTime = math.floor(leftTime)
  local day = math.floor(leftTime / 3600 / 24)
  local hour = math.floor((leftTime - day * 24 * 3600) / 3600)
  local m = math.floor((leftTime - day * 24 * 3600 - hour * 3600) / 60)
  local timeStr = string.format(ZhString.SetViewSecurityPage_SecurityResetTimeLeft, day, hour, m)
  local tipText = string.format(ZhString.SetViewSecurityPage_ResetPassDelay, timeStr)
  self.tipLabel.text = tipText
end
function SetViewSecurityPage:Exit()
end
function SetViewSecurityPage:Save()
end
function SetViewSecurityPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
end
function SetViewSecurityPage:SwitchOn()
  self:SettingUI()
end
function SetViewSecurityPage:SwitchOff()
end
