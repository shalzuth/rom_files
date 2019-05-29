MvpBattleTeamData = class("MvpBattleTeamData")
function MvpBattleTeamData:ctor(data)
  self.killMvps = {}
  self.killMinis = {}
  self.deadBosses = {}
  self:SetData(data)
end
function MvpBattleTeamData:SetData(data)
  if data ~= nil then
    self.teamid = data.teamid
    self.teamname = data.teamname
    self.killusernum = data.killusernum
    for i = 1, #data.killmvps do
      self.killMvps[#self.killMvps + 1] = data.killmvps[i]
    end
    for i = 1, #data.killminis do
      self.killMinis[#self.killMinis + 1] = data.killminis[i]
    end
    for i = 1, #data.deadboss do
      self.deadBosses[#self.deadBosses + 1] = data.deadboss[i]
    end
  end
end
function MvpBattleTeamData:SetIndex(index)
  self.index = index
end
function MvpBattleTeamData:GetKillMvps()
  return self.killMvps
end
function MvpBattleTeamData:GetKillMinis()
  return self.killMinis
end
function MvpBattleTeamData:GetDeadBosses()
  return self.deadBosses
end
function MvpBattleTeamData:GetKillMvpCount()
  return #self.killMvps
end
function MvpBattleTeamData:GetKillMiniCount()
  return #self.killMinis
end
