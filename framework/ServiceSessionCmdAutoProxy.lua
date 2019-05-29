ServiceSessionCmdAutoProxy = class("ServiceSessionCmdAutoProxy", ServiceProxy)
ServiceSessionCmdAutoProxy.Instance = nil
ServiceSessionCmdAutoProxy.NAME = "ServiceSessionCmdAutoProxy"
function ServiceSessionCmdAutoProxy:ctor(proxyName)
  if ServiceSessionCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionCmdAutoProxy.Instance = self
  end
end
function ServiceSessionCmdAutoProxy:Init()
end
function ServiceSessionCmdAutoProxy:onRegister()
  self:Listen(202, 1, function(data)
    self:RecvMapRegSessionCmd(data)
  end)
  self:Listen(202, 2, function(data)
    self:RecvCreateRaidMapSessionCmd(data)
  end)
  self:Listen(202, 3, function(data)
    self:RecvDeleteDMapSessionCmd(data)
  end)
  self:Listen(202, 4, function(data)
    self:RecvChangeSceneSessionCmd(data)
  end)
  self:Listen(202, 5, function(data)
    self:RecvChangeSceneResultSessionCmd(data)
  end)
  self:Listen(202, 6, function(data)
    self:RecvUserDataSync(data)
  end)
  self:Listen(202, 7, function(data)
    self:RecvQuestNtfListSessionCmd(data)
  end)
  self:Listen(202, 9, function(data)
    self:RecvGoToUserMapSessionCmd(data)
  end)
  self:Listen(202, 10, function(data)
    self:RecvLoadLuaSessionCmd(data)
  end)
  self:Listen(202, 72, function(data)
    self:RecvExecGMCmdSessionCmd(data)
  end)
  self:Listen(202, 13, function(data)
    self:RecvSceneTowerUpdate(data)
  end)
  self:Listen(202, TOWERINFO_GLOBALUPDATE, function(data)
    self:RecvTowerGlobalUpdateSessionCmd(data)
  end)
  self:Listen(202, 15, function(data)
    self:RecvTowerMonsterKill(data)
  end)
  self:Listen(202, 19, function(data)
    self:RecvSendMail(data)
  end)
  self:Listen(202, 21, function(data)
    self:RecvSessionSceneUserCmd(data)
  end)
  self:Listen(202, 20, function(data)
    self:RecvGetMailAttachSessionCmd(data)
  end)
  self:Listen(202, 22, function(data)
    self:RecvFollowerIDCheck(data)
  end)
  self:Listen(202, 23, function(data)
    self:RecvEvent(data)
  end)
  self:Listen(202, 11, function(data)
    self:RecvChatMsgSession(data)
  end)
  self:Listen(202, 24, function(data)
    self:RecvSetGlobalDaily(data)
  end)
  self:Listen(202, 28, function(data)
    self:RecvRefreshQuest(data)
  end)
  self:Listen(202, 25, function(data)
    self:RecvQuerySealTimer(data)
  end)
  self:Listen(202, 26, function(data)
    self:RecvDelSceneImage(data)
  end)
  self:Listen(202, 27, function(data)
    self:RecvSetTeamSeal(data)
  end)
  self:Listen(202, 29, function(data)
    self:RecvInviteHandsSessionCmd(data)
  end)
  self:Listen(202, 31, function(data)
    self:RecvUserLoginNtfSessionCmd(data)
  end)
  self:Listen(202, 32, function(data)
    self:RecvRefreshTower(data)
  end)
  self:Listen(202, 33, function(data)
    self:RecvNotifyLoginSessionCmd(data)
  end)
  self:Listen(202, 34, function(data)
    self:RecvErrSetUserDataSessionCmd(data)
  end)
  self:Listen(202, 35, function(data)
    self:RecvChangeSceneSingleSessionCmd(data)
  end)
  self:Listen(202, 36, function(data)
    self:RecvRegMapFailSessionCmd(data)
  end)
  self:Listen(202, 37, function(data)
    self:RecvRegMapOKSessionCmd(data)
  end)
  self:Listen(202, 38, function(data)
    self:RecvForwardUserSessionCmd(data)
  end)
  self:Listen(202, 39, function(data)
    self:RecvForwardUserSceneSessionCmd(data)
  end)
  self:Listen(202, 40, function(data)
    self:RecvForwardUserSessionSessionCmd(data)
  end)
  self:Listen(202, 41, function(data)
    self:RecvForwardUserSceneSvrSessionCmd(data)
  end)
  self:Listen(202, 50, function(data)
    self:RecvEnterGuildTerritorySessionCmd(data)
  end)
  self:Listen(202, 52, function(data)
    self:RecvSyncDojoSessionCmd(data)
  end)
  self:Listen(202, 54, function(data)
    self:RecvChargeSessionCmd(data)
  end)
  self:Listen(202, 55, function(data)
    self:RecvGagSessionCmd(data)
  end)
  self:Listen(202, 56, function(data)
    self:RecvLockSessionCmd(data)
  end)
  self:Listen(202, 59, function(data)
    self:RecvIteamImageSessionCmd(data)
  end)
  self:Listen(202, 60, function(data)
    self:RecvFerrisInviteSessionCmd(data)
  end)
  self:Listen(202, 61, function(data)
    self:RecvEnterFerrisReadySessionCmd(data)
  end)
  self:Listen(202, 62, function(data)
    self:RecvActivityTestAndSetSessionCmd(data)
  end)
  self:Listen(202, 63, function(data)
    self:RecvActivityStatusSessionCmd(data)
  end)
  self:Listen(202, 64, function(data)
    self:RecvChangeTeamSessionCmd(data)
  end)
  self:Listen(202, 65, function(data)
    self:RecvForwardRegionSessionCmd(data)
  end)
  self:Listen(202, 66, function(data)
    self:RecvBreakHandSessionCmd(data)
  end)
  self:Listen(202, 67, function(data)
    self:RecvActivityStopSessionCmd(data)
  end)
  self:Listen(202, 68, function(data)
    self:RecvWantedInfoSyncSessionCmd(data)
  end)
  self:Listen(202, 69, function(data)
    self:RecvQueryZoneStatusSessionCmd(data)
  end)
  self:Listen(202, 70, function(data)
    self:RecvSendMailFromScene(data)
  end)
  self:Listen(202, 71, function(data)
    self:RecvGetTradeLogSessionCmd(data)
  end)
  self:Listen(202, 73, function(data)
    self:RecvQuestRaidCloseSessionCmd(data)
  end)
  self:Listen(202, 75, function(data)
    self:RecvAuthorizeInfoSessionCmd(data)
  end)
  self:Listen(202, 74, function(data)
    self:RecvGuildRaidCloseSessionCmd(data)
  end)
  self:Listen(202, 76, function(data)
    self:RecvDeletePwdSessionCmd(data)
  end)
  self:Listen(202, 77, function(data)
    self:RecvGoBackSessionCmd(data)
  end)
  self:Listen(202, 78, function(data)
    self:RecvWantedQuestFinishCmd(data)
  end)
  self:Listen(202, 79, function(data)
    self:RecvAddOfflineItemSessionCmd(data)
  end)
  self:Listen(202, 81, function(data)
    self:RecvUpdateOperActivitySessionCmd(data)
  end)
  self:Listen(202, 82, function(data)
    self:RecvSyncShopSessionCmd(data)
  end)
  self:Listen(202, 87, function(data)
    self:RecvUpdateActivityEventSessionCmd(data)
  end)
  self:Listen(202, 88, function(data)
    self:RecvActivityEventNtfSessionCmd(data)
  end)
  self:Listen(202, 85, function(data)
    self:RecvLoveLetterSessionCmd(data)
  end)
  self:Listen(202, 86, function(data)
    self:RecvLoveLetterSendSessionCmd(data)
  end)
  self:Listen(202, 89, function(data)
    self:RecvUseItemCodeSessionCmd(data)
  end)
  self:Listen(202, 90, function(data)
    self:RecvReqUsedItemCodeSessionCmd(data)
  end)
  self:Listen(202, 91, function(data)
    self:RecvGlobalActivityStartSessionCmd(data)
  end)
  self:Listen(202, 92, function(data)
    self:RecvGlobalActivityStopSessionCmd(data)
  end)
  self:Listen(202, 93, function(data)
    self:RecvReqLotteryGiveSessionCmd(data)
  end)
  self:Listen(202, 95, function(data)
    self:RecvSyncOperateRewardSessionCmd(data)
  end)
  self:Listen(202, 96, function(data)
    self:RecvNotifyActivitySessionCmd(data)
  end)
  self:Listen(202, 98, function(data)
    self:RecvGiveRewardSessionCmd(data)
  end)
  self:Listen(202, 97, function(data)
    self:RecvWantedQuestSetCDSessionCmd(data)
  end)
  self:Listen(202, 100, function(data)
    self:RecvUserQuotaOperSessionCmd(data)
  end)
  self:Listen(202, 99, function(data)
    self:RecvSyncWorldLevelSessionCmd(data)
  end)
  self:Listen(202, 102, function(data)
    self:RecvUserEnterSceneSessionCmd(data)
  end)
  self:Listen(202, 101, function(data)
    self:RecvSyncUserVarSessionCmd(data)
  end)
  self:Listen(202, 103, function(data)
    self:RecvGoOriginalZoneSessionCmd(data)
  end)
  self:Listen(202, 104, function(data)
    self:RecvActivitySetSessionCmd(data)
  end)
