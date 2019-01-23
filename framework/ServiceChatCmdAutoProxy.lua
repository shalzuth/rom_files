ServiceChatCmdAutoProxy = class('ServiceChatCmdAutoProxy', ServiceProxy)

ServiceChatCmdAutoProxy.Instance = nil

ServiceChatCmdAutoProxy.NAME = 'ServiceChatCmdAutoProxy'

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
	self:Listen(59, 1, function (data)
		self:RecvQueryItemData(data) 
	end)
	self:Listen(59, 2, function (data)
		self:RecvPlayExpressionChatCmd(data) 
	end)
	self:Listen(59, 3, function (data)
		self:RecvQueryUserInfoChatCmd(data) 
	end)
	self:Listen(59, 4, function (data)
		self:RecvBarrageChatCmd(data) 
	end)
	self:Listen(59, 5, function (data)
		self:RecvBarrageMsgChatCmd(data) 
	end)
	self:Listen(59, 6, function (data)
		self:RecvChatCmd(data) 
	end)
	self:Listen(59, 7, function (data)
		self:RecvChatRetCmd(data) 
	end)
	self:Listen(59, 8, function (data)
		self:RecvQueryVoiceUserCmd(data) 
	end)
	self:Listen(59, 10, function (data)
		self:RecvGetVoiceIDChatCmd(data) 
	end)
	self:Listen(59, 11, function (data)
		self:RecvLoveLetterNtf(data) 
	end)
	self:Listen(59, 12, function (data)
		self:RecvChatSelfNtf(data) 
	end)
	self:Listen(59, 13, function (data)
		self:RecvNpcChatNtf(data) 
	end)
	self:Listen(59, 14, function (data)
		self:RecvQueryRealtimeVoiceIDCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceChatCmdAutoProxy:CallQueryItemData(guid, data) 
	local msg = ChatCmd_pb.QueryItemData()
	if(guid ~= nil )then
		msg.guid = guid
	end
	if(data.base ~= nil )then
		if(data.base.guid ~= nil )then
			msg.data.base.guid = data.base.guid
		end
	end
	if(data.base ~= nil )then
		if(data.base.id ~= nil )then
			msg.data.base.id = data.base.id
		end
	end
	if(data.base ~= nil )then
		if(data.base.count ~= nil )then
			msg.data.base.count = data.base.count
		end
	end
	if(data.base ~= nil )then
		if(data.base.index ~= nil )then
			msg.data.base.index = data.base.index
		end
	end
	if(data.base ~= nil )then
		if(data.base.createtime ~= nil )then
			msg.data.base.createtime = data.base.createtime
		end
	end
	if(data.base ~= nil )then
		if(data.base.cd ~= nil )then
			msg.data.base.cd = data.base.cd
		end
	end
	if(data.base ~= nil )then
		if(data.base.type ~= nil )then
			msg.data.base.type = data.base.type
		end
	end
	if(data.base ~= nil )then
		if(data.base.bind ~= nil )then
			msg.data.base.bind = data.base.bind
		end
	end
	if(data.base ~= nil )then
		if(data.base.expire ~= nil )then
			msg.data.base.expire = data.base.expire
		end
	end
	if(data.base ~= nil )then
		if(data.base.quality ~= nil )then
			msg.data.base.quality = data.base.quality
		end
	end
	if(data.base ~= nil )then
		if(data.base.equipType ~= nil )then
			msg.data.base.equipType = data.base.equipType
		end
	end
	if(data.base ~= nil )then
		if(data.base.source ~= nil )then
			msg.data.base.source = data.base.source
		end
	end
	if(data.base ~= nil )then
		if(data.base.isnew ~= nil )then
			msg.data.base.isnew = data.base.isnew
		end
	end
	if(data.base ~= nil )then
		if(data.base.maxcardslot ~= nil )then
			msg.data.base.maxcardslot = data.base.maxcardslot
		end
	end
	if(data.base ~= nil )then
		if(data.base.ishint ~= nil )then
			msg.data.base.ishint = data.base.ishint
		end
	end
	if(data.base ~= nil )then
		if(data.base.isactive ~= nil )then
			msg.data.base.isactive = data.base.isactive
		end
	end
	if(data.base ~= nil )then
		if(data.base.source_npc ~= nil )then
			msg.data.base.source_npc = data.base.source_npc
		end
	end
	if(data.base ~= nil )then
		if(data.base.refinelv ~= nil )then
			msg.data.base.refinelv = data.base.refinelv
		end
	end
	if(data.base ~= nil )then
		if(data.base.chargemoney ~= nil )then
			msg.data.base.chargemoney = data.base.chargemoney
		end
	end
	if(data.base ~= nil )then
		if(data.base.overtime ~= nil )then
			msg.data.base.overtime = data.base.overtime
		end
	end
	if(data.base ~= nil )then
		if(data.base.quota ~= nil )then
			msg.data.base.quota = data.base.quota
		end
	end
	if(data ~= nil )then
		if(data.equiped ~= nil )then
			msg.data.equiped = data.equiped
		end
	end
	if(data ~= nil )then
		if(data.battlepoint ~= nil )then
			msg.data.battlepoint = data.battlepoint
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.strengthlv ~= nil )then
			msg.data.equip.strengthlv = data.equip.strengthlv
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.refinelv ~= nil )then
			msg.data.equip.refinelv = data.equip.refinelv
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.strengthCost ~= nil )then
			msg.data.equip.strengthCost = data.equip.strengthCost
		end
	end
	if(data ~= nil )then
		if(data.equip.refineCompose ~= nil )then
			for i=1,#data.equip.refineCompose do 
				table.insert(msg.data.equip.refineCompose, data.equip.refineCompose[i])
			end
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.cardslot ~= nil )then
			msg.data.equip.cardslot = data.equip.cardslot
		end
	end
	if(data ~= nil )then
		if(data.equip.buffid ~= nil )then
			for i=1,#data.equip.buffid do 
				table.insert(msg.data.equip.buffid, data.equip.buffid[i])
			end
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.damage ~= nil )then
			msg.data.equip.damage = data.equip.damage
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.lv ~= nil )then
			msg.data.equip.lv = data.equip.lv
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.color ~= nil )then
			msg.data.equip.color = data.equip.color
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.breakstarttime ~= nil )then
			msg.data.equip.breakstarttime = data.equip.breakstarttime
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.breakendtime ~= nil )then
			msg.data.equip.breakendtime = data.equip.breakendtime
		end
	end
	if(data.equip ~= nil )then
		if(data.equip.strengthlv2 ~= nil )then
			msg.data.equip.strengthlv2 = data.equip.strengthlv2
		end
	end
	if(data ~= nil )then
		if(data.equip.strengthlv2cost ~= nil )then
			for i=1,#data.equip.strengthlv2cost do 
				table.insert(msg.data.equip.strengthlv2cost, data.equip.strengthlv2cost[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.card ~= nil )then
			for i=1,#data.card do 
				table.insert(msg.data.card, data.card[i])
			end
		end
	end
	if(data.enchant ~= nil )then
		if(data.enchant.type ~= nil )then
			msg.data.enchant.type = data.enchant.type
		end
	end
	if(data ~= nil )then
		if(data.enchant.attrs ~= nil )then
			for i=1,#data.enchant.attrs do 
				table.insert(msg.data.enchant.attrs, data.enchant.attrs[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.enchant.extras ~= nil )then
			for i=1,#data.enchant.extras do 
				table.insert(msg.data.enchant.extras, data.enchant.extras[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.enchant.patch ~= nil )then
			for i=1,#data.enchant.patch do 
				table.insert(msg.data.enchant.patch, data.enchant.patch[i])
			end
		end
	end
	if(data.previewenchant ~= nil )then
		if(data.previewenchant.type ~= nil )then
			msg.data.previewenchant.type = data.previewenchant.type
		end
	end
	if(data ~= nil )then
		if(data.previewenchant.attrs ~= nil )then
			for i=1,#data.previewenchant.attrs do 
				table.insert(msg.data.previewenchant.attrs, data.previewenchant.attrs[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.previewenchant.extras ~= nil )then
			for i=1,#data.previewenchant.extras do 
				table.insert(msg.data.previewenchant.extras, data.previewenchant.extras[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.previewenchant.patch ~= nil )then
			for i=1,#data.previewenchant.patch do 
				table.insert(msg.data.previewenchant.patch, data.previewenchant.patch[i])
			end
		end
	end
	if(data.refine ~= nil )then
		if(data.refine.lastfail ~= nil )then
			msg.data.refine.lastfail = data.refine.lastfail
		end
	end
	if(data.refine ~= nil )then
		if(data.refine.repaircount ~= nil )then
			msg.data.refine.repaircount = data.refine.repaircount
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.exp ~= nil )then
			msg.data.egg.exp = data.egg.exp
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.friendexp ~= nil )then
			msg.data.egg.friendexp = data.egg.friendexp
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.rewardexp ~= nil )then
			msg.data.egg.rewardexp = data.egg.rewardexp
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.id ~= nil )then
			msg.data.egg.id = data.egg.id
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.lv ~= nil )then
			msg.data.egg.lv = data.egg.lv
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.friendlv ~= nil )then
			msg.data.egg.friendlv = data.egg.friendlv
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.body ~= nil )then
			msg.data.egg.body = data.egg.body
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.relivetime ~= nil )then
			msg.data.egg.relivetime = data.egg.relivetime
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.hp ~= nil )then
			msg.data.egg.hp = data.egg.hp
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.restoretime ~= nil )then
			msg.data.egg.restoretime = data.egg.restoretime
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.time_happly ~= nil )then
			msg.data.egg.time_happly = data.egg.time_happly
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.time_excite ~= nil )then
			msg.data.egg.time_excite = data.egg.time_excite
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.time_happiness ~= nil )then
			msg.data.egg.time_happiness = data.egg.time_happiness
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.time_happly_gift ~= nil )then
			msg.data.egg.time_happly_gift = data.egg.time_happly_gift
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.time_excite_gift ~= nil )then
			msg.data.egg.time_excite_gift = data.egg.time_excite_gift
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.time_happiness_gift ~= nil )then
			msg.data.egg.time_happiness_gift = data.egg.time_happiness_gift
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.touch_tick ~= nil )then
			msg.data.egg.touch_tick = data.egg.touch_tick
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.feed_tick ~= nil )then
			msg.data.egg.feed_tick = data.egg.feed_tick
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.name ~= nil )then
			msg.data.egg.name = data.egg.name
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.var ~= nil )then
			msg.data.egg.var = data.egg.var
		end
	end
	if(data ~= nil )then
		if(data.egg.skillids ~= nil )then
			for i=1,#data.egg.skillids do 
				table.insert(msg.data.egg.skillids, data.egg.skillids[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.egg.equips ~= nil )then
			for i=1,#data.egg.equips do 
				table.insert(msg.data.egg.equips, data.egg.equips[i])
			end
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.buff ~= nil )then
			msg.data.egg.buff = data.egg.buff
		end
	end
	if(data ~= nil )then
		if(data.egg.unlock_equip ~= nil )then
			for i=1,#data.egg.unlock_equip do 
				table.insert(msg.data.egg.unlock_equip, data.egg.unlock_equip[i])
			end
		end
	end
	if(data ~= nil )then
		if(data.egg.unlock_body ~= nil )then
			for i=1,#data.egg.unlock_body do 
				table.insert(msg.data.egg.unlock_body, data.egg.unlock_body[i])
			end
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.version ~= nil )then
			msg.data.egg.version = data.egg.version
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.skilloff ~= nil )then
			msg.data.egg.skilloff = data.egg.skilloff
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.exchange_count ~= nil )then
			msg.data.egg.exchange_count = data.egg.exchange_count
		end
	end
	if(data.egg ~= nil )then
		if(data.egg.guid ~= nil )then
			msg.data.egg.guid = data.egg.guid
		end
	end
	if(data.letter ~= nil )then
		if(data.letter.sendUserName ~= nil )then
			msg.data.letter.sendUserName = data.letter.sendUserName
		end
	end
	if(data.letter ~= nil )then
		if(data.letter.bg ~= nil )then
			msg.data.letter.bg = data.letter.bg
		end
	end
	if(data.letter ~= nil )then
		if(data.letter.configID ~= nil )then
			msg.data.letter.configID = data.letter.configID
		end
	end
	if(data.letter ~= nil )then
		if(data.letter.content ~= nil )then
			msg.data.letter.content = data.letter.content
		end
	end
	if(data.letter ~= nil )then
		if(data.letter.content2 ~= nil )then
			msg.data.letter.content2 = data.letter.content2
		end
	end
	if(data.code ~= nil )then
		if(data.code.code ~= nil )then
			msg.data.code.code = data.code.code
		end
	end
	if(data.code ~= nil )then
		if(data.code.used ~= nil )then
			msg.data.code.used = data.code.used
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.id ~= nil )then
			msg.data.wedding.id = data.wedding.id
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.zoneid ~= nil )then
			msg.data.wedding.zoneid = data.wedding.zoneid
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.charid1 ~= nil )then
			msg.data.wedding.charid1 = data.wedding.charid1
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.charid2 ~= nil )then
			msg.data.wedding.charid2 = data.wedding.charid2
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.weddingtime ~= nil )then
			msg.data.wedding.weddingtime = data.wedding.weddingtime
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.photoidx ~= nil )then
			msg.data.wedding.photoidx = data.wedding.photoidx
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.phototime ~= nil )then
			msg.data.wedding.phototime = data.wedding.phototime
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.myname ~= nil )then
			msg.data.wedding.myname = data.wedding.myname
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.partnername ~= nil )then
			msg.data.wedding.partnername = data.wedding.partnername
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.starttime ~= nil )then
			msg.data.wedding.starttime = data.wedding.starttime
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.endtime ~= nil )then
			msg.data.wedding.endtime = data.wedding.endtime
		end
	end
	if(data.wedding ~= nil )then
		if(data.wedding.notified ~= nil )then
			msg.data.wedding.notified = data.wedding.notified
		end
	end
	if(data.sender ~= nil )then
		if(data.sender.charid ~= nil )then
			msg.data.sender.charid = data.sender.charid
		end
	end
	if(data.sender ~= nil )then
		if(data.sender.name ~= nil )then
			msg.data.sender.name = data.sender.name
		end
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallPlayExpressionChatCmd(charid, expressionid) 
	local msg = ChatCmd_pb.PlayExpressionChatCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(expressionid ~= nil )then
		msg.expressionid = expressionid
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallQueryUserInfoChatCmd(charid, msgid, type, info) 
	local msg = ChatCmd_pb.QueryUserInfoChatCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(info ~= nil )then
		if(info.charid ~= nil )then
			msg.info.charid = info.charid
		end
	end
	if(info ~= nil )then
		if(info.guildid ~= nil )then
			msg.info.guildid = info.guildid
		end
	end
	if(info ~= nil )then
		if(info.name ~= nil )then
			msg.info.name = info.name
		end
	end
	if(info ~= nil )then
		if(info.guildname ~= nil )then
			msg.info.guildname = info.guildname
		end
	end
	if(info ~= nil )then
		if(info.guildportrait ~= nil )then
			msg.info.guildportrait = info.guildportrait
		end
	end
	if(info ~= nil )then
		if(info.guildjob ~= nil )then
			msg.info.guildjob = info.guildjob
		end
	end
	if(info ~= nil )then
		if(info.datas ~= nil )then
			for i=1,#info.datas do 
				table.insert(msg.info.datas, info.datas[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.attrs ~= nil )then
			for i=1,#info.attrs do 
				table.insert(msg.info.attrs, info.attrs[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.equip ~= nil )then
			for i=1,#info.equip do 
				table.insert(msg.info.equip, info.equip[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.fashion ~= nil )then
			for i=1,#info.fashion do 
				table.insert(msg.info.fashion, info.fashion[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.highrefine ~= nil )then
			for i=1,#info.highrefine do 
				table.insert(msg.info.highrefine, info.highrefine[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.partner ~= nil )then
			msg.info.partner = info.partner
		end
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallBarrageChatCmd(opt) 
	local msg = ChatCmd_pb.BarrageChatCmd()
	if(opt ~= nil )then
		msg.opt = opt
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallBarrageMsgChatCmd(str, msgpos, clr, speed) 
	local msg = ChatCmd_pb.BarrageMsgChatCmd()
	if(str ~= nil )then
		msg.str = str
	end
	if(msgpos ~= nil )then
		if(msgpos.x ~= nil )then
			msg.msgpos.x = msgpos.x
		end
	end
	if(msgpos ~= nil )then
		if(msgpos.y ~= nil )then
			msg.msgpos.y = msgpos.y
		end
	end
	if(msgpos ~= nil )then
		if(msgpos.z ~= nil )then
			msg.msgpos.z = msgpos.z
		end
	end
	if(clr ~= nil )then
		if(clr.r ~= nil )then
			msg.clr.r = clr.r
		end
	end
	if(clr ~= nil )then
		if(clr.g ~= nil )then
			msg.clr.g = clr.g
		end
	end
	if(clr ~= nil )then
		if(clr.b ~= nil )then
			msg.clr.b = clr.b
		end
	end
	if(speed ~= nil )then
		msg.speed = speed
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallChatCmd(channel, str, desID, voice, voicetime, msgid, msgover) 
	local msg = ChatCmd_pb.ChatCmd()
	if(channel ~= nil )then
		msg.channel = channel
	end
	msg.str = str
	if(desID ~= nil )then
		msg.desID = desID
	end
	if(voice ~= nil )then
		msg.voice = voice
	end
	if(voicetime ~= nil )then
		msg.voicetime = voicetime
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	if(msgover ~= nil )then
		msg.msgover = msgover
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallChatRetCmd(id, targetid, portrait, frame, baselevel, voiceid, voicetime, hair, haircolor, body, appellation, msgid, head, face, mouth, eye, channel, rolejob, gender, blink, str, name, guildname) 
	local msg = ChatCmd_pb.ChatRetCmd()
	msg.id = id
	if(targetid ~= nil )then
		msg.targetid = targetid
	end
	msg.portrait = portrait
	msg.frame = frame
	if(baselevel ~= nil )then
		msg.baselevel = baselevel
	end
	if(voiceid ~= nil )then
		msg.voiceid = voiceid
	end
	if(voicetime ~= nil )then
		msg.voicetime = voicetime
	end
	if(hair ~= nil )then
		msg.hair = hair
	end
	if(haircolor ~= nil )then
		msg.haircolor = haircolor
	end
	if(body ~= nil )then
		msg.body = body
	end
	if(appellation ~= nil )then
		msg.appellation = appellation
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	if(head ~= nil )then
		msg.head = head
	end
	if(face ~= nil )then
		msg.face = face
	end
	if(mouth ~= nil )then
		msg.mouth = mouth
	end
	if(eye ~= nil )then
		msg.eye = eye
	end
	if(channel ~= nil )then
		msg.channel = channel
	end
	if(rolejob ~= nil )then
		msg.rolejob = rolejob
	end
	if(gender ~= nil )then
		msg.gender = gender
	end
	if(blink ~= nil )then
		msg.blink = blink
	end
	msg.str = str
	msg.name = name
	if(guildname ~= nil )then
		msg.guildname = guildname
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallQueryVoiceUserCmd(voiceid, voice, msgid, msgover) 
	local msg = ChatCmd_pb.QueryVoiceUserCmd()
	if(voiceid ~= nil )then
		msg.voiceid = voiceid
	end
	if(voice ~= nil )then
		msg.voice = voice
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	if(msgover ~= nil )then
		msg.msgover = msgover
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallGetVoiceIDChatCmd(id) 
	local msg = ChatCmd_pb.GetVoiceIDChatCmd()
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallLoveLetterNtf(name, content, type, bg, letterID, configID, content2) 
	local msg = ChatCmd_pb.LoveLetterNtf()
	if(name ~= nil )then
		msg.name = name
	end
	if(content ~= nil )then
		msg.content = content
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(bg ~= nil )then
		msg.bg = bg
	end
	if(letterID ~= nil )then
		msg.letterID = letterID
	end
	if(configID ~= nil )then
		msg.configID = configID
	end
	if(content2 ~= nil )then
		msg.content2 = content2
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallChatSelfNtf(chat) 
	local msg = ChatCmd_pb.ChatSelfNtf()
	if(chat ~= nil )then
		if(chat.cmd ~= nil )then
			msg.chat.cmd = chat.cmd
		end
	end
	if(chat ~= nil )then
		if(chat.param ~= nil )then
			msg.chat.param = chat.param
		end
	end
	if(chat ~= nil )then
		if(chat.channel ~= nil )then
			msg.chat.channel = chat.channel
		end
	end
	msg.chat.str = chat.str
	if(chat ~= nil )then
		if(chat.desID ~= nil )then
			msg.chat.desID = chat.desID
		end
	end
	if(chat ~= nil )then
		if(chat.voice ~= nil )then
			msg.chat.voice = chat.voice
		end
	end
	if(chat ~= nil )then
		if(chat.voicetime ~= nil )then
			msg.chat.voicetime = chat.voicetime
		end
	end
	if(chat ~= nil )then
		if(chat.msgid ~= nil )then
			msg.chat.msgid = chat.msgid
		end
	end
	if(chat ~= nil )then
		if(chat.msgover ~= nil )then
			msg.chat.msgover = chat.msgover
		end
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallNpcChatNtf(channel, npcid, msgid, params, msg, npcguid) 
	local msg = ChatCmd_pb.NpcChatNtf()
	if(channel ~= nil )then
		msg.channel = channel
	end
	if(npcid ~= nil )then
		msg.npcid = npcid
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	if( params ~= nil )then
		for i=1,#params do 
			table.insert(msg.params, params[i])
		end
	end
	if(msg ~= nil )then
		msg.msg = msg
	end
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	self:SendProto(msg)
end

function ServiceChatCmdAutoProxy:CallQueryRealtimeVoiceIDCmd(channel, id) 
	local msg = ChatCmd_pb.QueryRealtimeVoiceIDCmd()
	if(channel ~= nil )then
		msg.channel = channel
	end
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
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

ServiceEvent = _G["ServiceEvent"] or {}
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
