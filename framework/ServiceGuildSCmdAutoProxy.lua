ServiceGuildSCmdAutoProxy = class("ServiceGuildSCmdAutoProxy", ServiceProxy)
ServiceGuildSCmdAutoProxy.Instance = nil
ServiceGuildSCmdAutoProxy.NAME = "ServiceGuildSCmdAutoProxy"
function ServiceGuildSCmdAutoProxy:ctor(proxyName)
  if ServiceGuildSCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGuildSCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGuildSCmdAutoProxy.Instance = self
  end
end
function ServiceGuildSCmdAutoProxy:Init()
end
function ServiceGuildSCmdAutoProxy:onRegister()
  self:Listen(210, 1, function(data)
    self:RecvUserGuildInfoSyncGuildSCmd(data)
  end)
  self:Listen(210, 2, function(data)
    self:RecvChatSyncGuildSCmd(data)
  end)
  self:Listen(210, 3, function(data)
    self:RecvLoadLuaGuildSCmd(data)
  end)
  self:Listen(210, 4, function(data)
    self:RecvTransDataGuildSCmd(data)
  end)
  self:Listen(210, 5, function(data)
    self:RecvGuildInfoSyncGuildSCmd(data)
  end)
  self:Listen(210, 6, function(data)
    self:RecvGuildDataUpdateGuildSCmd(data)
  end)
  self:Listen(210, 7, function(data)
    self:RecvCityDataUpdateGuildSCmd(data)
  end)
  self:Listen(210, 8, function(data)
    self:RecvGuildMemberUpdateGuildSCmd(data)
  end)
  self:Listen(210, 9, function(data)
    self:RecvGuildMemberDataUpdateGuildSCmd(data)
  end)
  self:Listen(210, 11, function(data)
    self:RecvEnterGuildTerritoryGuildSCmd(data)
  end)
  self:Listen(210, 14, function(data)
    self:RecvQueryPhotoListGuildSCmd(data)
  end)
  self:Listen(210, 15, function(data)
    self:RecvQueryUserPhotoListGuildSCmd(data)
  end)
  self:Listen(210, 16, function(data)
    self:RecvQueryShowPhotoGuildSCmd(data)
  end)
  self:Listen(210, 17, function(data)
    self:RecvFrameUpdateGuildSCmd(data)
  end)
  self:Listen(210, 18, function(data)
    self:RecvPhotoUpdateGuildSCmd(data)
  end)
  self:Listen(210, 19, function(data)
    self:RecvJobUpdateGuildSCmd(data)
  end)
  self:Listen(210, 20, function(data)
    self:RecvGuildMusicDeleteGuildSCmd(data)
  end)
  self:Listen(210, 21, function(data)
    self:RecvRenameNTFGuildCmd(data)
  end)
  self:Listen(210, 22, function(data)
    self:RecvGuildCityActionGuildSCmd(data)
  end)
  self:Listen(210, 23, function(data)
    self:RecvSendMailGuildSCmd(data)
  end)
  self:Listen(210, 24, function(data)
    self:RecvGVGRewardGuildSCmd(data)
  end)
  self:Listen(210, GUILDSPARAM_GUILDPRAY, function(data)
    self:RecvGuildPrayGuildSCmd(data)
  end)
  self:Listen(210, 26, function(data)
    self:RecvGuildIconStateGuildSCmd(data)
  end)
  self:Listen(210, 27, function(data)
    self:RecvSubmitMaterialGuildSCmd(data)
  end)
  self:Listen(210, 28, function(data)
    self:RecvBuildingUpdateGuildSCmd(data)
  end)
  self:Listen(210, 29, function(data)
    self:RecvQueryGuildInfoGuildSCmd(data)
  end)
  self:Listen(210, 30, function(data)
    self:RecvSendWelfareGuildSCmd(data)
  end)
  self:Listen(210, 31, function(data)
    self:RecvChallengeProgressGuildSCmd(data)
  end)
  self:Listen(210, 32, function(data)
    self:RecvGMCommandGuildSCmd(data)
  end)
  self:Listen(210, 33, function(data)
    self:RecvGMCommandRespondGuildSCmd(data)
  end)
  self:Listen(210, 34, function(data)
    self:RecvBuildingEffectGuildSCmd(data)
  end)
  self:Listen(210, 35, function(data)
    self:RecvArtifactUpdateGuildSCmd(data)
  end)
  self:Listen(210, 36, function(data)
    self:RecvGuildArtifactQuestGuildSCmd(data)
  end)
  self:Listen(210, 37, function(data)
    self:RecvQueryTreasureGuildSCmd(data)
  end)
  self:Listen(210, 38, function(data)
    self:RecvGvgUserPartInGuildSCmd(data)
  end)
  self:Listen(210, 39, function(data)
    self:RecvTreasureResultNtfGuildSCmd(data)
  end)
  self:Listen(210, 41, function(data)
    self:RecvUpdateCityStateGuildSCmd(data)
  end)
  self:Listen(210, 40, function(data)
    self:RecvGvgOpenToServerGuildSCmd(data)
  end)
  self:Listen(210, 44, function(data)
    self:RecvShopBuyItemGuildSCmd(data)
  end)
  self:Listen(210, 42, function(data)
    self:RecvJoinSuperGvgGuildSCmd(data)
  end)
  self:Listen(210, 43, function(data)
    self:RecvEndSuperGvgGuildSCmd(data)
  end)
  self:Listen(210, 46, function(data)
    self:RecvUpdateCityGuildSCmd(data)
  end)
  self:Listen(210, 45, function(data)
    self:RecvGvgResultGuildSCmd(data)
  end)
  self:Listen(210, 48, function(data)
    self:RecvGuildBrocastMailGuildSCmd(data)
  end)
  self:Listen(210, 49, function(data)
    self:RecvGuildBrocastMsgGuildSCmd(data)
  end)
  self:Listen(210, 50, function(data)
    self:RecvBuyMaterialItemGuildSCmd(data)
  end)
  self:Listen(210, 51, function(data)
    self:RecvQueryGuildListGuildSCmd(data)
  end)
