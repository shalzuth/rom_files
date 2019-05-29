TeamPwsData = class("TeamPwsData")
function TeamPwsData.ParseRankData(table, serverData)
  table.name = serverData.name
  table.portrait = serverData.portrait
  table.profession = serverData.profession
  table.rank = serverData.rank
  table.score = serverData.score
  table.erank = serverData.erank
  table.level = serverData.level
  table.guildname = serverData.guildname
  table.charid = serverData.charid
  return table
end
function TeamPwsData.ParsePrepareData(table, serverData)
  table.charID = serverData
  table.isReady = false
  return table
end
function TeamPwsData.ParseReportData(table, serverData, teamID, color)
  table.teamID = teamID
  table.teamColor = color
  table.charID = serverData.charid
  table.name = serverData.name or ""
  table.profession = serverData.profession or 1
  table.kill = serverData.killnum or 0
  table.death = serverData.dienum or 0
  table.heal = serverData.heal or 0
  table.killScore = serverData.killscore or 0
  table.ballScore = math.ceil((serverData.ballscore or 0) / 1000) + (serverData.buffscore or 0)
  table.seasonScore = serverData.seasonscore or 0
  return table
end
