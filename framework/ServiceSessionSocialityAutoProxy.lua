ServiceSessionSocialityAutoProxy = class('ServiceSessionSocialityAutoProxy', ServiceProxy)

ServiceSessionSocialityAutoProxy.Instance = nil

ServiceSessionSocialityAutoProxy.NAME = 'ServiceSessionSocialityAutoProxy'

function ServiceSessionSocialityAutoProxy:ctor(proxyName)
	if ServiceSessionSocialityAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSessionSocialityAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSessionSocialityAutoProxy.Instance = self
	end
end

function ServiceSessionSocialityAutoProxy:Init()
end

function ServiceSessionSocialityAutoProxy:onRegister()
	self:Listen(56, 1, function (data)
		self:RecvQuerySocialData(data) 
	end)
	self:Listen(56, 2, function (data)
		self:RecvFindUser(data) 
	end)
	self:Listen(56, 3, function (data)
		self:RecvSocialUpdate(data) 
	end)
	self:Listen(56, 4, function (data)
		self:RecvSocialDataUpdate(data) 
	end)
	self:Listen(56, 5, function (data)
		self:RecvFrameStatusSocialCmd(data) 
	end)
	self:Listen(56, 6, function (data)
		self:RecvUseGiftCodeSocialCmd(data) 
	end)
	self:Listen(56, 7, function (data)
		self:RecvOperateQuerySocialCmd(data) 
	end)
	self:Listen(56, 8, function (data)
		self:RecvOperateTakeSocialCmd(data) 
	end)
	self:Listen(56, 9, function (data)
		self:RecvQueryDataNtfSocialCmd(data) 
	end)
	self:Listen(56, 10, function (data)
		self:RecvOperActivityNtfSocialCmd(data) 
	end)
	self:Listen(56, 11, function (data)
		self:RecvAddRelation(data) 
	end)
	self:Listen(56, 12, function (data)
		self:RecvRemoveRelation(data) 
	end)
	self:Listen(56, 13, function (data)
		self:RecvQueryRecallListSocialCmd(data) 
	end)
	self:Listen(56, 14, function (data)
		self:RecvRecallFriendSocialCmd(data) 
	end)
	self:Listen(56, 15, function (data)
		self:RecvAddRelationResultSocialCmd(data) 
	end)
	self:Listen(56, 16, function (data)
		self:RecvQueryChargeVirginCmd(data) 
	end)
	self:Listen(56, 17, function (data)
		self:RecvQueryUserInfoCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSessionSocialityAutoProxy:CallQuerySocialData(datas) 
	local msg = SessionSociality_pb.QuerySocialData()
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallFindUser(keyword, datas) 
	local msg = SessionSociality_pb.FindUser()
	if(keyword ~= nil )then
		msg.keyword = keyword
	end
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallSocialUpdate(updates, dels) 
	local msg = SessionSociality_pb.SocialUpdate()
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

function ServiceSessionSocialityAutoProxy:CallSocialDataUpdate(guid, items) 
	local msg = SessionSociality_pb.SocialDataUpdate()
	if(guid ~= nil )then
		msg.guid = guid
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallFrameStatusSocialCmd(open) 
	local msg = SessionSociality_pb.FrameStatusSocialCmd()
	if(open ~= nil )then
		msg.open = open
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallUseGiftCodeSocialCmd(code, ret) 
	local msg = SessionSociality_pb.UseGiftCodeSocialCmd()
	if(code ~= nil )then
		msg.code = code
	end
	if(ret ~= nil )then
		msg.ret = ret
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallOperateQuerySocialCmd(type, state, param1, param2, param3, param4) 
	local msg = SessionSociality_pb.OperateQuerySocialCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(state ~= nil )then
		msg.state = state
	end
	if(param1 ~= nil )then
		msg.param1 = param1
	end
	if(param2 ~= nil )then
		msg.param2 = param2
	end
	if(param3 ~= nil )then
		msg.param3 = param3
	end
	if( param4 ~= nil )then
		for i=1,#param4 do 
			table.insert(msg.param4, param4[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallOperateTakeSocialCmd(type, state, subkey) 
	local msg = SessionSociality_pb.OperateTakeSocialCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(state ~= nil )then
		msg.state = state
	end
	if(subkey ~= nil )then
		msg.subkey = subkey
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallQueryDataNtfSocialCmd(relations) 
	local msg = SessionSociality_pb.QueryDataNtfSocialCmd()
	if( relations ~= nil )then
		for i=1,#relations do 
			table.insert(msg.relations, relations[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallOperActivityNtfSocialCmd(activity) 
	local msg = SessionSociality_pb.OperActivityNtfSocialCmd()
	if( activity ~= nil )then
		for i=1,#activity do 
			table.insert(msg.activity, activity[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallAddRelation(charid, relation) 
	local msg = SessionSociality_pb.AddRelation()
	if( charid ~= nil )then
		for i=1,#charid do 
			table.insert(msg.charid, charid[i])
		end
	end
	if(relation ~= nil )then
		msg.relation = relation
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallRemoveRelation(charid, relation) 
	local msg = SessionSociality_pb.RemoveRelation()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(relation ~= nil )then
		msg.relation = relation
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallQueryRecallListSocialCmd(items) 
	local msg = SessionSociality_pb.QueryRecallListSocialCmd()
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallRecallFriendSocialCmd(charid) 
	local msg = SessionSociality_pb.RecallFriendSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallAddRelationResultSocialCmd(charid, relation, success) 
	local msg = SessionSociality_pb.AddRelationResultSocialCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(relation ~= nil )then
		msg.relation = relation
	end
	if(success ~= nil )then
		msg.success = success
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallQueryChargeVirginCmd(datas, del) 
	local msg = SessionSociality_pb.QueryChargeVirginCmd()
	if( datas ~= nil )then
		for i=1,#datas do 
			table.insert(msg.datas, datas[i])
		end
	end
	if(del ~= nil )then
		msg.del = del
	end
	self:SendProto(msg)
end

function ServiceSessionSocialityAutoProxy:CallQueryUserInfoCmd(charid, data) 
	local msg = SessionSociality_pb.QueryUserInfoCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(data ~= nil )then
		if(data.guid ~= nil )then
			msg.data.guid = data.guid
		end
	end
	if(data ~= nil )then
		if(data.accid ~= nil )then
			msg.data.accid = data.accid
		end
	end
	if(data ~= nil )then
		if(data.level ~= nil )then
			msg.data.level = data.level
		end
	end
	if(data ~= nil )then
		if(data.offlinetime ~= nil )then
			msg.data.offlinetime = data.offlinetime
		end
	end
	if(data ~= nil )then
		if(data.relation ~= nil )then
			msg.data.relation = data.relation
		end
	end
	if(data ~= nil )then
		if(data.portrait ~= nil )then
			msg.data.portrait = data.portrait
		end
	end
	if(data ~= nil )then
		if(data.frame ~= nil )then
			msg.data.frame = data.frame
		end
	end
	if(data ~= nil )then
		if(data.hair ~= nil )then
			msg.data.hair = data.hair
		end
	end
	if(data ~= nil )then
		if(data.haircolor ~= nil )then
			msg.data.haircolor = data.haircolor
		end
	end
	if(data ~= nil )then
		if(data.body ~= nil )then
			msg.data.body = data.body
		end
	end
	if(data ~= nil )then
		if(data.head ~= nil )then
			msg.data.head = data.head
		end
	end
	if(data ~= nil )then
		if(data.face ~= nil )then
			msg.data.face = data.face
		end
	end
	if(data ~= nil )then
		if(data.mouth ~= nil )then
			msg.data.mouth = data.mouth
		end
	end
	if(data ~= nil )then
		if(data.eye ~= nil )then
			msg.data.eye = data.eye
		end
	end
	if(data ~= nil )then
		if(data.profic ~= nil )then
			msg.data.profic = data.profic
		end
	end
	if(data ~= nil )then
		if(data.adventurelv ~= nil )then
			msg.data.adventurelv = data.adventurelv
		end
	end
	if(data ~= nil )then
		if(data.adventureexp ~= nil )then
			msg.data.adventureexp = data.adventureexp
		end
	end
	if(data ~= nil )then
		if(data.appellation ~= nil )then
			msg.data.appellation = data.appellation
		end
	end
	if(data ~= nil )then
		if(data.mapid ~= nil )then
			msg.data.mapid = data.mapid
		end
	end
	if(data ~= nil )then
		if(data.zoneid ~= nil )then
			msg.data.zoneid = data.zoneid
		end
	end
	if(data ~= nil )then
		if(data.profession ~= nil )then
			msg.data.profession = data.profession
		end
	end
	if(data ~= nil )then
		if(data.gender ~= nil )then
			msg.data.gender = data.gender
		end
	end
	if(data ~= nil )then
		if(data.blink ~= nil )then
			msg.data.blink = data.blink
		end
	end
	if(data ~= nil )then
		if(data.recall ~= nil )then
			msg.data.recall = data.recall
		end
	end
	if(data ~= nil )then
		if(data.canrecall ~= nil )then
			msg.data.canrecall = data.canrecall
		end
	end
	if(data ~= nil )then
		if(data.name ~= nil )then
			msg.data.name = data.name
		end
	end
	if(data ~= nil )then
		if(data.guildname ~= nil )then
			msg.data.guildname = data.guildname
		end
	end
	if(data ~= nil )then
		if(data.guildportrait ~= nil )then
			msg.data.guildportrait = data.guildportrait
		end
	end
	if(data ~= nil )then
		if(data.createtime ~= nil )then
			msg.data.createtime = data.createtime
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSessionSocialityAutoProxy:RecvQuerySocialData(data) 
	self:Notify(ServiceEvent.SessionSocialityQuerySocialData, data)
end

function ServiceSessionSocialityAutoProxy:RecvFindUser(data) 
	self:Notify(ServiceEvent.SessionSocialityFindUser, data)
end

function ServiceSessionSocialityAutoProxy:RecvSocialUpdate(data) 
	self:Notify(ServiceEvent.SessionSocialitySocialUpdate, data)
end

function ServiceSessionSocialityAutoProxy:RecvSocialDataUpdate(data) 
	self:Notify(ServiceEvent.SessionSocialitySocialDataUpdate, data)
end

function ServiceSessionSocialityAutoProxy:RecvFrameStatusSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityFrameStatusSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvUseGiftCodeSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityUseGiftCodeSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvOperateQuerySocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityOperateQuerySocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvOperateTakeSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityOperateTakeSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryDataNtfSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityQueryDataNtfSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvOperActivityNtfSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityOperActivityNtfSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvAddRelation(data) 
	self:Notify(ServiceEvent.SessionSocialityAddRelation, data)
end

function ServiceSessionSocialityAutoProxy:RecvRemoveRelation(data) 
	self:Notify(ServiceEvent.SessionSocialityRemoveRelation, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryRecallListSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityQueryRecallListSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvRecallFriendSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityRecallFriendSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvAddRelationResultSocialCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityAddRelationResultSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryChargeVirginCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityQueryChargeVirginCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryUserInfoCmd(data) 
	self:Notify(ServiceEvent.SessionSocialityQueryUserInfoCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SessionSocialityQuerySocialData = "ServiceEvent_SessionSocialityQuerySocialData"
ServiceEvent.SessionSocialityFindUser = "ServiceEvent_SessionSocialityFindUser"
ServiceEvent.SessionSocialitySocialUpdate = "ServiceEvent_SessionSocialitySocialUpdate"
ServiceEvent.SessionSocialitySocialDataUpdate = "ServiceEvent_SessionSocialitySocialDataUpdate"
ServiceEvent.SessionSocialityFrameStatusSocialCmd = "ServiceEvent_SessionSocialityFrameStatusSocialCmd"
ServiceEvent.SessionSocialityUseGiftCodeSocialCmd = "ServiceEvent_SessionSocialityUseGiftCodeSocialCmd"
ServiceEvent.SessionSocialityOperateQuerySocialCmd = "ServiceEvent_SessionSocialityOperateQuerySocialCmd"
ServiceEvent.SessionSocialityOperateTakeSocialCmd = "ServiceEvent_SessionSocialityOperateTakeSocialCmd"
ServiceEvent.SessionSocialityQueryDataNtfSocialCmd = "ServiceEvent_SessionSocialityQueryDataNtfSocialCmd"
ServiceEvent.SessionSocialityOperActivityNtfSocialCmd = "ServiceEvent_SessionSocialityOperActivityNtfSocialCmd"
ServiceEvent.SessionSocialityAddRelation = "ServiceEvent_SessionSocialityAddRelation"
ServiceEvent.SessionSocialityRemoveRelation = "ServiceEvent_SessionSocialityRemoveRelation"
ServiceEvent.SessionSocialityQueryRecallListSocialCmd = "ServiceEvent_SessionSocialityQueryRecallListSocialCmd"
ServiceEvent.SessionSocialityRecallFriendSocialCmd = "ServiceEvent_SessionSocialityRecallFriendSocialCmd"
ServiceEvent.SessionSocialityAddRelationResultSocialCmd = "ServiceEvent_SessionSocialityAddRelationResultSocialCmd"
ServiceEvent.SessionSocialityQueryChargeVirginCmd = "ServiceEvent_SessionSocialityQueryChargeVirginCmd"
ServiceEvent.SessionSocialityQueryUserInfoCmd = "ServiceEvent_SessionSocialityQueryUserInfoCmd"
