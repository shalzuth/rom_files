TeamPwsReportCell = class("TeamPwsReportCell", BaseCell)
function TeamPwsReportCell:Init()
  self:FindObjs()
end
function TeamPwsReportCell:FindObjs()
  self.objMvp = self:FindGO("objMvp")
  self.objLine = self:FindGO("objLine")
  self.sprBG = self:FindComponent("Bg", UISprite)
  self.sprBGMyself = self:FindComponent("BgAdd", UISprite)
  self.labName = self:FindComponent("labName", UILabel)
  self.sprProfession = self:FindComponent("sprProfession", UISprite)
  self.labKill = self:FindComponent("labKill", UILabel)
  self.labDeath = self:FindComponent("labDeath", UILabel)
  self.labHeal = self:FindComponent("labHeal", UILabel)
  self.labKillScore = self:FindComponent("labKillScore", UILabel)
  self.labBallScore = self:FindComponent("labBallScore", UILabel)
  self.labSeasonScore = self:FindComponent("labSeasonScore", UILabel)
end
function TeamPwsReportCell:SetData(data)
  self.data = data
  self.id = data.charID
  self.labName.text = data.name
  self.labKill.text = data.kill
  self.labDeath.text = data.death
  if not (data.heal < 100000) or not data.heal then
  end
  self.labHeal.text = string.format(ZhString.TeamPws_TenThousand, string.format("%.2f", data.heal / 10000))
  self.labKillScore.text = data.killScore
  self.labBallScore.text = data.ballScore
  self.labSeasonScore.text = data.seasonScore
  if type(data.profession) == "number" then
    local proData = Table_Class[data.profession]
    self.sprProfession.gameObject:SetActive(proData and IconManager:SetProfessionIcon(proData.icon, self.sprProfession) or false)
  elseif type(data.profession) == "string" then
    local success = IconManager:SetProfessionIcon(data.profession, self.sprProfession) or IconManager:SetUIIcon(data.profession, self.sprProfession)
    self.sprProfession.gameObject:SetActive(success)
  end
  local bgColor = data.teamColor == PvpProxy.TeamPws.TeamColor.Red and TeamPwsReportPanel.ColorRed or TeamPwsReportPanel.ColorBlue
  self.sprBG.color = bgColor
  if self.id == Game.Myself.data.id then
    self.sprBGMyself.color = bgColor
    self.sprBGMyself.gameObject:SetActive(true)
  else
    self.sprBGMyself.gameObject:SetActive(false)
  end
  self.objMvp:SetActive(data.isMvp or false)
end
function TeamPwsReportCell:SetLineActive(isActive)
  self.objLine:SetActive(isActive)
end
