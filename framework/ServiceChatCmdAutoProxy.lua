ServiceChatCmdAutoProxy = class("ServiceChatCmdAutoProxy", ServiceProxy)
ServiceChatCmdAutoProxy.Instance = nil
ServiceChatCmdAutoProxy.NAME = "ServiceChatCmdAutoProxy"
function ServiceChatCmdAutoProxy:ctor(proxyName)
  if ServiceChatCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceChatCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceChatCmdAutoProxy.Instance = self
  end
end
function ServiceChatCmdAutoProxy:Init()
end
function ServiceChatCmdAutoProxy:onRegister()
  self:Listen(59, 1, function(data)
    self:RecvQueryItemData(data)
  end)
  self:Listen(59, 2, function(data)
    self:RecvPlayExpressionChatCmd(data)
  end)
  self:Listen(59, 3, function(data)
    self:RecvQueryUserInfoChatCmd(data)
  end)
  self:Listen(59, 4, function(data)
    self:RecvBarrageChatCmd(data)
  end)
  self:Listen(59, 5, function(data)
    self:RecvBarrageMsgChatCmd(data)
  end)
  self:Listen(59, 6, function(data)
    self:RecvChatCmd(data)
  end)
  self:Listen(59, 7, function(data)
    self:RecvChatRetCmd(data)
  end)
  self:Listen(59, 8, function(data)
    self:RecvQueryVoiceUserCmd(data)
  end)
  self:Listen(59, 10, function(data)
    self:RecvGetVoiceIDChatCmd(data)
  end)
  self:Listen(59, 11, function(data)
    self:RecvLoveLetterNtf(data)
  end)
  self:Listen(59, 12, function(data)
    self:RecvChatSelfNtf(data)
  end)
  self:Listen(59, 13, function(data)
    self:RecvNpcChatNtf(data)
  end)
  self:Listen(59, 14, function(data)
    self:RecvQueryRealtimeVoiceIDCmd(data)
  end)
  self:Listen(59, 16, function(data)
    self:RecvQueryUserShowInfoCmd(data)
  end)
  self:Listen(59, 15, function(data)
    self:RecvSystemBarrageChatCmd(data)
  end)
