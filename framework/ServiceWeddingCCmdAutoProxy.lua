ServiceWeddingCCmdAutoProxy = class('ServiceWeddingCCmdAutoProxy', ServiceProxy)

ServiceWeddingCCmdAutoProxy.Instance = nil

ServiceWeddingCCmdAutoProxy.NAME = 'ServiceWeddingCCmdAutoProxy'

function ServiceWeddingCCmdAutoProxy:ctor(proxyName)
	if ServiceWeddingCCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceWeddingCCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceWeddingCCmdAutoProxy.Instance = self
	end
end

function ServiceWeddingCCmdAutoProxy:Init()
end

function ServiceWeddingCCmdAutoProxy:onRegister()
	self:Listen(65, 1, function (data)
		self:RecvReqWeddingDateListCCmd(data) 
	end)
	self:Listen(65, 3, function (data)
		self:RecvReqWeddingOneDayListCCmd(data) 
	end)
	self:Listen(65, 4, function (data)
		self:RecvReqWeddingInfoCCmd(data) 
	end)
	self:Listen(65, 5, function (data)
		self:RecvReserveWeddingDateCCmd(data) 
	end)
	self:Listen(65, 6, function (data)
		self:RecvNtfReserveWeddingDateCCmd(data) 
	end)
	self:Listen(65, 7, function (data)
		self:RecvReplyReserveWeddingDateCCmd(data) 
	end)
	self:Listen(65, 8, function (data)
		self:RecvGiveUpReserveCCmd(data) 
	end)
	self:Listen(65, 9, function (data)
		self:RecvReqDivorceCCmd(data) 
	end)
	self:Listen(65, 10, function (data)
		self:RecvUpdateWeddingManualCCmd(data) 
	end)
	self:Listen(65, 11, function (data)
		self:RecvBuyWeddingPackageCCmd(data) 
	end)
	self:Listen(65, 12, function (data)
		self:RecvBuyWeddingRingCCmd(data) 
	end)
	self:Listen(65, 13, function (data)
		self:RecvWeddingInviteCCmd(data) 
	end)
	self:Listen(65, 14, function (data)
		self:RecvUploadWeddingPhotoCCmd(data) 
	end)
	self:Listen(65, 15, function (data)
		self:RecvCheckCanReserveCCmd(data) 
	end)
	self:Listen(65, 16, function (data)
		self:RecvReqPartnerInfoCCmd(data) 
	end)
	self:Listen(65, 17, function (data)
		self:RecvNtfWeddingInfoCCmd(data) 
	end)
	self:Listen(65, 18, function (data)
		self:RecvInviteBeginWeddingCCmd(data) 
	end)
	self:Listen(65, 19, function (data)
		self:RecvReplyBeginWeddingCCmd(data) 
	end)
	self:Listen(65, 20, function (data)
		self:RecvGoToWeddingPosCCmd(data) 
	end)
	self:Listen(65, 21, function (data)
		self:RecvQuestionWeddingCCmd(data) 
	end)
	self:Listen(65, 22, function (data)
		self:RecvAnswerWeddingCCmd(data) 
	end)
	self:Listen(65, 23, function (data)
		self:RecvWeddingEventMsgCCmd(data) 
	end)
	self:Listen(65, 24, function (data)
		self:RecvWeddingOverCCmd(data) 
	end)
	self:Listen(65, 25, function (data)
		self:RecvWeddingSwitchQuestionCCmd(data) 
	end)
	self:Listen(65, 26, function (data)
		self:RecvEnterRollerCoasterCCmd(data) 
	end)
	self:Listen(65, 27, function (data)
		self:RecvDivorceRollerCoasterInviteCCmd(data) 
	end)
	self:Listen(65, 28, function (data)
		self:RecvDivorceRollerCoasterReplyCCmd(data) 
	end)
	self:Listen(65, 29, function (data)
		self:RecvEnterWeddingMapCCmd(data) 
	end)
	self:Listen(65, 30, function (data)
		self:RecvMissyouInviteWedCCmd(data) 
	end)
	self:Listen(65, 31, function (data)
		self:RecvMisccyouReplyWedCCmd(data) 
	end)
	self:Listen(65, 32, function (data)
		self:RecvWeddingCarrierCCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceWeddingCCmdAutoProxy:CallReqWeddingDateListCCmd(date_list, use_ticket) 
	local msg = WeddingCCmd_pb.ReqWeddingDateListCCmd()
	if( date_list ~= nil )then
		for i=1,#date_list do 
			table.insert(msg.date_list, date_list[i])
		end
	end
	if(use_ticket ~= nil )then
		msg.use_ticket = use_ticket
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallReqWeddingOneDayListCCmd(date, info) 
	local msg = WeddingCCmd_pb.ReqWeddingOneDayListCCmd()
	if(date ~= nil )then
		msg.date = date
	end
	if( info ~= nil )then
		for i=1,#info do 
			table.insert(msg.info, info[i])
		end
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallReqWeddingInfoCCmd(id, info) 
	local msg = WeddingCCmd_pb.ReqWeddingInfoCCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(info ~= nil )then
		if(info.id ~= nil )then
			msg.info.id = info.id
		end
	end
	if(info ~= nil )then
		if(info.status ~= nil )then
			msg.info.status = info.status
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.charid ~= nil )then
			msg.info.char1.charid = info.char1.charid
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.name ~= nil )then
			msg.info.char1.name = info.char1.name
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.profession ~= nil )then
			msg.info.char1.profession = info.char1.profession
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.gender ~= nil )then
			msg.info.char1.gender = info.char1.gender
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.portrait ~= nil )then
			msg.info.char1.portrait = info.char1.portrait
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.hair ~= nil )then
			msg.info.char1.hair = info.char1.hair
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.haircolor ~= nil )then
			msg.info.char1.haircolor = info.char1.haircolor
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.body ~= nil )then
			msg.info.char1.body = info.char1.body
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.head ~= nil )then
			msg.info.char1.head = info.char1.head
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.face ~= nil )then
			msg.info.char1.face = info.char1.face
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.mouth ~= nil )then
			msg.info.char1.mouth = info.char1.mouth
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.eye ~= nil )then
			msg.info.char1.eye = info.char1.eye
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.level ~= nil )then
			msg.info.char1.level = info.char1.level
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.guildname ~= nil )then
			msg.info.char1.guildname = info.char1.guildname
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.charid ~= nil )then
			msg.info.char2.charid = info.char2.charid
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.name ~= nil )then
			msg.info.char2.name = info.char2.name
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.profession ~= nil )then
			msg.info.char2.profession = info.char2.profession
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.gender ~= nil )then
			msg.info.char2.gender = info.char2.gender
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.portrait ~= nil )then
			msg.info.char2.portrait = info.char2.portrait
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.hair ~= nil )then
			msg.info.char2.hair = info.char2.hair
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.haircolor ~= nil )then
			msg.info.char2.haircolor = info.char2.haircolor
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.body ~= nil )then
			msg.info.char2.body = info.char2.body
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.head ~= nil )then
			msg.info.char2.head = info.char2.head
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.face ~= nil )then
			msg.info.char2.face = info.char2.face
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.mouth ~= nil )then
			msg.info.char2.mouth = info.char2.mouth
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.eye ~= nil )then
			msg.info.char2.eye = info.char2.eye
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.level ~= nil )then
			msg.info.char2.level = info.char2.level
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.guildname ~= nil )then
			msg.info.char2.guildname = info.char2.guildname
		end
	end
	if(info ~= nil )then
		if(info.zoneid ~= nil )then
			msg.info.zoneid = info.zoneid
		end
	end
	if(info ~= nil )then
		if(info.starttime ~= nil )then
			msg.info.starttime = info.starttime
		end
	end
	if(info ~= nil )then
		if(info.endtime ~= nil )then
			msg.info.endtime = info.endtime
		end
	end
	if(info ~= nil )then
		if(info.can_single_divorce ~= nil )then
			msg.info.can_single_divorce = info.can_single_divorce
		end
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallReserveWeddingDateCCmd(date, configid, charid2, use_ticket) 
	local msg = WeddingCCmd_pb.ReserveWeddingDateCCmd()
	if(date ~= nil )then
		msg.date = date
	end
	if(configid ~= nil )then
		msg.configid = configid
	end
	if(charid2 ~= nil )then
		msg.charid2 = charid2
	end
	if(use_ticket ~= nil )then
		msg.use_ticket = use_ticket
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallNtfReserveWeddingDateCCmd(date, configid, charid1, name, starttime, endtime, time, use_ticket, zoneid, sign) 
	local msg = WeddingCCmd_pb.NtfReserveWeddingDateCCmd()
	if(date ~= nil )then
		msg.date = date
	end
	if(configid ~= nil )then
		msg.configid = configid
	end
	if(charid1 ~= nil )then
		msg.charid1 = charid1
	end
	if(name ~= nil )then
		msg.name = name
	end
	if(starttime ~= nil )then
		msg.starttime = starttime
	end
	if(endtime ~= nil )then
		msg.endtime = endtime
	end
	if(time ~= nil )then
		msg.time = time
	end
	if(use_ticket ~= nil )then
		msg.use_ticket = use_ticket
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(sign ~= nil )then
		msg.sign = sign
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallReplyReserveWeddingDateCCmd(date, configid, charid1, reply, time, use_ticket, zoneid, sign) 
	local msg = WeddingCCmd_pb.ReplyReserveWeddingDateCCmd()
	if(date ~= nil )then
		msg.date = date
	end
	if(configid ~= nil )then
		msg.configid = configid
	end
	if(charid1 ~= nil )then
		msg.charid1 = charid1
	end
	if(reply ~= nil )then
		msg.reply = reply
	end
	if(time ~= nil )then
		msg.time = time
	end
	if(use_ticket ~= nil )then
		msg.use_ticket = use_ticket
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(sign ~= nil )then
		msg.sign = sign
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallGiveUpReserveCCmd(id) 
	local msg = WeddingCCmd_pb.GiveUpReserveCCmd()
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallReqDivorceCCmd(id, type) 
	local msg = WeddingCCmd_pb.ReqDivorceCCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(type ~= nil )then
		msg.type = type
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallUpdateWeddingManualCCmd(manual, invitees) 
	local msg = WeddingCCmd_pb.UpdateWeddingManualCCmd()
	if(manual ~= nil )then
		if(manual.packageids ~= nil )then
			for i=1,#manual.packageids do 
				table.insert(msg.manual.packageids, manual.packageids[i])
			end
		end
	end
	if(manual ~= nil )then
		if(manual.ringid ~= nil )then
			msg.manual.ringid = manual.ringid
		end
	end
	if(manual ~= nil )then
		if(manual.photoindex ~= nil )then
			msg.manual.photoindex = manual.photoindex
		end
	end
	if(manual ~= nil )then
		if(manual.phototime ~= nil )then
			msg.manual.phototime = manual.phototime
		end
	end
	if( invitees ~= nil )then
		for i=1,#invitees do 
			table.insert(msg.invitees, invitees[i])
		end
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallBuyWeddingPackageCCmd(id, priceitem) 
	local msg = WeddingCCmd_pb.BuyWeddingPackageCCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(priceitem ~= nil )then
		msg.priceitem = priceitem
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallBuyWeddingRingCCmd(id, priceitem) 
	local msg = WeddingCCmd_pb.BuyWeddingRingCCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(priceitem ~= nil )then
		msg.priceitem = priceitem
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallWeddingInviteCCmd(charids) 
	local msg = WeddingCCmd_pb.WeddingInviteCCmd()
	if( charids ~= nil )then
		for i=1,#charids do 
			table.insert(msg.charids, charids[i])
		end
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallUploadWeddingPhotoCCmd(index, time) 
	local msg = WeddingCCmd_pb.UploadWeddingPhotoCCmd()
	if(index ~= nil )then
		msg.index = index
	end
	if(time ~= nil )then
		msg.time = time
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallCheckCanReserveCCmd(charid2, success) 
	local msg = WeddingCCmd_pb.CheckCanReserveCCmd()
	if(charid2 ~= nil )then
		msg.charid2 = charid2
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallReqPartnerInfoCCmd(chardata) 
	local msg = WeddingCCmd_pb.ReqPartnerInfoCCmd()
	if(chardata ~= nil )then
		if(chardata.charid ~= nil )then
			msg.chardata.charid = chardata.charid
		end
	end
	if(chardata ~= nil )then
		if(chardata.name ~= nil )then
			msg.chardata.name = chardata.name
		end
	end
	if(chardata ~= nil )then
		if(chardata.profession ~= nil )then
			msg.chardata.profession = chardata.profession
		end
	end
	if(chardata ~= nil )then
		if(chardata.gender ~= nil )then
			msg.chardata.gender = chardata.gender
		end
	end
	if(chardata ~= nil )then
		if(chardata.portrait ~= nil )then
			msg.chardata.portrait = chardata.portrait
		end
	end
	if(chardata ~= nil )then
		if(chardata.hair ~= nil )then
			msg.chardata.hair = chardata.hair
		end
	end
	if(chardata ~= nil )then
		if(chardata.haircolor ~= nil )then
			msg.chardata.haircolor = chardata.haircolor
		end
	end
	if(chardata ~= nil )then
		if(chardata.body ~= nil )then
			msg.chardata.body = chardata.body
		end
	end
	if(chardata ~= nil )then
		if(chardata.head ~= nil )then
			msg.chardata.head = chardata.head
		end
	end
	if(chardata ~= nil )then
		if(chardata.face ~= nil )then
			msg.chardata.face = chardata.face
		end
	end
	if(chardata ~= nil )then
		if(chardata.mouth ~= nil )then
			msg.chardata.mouth = chardata.mouth
		end
	end
	if(chardata ~= nil )then
		if(chardata.eye ~= nil )then
			msg.chardata.eye = chardata.eye
		end
	end
	if(chardata ~= nil )then
		if(chardata.level ~= nil )then
			msg.chardata.level = chardata.level
		end
	end
	if(chardata ~= nil )then
		if(chardata.guildname ~= nil )then
			msg.chardata.guildname = chardata.guildname
		end
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallNtfWeddingInfoCCmd(info) 
	local msg = WeddingCCmd_pb.NtfWeddingInfoCCmd()
	if(info ~= nil )then
		if(info.id ~= nil )then
			msg.info.id = info.id
		end
	end
	if(info ~= nil )then
		if(info.status ~= nil )then
			msg.info.status = info.status
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.charid ~= nil )then
			msg.info.char1.charid = info.char1.charid
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.name ~= nil )then
			msg.info.char1.name = info.char1.name
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.profession ~= nil )then
			msg.info.char1.profession = info.char1.profession
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.gender ~= nil )then
			msg.info.char1.gender = info.char1.gender
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.portrait ~= nil )then
			msg.info.char1.portrait = info.char1.portrait
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.hair ~= nil )then
			msg.info.char1.hair = info.char1.hair
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.haircolor ~= nil )then
			msg.info.char1.haircolor = info.char1.haircolor
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.body ~= nil )then
			msg.info.char1.body = info.char1.body
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.head ~= nil )then
			msg.info.char1.head = info.char1.head
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.face ~= nil )then
			msg.info.char1.face = info.char1.face
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.mouth ~= nil )then
			msg.info.char1.mouth = info.char1.mouth
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.eye ~= nil )then
			msg.info.char1.eye = info.char1.eye
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.level ~= nil )then
			msg.info.char1.level = info.char1.level
		end
	end
	if(info.char1 ~= nil )then
		if(info.char1.guildname ~= nil )then
			msg.info.char1.guildname = info.char1.guildname
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.charid ~= nil )then
			msg.info.char2.charid = info.char2.charid
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.name ~= nil )then
			msg.info.char2.name = info.char2.name
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.profession ~= nil )then
			msg.info.char2.profession = info.char2.profession
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.gender ~= nil )then
			msg.info.char2.gender = info.char2.gender
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.portrait ~= nil )then
			msg.info.char2.portrait = info.char2.portrait
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.hair ~= nil )then
			msg.info.char2.hair = info.char2.hair
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.haircolor ~= nil )then
			msg.info.char2.haircolor = info.char2.haircolor
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.body ~= nil )then
			msg.info.char2.body = info.char2.body
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.head ~= nil )then
			msg.info.char2.head = info.char2.head
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.face ~= nil )then
			msg.info.char2.face = info.char2.face
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.mouth ~= nil )then
			msg.info.char2.mouth = info.char2.mouth
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.eye ~= nil )then
			msg.info.char2.eye = info.char2.eye
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.level ~= nil )then
			msg.info.char2.level = info.char2.level
		end
	end
	if(info.char2 ~= nil )then
		if(info.char2.guildname ~= nil )then
			msg.info.char2.guildname = info.char2.guildname
		end
	end
	if(info ~= nil )then
		if(info.zoneid ~= nil )then
			msg.info.zoneid = info.zoneid
		end
	end
	if(info ~= nil )then
		if(info.starttime ~= nil )then
			msg.info.starttime = info.starttime
		end
	end
	if(info ~= nil )then
		if(info.endtime ~= nil )then
			msg.info.endtime = info.endtime
		end
	end
	if(info ~= nil )then
		if(info.can_single_divorce ~= nil )then
			msg.info.can_single_divorce = info.can_single_divorce
		end
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallInviteBeginWeddingCCmd(masterid, name, tocharid) 
	local msg = WeddingCCmd_pb.InviteBeginWeddingCCmd()
	if(masterid ~= nil )then
		msg.masterid = masterid
	end
	if(name ~= nil )then
		msg.name = name
	end
	if(tocharid ~= nil )then
		msg.tocharid = tocharid
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallReplyBeginWeddingCCmd(masterid) 
	local msg = WeddingCCmd_pb.ReplyBeginWeddingCCmd()
	if(masterid ~= nil )then
		msg.masterid = masterid
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallGoToWeddingPosCCmd() 
	local msg = WeddingCCmd_pb.GoToWeddingPosCCmd()
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallQuestionWeddingCCmd(questionid, charids, npcguid) 
	local msg = WeddingCCmd_pb.QuestionWeddingCCmd()
	if(questionid ~= nil )then
		msg.questionid = questionid
	end
	if( charids ~= nil )then
		for i=1,#charids do 
			table.insert(msg.charids, charids[i])
		end
	end
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallAnswerWeddingCCmd(questionid, answer) 
	local msg = WeddingCCmd_pb.AnswerWeddingCCmd()
	if(questionid ~= nil )then
		msg.questionid = questionid
	end
	if(answer ~= nil )then
		msg.answer = answer
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallWeddingEventMsgCCmd(charid, event, id, charid1, charid2, msg, opt_charid) 
	local msg = WeddingCCmd_pb.WeddingEventMsgCCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(event ~= nil )then
		msg.event = event
	end
	if(id ~= nil )then
		msg.id = id
	end
	if(charid1 ~= nil )then
		msg.charid1 = charid1
	end
	if(charid2 ~= nil )then
		msg.charid2 = charid2
	end
	if(msg ~= nil )then
		msg.msg = msg
	end
	if(opt_charid ~= nil )then
		msg.opt_charid = opt_charid
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallWeddingOverCCmd(success) 
	local msg = WeddingCCmd_pb.WeddingOverCCmd()
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallWeddingSwitchQuestionCCmd(onoff, npcguid) 
	local msg = WeddingCCmd_pb.WeddingSwitchQuestionCCmd()
	if(onoff ~= nil )then
		msg.onoff = onoff
	end
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallEnterRollerCoasterCCmd() 
	local msg = WeddingCCmd_pb.EnterRollerCoasterCCmd()
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallDivorceRollerCoasterInviteCCmd(inviter, invitee, inviter_name) 
	local msg = WeddingCCmd_pb.DivorceRollerCoasterInviteCCmd()
	if(inviter ~= nil )then
		msg.inviter = inviter
	end
	if(invitee ~= nil )then
		msg.invitee = invitee
	end
	if(inviter_name ~= nil )then
		msg.inviter_name = inviter_name
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallDivorceRollerCoasterReplyCCmd(inviter, reply) 
	local msg = WeddingCCmd_pb.DivorceRollerCoasterReplyCCmd()
	if(inviter ~= nil )then
		msg.inviter = inviter
	end
	if(reply ~= nil )then
		msg.reply = reply
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallEnterWeddingMapCCmd() 
	local msg = WeddingCCmd_pb.EnterWeddingMapCCmd()
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallMissyouInviteWedCCmd() 
	local msg = WeddingCCmd_pb.MissyouInviteWedCCmd()
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallMisccyouReplyWedCCmd(agree) 
	local msg = WeddingCCmd_pb.MisccyouReplyWedCCmd()
	if(agree ~= nil )then
		msg.agree = agree
	end
	self:SendProto(msg)
