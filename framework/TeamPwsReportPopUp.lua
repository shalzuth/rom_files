autoImport("TeamPwsReportPanel")
TeamPwsReportPopUp = class("TeamPwsReportPopUp", BaseView)
TeamPwsReportPopUp.ViewType = UIViewType.PopUpLayer
function TeamPwsReportPopUp:Init()
  self:InitReportPanel()
  self:AddButtonEvt()
  self:AddViewEvt()
end
function TeamPwsReportPopUp:InitReportPanel()
  self.reportPanel = TeamPwsReportPanel.new(self:FindGO("ReportRoot"))
end
function TeamPwsReportPopUp:AddButtonEvt()
  self:AddClickEvent(self:FindGO("Mask"), function()
    self:ClickButtonClose()
  end)
  self:AddClickEvent(self:FindGO("BtnClose"), function()
    self:ClickButtonClose()
  end)
  self:AddClickEvent(self:FindGO("BtnLeave"), function()
    self:ClickButtonClose()
  end)
end
function TeamPwsReportPopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryTeamPwsUserInfoFubenCmd, self.HandelQueryTeamPwsUserInfoFubenCmd)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamPwsReportFubenCmd, self.HandleTeamPwsReportFubenCmd)
end
function TeamPwsReportPopUp:HandelQueryTeamPwsUserInfoFubenCmd()
  self.reportPanel:InitData()
end
function TeamPwsReportPopUp:HandleTeamPwsReportFubenCmd()
  self:CloseSelf()
end
function TeamPwsReportPopUp:ClickButtonClose()
  PvpProxy.Instance:ClearTeamPwsReportData()
  self:CloseSelf()
end
function TeamPwsReportPopUp:OnEnter()
  self.super.OnEnter(self)
  self.reportPanel:StartLoading()
  ServiceFuBenCmdProxy.Instance:CallQueryTeamPwsUserInfoFubenCmd()
end
function TeamPwsReportPopUp:OnExit()
  self.super.OnExit(self)
end
