ServiceSocialCmdAutoProxy = class("ServiceSocialCmdAutoProxy", ServiceProxy)
ServiceSocialCmdAutoProxy.Instance = nil
ServiceSocialCmdAutoProxy.NAME = "ServiceSocialCmdAutoProxy"
function ServiceSocialCmdAutoProxy:ctor(proxyName)
  if ServiceSocialCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSocialCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSocialCmdAutoProxy.Instance = self
  end
end
function ServiceSocialCmdAutoProxy:Init()
end
function ServiceSocialCmdAutoProxy:onRegister()
  self:Listen(208, 1, function(data)
    self:RecvSessionForwardSocialCmd(data)
  end)
  self:Listen(208, 2, function(data)
    self:RecvForwardToUserSocialCmd(data)
  end)
  self:Listen(208, 3, function(data)
    self:RecvForwardToUserSceneSocialCmd(data)
  end)
  self:Listen(208, 4, function(data)
    self:RecvForwardToSceneUserSocialCmd(data)
  end)
  self:Listen(208, 68, function(data)
    self:RecvForwardToSessionUserSocialCmd(data)
  end)
  self:Listen(208, 5, function(data)
    self:RecvOnlineStatusSocialCmd(data)
  end)
  self:Listen(208, 6, function(data)
    self:RecvAddOfflineMsgSocialCmd(data)
  end)
  self:Listen(208, 10, function(data)
    self:RecvUserInfoSyncSocialCmd(data)
  end)
  self:Listen(208, 11, function(data)
    self:RecvUserAddItemSocialCmd(data)
  end)
  self:Listen(208, 12, function(data)
    self:RecvUserDelSocialCmd(data)
  end)
  self:Listen(208, 14, function(data)
    self:RecvUserGuildInfoSocialCmd(data)
  end)
  self:Listen(208, 21, function(data)
    self:RecvChatWorldMsgSocialCmd(data)
  end)
  self:Listen(208, 22, function(data)
    self:RecvChatSocialCmd(data)
  end)
  self:Listen(208, 31, function(data)
    self:RecvCreateGuildSocialCmd(data)
  end)
  self:Listen(208, 32, function(data)
    self:RecvGuildDonateSocialCmd(data)
  end)
  self:Listen(208, 37, function(data)
    self:RecvGuildApplySocialCmd(data)
  end)
  self:Listen(208, 38, function(data)
    self:RecvGuildProcessInviteSocialCmd(data)
  end)
  self:Listen(208, 42, function(data)
    self:RecvGuildExchangeZoneSocialCmd(data)
  end)
  self:Listen(208, 51, function(data)
    self:RecvTeamCreateSocialCmd(data)
  end)
  self:Listen(208, 52, function(data)
    self:RecvTeamInviteSocialCmd(data)
  end)
  self:Listen(208, 53, function(data)
    self:RecvTeamProcessInviteSocialCmd(data)
  end)
  self:Listen(208, 54, function(data)
    self:RecvTeamApplySocialCmd(data)
  end)
  self:Listen(208, 55, function(data)
    self:RecvTeamQuickEnterSocialCmd(data)
  end)
  self:Listen(208, 57, function(data)
    self:RecvDojoStateNtfSocialCmd(data)
  end)
  self:Listen(208, 56, function(data)
    self:RecvDojoCreateSocialCmd(data)
  end)
  self:Listen(208, 58, function(data)
    self:RecvTowerLeaderInfoSyncSocialCmd(data)
  end)
  self:Listen(208, 59, function(data)
    self:RecvTowerSceneCreateSocialCmd(data)
  end)
  self:Listen(208, 60, function(data)
    self:RecvTowerSceneSyncSocialCmd(data)
  end)
  self:Listen(208, 61, function(data)
    self:RecvTowerLayerSyncSocialCmd(data)
  end)
  self:Listen(208, 71, function(data)
    self:RecvLeaderSealFinishSocialCmd(data)
  end)
  self:Listen(208, 62, function(data)
    self:RecvGoTeamRaidSocialCmd(data)
  end)
  self:Listen(208, 63, function(data)
    self:RecvDelTeamRaidSocialCmd(data)
  end)
  self:Listen(208, 64, function(data)
    self:RecvSendMailSocialCmd(data)
  end)
  self:Listen(208, 67, function(data)
    self:RecvForwardToAllSessionSocialCmd(data)
  end)
  self:Listen(208, 44, function(data)
    self:RecvGuildLevelUpSocialCmd(data)
  end)
  self:Listen(208, 70, function(data)
    self:RecvMoveGuildZoneSocialCmd(data)
  end)
  self:Listen(208, 80, function(data)
    self:RecvSocialDataUpdateSocialCmd(data)
  end)
  self:Listen(208, 81, function(data)
    self:RecvAddRelationSocialCmd(data)
  end)
  self:Listen(208, 82, function(data)
    self:RecvRemoveRelationSocialCmd(data)
  end)
  self:Listen(208, SOCIALPARAM_SOCIAL_REMOVEFOCUS, function(data)
    self:RecvRemoveFocusSocialCmd(data)
  end)
  self:Listen(208, 84, function(data)
    self:RecvRemoveSocialitySocialCmd(data)
  end)
  self:Listen(208, 85, function(data)
    self:RecvSyncSocialListSocialCmd(data)
  end)
  self:Listen(208, 86, function(data)
    self:RecvSocialListUpdateSocialCmd(data)
  end)
  self:Listen(208, 91, function(data)
    self:RecvUpdateRelationTimeSocialCmd(data)
  end)
  self:Listen(208, 87, function(data)
    self:RecvTeamerQuestUpdateSocialCmd(data)
  end)
  self:Listen(208, 88, function(data)
    self:RecvGlobalForwardCmdSocialCmd(data)
  end)
  self:Listen(208, 90, function(data)
    self:RecvAuthorizeInfoSyncSocialCmd(data)
  end)
  self:Listen(208, 92, function(data)
    self:RecvSyncRedTipSocialCmd(data)
  end)
  self:Listen(208, 93, function(data)
    self:RecvSendTutorRewardSocialCmd(data)
  end)
  self:Listen(208, 94, function(data)
    self:RecvSyncTutorRewardSocialCmd(data)
  end)
  self:Listen(208, 95, function(data)
    self:RecvGlobalForwardCmdSocialCmd2(data)
  end)
  self:Listen(208, 65, function(data)
    self:RecvCardSceneCreateSocialCmd(data)
  end)
  self:Listen(208, 66, function(data)
    self:RecvCardSceneSyncSocialCmd(data)
  end)
  self:Listen(208, 98, function(data)
    self:RecvModifyDepositSocialCmd(data)
  end)
  self:Listen(208, 96, function(data)
    self:RecvTeamRaidSceneCreateSocialCmd(data)
  end)
  self:Listen(208, 97, function(data)
    self:RecvTeamRaidSceneSyncSocialCmd(data)
  end)
  self:Listen(208, 100, function(data)
    self:RecvGlobalForwardCmdSocialCmd3(data)
  end)