end
function ServiceChatCmdAutoProxy:CallQueryItemData(guid, data)
  local msg = ChatCmd_pb.QueryItemData()
  if guid ~= nil then
    msg.guid = guid
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
  if data.base ~= nil and data.base.isfavorite ~= nil then
    msg.data.base.isfavorite = data.base.isfavorite
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
function ServiceChatCmdAutoProxy:CallPlayExpressionChatCmd(charid, expressionid)
  local msg = ChatCmd_pb.PlayExpressionChatCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if expressionid ~= nil then
    msg.expressionid = expressionid
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallQueryUserInfoChatCmd(charid, msgid, type, info)
  local msg = ChatCmd_pb.QueryUserInfoChatCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if type ~= nil then
    msg.type = type
  end
  if info ~= nil and info.charid ~= nil then
    msg.info.charid = info.charid
  end
  if info ~= nil and info.guildid ~= nil then
    msg.info.guildid = info.guildid
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.guildname ~= nil then
    msg.info.guildname = info.guildname
  end
  if info ~= nil and info.guildportrait ~= nil then
    msg.info.guildportrait = info.guildportrait
  end
  if info ~= nil and info.guildjob ~= nil then
    msg.info.guildjob = info.guildjob
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
  if info ~= nil and info.equip ~= nil then
    for i = 1, #info.equip do
      table.insert(msg.info.equip, info.equip[i])
    end
  end
  if info ~= nil and info.fashion ~= nil then
    for i = 1, #info.fashion do
      table.insert(msg.info.fashion, info.fashion[i])
    end
  end
  if info ~= nil and info.highrefine ~= nil then
    for i = 1, #info.highrefine do
      table.insert(msg.info.highrefine, info.highrefine[i])
    end
  end
  if info ~= nil and info.partner ~= nil then
    msg.info.partner = info.partner
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallBarrageChatCmd(opt)
  local msg = ChatCmd_pb.BarrageChatCmd()
  if opt ~= nil then
    msg.opt = opt
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallBarrageMsgChatCmd(str, msgpos, clr, speed, userid, frame)
  local msg = ChatCmd_pb.BarrageMsgChatCmd()
  if str ~= nil then
    msg.str = str
  end
  if msgpos ~= nil and msgpos.x ~= nil then
    msg.msgpos.x = msgpos.x
  end
  if msgpos ~= nil and msgpos.y ~= nil then
    msg.msgpos.y = msgpos.y
  end
  if msgpos ~= nil and msgpos.z ~= nil then
    msg.msgpos.z = msgpos.z
  end
  if clr ~= nil and clr.r ~= nil then
    msg.clr.r = clr.r
  end
  if clr ~= nil and clr.g ~= nil then
    msg.clr.g = clr.g
  end
  if clr ~= nil and clr.b ~= nil then
    msg.clr.b = clr.b
  end
  if speed ~= nil then
    msg.speed = speed
  end
  if userid ~= nil then
    msg.userid = userid
  end
  if frame ~= nil then
    msg.frame = frame
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallChatCmd(channel, str, desID, voice, voicetime, msgid, msgover)
  local msg = ChatCmd_pb.ChatCmd()
  if channel ~= nil then
    msg.channel = channel
  end
  msg.str = str
  if desID ~= nil then
    msg.desID = desID
  end
  if voice ~= nil then
    msg.voice = voice
  end
  if voicetime ~= nil then
    msg.voicetime = voicetime
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if msgover ~= nil then
    msg.msgover = msgover
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallChatRetCmd(id, targetid, portrait, frame, baselevel, voiceid, voicetime, hair, haircolor, body, appellation, msgid, head, face, mouth, eye, channel, rolejob, gender, blink, str, name, guildname, sysmsgid)
  local msg = ChatCmd_pb.ChatRetCmd()
  msg.id = id
  if targetid ~= nil then
    msg.targetid = targetid
  end
  msg.portrait = portrait
  msg.frame = frame
  if baselevel ~= nil then
    msg.baselevel = baselevel
  end
  if voiceid ~= nil then
    msg.voiceid = voiceid
  end
  if voicetime ~= nil then
    msg.voicetime = voicetime
  end
  if hair ~= nil then
    msg.hair = hair
  end
  if haircolor ~= nil then
    msg.haircolor = haircolor
  end
  if body ~= nil then
    msg.body = body
  end
  if appellation ~= nil then
    msg.appellation = appellation
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if head ~= nil then
    msg.head = head
  end
  if face ~= nil then
    msg.face = face
  end
  if mouth ~= nil then
    msg.mouth = mouth
  end
  if eye ~= nil then
    msg.eye = eye
  end
  if channel ~= nil then
    msg.channel = channel
  end
  if rolejob ~= nil then
    msg.rolejob = rolejob
  end
  if gender ~= nil then
    msg.gender = gender
  end
  if blink ~= nil then
    msg.blink = blink
  end
  msg.str = str
  msg.name = name
  if guildname ~= nil then
    msg.guildname = guildname
  end
  if sysmsgid ~= nil then
    msg.sysmsgid = sysmsgid
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallQueryVoiceUserCmd(voiceid, voice, msgid, msgover)
  local msg = ChatCmd_pb.QueryVoiceUserCmd()
  if voiceid ~= nil then
    msg.voiceid = voiceid
  end
  if voice ~= nil then
    msg.voice = voice
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if msgover ~= nil then
    msg.msgover = msgover
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallGetVoiceIDChatCmd(id)
  local msg = ChatCmd_pb.GetVoiceIDChatCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallLoveLetterNtf(name, content, type, bg, letterID, configID, content2)
  local msg = ChatCmd_pb.LoveLetterNtf()
  if name ~= nil then
    msg.name = name
  end
  if content ~= nil then
    msg.content = content
  end
  if type ~= nil then
    msg.type = type
  end
  if bg ~= nil then
    msg.bg = bg
  end
  if letterID ~= nil then
    msg.letterID = letterID
  end
  if configID ~= nil then
    msg.configID = configID
  end
  if content2 ~= nil then
    msg.content2 = content2
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallChatSelfNtf(chat)
  local msg = ChatCmd_pb.ChatSelfNtf()
  if chat ~= nil and chat.cmd ~= nil then
    msg.chat.cmd = chat.cmd
  end
  if chat ~= nil and chat.param ~= nil then
    msg.chat.param = chat.param
  end
  if chat ~= nil and chat.channel ~= nil then
    msg.chat.channel = chat.channel
  end
  msg.chat.str = chat.str
  if chat ~= nil and chat.desID ~= nil then
    msg.chat.desID = chat.desID
  end
  if chat ~= nil and chat.voice ~= nil then
    msg.chat.voice = chat.voice
  end
  if chat ~= nil and chat.voicetime ~= nil then
    msg.chat.voicetime = chat.voicetime
  end
  if chat ~= nil and chat.msgid ~= nil then
    msg.chat.msgid = chat.msgid
  end
  if chat ~= nil and chat.msgover ~= nil then
    msg.chat.msgover = chat.msgover
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallNpcChatNtf(channel, npcid, msgid, params, msg, npcguid)
  local msg = ChatCmd_pb.NpcChatNtf()
  if channel ~= nil then
    msg.channel = channel
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  if params ~= nil then
    for i = 1, #params do
      table.insert(msg.params, params[i])
    end
  end
  if msg ~= nil then
    msg.msg = msg
  end
  if npcguid ~= nil then
    msg.npcguid = npcguid
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallQueryRealtimeVoiceIDCmd(channel, id)
  local msg = ChatCmd_pb.QueryRealtimeVoiceIDCmd()
  if channel ~= nil then
    msg.channel = channel
  end
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallQueryUserShowInfoCmd(targetid, info)
  local msg = ChatCmd_pb.QueryUserShowInfoCmd()
  if targetid ~= nil then
    msg.targetid = targetid
  end
  if info ~= nil and info.charid ~= nil then
    msg.info.charid = info.charid
  end
  if info ~= nil and info.guildid ~= nil then
    msg.info.guildid = info.guildid
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.guildname ~= nil then
    msg.info.guildname = info.guildname
  end
  if info ~= nil and info.guildportrait ~= nil then
    msg.info.guildportrait = info.guildportrait
  end
  if info ~= nil and info.guildjob ~= nil then
    msg.info.guildjob = info.guildjob
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
  if info ~= nil and info.equip ~= nil then
    for i = 1, #info.equip do
      table.insert(msg.info.equip, info.equip[i])
    end
  end
  if info ~= nil and info.fashion ~= nil then
    for i = 1, #info.fashion do
      table.insert(msg.info.fashion, info.fashion[i])
    end
  end
  if info ~= nil and info.highrefine ~= nil then
    for i = 1, #info.highrefine do
      table.insert(msg.info.highrefine, info.highrefine[i])
    end
  end
  if info ~= nil and info.partner ~= nil then
    msg.info.partner = info.partner
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:CallSystemBarrageChatCmd(type, msgid)
  local msg = ChatCmd_pb.SystemBarrageChatCmd()
  if type ~= nil then
    msg.type = type
  end
  if msgid ~= nil then
    msg.msgid = msgid
  end
  self:SendProto(msg)