end
function ServiceGuildSCmdAutoProxy:CallUserGuildInfoSyncGuildSCmd(charid, guildid, guildname, guildportrait)
  local msg = GuildSCmd_pb.UserGuildInfoSyncGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if guildname ~= nil then
    msg.guildname = guildname
  end
  if guildportrait ~= nil then
    msg.guildportrait = guildportrait
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallChatSyncGuildSCmd(charid, data, len)
  local msg = GuildSCmd_pb.ChatSyncGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallLoadLuaGuildSCmd(table, lua, log)
  local msg = GuildSCmd_pb.LoadLuaGuildSCmd()
  if table ~= nil then
    msg.table = table
  end
  if lua ~= nil then
    msg.lua = lua
  end
  if log ~= nil then
    msg.log = log
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallTransDataGuildSCmd(user, contribute, prays)
  local msg = GuildSCmd_pb.TransDataGuildSCmd()
  if user ~= nil and user.accid ~= nil then
    msg.user.accid = user.accid
  end
  if user ~= nil and user.charid ~= nil then
    msg.user.charid = user.charid
  end
  if user ~= nil and user.zoneid ~= nil then
    msg.user.zoneid = user.zoneid
  end
  if user ~= nil and user.mapid ~= nil then
    msg.user.mapid = user.mapid
  end
  if user ~= nil and user.baselv ~= nil then
    msg.user.baselv = user.baselv
  end
  if user ~= nil and user.profession ~= nil then
    msg.user.profession = user.profession
  end
  if user ~= nil and user.name ~= nil then
    msg.user.name = user.name
  end
  if user ~= nil and user.guildid ~= nil then
    msg.user.guildid = user.guildid
  end
  if contribute ~= nil then
    msg.contribute = contribute
  end
  if prays ~= nil then
    for i = 1, #prays do
      table.insert(msg.prays, prays[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildInfoSyncGuildSCmd(charid, info)
  local msg = GuildSCmd_pb.GuildInfoSyncGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if info ~= nil and info.id ~= nil then
    msg.info.id = info.id
  end
  if info ~= nil and info.zoneid ~= nil then
    msg.info.zoneid = info.zoneid
  end
  if info ~= nil and info.lv ~= nil then
    msg.info.lv = info.lv
  end
  if info ~= nil and info.scene ~= nil then
    msg.info.scene = info.scene
  end
  if info ~= nil and info.auth ~= nil then
    msg.info.auth = info.auth
  end
  if info ~= nil and info.average ~= nil then
    msg.info.average = info.average
  end
  if info ~= nil and info.createtime ~= nil then
    msg.info.createtime = info.createtime
  end
  if info ~= nil and info.create ~= nil then
    msg.info.create = info.create
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.portrait ~= nil then
    msg.info.portrait = info.portrait
  end
  if info ~= nil and info.jobname ~= nil then
    msg.info.jobname = info.jobname
  end
  if info ~= nil and info.members ~= nil then
    for i = 1, #info.members do
      table.insert(msg.info.members, info.members[i])
    end
  end
  if info ~= nil and info.quests ~= nil then
    for i = 1, #info.quests do
      table.insert(msg.info.quests, info.quests[i])
    end
  end
  if info ~= nil and info.building.buildings ~= nil then
    for i = 1, #info.building.buildings do
      table.insert(msg.info.building.buildings, info.building.buildings[i])
    end
  end
  if info.building ~= nil and info.building.version ~= nil then
    msg.info.building.version = info.building.version
  end
  if info ~= nil and info.openfunction ~= nil then
    msg.info.openfunction = info.openfunction
  end
  if info ~= nil and info.challenges ~= nil then
    for i = 1, #info.challenges do
      table.insert(msg.info.challenges, info.challenges[i])
    end
  end
  if info ~= nil and info.artifactitems ~= nil then
    for i = 1, #info.artifactitems do
      table.insert(msg.info.artifactitems, info.artifactitems[i])
    end
  end
  if info ~= nil and info.artifacequest.submitids ~= nil then
    for i = 1, #info.artifacequest.submitids do
      table.insert(msg.info.artifacequest.submitids, info.artifacequest.submitids[i])
    end
  end
  if info ~= nil and info.artifacequest.datas ~= nil then
    for i = 1, #info.artifacequest.datas do
      table.insert(msg.info.artifacequest.datas, info.artifacequest.datas[i])
    end
  end
  if info.gvg ~= nil and info.gvg.insupergvg ~= nil then
    msg.info.gvg.insupergvg = info.gvg.insupergvg
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildDataUpdateGuildSCmd(charid, updates)
  local msg = GuildSCmd_pb.GuildDataUpdateGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallCityDataUpdateGuildSCmd(cityid, membercount, updates, leadername)
  local msg = GuildSCmd_pb.CityDataUpdateGuildSCmd()
  if cityid ~= nil then
    msg.cityid = cityid
  end
  if membercount ~= nil then
    msg.membercount = membercount
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if leadername ~= nil then
    msg.leadername = leadername
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildMemberUpdateGuildSCmd(charid, updates, dels)
  local msg = GuildSCmd_pb.GuildMemberUpdateGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if dels ~= nil then
    for i = 1, #dels do
      table.insert(msg.dels, dels[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildMemberDataUpdateGuildSCmd(charid, destid, updates)
  local msg = GuildSCmd_pb.GuildMemberDataUpdateGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if destid ~= nil then
    msg.destid = destid
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallEnterGuildTerritoryGuildSCmd(charid)
  local msg = GuildSCmd_pb.EnterGuildTerritoryGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallQueryPhotoListGuildSCmd(guildid, sceneid, result, frames)
  local msg = GuildSCmd_pb.QueryPhotoListGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if result ~= nil then
    msg.result = result
  end
  if frames ~= nil then
    for i = 1, #frames do
      table.insert(msg.frames, frames[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallQueryUserPhotoListGuildSCmd(guildid, result, user, frames)
  local msg = GuildSCmd_pb.QueryUserPhotoListGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if result ~= nil then
    msg.result = result
  end
  if user ~= nil and user.accid ~= nil then
    msg.user.accid = user.accid
  end
  if user ~= nil and user.charid ~= nil then
    msg.user.charid = user.charid
  end
  if user ~= nil and user.zoneid ~= nil then
    msg.user.zoneid = user.zoneid
  end
  if user ~= nil and user.mapid ~= nil then
    msg.user.mapid = user.mapid
  end
  if user ~= nil and user.baselv ~= nil then
    msg.user.baselv = user.baselv
  end
  if user ~= nil and user.profession ~= nil then
    msg.user.profession = user.profession
  end
  if user ~= nil and user.name ~= nil then
    msg.user.name = user.name
  end
  if user ~= nil and user.guildid ~= nil then
    msg.user.guildid = user.guildid
  end
  if frames ~= nil then
    for i = 1, #frames do
      table.insert(msg.frames, frames[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallQueryShowPhotoGuildSCmd(action, guildid, loads, exists, members, results)
  local msg = GuildSCmd_pb.QueryShowPhotoGuildSCmd()
  if action ~= nil then
    msg.action = action
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if loads ~= nil then
    for i = 1, #loads do
      table.insert(msg.loads, loads[i])
    end
  end
  if exists ~= nil then
    for i = 1, #exists do
      table.insert(msg.exists, exists[i])
    end
  end
  if members ~= nil then
    for i = 1, #members do
      table.insert(msg.members, members[i])
    end
  end
  if results ~= nil then
    for i = 1, #results do
      table.insert(msg.results, results[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallFrameUpdateGuildSCmd(guildid, frameid, update, del)
  local msg = GuildSCmd_pb.FrameUpdateGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if frameid ~= nil then
    msg.frameid = frameid
  end
  if update ~= nil and update.accid_svr ~= nil then
    msg.update.accid_svr = update.accid_svr
  end
  if update ~= nil and update.accid ~= nil then
    msg.update.accid = update.accid
  end
  if update ~= nil and update.charid ~= nil then
    msg.update.charid = update.charid
  end
  if update ~= nil and update.anglez ~= nil then
    msg.update.anglez = update.anglez
  end
  if update ~= nil and update.time ~= nil then
    msg.update.time = update.time
  end
  if update ~= nil and update.mapid ~= nil then
    msg.update.mapid = update.mapid
  end
  if update ~= nil and update.sourceid ~= nil then
    msg.update.sourceid = update.sourceid
  end
  if update ~= nil and update.source ~= nil then
    msg.update.source = update.source
  end
  if del ~= nil and del.accid_svr ~= nil then
    msg.del.accid_svr = del.accid_svr
  end
  if del ~= nil and del.accid ~= nil then
    msg.del.accid = del.accid
  end
  if del ~= nil and del.charid ~= nil then
    msg.del.charid = del.charid
  end
  if del ~= nil and del.anglez ~= nil then
    msg.del.anglez = del.anglez
  end
  if del ~= nil and del.time ~= nil then
    msg.del.time = del.time
  end
  if del ~= nil and del.mapid ~= nil then
    msg.del.mapid = del.mapid
  end
  if del ~= nil and del.sourceid ~= nil then
    msg.del.sourceid = del.sourceid
  end
  if del ~= nil and del.source ~= nil then
    msg.del.source = del.source
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallPhotoUpdateGuildSCmd(guildid, sceneid, update, del, to_guild)
  local msg = GuildSCmd_pb.PhotoUpdateGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if update ~= nil and update.accid_svr ~= nil then
    msg.update.accid_svr = update.accid_svr
  end
  if update ~= nil and update.accid ~= nil then
    msg.update.accid = update.accid
  end
  if update ~= nil and update.charid ~= nil then
    msg.update.charid = update.charid
  end
  if update ~= nil and update.anglez ~= nil then
    msg.update.anglez = update.anglez
  end
  if update ~= nil and update.time ~= nil then
    msg.update.time = update.time
  end
  if update ~= nil and update.mapid ~= nil then
    msg.update.mapid = update.mapid
  end
  if update ~= nil and update.sourceid ~= nil then
    msg.update.sourceid = update.sourceid
  end
  if update ~= nil and update.source ~= nil then
    msg.update.source = update.source
  end
  if del ~= nil and del.accid_svr ~= nil then
    msg.del.accid_svr = del.accid_svr
  end
  if del ~= nil and del.accid ~= nil then
    msg.del.accid = del.accid
  end
  if del ~= nil and del.charid ~= nil then
    msg.del.charid = del.charid
  end
  if del ~= nil and del.anglez ~= nil then
    msg.del.anglez = del.anglez
  end
  if del ~= nil and del.time ~= nil then
    msg.del.time = del.time
  end
  if del ~= nil and del.mapid ~= nil then
    msg.del.mapid = del.mapid
  end
  if del ~= nil and del.sourceid ~= nil then
    msg.del.sourceid = del.sourceid
  end
  if del ~= nil and del.source ~= nil then
    msg.del.source = del.source
  end
  if to_guild ~= nil then
    msg.to_guild = to_guild
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallJobUpdateGuildSCmd(guildid, charid, job)
  local msg = GuildSCmd_pb.JobUpdateGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if job ~= nil and job.job ~= nil then
    msg.job.job = job.job
  end
  if job ~= nil and job.name ~= nil then
    msg.job.name = job.name
  end
  if job ~= nil and job.auth ~= nil then
    msg.job.auth = job.auth
  end
  if job ~= nil and job.editauth ~= nil then
    msg.job.editauth = job.editauth
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildMusicDeleteGuildSCmd(guildid)
  local msg = GuildSCmd_pb.GuildMusicDeleteGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallRenameNTFGuildCmd(user, newname, result)
  local msg = GuildSCmd_pb.RenameNTFGuildCmd()
  if user ~= nil and user.accid ~= nil then
    msg.user.accid = user.accid
  end
  if user ~= nil and user.charid ~= nil then
    msg.user.charid = user.charid
  end
  if user ~= nil and user.zoneid ~= nil then
    msg.user.zoneid = user.zoneid
  end
  if user ~= nil and user.mapid ~= nil then
    msg.user.mapid = user.mapid
  end
  if user ~= nil and user.baselv ~= nil then
    msg.user.baselv = user.baselv
  end
  if user ~= nil and user.profession ~= nil then
    msg.user.profession = user.profession
  end
  if user ~= nil and user.name ~= nil then
    msg.user.name = user.name
  end
  if user ~= nil and user.guildid ~= nil then
    msg.user.guildid = user.guildid
  end
  if newname ~= nil then
    msg.newname = newname
  end
  if result ~= nil then
    msg.result = result
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildCityActionGuildSCmd(action, status, result, zoneid, scenename, infos)
  local msg = GuildSCmd_pb.GuildCityActionGuildSCmd()
  if action ~= nil then
    msg.action = action
  end
  if status ~= nil then
    msg.status = status
  end
  if result ~= nil then
    msg.result = result
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallSendMailGuildSCmd(data)
  local msg = GuildSCmd_pb.SendMailGuildSCmd()
  if data ~= nil and data.id ~= nil then
    msg.data.id = data.id
  end
  if data ~= nil and data.sysid ~= nil then
    msg.data.sysid = data.sysid
  end
  if data ~= nil and data.senderid ~= nil then
    msg.data.senderid = data.senderid
  end
  if data ~= nil and data.receiveid ~= nil then
    msg.data.receiveid = data.receiveid
  end
  if data ~= nil and data.receiveaccid ~= nil then
    msg.data.receiveaccid = data.receiveaccid
  end
  if data ~= nil and data.time ~= nil then
    msg.data.time = data.time
  end
  if data ~= nil and data.mailid ~= nil then
    msg.data.mailid = data.mailid
  end
  if data ~= nil and data.type ~= nil then
    msg.data.type = data.type
  end
  if data ~= nil and data.status ~= nil then
    msg.data.status = data.status
  end
  if data ~= nil and data.title ~= nil then
    msg.data.title = data.title
  end
  if data ~= nil and data.sender ~= nil then
    msg.data.sender = data.sender
  end
  if data ~= nil and data.msg ~= nil then
    msg.data.msg = data.msg
  end
  if data ~= nil and data.attach.attachs ~= nil then
    for i = 1, #data.attach.attachs do
      table.insert(msg.data.attach.attachs, data.attach.attachs[i])
    end
  end
  if data ~= nil and data.groupid ~= nil then
    msg.data.groupid = data.groupid
  end
  if data ~= nil and data.starttime ~= nil then
    msg.data.starttime = data.starttime
  end
  if data ~= nil and data.endtime ~= nil then
    msg.data.endtime = data.endtime
  end
  if data.weddingmsg ~= nil and data.weddingmsg.cmd ~= nil then
    msg.data.weddingmsg.cmd = data.weddingmsg.cmd
  end
  if data.weddingmsg ~= nil and data.weddingmsg.param ~= nil then
    msg.data.weddingmsg.param = data.weddingmsg.param
  end
  if data.weddingmsg ~= nil and data.weddingmsg.charid ~= nil then
    msg.data.weddingmsg.charid = data.weddingmsg.charid
  end
  if data.weddingmsg ~= nil and data.weddingmsg.event ~= nil then
    msg.data.weddingmsg.event = data.weddingmsg.event
  end
  if data.weddingmsg ~= nil and data.weddingmsg.id ~= nil then
    msg.data.weddingmsg.id = data.weddingmsg.id
  end
  if data.weddingmsg ~= nil and data.weddingmsg.charid1 ~= nil then
    msg.data.weddingmsg.charid1 = data.weddingmsg.charid1
  end
  if data.weddingmsg ~= nil and data.weddingmsg.charid2 ~= nil then
    msg.data.weddingmsg.charid2 = data.weddingmsg.charid2
  end
  if data.weddingmsg ~= nil and data.weddingmsg.msg ~= nil then
    msg.data.weddingmsg.msg = data.weddingmsg.msg
  end
  if data.weddingmsg ~= nil and data.weddingmsg.opt_charid ~= nil then
    msg.data.weddingmsg.opt_charid = data.weddingmsg.opt_charid
  end
  if data.eventmsg ~= nil and data.eventmsg.cmd ~= nil then
    msg.data.eventmsg.cmd = data.eventmsg.cmd
  end
  if data.eventmsg ~= nil and data.eventmsg.param ~= nil then
    msg.data.eventmsg.param = data.eventmsg.param
  end
  if data.eventmsg ~= nil and data.eventmsg.eType ~= nil then
    msg.data.eventmsg.eType = data.eventmsg.eType
  end
  if data ~= nil and data.eventmsg.param32 ~= nil then
    for i = 1, #data.eventmsg.param32 do
      table.insert(msg.data.eventmsg.param32, data.eventmsg.param32[i])
    end
  end
  if data ~= nil and data.eventmsg.param64 ~= nil then
    for i = 1, #data.eventmsg.param64 do
      table.insert(msg.data.eventmsg.param64, data.eventmsg.param64[i])
    end
  end
  if data ~= nil and data.sendtime ~= nil then
    msg.data.sendtime = data.sendtime
  end
  if data ~= nil and data.expiretime ~= nil then
    msg.data.expiretime = data.expiretime
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGVGRewardGuildSCmd(guildid)
  local msg = GuildSCmd_pb.GVGRewardGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildPrayGuildSCmd(user, npcid, prayid)
  local msg = GuildSCmd_pb.GuildPrayGuildSCmd()
  if user ~= nil and user.accid ~= nil then
    msg.user.accid = user.accid
  end
  if user ~= nil and user.charid ~= nil then
    msg.user.charid = user.charid
  end
  if user ~= nil and user.zoneid ~= nil then
    msg.user.zoneid = user.zoneid
  end
  if user ~= nil and user.mapid ~= nil then
    msg.user.mapid = user.mapid
  end
  if user ~= nil and user.baselv ~= nil then
    msg.user.baselv = user.baselv
  end
  if user ~= nil and user.profession ~= nil then
    msg.user.profession = user.profession
  end
  if user ~= nil and user.name ~= nil then
    msg.user.name = user.name
  end
  if user ~= nil and user.guildid ~= nil then
    msg.user.guildid = user.guildid
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if prayid ~= nil then
    msg.prayid = prayid
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildIconStateGuildSCmd(ids, state)
  local msg = GuildSCmd_pb.GuildIconStateGuildSCmd()
  if ids ~= nil then
    for i = 1, #ids do
      table.insert(msg.ids, ids[i])
    end
  end
  if state ~= nil then
    msg.state = state
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallSubmitMaterialGuildSCmd(charid, building, materials, submitcount, counter, success, curlevel, submitinc)
  local msg = GuildSCmd_pb.SubmitMaterialGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if building ~= nil then
    msg.building = building
  end
  if materials ~= nil then
    for i = 1, #materials do
      table.insert(msg.materials, materials[i])
    end
  end
  if submitcount ~= nil then
    msg.submitcount = submitcount
  end
  if counter ~= nil then
    msg.counter = counter
  end
  if success ~= nil then
    msg.success = success
  end
  if curlevel ~= nil then
    msg.curlevel = curlevel
  end
  if submitinc ~= nil then
    msg.submitinc = submitinc
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallBuildingUpdateGuildSCmd(guildid, sceneid, updates, charid)
  local msg = GuildSCmd_pb.BuildingUpdateGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallQueryGuildInfoGuildSCmd(guildid, sceneid, info, result)
  local msg = GuildSCmd_pb.QueryGuildInfoGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if info ~= nil and info.id ~= nil then
    msg.info.id = info.id
  end
  if info ~= nil and info.zoneid ~= nil then
    msg.info.zoneid = info.zoneid
  end
  if info ~= nil and info.lv ~= nil then
    msg.info.lv = info.lv
  end
  if info ~= nil and info.scene ~= nil then
    msg.info.scene = info.scene
  end
  if info ~= nil and info.auth ~= nil then
    msg.info.auth = info.auth
  end
  if info ~= nil and info.average ~= nil then
    msg.info.average = info.average
  end
  if info ~= nil and info.createtime ~= nil then
    msg.info.createtime = info.createtime
  end
  if info ~= nil and info.create ~= nil then
    msg.info.create = info.create
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.portrait ~= nil then
    msg.info.portrait = info.portrait
  end
  if info ~= nil and info.jobname ~= nil then
    msg.info.jobname = info.jobname
  end
  if info ~= nil and info.members ~= nil then
    for i = 1, #info.members do
      table.insert(msg.info.members, info.members[i])
    end
  end
  if info ~= nil and info.quests ~= nil then
    for i = 1, #info.quests do
      table.insert(msg.info.quests, info.quests[i])
    end
  end
  if info ~= nil and info.building.buildings ~= nil then
    for i = 1, #info.building.buildings do
      table.insert(msg.info.building.buildings, info.building.buildings[i])
    end
  end
  if info.building ~= nil and info.building.version ~= nil then
    msg.info.building.version = info.building.version
  end
  if info ~= nil and info.openfunction ~= nil then
    msg.info.openfunction = info.openfunction
  end
  if info ~= nil and info.challenges ~= nil then
    for i = 1, #info.challenges do
      table.insert(msg.info.challenges, info.challenges[i])
    end
  end
  if info ~= nil and info.artifactitems ~= nil then
    for i = 1, #info.artifactitems do
      table.insert(msg.info.artifactitems, info.artifactitems[i])
    end
  end
  if info ~= nil and info.artifacequest.submitids ~= nil then
    for i = 1, #info.artifacequest.submitids do
      table.insert(msg.info.artifacequest.submitids, info.artifacequest.submitids[i])
    end
  end
  if info ~= nil and info.artifacequest.datas ~= nil then
    for i = 1, #info.artifacequest.datas do
      table.insert(msg.info.artifacequest.datas, info.artifacequest.datas[i])
    end
  end
  if info.gvg ~= nil and info.gvg.insupergvg ~= nil then
    msg.info.gvg.insupergvg = info.gvg.insupergvg
  end
  if result ~= nil then
    msg.result = result
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallSendWelfareGuildSCmd(charid, items)
  local msg = GuildSCmd_pb.SendWelfareGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallChallengeProgressGuildSCmd(guildid, charid, items)
  local msg = GuildSCmd_pb.ChallengeProgressGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGMCommandGuildSCmd(info, command)
  local msg = GuildSCmd_pb.GMCommandGuildSCmd()
  if info ~= nil and info.zoneid ~= nil then
    msg.info.zoneid = info.zoneid
  end
  if info ~= nil and info.sessionid ~= nil then
    msg.info.sessionid = info.sessionid
  end
  if info ~= nil and info.guildid ~= nil then
    msg.info.guildid = info.guildid
  end
  if info ~= nil and info.charid ~= nil then
    msg.info.charid = info.charid
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.accid ~= nil then
    msg.info.accid = info.accid
  end
  if command ~= nil then
    msg.command = command
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGMCommandRespondGuildSCmd(info)
  local msg = GuildSCmd_pb.GMCommandRespondGuildSCmd()
  if info ~= nil and info.zoneid ~= nil then
    msg.info.zoneid = info.zoneid
  end
  if info ~= nil and info.sessionid ~= nil then
    msg.info.sessionid = info.sessionid
  end
  if info ~= nil and info.guildid ~= nil then
    msg.info.guildid = info.guildid
  end
  if info ~= nil and info.charid ~= nil then
    msg.info.charid = info.charid
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.accid ~= nil then
    msg.info.accid = info.accid
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallBuildingEffectGuildSCmd(charid)
  local msg = GuildSCmd_pb.BuildingEffectGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallArtifactUpdateGuildSCmd(charid, guildid, sceneid, itemupdates, itemdels)
  local msg = GuildSCmd_pb.ArtifactUpdateGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if itemupdates ~= nil then
    for i = 1, #itemupdates do
      table.insert(msg.itemupdates, itemupdates[i])
    end
  end
  if itemdels ~= nil then
    for i = 1, #itemdels do
      table.insert(msg.itemdels, itemdels[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildArtifactQuestGuildSCmd(charid, quest)
  local msg = GuildSCmd_pb.GuildArtifactQuestGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if quest ~= nil and quest.submitids ~= nil then
    for i = 1, #quest.submitids do
      table.insert(msg.quest.submitids, quest.submitids[i])
    end
  end
  if quest ~= nil and quest.datas ~= nil then
    for i = 1, #quest.datas do
      table.insert(msg.quest.datas, quest.datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallQueryTreasureGuildSCmd(guildid, sceneid, result, treasures, bcoin_count, asset_count)
  local msg = GuildSCmd_pb.QueryTreasureGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if result ~= nil then
    msg.result = result
  end
  if treasures ~= nil then
    for i = 1, #treasures do
      table.insert(msg.treasures, treasures[i])
    end
  end
  if bcoin_count ~= nil then
    msg.bcoin_count = bcoin_count
  end
  if asset_count ~= nil then
    msg.asset_count = asset_count
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGvgUserPartInGuildSCmd(guildid, charid)
  local msg = GuildSCmd_pb.GvgUserPartInGuildSCmd()
  msg.guildid = guildid
  msg.charid = charid
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallTreasureResultNtfGuildSCmd(charid, result)
  local msg = GuildSCmd_pb.TreasureResultNtfGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if result ~= nil and result.ownerid ~= nil then
    msg.result.ownerid = result.ownerid
  end
  if result ~= nil and result.eventguid ~= nil then
    msg.result.eventguid = result.eventguid
  end
  if result ~= nil and result.treasureid ~= nil then
    msg.result.treasureid = result.treasureid
  end
  if result ~= nil and result.totalmember ~= nil then
    msg.result.totalmember = result.totalmember
  end
  if result ~= nil and result.state ~= nil then
    msg.result.state = result.state
  end
  if result ~= nil and result.items ~= nil then
    for i = 1, #result.items do
      table.insert(msg.result.items, result.items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallUpdateCityStateGuildSCmd(infos)
  local msg = GuildSCmd_pb.UpdateCityStateGuildSCmd()
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGvgOpenToServerGuildSCmd(fire)
  local msg = GuildSCmd_pb.GvgOpenToServerGuildSCmd()
  if fire ~= nil then
    msg.fire = fire
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallShopBuyItemGuildSCmd(charid, id, count)
  local msg = GuildSCmd_pb.ShopBuyItemGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  if count ~= nil then
    msg.count = count
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallJoinSuperGvgGuildSCmd(guildid, supergvgtime)
  local msg = GuildSCmd_pb.JoinSuperGvgGuildSCmd()
  msg.guildid = guildid
  if supergvgtime ~= nil then
    msg.supergvgtime = supergvgtime
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallEndSuperGvgGuildSCmd(guildid, rank)
  local msg = GuildSCmd_pb.EndSuperGvgGuildSCmd()
  msg.guildid = guildid
  msg.rank = rank
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallUpdateCityGuildSCmd(guildid, cityid, add)
  local msg = GuildSCmd_pb.UpdateCityGuildSCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if cityid ~= nil then
    msg.cityid = cityid
  end
  if add ~= nil then
    msg.add = add
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGvgResultGuildSCmd(infos)
  local msg = GuildSCmd_pb.GvgResultGuildSCmd()
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildBrocastMailGuildSCmd(guildid, mailid, items)
  local msg = GuildSCmd_pb.GuildBrocastMailGuildSCmd()
  msg.guildid = guildid
  if mailid ~= nil then
    msg.mailid = mailid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallGuildBrocastMsgGuildSCmd(guildid, msgid, params)
  local msg = GuildSCmd_pb.GuildBrocastMsgGuildSCmd()
  msg.guildid = guildid
  msg.msgid = msgid
  if params ~= nil then
    for i = 1, #params do
      table.insert(msg.params, params[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallBuyMaterialItemGuildSCmd(charid, guildid, zoneid, shopid, count, ret)
  local msg = GuildSCmd_pb.BuyMaterialItemGuildSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if shopid ~= nil then
    msg.shopid = shopid
  end
  if count ~= nil then
    msg.count = count
  end
  if ret ~= nil then
    msg.ret = ret
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:CallQueryGuildListGuildSCmd(user, result)
  local msg = GuildSCmd_pb.QueryGuildListGuildSCmd()
  if user ~= nil and user.accid ~= nil then
    msg.user.accid = user.accid
  end
  if user ~= nil and user.charid ~= nil then
    msg.user.charid = user.charid
  end
  if user ~= nil and user.zoneid ~= nil then
    msg.user.zoneid = user.zoneid
  end
  if user ~= nil and user.mapid ~= nil then
    msg.user.mapid = user.mapid
  end
  if user ~= nil and user.baselv ~= nil then
    msg.user.baselv = user.baselv
  end
  if user ~= nil and user.profession ~= nil then
    msg.user.profession = user.profession
  end
  if user ~= nil and user.name ~= nil then
    msg.user.name = user.name
  end
  if user ~= nil and user.guildid ~= nil then
    msg.user.guildid = user.guildid
  end
  if result ~= nil and result.cmd ~= nil then
    msg.result.cmd = result.cmd
  end
  if result ~= nil and result.param ~= nil then
    msg.result.param = result.param
  end
  if result ~= nil and result.keyword ~= nil then
    msg.result.keyword = result.keyword
  end
  if result ~= nil and result.page ~= nil then
    msg.result.page = result.page
  end
  if result ~= nil and result.list ~= nil then
    for i = 1, #result.list do
      table.insert(msg.result.list, result.list[i])
    end
  end
  self:SendProto(msg)
end
function ServiceGuildSCmdAutoProxy:RecvUserGuildInfoSyncGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdUserGuildInfoSyncGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvChatSyncGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdChatSyncGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvLoadLuaGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdLoadLuaGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvTransDataGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdTransDataGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildInfoSyncGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildInfoSyncGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildDataUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildDataUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvCityDataUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdCityDataUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildMemberUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildMemberUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildMemberDataUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildMemberDataUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvEnterGuildTerritoryGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdEnterGuildTerritoryGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvQueryPhotoListGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdQueryPhotoListGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvQueryUserPhotoListGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdQueryUserPhotoListGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvQueryShowPhotoGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdQueryShowPhotoGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvFrameUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdFrameUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvPhotoUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdPhotoUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvJobUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdJobUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildMusicDeleteGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildMusicDeleteGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvRenameNTFGuildCmd(data)
  self:Notify(ServiceEvent.GuildSCmdRenameNTFGuildCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildCityActionGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildCityActionGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvSendMailGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdSendMailGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGVGRewardGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGVGRewardGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildPrayGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildPrayGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildIconStateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildIconStateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvSubmitMaterialGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdSubmitMaterialGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvBuildingUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdBuildingUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvQueryGuildInfoGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdQueryGuildInfoGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvSendWelfareGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdSendWelfareGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvChallengeProgressGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdChallengeProgressGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGMCommandGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGMCommandGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGMCommandRespondGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGMCommandRespondGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvBuildingEffectGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdBuildingEffectGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvArtifactUpdateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdArtifactUpdateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildArtifactQuestGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildArtifactQuestGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvQueryTreasureGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdQueryTreasureGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGvgUserPartInGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGvgUserPartInGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvTreasureResultNtfGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdTreasureResultNtfGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvUpdateCityStateGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdUpdateCityStateGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGvgOpenToServerGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGvgOpenToServerGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvShopBuyItemGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdShopBuyItemGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvJoinSuperGvgGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdJoinSuperGvgGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvEndSuperGvgGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdEndSuperGvgGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvUpdateCityGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdUpdateCityGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGvgResultGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGvgResultGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildBrocastMailGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildBrocastMailGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvGuildBrocastMsgGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdGuildBrocastMsgGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvBuyMaterialItemGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdBuyMaterialItemGuildSCmd, data)
end
function ServiceGuildSCmdAutoProxy:RecvQueryGuildListGuildSCmd(data)
  self:Notify(ServiceEvent.GuildSCmdQueryGuildListGuildSCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.GuildSCmdUserGuildInfoSyncGuildSCmd = "ServiceEvent_GuildSCmdUserGuildInfoSyncGuildSCmd"
ServiceEvent.GuildSCmdChatSyncGuildSCmd = "ServiceEvent_GuildSCmdChatSyncGuildSCmd"
ServiceEvent.GuildSCmdLoadLuaGuildSCmd = "ServiceEvent_GuildSCmdLoadLuaGuildSCmd"
ServiceEvent.GuildSCmdTransDataGuildSCmd = "ServiceEvent_GuildSCmdTransDataGuildSCmd"
ServiceEvent.GuildSCmdGuildInfoSyncGuildSCmd = "ServiceEvent_GuildSCmdGuildInfoSyncGuildSCmd"
ServiceEvent.GuildSCmdGuildDataUpdateGuildSCmd = "ServiceEvent_GuildSCmdGuildDataUpdateGuildSCmd"
ServiceEvent.GuildSCmdCityDataUpdateGuildSCmd = "ServiceEvent_GuildSCmdCityDataUpdateGuildSCmd"
ServiceEvent.GuildSCmdGuildMemberUpdateGuildSCmd = "ServiceEvent_GuildSCmdGuildMemberUpdateGuildSCmd"
ServiceEvent.GuildSCmdGuildMemberDataUpdateGuildSCmd = "ServiceEvent_GuildSCmdGuildMemberDataUpdateGuildSCmd"
ServiceEvent.GuildSCmdEnterGuildTerritoryGuildSCmd = "ServiceEvent_GuildSCmdEnterGuildTerritoryGuildSCmd"
ServiceEvent.GuildSCmdQueryPhotoListGuildSCmd = "ServiceEvent_GuildSCmdQueryPhotoListGuildSCmd"
ServiceEvent.GuildSCmdQueryUserPhotoListGuildSCmd = "ServiceEvent_GuildSCmdQueryUserPhotoListGuildSCmd"
ServiceEvent.GuildSCmdQueryShowPhotoGuildSCmd = "ServiceEvent_GuildSCmdQueryShowPhotoGuildSCmd"
ServiceEvent.GuildSCmdFrameUpdateGuildSCmd = "ServiceEvent_GuildSCmdFrameUpdateGuildSCmd"
ServiceEvent.GuildSCmdPhotoUpdateGuildSCmd = "ServiceEvent_GuildSCmdPhotoUpdateGuildSCmd"
ServiceEvent.GuildSCmdJobUpdateGuildSCmd = "ServiceEvent_GuildSCmdJobUpdateGuildSCmd"
ServiceEvent.GuildSCmdGuildMusicDeleteGuildSCmd = "ServiceEvent_GuildSCmdGuildMusicDeleteGuildSCmd"
ServiceEvent.GuildSCmdRenameNTFGuildCmd = "ServiceEvent_GuildSCmdRenameNTFGuildCmd"
ServiceEvent.GuildSCmdGuildCityActionGuildSCmd = "ServiceEvent_GuildSCmdGuildCityActionGuildSCmd"
ServiceEvent.GuildSCmdSendMailGuildSCmd = "ServiceEvent_GuildSCmdSendMailGuildSCmd"
ServiceEvent.GuildSCmdGVGRewardGuildSCmd = "ServiceEvent_GuildSCmdGVGRewardGuildSCmd"
ServiceEvent.GuildSCmdGuildPrayGuildSCmd = "ServiceEvent_GuildSCmdGuildPrayGuildSCmd"
ServiceEvent.GuildSCmdGuildIconStateGuildSCmd = "ServiceEvent_GuildSCmdGuildIconStateGuildSCmd"
ServiceEvent.GuildSCmdSubmitMaterialGuildSCmd = "ServiceEvent_GuildSCmdSubmitMaterialGuildSCmd"
ServiceEvent.GuildSCmdBuildingUpdateGuildSCmd = "ServiceEvent_GuildSCmdBuildingUpdateGuildSCmd"
ServiceEvent.GuildSCmdQueryGuildInfoGuildSCmd = "ServiceEvent_GuildSCmdQueryGuildInfoGuildSCmd"
ServiceEvent.GuildSCmdSendWelfareGuildSCmd = "ServiceEvent_GuildSCmdSendWelfareGuildSCmd"
ServiceEvent.GuildSCmdChallengeProgressGuildSCmd = "ServiceEvent_GuildSCmdChallengeProgressGuildSCmd"
ServiceEvent.GuildSCmdGMCommandGuildSCmd = "ServiceEvent_GuildSCmdGMCommandGuildSCmd"
ServiceEvent.GuildSCmdGMCommandRespondGuildSCmd = "ServiceEvent_GuildSCmdGMCommandRespondGuildSCmd"
ServiceEvent.GuildSCmdBuildingEffectGuildSCmd = "ServiceEvent_GuildSCmdBuildingEffectGuildSCmd"
ServiceEvent.GuildSCmdArtifactUpdateGuildSCmd = "ServiceEvent_GuildSCmdArtifactUpdateGuildSCmd"
ServiceEvent.GuildSCmdGuildArtifactQuestGuildSCmd = "ServiceEvent_GuildSCmdGuildArtifactQuestGuildSCmd"
ServiceEvent.GuildSCmdQueryTreasureGuildSCmd = "ServiceEvent_GuildSCmdQueryTreasureGuildSCmd"
ServiceEvent.GuildSCmdGvgUserPartInGuildSCmd = "ServiceEvent_GuildSCmdGvgUserPartInGuildSCmd"
ServiceEvent.GuildSCmdTreasureResultNtfGuildSCmd = "ServiceEvent_GuildSCmdTreasureResultNtfGuildSCmd"
ServiceEvent.GuildSCmdUpdateCityStateGuildSCmd = "ServiceEvent_GuildSCmdUpdateCityStateGuildSCmd"
ServiceEvent.GuildSCmdGvgOpenToServerGuildSCmd = "ServiceEvent_GuildSCmdGvgOpenToServerGuildSCmd"
ServiceEvent.GuildSCmdShopBuyItemGuildSCmd = "ServiceEvent_GuildSCmdShopBuyItemGuildSCmd"
ServiceEvent.GuildSCmdJoinSuperGvgGuildSCmd = "ServiceEvent_GuildSCmdJoinSuperGvgGuildSCmd"
ServiceEvent.GuildSCmdEndSuperGvgGuildSCmd = "ServiceEvent_GuildSCmdEndSuperGvgGuildSCmd"
ServiceEvent.GuildSCmdUpdateCityGuildSCmd = "ServiceEvent_GuildSCmdUpdateCityGuildSCmd"
ServiceEvent.GuildSCmdGvgResultGuildSCmd = "ServiceEvent_GuildSCmdGvgResultGuildSCmd"
ServiceEvent.GuildSCmdGuildBrocastMailGuildSCmd = "ServiceEvent_GuildSCmdGuildBrocastMailGuildSCmd"
ServiceEvent.GuildSCmdGuildBrocastMsgGuildSCmd = "ServiceEvent_GuildSCmdGuildBrocastMsgGuildSCmd"
ServiceEvent.GuildSCmdBuyMaterialItemGuildSCmd = "ServiceEvent_GuildSCmdBuyMaterialItemGuildSCmd"
ServiceEvent.GuildSCmdQueryGuildListGuildSCmd = "ServiceEvent_GuildSCmdQueryGuildListGuildSCmd"
