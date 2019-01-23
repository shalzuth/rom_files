ServicePhotoCmdAutoProxy = class('ServicePhotoCmdAutoProxy', ServiceProxy)

ServicePhotoCmdAutoProxy.Instance = nil

ServicePhotoCmdAutoProxy.NAME = 'ServicePhotoCmdAutoProxy'

function ServicePhotoCmdAutoProxy:ctor(proxyName)
	if ServicePhotoCmdAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServicePhotoCmdAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServicePhotoCmdAutoProxy.Instance = self
	end
end

function ServicePhotoCmdAutoProxy:Init()
end

function ServicePhotoCmdAutoProxy:onRegister()
	self:Listen(30, 1, function (data)
		self:RecvPhotoQueryListCmd(data) 
	end)
	self:Listen(30, 2, function (data)
		self:RecvPhotoOptCmd(data) 
	end)
	self:Listen(30, 3, function (data)
		self:RecvPhotoUpdateNtf(data) 
	end)
	self:Listen(30, 4, function (data)
		self:RecvFrameActionPhotoCmd(data) 
	end)
	self:Listen(30, 5, function (data)
		self:RecvQueryFramePhotoListPhotoCmd(data) 
	end)
	self:Listen(30, 6, function (data)
		self:RecvQueryUserPhotoListPhotoCmd(data) 
	end)
	self:Listen(30, 7, function (data)
		self:RecvUpdateFrameShowPhotoCmd(data) 
	end)
	self:Listen(30, 8, function (data)
		self:RecvFramePhotoUpdatePhotoCmd(data) 
	end)
	self:Listen(30, 9, function (data)
		self:RecvQueryMd5ListPhotoCmd(data) 
	end)
	self:Listen(30, 10, function (data)
		self:RecvAddMd5PhotoCmd(data) 
	end)
	self:Listen(30, 11, function (data)
		self:RecvRemoveMd5PhotoCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServicePhotoCmdAutoProxy:CallPhotoQueryListCmd(photos, size) 
	local msg = PhotoCmd_pb.PhotoQueryListCmd()
	if( photos ~= nil )then
		for i=1,#photos do 
			table.insert(msg.photos, photos[i])
		end
	end
	if(size ~= nil )then
		msg.size = size
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallPhotoOptCmd(opttype, index, anglez, mapid) 
	local msg = PhotoCmd_pb.PhotoOptCmd()
	if(opttype ~= nil )then
		msg.opttype = opttype
	end
	if(index ~= nil )then
		msg.index = index
	end
	if(anglez ~= nil )then
		msg.anglez = anglez
	end
	if(mapid ~= nil )then
		msg.mapid = mapid
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallPhotoUpdateNtf(opttype, photo) 
	local msg = PhotoCmd_pb.PhotoUpdateNtf()
	if(opttype ~= nil )then
		msg.opttype = opttype
	end
	if(photo ~= nil )then
		if(photo.index ~= nil )then
			msg.photo.index = photo.index
		end
	end
	if(photo ~= nil )then
		if(photo.mapid ~= nil )then
			msg.photo.mapid = photo.mapid
		end
	end
	if(photo ~= nil )then
		if(photo.time ~= nil )then
			msg.photo.time = photo.time
		end
	end
	if(photo ~= nil )then
		if(photo.anglez ~= nil )then
			msg.photo.anglez = photo.anglez
		end
	end
	if(photo ~= nil )then
		if(photo.isupload ~= nil )then
			msg.photo.isupload = photo.isupload
		end
	end
	if(photo ~= nil )then
		if(photo.charid ~= nil )then
			msg.photo.charid = photo.charid
		end
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallFrameActionPhotoCmd(frameid, action, photos) 
	local msg = PhotoCmd_pb.FrameActionPhotoCmd()
	if(frameid ~= nil )then
		msg.frameid = frameid
	end
	if(action ~= nil )then
		msg.action = action
	end
	if( photos ~= nil )then
		for i=1,#photos do 
			table.insert(msg.photos, photos[i])
		end
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallQueryFramePhotoListPhotoCmd(frameid, photos) 
	local msg = PhotoCmd_pb.QueryFramePhotoListPhotoCmd()
	if(frameid ~= nil )then
		msg.frameid = frameid
	end
	if( photos ~= nil )then
		for i=1,#photos do 
			table.insert(msg.photos, photos[i])
		end
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallQueryUserPhotoListPhotoCmd(frames, maxphoto, maxframe) 
	local msg = PhotoCmd_pb.QueryUserPhotoListPhotoCmd()
	if( frames ~= nil )then
		for i=1,#frames do 
			table.insert(msg.frames, frames[i])
		end
	end
	if(maxphoto ~= nil )then
		msg.maxphoto = maxphoto
	end
	if(maxframe ~= nil )then
		msg.maxframe = maxframe
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallUpdateFrameShowPhotoCmd(shows) 
	local msg = PhotoCmd_pb.UpdateFrameShowPhotoCmd()
	if( shows ~= nil )then
		for i=1,#shows do 
			table.insert(msg.shows, shows[i])
		end
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallFramePhotoUpdatePhotoCmd(frameid, update, del) 
	local msg = PhotoCmd_pb.FramePhotoUpdatePhotoCmd()
	if(frameid ~= nil )then
		msg.frameid = frameid
	end
	if(update ~= nil )then
		if(update.accid_svr ~= nil )then
			msg.update.accid_svr = update.accid_svr
		end
	end
	if(update ~= nil )then
		if(update.accid ~= nil )then
			msg.update.accid = update.accid
		end
	end
	if(update ~= nil )then
		if(update.charid ~= nil )then
			msg.update.charid = update.charid
		end
	end
	if(update ~= nil )then
		if(update.anglez ~= nil )then
			msg.update.anglez = update.anglez
		end
	end
	if(update ~= nil )then
		if(update.time ~= nil )then
			msg.update.time = update.time
		end
	end
	if(update ~= nil )then
		if(update.mapid ~= nil )then
			msg.update.mapid = update.mapid
		end
	end
	if(update ~= nil )then
		if(update.sourceid ~= nil )then
			msg.update.sourceid = update.sourceid
		end
	end
	if(update ~= nil )then
		if(update.source ~= nil )then
			msg.update.source = update.source
		end
	end
	if(del ~= nil )then
		if(del.accid_svr ~= nil )then
			msg.del.accid_svr = del.accid_svr
		end
	end
	if(del ~= nil )then
		if(del.accid ~= nil )then
			msg.del.accid = del.accid
		end
	end
	if(del ~= nil )then
		if(del.charid ~= nil )then
			msg.del.charid = del.charid
		end
	end
	if(del ~= nil )then
		if(del.anglez ~= nil )then
			msg.del.anglez = del.anglez
		end
	end
	if(del ~= nil )then
		if(del.time ~= nil )then
			msg.del.time = del.time
		end
	end
	if(del ~= nil )then
		if(del.mapid ~= nil )then
			msg.del.mapid = del.mapid
		end
	end
	if(del ~= nil )then
		if(del.sourceid ~= nil )then
			msg.del.sourceid = del.sourceid
		end
	end
	if(del ~= nil )then
		if(del.source ~= nil )then
			msg.del.source = del.source
		end
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallQueryMd5ListPhotoCmd(item) 
	local msg = PhotoCmd_pb.QueryMd5ListPhotoCmd()
	if( item ~= nil )then
		for i=1,#item do 
			table.insert(msg.item, item[i])
		end
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallAddMd5PhotoCmd(md5) 
	local msg = PhotoCmd_pb.AddMd5PhotoCmd()
	if(md5 ~= nil )then
		if(md5.sourceid ~= nil )then
			msg.md5.sourceid = md5.sourceid
		end
	end
	if(md5 ~= nil )then
		if(md5.time ~= nil )then
			msg.md5.time = md5.time
		end
	end
	if(md5 ~= nil )then
		if(md5.source ~= nil )then
			msg.md5.source = md5.source
		end
	end
	if(md5 ~= nil )then
		if(md5.md5 ~= nil )then
			msg.md5.md5 = md5.md5
		end
	end
	self:SendProto(msg)
end

function ServicePhotoCmdAutoProxy:CallRemoveMd5PhotoCmd(md5) 
	local msg = PhotoCmd_pb.RemoveMd5PhotoCmd()
	if(md5 ~= nil )then
		if(md5.sourceid ~= nil )then
			msg.md5.sourceid = md5.sourceid
		end
	end
	if(md5 ~= nil )then
		if(md5.time ~= nil )then
			msg.md5.time = md5.time
		end
	end
	if(md5 ~= nil )then
		if(md5.source ~= nil )then
			msg.md5.source = md5.source
		end
	end
	if(md5 ~= nil )then
		if(md5.md5 ~= nil )then
			msg.md5.md5 = md5.md5
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServicePhotoCmdAutoProxy:RecvPhotoQueryListCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdPhotoQueryListCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvPhotoOptCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdPhotoOptCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvPhotoUpdateNtf(data) 
	self:Notify(ServiceEvent.PhotoCmdPhotoUpdateNtf, data)
end

function ServicePhotoCmdAutoProxy:RecvFrameActionPhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdFrameActionPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryFramePhotoListPhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryUserPhotoListPhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdQueryUserPhotoListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvUpdateFrameShowPhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvFramePhotoUpdatePhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdFramePhotoUpdatePhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryMd5ListPhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdQueryMd5ListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvAddMd5PhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdAddMd5PhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvRemoveMd5PhotoCmd(data) 
	self:Notify(ServiceEvent.PhotoCmdRemoveMd5PhotoCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.PhotoCmdPhotoQueryListCmd = "ServiceEvent_PhotoCmdPhotoQueryListCmd"
ServiceEvent.PhotoCmdPhotoOptCmd = "ServiceEvent_PhotoCmdPhotoOptCmd"
ServiceEvent.PhotoCmdPhotoUpdateNtf = "ServiceEvent_PhotoCmdPhotoUpdateNtf"
ServiceEvent.PhotoCmdFrameActionPhotoCmd = "ServiceEvent_PhotoCmdFrameActionPhotoCmd"
ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd = "ServiceEvent_PhotoCmdQueryFramePhotoListPhotoCmd"
ServiceEvent.PhotoCmdQueryUserPhotoListPhotoCmd = "ServiceEvent_PhotoCmdQueryUserPhotoListPhotoCmd"
ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd = "ServiceEvent_PhotoCmdUpdateFrameShowPhotoCmd"
ServiceEvent.PhotoCmdFramePhotoUpdatePhotoCmd = "ServiceEvent_PhotoCmdFramePhotoUpdatePhotoCmd"
ServiceEvent.PhotoCmdQueryMd5ListPhotoCmd = "ServiceEvent_PhotoCmdQueryMd5ListPhotoCmd"
ServiceEvent.PhotoCmdAddMd5PhotoCmd = "ServiceEvent_PhotoCmdAddMd5PhotoCmd"
ServiceEvent.PhotoCmdRemoveMd5PhotoCmd = "ServiceEvent_PhotoCmdRemoveMd5PhotoCmd"
