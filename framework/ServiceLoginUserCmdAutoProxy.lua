ServiceLoginUserCmdAutoProxy = class('ServiceLoginUserCmdAutoProxy', ServiceProxy)

ServiceLoginUserCmdAutoProxy.Instance = nil

ServiceLoginUserCmdAutoProxy.NAME = 'ServiceLoginUserCmdAutoProxy'

function ServiceLoginUserCmdAutoProxy:ctor(proxyName)
	if ServiceLoginUserCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceLoginUserCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceLoginUserCmdAutoProxy.Instance = self
	end
end

function ServiceLoginUserCmdAutoProxy:Init()
end

function ServiceLoginUserCmdAutoProxy:onRegister()
	self:Listen(1, 4, function (data)
		self:RecvRegResultUserCmd(data) 
	end)
	self:Listen(1, 5, function (data)
		self:RecvCreateCharUserCmd(data) 
	end)
	self:Listen(1, 6, function (data)
		self:RecvSnapShotUserCmd(data) 
	end)
	self:Listen(1, 7, function (data)
		self:RecvSelectRoleUserCmd(data) 
	end)
	self:Listen(1, 8, function (data)
		self:RecvLoginResultUserCmd(data) 
	end)
	self:Listen(1, 9, function (data)
		self:RecvDeleteCharUserCmd(data) 
	end)
	self:Listen(1, 10, function (data)
		self:RecvHeartBeatUserCmd(data) 
	end)
	self:Listen(1, 11, function (data)
		self:RecvServerTimeUserCmd(data) 
	end)
	self:Listen(1, 12, function (data)
		self:RecvGMDeleteCharUserCmd(data) 
	end)
	self:Listen(1, 13, function (data)
		self:RecvClientInfoUserCmd(data) 
	end)
	self:Listen(1, 14, function (data)
		self:RecvReqLoginUserCmd(data) 
	end)
	self:Listen(1, 15, function (data)
		self:RecvReqLoginParamUserCmd(data) 
	end)
	self:Listen(1, 16, function (data)
		self:RecvKickParamUserCmd(data) 
	end)
	self:Listen(1, 17, function (data)
		self:RecvCancelDeleteCharUserCmd(data) 
	end)
	self:Listen(1, 18, function (data)
		self:RecvClientFrameUserCmd(data) 
	end)
	self:Listen(1, 19, function (data)
		self:RecvSafeDeviceUserCmd(data) 
	end)
	self:Listen(1, 20, function (data)
		self:RecvConfirmAuthorizeUserCmd(data) 
	end)
	self:Listen(1, 21, function (data)
		self:RecvSyncAuthorizeGateCmd(data) 
	end)
	self:Listen(1, 22, function (data)
		self:RecvRealAuthorizeUserCmd(data) 
	end)
	self:Listen(1, 23, function (data)
		self:RecvRealAuthorizeServerCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceLoginUserCmdAutoProxy:CallRegResultUserCmd(id, ret) 
	local msg = LoginUserCmd_pb.RegResultUserCmd()
	msg.id = id
	msg.ret = ret
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallCreateCharUserCmd(name, role_sex, profession, hair, haircolor, clothcolor, accid, sequence, version) 
	local msg = LoginUserCmd_pb.CreateCharUserCmd()
	if(name ~= nil )then
		msg.name = name
	end
	if(role_sex ~= nil )then
		msg.role_sex = role_sex
	end
	if(profession ~= nil )then
		msg.profession = profession
	end
	if(hair ~= nil )then
		msg.hair = hair
	end
	if(haircolor ~= nil )then
		msg.haircolor = haircolor
	end
	if(clothcolor ~= nil )then
		msg.clothcolor = clothcolor
	end
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(sequence ~= nil )then
		msg.sequence = sequence
	end
	if(version ~= nil )then
		msg.version = version
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallSnapShotUserCmd(data, lastselect, deletechar, deletecdtime, maincharid) 
	local msg = LoginUserCmd_pb.SnapShotUserCmd()
	if( data ~= nil )then
		for i=1,#data do 
			table.insert(msg.data, data[i])
		end
	end
	if(lastselect ~= nil )then
		msg.lastselect = lastselect
	end
	if(deletechar ~= nil )then
		msg.deletechar = deletechar
	end
	if(deletecdtime ~= nil )then
		msg.deletecdtime = deletecdtime
	end
	if(maincharid ~= nil )then
		msg.maincharid = maincharid
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallSelectRoleUserCmd(id, zoneID, accid, deviceid, name, version, extraData, ignorepwd, password, resettime, language, realauthorized, maxbaselv) 
	local msg = LoginUserCmd_pb.SelectRoleUserCmd()
	msg.id = id
	if(zoneID ~= nil )then
		msg.zoneID = zoneID
	end
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(deviceid ~= nil )then
		msg.deviceid = deviceid
	end
	if(name ~= nil )then
		msg.name = name
	end
	if(version ~= nil )then
		msg.version = version
	end
	if(extraData ~= nil )then
		if(extraData.phone ~= nil )then
			msg.extraData.phone = extraData.phone
		end
	end
	if(extraData ~= nil )then
		if(extraData.safedevice ~= nil )then
			msg.extraData.safedevice = extraData.safedevice
		end
	end
	if(ignorepwd ~= nil )then
		msg.ignorepwd = ignorepwd
	end
	if(password ~= nil )then
		msg.password = password
	end
	if(resettime ~= nil )then
		msg.resettime = resettime
	end
	if(language ~= nil )then
		msg.language = language
	end
	if(realauthorized ~= nil )then
		msg.realauthorized = realauthorized
	end
	if(maxbaselv ~= nil )then
		msg.maxbaselv = maxbaselv
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallLoginResultUserCmd(ret) 
	local msg = LoginUserCmd_pb.LoginResultUserCmd()
	msg.ret = ret
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallDeleteCharUserCmd(id, accid, version) 
	local msg = LoginUserCmd_pb.DeleteCharUserCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(version ~= nil )then
		msg.version = version
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallHeartBeatUserCmd(time) 
	local msg = LoginUserCmd_pb.HeartBeatUserCmd()
	if(time ~= nil )then
		msg.time = time
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallServerTimeUserCmd(time) 
	local msg = LoginUserCmd_pb.ServerTimeUserCmd()
	if(time ~= nil )then
		msg.time = time
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallGMDeleteCharUserCmd(accid, zoneid) 
	local msg = LoginUserCmd_pb.GMDeleteCharUserCmd()
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallClientInfoUserCmd(ip, delay) 
	local msg = LoginUserCmd_pb.ClientInfoUserCmd()
	if(ip ~= nil )then
		msg.ip = ip
	end
	if(delay ~= nil )then
		msg.delay = delay
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallReqLoginUserCmd(accid, sha1, zoneid, timestamp, version, domain, ip, device, phone, safe_device, language, site, authorize) 
	local msg = LoginUserCmd_pb.ReqLoginUserCmd()
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(sha1 ~= nil )then
		msg.sha1 = sha1
	end
	if(zoneid ~= nil )then
		msg.zoneid = zoneid
	end
	if(timestamp ~= nil )then
		msg.timestamp = timestamp
	end
	if(version ~= nil )then
		msg.version = version
	end
	if(domain ~= nil )then
		msg.domain = domain
	end
	if(ip ~= nil )then
		msg.ip = ip
	end
	if(device ~= nil )then
		msg.device = device
	end
	if(phone ~= nil )then
		msg.phone = phone
	end
	if(safe_device ~= nil )then
		msg.safe_device = safe_device
	end
	if(language ~= nil )then
		msg.language = language
	end
	if(site ~= nil )then
		msg.site = site
	end
	if(authorize ~= nil )then
		msg.authorize = authorize
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallReqLoginParamUserCmd(accid, sha1, timestamp, phone, version) 
	local msg = LoginUserCmd_pb.ReqLoginParamUserCmd()
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(sha1 ~= nil )then
		msg.sha1 = sha1
	end
	if(timestamp ~= nil )then
		msg.timestamp = timestamp
	end
	if(phone ~= nil )then
		msg.phone = phone
	end
	if(version ~= nil )then
		msg.version = version
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallKickParamUserCmd(charid, accid) 
	local msg = LoginUserCmd_pb.KickParamUserCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(accid ~= nil )then
		msg.accid = accid
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallCancelDeleteCharUserCmd(id, accid) 
	local msg = LoginUserCmd_pb.CancelDeleteCharUserCmd()
	if(id ~= nil )then
		msg.id = id
	end
	if(accid ~= nil )then
		msg.accid = accid
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallClientFrameUserCmd(frame) 
	local msg = LoginUserCmd_pb.ClientFrameUserCmd()
	if(frame ~= nil )then
		msg.frame = frame
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallSafeDeviceUserCmd(safe) 
	local msg = LoginUserCmd_pb.SafeDeviceUserCmd()
	if(safe ~= nil )then
		msg.safe = safe
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallConfirmAuthorizeUserCmd(password, success, resettime, hasset) 
	local msg = LoginUserCmd_pb.ConfirmAuthorizeUserCmd()
	if(password ~= nil )then
		msg.password = password
	end
	if(success ~= nil )then
		msg.success = success
	end
	if(resettime ~= nil )then
		msg.resettime = resettime
	end
	if(hasset ~= nil )then
		msg.hasset = hasset
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallSyncAuthorizeGateCmd(ignorepwd, password, version, accid, resettime) 
	local msg = LoginUserCmd_pb.SyncAuthorizeGateCmd()
	if(ignorepwd ~= nil )then
		msg.ignorepwd = ignorepwd
	end
	if(password ~= nil )then
		msg.password = password
	end
	if(version ~= nil )then
		msg.version = version
	end
	if(accid ~= nil )then
		msg.accid = accid
	end
	if(resettime ~= nil )then
		msg.resettime = resettime
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallRealAuthorizeUserCmd(authoriz_state, authorized) 
	local msg = LoginUserCmd_pb.RealAuthorizeUserCmd()
	if(authoriz_state ~= nil )then
		msg.authoriz_state = authoriz_state
	end
	if(authorized ~= nil )then
		msg.authorized = authorized
	end
	self:SendProto(msg)
end

function ServiceLoginUserCmdAutoProxy:CallRealAuthorizeServerCmd(authorized) 
	local msg = LoginUserCmd_pb.RealAuthorizeServerCmd()
	if(authorized ~= nil )then
		msg.authorized = authorized
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceLoginUserCmdAutoProxy:RecvRegResultUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdRegResultUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvCreateCharUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdCreateCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSnapShotUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdSnapShotUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSelectRoleUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdSelectRoleUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvLoginResultUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdLoginResultUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvDeleteCharUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdDeleteCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvHeartBeatUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdHeartBeatUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvServerTimeUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdServerTimeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvGMDeleteCharUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdGMDeleteCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvClientInfoUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdClientInfoUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvReqLoginUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdReqLoginUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvReqLoginParamUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdReqLoginParamUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvKickParamUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdKickParamUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvCancelDeleteCharUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdCancelDeleteCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvClientFrameUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdClientFrameUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSafeDeviceUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdSafeDeviceUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvConfirmAuthorizeUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSyncAuthorizeGateCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdSyncAuthorizeGateCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvRealAuthorizeUserCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdRealAuthorizeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvRealAuthorizeServerCmd(data) 
	self:Notify(ServiceEvent.LoginUserCmdRealAuthorizeServerCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.LoginUserCmdRegResultUserCmd = "ServiceEvent_LoginUserCmdRegResultUserCmd"
ServiceEvent.LoginUserCmdCreateCharUserCmd = "ServiceEvent_LoginUserCmdCreateCharUserCmd"
ServiceEvent.LoginUserCmdSnapShotUserCmd = "ServiceEvent_LoginUserCmdSnapShotUserCmd"
ServiceEvent.LoginUserCmdSelectRoleUserCmd = "ServiceEvent_LoginUserCmdSelectRoleUserCmd"
ServiceEvent.LoginUserCmdLoginResultUserCmd = "ServiceEvent_LoginUserCmdLoginResultUserCmd"
ServiceEvent.LoginUserCmdDeleteCharUserCmd = "ServiceEvent_LoginUserCmdDeleteCharUserCmd"
ServiceEvent.LoginUserCmdHeartBeatUserCmd = "ServiceEvent_LoginUserCmdHeartBeatUserCmd"
ServiceEvent.LoginUserCmdServerTimeUserCmd = "ServiceEvent_LoginUserCmdServerTimeUserCmd"
ServiceEvent.LoginUserCmdGMDeleteCharUserCmd = "ServiceEvent_LoginUserCmdGMDeleteCharUserCmd"
ServiceEvent.LoginUserCmdClientInfoUserCmd = "ServiceEvent_LoginUserCmdClientInfoUserCmd"
ServiceEvent.LoginUserCmdReqLoginUserCmd = "ServiceEvent_LoginUserCmdReqLoginUserCmd"
ServiceEvent.LoginUserCmdReqLoginParamUserCmd = "ServiceEvent_LoginUserCmdReqLoginParamUserCmd"
ServiceEvent.LoginUserCmdKickParamUserCmd = "ServiceEvent_LoginUserCmdKickParamUserCmd"
ServiceEvent.LoginUserCmdCancelDeleteCharUserCmd = "ServiceEvent_LoginUserCmdCancelDeleteCharUserCmd"
ServiceEvent.LoginUserCmdClientFrameUserCmd = "ServiceEvent_LoginUserCmdClientFrameUserCmd"
ServiceEvent.LoginUserCmdSafeDeviceUserCmd = "ServiceEvent_LoginUserCmdSafeDeviceUserCmd"
ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd = "ServiceEvent_LoginUserCmdConfirmAuthorizeUserCmd"
ServiceEvent.LoginUserCmdSyncAuthorizeGateCmd = "ServiceEvent_LoginUserCmdSyncAuthorizeGateCmd"
ServiceEvent.LoginUserCmdRealAuthorizeUserCmd = "ServiceEvent_LoginUserCmdRealAuthorizeUserCmd"
ServiceEvent.LoginUserCmdRealAuthorizeServerCmd = "ServiceEvent_LoginUserCmdRealAuthorizeServerCmd"