end

function ServiceWeddingCCmdAutoProxy:CallWeddingCarrierCCmd() 
	local msg = WeddingCCmd_pb.WeddingCarrierCCmd()
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceWeddingCCmdAutoProxy:RecvReqWeddingDateListCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReqWeddingDateListCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqWeddingOneDayListCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReqWeddingOneDayListCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqWeddingInfoCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReqWeddingInfoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReserveWeddingDateCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReserveWeddingDateCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvNtfReserveWeddingDateCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdNtfReserveWeddingDateCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReplyReserveWeddingDateCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReplyReserveWeddingDateCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvGiveUpReserveCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdGiveUpReserveCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqDivorceCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReqDivorceCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvUpdateWeddingManualCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvBuyWeddingPackageCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdBuyWeddingPackageCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvBuyWeddingRingCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdBuyWeddingRingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingInviteCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdWeddingInviteCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvUploadWeddingPhotoCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdUploadWeddingPhotoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvCheckCanReserveCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdCheckCanReserveCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqPartnerInfoCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReqPartnerInfoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvNtfWeddingInfoCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdNtfWeddingInfoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvInviteBeginWeddingCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReplyBeginWeddingCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdReplyBeginWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvGoToWeddingPosCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdGoToWeddingPosCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvQuestionWeddingCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdQuestionWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvAnswerWeddingCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdAnswerWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingEventMsgCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdWeddingEventMsgCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingOverCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdWeddingOverCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingSwitchQuestionCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdWeddingSwitchQuestionCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvEnterRollerCoasterCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdEnterRollerCoasterCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvDivorceRollerCoasterInviteCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdDivorceRollerCoasterInviteCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvDivorceRollerCoasterReplyCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdDivorceRollerCoasterReplyCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvEnterWeddingMapCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdEnterWeddingMapCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvMissyouInviteWedCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdMissyouInviteWedCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvMisccyouReplyWedCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdMisccyouReplyWedCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingCarrierCCmd(data) 
	self:Notify(ServiceEvent.WeddingCCmdWeddingCarrierCCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.WeddingCCmdReqWeddingDateListCCmd = "ServiceEvent_WeddingCCmdReqWeddingDateListCCmd"
ServiceEvent.WeddingCCmdReqWeddingOneDayListCCmd = "ServiceEvent_WeddingCCmdReqWeddingOneDayListCCmd"
ServiceEvent.WeddingCCmdReqWeddingInfoCCmd = "ServiceEvent_WeddingCCmdReqWeddingInfoCCmd"
ServiceEvent.WeddingCCmdReserveWeddingDateCCmd = "ServiceEvent_WeddingCCmdReserveWeddingDateCCmd"
ServiceEvent.WeddingCCmdNtfReserveWeddingDateCCmd = "ServiceEvent_WeddingCCmdNtfReserveWeddingDateCCmd"
ServiceEvent.WeddingCCmdReplyReserveWeddingDateCCmd = "ServiceEvent_WeddingCCmdReplyReserveWeddingDateCCmd"
ServiceEvent.WeddingCCmdGiveUpReserveCCmd = "ServiceEvent_WeddingCCmdGiveUpReserveCCmd"
ServiceEvent.WeddingCCmdReqDivorceCCmd = "ServiceEvent_WeddingCCmdReqDivorceCCmd"
ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd = "ServiceEvent_WeddingCCmdUpdateWeddingManualCCmd"
ServiceEvent.WeddingCCmdBuyWeddingPackageCCmd = "ServiceEvent_WeddingCCmdBuyWeddingPackageCCmd"
ServiceEvent.WeddingCCmdBuyWeddingRingCCmd = "ServiceEvent_WeddingCCmdBuyWeddingRingCCmd"
ServiceEvent.WeddingCCmdWeddingInviteCCmd = "ServiceEvent_WeddingCCmdWeddingInviteCCmd"
ServiceEvent.WeddingCCmdUploadWeddingPhotoCCmd = "ServiceEvent_WeddingCCmdUploadWeddingPhotoCCmd"
ServiceEvent.WeddingCCmdCheckCanReserveCCmd = "ServiceEvent_WeddingCCmdCheckCanReserveCCmd"
ServiceEvent.WeddingCCmdReqPartnerInfoCCmd = "ServiceEvent_WeddingCCmdReqPartnerInfoCCmd"
ServiceEvent.WeddingCCmdNtfWeddingInfoCCmd = "ServiceEvent_WeddingCCmdNtfWeddingInfoCCmd"
ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd = "ServiceEvent_WeddingCCmdInviteBeginWeddingCCmd"
ServiceEvent.WeddingCCmdReplyBeginWeddingCCmd = "ServiceEvent_WeddingCCmdReplyBeginWeddingCCmd"
ServiceEvent.WeddingCCmdGoToWeddingPosCCmd = "ServiceEvent_WeddingCCmdGoToWeddingPosCCmd"
ServiceEvent.WeddingCCmdQuestionWeddingCCmd = "ServiceEvent_WeddingCCmdQuestionWeddingCCmd"
ServiceEvent.WeddingCCmdAnswerWeddingCCmd = "ServiceEvent_WeddingCCmdAnswerWeddingCCmd"
ServiceEvent.WeddingCCmdWeddingEventMsgCCmd = "ServiceEvent_WeddingCCmdWeddingEventMsgCCmd"
ServiceEvent.WeddingCCmdWeddingOverCCmd = "ServiceEvent_WeddingCCmdWeddingOverCCmd"
ServiceEvent.WeddingCCmdWeddingSwitchQuestionCCmd = "ServiceEvent_WeddingCCmdWeddingSwitchQuestionCCmd"
ServiceEvent.WeddingCCmdEnterRollerCoasterCCmd = "ServiceEvent_WeddingCCmdEnterRollerCoasterCCmd"
ServiceEvent.WeddingCCmdDivorceRollerCoasterInviteCCmd = "ServiceEvent_WeddingCCmdDivorceRollerCoasterInviteCCmd"
ServiceEvent.WeddingCCmdDivorceRollerCoasterReplyCCmd = "ServiceEvent_WeddingCCmdDivorceRollerCoasterReplyCCmd"
ServiceEvent.WeddingCCmdEnterWeddingMapCCmd = "ServiceEvent_WeddingCCmdEnterWeddingMapCCmd"
ServiceEvent.WeddingCCmdMissyouInviteWedCCmd = "ServiceEvent_WeddingCCmdMissyouInviteWedCCmd"
ServiceEvent.WeddingCCmdMisccyouReplyWedCCmd = "ServiceEvent_WeddingCCmdMisccyouReplyWedCCmd"
ServiceEvent.WeddingCCmdWeddingCarrierCCmd = "ServiceEvent_WeddingCCmdWeddingCarrierCCmd"
