ServiceSocialCmdAutoProxy = class('ServiceSocialCmdAutoProxy', ServiceProxy)

ServiceSocialCmdAutoProxy.Instance = nil

ServiceSocialCmdAutoProxy.NAME = 'ServiceSocialCmdAutoProxy'

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
	self:Listen(208, 1, function (data)
		self:RecvSessionForwardSocialCmd(data) 
	end)
	self:Listen(208, 2, function (data)
		self:RecvForwardToUserSocialCmd(data) 
	end)
	self:Listen(208, 3, function (data)
		self:RecvForwardToUserSceneSocialCmd(data) 
	end)
	self:Listen(208, 4, function (data)
		self:RecvForwardToSceneUserSocialCmd(data) 
	end)
	self:Listen(208, 68, function (data)
		self:RecvForwardToSessionUserSocialCmd(data) 
	end)
	self:Listen(208, 5, function (data)
		self:RecvOnlineStatusSocialCmd(data) 
	end)
	self:Listen(208, 6, function (data)
		self:RecvAddOfflineMsgSocialCmd(data) 
	end)
	self:Listen(208, 10, function (data)
		self:RecvUserInfoSyncSocialCmd(data) 
	end)
	self:Listen(208, 11, function (data)
		self:RecvUserAddItemSocialCmd(data) 
	end)
	self:Listen(208, 12, function (data)
		self:RecvUserDelSocialCmd(data) 
	end)
	self:Listen(208, 14, function (data)
		self:RecvUserGuildInfoSocialCmd(data) 
	end)
	self:Listen(208, 21, function (data)
		self:RecvChatWorldMsgSocialCmd(data) 
	end)
	self:Listen(208, 22, function (data)
		self:RecvChatSocialCmd(data) 
	end)
	self:Listen(208, 31, function (data)
		self:RecvCreateGuildSocialCmd(data) 
	end)
	self:Listen(208, 32, function (data)
		self:RecvGuildDonateSocialCmd(data) 
	end)
	self:Listen(208, 33, function (data)
		self:RecvGuildPraySocialCmd(data) 
	end)
	self:Listen(208, 37, function (data)
		self:RecvGuildApplySocialCmd(data) 
	end)
	self:Listen(208, 38, function (data)
		self:RecvGuildProcessInviteSocialCmd(data) 
	end)
	self:Listen(208, 39, function (data)
		self:RecvGuildAddConSocialCmd(data) 
	end)
	self:Listen(208, 40, function (data)
		self:RecvGuildAddAssetSocialCmd(data) 
	end)
	self:Listen(208, 42, function (data)
		self:RecvGuildExchangeZoneSocialCmd(data) 
	end)
	self:Listen(208, 43, function (data)
		self:RecvGuildAddItemSocialCmd(data) 
	end)
	self:Listen(208, 51, function (data)
		self:RecvTeamCreateSocialCmd(data) 
	end)
	self:Listen(208, 52, function (data)
		self:RecvTeamInviteSocialCmd(data) 
	end)
	self:Listen(208, 53, function (data)
		self:RecvTeamProcessInviteSocialCmd(data) 
	end)
	self:Listen(208, 54, function (data)
		self:RecvTeamApplySocialCmd(data) 
	end)
	self:Listen(208, 55, function (data)
		self:RecvTeamQuickEnterSocialCmd(data) 
	end)
	self:Listen(208, 57, function (data)
		self:RecvDojoStateNtfSocialCmd(data) 
	end)
	self:Listen(208, 56, function (data)
		self:RecvDojoCreateSocialCmd(data) 
	end)
	self:Listen(208, 58, function (data)
		self:RecvTowerLeaderInfoSyncSocialCmd(data) 
	end)
	self:Listen(208, 59, function (data)
		self:RecvTowerSceneCreateSocialCmd(data) 
	end)
	self:Listen(208, 60, function (data)
		self:RecvTowerSceneSyncSocialCmd(data) 
	end)
	self:Listen(208, 61, function (data)
		self:RecvTowerLayerSyncSocialCmd(data) 
	end)
	self:Listen(208, 71, function (data)
		self:RecvLeaderSealFinishSocialCmd(data) 
	end)
	self:Listen(208, 62, function (data)
		self:RecvGoTeamRaidSocialCmd(data) 
	end)
	self:Listen(208, 63, function (data)
		self:RecvDelTeamRaidSocialCmd(data) 
	end)
	self:Listen(208, 64, function (data)
		self:RecvSendMailSocialCmd(data) 
	end)
	self:Listen(208, 67, function (data)
		self:RecvForwardToAllSessionSocialCmd(data) 
	end)
	self:Listen(208, 44, function (data)
		self:RecvGuildLevelUpSocialCmd(data) 
	end)
	self:Listen(208, 70, function (data)
		self:RecvMoveGuildZoneSocialCmd(data) 
	end)
	self:Listen(208, 80, function (data)
		self:RecvSocialDataUpdateSocialCmd(data) 
	end)
	self:Listen(208, 81, function (data)
		self:RecvAddRelationSocialCmd(data) 
	end)
	self:Listen(208, 82, function (data)
		self:RecvRemoveRelationSocialCmd(data) 
	end)
	self:Listen(208, SOCIALPARAM_SOCIAL_REMOVEFOCUS, function (data)
		self:RecvRemoveFocusSocialCmd(data) 
	end)
	self:Listen(208, 84, function (data)
		self:RecvRemoveSocialitySocialCmd(data) 
	end)
	self:Listen(208, 85, function (data)
		self:RecvSyncSocialListSocialCmd(data) 
	end)
	self:Listen(208, 86, function (data)
		self:RecvSocialListUpdateSocialCmd(data) 
	end)
	self:Listen(208, 87, function (data)
		self:RecvTeamerQuestUpdateSocialCmd(data) 
	end)
	self:Listen(208, 88, function (data)
		self:RecvGlobalForwardCmdSocialCmd(data) 
	end)
	self:Listen(208, 90, function (data)
		self:RecvAuthorizeInfoSyncSocialCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSocialCmdAutoProxy:CallSessionForwardSocialCmd(type, user, data, len) 
	local msg = SocialCmd_pb.SessionForwardSocialCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallForwardToUserSocialCmd(charid, data, len) 
	local msg = SocialCmd_pb.ForwardToUserSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallForwardToUserSceneSocialCmd(charid, data, len) 
	local msg = SocialCmd_pb.ForwardToUserSceneSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallForwardToSceneUserSocialCmd(charid, data, len) 
	local msg = SocialCmd_pb.ForwardToSceneUserSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallForwardToSessionUserSocialCmd(charid, data, len) 
	local msg = SocialCmd_pb.ForwardToSessionUserSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallOnlineStatusSocialCmd(user, online) 
	local msg = SocialCmd_pb.OnlineStatusSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(online ~= nil )then
		msg.online = online
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallAddOfflineMsgSocialCmd(msg) 
	local msg = SocialCmd_pb.AddOfflineMsgSocialCmd()
	if(msg ~= nil )then
		if(msg.targetid ~= nil )then
			msg.msg.targetid = msg.targetid
		end
	end
	if(msg ~= nil )then
		if(msg.senderid ~= nil )then
			msg.msg.senderid = msg.senderid
		end
	end
	if(msg ~= nil )then
		if(msg.time ~= nil )then
			msg.msg.time = msg.time
		end
	end
	if(msg ~= nil )then
		if(msg.type ~= nil )then
			msg.msg.type = msg.type
		end
	end
	if(msg ~= nil )then
		if(msg.sendername ~= nil )then
			msg.msg.sendername = msg.sendername
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.cmd ~= nil )then
			msg.msg.chat.cmd = msg.chat.cmd
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.param ~= nil )then
			msg.msg.chat.param = msg.chat.param
		end
	end
	msg.msg.chat.id = msg.chat.id
	if(msg.chat ~= nil )then
		if(msg.chat.targetid ~= nil )then
			msg.msg.chat.targetid = msg.chat.targetid
		end
	end
	msg.msg.chat.portrait = msg.chat.portrait
	msg.msg.chat.frame = msg.chat.frame
	if(msg.chat ~= nil )then
		if(msg.chat.baselevel ~= nil )then
			msg.msg.chat.baselevel = msg.chat.baselevel
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.voiceid ~= nil )then
			msg.msg.chat.voiceid = msg.chat.voiceid
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.voicetime ~= nil )then
			msg.msg.chat.voicetime = msg.chat.voicetime
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.hair ~= nil )then
			msg.msg.chat.hair = msg.chat.hair
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.haircolor ~= nil )then
			msg.msg.chat.haircolor = msg.chat.haircolor
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.body ~= nil )then
			msg.msg.chat.body = msg.chat.body
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.appellation ~= nil )then
			msg.msg.chat.appellation = msg.chat.appellation
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.msgid ~= nil )then
			msg.msg.chat.msgid = msg.chat.msgid
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.head ~= nil )then
			msg.msg.chat.head = msg.chat.head
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.face ~= nil )then
			msg.msg.chat.face = msg.chat.face
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.mouth ~= nil )then
			msg.msg.chat.mouth = msg.chat.mouth
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.channel ~= nil )then
			msg.msg.chat.channel = msg.chat.channel
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.rolejob ~= nil )then
			msg.msg.chat.rolejob = msg.chat.rolejob
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.gender ~= nil )then
			msg.msg.chat.gender = msg.chat.gender
		end
	end
	if(msg.chat ~= nil )then
		if(msg.chat.blink ~= nil )then
			msg.msg.chat.blink = msg.chat.blink
		end
	end
	msg.msg.chat.str = msg.chat.str
	msg.msg.chat.name = msg.chat.name
	if(msg.chat ~= nil )then
		if(msg.chat.guildname ~= nil )then
			msg.msg.chat.guildname = msg.chat.guildname
		end
	end
	if(msg ~= nil )then
		if(msg.itemid ~= nil )then
			msg.msg.itemid = msg.itemid
		end
	end
	if(msg ~= nil )then
		if(msg.price ~= nil )then
			msg.msg.price = msg.price
		end
	end
	if(msg ~= nil )then
		if(msg.count ~= nil )then
			msg.msg.count = msg.count
		end
	end
	if(msg ~= nil )then
		if(msg.givemoney ~= nil )then
			msg.msg.givemoney = msg.givemoney
		end
	end
	if(msg ~= nil )then
		if(msg.moneytype ~= nil )then
			msg.msg.moneytype = msg.moneytype
		end
	end
	if(msg ~= nil )then
		if(msg.sysstr ~= nil )then
			msg.msg.sysstr = msg.sysstr
		end
	end
	if(msg ~= nil )then
		if(msg.gmcmd ~= nil )then
			msg.msg.gmcmd = msg.gmcmd
		end
	end
	if(msg ~= nil )then
		if(msg.id ~= nil )then
			msg.msg.id = msg.id
		end
	end
	if(msg ~= nil )then
		if(msg.msg ~= nil )then
			msg.msg.msg = msg.msg
		end
	end
	if(msg.syscmd ~= nil )then
		if(msg.syscmd.cmd ~= nil )then
			msg.msg.syscmd.cmd = msg.syscmd.cmd
		end
	end
	if(msg.syscmd ~= nil )then
		if(msg.syscmd.param ~= nil )then
			msg.msg.syscmd.param = msg.syscmd.param
		end
	end
	if(msg.syscmd ~= nil )then
		if(msg.syscmd.id ~= nil )then
			msg.msg.syscmd.id = msg.syscmd.id
		end
	end
	if(msg.syscmd ~= nil )then
		if(msg.syscmd.type ~= nil )then
			msg.msg.syscmd.type = msg.syscmd.type
		end
	end
	if(msg ~= nil )then
		if(msg.syscmd.params ~= nil )then
			for i=1,#msg.syscmd.params do 
				table.insert(msg.msg.syscmd.params, msg.syscmd.params[i])
			end
		end
	end
	if(msg.syscmd ~= nil )then
		if(msg.syscmd.act ~= nil )then
			msg.msg.syscmd.act = msg.syscmd.act
		end
	end
	if(msg.syscmd ~= nil )then
		if(msg.syscmd.delay ~= nil )then
			msg.msg.syscmd.delay = msg.syscmd.delay
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallUserInfoSyncSocialCmd(info) 
	local msg = SocialCmd_pb.UserInfoSyncSocialCmd()
	if(info.user ~= nil )then
		if(info.user.accid ~= nil )then
			msg.info.user.accid = info.user.accid
		end
	end
	if(info.user ~= nil )then
		if(info.user.charid ~= nil )then
			msg.info.user.charid = info.user.charid
		end
	end
	if(info.user ~= nil )then
		if(info.user.zoneid ~= nil )then
			msg.info.user.zoneid = info.user.zoneid
		end
	end
	if(info.user ~= nil )then
		if(info.user.mapid ~= nil )then
			msg.info.user.mapid = info.user.mapid
		end
	end
	if(info.user ~= nil )then
		if(info.user.baselv ~= nil )then
			msg.info.user.baselv = info.user.baselv
		end
	end
	if(info.user ~= nil )then
		if(info.user.profession ~= nil )then
			msg.info.user.profession = info.user.profession
		end
	end
	if(info.user ~= nil )then
		if(info.user.name ~= nil )then
			msg.info.user.name = info.user.name
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
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallUserAddItemSocialCmd(user, items, doublereward) 
	local msg = SocialCmd_pb.UserAddItemSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	if(doublereward ~= nil )then
		msg.doublereward = doublereward
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallUserDelSocialCmd(charid) 
	local msg = SocialCmd_pb.UserDelSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallUserGuildInfoSocialCmd(charid, name, portrait) 
	local msg = SocialCmd_pb.UserGuildInfoSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(name ~= nil )then
		msg.name = name
	end
	if(portrait ~= nil )then
		msg.portrait = portrait
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallChatWorldMsgSocialCmd(msg) 
	local msg = SocialCmd_pb.ChatWorldMsgSocialCmd()
	if(msg ~= nil )then
		if(msg.cmd ~= nil )then
			msg.msg.cmd = msg.cmd
		end
	end
	if(msg ~= nil )then
		if(msg.param ~= nil )then
			msg.msg.param = msg.param
		end
	end
	if(msg ~= nil )then
		if(msg.id ~= nil )then
			msg.msg.id = msg.id
		end
	end
	if(msg ~= nil )then
		if(msg.type ~= nil )then
			msg.msg.type = msg.type
		end
	end
	if(msg ~= nil )then
		if(msg.params ~= nil )then
			for i=1,#msg.params do 
				table.insert(msg.msg.params, msg.params[i])
			end
		end
	end
	if(msg ~= nil )then
		if(msg.act ~= nil )then
			msg.msg.act = msg.act
		end
	end
	if(msg ~= nil )then
		if(msg.delay ~= nil )then
			msg.msg.delay = msg.delay
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallChatSocialCmd(ret, targets, accid, platformid, to_global) 
	local msg = SocialCmd_pb.ChatSocialCmd()
	if(ret ~= nil )then
		if(ret.cmd ~= nil )then
			msg.ret.cmd = ret.cmd
		end
	end
	if(ret ~= nil )then
		if(ret.param ~= nil )then
			msg.ret.param = ret.param
		end
	end
	msg.ret.id = ret.id
	if(ret ~= nil )then
		if(ret.targetid ~= nil )then
			msg.ret.targetid = ret.targetid
		end
	end
	msg.ret.portrait = ret.portrait
	msg.ret.frame = ret.frame
	if(ret ~= nil )then
		if(ret.baselevel ~= nil )then
			msg.ret.baselevel = ret.baselevel
		end
	end
	if(ret ~= nil )then
		if(ret.voiceid ~= nil )then
			msg.ret.voiceid = ret.voiceid
		end
	end
	if(ret ~= nil )then
		if(ret.voicetime ~= nil )then
			msg.ret.voicetime = ret.voicetime
		end
	end
	if(ret ~= nil )then
		if(ret.hair ~= nil )then
			msg.ret.hair = ret.hair
		end
	end
	if(ret ~= nil )then
		if(ret.haircolor ~= nil )then
			msg.ret.haircolor = ret.haircolor
		end
	end
	if(ret ~= nil )then
		if(ret.body ~= nil )then
			msg.ret.body = ret.body
		end
	end
	if(ret ~= nil )then
		if(ret.appellation ~= nil )then
			msg.ret.appellation = ret.appellation
		end
	end
	if(ret ~= nil )then
		if(ret.msgid ~= nil )then
			msg.ret.msgid = ret.msgid
		end
	end
	if(ret ~= nil )then
		if(ret.head ~= nil )then
			msg.ret.head = ret.head
		end
	end
	if(ret ~= nil )then
		if(ret.face ~= nil )then
			msg.ret.face = ret.face
		end
	end
	if(ret ~= nil )then
		if(ret.mouth ~= nil )then
			msg.ret.mouth = ret.mouth
		end
	end
	if(ret ~= nil )then
		if(ret.channel ~= nil )then
			msg.ret.channel = ret.channel
		end
	end
	if(ret ~= nil )then
		if(ret.rolejob ~= nil )then
			msg.ret.rolejob = ret.rolejob
		end
	end
	if(ret ~= nil )then
		if(ret.gender ~= nil )then
			msg.ret.gender = ret.gender
		end
	end
	if(ret ~= nil )then
		if(ret.blink ~= nil )then
			msg.ret.blink = ret.blink
		end
	end
	msg.ret.str = ret.str
	msg.ret.name = ret.name
	if(ret ~= nil )then
		if(ret.guildname ~= nil )then
			msg.ret.guildname = ret.guildname
		end
	end
	if( targets ~= nil )then
		for i=1,#targets do 
			table.insert(msg.targets, targets[i])
		end
	end
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(platformid ~= nil )then
		msg.platformid = platformid
	end
	if(to_global ~= nil )then
		msg.to_global = to_global
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallCreateGuildSocialCmd(user, msgid, name) 
	local msg = SocialCmd_pb.CreateGuildSocialCmd()
	if(user.user ~= nil )then
		if(user.user.accid ~= nil )then
			msg.user.user.accid = user.user.accid
		end
	end
	if(user.user ~= nil )then
		if(user.user.charid ~= nil )then
			msg.user.user.charid = user.user.charid
		end
	end
	if(user.user ~= nil )then
		if(user.user.zoneid ~= nil )then
			msg.user.user.zoneid = user.user.zoneid
		end
	end
	if(user.user ~= nil )then
		if(user.user.mapid ~= nil )then
			msg.user.user.mapid = user.user.mapid
		end
	end
	if(user.user ~= nil )then
		if(user.user.baselv ~= nil )then
			msg.user.user.baselv = user.user.baselv
		end
	end
	if(user.user ~= nil )then
		if(user.user.profession ~= nil )then
			msg.user.user.profession = user.user.profession
		end
	end
	if(user.user ~= nil )then
		if(user.user.name ~= nil )then
			msg.user.user.name = user.user.name
		end
	end
	if(user ~= nil )then
		if(user.datas ~= nil )then
			for i=1,#user.datas do 
				table.insert(msg.user.datas, user.datas[i])
			end
		end
	end
	if(user ~= nil )then
		if(user.attrs ~= nil )then
			for i=1,#user.attrs do 
				table.insert(msg.user.attrs, user.attrs[i])
			end
		end
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	if(name ~= nil )then
		msg.name = name
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildDonateSocialCmd(user, item, msgid) 
	local msg = SocialCmd_pb.GuildDonateSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(item ~= nil )then
		if(item.configid ~= nil )then
			msg.item.configid = item.configid
		end
	end
	if(item ~= nil )then
		if(item.count ~= nil )then
			msg.item.count = item.count
		end
	end
	if(item ~= nil )then
		if(item.time ~= nil )then
			msg.item.time = item.time
		end
	end
	if(item ~= nil )then
		if(item.itemid ~= nil )then
			msg.item.itemid = item.itemid
		end
	end
	if(item ~= nil )then
		if(item.itemcount ~= nil )then
			msg.item.itemcount = item.itemcount
		end
	end
	if(item ~= nil )then
		if(item.contribute ~= nil )then
			msg.item.contribute = item.contribute
		end
	end
	if(item ~= nil )then
		if(item.medal ~= nil )then
			msg.item.medal = item.medal
		end
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildPraySocialCmd(user, npcid, prayid, needcon, needmon, prayitem, msgid) 
	local msg = SocialCmd_pb.GuildPraySocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(npcid ~= nil )then
		msg.npcid = npcid
	end
	if(prayid ~= nil )then
		msg.prayid = prayid
	end
	if(needcon ~= nil )then
		msg.needcon = needcon
	end
	if(needmon ~= nil )then
		msg.needmon = needmon
	end
	if(prayitem ~= nil )then
		msg.prayitem = prayitem
	end
	if(msgid ~= nil )then
		msg.msgid = msgid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildApplySocialCmd(user, guildid) 
	local msg = SocialCmd_pb.GuildApplySocialCmd()
	if(user.user ~= nil )then
		if(user.user.accid ~= nil )then
			msg.user.user.accid = user.user.accid
		end
	end
	if(user.user ~= nil )then
		if(user.user.charid ~= nil )then
			msg.user.user.charid = user.user.charid
		end
	end
	if(user.user ~= nil )then
		if(user.user.zoneid ~= nil )then
			msg.user.user.zoneid = user.user.zoneid
		end
	end
	if(user.user ~= nil )then
		if(user.user.mapid ~= nil )then
			msg.user.user.mapid = user.user.mapid
		end
	end
	if(user.user ~= nil )then
		if(user.user.baselv ~= nil )then
			msg.user.user.baselv = user.user.baselv
		end
	end
	if(user.user ~= nil )then
		if(user.user.profession ~= nil )then
			msg.user.user.profession = user.user.profession
		end
	end
	if(user.user ~= nil )then
		if(user.user.name ~= nil )then
			msg.user.user.name = user.user.name
		end
	end
	if(user ~= nil )then
		if(user.datas ~= nil )then
			for i=1,#user.datas do 
				table.insert(msg.user.datas, user.datas[i])
			end
		end
	end
	if(user ~= nil )then
		if(user.attrs ~= nil )then
			for i=1,#user.attrs do 
				table.insert(msg.user.attrs, user.attrs[i])
			end
		end
	end
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildProcessInviteSocialCmd(user, action, guildid) 
	local msg = SocialCmd_pb.GuildProcessInviteSocialCmd()
	if(user.user ~= nil )then
		if(user.user.accid ~= nil )then
			msg.user.user.accid = user.user.accid
		end
	end
	if(user.user ~= nil )then
		if(user.user.charid ~= nil )then
			msg.user.user.charid = user.user.charid
		end
	end
	if(user.user ~= nil )then
		if(user.user.zoneid ~= nil )then
			msg.user.user.zoneid = user.user.zoneid
		end
	end
	if(user.user ~= nil )then
		if(user.user.mapid ~= nil )then
			msg.user.user.mapid = user.user.mapid
		end
	end
	if(user.user ~= nil )then
		if(user.user.baselv ~= nil )then
			msg.user.user.baselv = user.user.baselv
		end
	end
	if(user.user ~= nil )then
		if(user.user.profession ~= nil )then
			msg.user.user.profession = user.user.profession
		end
	end
	if(user.user ~= nil )then
		if(user.user.name ~= nil )then
			msg.user.user.name = user.user.name
		end
	end
	if(user ~= nil )then
		if(user.datas ~= nil )then
			for i=1,#user.datas do 
				table.insert(msg.user.datas, user.datas[i])
			end
		end
	end
	if(user ~= nil )then
		if(user.attrs ~= nil )then
			for i=1,#user.attrs do 
				table.insert(msg.user.attrs, user.attrs[i])
			end
		end
	end
	if(action ~= nil )then
		msg.action = action
	end
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildAddConSocialCmd(charid, con, source) 
	local msg = SocialCmd_pb.GuildAddConSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(con ~= nil )then
		msg.con = con
	end
	if(source ~= nil )then
		msg.source = source
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildAddAssetSocialCmd(user, asset, self, source) 
	local msg = SocialCmd_pb.GuildAddAssetSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(asset ~= nil )then
		msg.asset = asset
	end
	if(self ~= nil )then
		msg.self = self
	end
	if(source ~= nil )then
		msg.source = source
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildExchangeZoneSocialCmd(user, zoneid) 
	local msg = SocialCmd_pb.GuildExchangeZoneSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildAddItemSocialCmd(user, items) 
	local msg = SocialCmd_pb.GuildAddItemSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTeamCreateSocialCmd(user, team) 
	local msg = SocialCmd_pb.TeamCreateSocialCmd()
	if(user.user ~= nil )then
		if(user.user.accid ~= nil )then
			msg.user.user.accid = user.user.accid
		end
	end
	if(user.user ~= nil )then
		if(user.user.charid ~= nil )then
			msg.user.user.charid = user.user.charid
		end
	end
	if(user.user ~= nil )then
		if(user.user.zoneid ~= nil )then
			msg.user.user.zoneid = user.user.zoneid
		end
	end
	if(user.user ~= nil )then
		if(user.user.mapid ~= nil )then
			msg.user.user.mapid = user.user.mapid
		end
	end
	if(user.user ~= nil )then
		if(user.user.baselv ~= nil )then
			msg.user.user.baselv = user.user.baselv
		end
	end
	if(user.user ~= nil )then
		if(user.user.profession ~= nil )then
			msg.user.user.profession = user.user.profession
		end
	end
	if(user.user ~= nil )then
		if(user.user.name ~= nil )then
			msg.user.user.name = user.user.name
		end
	end
	if(user ~= nil )then
		if(user.datas ~= nil )then
			for i=1,#user.datas do 
				table.insert(msg.user.datas, user.datas[i])
			end
		end
	end
	if(user ~= nil )then
		if(user.attrs ~= nil )then
			for i=1,#user.attrs do 
				table.insert(msg.user.attrs, user.attrs[i])
			end
		end
	end
	if(team ~= nil )then
		if(team.cmd ~= nil )then
			msg.team.cmd = team.cmd
		end
	end
	if(team ~= nil )then
		if(team.param ~= nil )then
			msg.team.param = team.param
		end
	end
	if(team ~= nil )then
		if(team.minlv ~= nil )then
			msg.team.minlv = team.minlv
		end
	end
	if(team ~= nil )then
		if(team.maxlv ~= nil )then
			msg.team.maxlv = team.maxlv
		end
	end
	if(team ~= nil )then
		if(team.type ~= nil )then
			msg.team.type = team.type
		end
	end
	if(team ~= nil )then
		if(team.autoaccept ~= nil )then
			msg.team.autoaccept = team.autoaccept
		end
	end
	if(team ~= nil )then
		if(team.name ~= nil )then
			msg.team.name = team.name
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTeamInviteSocialCmd(invite, beinvite) 
	local msg = SocialCmd_pb.TeamInviteSocialCmd()
	if(invite.user ~= nil )then
		if(invite.user.accid ~= nil )then
			msg.invite.user.accid = invite.user.accid
		end
	end
	if(invite.user ~= nil )then
		if(invite.user.charid ~= nil )then
			msg.invite.user.charid = invite.user.charid
		end
	end
	if(invite.user ~= nil )then
		if(invite.user.zoneid ~= nil )then
			msg.invite.user.zoneid = invite.user.zoneid
		end
	end
	if(invite.user ~= nil )then
		if(invite.user.mapid ~= nil )then
			msg.invite.user.mapid = invite.user.mapid
		end
	end
	if(invite.user ~= nil )then
		if(invite.user.baselv ~= nil )then
			msg.invite.user.baselv = invite.user.baselv
		end
	end
	if(invite.user ~= nil )then
		if(invite.user.profession ~= nil )then
			msg.invite.user.profession = invite.user.profession
		end
	end
	if(invite.user ~= nil )then
		if(invite.user.name ~= nil )then
			msg.invite.user.name = invite.user.name
		end
	end
	if(invite ~= nil )then
		if(invite.datas ~= nil )then
			for i=1,#invite.datas do 
				table.insert(msg.invite.datas, invite.datas[i])
			end
		end
	end
	if(invite ~= nil )then
		if(invite.attrs ~= nil )then
			for i=1,#invite.attrs do 
				table.insert(msg.invite.attrs, invite.attrs[i])
			end
		end
	end
	if(beinvite ~= nil )then
		if(beinvite.accid ~= nil )then
			msg.beinvite.accid = beinvite.accid
		end
	end
	if(beinvite ~= nil )then
		if(beinvite.charid ~= nil )then
			msg.beinvite.charid = beinvite.charid
		end
	end
	if(beinvite ~= nil )then
		if(beinvite.zoneid ~= nil )then
			msg.beinvite.zoneid = beinvite.zoneid
		end
	end
	if(beinvite ~= nil )then
		if(beinvite.mapid ~= nil )then
			msg.beinvite.mapid = beinvite.mapid
		end
	end
	if(beinvite ~= nil )then
		if(beinvite.baselv ~= nil )then
			msg.beinvite.baselv = beinvite.baselv
		end
	end
	if(beinvite ~= nil )then
		if(beinvite.profession ~= nil )then
			msg.beinvite.profession = beinvite.profession
		end
	end
	if(beinvite ~= nil )then
		if(beinvite.name ~= nil )then
			msg.beinvite.name = beinvite.name
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTeamProcessInviteSocialCmd(type, user, leaderid) 
	local msg = SocialCmd_pb.TeamProcessInviteSocialCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(user.user ~= nil )then
		if(user.user.accid ~= nil )then
			msg.user.user.accid = user.user.accid
		end
	end
	if(user.user ~= nil )then
		if(user.user.charid ~= nil )then
			msg.user.user.charid = user.user.charid
		end
	end
	if(user.user ~= nil )then
		if(user.user.zoneid ~= nil )then
			msg.user.user.zoneid = user.user.zoneid
		end
	end
	if(user.user ~= nil )then
		if(user.user.mapid ~= nil )then
			msg.user.user.mapid = user.user.mapid
		end
	end
	if(user.user ~= nil )then
		if(user.user.baselv ~= nil )then
			msg.user.user.baselv = user.user.baselv
		end
	end
	if(user.user ~= nil )then
		if(user.user.profession ~= nil )then
			msg.user.user.profession = user.user.profession
		end
	end
	if(user.user ~= nil )then
		if(user.user.name ~= nil )then
			msg.user.user.name = user.user.name
		end
	end
	if(user ~= nil )then
		if(user.datas ~= nil )then
			for i=1,#user.datas do 
				table.insert(msg.user.datas, user.datas[i])
			end
		end
	end
	if(user ~= nil )then
		if(user.attrs ~= nil )then
			for i=1,#user.attrs do 
				table.insert(msg.user.attrs, user.attrs[i])
			end
		end
	end
	if(leaderid ~= nil )then
		msg.leaderid = leaderid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTeamApplySocialCmd(apply, teamid) 
	local msg = SocialCmd_pb.TeamApplySocialCmd()
	if(apply.user ~= nil )then
		if(apply.user.accid ~= nil )then
			msg.apply.user.accid = apply.user.accid
		end
	end
	if(apply.user ~= nil )then
		if(apply.user.charid ~= nil )then
			msg.apply.user.charid = apply.user.charid
		end
	end
	if(apply.user ~= nil )then
		if(apply.user.zoneid ~= nil )then
			msg.apply.user.zoneid = apply.user.zoneid
		end
	end
	if(apply.user ~= nil )then
		if(apply.user.mapid ~= nil )then
			msg.apply.user.mapid = apply.user.mapid
		end
	end
	if(apply.user ~= nil )then
		if(apply.user.baselv ~= nil )then
			msg.apply.user.baselv = apply.user.baselv
		end
	end
	if(apply.user ~= nil )then
		if(apply.user.profession ~= nil )then
			msg.apply.user.profession = apply.user.profession
		end
	end
	if(apply.user ~= nil )then
		if(apply.user.name ~= nil )then
			msg.apply.user.name = apply.user.name
		end
	end
	if(apply ~= nil )then
		if(apply.datas ~= nil )then
			for i=1,#apply.datas do 
				table.insert(msg.apply.datas, apply.datas[i])
			end
		end
	end
	if(apply ~= nil )then
		if(apply.attrs ~= nil )then
			for i=1,#apply.attrs do 
				table.insert(msg.apply.attrs, apply.attrs[i])
			end
		end
	end
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTeamQuickEnterSocialCmd(user, type, set) 
	local msg = SocialCmd_pb.TeamQuickEnterSocialCmd()
	if(user.user ~= nil )then
		if(user.user.accid ~= nil )then
			msg.user.user.accid = user.user.accid
		end
	end
	if(user.user ~= nil )then
		if(user.user.charid ~= nil )then
			msg.user.user.charid = user.user.charid
		end
	end
	if(user.user ~= nil )then
		if(user.user.zoneid ~= nil )then
			msg.user.user.zoneid = user.user.zoneid
		end
	end
	if(user.user ~= nil )then
		if(user.user.mapid ~= nil )then
			msg.user.user.mapid = user.user.mapid
		end
	end
	if(user.user ~= nil )then
		if(user.user.baselv ~= nil )then
			msg.user.user.baselv = user.user.baselv
		end
	end
	if(user.user ~= nil )then
		if(user.user.profession ~= nil )then
			msg.user.user.profession = user.user.profession
		end
	end
	if(user.user ~= nil )then
		if(user.user.name ~= nil )then
			msg.user.user.name = user.user.name
		end
	end
	if(user ~= nil )then
		if(user.datas ~= nil )then
			for i=1,#user.datas do 
				table.insert(msg.user.datas, user.datas[i])
			end
		end
	end
	if(user ~= nil )then
		if(user.attrs ~= nil )then
			for i=1,#user.attrs do 
				table.insert(msg.user.attrs, user.attrs[i])
			end
		end
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(set ~= nil )then
		msg.set = set
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallDojoStateNtfSocialCmd(teamid, guildid, state) 
	local msg = SocialCmd_pb.DojoStateNtfSocialCmd()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	if(state ~= nil )then
		msg.state = state
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallDojoCreateSocialCmd(charid, dojoid, teamid, guildid) 
	local msg = SocialCmd_pb.DojoCreateSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(dojoid ~= nil )then
		msg.dojoid = dojoid
	end
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTowerLeaderInfoSyncSocialCmd(user, info) 
	local msg = SocialCmd_pb.TowerLeaderInfoSyncSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(info ~= nil )then
		if(info.oldmaxlayer ~= nil )then
			msg.info.oldmaxlayer = info.oldmaxlayer
		end
	end
	if(info ~= nil )then
		if(info.curmaxlayer ~= nil )then
			msg.info.curmaxlayer = info.curmaxlayer
		end
	end
	if(info ~= nil )then
		if(info.layers ~= nil )then
			for i=1,#info.layers do 
				table.insert(msg.info.layers, info.layers[i])
			end
		end
	end
	if(info ~= nil )then
		if(info.maxlayer ~= nil )then
			msg.info.maxlayer = info.maxlayer
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTowerSceneCreateSocialCmd(user, teamid, layer) 
	local msg = SocialCmd_pb.TowerSceneCreateSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(layer ~= nil )then
		msg.layer = layer
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTowerSceneSyncSocialCmd(teamid, state, raidid) 
	local msg = SocialCmd_pb.TowerSceneSyncSocialCmd()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(state ~= nil )then
		msg.state = state
	end
	if(raidid ~= nil )then
		msg.raidid = raidid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTowerLayerSyncSocialCmd(teamid, layer) 
	local msg = SocialCmd_pb.TowerLayerSyncSocialCmd()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(layer ~= nil )then
		msg.layer = layer
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallLeaderSealFinishSocialCmd(teamid) 
	local msg = SocialCmd_pb.LeaderSealFinishSocialCmd()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGoTeamRaidSocialCmd(teamid, charid, myzoneid, raidzoneid, raidid, gomaptype) 
	local msg = SocialCmd_pb.GoTeamRaidSocialCmd()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(myzoneid ~= nil )then
		msg.myzoneid = myzoneid
	end
	if(raidzoneid ~= nil )then
		msg.raidzoneid = raidzoneid
	end
	if(raidid ~= nil )then
		msg.raidid = raidid
	end
	if(gomaptype ~= nil )then
		msg.gomaptype = gomaptype
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallDelTeamRaidSocialCmd(teamid, raidid) 
	local msg = SocialCmd_pb.DelTeamRaidSocialCmd()
	if(teamid ~= nil )then
		msg.teamid = teamid
	end
	if(raidid ~= nil )then
		msg.raidid = raidid
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallSendMailSocialCmd(zoneid, data, len) 
	local msg = SocialCmd_pb.SendMailSocialCmd()
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallForwardToAllSessionSocialCmd(except, data, len) 
	local msg = SocialCmd_pb.ForwardToAllSessionSocialCmd()
	if(except ~= nil )then
		msg.except = except
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGuildLevelUpSocialCmd(charid, guildid, addlevel, guildname) 
	local msg = SocialCmd_pb.GuildLevelUpSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(guildid ~= nil )then
		msg.guildid = guildid
	end
	if(addlevel ~= nil )then
		msg.addlevel = addlevel
	end
	if(guildname ~= nil )then
		msg.guildname = guildname
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallMoveGuildZoneSocialCmd(orizone, newzone) 
	local msg = SocialCmd_pb.MoveGuildZoneSocialCmd()
	if(orizone ~= nil )then
		msg.orizone = orizone
	end
	if(newzone ~= nil )then
		msg.newzone = newzone
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallSocialDataUpdateSocialCmd(charid, targetid, update, to_global) 
	local msg = SocialCmd_pb.SocialDataUpdateSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(targetid ~= nil )then
		msg.targetid = targetid
	end
	if(update ~= nil )then
		if(update.cmd ~= nil )then
			msg.update.cmd = update.cmd
		end
	end
	if(update ~= nil )then
		if(update.param ~= nil )then
			msg.update.param = update.param
		end
	end
	if(update ~= nil )then
		if(update.guid ~= nil )then
			msg.update.guid = update.guid
		end
	end
	if(update ~= nil )then
		if(update.items ~= nil )then
			for i=1,#update.items do 
				table.insert(msg.update.items, update.items[i])
			end
		end
	end
	if(to_global ~= nil )then
		msg.to_global = to_global
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallAddRelationSocialCmd(user, destid, relation, to_global) 
	local msg = SocialCmd_pb.AddRelationSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(destid ~= nil )then
		msg.destid = destid
	end
	if(relation ~= nil )then
		msg.relation = relation
	end
	if(to_global ~= nil )then
		msg.to_global = to_global
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallRemoveRelationSocialCmd(user, destid, relation, to_global) 
	local msg = SocialCmd_pb.RemoveRelationSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(destid ~= nil )then
		msg.destid = destid
	end
	if(relation ~= nil )then
		msg.relation = relation
	end
	if(to_global ~= nil )then
		msg.to_global = to_global
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallRemoveFocusSocialCmd(user, destid, to_global) 
	local msg = SocialCmd_pb.RemoveFocusSocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(destid ~= nil )then
		msg.destid = destid
	end
	if(to_global ~= nil )then
		msg.to_global = to_global
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallRemoveSocialitySocialCmd(user, destid, to_global) 
	local msg = SocialCmd_pb.RemoveSocialitySocialCmd()
	if(user ~= nil )then
		if(user.accid ~= nil )then
			msg.user.accid = user.accid
		end
	end
	if(user ~= nil )then
		if(user.charid ~= nil )then
			msg.user.charid = user.charid
		end
	end
	if(user ~= nil )then
		if(user.zoneid ~= nil )then
			msg.user.zoneid = user.zoneid
		end
	end
	if(user ~= nil )then
		if(user.mapid ~= nil )then
			msg.user.mapid = user.mapid
		end
	end
	if(user ~= nil )then
		if(user.baselv ~= nil )then
			msg.user.baselv = user.baselv
		end
	end
	if(user ~= nil )then
		if(user.profession ~= nil )then
			msg.user.profession = user.profession
		end
	end
	if(user ~= nil )then
		if(user.name ~= nil )then
			msg.user.name = user.name
		end
	end
	if(destid ~= nil )then
		msg.destid = destid
	end
	if(to_global ~= nil )then
		msg.to_global = to_global
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallSyncSocialListSocialCmd(charid, items) 
	local msg = SocialCmd_pb.SyncSocialListSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallSocialListUpdateSocialCmd(charid, updates, dels) 
	local msg = SocialCmd_pb.SocialListUpdateSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if( updates ~= nil )then
		for i=1,#updates do 
			table.insert(msg.updates, updates[i])
		end
	end
	if( dels ~= nil )then
		for i=1,#dels do 
			table.insert(msg.dels, dels[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallTeamerQuestUpdateSocialCmd(quest) 
	local msg = SocialCmd_pb.TeamerQuestUpdateSocialCmd()
	if(quest ~= nil )then
		if(quest.charid ~= nil )then
			msg.quest.charid = quest.charid
		end
	end
	if(quest ~= nil )then
		if(quest.questid ~= nil )then
			msg.quest.questid = quest.questid
		end
	end
	if(quest ~= nil )then
		if(quest.action ~= nil )then
			msg.quest.action = quest.action
		end
	end
	if(quest ~= nil )then
		if(quest.step ~= nil )then
			msg.quest.step = quest.step
		end
	end
	if(quest.questdata ~= nil )then
		if(quest.questdata.process ~= nil )then
			msg.quest.questdata.process = quest.questdata.process
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.params ~= nil )then
			for i=1,#quest.questdata.params do 
				table.insert(msg.quest.questdata.params, quest.questdata.params[i])
			end
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.names ~= nil )then
			for i=1,#quest.questdata.names do 
				table.insert(msg.quest.questdata.names, quest.questdata.names[i])
			end
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.RewardGroup ~= nil )then
			msg.quest.questdata.config.RewardGroup = quest.questdata.config.RewardGroup
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.SubGroup ~= nil )then
			msg.quest.questdata.config.SubGroup = quest.questdata.config.SubGroup
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.FinishJump ~= nil )then
			msg.quest.questdata.config.FinishJump = quest.questdata.config.FinishJump
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.FailJump ~= nil )then
			msg.quest.questdata.config.FailJump = quest.questdata.config.FailJump
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Map ~= nil )then
			msg.quest.questdata.config.Map = quest.questdata.config.Map
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.WhetherTrace ~= nil )then
			msg.quest.questdata.config.WhetherTrace = quest.questdata.config.WhetherTrace
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Auto ~= nil )then
			msg.quest.questdata.config.Auto = quest.questdata.config.Auto
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.FirstClass ~= nil )then
			msg.quest.questdata.config.FirstClass = quest.questdata.config.FirstClass
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Class ~= nil )then
			msg.quest.questdata.config.Class = quest.questdata.config.Class
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.QuestName ~= nil )then
			msg.quest.questdata.config.QuestName = quest.questdata.config.QuestName
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Name ~= nil )then
			msg.quest.questdata.config.Name = quest.questdata.config.Name
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Type ~= nil )then
			msg.quest.questdata.config.Type = quest.questdata.config.Type
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.Content ~= nil )then
			msg.quest.questdata.config.Content = quest.questdata.config.Content
		end
	end
	if(quest.questdata.config ~= nil )then
		if(quest.questdata.config.TraceInfo ~= nil )then
			msg.quest.questdata.config.TraceInfo = quest.questdata.config.TraceInfo
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.config.params.params ~= nil )then
			for i=1,#quest.questdata.config.params.params do 
				table.insert(msg.quest.questdata.config.params.params, quest.questdata.config.params.params[i])
			end
		end
	end
	if(quest ~= nil )then
		if(quest.questdata.config.allrewardid ~= nil )then
			for i=1,#quest.questdata.config.allrewardid do 
				table.insert(msg.quest.questdata.config.allrewardid, quest.questdata.config.allrewardid[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallGlobalForwardCmdSocialCmd(charid, data, len) 
	local msg = SocialCmd_pb.GlobalForwardCmdSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(data ~= nil )then
		msg.data = data
	end
	if(len ~= nil )then
		msg.len = len
	end
	self:SendProto(msg)
end

function ServiceSocialCmdAutoProxy:CallAuthorizeInfoSyncSocialCmd(charid, ignorepwd) 
	local msg = SocialCmd_pb.AuthorizeInfoSyncSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(ignorepwd ~= nil )then
		msg.ignorepwd = ignorepwd
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
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

function ServiceSocialCmdAutoProxy:RecvGuildPraySocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGuildPraySocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvGuildApplySocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGuildApplySocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvGuildProcessInviteSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGuildProcessInviteSocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvGuildAddConSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGuildAddConSocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvGuildAddAssetSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGuildAddAssetSocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvGuildExchangeZoneSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGuildExchangeZoneSocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvGuildAddItemSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGuildAddItemSocialCmd, data)
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

function ServiceSocialCmdAutoProxy:RecvTeamerQuestUpdateSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdTeamerQuestUpdateSocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvGlobalForwardCmdSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd, data)
end

