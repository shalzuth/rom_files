autoImport("TeamPwsReportCell")
TeamPwsReportPanel = class("TeamPwsReportPanel", BaseView)
TeamPwsReportPanel.SortType = {
  Name = 1,
  Kill = 2,
  Death = 3,
  Heal = 4,
  KillScore = 5,
  BallScore = 6,
  SeasonScore = 7
}
TeamPwsReportPanel.ColorRed = Color(1, 0.6862745098039216, 0.6862745098039216, 1)
TeamPwsReportPanel.ColorBlue = Color(0.6235294117647059, 0.796078431372549, 1, 1)
function TeamPwsReportPanel:ctor(parent)
  TeamPwsReportPanel.super.ctor(self, self:LoadPreferb_ByFullPath("GUI/v1/view/TeamPwsReportPanel", parent, true))
end
function TeamPwsReportPanel:Init()
  self:FindObjs()
  self:ProcessReportTitles()
end
function TeamPwsReportPanel:FindObjs()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  self.labRedTeamScore = self:FindComponent("labRedTeamScore", UILabel)
  self.labBlueTeamScore = self:FindComponent("labBlueTeamScore", UILabel)
  local gridReport = self:FindComponent("reportContainer", UIGrid)
  self.listReports = UIGridListCtrl.new(gridReport, TeamPwsReportCell, "TeamPwsReportCell")
end
function TeamPwsReportPanel:ProcessReportTitles()
  local parent = self:FindGO("ReportTitles")
  local objButton = self:FindGO("labName", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByName()
  end)
  objButton = self:FindGO("labKill", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKill()
  end)
  objButton = self:FindGO("labDeath", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByDeath()
  end)
  objButton = self:FindGO("labHeal", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByHeal()
  end)
  objButton = self:FindGO("labKillScore", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKillScore()
  end)
  objButton = self:FindGO("labBallScore", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByBallScore()
  end)
  objButton = self:FindGO("labSeasonScore", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortBySeasonScore()
  end)
end
function TeamPwsReportPanel:ProcessLabelCollider(go)
  local label = go:GetComponent(UILabel)
  local boxCollider = go:GetComponent(BoxCollider)
  local width = label.printedSize.x
  local vec = boxCollider.size
  vec.x = width + math.min(math.max(label.width - width, 0), 10)
  boxCollider.size = vec
  vec = boxCollider.center
  vec.x = width / 2
  boxCollider.center = vec
end
function TeamPwsReportPanel:StartLoading()
  self.objLoading:SetActive(true)
end
function TeamPwsReportPanel:InitData()
  self.data = PvpProxy.Instance:GetTeamPwsReportData()
  self:UpdateData()
end
function TeamPwsReportPanel:UpdateData()
  if not self.data then
    printRed("Cannot Find TeamPws Report Data!")
    return
  end
  self.labRedTeamScore.text = self.data.aveScores[PvpProxy.TeamPws.TeamColor.Red] or "-"
  self.labBlueTeamScore.text = self.data.aveScores[PvpProxy.TeamPws.TeamColor.Blue] or "-"
  self.objLoading:SetActive(false)
  self.objEmptyList:SetActive(#self.data.reports < 1)
  if self.curLastCell then
    self.curLastCell:SetLineActive(true)
  end
  self.listReports:ResetDatas(self.data.reports)
  if #self.data.reports > 0 then
    local cells = self.listReports:GetCells()
    self.curLastCell = cells[#cells]
    self.curLastCell:SetLineActive(false)
  end
end
function TeamPwsReportPanel:SortByName()
  if self.sortType == TeamPwsReportPanel.SortType.Name then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.name < y.name
  end)
  self.sortType = TeamPwsReportPanel.SortType.Name
  self:UpdateData()
end
function TeamPwsReportPanel:SortByKill()
  if self.sortType == TeamPwsReportPanel.SortType.Kill then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.kill > y.kill
  end)
  self.sortType = TeamPwsReportPanel.SortType.Kill
  self:UpdateData()
end
function TeamPwsReportPanel:SortByDeath()
  if self.sortType == TeamPwsReportPanel.SortType.Death then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.death > y.death
  end)
  self.sortType = TeamPwsReportPanel.SortType.Death
  self:UpdateData()
end
function TeamPwsReportPanel:SortByHeal()
  if self.sortType == TeamPwsReportPanel.SortType.Heal then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.heal > y.heal
  end)
  self.sortType = TeamPwsReportPanel.SortType.Heal
  self:UpdateData()
end
function TeamPwsReportPanel:SortByKillScore()
  if self.sortType == TeamPwsReportPanel.SortType.KillScore then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.killScore > y.killScore
  end)
  self.sortType = TeamPwsReportPanel.SortType.KillScore
  self:UpdateData()
end
function TeamPwsReportPanel:SortByBallScore()
  if self.sortType == TeamPwsReportPanel.SortType.BallScore then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.ballScore > y.ballScore
  end)
  self.sortType = TeamPwsReportPanel.SortType.BallScore
  self:UpdateData()
end
function TeamPwsReportPanel:SortBySeasonScore()
  if self.sortType == TeamPwsReportPanel.SortType.SeasonScore then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.seasonScore > y.seasonScore
  end)
  self.sortType = TeamPwsReportPanel.SortType.SeasonScore
  self:UpdateData()
end
