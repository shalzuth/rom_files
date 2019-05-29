JoinStagePopUp = class("PurchaseSaveSlotPopUp", ContainerView)
JoinStagePopUp.ViewType = UIViewType.PopUpLayer
function JoinStagePopUp:Init()
  self:InitView()
  self:AddListenEvt(ServiceEvent.NUserQueryStageUserCmd, self.SetWaittime)
end
function JoinStagePopUp:InitView()
  self.stageid = StageProxy.Instance:GetCurrentStageid()
  local mode = StageProxy.Instance.joinType
  self:AddButtonEvent("ConfirmBtn", function()
    ServiceNUserProxy.Instance:CallDressUpLineUpUserCmd(self.stageid, mode, true)
    self:CloseSelf()
  end)
  self:AddButtonEvent("CancelBtn", function()
    self:CloseSelf()
  end)
end
local stagecfg = GameConfig.StageConfig
function JoinStagePopUp:SetWaittime()
  local tiplabel = self:FindGO("tiplabel"):GetComponent(UILabel)
  local waittime = StageProxy.Instance:GetWaitTime()
  local name = stagecfg[self.stageid].name
  tiplabel.text = string.format(ZhString.Stage_WaitInfo, name, waittime)
end
