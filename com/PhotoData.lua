PhotoData = class("PhotoData")

function PhotoData:ctor(serverData,type)
	--动态唯一标识id
	if(type == PhotoDataProxy.PhotoType.PersonalPhotoType)then
		self:updatePersonalPhoto(serverData)
	elseif(type == PhotoDataProxy.PhotoType.SceneryPhotoType)then
		self:updateMySceneryPhoto(serverData)
	else
		self:updateWallPhoto(serverData)
	end
	self.type = type
end

function PhotoData:setBelongAcc(b )
	self.isBelongAccPic = b
end

function PhotoData:isBelongAcc()
	return self.isBelongAccPic
end

function PhotoData:updateMySceneryPhoto(adventureData )
	self.index = adventureData.staticId
	self.roleId = adventureData.roleId
	self.charid = self.roleId
	self.time = adventureData.time or 0
	self.anglez = adventureData.anglez or 0
	self.sourceid = self.index
	self.source = ProtoCommon_pb.ESOURCE_PHOTO_SCENERY
	self.isMyself = true
end

function PhotoData:updateWallPhoto(serverData )
	self.index = serverData.index
	self.mapid = serverData.mapid
	self.time = serverData.time
	self.anglez = serverData.anglez
	self.charid = serverData.charid
	if(self.charid == Game.Myself.data.id)then
		self.isMyself = true
	end
	self.sourceid = serverData.sourceid
	self.source = serverData.source
	if(serverData.accid and serverData.accid ~= 0)then
		self.charid  = serverData.accid

		local loginData = FunctionLogin.Me():getLoginData()
		local account = loginData ~= nil and loginData.accid or 0
		
		if(self.charid == account)then
			self.isMyself = true
		end
		self.isBelongAccPic = true
	else
		self.isBelongAccPic = false
	end
end

function PhotoData:updatePersonalPhoto( serverData )
	-- body
	self.index = serverData.index
	self.mapid = serverData.mapid
	self.time = serverData.time
	self.isupload = serverData.isupload
	self.anglez = serverData.anglez
	self.sourceid = self.index
	self.source = ProtoCommon_pb.ESOURCE_PHOTO_SELF
	self.charid = serverData.charid
end