end
function ServiceSocialCmdAutoProxy:CallSessionForwardSocialCmd(type, user, data, len)
  local msg = SocialCmd_pb.SessionForwardSocialCmd()
  if type ~= nil then
    msg.type = type
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
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallForwardToUserSocialCmd(charid, data, len)
  local msg = SocialCmd_pb.ForwardToUserSocialCmd()
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
function ServiceSocialCmdAutoProxy:CallForwardToUserSceneSocialCmd(charid, data, len)
  local msg = SocialCmd_pb.ForwardToUserSceneSocialCmd()
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
function ServiceSocialCmdAutoProxy:CallForwardToSceneUserSocialCmd(charid, data, len)
  local msg = SocialCmd_pb.ForwardToSceneUserSocialCmd()
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
function ServiceSocialCmdAutoProxy:CallForwardToSessionUserSocialCmd(charid, data, len)
  local msg = SocialCmd_pb.ForwardToSessionUserSocialCmd()
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
function ServiceSocialCmdAutoProxy:CallOnlineStatusSocialCmd(user, online)
  local msg = SocialCmd_pb.OnlineStatusSocialCmd()
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
  if online ~= nil then
    msg.online = online
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallAddOfflineMsgSocialCmd(msg)
  local msg = SocialCmd_pb.AddOfflineMsgSocialCmd()
  if msg ~= nil and msg.targetid ~= nil then
    msg.msg.targetid = msg.targetid
  end
  if msg ~= nil and msg.senderid ~= nil then
    msg.msg.senderid = msg.senderid
  end
  if msg ~= nil and msg.time ~= nil then
    msg.msg.time = msg.time
  end
  if msg ~= nil and msg.type ~= nil then
    msg.msg.type = msg.type
  end
  if msg ~= nil and msg.sendername ~= nil then
    msg.msg.sendername = msg.sendername
  end
  if msg.chat ~= nil and msg.chat.cmd ~= nil then
    msg.msg.chat.cmd = msg.chat.cmd
  end
  if msg.chat ~= nil and msg.chat.param ~= nil then
    msg.msg.chat.param = msg.chat.param
  end
  msg.msg.chat.id = msg.chat.id
  if msg.chat ~= nil and msg.chat.targetid ~= nil then
    msg.msg.chat.targetid = msg.chat.targetid
  end
  msg.msg.chat.portrait = msg.chat.portrait
  msg.msg.chat.frame = msg.chat.frame
  if msg.chat ~= nil and msg.chat.baselevel ~= nil then
    msg.msg.chat.baselevel = msg.chat.baselevel
  end
  if msg.chat ~= nil and msg.chat.voiceid ~= nil then
    msg.msg.chat.voiceid = msg.chat.voiceid
  end
  if msg.chat ~= nil and msg.chat.voicetime ~= nil then
    msg.msg.chat.voicetime = msg.chat.voicetime
  end
  if msg.chat ~= nil and msg.chat.hair ~= nil then
    msg.msg.chat.hair = msg.chat.hair
  end
  if msg.chat ~= nil and msg.chat.haircolor ~= nil then
    msg.msg.chat.haircolor = msg.chat.haircolor
  end
  if msg.chat ~= nil and msg.chat.body ~= nil then
    msg.msg.chat.body = msg.chat.body
  end
  if msg.chat ~= nil and msg.chat.appellation ~= nil then
    msg.msg.chat.appellation = msg.chat.appellation
  end
  if msg.chat ~= nil and msg.chat.msgid ~= nil then
    msg.msg.chat.msgid = msg.chat.msgid
  end
  if msg.chat ~= nil and msg.chat.head ~= nil then
    msg.msg.chat.head = msg.chat.head
  end
  if msg.chat ~= nil and msg.chat.face ~= nil then
    msg.msg.chat.face = msg.chat.face
  end
  if msg.chat ~= nil and msg.chat.mouth ~= nil then
    msg.msg.chat.mouth = msg.chat.mouth
  end
  if msg.chat ~= nil and msg.chat.eye ~= nil then
    msg.msg.chat.eye = msg.chat.eye
  end
  if msg.chat ~= nil and msg.chat.channel ~= nil then
    msg.msg.chat.channel = msg.chat.channel
  end
  if msg.chat ~= nil and msg.chat.rolejob ~= nil then
    msg.msg.chat.rolejob = msg.chat.rolejob
  end
  if msg.chat ~= nil and msg.chat.gender ~= nil then
    msg.msg.chat.gender = msg.chat.gender
  end
  if msg.chat ~= nil and msg.chat.blink ~= nil then
    msg.msg.chat.blink = msg.chat.blink
  end
  msg.msg.chat.str = msg.chat.str
  msg.msg.chat.name = msg.chat.name
  if msg.chat ~= nil and msg.chat.guildname ~= nil then
    msg.msg.chat.guildname = msg.chat.guildname
  end
  if msg.chat ~= nil and msg.chat.sysmsgid ~= nil then
    msg.msg.chat.sysmsgid = msg.chat.sysmsgid
  end
  if msg ~= nil and msg.itemid ~= nil then
    msg.msg.itemid = msg.itemid
  end
  if msg ~= nil and msg.price ~= nil then
    msg.msg.price = msg.price
  end
  if msg ~= nil and msg.count ~= nil then
    msg.msg.count = msg.count
  end
  if msg ~= nil and msg.givemoney ~= nil then
    msg.msg.givemoney = msg.givemoney
  end
  if msg ~= nil and msg.moneytype ~= nil then
    msg.msg.moneytype = msg.moneytype
  end
  if msg ~= nil and msg.sysstr ~= nil then
    msg.msg.sysstr = msg.sysstr
  end
  if msg ~= nil and msg.gmcmd ~= nil then
    msg.msg.gmcmd = msg.gmcmd
  end
  if msg ~= nil and msg.id ~= nil then
    msg.msg.id = msg.id
  end
  if msg ~= nil and msg.msg ~= nil then
    msg.msg.msg = msg.msg
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.guid ~= nil then
    msg.msg.itemdata.base.guid = msg.itemdata.base.guid
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.id ~= nil then
    msg.msg.itemdata.base.id = msg.itemdata.base.id
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.count ~= nil then
    msg.msg.itemdata.base.count = msg.itemdata.base.count
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.index ~= nil then
    msg.msg.itemdata.base.index = msg.itemdata.base.index
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.createtime ~= nil then
    msg.msg.itemdata.base.createtime = msg.itemdata.base.createtime
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.cd ~= nil then
    msg.msg.itemdata.base.cd = msg.itemdata.base.cd
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.type ~= nil then
    msg.msg.itemdata.base.type = msg.itemdata.base.type
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.bind ~= nil then
    msg.msg.itemdata.base.bind = msg.itemdata.base.bind
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.expire ~= nil then
    msg.msg.itemdata.base.expire = msg.itemdata.base.expire
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.quality ~= nil then
    msg.msg.itemdata.base.quality = msg.itemdata.base.quality
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.equipType ~= nil then
    msg.msg.itemdata.base.equipType = msg.itemdata.base.equipType
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.source ~= nil then
    msg.msg.itemdata.base.source = msg.itemdata.base.source
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.isnew ~= nil then
    msg.msg.itemdata.base.isnew = msg.itemdata.base.isnew
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.maxcardslot ~= nil then
    msg.msg.itemdata.base.maxcardslot = msg.itemdata.base.maxcardslot
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.ishint ~= nil then
    msg.msg.itemdata.base.ishint = msg.itemdata.base.ishint
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.isactive ~= nil then
    msg.msg.itemdata.base.isactive = msg.itemdata.base.isactive
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.source_npc ~= nil then
    msg.msg.itemdata.base.source_npc = msg.itemdata.base.source_npc
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.refinelv ~= nil then
    msg.msg.itemdata.base.refinelv = msg.itemdata.base.refinelv
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.chargemoney ~= nil then
    msg.msg.itemdata.base.chargemoney = msg.itemdata.base.chargemoney
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.overtime ~= nil then
    msg.msg.itemdata.base.overtime = msg.itemdata.base.overtime
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.quota ~= nil then
    msg.msg.itemdata.base.quota = msg.itemdata.base.quota
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.usedtimes ~= nil then
    msg.msg.itemdata.base.usedtimes = msg.itemdata.base.usedtimes
  end
  if msg.itemdata.base ~= nil and msg.itemdata.base.usedtime ~= nil then
    msg.msg.itemdata.base.usedtime = msg.itemdata.base.usedtime
  end
  if msg.itemdata ~= nil and msg.itemdata.equiped ~= nil then
    msg.msg.itemdata.equiped = msg.itemdata.equiped
  end
  if msg.itemdata ~= nil and msg.itemdata.battlepoint ~= nil then
    msg.msg.itemdata.battlepoint = msg.itemdata.battlepoint
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.strengthlv ~= nil then
    msg.msg.itemdata.equip.strengthlv = msg.itemdata.equip.strengthlv
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.refinelv ~= nil then
    msg.msg.itemdata.equip.refinelv = msg.itemdata.equip.refinelv
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.strengthCost ~= nil then
    msg.msg.itemdata.equip.strengthCost = msg.itemdata.equip.strengthCost
  end
  if msg ~= nil and msg.itemdata.equip.refineCompose ~= nil then
    for i = 1, #msg.itemdata.equip.refineCompose do
      table.insert(msg.msg.itemdata.equip.refineCompose, msg.itemdata.equip.refineCompose[i])
    end
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.cardslot ~= nil then
    msg.msg.itemdata.equip.cardslot = msg.itemdata.equip.cardslot
  end
  if msg ~= nil and msg.itemdata.equip.buffid ~= nil then
    for i = 1, #msg.itemdata.equip.buffid do
      table.insert(msg.msg.itemdata.equip.buffid, msg.itemdata.equip.buffid[i])
    end
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.damage ~= nil then
    msg.msg.itemdata.equip.damage = msg.itemdata.equip.damage
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.lv ~= nil then
    msg.msg.itemdata.equip.lv = msg.itemdata.equip.lv
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.color ~= nil then
    msg.msg.itemdata.equip.color = msg.itemdata.equip.color
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.breakstarttime ~= nil then
    msg.msg.itemdata.equip.breakstarttime = msg.itemdata.equip.breakstarttime
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.breakendtime ~= nil then
    msg.msg.itemdata.equip.breakendtime = msg.itemdata.equip.breakendtime
  end
  if msg.itemdata.equip ~= nil and msg.itemdata.equip.strengthlv2 ~= nil then
    msg.msg.itemdata.equip.strengthlv2 = msg.itemdata.equip.strengthlv2
  end
  if msg ~= nil and msg.itemdata.equip.strengthlv2cost ~= nil then
    for i = 1, #msg.itemdata.equip.strengthlv2cost do
      table.insert(msg.msg.itemdata.equip.strengthlv2cost, msg.itemdata.equip.strengthlv2cost[i])
    end
  end
  if msg ~= nil and msg.itemdata.card ~= nil then
    for i = 1, #msg.itemdata.card do
      table.insert(msg.msg.itemdata.card, msg.itemdata.card[i])
    end
  end
  if msg.itemdata.enchant ~= nil and msg.itemdata.enchant.type ~= nil then
    msg.msg.itemdata.enchant.type = msg.itemdata.enchant.type
  end
  if msg ~= nil and msg.itemdata.enchant.attrs ~= nil then
    for i = 1, #msg.itemdata.enchant.attrs do
      table.insert(msg.msg.itemdata.enchant.attrs, msg.itemdata.enchant.attrs[i])
    end
  end
  if msg ~= nil and msg.itemdata.enchant.extras ~= nil then
    for i = 1, #msg.itemdata.enchant.extras do
      table.insert(msg.msg.itemdata.enchant.extras, msg.itemdata.enchant.extras[i])
    end
  end
  if msg ~= nil and msg.itemdata.enchant.patch ~= nil then
    for i = 1, #msg.itemdata.enchant.patch do
      table.insert(msg.msg.itemdata.enchant.patch, msg.itemdata.enchant.patch[i])
    end
  end
  if msg.itemdata.previewenchant ~= nil and msg.itemdata.previewenchant.type ~= nil then
    msg.msg.itemdata.previewenchant.type = msg.itemdata.previewenchant.type
  end
  if msg ~= nil and msg.itemdata.previewenchant.attrs ~= nil then
    for i = 1, #msg.itemdata.previewenchant.attrs do
      table.insert(msg.msg.itemdata.previewenchant.attrs, msg.itemdata.previewenchant.attrs[i])
    end
  end
  if msg ~= nil and msg.itemdata.previewenchant.extras ~= nil then
    for i = 1, #msg.itemdata.previewenchant.extras do
      table.insert(msg.msg.itemdata.previewenchant.extras, msg.itemdata.previewenchant.extras[i])
    end
  end
  if msg ~= nil and msg.itemdata.previewenchant.patch ~= nil then
    for i = 1, #msg.itemdata.previewenchant.patch do
      table.insert(msg.msg.itemdata.previewenchant.patch, msg.itemdata.previewenchant.patch[i])
    end
  end
  if msg.itemdata.refine ~= nil and msg.itemdata.refine.lastfail ~= nil then
    msg.msg.itemdata.refine.lastfail = msg.itemdata.refine.lastfail
  end
  if msg.itemdata.refine ~= nil and msg.itemdata.refine.repaircount ~= nil then
    msg.msg.itemdata.refine.repaircount = msg.itemdata.refine.repaircount
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.exp ~= nil then
    msg.msg.itemdata.egg.exp = msg.itemdata.egg.exp
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.friendexp ~= nil then
    msg.msg.itemdata.egg.friendexp = msg.itemdata.egg.friendexp
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.rewardexp ~= nil then
    msg.msg.itemdata.egg.rewardexp = msg.itemdata.egg.rewardexp
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.id ~= nil then
    msg.msg.itemdata.egg.id = msg.itemdata.egg.id
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.lv ~= nil then
    msg.msg.itemdata.egg.lv = msg.itemdata.egg.lv
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.friendlv ~= nil then
    msg.msg.itemdata.egg.friendlv = msg.itemdata.egg.friendlv
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.body ~= nil then
    msg.msg.itemdata.egg.body = msg.itemdata.egg.body
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.relivetime ~= nil then
    msg.msg.itemdata.egg.relivetime = msg.itemdata.egg.relivetime
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.hp ~= nil then
    msg.msg.itemdata.egg.hp = msg.itemdata.egg.hp
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.restoretime ~= nil then
    msg.msg.itemdata.egg.restoretime = msg.itemdata.egg.restoretime
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.time_happly ~= nil then
    msg.msg.itemdata.egg.time_happly = msg.itemdata.egg.time_happly
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.time_excite ~= nil then
    msg.msg.itemdata.egg.time_excite = msg.itemdata.egg.time_excite
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.time_happiness ~= nil then
    msg.msg.itemdata.egg.time_happiness = msg.itemdata.egg.time_happiness
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.time_happly_gift ~= nil then
    msg.msg.itemdata.egg.time_happly_gift = msg.itemdata.egg.time_happly_gift
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.time_excite_gift ~= nil then
    msg.msg.itemdata.egg.time_excite_gift = msg.itemdata.egg.time_excite_gift
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.time_happiness_gift ~= nil then
    msg.msg.itemdata.egg.time_happiness_gift = msg.itemdata.egg.time_happiness_gift
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.touch_tick ~= nil then
    msg.msg.itemdata.egg.touch_tick = msg.itemdata.egg.touch_tick
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.feed_tick ~= nil then
    msg.msg.itemdata.egg.feed_tick = msg.itemdata.egg.feed_tick
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.name ~= nil then
    msg.msg.itemdata.egg.name = msg.itemdata.egg.name
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.var ~= nil then
    msg.msg.itemdata.egg.var = msg.itemdata.egg.var
  end
  if msg ~= nil and msg.itemdata.egg.skillids ~= nil then
    for i = 1, #msg.itemdata.egg.skillids do
      table.insert(msg.msg.itemdata.egg.skillids, msg.itemdata.egg.skillids[i])
    end
  end
  if msg ~= nil and msg.itemdata.egg.equips ~= nil then
    for i = 1, #msg.itemdata.egg.equips do
      table.insert(msg.msg.itemdata.egg.equips, msg.itemdata.egg.equips[i])
    end
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.buff ~= nil then
    msg.msg.itemdata.egg.buff = msg.itemdata.egg.buff
  end
  if msg ~= nil and msg.itemdata.egg.unlock_equip ~= nil then
    for i = 1, #msg.itemdata.egg.unlock_equip do
      table.insert(msg.msg.itemdata.egg.unlock_equip, msg.itemdata.egg.unlock_equip[i])
    end
  end
  if msg ~= nil and msg.itemdata.egg.unlock_body ~= nil then
    for i = 1, #msg.itemdata.egg.unlock_body do
      table.insert(msg.msg.itemdata.egg.unlock_body, msg.itemdata.egg.unlock_body[i])
    end
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.version ~= nil then
    msg.msg.itemdata.egg.version = msg.itemdata.egg.version
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.skilloff ~= nil then
    msg.msg.itemdata.egg.skilloff = msg.itemdata.egg.skilloff
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.exchange_count ~= nil then
    msg.msg.itemdata.egg.exchange_count = msg.itemdata.egg.exchange_count
  end
  if msg.itemdata.egg ~= nil and msg.itemdata.egg.guid ~= nil then
    msg.msg.itemdata.egg.guid = msg.itemdata.egg.guid
  end
  if msg ~= nil and msg.itemdata.egg.defaultwears ~= nil then
    for i = 1, #msg.itemdata.egg.defaultwears do
      table.insert(msg.msg.itemdata.egg.defaultwears, msg.itemdata.egg.defaultwears[i])
    end
  end
  if msg ~= nil and msg.itemdata.egg.wears ~= nil then
    for i = 1, #msg.itemdata.egg.wears do
      table.insert(msg.msg.itemdata.egg.wears, msg.itemdata.egg.wears[i])
    end
  end
  if msg.itemdata.letter ~= nil and msg.itemdata.letter.sendUserName ~= nil then
    msg.msg.itemdata.letter.sendUserName = msg.itemdata.letter.sendUserName
  end
  if msg.itemdata.letter ~= nil and msg.itemdata.letter.bg ~= nil then
    msg.msg.itemdata.letter.bg = msg.itemdata.letter.bg
  end
  if msg.itemdata.letter ~= nil and msg.itemdata.letter.configID ~= nil then
    msg.msg.itemdata.letter.configID = msg.itemdata.letter.configID
  end
  if msg.itemdata.letter ~= nil and msg.itemdata.letter.content ~= nil then
    msg.msg.itemdata.letter.content = msg.itemdata.letter.content
  end
  if msg.itemdata.letter ~= nil and msg.itemdata.letter.content2 ~= nil then
    msg.msg.itemdata.letter.content2 = msg.itemdata.letter.content2
  end
  if msg.itemdata.code ~= nil and msg.itemdata.code.code ~= nil then
    msg.msg.itemdata.code.code = msg.itemdata.code.code
  end
  if msg.itemdata.code ~= nil and msg.itemdata.code.used ~= nil then
    msg.msg.itemdata.code.used = msg.itemdata.code.used
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.id ~= nil then
    msg.msg.itemdata.wedding.id = msg.itemdata.wedding.id
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.zoneid ~= nil then
    msg.msg.itemdata.wedding.zoneid = msg.itemdata.wedding.zoneid
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.charid1 ~= nil then
    msg.msg.itemdata.wedding.charid1 = msg.itemdata.wedding.charid1
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.charid2 ~= nil then
    msg.msg.itemdata.wedding.charid2 = msg.itemdata.wedding.charid2
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.weddingtime ~= nil then
    msg.msg.itemdata.wedding.weddingtime = msg.itemdata.wedding.weddingtime
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.photoidx ~= nil then
    msg.msg.itemdata.wedding.photoidx = msg.itemdata.wedding.photoidx
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.phototime ~= nil then
    msg.msg.itemdata.wedding.phototime = msg.itemdata.wedding.phototime
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.myname ~= nil then
    msg.msg.itemdata.wedding.myname = msg.itemdata.wedding.myname
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.partnername ~= nil then
    msg.msg.itemdata.wedding.partnername = msg.itemdata.wedding.partnername
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.starttime ~= nil then
    msg.msg.itemdata.wedding.starttime = msg.itemdata.wedding.starttime
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.endtime ~= nil then
    msg.msg.itemdata.wedding.endtime = msg.itemdata.wedding.endtime
  end
  if msg.itemdata.wedding ~= nil and msg.itemdata.wedding.notified ~= nil then
    msg.msg.itemdata.wedding.notified = msg.itemdata.wedding.notified
  end
  if msg.itemdata.sender ~= nil and msg.itemdata.sender.charid ~= nil then
    msg.msg.itemdata.sender.charid = msg.itemdata.sender.charid
  end
  if msg.itemdata.sender ~= nil and msg.itemdata.sender.name ~= nil then
    msg.msg.itemdata.sender.name = msg.itemdata.sender.name
  end
  if msg.syscmd ~= nil and msg.syscmd.cmd ~= nil then
    msg.msg.syscmd.cmd = msg.syscmd.cmd
  end
  if msg.syscmd ~= nil and msg.syscmd.param ~= nil then
    msg.msg.syscmd.param = msg.syscmd.param
  end
  if msg.syscmd ~= nil and msg.syscmd.id ~= nil then
    msg.msg.syscmd.id = msg.syscmd.id
  end
  if msg.syscmd ~= nil and msg.syscmd.type ~= nil then
    msg.msg.syscmd.type = msg.syscmd.type
  end
  if msg ~= nil and msg.syscmd.params ~= nil then
    for i = 1, #msg.syscmd.params do
      table.insert(msg.msg.syscmd.params, msg.syscmd.params[i])
    end
  end
  if msg.syscmd ~= nil and msg.syscmd.act ~= nil then
    msg.msg.syscmd.act = msg.syscmd.act
  end
  if msg.syscmd ~= nil and msg.syscmd.delay ~= nil then
    msg.msg.syscmd.delay = msg.syscmd.delay
  end
  if msg.tutorreward ~= nil and msg.tutorreward.charid ~= nil then
    msg.msg.tutorreward.charid = msg.tutorreward.charid
  end
  if msg.tutorreward ~= nil and msg.tutorreward.name ~= nil then
    msg.msg.tutorreward.name = msg.tutorreward.name
  end
  if msg ~= nil and msg.tutorreward.reward ~= nil then
    for i = 1, #msg.tutorreward.reward do
      table.insert(msg.msg.tutorreward.reward, msg.tutorreward.reward[i])
    end
  end
  if msg ~= nil and msg.tutorreward.item ~= nil then
    for i = 1, #msg.tutorreward.item do
      table.insert(msg.msg.tutorreward.item, msg.tutorreward.item[i])
    end
  end
  if msg.useradditem ~= nil and msg.useradditem.type ~= nil then
    msg.msg.useradditem.type = msg.useradditem.type
  end
  if msg ~= nil and msg.useradditem.items ~= nil then
    for i = 1, #msg.useradditem.items do
      table.insert(msg.msg.useradditem.items, msg.useradditem.items[i])
    end
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.cmd ~= nil then
    msg.msg.weddingmsg.cmd = msg.weddingmsg.cmd
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.param ~= nil then
    msg.msg.weddingmsg.param = msg.weddingmsg.param
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.charid ~= nil then
    msg.msg.weddingmsg.charid = msg.weddingmsg.charid
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.event ~= nil then
    msg.msg.weddingmsg.event = msg.weddingmsg.event
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.id ~= nil then
    msg.msg.weddingmsg.id = msg.weddingmsg.id
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.charid1 ~= nil then
    msg.msg.weddingmsg.charid1 = msg.weddingmsg.charid1
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.charid2 ~= nil then
    msg.msg.weddingmsg.charid2 = msg.weddingmsg.charid2
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.msg ~= nil then
    msg.msg.weddingmsg.msg = msg.weddingmsg.msg
  end
  if msg.weddingmsg ~= nil and msg.weddingmsg.opt_charid ~= nil then
    msg.msg.weddingmsg.opt_charid = msg.weddingmsg.opt_charid
  end
  if msg.quotadata ~= nil and msg.quotadata.quota ~= nil then
    msg.msg.quotadata.quota = msg.quotadata.quota
  end
  if msg.quotadata ~= nil and msg.quotadata.oper ~= nil then
    msg.msg.quotadata.oper = msg.quotadata.oper
  end
  if msg.quotadata ~= nil and msg.quotadata.type ~= nil then
    msg.msg.quotadata.type = msg.quotadata.type
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallUserInfoSyncSocialCmd(info)
  local msg = SocialCmd_pb.UserInfoSyncSocialCmd()
  if info.user ~= nil and info.user.accid ~= nil then
    msg.info.user.accid = info.user.accid
  end
  if info.user ~= nil and info.user.charid ~= nil then
    msg.info.user.charid = info.user.charid
  end
  if info.user ~= nil and info.user.zoneid ~= nil then
    msg.info.user.zoneid = info.user.zoneid
  end
  if info.user ~= nil and info.user.mapid ~= nil then
    msg.info.user.mapid = info.user.mapid
  end
  if info.user ~= nil and info.user.baselv ~= nil then
    msg.info.user.baselv = info.user.baselv
  end
  if info.user ~= nil and info.user.profession ~= nil then
    msg.info.user.profession = info.user.profession
  end
  if info.user ~= nil and info.user.name ~= nil then
    msg.info.user.name = info.user.name
  end
  if info.user ~= nil and info.user.guildid ~= nil then
    msg.info.user.guildid = info.user.guildid
  end
  if info ~= nil and info.datas ~= nil then
    for i = 1, #info.datas do
      table.insert(msg.info.datas, info.datas[i])
    end
  end
  if info ~= nil and info.attrs ~= nil then
    for i = 1, #info.attrs do
      table.insert(msg.info.attrs, info.attrs[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallUserAddItemSocialCmd(user, items, doublereward, operatereward)
  local msg = SocialCmd_pb.UserAddItemSocialCmd()
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
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if doublereward ~= nil then
    msg.doublereward = doublereward
  end
  if operatereward ~= nil then
    msg.operatereward = operatereward
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallUserDelSocialCmd(charid)
  local msg = SocialCmd_pb.UserDelSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallUserGuildInfoSocialCmd(charid, name, portrait)
  local msg = SocialCmd_pb.UserGuildInfoSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if name ~= nil then
    msg.name = name
  end
  if portrait ~= nil then
    msg.portrait = portrait
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallChatWorldMsgSocialCmd(msg)
  local msg = SocialCmd_pb.ChatWorldMsgSocialCmd()
  if msg ~= nil and msg.cmd ~= nil then
    msg.msg.cmd = msg.cmd
  end
  if msg ~= nil and msg.param ~= nil then
    msg.msg.param = msg.param
  end
  if msg ~= nil and msg.id ~= nil then
    msg.msg.id = msg.id
  end
  if msg ~= nil and msg.type ~= nil then
    msg.msg.type = msg.type
  end
  if msg ~= nil and msg.params ~= nil then
    for i = 1, #msg.params do
      table.insert(msg.msg.params, msg.params[i])
    end
  end
  if msg ~= nil and msg.act ~= nil then
    msg.msg.act = msg.act
  end
  if msg ~= nil and msg.delay ~= nil then
    msg.msg.delay = msg.delay
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallChatSocialCmd(ret, targets, accid, platformid, to_global)
  local msg = SocialCmd_pb.ChatSocialCmd()
  if ret ~= nil and ret.cmd ~= nil then
    msg.ret.cmd = ret.cmd
  end
  if ret ~= nil and ret.param ~= nil then
    msg.ret.param = ret.param
  end
  msg.ret.id = ret.id
  if ret ~= nil and ret.targetid ~= nil then
    msg.ret.targetid = ret.targetid
  end
  msg.ret.portrait = ret.portrait
  msg.ret.frame = ret.frame
  if ret ~= nil and ret.baselevel ~= nil then
    msg.ret.baselevel = ret.baselevel
  end
  if ret ~= nil and ret.voiceid ~= nil then
    msg.ret.voiceid = ret.voiceid
  end
  if ret ~= nil and ret.voicetime ~= nil then
    msg.ret.voicetime = ret.voicetime
  end
  if ret ~= nil and ret.hair ~= nil then
    msg.ret.hair = ret.hair
  end
  if ret ~= nil and ret.haircolor ~= nil then
    msg.ret.haircolor = ret.haircolor
  end
  if ret ~= nil and ret.body ~= nil then
    msg.ret.body = ret.body
  end
  if ret ~= nil and ret.appellation ~= nil then
    msg.ret.appellation = ret.appellation
  end
  if ret ~= nil and ret.msgid ~= nil then
    msg.ret.msgid = ret.msgid
  end
  if ret ~= nil and ret.head ~= nil then
    msg.ret.head = ret.head
  end
  if ret ~= nil and ret.face ~= nil then
    msg.ret.face = ret.face
  end
  if ret ~= nil and ret.mouth ~= nil then
    msg.ret.mouth = ret.mouth
  end
  if ret ~= nil and ret.eye ~= nil then
    msg.ret.eye = ret.eye
  end
  if ret ~= nil and ret.channel ~= nil then
    msg.ret.channel = ret.channel
  end
  if ret ~= nil and ret.rolejob ~= nil then
    msg.ret.rolejob = ret.rolejob
  end
  if ret ~= nil and ret.gender ~= nil then
    msg.ret.gender = ret.gender
  end
  if ret ~= nil and ret.blink ~= nil then
    msg.ret.blink = ret.blink
  end
  msg.ret.str = ret.str
  msg.ret.name = ret.name
  if ret ~= nil and ret.guildname ~= nil then
    msg.ret.guildname = ret.guildname
  end
  if ret ~= nil and ret.sysmsgid ~= nil then
    msg.ret.sysmsgid = ret.sysmsgid
  end
  if targets ~= nil then
    for i = 1, #targets do
      table.insert(msg.targets, targets[i])
    end
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if platformid ~= nil then
    msg.platformid = platformid
  end
  if to_global ~= nil then
    msg.to_global = to_global
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallCreateGuildSocialCmd(user, msgid, name)
  local msg = SocialCmd_pb.CreateGuildSocialCmd()
  if user.user ~= nil and user.user.accid ~= nil then
    msg.user.user.accid = user.user.accid
  end
  if user.user ~= nil and user.user.charid ~= nil then
    msg.user.user.charid = user.user.charid
  end
  if user.user ~= nil and user.user.zoneid ~= nil then
    msg.user.user.zoneid = user.user.zoneid
  end
  if user.user ~= nil and user.user.mapid ~= nil then
    msg.user.user.mapid = user.user.mapid
  end
  if user.user ~= nil and user.user.baselv ~= nil then
    msg.user.user.baselv = user.user.baselv
  end
  if user.user ~= nil and user.user.profession ~= nil then
    msg.user.user.profession = user.user.profession
  end
  if user.user ~= nil and user.user.name ~= nil then
    msg.user.user.name = user.user.name
  end
  if user.user ~= nil and user.user.guildid ~= nil then
    msg.user.user.guildid = user.user.guildid
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if name ~= nil then
    msg.name = name
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGuildDonateSocialCmd(user, item, msgid)
  local msg = SocialCmd_pb.GuildDonateSocialCmd()
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
  if item ~= nil and item.configid ~= nil then
    msg.item.configid = item.configid
  end
  if item ~= nil and item.count ~= nil then
    msg.item.count = item.count
  end
  if item ~= nil and item.time ~= nil then
    msg.item.time = item.time
  end
  if item ~= nil and item.itemid ~= nil then
    msg.item.itemid = item.itemid
  end
  if item ~= nil and item.itemcount ~= nil then
    msg.item.itemcount = item.itemcount
  end
  if item ~= nil and item.contribute ~= nil then
    msg.item.contribute = item.contribute
  end
  if item ~= nil and item.medal ~= nil then
    msg.item.medal = item.medal
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGuildApplySocialCmd(user, guildid)
  local msg = SocialCmd_pb.GuildApplySocialCmd()
  if user.user ~= nil and user.user.accid ~= nil then
    msg.user.user.accid = user.user.accid
  end
  if user.user ~= nil and user.user.charid ~= nil then
    msg.user.user.charid = user.user.charid
  end
  if user.user ~= nil and user.user.zoneid ~= nil then
    msg.user.user.zoneid = user.user.zoneid
  end
  if user.user ~= nil and user.user.mapid ~= nil then
    msg.user.user.mapid = user.user.mapid
  end
  if user.user ~= nil and user.user.baselv ~= nil then
    msg.user.user.baselv = user.user.baselv
  end
  if user.user ~= nil and user.user.profession ~= nil then
    msg.user.user.profession = user.user.profession
  end
  if user.user ~= nil and user.user.name ~= nil then
    msg.user.user.name = user.user.name
  end
  if user.user ~= nil and user.user.guildid ~= nil then
    msg.user.user.guildid = user.user.guildid
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGuildProcessInviteSocialCmd(user, action, guildid)
  local msg = SocialCmd_pb.GuildProcessInviteSocialCmd()
  if user.user ~= nil and user.user.accid ~= nil then
    msg.user.user.accid = user.user.accid
  end
  if user.user ~= nil and user.user.charid ~= nil then
    msg.user.user.charid = user.user.charid
  end
  if user.user ~= nil and user.user.zoneid ~= nil then
    msg.user.user.zoneid = user.user.zoneid
  end
  if user.user ~= nil and user.user.mapid ~= nil then
    msg.user.user.mapid = user.user.mapid
  end
  if user.user ~= nil and user.user.baselv ~= nil then
    msg.user.user.baselv = user.user.baselv
  end
  if user.user ~= nil and user.user.profession ~= nil then
    msg.user.user.profession = user.user.profession
  end
  if user.user ~= nil and user.user.name ~= nil then
    msg.user.user.name = user.user.name
  end
  if user.user ~= nil and user.user.guildid ~= nil then
    msg.user.user.guildid = user.user.guildid
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if action ~= nil then
    msg.action = action
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGuildExchangeZoneSocialCmd(user, zoneid)
  local msg = SocialCmd_pb.GuildExchangeZoneSocialCmd()
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
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamCreateSocialCmd(users, team)
  local msg = SocialCmd_pb.TeamCreateSocialCmd()
  if users ~= nil then
    for i = 1, #users do
      table.insert(msg.users, users[i])
    end
  end
  if team ~= nil and team.cmd ~= nil then
    msg.team.cmd = team.cmd
  end
  if team ~= nil and team.param ~= nil then
    msg.team.param = team.param
  end
  if team ~= nil and team.minlv ~= nil then
    msg.team.minlv = team.minlv
  end
  if team ~= nil and team.maxlv ~= nil then
    msg.team.maxlv = team.maxlv
  end
  if team ~= nil and team.type ~= nil then
    msg.team.type = team.type
  end
  if team ~= nil and team.autoaccept ~= nil then
    msg.team.autoaccept = team.autoaccept
  end
  if team ~= nil and team.name ~= nil then
    msg.team.name = team.name
  end
  if team ~= nil and team.state ~= nil then
    msg.team.state = team.state
  end
  if team ~= nil and team.desc ~= nil then
    msg.team.desc = team.desc
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamInviteSocialCmd(invite, beinvite)
  local msg = SocialCmd_pb.TeamInviteSocialCmd()
  if invite.user ~= nil and invite.user.accid ~= nil then
    msg.invite.user.accid = invite.user.accid
  end
  if invite.user ~= nil and invite.user.charid ~= nil then
    msg.invite.user.charid = invite.user.charid
  end
  if invite.user ~= nil and invite.user.zoneid ~= nil then
    msg.invite.user.zoneid = invite.user.zoneid
  end
  if invite.user ~= nil and invite.user.mapid ~= nil then
    msg.invite.user.mapid = invite.user.mapid
  end
  if invite.user ~= nil and invite.user.baselv ~= nil then
    msg.invite.user.baselv = invite.user.baselv
  end
  if invite.user ~= nil and invite.user.profession ~= nil then
    msg.invite.user.profession = invite.user.profession
  end
  if invite.user ~= nil and invite.user.name ~= nil then
    msg.invite.user.name = invite.user.name
  end
  if invite.user ~= nil and invite.user.guildid ~= nil then
    msg.invite.user.guildid = invite.user.guildid
  end
  if invite ~= nil and invite.datas ~= nil then
    for i = 1, #invite.datas do
      table.insert(msg.invite.datas, invite.datas[i])
    end
  end
  if invite ~= nil and invite.attrs ~= nil then
    for i = 1, #invite.attrs do
      table.insert(msg.invite.attrs, invite.attrs[i])
    end
  end
  if beinvite ~= nil and beinvite.accid ~= nil then
    msg.beinvite.accid = beinvite.accid
  end
  if beinvite ~= nil and beinvite.charid ~= nil then
    msg.beinvite.charid = beinvite.charid
  end
  if beinvite ~= nil and beinvite.zoneid ~= nil then
    msg.beinvite.zoneid = beinvite.zoneid
  end
  if beinvite ~= nil and beinvite.mapid ~= nil then
    msg.beinvite.mapid = beinvite.mapid
  end
  if beinvite ~= nil and beinvite.baselv ~= nil then
    msg.beinvite.baselv = beinvite.baselv
  end
  if beinvite ~= nil and beinvite.profession ~= nil then
    msg.beinvite.profession = beinvite.profession
  end
  if beinvite ~= nil and beinvite.name ~= nil then
    msg.beinvite.name = beinvite.name
  end
  if beinvite ~= nil and beinvite.guildid ~= nil then
    msg.beinvite.guildid = beinvite.guildid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamProcessInviteSocialCmd(type, user, leaderid)
  local msg = SocialCmd_pb.TeamProcessInviteSocialCmd()
  if type ~= nil then
    msg.type = type
  end
  if user.user ~= nil and user.user.accid ~= nil then
    msg.user.user.accid = user.user.accid
  end
  if user.user ~= nil and user.user.charid ~= nil then
    msg.user.user.charid = user.user.charid
  end
  if user.user ~= nil and user.user.zoneid ~= nil then
    msg.user.user.zoneid = user.user.zoneid
  end
  if user.user ~= nil and user.user.mapid ~= nil then
    msg.user.user.mapid = user.user.mapid
  end
  if user.user ~= nil and user.user.baselv ~= nil then
    msg.user.user.baselv = user.user.baselv
  end
  if user.user ~= nil and user.user.profession ~= nil then
    msg.user.user.profession = user.user.profession
  end
  if user.user ~= nil and user.user.name ~= nil then
    msg.user.user.name = user.user.name
  end
  if user.user ~= nil and user.user.guildid ~= nil then
    msg.user.user.guildid = user.user.guildid
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if leaderid ~= nil then
    msg.leaderid = leaderid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamApplySocialCmd(apply, teamid)
  local msg = SocialCmd_pb.TeamApplySocialCmd()
  if apply.user ~= nil and apply.user.accid ~= nil then
    msg.apply.user.accid = apply.user.accid
  end
  if apply.user ~= nil and apply.user.charid ~= nil then
    msg.apply.user.charid = apply.user.charid
  end
  if apply.user ~= nil and apply.user.zoneid ~= nil then
    msg.apply.user.zoneid = apply.user.zoneid
  end
  if apply.user ~= nil and apply.user.mapid ~= nil then
    msg.apply.user.mapid = apply.user.mapid
  end
  if apply.user ~= nil and apply.user.baselv ~= nil then
    msg.apply.user.baselv = apply.user.baselv
  end
  if apply.user ~= nil and apply.user.profession ~= nil then
    msg.apply.user.profession = apply.user.profession
  end
  if apply.user ~= nil and apply.user.name ~= nil then
    msg.apply.user.name = apply.user.name
  end
  if apply.user ~= nil and apply.user.guildid ~= nil then
    msg.apply.user.guildid = apply.user.guildid
  end
  if apply ~= nil and apply.datas ~= nil then
    for i = 1, #apply.datas do
      table.insert(msg.apply.datas, apply.datas[i])
    end
  end
  if apply ~= nil and apply.attrs ~= nil then
    for i = 1, #apply.attrs do
      table.insert(msg.apply.attrs, apply.attrs[i])
    end
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamQuickEnterSocialCmd(user, type, set)
  local msg = SocialCmd_pb.TeamQuickEnterSocialCmd()
  if user.user ~= nil and user.user.accid ~= nil then
    msg.user.user.accid = user.user.accid
  end
  if user.user ~= nil and user.user.charid ~= nil then
    msg.user.user.charid = user.user.charid
  end
  if user.user ~= nil and user.user.zoneid ~= nil then
    msg.user.user.zoneid = user.user.zoneid
  end
  if user.user ~= nil and user.user.mapid ~= nil then
    msg.user.user.mapid = user.user.mapid
  end
  if user.user ~= nil and user.user.baselv ~= nil then
    msg.user.user.baselv = user.user.baselv
  end
  if user.user ~= nil and user.user.profession ~= nil then
    msg.user.user.profession = user.user.profession
  end
  if user.user ~= nil and user.user.name ~= nil then
    msg.user.user.name = user.user.name
  end
  if user.user ~= nil and user.user.guildid ~= nil then
    msg.user.user.guildid = user.user.guildid
  end
  if user ~= nil and user.datas ~= nil then
    for i = 1, #user.datas do
      table.insert(msg.user.datas, user.datas[i])
    end
  end
  if user ~= nil and user.attrs ~= nil then
    for i = 1, #user.attrs do
      table.insert(msg.user.attrs, user.attrs[i])
    end
  end
  if type ~= nil then
    msg.type = type
  end
  if set ~= nil then
    msg.set = set
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallDojoStateNtfSocialCmd(teamid, guildid, state)
  local msg = SocialCmd_pb.DojoStateNtfSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if state ~= nil then
    msg.state = state
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallDojoCreateSocialCmd(charid, dojoid, teamid, guildid)
  local msg = SocialCmd_pb.DojoCreateSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if dojoid ~= nil then
    msg.dojoid = dojoid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTowerLeaderInfoSyncSocialCmd(user, info)
  local msg = SocialCmd_pb.TowerLeaderInfoSyncSocialCmd()
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
  if info ~= nil and info.oldmaxlayer ~= nil then
    msg.info.oldmaxlayer = info.oldmaxlayer
  end
  if info ~= nil and info.curmaxlayer ~= nil then
    msg.info.curmaxlayer = info.curmaxlayer
  end
  if info ~= nil and info.layers ~= nil then
    for i = 1, #info.layers do
      table.insert(msg.info.layers, info.layers[i])
    end
  end
  if info ~= nil and info.maxlayer ~= nil then
    msg.info.maxlayer = info.maxlayer
  end
  if info ~= nil and info.record_layer ~= nil then
    msg.info.record_layer = info.record_layer
  end
  if info ~= nil and info.everpasslayers ~= nil then
    for i = 1, #info.everpasslayers do
      table.insert(msg.info.everpasslayers, info.everpasslayers[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTowerSceneCreateSocialCmd(user, teamid, layer)
  local msg = SocialCmd_pb.TowerSceneCreateSocialCmd()
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
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if layer ~= nil then
    msg.layer = layer
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTowerSceneSyncSocialCmd(teamid, state, raidid)
  local msg = SocialCmd_pb.TowerSceneSyncSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if state ~= nil then
    msg.state = state
  end
  if raidid ~= nil then
    msg.raidid = raidid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTowerLayerSyncSocialCmd(teamid, layer)
  local msg = SocialCmd_pb.TowerLayerSyncSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if layer ~= nil then
    msg.layer = layer
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallLeaderSealFinishSocialCmd(teamid)
  local msg = SocialCmd_pb.LeaderSealFinishSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGoTeamRaidSocialCmd(teamid, charid, myzoneid, raidzoneid, raidid, gomaptype)
  local msg = SocialCmd_pb.GoTeamRaidSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if myzoneid ~= nil then
    msg.myzoneid = myzoneid
  end
  if raidzoneid ~= nil then
    msg.raidzoneid = raidzoneid
  end
  if raidid ~= nil then
    msg.raidid = raidid
  end
  if gomaptype ~= nil then
    msg.gomaptype = gomaptype
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallDelTeamRaidSocialCmd(teamid, raidid)
  local msg = SocialCmd_pb.DelTeamRaidSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if raidid ~= nil then
    msg.raidid = raidid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallSendMailSocialCmd(zoneid, data, len)
  local msg = SocialCmd_pb.SendMailSocialCmd()
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallForwardToAllSessionSocialCmd(except, data, len)
  local msg = SocialCmd_pb.ForwardToAllSessionSocialCmd()
  if except ~= nil then
    msg.except = except
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGuildLevelUpSocialCmd(charid, guildid, addlevel, guildname)
  local msg = SocialCmd_pb.GuildLevelUpSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if addlevel ~= nil then
    msg.addlevel = addlevel
  end
  if guildname ~= nil then
    msg.guildname = guildname
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallMoveGuildZoneSocialCmd(orizone, newzone)
  local msg = SocialCmd_pb.MoveGuildZoneSocialCmd()
  if orizone ~= nil then
    msg.orizone = orizone
  end
  if newzone ~= nil then
    msg.newzone = newzone
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallSocialDataUpdateSocialCmd(charid, targetid, update, to_global)
  local msg = SocialCmd_pb.SocialDataUpdateSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  if update ~= nil and update.cmd ~= nil then
    msg.update.cmd = update.cmd
  end
  if update ~= nil and update.param ~= nil then
    msg.update.param = update.param
  end
  if update ~= nil and update.guid ~= nil then
    msg.update.guid = update.guid
  end
  if update ~= nil and update.items ~= nil then
    for i = 1, #update.items do
      table.insert(msg.update.items, update.items[i])
    end
  end
  if to_global ~= nil then
    msg.to_global = to_global
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallAddRelationSocialCmd(user, destid, relation, to_global, check)
  local msg = SocialCmd_pb.AddRelationSocialCmd()
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
  if destid ~= nil then
    msg.destid = destid
  end
  if relation ~= nil then
    msg.relation = relation
  end
  if to_global ~= nil then
    msg.to_global = to_global
  end
  if check ~= nil then
    msg.check = check
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallRemoveRelationSocialCmd(user, destid, relation, to_global)
  local msg = SocialCmd_pb.RemoveRelationSocialCmd()
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
  if destid ~= nil then
    msg.destid = destid
  end
  if relation ~= nil then
    msg.relation = relation
  end
  if to_global ~= nil then
    msg.to_global = to_global
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallRemoveFocusSocialCmd(user, destid, to_global)
  local msg = SocialCmd_pb.RemoveFocusSocialCmd()
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
  if destid ~= nil then
    msg.destid = destid
  end
  if to_global ~= nil then
    msg.to_global = to_global
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallRemoveSocialitySocialCmd(user, destid, to_global)
  local msg = SocialCmd_pb.RemoveSocialitySocialCmd()
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
  if destid ~= nil then
    msg.destid = destid
  end
  if to_global ~= nil then
    msg.to_global = to_global
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallSyncSocialListSocialCmd(charid, items)
  local msg = SocialCmd_pb.SyncSocialListSocialCmd()
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
function ServiceSocialCmdAutoProxy:CallSocialListUpdateSocialCmd(charid, updates, dels)
  local msg = SocialCmd_pb.SocialListUpdateSocialCmd()
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
function ServiceSocialCmdAutoProxy:CallUpdateRelationTimeSocialCmd(charid, targetid, time, relation)
  local msg = SocialCmd_pb.UpdateRelationTimeSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  if time ~= nil then
    msg.time = time
  end
  if relation ~= nil then
    msg.relation = relation
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamerQuestUpdateSocialCmd(quest)
  local msg = SocialCmd_pb.TeamerQuestUpdateSocialCmd()
  if quest ~= nil and quest.charid ~= nil then
    msg.quest.charid = quest.charid
  end
  if quest ~= nil and quest.questid ~= nil then
    msg.quest.questid = quest.questid
  end
  if quest ~= nil and quest.action ~= nil then
    msg.quest.action = quest.action
  end
  if quest ~= nil and quest.step ~= nil then
    msg.quest.step = quest.step
  end
  if quest.questdata ~= nil and quest.questdata.process ~= nil then
    msg.quest.questdata.process = quest.questdata.process
  end
  if quest ~= nil and quest.questdata.params ~= nil then
    for i = 1, #quest.questdata.params do
      table.insert(msg.quest.questdata.params, quest.questdata.params[i])
    end
  end
  if quest ~= nil and quest.questdata.names ~= nil then
    for i = 1, #quest.questdata.names do
      table.insert(msg.quest.questdata.names, quest.questdata.names[i])
    end
  end
  if quest.questdata.config ~= nil and quest.questdata.config.RewardGroup ~= nil then
    msg.quest.questdata.config.RewardGroup = quest.questdata.config.RewardGroup
  end
  if quest.questdata.config ~= nil and quest.questdata.config.SubGroup ~= nil then
    msg.quest.questdata.config.SubGroup = quest.questdata.config.SubGroup
  end
  if quest.questdata.config ~= nil and quest.questdata.config.FinishJump ~= nil then
    msg.quest.questdata.config.FinishJump = quest.questdata.config.FinishJump
  end
  if quest.questdata.config ~= nil and quest.questdata.config.FailJump ~= nil then
    msg.quest.questdata.config.FailJump = quest.questdata.config.FailJump
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Map ~= nil then
    msg.quest.questdata.config.Map = quest.questdata.config.Map
  end
  if quest.questdata.config ~= nil and quest.questdata.config.WhetherTrace ~= nil then
    msg.quest.questdata.config.WhetherTrace = quest.questdata.config.WhetherTrace
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Auto ~= nil then
    msg.quest.questdata.config.Auto = quest.questdata.config.Auto
  end
  if quest.questdata.config ~= nil and quest.questdata.config.FirstClass ~= nil then
    msg.quest.questdata.config.FirstClass = quest.questdata.config.FirstClass
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Class ~= nil then
    msg.quest.questdata.config.Class = quest.questdata.config.Class
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Level ~= nil then
    msg.quest.questdata.config.Level = quest.questdata.config.Level
  end
  if quest.questdata.config ~= nil and quest.questdata.config.PreNoShow ~= nil then
    msg.quest.questdata.config.PreNoShow = quest.questdata.config.PreNoShow
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Risklevel ~= nil then
    msg.quest.questdata.config.Risklevel = quest.questdata.config.Risklevel
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Joblevel ~= nil then
    msg.quest.questdata.config.Joblevel = quest.questdata.config.Joblevel
  end
  if quest.questdata.config ~= nil and quest.questdata.config.CookerLv ~= nil then
    msg.quest.questdata.config.CookerLv = quest.questdata.config.CookerLv
  end
  if quest.questdata.config ~= nil and quest.questdata.config.TasterLv ~= nil then
    msg.quest.questdata.config.TasterLv = quest.questdata.config.TasterLv
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Icon ~= nil then
    msg.quest.questdata.config.Icon = quest.questdata.config.Icon
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Color ~= nil then
    msg.quest.questdata.config.Color = quest.questdata.config.Color
  end
  if quest.questdata.config ~= nil and quest.questdata.config.QuestName ~= nil then
    msg.quest.questdata.config.QuestName = quest.questdata.config.QuestName
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Name ~= nil then
    msg.quest.questdata.config.Name = quest.questdata.config.Name
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Type ~= nil then
    msg.quest.questdata.config.Type = quest.questdata.config.Type
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Content ~= nil then
    msg.quest.questdata.config.Content = quest.questdata.config.Content
  end
  if quest.questdata.config ~= nil and quest.questdata.config.TraceInfo ~= nil then
    msg.quest.questdata.config.TraceInfo = quest.questdata.config.TraceInfo
  end
  if quest.questdata.config ~= nil and quest.questdata.config.Prefixion ~= nil then
    msg.quest.questdata.config.Prefixion = quest.questdata.config.Prefixion
  end
  if quest ~= nil and quest.questdata.config.params.params ~= nil then
    for i = 1, #quest.questdata.config.params.params do
      table.insert(msg.quest.questdata.config.params.params, quest.questdata.config.params.params[i])
    end
  end
  if quest ~= nil and quest.questdata.config.allrewardid ~= nil then
    for i = 1, #quest.questdata.config.allrewardid do
      table.insert(msg.quest.questdata.config.allrewardid, quest.questdata.config.allrewardid[i])
    end
  end
  if quest ~= nil and quest.questdata.config.PreQuest ~= nil then
    for i = 1, #quest.questdata.config.PreQuest do
      table.insert(msg.quest.questdata.config.PreQuest, quest.questdata.config.PreQuest[i])
    end
  end
  if quest ~= nil and quest.questdata.config.MustPreQuest ~= nil then
    for i = 1, #quest.questdata.config.MustPreQuest do
      table.insert(msg.quest.questdata.config.MustPreQuest, quest.questdata.config.MustPreQuest[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGlobalForwardCmdSocialCmd(charid, data, len, dir)
  local msg = SocialCmd_pb.GlobalForwardCmdSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  if dir ~= nil then
    msg.dir = dir
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallAuthorizeInfoSyncSocialCmd(charid, ignorepwd)
  local msg = SocialCmd_pb.AuthorizeInfoSyncSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if ignorepwd ~= nil then
    msg.ignorepwd = ignorepwd
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallSyncRedTipSocialCmd(dwid, charid, red, add)
  local msg = SocialCmd_pb.SyncRedTipSocialCmd()
  if dwid ~= nil then
    msg.dwid = dwid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if red ~= nil then
    msg.red = red
  end
  if add ~= nil then
    msg.add = add
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallSendTutorRewardSocialCmd(charid, rewards)
  local msg = SocialCmd_pb.SendTutorRewardSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if rewards ~= nil then
    for i = 1, #rewards do
      table.insert(msg.rewards, rewards[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallSyncTutorRewardSocialCmd(searchuser, charid, reward, redpointtip)
  local msg = SocialCmd_pb.SyncTutorRewardSocialCmd()
  if searchuser ~= nil then
    msg.searchuser = searchuser
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if reward ~= nil and reward.charid ~= nil then
    msg.reward.charid = reward.charid
  end
  if reward ~= nil and reward.name ~= nil then
    msg.reward.name = reward.name
  end
  if reward ~= nil and reward.reward ~= nil then
    for i = 1, #reward.reward do
      table.insert(msg.reward.reward, reward.reward[i])
    end
  end
  if reward ~= nil and reward.item ~= nil then
    for i = 1, #reward.item do
      table.insert(msg.reward.item, reward.item[i])
    end
  end
  if redpointtip ~= nil then
    msg.redpointtip = redpointtip
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGlobalForwardCmdSocialCmd2(charid, data, len)
  local msg = SocialCmd_pb.GlobalForwardCmdSocialCmd2()
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
function ServiceSocialCmdAutoProxy:CallCardSceneCreateSocialCmd(userid, teamid, configid)
  local msg = SocialCmd_pb.CardSceneCreateSocialCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if configid ~= nil then
    msg.configid = configid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallCardSceneSyncSocialCmd(teamid, open)
  local msg = SocialCmd_pb.CardSceneSyncSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if open ~= nil then
    msg.open = open
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallModifyDepositSocialCmd(charid, command)
  local msg = SocialCmd_pb.ModifyDepositSocialCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if command ~= nil then
    msg.command = command
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamRaidSceneCreateSocialCmd(user, teamid, raid_type)
  local msg = SocialCmd_pb.TeamRaidSceneCreateSocialCmd()
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
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if raid_type ~= nil then
    msg.raid_type = raid_type
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallTeamRaidSceneSyncSocialCmd(teamid, open, raid_type, raid, zoneid)
  local msg = SocialCmd_pb.TeamRaidSceneSyncSocialCmd()
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if open ~= nil then
    msg.open = open
  end
  if raid_type ~= nil then
    msg.raid_type = raid_type
  end
  if raid ~= nil then
    msg.raid = raid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:CallGlobalForwardCmdSocialCmd3(charid, data, len, dir)
  local msg = SocialCmd_pb.GlobalForwardCmdSocialCmd3()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  if dir ~= nil then
    msg.dir = dir
  end
  self:SendProto(msg)
end
function ServiceSocialCmdAutoProxy:RecvSessionForwardSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSessionForwardSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvForwardToUserSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdForwardToUserSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvForwardToUserSceneSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdForwardToUserSceneSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvForwardToSceneUserSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdForwardToSceneUserSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvForwardToSessionUserSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdForwardToSessionUserSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvOnlineStatusSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdOnlineStatusSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvAddOfflineMsgSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdAddOfflineMsgSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvUserInfoSyncSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdUserInfoSyncSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvUserAddItemSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdUserAddItemSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvUserDelSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdUserDelSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvUserGuildInfoSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdUserGuildInfoSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvChatWorldMsgSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdChatWorldMsgSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvChatSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdChatSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvCreateGuildSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdCreateGuildSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGuildDonateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdGuildDonateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGuildApplySocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdGuildApplySocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGuildProcessInviteSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdGuildProcessInviteSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGuildExchangeZoneSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdGuildExchangeZoneSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamCreateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamCreateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamInviteSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamInviteSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamProcessInviteSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamProcessInviteSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamApplySocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamApplySocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamQuickEnterSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamQuickEnterSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvDojoStateNtfSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdDojoStateNtfSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvDojoCreateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdDojoCreateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTowerLeaderInfoSyncSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTowerLeaderInfoSyncSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTowerSceneCreateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTowerSceneCreateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTowerSceneSyncSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTowerSceneSyncSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTowerLayerSyncSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTowerLayerSyncSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvLeaderSealFinishSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdLeaderSealFinishSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGoTeamRaidSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdGoTeamRaidSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvDelTeamRaidSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdDelTeamRaidSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvSendMailSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSendMailSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvForwardToAllSessionSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdForwardToAllSessionSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGuildLevelUpSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdGuildLevelUpSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvMoveGuildZoneSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdMoveGuildZoneSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvSocialDataUpdateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSocialDataUpdateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvAddRelationSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdAddRelationSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvRemoveRelationSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdRemoveRelationSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvRemoveFocusSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdRemoveFocusSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvRemoveSocialitySocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdRemoveSocialitySocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvSyncSocialListSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSyncSocialListSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvSocialListUpdateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSocialListUpdateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvUpdateRelationTimeSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdUpdateRelationTimeSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamerQuestUpdateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamerQuestUpdateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGlobalForwardCmdSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvAuthorizeInfoSyncSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdAuthorizeInfoSyncSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvSyncRedTipSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSyncRedTipSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvSendTutorRewardSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSendTutorRewardSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvSyncTutorRewardSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdSyncTutorRewardSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGlobalForwardCmdSocialCmd2(data)
  self:Notify(ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd2, data)
end
function ServiceSocialCmdAutoProxy:RecvCardSceneCreateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdCardSceneCreateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvCardSceneSyncSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdCardSceneSyncSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvModifyDepositSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdModifyDepositSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamRaidSceneCreateSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamRaidSceneCreateSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvTeamRaidSceneSyncSocialCmd(data)
  self:Notify(ServiceEvent.SocialCmdTeamRaidSceneSyncSocialCmd, data)
end
function ServiceSocialCmdAutoProxy:RecvGlobalForwardCmdSocialCmd3(data)
  self:Notify(ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd3, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SocialCmdSessionForwardSocialCmd = "ServiceEvent_SocialCmdSessionForwardSocialCmd"
ServiceEvent.SocialCmdForwardToUserSocialCmd = "ServiceEvent_SocialCmdForwardToUserSocialCmd"
ServiceEvent.SocialCmdForwardToUserSceneSocialCmd = "ServiceEvent_SocialCmdForwardToUserSceneSocialCmd"
ServiceEvent.SocialCmdForwardToSceneUserSocialCmd = "ServiceEvent_SocialCmdForwardToSceneUserSocialCmd"
ServiceEvent.SocialCmdForwardToSessionUserSocialCmd = "ServiceEvent_SocialCmdForwardToSessionUserSocialCmd"
ServiceEvent.SocialCmdOnlineStatusSocialCmd = "ServiceEvent_SocialCmdOnlineStatusSocialCmd"
ServiceEvent.SocialCmdAddOfflineMsgSocialCmd = "ServiceEvent_SocialCmdAddOfflineMsgSocialCmd"
ServiceEvent.SocialCmdUserInfoSyncSocialCmd = "ServiceEvent_SocialCmdUserInfoSyncSocialCmd"
ServiceEvent.SocialCmdUserAddItemSocialCmd = "ServiceEvent_SocialCmdUserAddItemSocialCmd"
ServiceEvent.SocialCmdUserDelSocialCmd = "ServiceEvent_SocialCmdUserDelSocialCmd"
ServiceEvent.SocialCmdUserGuildInfoSocialCmd = "ServiceEvent_SocialCmdUserGuildInfoSocialCmd"
ServiceEvent.SocialCmdChatWorldMsgSocialCmd = "ServiceEvent_SocialCmdChatWorldMsgSocialCmd"
ServiceEvent.SocialCmdChatSocialCmd = "ServiceEvent_SocialCmdChatSocialCmd"
ServiceEvent.SocialCmdCreateGuildSocialCmd = "ServiceEvent_SocialCmdCreateGuildSocialCmd"
ServiceEvent.SocialCmdGuildDonateSocialCmd = "ServiceEvent_SocialCmdGuildDonateSocialCmd"
ServiceEvent.SocialCmdGuildApplySocialCmd = "ServiceEvent_SocialCmdGuildApplySocialCmd"
ServiceEvent.SocialCmdGuildProcessInviteSocialCmd = "ServiceEvent_SocialCmdGuildProcessInviteSocialCmd"
ServiceEvent.SocialCmdGuildExchangeZoneSocialCmd = "ServiceEvent_SocialCmdGuildExchangeZoneSocialCmd"
ServiceEvent.SocialCmdTeamCreateSocialCmd = "ServiceEvent_SocialCmdTeamCreateSocialCmd"
ServiceEvent.SocialCmdTeamInviteSocialCmd = "ServiceEvent_SocialCmdTeamInviteSocialCmd"
ServiceEvent.SocialCmdTeamProcessInviteSocialCmd = "ServiceEvent_SocialCmdTeamProcessInviteSocialCmd"
ServiceEvent.SocialCmdTeamApplySocialCmd = "ServiceEvent_SocialCmdTeamApplySocialCmd"
ServiceEvent.SocialCmdTeamQuickEnterSocialCmd = "ServiceEvent_SocialCmdTeamQuickEnterSocialCmd"
ServiceEvent.SocialCmdDojoStateNtfSocialCmd = "ServiceEvent_SocialCmdDojoStateNtfSocialCmd"
ServiceEvent.SocialCmdDojoCreateSocialCmd = "ServiceEvent_SocialCmdDojoCreateSocialCmd"
ServiceEvent.SocialCmdTowerLeaderInfoSyncSocialCmd = "ServiceEvent_SocialCmdTowerLeaderInfoSyncSocialCmd"
ServiceEvent.SocialCmdTowerSceneCreateSocialCmd = "ServiceEvent_SocialCmdTowerSceneCreateSocialCmd"
ServiceEvent.SocialCmdTowerSceneSyncSocialCmd = "ServiceEvent_SocialCmdTowerSceneSyncSocialCmd"
ServiceEvent.SocialCmdTowerLayerSyncSocialCmd = "ServiceEvent_SocialCmdTowerLayerSyncSocialCmd"
ServiceEvent.SocialCmdLeaderSealFinishSocialCmd = "ServiceEvent_SocialCmdLeaderSealFinishSocialCmd"
ServiceEvent.SocialCmdGoTeamRaidSocialCmd = "ServiceEvent_SocialCmdGoTeamRaidSocialCmd"
ServiceEvent.SocialCmdDelTeamRaidSocialCmd = "ServiceEvent_SocialCmdDelTeamRaidSocialCmd"
ServiceEvent.SocialCmdSendMailSocialCmd = "ServiceEvent_SocialCmdSendMailSocialCmd"
ServiceEvent.SocialCmdForwardToAllSessionSocialCmd = "ServiceEvent_SocialCmdForwardToAllSessionSocialCmd"
ServiceEvent.SocialCmdGuildLevelUpSocialCmd = "ServiceEvent_SocialCmdGuildLevelUpSocialCmd"
ServiceEvent.SocialCmdMoveGuildZoneSocialCmd = "ServiceEvent_SocialCmdMoveGuildZoneSocialCmd"
ServiceEvent.SocialCmdSocialDataUpdateSocialCmd = "ServiceEvent_SocialCmdSocialDataUpdateSocialCmd"
ServiceEvent.SocialCmdAddRelationSocialCmd = "ServiceEvent_SocialCmdAddRelationSocialCmd"
ServiceEvent.SocialCmdRemoveRelationSocialCmd = "ServiceEvent_SocialCmdRemoveRelationSocialCmd"
ServiceEvent.SocialCmdRemoveFocusSocialCmd = "ServiceEvent_SocialCmdRemoveFocusSocialCmd"
ServiceEvent.SocialCmdRemoveSocialitySocialCmd = "ServiceEvent_SocialCmdRemoveSocialitySocialCmd"
ServiceEvent.SocialCmdSyncSocialListSocialCmd = "ServiceEvent_SocialCmdSyncSocialListSocialCmd"
ServiceEvent.SocialCmdSocialListUpdateSocialCmd = "ServiceEvent_SocialCmdSocialListUpdateSocialCmd"
ServiceEvent.SocialCmdUpdateRelationTimeSocialCmd = "ServiceEvent_SocialCmdUpdateRelationTimeSocialCmd"
ServiceEvent.SocialCmdTeamerQuestUpdateSocialCmd = "ServiceEvent_SocialCmdTeamerQuestUpdateSocialCmd"
ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd = "ServiceEvent_SocialCmdGlobalForwardCmdSocialCmd"
ServiceEvent.SocialCmdAuthorizeInfoSyncSocialCmd = "ServiceEvent_SocialCmdAuthorizeInfoSyncSocialCmd"
ServiceEvent.SocialCmdSyncRedTipSocialCmd = "ServiceEvent_SocialCmdSyncRedTipSocialCmd"
ServiceEvent.SocialCmdSendTutorRewardSocialCmd = "ServiceEvent_SocialCmdSendTutorRewardSocialCmd"
ServiceEvent.SocialCmdSyncTutorRewardSocialCmd = "ServiceEvent_SocialCmdSyncTutorRewardSocialCmd"
ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd2 = "ServiceEvent_SocialCmdGlobalForwardCmdSocialCmd2"
ServiceEvent.SocialCmdCardSceneCreateSocialCmd = "ServiceEvent_SocialCmdCardSceneCreateSocialCmd"
ServiceEvent.SocialCmdCardSceneSyncSocialCmd = "ServiceEvent_SocialCmdCardSceneSyncSocialCmd"
ServiceEvent.SocialCmdModifyDepositSocialCmd = "ServiceEvent_SocialCmdModifyDepositSocialCmd"
ServiceEvent.SocialCmdTeamRaidSceneCreateSocialCmd = "ServiceEvent_SocialCmdTeamRaidSceneCreateSocialCmd"
ServiceEvent.SocialCmdTeamRaidSceneSyncSocialCmd = "ServiceEvent_SocialCmdTeamRaidSceneSyncSocialCmd"
ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd3 = "ServiceEvent_SocialCmdGlobalForwardCmdSocialCmd3"
