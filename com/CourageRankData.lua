CourageRankData = class("CourageRankData")
function CourageRankData.ParseServerData(table, serverData, rank)
  table.charid = serverData.charid
  table.name = serverData.name
  table.level = serverData.level
  table.score = serverData.score
  table.guildname = serverData.guildname
  table.profession = serverData.profession
  table.rank = rank
  return table
end
function CourageRankData.CreateMyselfData(table, myRank)
  table.charid = Game.Myself.data.id
  table.name = Game.Myself.data.name
  table.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  table.score = Game.Myself.data.userdata:Get(UDEnum.COURAGE)
  table.guildname = GuildProxy.Instance.myGuildData and GuildProxy.Instance.myGuildData.name
  table.profession = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  table.rank = myRank
  return table
end