function ServiceSocialCmdAutoProxy:RecvAuthorizeInfoSyncSocialCmd(data) 
	self:Notify(ServiceEvent.SocialCmdAuthorizeInfoSyncSocialCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
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
ServiceEvent.SocialCmdGuildPraySocialCmd = "ServiceEvent_SocialCmdGuildPraySocialCmd"
ServiceEvent.SocialCmdGuildApplySocialCmd = "ServiceEvent_SocialCmdGuildApplySocialCmd"
ServiceEvent.SocialCmdGuildProcessInviteSocialCmd = "ServiceEvent_SocialCmdGuildProcessInviteSocialCmd"
ServiceEvent.SocialCmdGuildAddConSocialCmd = "ServiceEvent_SocialCmdGuildAddConSocialCmd"
ServiceEvent.SocialCmdGuildAddAssetSocialCmd = "ServiceEvent_SocialCmdGuildAddAssetSocialCmd"
ServiceEvent.SocialCmdGuildExchangeZoneSocialCmd = "ServiceEvent_SocialCmdGuildExchangeZoneSocialCmd"
ServiceEvent.SocialCmdGuildAddItemSocialCmd = "ServiceEvent_SocialCmdGuildAddItemSocialCmd"
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
ServiceEvent.SocialCmdTeamerQuestUpdateSocialCmd = "ServiceEvent_SocialCmdTeamerQuestUpdateSocialCmd"
ServiceEvent.SocialCmdGlobalForwardCmdSocialCmd = "ServiceEvent_SocialCmdGlobalForwardCmdSocialCmd"
ServiceEvent.SocialCmdAuthorizeInfoSyncSocialCmd = "ServiceEvent_SocialCmdAuthorizeInfoSyncSocialCmd"