end
function ServiceChatCmdAutoProxy:RecvQueryItemData(data)
  self:Notify(ServiceEvent.ChatCmdQueryItemData, data)
end
function ServiceChatCmdAutoProxy:RecvPlayExpressionChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdPlayExpressionChatCmd, data)
end
function ServiceChatCmdAutoProxy:RecvQueryUserInfoChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryUserInfoChatCmd, data)
end
function ServiceChatCmdAutoProxy:RecvBarrageChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdBarrageChatCmd, data)
end
function ServiceChatCmdAutoProxy:RecvBarrageMsgChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdBarrageMsgChatCmd, data)
end
function ServiceChatCmdAutoProxy:RecvChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdChatCmd, data)
end
function ServiceChatCmdAutoProxy:RecvChatRetCmd(data)
  self:Notify(ServiceEvent.ChatCmdChatRetCmd, data)
end
function ServiceChatCmdAutoProxy:RecvQueryVoiceUserCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryVoiceUserCmd, data)
end
function ServiceChatCmdAutoProxy:RecvGetVoiceIDChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdGetVoiceIDChatCmd, data)
end
function ServiceChatCmdAutoProxy:RecvLoveLetterNtf(data)
  self:Notify(ServiceEvent.ChatCmdLoveLetterNtf, data)
end
function ServiceChatCmdAutoProxy:RecvChatSelfNtf(data)
  self:Notify(ServiceEvent.ChatCmdChatSelfNtf, data)
end
function ServiceChatCmdAutoProxy:RecvNpcChatNtf(data)
  self:Notify(ServiceEvent.ChatCmdNpcChatNtf, data)
end
function ServiceChatCmdAutoProxy:RecvQueryRealtimeVoiceIDCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryRealtimeVoiceIDCmd, data)
end
function ServiceChatCmdAutoProxy:RecvQueryUserShowInfoCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryUserShowInfoCmd, data)
end
function ServiceChatCmdAutoProxy:RecvSystemBarrageChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdSystemBarrageChatCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ChatCmdQueryItemData = "ServiceEvent_ChatCmdQueryItemData"
ServiceEvent.ChatCmdPlayExpressionChatCmd = "ServiceEvent_ChatCmdPlayExpressionChatCmd"
ServiceEvent.ChatCmdQueryUserInfoChatCmd = "ServiceEvent_ChatCmdQueryUserInfoChatCmd"
ServiceEvent.ChatCmdBarrageChatCmd = "ServiceEvent_ChatCmdBarrageChatCmd"
ServiceEvent.ChatCmdBarrageMsgChatCmd = "ServiceEvent_ChatCmdBarrageMsgChatCmd"
ServiceEvent.ChatCmdChatCmd = "ServiceEvent_ChatCmdChatCmd"
ServiceEvent.ChatCmdChatRetCmd = "ServiceEvent_ChatCmdChatRetCmd"
ServiceEvent.ChatCmdQueryVoiceUserCmd = "ServiceEvent_ChatCmdQueryVoiceUserCmd"
ServiceEvent.ChatCmdGetVoiceIDChatCmd = "ServiceEvent_ChatCmdGetVoiceIDChatCmd"
ServiceEvent.ChatCmdLoveLetterNtf = "ServiceEvent_ChatCmdLoveLetterNtf"
ServiceEvent.ChatCmdChatSelfNtf = "ServiceEvent_ChatCmdChatSelfNtf"
ServiceEvent.ChatCmdNpcChatNtf = "ServiceEvent_ChatCmdNpcChatNtf"
ServiceEvent.ChatCmdQueryRealtimeVoiceIDCmd = "ServiceEvent_ChatCmdQueryRealtimeVoiceIDCmd"
ServiceEvent.ChatCmdQueryUserShowInfoCmd = "ServiceEvent_ChatCmdQueryUserShowInfoCmd"
ServiceEvent.ChatCmdSystemBarrageChatCmd = "ServiceEvent_ChatCmdSystemBarrageChatCmd"