end
function ServiceSessionCmdAutoProxy:CallMapRegSessionCmd(mapid, mapname, scenename, data)
  local msg = SessionCmd_pb.MapRegSessionCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if mapname ~= nil then
    msg.mapname = mapname
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if data ~= nil and data.raidid ~= nil then
    msg.data.raidid = data.raidid
  end
  if data ~= nil and data.index ~= nil then
    msg.data.index = data.index
  end
  if data ~= nil and data.charid ~= nil then
    msg.data.charid = data.charid
  end
  if data ~= nil and data.guildid ~= nil then
    msg.data.guildid = data.guildid
  end
  if data ~= nil and data.guildlv ~= nil then
    msg.data.guildlv = data.guildlv
  end
  if data ~= nil and data.teamid ~= nil then
    msg.data.teamid = data.teamid
  end
  if data ~= nil and data.restrict ~= nil then
    msg.data.restrict = data.restrict
  end
  if data ~= nil and data.memberlist ~= nil then
    for i = 1, #data.memberlist do
      table.insert(msg.data.memberlist, data.memberlist[i])
    end
  end
  if data.imagecenter ~= nil and data.imagecenter.x ~= nil then
    msg.data.imagecenter.x = data.imagecenter.x
  end
  if data.imagecenter ~= nil and data.imagecenter.y ~= nil then
    msg.data.imagecenter.y = data.imagecenter.y
  end
  if data.imagecenter ~= nil and data.imagecenter.z ~= nil then
    msg.data.imagecenter.z = data.imagecenter.z
  end
  if data ~= nil and data.imagerange ~= nil then
    msg.data.imagerange = data.imagerange
  end
  if data.enterpos ~= nil and data.enterpos.x ~= nil then
    msg.data.enterpos.x = data.enterpos.x
  end
  if data.enterpos ~= nil and data.enterpos.y ~= nil then
    msg.data.enterpos.y = data.enterpos.y
  end
  if data.enterpos ~= nil and data.enterpos.z ~= nil then
    msg.data.enterpos.z = data.enterpos.z
  end
  if data ~= nil and data.sealid ~= nil then
    msg.data.sealid = data.sealid
  end
  if data ~= nil and data.follow ~= nil then
    msg.data.follow = data.follow
  end
  if data ~= nil and data.dojoid ~= nil then
    msg.data.dojoid = data.dojoid
  end
  if data ~= nil and data.layer ~= nil then
    msg.data.layer = data.layer
  end
  if data ~= nil and data.guildraidindex ~= nil then
    msg.data.guildraidindex = data.guildraidindex
  end
  if data ~= nil and data.roomid ~= nil then
    msg.data.roomid = data.roomid
  end
  if data.guildinfo ~= nil and data.guildinfo.id ~= nil then
    msg.data.guildinfo.id = data.guildinfo.id
  end
  if data.guildinfo ~= nil and data.guildinfo.zoneid ~= nil then
    msg.data.guildinfo.zoneid = data.guildinfo.zoneid
  end
  if data.guildinfo ~= nil and data.guildinfo.lv ~= nil then
    msg.data.guildinfo.lv = data.guildinfo.lv
  end
  if data.guildinfo ~= nil and data.guildinfo.scene ~= nil then
    msg.data.guildinfo.scene = data.guildinfo.scene
  end
  if data.guildinfo ~= nil and data.guildinfo.auth ~= nil then
    msg.data.guildinfo.auth = data.guildinfo.auth
  end
  if data.guildinfo ~= nil and data.guildinfo.average ~= nil then
    msg.data.guildinfo.average = data.guildinfo.average
  end
  if data.guildinfo ~= nil and data.guildinfo.createtime ~= nil then
    msg.data.guildinfo.createtime = data.guildinfo.createtime
  end
  if data.guildinfo ~= nil and data.guildinfo.create ~= nil then
    msg.data.guildinfo.create = data.guildinfo.create
  end
  if data.guildinfo ~= nil and data.guildinfo.name ~= nil then
    msg.data.guildinfo.name = data.guildinfo.name
  end
  if data.guildinfo ~= nil and data.guildinfo.portrait ~= nil then
    msg.data.guildinfo.portrait = data.guildinfo.portrait
  end
  if data.guildinfo ~= nil and data.guildinfo.jobname ~= nil then
    msg.data.guildinfo.jobname = data.guildinfo.jobname
  end
  if data ~= nil and data.guildinfo.members ~= nil then
    for i = 1, #data.guildinfo.members do
      table.insert(msg.data.guildinfo.members, data.guildinfo.members[i])
    end
  end
  if data ~= nil and data.guildinfo.quests ~= nil then
    for i = 1, #data.guildinfo.quests do
      table.insert(msg.data.guildinfo.quests, data.guildinfo.quests[i])
    end
  end
  if data ~= nil and data.guildinfo.building.buildings ~= nil then
    for i = 1, #data.guildinfo.building.buildings do
      table.insert(msg.data.guildinfo.building.buildings, data.guildinfo.building.buildings[i])
    end
  end
  if data.guildinfo.building ~= nil and data.guildinfo.building.version ~= nil then
    msg.data.guildinfo.building.version = data.guildinfo.building.version
  end
  if data.guildinfo ~= nil and data.guildinfo.openfunction ~= nil then
    msg.data.guildinfo.openfunction = data.guildinfo.openfunction
  end
  if data ~= nil and data.guildinfo.challenges ~= nil then
    for i = 1, #data.guildinfo.challenges do
      table.insert(msg.data.guildinfo.challenges, data.guildinfo.challenges[i])
    end
  end
  if data ~= nil and data.guildinfo.artifactitems ~= nil then
    for i = 1, #data.guildinfo.artifactitems do
      table.insert(msg.data.guildinfo.artifactitems, data.guildinfo.artifactitems[i])
    end
  end
  if data ~= nil and data.guildinfo.artifacequest.submitids ~= nil then
    for i = 1, #data.guildinfo.artifacequest.submitids do
      table.insert(msg.data.guildinfo.artifacequest.submitids, data.guildinfo.artifacequest.submitids[i])
    end
  end
  if data ~= nil and data.guildinfo.artifacequest.datas ~= nil then
    for i = 1, #data.guildinfo.artifacequest.datas do
      table.insert(msg.data.guildinfo.artifacequest.datas, data.guildinfo.artifacequest.datas[i])
    end
  end
  if data.guildinfo.gvg ~= nil and data.guildinfo.gvg.insupergvg ~= nil then
    msg.data.guildinfo.gvg.insupergvg = data.guildinfo.gvg.insupergvg
  end
  if data ~= nil and data.npcid ~= nil then
    msg.data.npcid = data.npcid
  end
  if data ~= nil and data.nomonsterlayer ~= nil then
    msg.data.nomonsterlayer = data.nomonsterlayer
  end
  if data ~= nil and data.gomaptype ~= nil then
    msg.data.gomaptype = data.gomaptype
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallCreateRaidMapSessionCmd(data)
  local msg = SessionCmd_pb.CreateRaidMapSessionCmd()
  if data ~= nil and data.raidid ~= nil then
    msg.data.raidid = data.raidid
  end
  if data ~= nil and data.index ~= nil then
    msg.data.index = data.index
  end
  if data ~= nil and data.charid ~= nil then
    msg.data.charid = data.charid
  end
  if data ~= nil and data.guildid ~= nil then
    msg.data.guildid = data.guildid
  end
  if data ~= nil and data.guildlv ~= nil then
    msg.data.guildlv = data.guildlv
  end
  if data ~= nil and data.teamid ~= nil then
    msg.data.teamid = data.teamid
  end
  if data ~= nil and data.restrict ~= nil then
    msg.data.restrict = data.restrict
  end
  if data ~= nil and data.memberlist ~= nil then
    for i = 1, #data.memberlist do
      table.insert(msg.data.memberlist, data.memberlist[i])
    end
  end
  if data.imagecenter ~= nil and data.imagecenter.x ~= nil then
    msg.data.imagecenter.x = data.imagecenter.x
  end
  if data.imagecenter ~= nil and data.imagecenter.y ~= nil then
    msg.data.imagecenter.y = data.imagecenter.y
  end
  if data.imagecenter ~= nil and data.imagecenter.z ~= nil then
    msg.data.imagecenter.z = data.imagecenter.z
  end
  if data ~= nil and data.imagerange ~= nil then
    msg.data.imagerange = data.imagerange
  end
  if data.enterpos ~= nil and data.enterpos.x ~= nil then
    msg.data.enterpos.x = data.enterpos.x
  end
  if data.enterpos ~= nil and data.enterpos.y ~= nil then
    msg.data.enterpos.y = data.enterpos.y
  end
  if data.enterpos ~= nil and data.enterpos.z ~= nil then
    msg.data.enterpos.z = data.enterpos.z
  end
  if data ~= nil and data.sealid ~= nil then
    msg.data.sealid = data.sealid
  end
  if data ~= nil and data.follow ~= nil then
    msg.data.follow = data.follow
  end
  if data ~= nil and data.dojoid ~= nil then
    msg.data.dojoid = data.dojoid
  end
  if data ~= nil and data.layer ~= nil then
    msg.data.layer = data.layer
  end
  if data ~= nil and data.guildraidindex ~= nil then
    msg.data.guildraidindex = data.guildraidindex
  end
  if data ~= nil and data.roomid ~= nil then
    msg.data.roomid = data.roomid
  end
  if data.guildinfo ~= nil and data.guildinfo.id ~= nil then
    msg.data.guildinfo.id = data.guildinfo.id
  end
  if data.guildinfo ~= nil and data.guildinfo.zoneid ~= nil then
    msg.data.guildinfo.zoneid = data.guildinfo.zoneid
  end
  if data.guildinfo ~= nil and data.guildinfo.lv ~= nil then
    msg.data.guildinfo.lv = data.guildinfo.lv
  end
  if data.guildinfo ~= nil and data.guildinfo.scene ~= nil then
    msg.data.guildinfo.scene = data.guildinfo.scene
  end
  if data.guildinfo ~= nil and data.guildinfo.auth ~= nil then
    msg.data.guildinfo.auth = data.guildinfo.auth
  end
  if data.guildinfo ~= nil and data.guildinfo.average ~= nil then
    msg.data.guildinfo.average = data.guildinfo.average
  end
  if data.guildinfo ~= nil and data.guildinfo.createtime ~= nil then
    msg.data.guildinfo.createtime = data.guildinfo.createtime
  end
  if data.guildinfo ~= nil and data.guildinfo.create ~= nil then
    msg.data.guildinfo.create = data.guildinfo.create
  end
  if data.guildinfo ~= nil and data.guildinfo.name ~= nil then
    msg.data.guildinfo.name = data.guildinfo.name
  end
  if data.guildinfo ~= nil and data.guildinfo.portrait ~= nil then
    msg.data.guildinfo.portrait = data.guildinfo.portrait
  end
  if data.guildinfo ~= nil and data.guildinfo.jobname ~= nil then
    msg.data.guildinfo.jobname = data.guildinfo.jobname
  end
  if data ~= nil and data.guildinfo.members ~= nil then
    for i = 1, #data.guildinfo.members do
      table.insert(msg.data.guildinfo.members, data.guildinfo.members[i])
    end
  end
  if data ~= nil and data.guildinfo.quests ~= nil then
    for i = 1, #data.guildinfo.quests do
      table.insert(msg.data.guildinfo.quests, data.guildinfo.quests[i])
    end
  end
  if data ~= nil and data.guildinfo.building.buildings ~= nil then
    for i = 1, #data.guildinfo.building.buildings do
      table.insert(msg.data.guildinfo.building.buildings, data.guildinfo.building.buildings[i])
    end
  end
  if data.guildinfo.building ~= nil and data.guildinfo.building.version ~= nil then
    msg.data.guildinfo.building.version = data.guildinfo.building.version
  end
  if data.guildinfo ~= nil and data.guildinfo.openfunction ~= nil then
    msg.data.guildinfo.openfunction = data.guildinfo.openfunction
  end
  if data ~= nil and data.guildinfo.challenges ~= nil then
    for i = 1, #data.guildinfo.challenges do
      table.insert(msg.data.guildinfo.challenges, data.guildinfo.challenges[i])
    end
  end
  if data ~= nil and data.guildinfo.artifactitems ~= nil then
    for i = 1, #data.guildinfo.artifactitems do
      table.insert(msg.data.guildinfo.artifactitems, data.guildinfo.artifactitems[i])
    end
  end
  if data ~= nil and data.guildinfo.artifacequest.submitids ~= nil then
    for i = 1, #data.guildinfo.artifacequest.submitids do
      table.insert(msg.data.guildinfo.artifacequest.submitids, data.guildinfo.artifacequest.submitids[i])
    end
  end
  if data ~= nil and data.guildinfo.artifacequest.datas ~= nil then
    for i = 1, #data.guildinfo.artifacequest.datas do
      table.insert(msg.data.guildinfo.artifacequest.datas, data.guildinfo.artifacequest.datas[i])
    end
  end
  if data.guildinfo.gvg ~= nil and data.guildinfo.gvg.insupergvg ~= nil then
    msg.data.guildinfo.gvg.insupergvg = data.guildinfo.gvg.insupergvg
  end
  if data ~= nil and data.npcid ~= nil then
    msg.data.npcid = data.npcid
  end
  if data ~= nil and data.nomonsterlayer ~= nil then
    msg.data.nomonsterlayer = data.nomonsterlayer
  end
  if data ~= nil and data.gomaptype ~= nil then
    msg.data.gomaptype = data.gomaptype
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallDeleteDMapSessionCmd(mapid)
  local msg = SessionCmd_pb.DeleteDMapSessionCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallChangeSceneSessionCmd(mapid, charid, pos)
  local msg = SessionCmd_pb.ChangeSceneSessionCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if charid ~= nil then
    for i = 1, #charid do
      table.insert(msg.charid, charid[i])
    end
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallChangeSceneResultSessionCmd(mapid, charid, mapname, pos)
  local msg = SessionCmd_pb.ChangeSceneResultSessionCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if mapname ~= nil then
    msg.mapname = mapname
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallUserDataSync(id, x, y, z, datas, attrs)
  local msg = SessionCmd_pb.UserDataSync()
  if id ~= nil then
    msg.id = id
  end
  if x ~= nil then
    msg.x = x
  end
  if y ~= nil then
    msg.y = y
  end
  if z ~= nil then
    msg.z = z
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  if attrs ~= nil then
    for i = 1, #attrs do
      table.insert(msg.attrs, attrs[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallQuestNtfListSessionCmd(charid, ids)
  local msg = SessionCmd_pb.QuestNtfListSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if ids ~= nil then
    for i = 1, #ids do
      table.insert(msg.ids, ids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGoToUserMapSessionCmd(targetuserid, gotouserid)
  local msg = SessionCmd_pb.GoToUserMapSessionCmd()
  if targetuserid ~= nil then
    msg.targetuserid = targetuserid
  end
  if gotouserid ~= nil then
    msg.gotouserid = gotouserid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallLoadLuaSessionCmd(table, lua, log, serverid, allzone, load_type)
  local msg = SessionCmd_pb.LoadLuaSessionCmd()
  if table ~= nil then
    msg.table = table
  end
  if lua ~= nil then
    msg.lua = lua
  end
  if log ~= nil then
    msg.log = log
  end
  if serverid ~= nil then
    msg.serverid = serverid
  end
  if allzone ~= nil then
    msg.allzone = allzone
  end
  if load_type ~= nil then
    msg.load_type = load_type
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallExecGMCmdSessionCmd(serverid, gmcmd, allzone)
  local msg = SessionCmd_pb.ExecGMCmdSessionCmd()
  if serverid ~= nil then
    msg.serverid = serverid
  end
  if gmcmd ~= nil then
    msg.gmcmd = gmcmd
  end
  if allzone ~= nil then
    msg.allzone = allzone
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSceneTowerUpdate(info)
  local msg = SessionCmd_pb.SceneTowerUpdate()
  if info ~= nil and info.maxlayer ~= nil then
    msg.info.maxlayer = info.maxlayer
  end
  if info ~= nil and info.cleartime ~= nil then
    msg.info.cleartime = info.cleartime
  end
  if info ~= nil and info.killmonsters ~= nil then
    for i = 1, #info.killmonsters do
      table.insert(msg.info.killmonsters, info.killmonsters[i])
    end
  end
  if info ~= nil and info.layers ~= nil then
    for i = 1, #info.layers do
      table.insert(msg.info.layers, info.layers[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallTowerGlobalUpdateSessionCmd(info)
  local msg = SessionCmd_pb.TowerGlobalUpdateSessionCmd()
  if info ~= nil and info.maxlayer ~= nil then
    msg.info.maxlayer = info.maxlayer
  end
  if info ~= nil and info.cleartime ~= nil then
    msg.info.cleartime = info.cleartime
  end
  if info ~= nil and info.killmonsters ~= nil then
    for i = 1, #info.killmonsters do
      table.insert(msg.info.killmonsters, info.killmonsters[i])
    end
  end
  if info ~= nil and info.layers ~= nil then
    for i = 1, #info.layers do
      table.insert(msg.info.layers, info.layers[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallTowerMonsterKill(monsterid)
  local msg = SessionCmd_pb.TowerMonsterKill()
  if monsterid ~= nil then
    msg.monsterid = monsterid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSendMail(data)
  local msg = SessionCmd_pb.SendMail()
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
function ServiceSessionCmdAutoProxy:CallSessionSceneUserCmd(userid, cmddata)
  local msg = SessionCmd_pb.SessionSceneUserCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  if cmddata ~= nil then
    msg.cmddata = cmddata
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGetMailAttachSessionCmd(user, mailid, msgid, items, itemDatas, groupid, opt, realmailid, platformid, data)
  local msg = SessionCmd_pb.GetMailAttachSessionCmd()
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
  if mailid ~= nil then
    msg.mailid = mailid
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if itemDatas ~= nil then
    for i = 1, #itemDatas do
      table.insert(msg.itemDatas, itemDatas[i])
    end
  end
  if groupid ~= nil then
    msg.groupid = groupid
  end
  if opt ~= nil then
    msg.opt = opt
  end
  if realmailid ~= nil then
    msg.realmailid = realmailid
  end
  if platformid ~= nil then
    msg.platformid = platformid
  end
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
function ServiceSessionCmdAutoProxy:CallFollowerIDCheck(userid, followid, etype)
  local msg = SessionCmd_pb.FollowerIDCheck()
  if userid ~= nil then
    msg.userid = userid
  end
  if followid ~= nil then
    msg.followid = followid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallEvent(guid, type, params)
  local msg = SessionCmd_pb.Event()
  if guid ~= nil then
    msg.guid = guid
  end
  if type ~= nil then
    msg.type = type
  end
  if params ~= nil then
    for i = 1, #params do
      table.insert(msg.params, params[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallChatMsgSession(targetid, msg, channel, selfid, voice, voicetime, blink, msgid, msgover, barrage)
  local msg = SessionCmd_pb.ChatMsgSession()
  if targetid ~= nil then
    for i = 1, #targetid do
      table.insert(msg.targetid, targetid[i])
    end
  end
  if msg ~= nil then
    msg.msg = msg
  end
  if channel ~= nil then
    msg.channel = channel
  end
  if selfid ~= nil then
    msg.selfid = selfid
  end
  if voice ~= nil then
    msg.voice = voice
  end
  if voicetime ~= nil then
    msg.voicetime = voicetime
  end
  if blink ~= nil then
    msg.blink = blink
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if msgover ~= nil then
    msg.msgover = msgover
  end
  if barrage ~= nil and barrage.cmd ~= nil then
    msg.barrage.cmd = barrage.cmd
  end
  if barrage ~= nil and barrage.param ~= nil then
    msg.barrage.param = barrage.param
  end
  if barrage ~= nil and barrage.str ~= nil then
    msg.barrage.str = barrage.str
  end
  if barrage.msgpos ~= nil and barrage.msgpos.x ~= nil then
    msg.barrage.msgpos.x = barrage.msgpos.x
  end
  if barrage.msgpos ~= nil and barrage.msgpos.y ~= nil then
    msg.barrage.msgpos.y = barrage.msgpos.y
  end
  if barrage.msgpos ~= nil and barrage.msgpos.z ~= nil then
    msg.barrage.msgpos.z = barrage.msgpos.z
  end
  if barrage.clr ~= nil and barrage.clr.r ~= nil then
    msg.barrage.clr.r = barrage.clr.r
  end
  if barrage.clr ~= nil and barrage.clr.g ~= nil then
    msg.barrage.clr.g = barrage.clr.g
  end
  if barrage.clr ~= nil and barrage.clr.b ~= nil then
    msg.barrage.clr.b = barrage.clr.b
  end
  if barrage ~= nil and barrage.speed ~= nil then
    msg.barrage.speed = barrage.speed
  end
  if barrage ~= nil and barrage.userid ~= nil then
    msg.barrage.userid = barrage.userid
  end
  if barrage ~= nil and barrage.frame ~= nil then
    msg.barrage.frame = barrage.frame
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSetGlobalDaily(value)
  local msg = SessionCmd_pb.SetGlobalDaily()
  if value ~= nil then
    msg.value = value
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallRefreshQuest(value)
  local msg = SessionCmd_pb.RefreshQuest()
  if value ~= nil then
    msg.value = value
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallQuerySealTimer(userid, teamid)
  local msg = SessionCmd_pb.QuerySealTimer()
  msg.userid = userid
  msg.teamid = teamid
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallDelSceneImage(guid, realscene, etype, raid)
  local msg = SessionCmd_pb.DelSceneImage()
  if guid ~= nil then
    msg.guid = guid
  end
  if realscene ~= nil then
    msg.realscene = realscene
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if raid ~= nil then
    msg.raid = raid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSetTeamSeal(sealid, teamid, mapid, estatus, pos, leaderid, teamers)
  local msg = SessionCmd_pb.SetTeamSeal()
  if sealid ~= nil then
    msg.sealid = sealid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if estatus ~= nil then
    msg.estatus = estatus
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  if leaderid ~= nil then
    msg.leaderid = leaderid
  end
  if teamers ~= nil then
    for i = 1, #teamers do
      table.insert(msg.teamers, teamers[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallInviteHandsSessionCmd(charid, otherid)
  local msg = SessionCmd_pb.InviteHandsSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if otherid ~= nil then
    msg.otherid = otherid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallUserLoginNtfSessionCmd(charid, servername)
  local msg = SessionCmd_pb.UserLoginNtfSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if servername ~= nil then
    msg.servername = servername
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallRefreshTower()
  local msg = SessionCmd_pb.RefreshTower()
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallNotifyLoginSessionCmd(id, accid, mapid, ischangescene, name, gatename, phone, pushkey, ignorepwd, language, realauthorized, maxbaselv, clickpos)
  local msg = SessionCmd_pb.NotifyLoginSessionCmd()
  if id ~= nil then
    msg.id = id
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if ischangescene ~= nil then
    msg.ischangescene = ischangescene
  end
  if name ~= nil then
    msg.name = name
  end
  if gatename ~= nil then
    msg.gatename = gatename
  end
  if phone ~= nil then
    msg.phone = phone
  end
  if pushkey ~= nil then
    msg.pushkey = pushkey
  end
  if ignorepwd ~= nil then
    msg.ignorepwd = ignorepwd
  end
  if language ~= nil then
    msg.language = language
  end
  if realauthorized ~= nil then
    msg.realauthorized = realauthorized
  end
  if maxbaselv ~= nil then
    msg.maxbaselv = maxbaselv
  end
  if clickpos ~= nil then
    msg.clickpos = clickpos
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallErrSetUserDataSessionCmd(id)
  local msg = SessionCmd_pb.ErrSetUserDataSessionCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallChangeSceneSingleSessionCmd(charid, mapid)
  local msg = SessionCmd_pb.ChangeSceneSingleSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallRegMapFailSessionCmd(mapid)
  local msg = SessionCmd_pb.RegMapFailSessionCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallRegMapOKSessionCmd(mapid)
  local msg = SessionCmd_pb.RegMapOKSessionCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallForwardUserSessionCmd(charid, data)
  local msg = SessionCmd_pb.ForwardUserSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallForwardUserSceneSessionCmd(charid, data)
  local msg = SessionCmd_pb.ForwardUserSceneSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallForwardUserSessionSessionCmd(charid, data)
  local msg = SessionCmd_pb.ForwardUserSessionSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallForwardUserSceneSvrSessionCmd(charid, data)
  local msg = SessionCmd_pb.ForwardUserSceneSvrSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallEnterGuildTerritorySessionCmd(charid, targetid)
  local msg = SessionCmd_pb.EnterGuildTerritorySessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSyncDojoSessionCmd(teamguid, dojoid, sponsorid, isopen, guildid, del)
  local msg = SessionCmd_pb.SyncDojoSessionCmd()
  if teamguid ~= nil then
    msg.teamguid = teamguid
  end
  if dojoid ~= nil then
    msg.dojoid = dojoid
  end
  if sponsorid ~= nil then
    msg.sponsorid = sponsorid
  end
  if isopen ~= nil then
    msg.isopen = isopen
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if del ~= nil then
    msg.del = del
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallChargeSessionCmd(charid, charge, itemid, count, source, orderid, dataid)
  local msg = SessionCmd_pb.ChargeSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if charge ~= nil then
    msg.charge = charge
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if count ~= nil then
    msg.count = count
  end
  if source ~= nil then
    msg.source = source
  end
  if orderid ~= nil then
    msg.orderid = orderid
  end
  if dataid ~= nil then
    msg.dataid = dataid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGagSessionCmd(charid, time, reason)
  local msg = SessionCmd_pb.GagSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if time ~= nil then
    msg.time = time
  end
  if reason ~= nil then
    msg.reason = reason
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallLockSessionCmd(charid, time, reason, account)
  local msg = SessionCmd_pb.LockSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if time ~= nil then
    msg.time = time
  end
  if reason ~= nil then
    msg.reason = reason
  end
  if account ~= nil then
    msg.account = account
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallIteamImageSessionCmd(charid, teamid)
  local msg = SessionCmd_pb.IteamImageSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallFerrisInviteSessionCmd(charid, targetid, msgid, id)
  local msg = SessionCmd_pb.FerrisInviteSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallEnterFerrisReadySessionCmd(charid, msgid, id)
  local msg = SessionCmd_pb.EnterFerrisReadySessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallActivityTestAndSetSessionCmd(id, uid, mapid, starttime, charid, ret)
  local msg = SessionCmd_pb.ActivityTestAndSetSessionCmd()
  if id ~= nil then
    msg.id = id
  end
  if uid ~= nil then
    msg.uid = uid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if starttime ~= nil then
    msg.starttime = starttime
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if ret ~= nil then
    msg.ret = ret
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallActivityStatusSessionCmd(id, mapid, start)
  local msg = SessionCmd_pb.ActivityStatusSessionCmd()
  if id ~= nil then
    msg.id = id
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if start ~= nil then
    msg.start = start
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallChangeTeamSessionCmd(join, userid, teamid)
  local msg = SessionCmd_pb.ChangeTeamSessionCmd()
  if join ~= nil then
    msg.join = join
  end
  if userid ~= nil then
    msg.userid = userid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallForwardRegionSessionCmd(region_type, data, len)
  local msg = SessionCmd_pb.ForwardRegionSessionCmd()
  if region_type ~= nil then
    msg.region_type = region_type
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallBreakHandSessionCmd(userid)
  local msg = SessionCmd_pb.BreakHandSessionCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallActivityStopSessionCmd(id, uid, mapid)
  local msg = SessionCmd_pb.ActivityStopSessionCmd()
  if id ~= nil then
    msg.id = id
  end
  if uid ~= nil then
    msg.uid = uid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallWantedInfoSyncSessionCmd(active, maxcount)
  local msg = SessionCmd_pb.WantedInfoSyncSessionCmd()
  if active ~= nil then
    msg.active = active
  end
  if maxcount ~= nil then
    msg.maxcount = maxcount
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallQueryZoneStatusSessionCmd(charid, infos)
  local msg = SessionCmd_pb.QueryZoneStatusSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSendMailFromScene(data)
  local msg = SessionCmd_pb.SendMailFromScene()
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
function ServiceSessionCmdAutoProxy:CallGetTradeLogSessionCmd(charid, id, logtype, item, itemData, success, sell_item_id, sell_price, sell_count, refine_lv, ret_cost, trade_type, tax, quota, getmoney, retmoney)
  local msg = SessionCmd_pb.GetTradeLogSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if id ~= nil then
    msg.id = id
  end
  if logtype ~= nil then
    msg.logtype = logtype
  end
  if item ~= nil and item.guid ~= nil then
    msg.item.guid = item.guid
  end
  if item ~= nil and item.id ~= nil then
    msg.item.id = item.id
  end
  if item ~= nil and item.count ~= nil then
    msg.item.count = item.count
  end
  if item ~= nil and item.index ~= nil then
    msg.item.index = item.index
  end
  if item ~= nil and item.createtime ~= nil then
    msg.item.createtime = item.createtime
  end
  if item ~= nil and item.cd ~= nil then
    msg.item.cd = item.cd
  end
  if item ~= nil and item.type ~= nil then
    msg.item.type = item.type
  end
  if item ~= nil and item.bind ~= nil then
    msg.item.bind = item.bind
  end
  if item ~= nil and item.expire ~= nil then
    msg.item.expire = item.expire
  end
  if item ~= nil and item.quality ~= nil then
    msg.item.quality = item.quality
  end
  if item ~= nil and item.equipType ~= nil then
    msg.item.equipType = item.equipType
  end
  if item ~= nil and item.source ~= nil then
    msg.item.source = item.source
  end
  if item ~= nil and item.isnew ~= nil then
    msg.item.isnew = item.isnew
  end
  if item ~= nil and item.maxcardslot ~= nil then
    msg.item.maxcardslot = item.maxcardslot
  end
  if item ~= nil and item.ishint ~= nil then
    msg.item.ishint = item.ishint
  end
  if item ~= nil and item.isactive ~= nil then
    msg.item.isactive = item.isactive
  end
  if item ~= nil and item.source_npc ~= nil then
    msg.item.source_npc = item.source_npc
  end
  if item ~= nil and item.refinelv ~= nil then
    msg.item.refinelv = item.refinelv
  end
  if item ~= nil and item.chargemoney ~= nil then
    msg.item.chargemoney = item.chargemoney
  end
  if item ~= nil and item.overtime ~= nil then
    msg.item.overtime = item.overtime
  end
  if item ~= nil and item.quota ~= nil then
    msg.item.quota = item.quota
  end
  if item ~= nil and item.usedtimes ~= nil then
    msg.item.usedtimes = item.usedtimes
  end
  if item ~= nil and item.usedtime ~= nil then
    msg.item.usedtime = item.usedtime
  end
  if itemData.base ~= nil and itemData.base.guid ~= nil then
    msg.itemData.base.guid = itemData.base.guid
  end
  if itemData.base ~= nil and itemData.base.id ~= nil then
    msg.itemData.base.id = itemData.base.id
  end
  if itemData.base ~= nil and itemData.base.count ~= nil then
    msg.itemData.base.count = itemData.base.count
  end
  if itemData.base ~= nil and itemData.base.index ~= nil then
    msg.itemData.base.index = itemData.base.index
  end
  if itemData.base ~= nil and itemData.base.createtime ~= nil then
    msg.itemData.base.createtime = itemData.base.createtime
  end
  if itemData.base ~= nil and itemData.base.cd ~= nil then
    msg.itemData.base.cd = itemData.base.cd
  end
  if itemData.base ~= nil and itemData.base.type ~= nil then
    msg.itemData.base.type = itemData.base.type
  end
  if itemData.base ~= nil and itemData.base.bind ~= nil then
    msg.itemData.base.bind = itemData.base.bind
  end
  if itemData.base ~= nil and itemData.base.expire ~= nil then
    msg.itemData.base.expire = itemData.base.expire
  end
  if itemData.base ~= nil and itemData.base.quality ~= nil then
    msg.itemData.base.quality = itemData.base.quality
  end
  if itemData.base ~= nil and itemData.base.equipType ~= nil then
    msg.itemData.base.equipType = itemData.base.equipType
  end
  if itemData.base ~= nil and itemData.base.source ~= nil then
    msg.itemData.base.source = itemData.base.source
  end
  if itemData.base ~= nil and itemData.base.isnew ~= nil then
    msg.itemData.base.isnew = itemData.base.isnew
  end
  if itemData.base ~= nil and itemData.base.maxcardslot ~= nil then
    msg.itemData.base.maxcardslot = itemData.base.maxcardslot
  end
  if itemData.base ~= nil and itemData.base.ishint ~= nil then
    msg.itemData.base.ishint = itemData.base.ishint
  end
  if itemData.base ~= nil and itemData.base.isactive ~= nil then
    msg.itemData.base.isactive = itemData.base.isactive
  end
  if itemData.base ~= nil and itemData.base.source_npc ~= nil then
    msg.itemData.base.source_npc = itemData.base.source_npc
  end
  if itemData.base ~= nil and itemData.base.refinelv ~= nil then
    msg.itemData.base.refinelv = itemData.base.refinelv
  end
  if itemData.base ~= nil and itemData.base.chargemoney ~= nil then
    msg.itemData.base.chargemoney = itemData.base.chargemoney
  end
  if itemData.base ~= nil and itemData.base.overtime ~= nil then
    msg.itemData.base.overtime = itemData.base.overtime
  end
  if itemData.base ~= nil and itemData.base.quota ~= nil then
    msg.itemData.base.quota = itemData.base.quota
  end
  if itemData.base ~= nil and itemData.base.usedtimes ~= nil then
    msg.itemData.base.usedtimes = itemData.base.usedtimes
  end
  if itemData.base ~= nil and itemData.base.usedtime ~= nil then
    msg.itemData.base.usedtime = itemData.base.usedtime
  end
  if itemData ~= nil and itemData.equiped ~= nil then
    msg.itemData.equiped = itemData.equiped
  end
  if itemData ~= nil and itemData.battlepoint ~= nil then
    msg.itemData.battlepoint = itemData.battlepoint
  end
  if itemData.equip ~= nil and itemData.equip.strengthlv ~= nil then
    msg.itemData.equip.strengthlv = itemData.equip.strengthlv
  end
  if itemData.equip ~= nil and itemData.equip.refinelv ~= nil then
    msg.itemData.equip.refinelv = itemData.equip.refinelv
  end
  if itemData.equip ~= nil and itemData.equip.strengthCost ~= nil then
    msg.itemData.equip.strengthCost = itemData.equip.strengthCost
  end
  if itemData ~= nil and itemData.equip.refineCompose ~= nil then
    for i = 1, #itemData.equip.refineCompose do
      table.insert(msg.itemData.equip.refineCompose, itemData.equip.refineCompose[i])
    end
  end
  if itemData.equip ~= nil and itemData.equip.cardslot ~= nil then
    msg.itemData.equip.cardslot = itemData.equip.cardslot
  end
  if itemData ~= nil and itemData.equip.buffid ~= nil then
    for i = 1, #itemData.equip.buffid do
      table.insert(msg.itemData.equip.buffid, itemData.equip.buffid[i])
    end
  end
  if itemData.equip ~= nil and itemData.equip.damage ~= nil then
    msg.itemData.equip.damage = itemData.equip.damage
  end
  if itemData.equip ~= nil and itemData.equip.lv ~= nil then
    msg.itemData.equip.lv = itemData.equip.lv
  end
  if itemData.equip ~= nil and itemData.equip.color ~= nil then
    msg.itemData.equip.color = itemData.equip.color
  end
  if itemData.equip ~= nil and itemData.equip.breakstarttime ~= nil then
    msg.itemData.equip.breakstarttime = itemData.equip.breakstarttime
  end
  if itemData.equip ~= nil and itemData.equip.breakendtime ~= nil then
    msg.itemData.equip.breakendtime = itemData.equip.breakendtime
  end
  if itemData.equip ~= nil and itemData.equip.strengthlv2 ~= nil then
    msg.itemData.equip.strengthlv2 = itemData.equip.strengthlv2
  end
  if itemData ~= nil and itemData.equip.strengthlv2cost ~= nil then
    for i = 1, #itemData.equip.strengthlv2cost do
      table.insert(msg.itemData.equip.strengthlv2cost, itemData.equip.strengthlv2cost[i])
    end
  end
  if itemData ~= nil and itemData.card ~= nil then
    for i = 1, #itemData.card do
      table.insert(msg.itemData.card, itemData.card[i])
    end
  end
  if itemData.enchant ~= nil and itemData.enchant.type ~= nil then
    msg.itemData.enchant.type = itemData.enchant.type
  end
  if itemData ~= nil and itemData.enchant.attrs ~= nil then
    for i = 1, #itemData.enchant.attrs do
      table.insert(msg.itemData.enchant.attrs, itemData.enchant.attrs[i])
    end
  end
  if itemData ~= nil and itemData.enchant.extras ~= nil then
    for i = 1, #itemData.enchant.extras do
      table.insert(msg.itemData.enchant.extras, itemData.enchant.extras[i])
    end
  end
  if itemData ~= nil and itemData.enchant.patch ~= nil then
    for i = 1, #itemData.enchant.patch do
      table.insert(msg.itemData.enchant.patch, itemData.enchant.patch[i])
    end
  end
  if itemData.previewenchant ~= nil and itemData.previewenchant.type ~= nil then
    msg.itemData.previewenchant.type = itemData.previewenchant.type
  end
  if itemData ~= nil and itemData.previewenchant.attrs ~= nil then
    for i = 1, #itemData.previewenchant.attrs do
      table.insert(msg.itemData.previewenchant.attrs, itemData.previewenchant.attrs[i])
    end
  end
  if itemData ~= nil and itemData.previewenchant.extras ~= nil then
    for i = 1, #itemData.previewenchant.extras do
      table.insert(msg.itemData.previewenchant.extras, itemData.previewenchant.extras[i])
    end
  end
  if itemData ~= nil and itemData.previewenchant.patch ~= nil then
    for i = 1, #itemData.previewenchant.patch do
      table.insert(msg.itemData.previewenchant.patch, itemData.previewenchant.patch[i])
    end
  end
  if itemData.refine ~= nil and itemData.refine.lastfail ~= nil then
    msg.itemData.refine.lastfail = itemData.refine.lastfail
  end
  if itemData.refine ~= nil and itemData.refine.repaircount ~= nil then
    msg.itemData.refine.repaircount = itemData.refine.repaircount
  end
  if itemData.egg ~= nil and itemData.egg.exp ~= nil then
    msg.itemData.egg.exp = itemData.egg.exp
  end
  if itemData.egg ~= nil and itemData.egg.friendexp ~= nil then
    msg.itemData.egg.friendexp = itemData.egg.friendexp
  end
  if itemData.egg ~= nil and itemData.egg.rewardexp ~= nil then
    msg.itemData.egg.rewardexp = itemData.egg.rewardexp
  end
  if itemData.egg ~= nil and itemData.egg.id ~= nil then
    msg.itemData.egg.id = itemData.egg.id
  end
  if itemData.egg ~= nil and itemData.egg.lv ~= nil then
    msg.itemData.egg.lv = itemData.egg.lv
  end
  if itemData.egg ~= nil and itemData.egg.friendlv ~= nil then
    msg.itemData.egg.friendlv = itemData.egg.friendlv
  end
  if itemData.egg ~= nil and itemData.egg.body ~= nil then
    msg.itemData.egg.body = itemData.egg.body
  end
  if itemData.egg ~= nil and itemData.egg.relivetime ~= nil then
    msg.itemData.egg.relivetime = itemData.egg.relivetime
  end
  if itemData.egg ~= nil and itemData.egg.hp ~= nil then
    msg.itemData.egg.hp = itemData.egg.hp
  end
  if itemData.egg ~= nil and itemData.egg.restoretime ~= nil then
    msg.itemData.egg.restoretime = itemData.egg.restoretime
  end
  if itemData.egg ~= nil and itemData.egg.time_happly ~= nil then
    msg.itemData.egg.time_happly = itemData.egg.time_happly
  end
  if itemData.egg ~= nil and itemData.egg.time_excite ~= nil then
    msg.itemData.egg.time_excite = itemData.egg.time_excite
  end
  if itemData.egg ~= nil and itemData.egg.time_happiness ~= nil then
    msg.itemData.egg.time_happiness = itemData.egg.time_happiness
  end
  if itemData.egg ~= nil and itemData.egg.time_happly_gift ~= nil then
    msg.itemData.egg.time_happly_gift = itemData.egg.time_happly_gift
  end
  if itemData.egg ~= nil and itemData.egg.time_excite_gift ~= nil then
    msg.itemData.egg.time_excite_gift = itemData.egg.time_excite_gift
  end
  if itemData.egg ~= nil and itemData.egg.time_happiness_gift ~= nil then
    msg.itemData.egg.time_happiness_gift = itemData.egg.time_happiness_gift
  end
  if itemData.egg ~= nil and itemData.egg.touch_tick ~= nil then
    msg.itemData.egg.touch_tick = itemData.egg.touch_tick
  end
  if itemData.egg ~= nil and itemData.egg.feed_tick ~= nil then
    msg.itemData.egg.feed_tick = itemData.egg.feed_tick
  end
  if itemData.egg ~= nil and itemData.egg.name ~= nil then
    msg.itemData.egg.name = itemData.egg.name
  end
  if itemData.egg ~= nil and itemData.egg.var ~= nil then
    msg.itemData.egg.var = itemData.egg.var
  end
  if itemData ~= nil and itemData.egg.skillids ~= nil then
    for i = 1, #itemData.egg.skillids do
      table.insert(msg.itemData.egg.skillids, itemData.egg.skillids[i])
    end
  end
  if itemData ~= nil and itemData.egg.equips ~= nil then
    for i = 1, #itemData.egg.equips do
      table.insert(msg.itemData.egg.equips, itemData.egg.equips[i])
    end
  end
  if itemData.egg ~= nil and itemData.egg.buff ~= nil then
    msg.itemData.egg.buff = itemData.egg.buff
  end
  if itemData ~= nil and itemData.egg.unlock_equip ~= nil then
    for i = 1, #itemData.egg.unlock_equip do
      table.insert(msg.itemData.egg.unlock_equip, itemData.egg.unlock_equip[i])
    end
  end
  if itemData ~= nil and itemData.egg.unlock_body ~= nil then
    for i = 1, #itemData.egg.unlock_body do
      table.insert(msg.itemData.egg.unlock_body, itemData.egg.unlock_body[i])
    end
  end
  if itemData.egg ~= nil and itemData.egg.version ~= nil then
    msg.itemData.egg.version = itemData.egg.version
  end
  if itemData.egg ~= nil and itemData.egg.skilloff ~= nil then
    msg.itemData.egg.skilloff = itemData.egg.skilloff
  end
  if itemData.egg ~= nil and itemData.egg.exchange_count ~= nil then
    msg.itemData.egg.exchange_count = itemData.egg.exchange_count
  end
  if itemData.egg ~= nil and itemData.egg.guid ~= nil then
    msg.itemData.egg.guid = itemData.egg.guid
  end
  if itemData ~= nil and itemData.egg.defaultwears ~= nil then
    for i = 1, #itemData.egg.defaultwears do
      table.insert(msg.itemData.egg.defaultwears, itemData.egg.defaultwears[i])
    end
  end
  if itemData ~= nil and itemData.egg.wears ~= nil then
    for i = 1, #itemData.egg.wears do
      table.insert(msg.itemData.egg.wears, itemData.egg.wears[i])
    end
  end
  if itemData.letter ~= nil and itemData.letter.sendUserName ~= nil then
    msg.itemData.letter.sendUserName = itemData.letter.sendUserName
  end
  if itemData.letter ~= nil and itemData.letter.bg ~= nil then
    msg.itemData.letter.bg = itemData.letter.bg
  end
  if itemData.letter ~= nil and itemData.letter.configID ~= nil then
    msg.itemData.letter.configID = itemData.letter.configID
  end
  if itemData.letter ~= nil and itemData.letter.content ~= nil then
    msg.itemData.letter.content = itemData.letter.content
  end
  if itemData.letter ~= nil and itemData.letter.content2 ~= nil then
    msg.itemData.letter.content2 = itemData.letter.content2
  end
  if itemData.code ~= nil and itemData.code.code ~= nil then
    msg.itemData.code.code = itemData.code.code
  end
  if itemData.code ~= nil and itemData.code.used ~= nil then
    msg.itemData.code.used = itemData.code.used
  end
  if itemData.wedding ~= nil and itemData.wedding.id ~= nil then
    msg.itemData.wedding.id = itemData.wedding.id
  end
  if itemData.wedding ~= nil and itemData.wedding.zoneid ~= nil then
    msg.itemData.wedding.zoneid = itemData.wedding.zoneid
  end
  if itemData.wedding ~= nil and itemData.wedding.charid1 ~= nil then
    msg.itemData.wedding.charid1 = itemData.wedding.charid1
  end
  if itemData.wedding ~= nil and itemData.wedding.charid2 ~= nil then
    msg.itemData.wedding.charid2 = itemData.wedding.charid2
  end
  if itemData.wedding ~= nil and itemData.wedding.weddingtime ~= nil then
    msg.itemData.wedding.weddingtime = itemData.wedding.weddingtime
  end
  if itemData.wedding ~= nil and itemData.wedding.photoidx ~= nil then
    msg.itemData.wedding.photoidx = itemData.wedding.photoidx
  end
  if itemData.wedding ~= nil and itemData.wedding.phototime ~= nil then
    msg.itemData.wedding.phototime = itemData.wedding.phototime
  end
  if itemData.wedding ~= nil and itemData.wedding.myname ~= nil then
    msg.itemData.wedding.myname = itemData.wedding.myname
  end
  if itemData.wedding ~= nil and itemData.wedding.partnername ~= nil then
    msg.itemData.wedding.partnername = itemData.wedding.partnername
  end
  if itemData.wedding ~= nil and itemData.wedding.starttime ~= nil then
    msg.itemData.wedding.starttime = itemData.wedding.starttime
  end
  if itemData.wedding ~= nil and itemData.wedding.endtime ~= nil then
    msg.itemData.wedding.endtime = itemData.wedding.endtime
  end
  if itemData.wedding ~= nil and itemData.wedding.notified ~= nil then
    msg.itemData.wedding.notified = itemData.wedding.notified
  end
  if itemData.sender ~= nil and itemData.sender.charid ~= nil then
    msg.itemData.sender.charid = itemData.sender.charid
  end
  if itemData.sender ~= nil and itemData.sender.name ~= nil then
    msg.itemData.sender.name = itemData.sender.name
  end
  if success ~= nil then
    msg.success = success
  end
  if sell_item_id ~= nil then
    msg.sell_item_id = sell_item_id
  end
  if sell_price ~= nil then
    msg.sell_price = sell_price
  end
  if sell_count ~= nil then
    msg.sell_count = sell_count
  end
  if refine_lv ~= nil then
    msg.refine_lv = refine_lv
  end
  if ret_cost ~= nil then
    msg.ret_cost = ret_cost
  end
  if trade_type ~= nil then
    msg.trade_type = trade_type
  end
  if tax ~= nil then
    msg.tax = tax
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if getmoney ~= nil then
    msg.getmoney = getmoney
  end
  if retmoney ~= nil then
    msg.retmoney = retmoney
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallQuestRaidCloseSessionCmd(userid, raidid)
  local msg = SessionCmd_pb.QuestRaidCloseSessionCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  if raidid ~= nil then
    msg.raidid = raidid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallAuthorizeInfoSessionCmd(charid, ignorepwd)
  local msg = SessionCmd_pb.AuthorizeInfoSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if ignorepwd ~= nil then
    msg.ignorepwd = ignorepwd
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGuildRaidCloseSessionCmd(mapid, curmapindex, guildid, teamid)
  local msg = SessionCmd_pb.GuildRaidCloseSessionCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if curmapindex ~= nil then
    msg.curmapindex = curmapindex
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallDeletePwdSessionCmd(charid)
  local msg = SessionCmd_pb.DeletePwdSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGoBackSessionCmd(charid)
  local msg = SessionCmd_pb.GoBackSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallWantedQuestFinishCmd(leaderid, teammateid)
  local msg = SessionCmd_pb.WantedQuestFinishCmd()
  if leaderid ~= nil then
    msg.leaderid = leaderid
  end
  if teammateid ~= nil then
    msg.teammateid = teammateid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallAddOfflineItemSessionCmd(charid, data)
  local msg = SessionCmd_pb.AddOfflineItemSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data.base ~= nil and data.base.guid ~= nil then
    msg.data.base.guid = data.base.guid
  end
  if data.base ~= nil and data.base.id ~= nil then
    msg.data.base.id = data.base.id
  end
  if data.base ~= nil and data.base.count ~= nil then
    msg.data.base.count = data.base.count
  end
  if data.base ~= nil and data.base.index ~= nil then
    msg.data.base.index = data.base.index
  end
  if data.base ~= nil and data.base.createtime ~= nil then
    msg.data.base.createtime = data.base.createtime
  end
  if data.base ~= nil and data.base.cd ~= nil then
    msg.data.base.cd = data.base.cd
  end
  if data.base ~= nil and data.base.type ~= nil then
    msg.data.base.type = data.base.type
  end
  if data.base ~= nil and data.base.bind ~= nil then
    msg.data.base.bind = data.base.bind
  end
  if data.base ~= nil and data.base.expire ~= nil then
    msg.data.base.expire = data.base.expire
  end
  if data.base ~= nil and data.base.quality ~= nil then
    msg.data.base.quality = data.base.quality
  end
  if data.base ~= nil and data.base.equipType ~= nil then
    msg.data.base.equipType = data.base.equipType
  end
  if data.base ~= nil and data.base.source ~= nil then
    msg.data.base.source = data.base.source
  end
  if data.base ~= nil and data.base.isnew ~= nil then
    msg.data.base.isnew = data.base.isnew
  end
  if data.base ~= nil and data.base.maxcardslot ~= nil then
    msg.data.base.maxcardslot = data.base.maxcardslot
  end
  if data.base ~= nil and data.base.ishint ~= nil then
    msg.data.base.ishint = data.base.ishint
  end
  if data.base ~= nil and data.base.isactive ~= nil then
    msg.data.base.isactive = data.base.isactive
  end
  if data.base ~= nil and data.base.source_npc ~= nil then
    msg.data.base.source_npc = data.base.source_npc
  end
  if data.base ~= nil and data.base.refinelv ~= nil then
    msg.data.base.refinelv = data.base.refinelv
  end
  if data.base ~= nil and data.base.chargemoney ~= nil then
    msg.data.base.chargemoney = data.base.chargemoney
  end
  if data.base ~= nil and data.base.overtime ~= nil then
    msg.data.base.overtime = data.base.overtime
  end
  if data.base ~= nil and data.base.quota ~= nil then
    msg.data.base.quota = data.base.quota
  end
  if data.base ~= nil and data.base.usedtimes ~= nil then
    msg.data.base.usedtimes = data.base.usedtimes
  end
  if data.base ~= nil and data.base.usedtime ~= nil then
    msg.data.base.usedtime = data.base.usedtime
  end
  if data ~= nil and data.equiped ~= nil then
    msg.data.equiped = data.equiped
  end
  if data ~= nil and data.battlepoint ~= nil then
    msg.data.battlepoint = data.battlepoint
  end
  if data.equip ~= nil and data.equip.strengthlv ~= nil then
    msg.data.equip.strengthlv = data.equip.strengthlv
  end
  if data.equip ~= nil and data.equip.refinelv ~= nil then
    msg.data.equip.refinelv = data.equip.refinelv
  end
  if data.equip ~= nil and data.equip.strengthCost ~= nil then
    msg.data.equip.strengthCost = data.equip.strengthCost
  end
  if data ~= nil and data.equip.refineCompose ~= nil then
    for i = 1, #data.equip.refineCompose do
      table.insert(msg.data.equip.refineCompose, data.equip.refineCompose[i])
    end
  end
  if data.equip ~= nil and data.equip.cardslot ~= nil then
    msg.data.equip.cardslot = data.equip.cardslot
  end
  if data ~= nil and data.equip.buffid ~= nil then
    for i = 1, #data.equip.buffid do
      table.insert(msg.data.equip.buffid, data.equip.buffid[i])
    end
  end
  if data.equip ~= nil and data.equip.damage ~= nil then
    msg.data.equip.damage = data.equip.damage
  end
  if data.equip ~= nil and data.equip.lv ~= nil then
    msg.data.equip.lv = data.equip.lv
  end
  if data.equip ~= nil and data.equip.color ~= nil then
    msg.data.equip.color = data.equip.color
  end
  if data.equip ~= nil and data.equip.breakstarttime ~= nil then
    msg.data.equip.breakstarttime = data.equip.breakstarttime
  end
  if data.equip ~= nil and data.equip.breakendtime ~= nil then
    msg.data.equip.breakendtime = data.equip.breakendtime
  end
  if data.equip ~= nil and data.equip.strengthlv2 ~= nil then
    msg.data.equip.strengthlv2 = data.equip.strengthlv2
  end
  if data ~= nil and data.equip.strengthlv2cost ~= nil then
    for i = 1, #data.equip.strengthlv2cost do
      table.insert(msg.data.equip.strengthlv2cost, data.equip.strengthlv2cost[i])
    end
  end
  if data ~= nil and data.card ~= nil then
    for i = 1, #data.card do
      table.insert(msg.data.card, data.card[i])
    end
  end
  if data.enchant ~= nil and data.enchant.type ~= nil then
    msg.data.enchant.type = data.enchant.type
  end
  if data ~= nil and data.enchant.attrs ~= nil then
    for i = 1, #data.enchant.attrs do
      table.insert(msg.data.enchant.attrs, data.enchant.attrs[i])
    end
  end
  if data ~= nil and data.enchant.extras ~= nil then
    for i = 1, #data.enchant.extras do
      table.insert(msg.data.enchant.extras, data.enchant.extras[i])
    end
  end
  if data ~= nil and data.enchant.patch ~= nil then
    for i = 1, #data.enchant.patch do
      table.insert(msg.data.enchant.patch, data.enchant.patch[i])
    end
  end
  if data.previewenchant ~= nil and data.previewenchant.type ~= nil then
    msg.data.previewenchant.type = data.previewenchant.type
  end
  if data ~= nil and data.previewenchant.attrs ~= nil then
    for i = 1, #data.previewenchant.attrs do
      table.insert(msg.data.previewenchant.attrs, data.previewenchant.attrs[i])
    end
  end
  if data ~= nil and data.previewenchant.extras ~= nil then
    for i = 1, #data.previewenchant.extras do
      table.insert(msg.data.previewenchant.extras, data.previewenchant.extras[i])
    end
  end
  if data ~= nil and data.previewenchant.patch ~= nil then
    for i = 1, #data.previewenchant.patch do
      table.insert(msg.data.previewenchant.patch, data.previewenchant.patch[i])
    end
  end
  if data.refine ~= nil and data.refine.lastfail ~= nil then
    msg.data.refine.lastfail = data.refine.lastfail
  end
  if data.refine ~= nil and data.refine.repaircount ~= nil then
    msg.data.refine.repaircount = data.refine.repaircount
  end
  if data.egg ~= nil and data.egg.exp ~= nil then
    msg.data.egg.exp = data.egg.exp
  end
  if data.egg ~= nil and data.egg.friendexp ~= nil then
    msg.data.egg.friendexp = data.egg.friendexp
  end
  if data.egg ~= nil and data.egg.rewardexp ~= nil then
    msg.data.egg.rewardexp = data.egg.rewardexp
  end
  if data.egg ~= nil and data.egg.id ~= nil then
    msg.data.egg.id = data.egg.id
  end
  if data.egg ~= nil and data.egg.lv ~= nil then
    msg.data.egg.lv = data.egg.lv
  end
  if data.egg ~= nil and data.egg.friendlv ~= nil then
    msg.data.egg.friendlv = data.egg.friendlv
  end
  if data.egg ~= nil and data.egg.body ~= nil then
    msg.data.egg.body = data.egg.body
  end
  if data.egg ~= nil and data.egg.relivetime ~= nil then
    msg.data.egg.relivetime = data.egg.relivetime
  end
  if data.egg ~= nil and data.egg.hp ~= nil then
    msg.data.egg.hp = data.egg.hp
  end
  if data.egg ~= nil and data.egg.restoretime ~= nil then
    msg.data.egg.restoretime = data.egg.restoretime
  end
  if data.egg ~= nil and data.egg.time_happly ~= nil then
    msg.data.egg.time_happly = data.egg.time_happly
  end
  if data.egg ~= nil and data.egg.time_excite ~= nil then
    msg.data.egg.time_excite = data.egg.time_excite
  end
  if data.egg ~= nil and data.egg.time_happiness ~= nil then
    msg.data.egg.time_happiness = data.egg.time_happiness
  end
  if data.egg ~= nil and data.egg.time_happly_gift ~= nil then
    msg.data.egg.time_happly_gift = data.egg.time_happly_gift
  end
  if data.egg ~= nil and data.egg.time_excite_gift ~= nil then
    msg.data.egg.time_excite_gift = data.egg.time_excite_gift
  end
  if data.egg ~= nil and data.egg.time_happiness_gift ~= nil then
    msg.data.egg.time_happiness_gift = data.egg.time_happiness_gift
  end
  if data.egg ~= nil and data.egg.touch_tick ~= nil then
    msg.data.egg.touch_tick = data.egg.touch_tick
  end
  if data.egg ~= nil and data.egg.feed_tick ~= nil then
    msg.data.egg.feed_tick = data.egg.feed_tick
  end
  if data.egg ~= nil and data.egg.name ~= nil then
    msg.data.egg.name = data.egg.name
  end
  if data.egg ~= nil and data.egg.var ~= nil then
    msg.data.egg.var = data.egg.var
  end
  if data ~= nil and data.egg.skillids ~= nil then
    for i = 1, #data.egg.skillids do
      table.insert(msg.data.egg.skillids, data.egg.skillids[i])
    end
  end
  if data ~= nil and data.egg.equips ~= nil then
    for i = 1, #data.egg.equips do
      table.insert(msg.data.egg.equips, data.egg.equips[i])
    end
  end
  if data.egg ~= nil and data.egg.buff ~= nil then
    msg.data.egg.buff = data.egg.buff
  end
  if data ~= nil and data.egg.unlock_equip ~= nil then
    for i = 1, #data.egg.unlock_equip do
      table.insert(msg.data.egg.unlock_equip, data.egg.unlock_equip[i])
    end
  end
  if data ~= nil and data.egg.unlock_body ~= nil then
    for i = 1, #data.egg.unlock_body do
      table.insert(msg.data.egg.unlock_body, data.egg.unlock_body[i])
    end
  end
  if data.egg ~= nil and data.egg.version ~= nil then
    msg.data.egg.version = data.egg.version
  end
  if data.egg ~= nil and data.egg.skilloff ~= nil then
    msg.data.egg.skilloff = data.egg.skilloff
  end
  if data.egg ~= nil and data.egg.exchange_count ~= nil then
    msg.data.egg.exchange_count = data.egg.exchange_count
  end
  if data.egg ~= nil and data.egg.guid ~= nil then
    msg.data.egg.guid = data.egg.guid
  end
  if data ~= nil and data.egg.defaultwears ~= nil then
    for i = 1, #data.egg.defaultwears do
      table.insert(msg.data.egg.defaultwears, data.egg.defaultwears[i])
    end
  end
  if data ~= nil and data.egg.wears ~= nil then
    for i = 1, #data.egg.wears do
      table.insert(msg.data.egg.wears, data.egg.wears[i])
    end
  end
  if data.letter ~= nil and data.letter.sendUserName ~= nil then
    msg.data.letter.sendUserName = data.letter.sendUserName
  end
  if data.letter ~= nil and data.letter.bg ~= nil then
    msg.data.letter.bg = data.letter.bg
  end
  if data.letter ~= nil and data.letter.configID ~= nil then
    msg.data.letter.configID = data.letter.configID
  end
  if data.letter ~= nil and data.letter.content ~= nil then
    msg.data.letter.content = data.letter.content
  end
  if data.letter ~= nil and data.letter.content2 ~= nil then
    msg.data.letter.content2 = data.letter.content2
  end
  if data.code ~= nil and data.code.code ~= nil then
    msg.data.code.code = data.code.code
  end
  if data.code ~= nil and data.code.used ~= nil then
    msg.data.code.used = data.code.used
  end
  if data.wedding ~= nil and data.wedding.id ~= nil then
    msg.data.wedding.id = data.wedding.id
  end
  if data.wedding ~= nil and data.wedding.zoneid ~= nil then
    msg.data.wedding.zoneid = data.wedding.zoneid
  end
  if data.wedding ~= nil and data.wedding.charid1 ~= nil then
    msg.data.wedding.charid1 = data.wedding.charid1
  end
  if data.wedding ~= nil and data.wedding.charid2 ~= nil then
    msg.data.wedding.charid2 = data.wedding.charid2
  end
  if data.wedding ~= nil and data.wedding.weddingtime ~= nil then
    msg.data.wedding.weddingtime = data.wedding.weddingtime
  end
  if data.wedding ~= nil and data.wedding.photoidx ~= nil then
    msg.data.wedding.photoidx = data.wedding.photoidx
  end
  if data.wedding ~= nil and data.wedding.phototime ~= nil then
    msg.data.wedding.phototime = data.wedding.phototime
  end
  if data.wedding ~= nil and data.wedding.myname ~= nil then
    msg.data.wedding.myname = data.wedding.myname
  end
  if data.wedding ~= nil and data.wedding.partnername ~= nil then
    msg.data.wedding.partnername = data.wedding.partnername
  end
  if data.wedding ~= nil and data.wedding.starttime ~= nil then
    msg.data.wedding.starttime = data.wedding.starttime
  end
  if data.wedding ~= nil and data.wedding.endtime ~= nil then
    msg.data.wedding.endtime = data.wedding.endtime
  end
  if data.wedding ~= nil and data.wedding.notified ~= nil then
    msg.data.wedding.notified = data.wedding.notified
  end
  if data.sender ~= nil and data.sender.charid ~= nil then
    msg.data.sender.charid = data.sender.charid
  end
  if data.sender ~= nil and data.sender.name ~= nil then
    msg.data.sender.name = data.sender.name
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallUpdateOperActivitySessionCmd()
  local msg = SessionCmd_pb.UpdateOperActivitySessionCmd()
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSyncShopSessionCmd(item)
  local msg = SessionCmd_pb.SyncShopSessionCmd()
  if item ~= nil then
    msg.item = item
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallUpdateActivityEventSessionCmd()
  local msg = SessionCmd_pb.UpdateActivityEventSessionCmd()
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallActivityEventNtfSessionCmd(infos)
  local msg = SessionCmd_pb.ActivityEventNtfSessionCmd()
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallLoveLetterSessionCmd(charid, itemguid, targets, content, type)
  local msg = SessionCmd_pb.LoveLetterSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if itemguid ~= nil then
    msg.itemguid = itemguid
  end
  if targets ~= nil then
    msg.targets = targets
  end
  if content ~= nil then
    msg.content = content
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallLoveLetterSendSessionCmd(charid, sendname, content, type)
  local msg = SessionCmd_pb.LoveLetterSendSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if sendname ~= nil then
    msg.sendname = sendname
  end
  if content ~= nil then
    msg.content = content
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallUseItemCodeSessionCmd(charid, guid, itemid, type, code)
  local msg = SessionCmd_pb.UseItemCodeSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if guid ~= nil then
    msg.guid = guid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if type ~= nil then
    msg.type = type
  end
  if code ~= nil then
    msg.code = code
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallReqUsedItemCodeSessionCmd(charid, guid, type)
  local msg = SessionCmd_pb.ReqUsedItemCodeSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if guid ~= nil then
    for i = 1, #guid do
      table.insert(msg.guid, guid[i])
    end
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGlobalActivityStartSessionCmd(id)
  local msg = SessionCmd_pb.GlobalActivityStartSessionCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGlobalActivityStopSessionCmd(id)
  local msg = SessionCmd_pb.GlobalActivityStopSessionCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallReqLotteryGiveSessionCmd(charid, iteminfo)
  local msg = SessionCmd_pb.ReqLotteryGiveSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if iteminfo ~= nil and iteminfo.year ~= nil then
    msg.iteminfo.year = iteminfo.year
  end
  if iteminfo ~= nil and iteminfo.month ~= nil then
    msg.iteminfo.month = iteminfo.month
  end
  if iteminfo ~= nil and iteminfo.count ~= nil then
    msg.iteminfo.count = iteminfo.count
  end
  if iteminfo ~= nil and iteminfo.content ~= nil then
    msg.iteminfo.content = iteminfo.content
  end
  if iteminfo ~= nil and iteminfo.configid ~= nil then
    msg.iteminfo.configid = iteminfo.configid
  end
  if iteminfo ~= nil and iteminfo.receiverid ~= nil then
    msg.iteminfo.receiverid = iteminfo.receiverid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSyncOperateRewardSessionCmd(charid, var)
  local msg = SessionCmd_pb.SyncOperateRewardSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if var ~= nil then
    msg.var = var
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallNotifyActivitySessionCmd(actid, open)
  local msg = SessionCmd_pb.NotifyActivitySessionCmd()
  if actid ~= nil then
    msg.actid = actid
  end
  if open ~= nil then
    msg.open = open
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGiveRewardSessionCmd(charid, rewardid, buffid)
  local msg = SessionCmd_pb.GiveRewardSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if rewardid ~= nil then
    msg.rewardid = rewardid
  end
  if buffid ~= nil then
    msg.buffid = buffid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallWantedQuestSetCDSessionCmd(charid, time)
  local msg = SessionCmd_pb.WantedQuestSetCDSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if time ~= nil then
    msg.time = time
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallUserQuotaOperSessionCmd(charid, quota, oper, type)
  local msg = SessionCmd_pb.UserQuotaOperSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if oper ~= nil then
    msg.oper = oper
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSyncWorldLevelSessionCmd(charid, base_worldlevel, job_worldlevel)
  local msg = SessionCmd_pb.SyncWorldLevelSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if base_worldlevel ~= nil then
    msg.base_worldlevel = base_worldlevel
  end
  if job_worldlevel ~= nil then
    msg.job_worldlevel = job_worldlevel
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallUserEnterSceneSessionCmd(charid)
  local msg = SessionCmd_pb.UserEnterSceneSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallSyncUserVarSessionCmd(charid, vars)
  local msg = SessionCmd_pb.SyncUserVarSessionCmd()
  msg.charid = charid
  if vars ~= nil then
    for i = 1, #vars do
      table.insert(msg.vars, vars[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallGoOriginalZoneSessionCmd(charid, checksscene)
  local msg = SessionCmd_pb.GoOriginalZoneSessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if checksscene ~= nil then
    msg.checksscene = checksscene
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:CallActivitySetSessionCmd(uid)
  local msg = SessionCmd_pb.ActivitySetSessionCmd()
  if uid ~= nil then
    msg.uid = uid
  end
  self:SendProto(msg)
end
function ServiceSessionCmdAutoProxy:RecvMapRegSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdMapRegSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvCreateRaidMapSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdCreateRaidMapSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvDeleteDMapSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdDeleteDMapSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvChangeSceneSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdChangeSceneSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvChangeSceneResultSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdChangeSceneResultSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvUserDataSync(data)
  self:Notify(ServiceEvent.SessionCmdUserDataSync, data)
end
function ServiceSessionCmdAutoProxy:RecvQuestNtfListSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdQuestNtfListSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGoToUserMapSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGoToUserMapSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvLoadLuaSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdLoadLuaSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvExecGMCmdSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdExecGMCmdSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvSceneTowerUpdate(data)
  self:Notify(ServiceEvent.SessionCmdSceneTowerUpdate, data)
end
function ServiceSessionCmdAutoProxy:RecvTowerGlobalUpdateSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdTowerGlobalUpdateSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvTowerMonsterKill(data)
  self:Notify(ServiceEvent.SessionCmdTowerMonsterKill, data)
end
function ServiceSessionCmdAutoProxy:RecvSendMail(data)
  self:Notify(ServiceEvent.SessionCmdSendMail, data)
end
function ServiceSessionCmdAutoProxy:RecvSessionSceneUserCmd(data)
  self:Notify(ServiceEvent.SessionCmdSessionSceneUserCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGetMailAttachSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGetMailAttachSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvFollowerIDCheck(data)
  self:Notify(ServiceEvent.SessionCmdFollowerIDCheck, data)
end
function ServiceSessionCmdAutoProxy:RecvEvent(data)
  self:Notify(ServiceEvent.SessionCmdEvent, data)
end
function ServiceSessionCmdAutoProxy:RecvChatMsgSession(data)
  self:Notify(ServiceEvent.SessionCmdChatMsgSession, data)
end
function ServiceSessionCmdAutoProxy:RecvSetGlobalDaily(data)
  self:Notify(ServiceEvent.SessionCmdSetGlobalDaily, data)
end
function ServiceSessionCmdAutoProxy:RecvRefreshQuest(data)
  self:Notify(ServiceEvent.SessionCmdRefreshQuest, data)
end
function ServiceSessionCmdAutoProxy:RecvQuerySealTimer(data)
  self:Notify(ServiceEvent.SessionCmdQuerySealTimer, data)
end
function ServiceSessionCmdAutoProxy:RecvDelSceneImage(data)
  self:Notify(ServiceEvent.SessionCmdDelSceneImage, data)
end
function ServiceSessionCmdAutoProxy:RecvSetTeamSeal(data)
  self:Notify(ServiceEvent.SessionCmdSetTeamSeal, data)
end
function ServiceSessionCmdAutoProxy:RecvInviteHandsSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdInviteHandsSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvUserLoginNtfSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdUserLoginNtfSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvRefreshTower(data)
  self:Notify(ServiceEvent.SessionCmdRefreshTower, data)
end
function ServiceSessionCmdAutoProxy:RecvNotifyLoginSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdNotifyLoginSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvErrSetUserDataSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdErrSetUserDataSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvChangeSceneSingleSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdChangeSceneSingleSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvRegMapFailSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdRegMapFailSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvRegMapOKSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdRegMapOKSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvForwardUserSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdForwardUserSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvForwardUserSceneSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdForwardUserSceneSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvForwardUserSessionSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdForwardUserSessionSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvForwardUserSceneSvrSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdForwardUserSceneSvrSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvEnterGuildTerritorySessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdEnterGuildTerritorySessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvSyncDojoSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdSyncDojoSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvChargeSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdChargeSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGagSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGagSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvLockSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdLockSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvIteamImageSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdIteamImageSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvFerrisInviteSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdFerrisInviteSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvEnterFerrisReadySessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdEnterFerrisReadySessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvActivityTestAndSetSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdActivityTestAndSetSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvActivityStatusSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdActivityStatusSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvChangeTeamSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdChangeTeamSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvForwardRegionSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdForwardRegionSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvBreakHandSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdBreakHandSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvActivityStopSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdActivityStopSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvWantedInfoSyncSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdWantedInfoSyncSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvQueryZoneStatusSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdQueryZoneStatusSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvSendMailFromScene(data)
  self:Notify(ServiceEvent.SessionCmdSendMailFromScene, data)
end
function ServiceSessionCmdAutoProxy:RecvGetTradeLogSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGetTradeLogSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvQuestRaidCloseSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdQuestRaidCloseSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvAuthorizeInfoSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdAuthorizeInfoSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGuildRaidCloseSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGuildRaidCloseSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvDeletePwdSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdDeletePwdSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGoBackSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGoBackSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvWantedQuestFinishCmd(data)
  self:Notify(ServiceEvent.SessionCmdWantedQuestFinishCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvAddOfflineItemSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdAddOfflineItemSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvUpdateOperActivitySessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdUpdateOperActivitySessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvSyncShopSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdSyncShopSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvUpdateActivityEventSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdUpdateActivityEventSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvActivityEventNtfSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdActivityEventNtfSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvLoveLetterSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdLoveLetterSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvLoveLetterSendSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdLoveLetterSendSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvUseItemCodeSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdUseItemCodeSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvReqUsedItemCodeSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdReqUsedItemCodeSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGlobalActivityStartSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGlobalActivityStartSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGlobalActivityStopSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGlobalActivityStopSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvReqLotteryGiveSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdReqLotteryGiveSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvSyncOperateRewardSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdSyncOperateRewardSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvNotifyActivitySessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdNotifyActivitySessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGiveRewardSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGiveRewardSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvWantedQuestSetCDSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdWantedQuestSetCDSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvUserQuotaOperSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdUserQuotaOperSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvSyncWorldLevelSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdSyncWorldLevelSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvUserEnterSceneSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdUserEnterSceneSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvSyncUserVarSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdSyncUserVarSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvGoOriginalZoneSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdGoOriginalZoneSessionCmd, data)
end
function ServiceSessionCmdAutoProxy:RecvActivitySetSessionCmd(data)
  self:Notify(ServiceEvent.SessionCmdActivitySetSessionCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SessionCmdMapRegSessionCmd = "ServiceEvent_SessionCmdMapRegSessionCmd"
ServiceEvent.SessionCmdCreateRaidMapSessionCmd = "ServiceEvent_SessionCmdCreateRaidMapSessionCmd"
ServiceEvent.SessionCmdDeleteDMapSessionCmd = "ServiceEvent_SessionCmdDeleteDMapSessionCmd"
ServiceEvent.SessionCmdChangeSceneSessionCmd = "ServiceEvent_SessionCmdChangeSceneSessionCmd"
ServiceEvent.SessionCmdChangeSceneResultSessionCmd = "ServiceEvent_SessionCmdChangeSceneResultSessionCmd"
ServiceEvent.SessionCmdUserDataSync = "ServiceEvent_SessionCmdUserDataSync"
ServiceEvent.SessionCmdQuestNtfListSessionCmd = "ServiceEvent_SessionCmdQuestNtfListSessionCmd"
ServiceEvent.SessionCmdGoToUserMapSessionCmd = "ServiceEvent_SessionCmdGoToUserMapSessionCmd"
ServiceEvent.SessionCmdLoadLuaSessionCmd = "ServiceEvent_SessionCmdLoadLuaSessionCmd"
ServiceEvent.SessionCmdExecGMCmdSessionCmd = "ServiceEvent_SessionCmdExecGMCmdSessionCmd"
ServiceEvent.SessionCmdSceneTowerUpdate = "ServiceEvent_SessionCmdSceneTowerUpdate"
ServiceEvent.SessionCmdTowerGlobalUpdateSessionCmd = "ServiceEvent_SessionCmdTowerGlobalUpdateSessionCmd"
ServiceEvent.SessionCmdTowerMonsterKill = "ServiceEvent_SessionCmdTowerMonsterKill"
ServiceEvent.SessionCmdSendMail = "ServiceEvent_SessionCmdSendMail"
ServiceEvent.SessionCmdSessionSceneUserCmd = "ServiceEvent_SessionCmdSessionSceneUserCmd"
ServiceEvent.SessionCmdGetMailAttachSessionCmd = "ServiceEvent_SessionCmdGetMailAttachSessionCmd"
ServiceEvent.SessionCmdFollowerIDCheck = "ServiceEvent_SessionCmdFollowerIDCheck"
ServiceEvent.SessionCmdEvent = "ServiceEvent_SessionCmdEvent"
ServiceEvent.SessionCmdChatMsgSession = "ServiceEvent_SessionCmdChatMsgSession"
ServiceEvent.SessionCmdSetGlobalDaily = "ServiceEvent_SessionCmdSetGlobalDaily"
ServiceEvent.SessionCmdRefreshQuest = "ServiceEvent_SessionCmdRefreshQuest"
ServiceEvent.SessionCmdQuerySealTimer = "ServiceEvent_SessionCmdQuerySealTimer"
ServiceEvent.SessionCmdDelSceneImage = "ServiceEvent_SessionCmdDelSceneImage"
ServiceEvent.SessionCmdSetTeamSeal = "ServiceEvent_SessionCmdSetTeamSeal"
ServiceEvent.SessionCmdInviteHandsSessionCmd = "ServiceEvent_SessionCmdInviteHandsSessionCmd"
ServiceEvent.SessionCmdUserLoginNtfSessionCmd = "ServiceEvent_SessionCmdUserLoginNtfSessionCmd"
ServiceEvent.SessionCmdRefreshTower = "ServiceEvent_SessionCmdRefreshTower"
ServiceEvent.SessionCmdNotifyLoginSessionCmd = "ServiceEvent_SessionCmdNotifyLoginSessionCmd"
ServiceEvent.SessionCmdErrSetUserDataSessionCmd = "ServiceEvent_SessionCmdErrSetUserDataSessionCmd"
ServiceEvent.SessionCmdChangeSceneSingleSessionCmd = "ServiceEvent_SessionCmdChangeSceneSingleSessionCmd"
ServiceEvent.SessionCmdRegMapFailSessionCmd = "ServiceEvent_SessionCmdRegMapFailSessionCmd"
ServiceEvent.SessionCmdRegMapOKSessionCmd = "ServiceEvent_SessionCmdRegMapOKSessionCmd"
ServiceEvent.SessionCmdForwardUserSessionCmd = "ServiceEvent_SessionCmdForwardUserSessionCmd"
ServiceEvent.SessionCmdForwardUserSceneSessionCmd = "ServiceEvent_SessionCmdForwardUserSceneSessionCmd"
ServiceEvent.SessionCmdForwardUserSessionSessionCmd = "ServiceEvent_SessionCmdForwardUserSessionSessionCmd"
ServiceEvent.SessionCmdForwardUserSceneSvrSessionCmd = "ServiceEvent_SessionCmdForwardUserSceneSvrSessionCmd"
ServiceEvent.SessionCmdEnterGuildTerritorySessionCmd = "ServiceEvent_SessionCmdEnterGuildTerritorySessionCmd"
ServiceEvent.SessionCmdSyncDojoSessionCmd = "ServiceEvent_SessionCmdSyncDojoSessionCmd"
ServiceEvent.SessionCmdChargeSessionCmd = "ServiceEvent_SessionCmdChargeSessionCmd"
ServiceEvent.SessionCmdGagSessionCmd = "ServiceEvent_SessionCmdGagSessionCmd"
ServiceEvent.SessionCmdLockSessionCmd = "ServiceEvent_SessionCmdLockSessionCmd"
ServiceEvent.SessionCmdIteamImageSessionCmd = "ServiceEvent_SessionCmdIteamImageSessionCmd"
ServiceEvent.SessionCmdFerrisInviteSessionCmd = "ServiceEvent_SessionCmdFerrisInviteSessionCmd"
ServiceEvent.SessionCmdEnterFerrisReadySessionCmd = "ServiceEvent_SessionCmdEnterFerrisReadySessionCmd"
ServiceEvent.SessionCmdActivityTestAndSetSessionCmd = "ServiceEvent_SessionCmdActivityTestAndSetSessionCmd"
ServiceEvent.SessionCmdActivityStatusSessionCmd = "ServiceEvent_SessionCmdActivityStatusSessionCmd"
ServiceEvent.SessionCmdChangeTeamSessionCmd = "ServiceEvent_SessionCmdChangeTeamSessionCmd"
ServiceEvent.SessionCmdForwardRegionSessionCmd = "ServiceEvent_SessionCmdForwardRegionSessionCmd"
ServiceEvent.SessionCmdBreakHandSessionCmd = "ServiceEvent_SessionCmdBreakHandSessionCmd"
ServiceEvent.SessionCmdActivityStopSessionCmd = "ServiceEvent_SessionCmdActivityStopSessionCmd"
ServiceEvent.SessionCmdWantedInfoSyncSessionCmd = "ServiceEvent_SessionCmdWantedInfoSyncSessionCmd"
ServiceEvent.SessionCmdQueryZoneStatusSessionCmd = "ServiceEvent_SessionCmdQueryZoneStatusSessionCmd"
ServiceEvent.SessionCmdSendMailFromScene = "ServiceEvent_SessionCmdSendMailFromScene"
ServiceEvent.SessionCmdGetTradeLogSessionCmd = "ServiceEvent_SessionCmdGetTradeLogSessionCmd"
ServiceEvent.SessionCmdQuestRaidCloseSessionCmd = "ServiceEvent_SessionCmdQuestRaidCloseSessionCmd"
ServiceEvent.SessionCmdAuthorizeInfoSessionCmd = "ServiceEvent_SessionCmdAuthorizeInfoSessionCmd"
ServiceEvent.SessionCmdGuildRaidCloseSessionCmd = "ServiceEvent_SessionCmdGuildRaidCloseSessionCmd"
ServiceEvent.SessionCmdDeletePwdSessionCmd = "ServiceEvent_SessionCmdDeletePwdSessionCmd"
ServiceEvent.SessionCmdGoBackSessionCmd = "ServiceEvent_SessionCmdGoBackSessionCmd"
ServiceEvent.SessionCmdWantedQuestFinishCmd = "ServiceEvent_SessionCmdWantedQuestFinishCmd"
ServiceEvent.SessionCmdAddOfflineItemSessionCmd = "ServiceEvent_SessionCmdAddOfflineItemSessionCmd"
ServiceEvent.SessionCmdUpdateOperActivitySessionCmd = "ServiceEvent_SessionCmdUpdateOperActivitySessionCmd"
ServiceEvent.SessionCmdSyncShopSessionCmd = "ServiceEvent_SessionCmdSyncShopSessionCmd"
ServiceEvent.SessionCmdUpdateActivityEventSessionCmd = "ServiceEvent_SessionCmdUpdateActivityEventSessionCmd"
ServiceEvent.SessionCmdActivityEventNtfSessionCmd = "ServiceEvent_SessionCmdActivityEventNtfSessionCmd"
ServiceEvent.SessionCmdLoveLetterSessionCmd = "ServiceEvent_SessionCmdLoveLetterSessionCmd"
ServiceEvent.SessionCmdLoveLetterSendSessionCmd = "ServiceEvent_SessionCmdLoveLetterSendSessionCmd"
ServiceEvent.SessionCmdUseItemCodeSessionCmd = "ServiceEvent_SessionCmdUseItemCodeSessionCmd"
ServiceEvent.SessionCmdReqUsedItemCodeSessionCmd = "ServiceEvent_SessionCmdReqUsedItemCodeSessionCmd"
ServiceEvent.SessionCmdGlobalActivityStartSessionCmd = "ServiceEvent_SessionCmdGlobalActivityStartSessionCmd"
ServiceEvent.SessionCmdGlobalActivityStopSessionCmd = "ServiceEvent_SessionCmdGlobalActivityStopSessionCmd"
ServiceEvent.SessionCmdReqLotteryGiveSessionCmd = "ServiceEvent_SessionCmdReqLotteryGiveSessionCmd"
ServiceEvent.SessionCmdSyncOperateRewardSessionCmd = "ServiceEvent_SessionCmdSyncOperateRewardSessionCmd"
ServiceEvent.SessionCmdNotifyActivitySessionCmd = "ServiceEvent_SessionCmdNotifyActivitySessionCmd"
ServiceEvent.SessionCmdGiveRewardSessionCmd = "ServiceEvent_SessionCmdGiveRewardSessionCmd"
ServiceEvent.SessionCmdWantedQuestSetCDSessionCmd = "ServiceEvent_SessionCmdWantedQuestSetCDSessionCmd"
ServiceEvent.SessionCmdUserQuotaOperSessionCmd = "ServiceEvent_SessionCmdUserQuotaOperSessionCmd"
ServiceEvent.SessionCmdSyncWorldLevelSessionCmd = "ServiceEvent_SessionCmdSyncWorldLevelSessionCmd"
ServiceEvent.SessionCmdUserEnterSceneSessionCmd = "ServiceEvent_SessionCmdUserEnterSceneSessionCmd"
ServiceEvent.SessionCmdSyncUserVarSessionCmd = "ServiceEvent_SessionCmdSyncUserVarSessionCmd"
ServiceEvent.SessionCmdGoOriginalZoneSessionCmd = "ServiceEvent_SessionCmdGoOriginalZoneSessionCmd"
ServiceEvent.SessionCmdActivitySetSessionCmd = "ServiceEvent_SessionCmdActivitySetSessionCmd"
