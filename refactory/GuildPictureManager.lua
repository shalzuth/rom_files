GuildPictureManager = class("GuildPictureManager")
autoImport("UnionLogo")
function GuildPictureManager.Instance()
	if nil == GuildPictureManager.me then
		GuildPictureManager.me = GuildPictureManager.new()
	end
	return GuildPictureManager.me
end

function GuildPictureManager:ctor()

	if(self.toBeDownload)then
		TableUtility.ArrayClear(self.toBeDownload)
	end
	self.toBeDownload = {}

	if(self.LRUTextureCache)then
		TableUtility.ArrayClear(self.LRUTextureCache)
	end
	self.LRUTextureCache = {}
	self.UploadingMap = {}
	self.maxCache = 50
	self.logEnable = false
	self.isDownloading = false
end

function GuildPictureManager:log( ... )
	-- body
	if(self.logEnable)then
		helplog(...)
	end
end

function GuildPictureManager:tryGetMyThumbnail(guild,callIndex,index,time,picType)

	self:log("GuildPictureManagertryGenThumbnail",guild,index, time)
	self.isDownloading = true
	UnionLogo.Ins():SetUnionID(guild)
	UnionLogo.Ins():GetThumbnail(callIndex,index,time,picType,function ( progress )
			-- body
			self:MyThumbnailProgressCallback(guild,callIndex,index,time,progress)
		end,function ( bytes)
			-- body
			self:MyThumbnailSusCallback(guild,callIndex,index,time,bytes)
		end,function ( errorMessage )
			-- body
			self:MyThumbnailErrorCallback(guild,callIndex,index,time,errorMessage)
		end)
end

function GuildPictureManager:AddMyThumbnailInfos(list)
	if(list and #list > 0)then
		for i=1,#list do
			self:AddSingleMyThumbnail(list[i])
		end
		self:startTryGetMyThumbnail()
	end
end

function GuildPictureManager:AddSingleMyThumbnail(data)
	
   local index = data.index
   local time = data.time
   local guild = data.guild
   local callIndex = data.callIndex
   local picType = data.picType
   local texture = self:GetThumbnailTextureById(guild,callIndex,index,time)
   if(not texture)then
   		local hasIn = self:HasInToBeDownload(guild,callIndex,index,time)
	   	if(not hasIn)then
	   		local loadData = {callIndex = callIndex,index = index,time = time,guild = guild,picType = picType}
	   		self.toBeDownload[#self.toBeDownload+1] = loadData
	    end
   end
end

function GuildPictureManager:HasInToBeDownload(guild,callIndex,index,time)
	for i=1,#self.toBeDownload do
		local single = self.toBeDownload[i]
		if(single.index == index and single.guild == guild and single.time == time and single.callIndex == callIndex)then
			return true
		end
	end
end

function GuildPictureManager:MyThumbnailSusCallback(guild,callIndex,index,time,bytes)
	self.isDownloading = false
	local texture = Texture2D(2,2,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(texture, bytes)
	if(bRet)then
		self:addThumbnailTextureById(guild,callIndex,index,time,texture)
		self:removeOldTimeData(guild,callIndex,index,time)
		self:ThumbnailDownloadCompleteCallback1(guild,callIndex,index,time,bytes)
		self:removeDownloadTexture(guild,callIndex,index,time)
		self:startTryGetMyThumbnail()
	else
		self:MyThumbnailErrorCallback(guild,callIndex,index,time,"load LoadImage error!")
		Object.DestroyImmediate(texture)
	end
end

function GuildPictureManager:removePhotoCache( guild,callIndex,index,time )
	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index and single.guild == guild and single.callIndex == callIndex)then
			local data = table.remove(self.LRUTextureCache,i)
			Object.DestroyImmediate(data.texture)
			break
		end
	end
end

function GuildPictureManager:removeOldTimeData(guild,callIndex,index,time )
	-- body
	for i=1,#self.toBeDownload do
		local single = self.toBeDownload[i]
		if(single.index == index and single.guild == guild and single.time ~= time and single.callIndex == callIndex)then
			table.remove(self.toBeDownload,i)
			break
		end
	end

	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index and single.guild == guild and single.time ~= time and single.callIndex == callIndex)then
			local data = table.remove(self.LRUTextureCache,i)
			Object.DestroyImmediate(data.texture)
			break
		end
	end
end

function GuildPictureManager:MyThumbnailErrorCallback(guild,callIndex,index,time,errorMessage)
	self.isDownloading = false
	self:removeDownloadTexture(guild,callIndex,index,time)
	self:ThumbnailDownloadErrorCallback1(guild,callIndex,index,time,errorMessage)
	self:startTryGetMyThumbnail()
end

function GuildPictureManager:MyThumbnailProgressCallback(guild,callIndex,index,time,progress)
	self:ThumbnailDownloadProgressCallback1(guild,callIndex,index,time,progress)
end

function GuildPictureManager:startTryGetMyThumbnail()
	if(#self.toBeDownload > 0 and not self.isDownloading)then
		local loadData = self.toBeDownload[1]
		self:tryGetMyThumbnail(loadData.guild,loadData.callIndex,loadData.index,loadData.time,loadData.picType)
	end
end

function GuildPictureManager:GetThumbnailTexture( guild,callIndex,index,time)
	-- body
	local texture = self:GetThumbnailTextureById(guild,callIndex,index,time,true)
	if(texture)then
		return texture
	end
end

function GuildPictureManager:GetThumbnailTextureById( guild,callIndex,index,time,rePos )
	-- body
	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index and single.guild == guild and single.time == time and callIndex == single.callIndex)then
			if(rePos)then
				table.remove(self.LRUTextureCache,i)
				table.insert(self.LRUTextureCache,1,single)
			end
			return single.texture
		end
	end
end

function GuildPictureManager:addThumbnailTextureById(guild,callIndex,index,time,texture)
	-- body
	if(not self:GetThumbnailTextureById(guild,callIndex,index,time))then
		if(#self.LRUTextureCache > self.maxCache)then
			local oldData = table.remove(self.LRUTextureCache)
			Object.DestroyImmediate(oldData.texture)
		end
		local data = {}
		data.index = index
		data.guild = guild
		data.texture = texture
		data.time = time
		data.callIndex = callIndex
		table.insert(self.LRUTextureCache,1,data)
	else
		self:log("addThumbnailTextureById:exsit  index:",index)
	end
end

function GuildPictureManager:removeDownloadTexture(guild,callIndex,index,time)
	for j=1,#self.toBeDownload do
		local data = self.toBeDownload[j]
		if(index == data.index and data.guild == guild and time == data.time and callIndex == data.callIndex)then
			table.remove(self.toBeDownload,j)
			break
		end
	end
end

-- function GuildPictureManager:isUpLoadFailure( index )
-- 	local photoData = PhotoDataProxy.Instance:getPhotoDataByIndex(index)
-- 	if(photoData and not photoData.isupload)then
-- 		return true
-- 	end
-- end

-- function GuildPictureManager:isUpLoading( guild,index )
-- 	return self.UploadingMap[index] == true
-- end

-- function GuildPictureManager:isCanReUpLoading( guild,index,time )
-- 	local exsit = UnionLogo.Ins():CheckExistOnLocal(index)
-- 	if(exsit)then
-- 		return true
-- 	end
-- end

-- function GuildPictureManager:removePhotoFromeAlbum( index ,time)
-- 	ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_REMOVE,index)
-- end

-- function GuildPictureManager:removeAndClearPhotoDataWhenDel( index,time )
-- 	self:removePhotoDataWhenDel(index,time)
-- 	UnionLogo.Ins():Clear(index)
-- end

-- function GuildPictureManager:removePhotoDataWhenDel(guild, index,time )
-- 	-- body
-- 	self:removeDownloadTexture(guild,index,time)
-- 	self:removeOldTimeData(guild,index,time)
-- 	self.UploadingMap[index] = false
-- 	self:removePhotoCache(guild,index,time)
-- end

-- function GuildPictureManager:saveToPhotoAlbum( texture,index,time )
-- 	local bytes = texture:EncodeToJPG(100)
-- 	self.UploadingMap[index] = true
-- 	UnionLogo.Ins():SaveAndUpload(index,bytes,time,function (progress)
-- 		-- body
-- 		self:log("Upload progress:",progress)
-- 		self:OriginPhotoUploadProgressCallback1(index,time,progress)
-- 	end, function ( bytes )
-- 		-- body
-- 		self:log("Upload sus:")
-- 		self.UploadingMap[index] = false
-- 		ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_UPLOAD,index)
-- 		self:OriginPhotoUploadCompleteCallback1(index,time)

-- 	end, function ( errorMessage )
-- 		-- body
-- 		self.UploadingMap[index] = false
-- 		self:log("Upload error:",errorMessage)
-- 		self:OriginPhotoUploadErrorCallback1(index,time,errorMessage)
-- 	end)
-- end

-- function GuildPictureManager:UploadPhoto( index,time )
-- 	-- body
-- 	self.UploadingMap[index] = true
-- 	UnionLogo.Ins():Upload(index,function (progress)
-- 		-- body
-- 		self:log("Upload progress:",progress)
-- 		self:OriginPhotoUploadProgressCallback1(index,time,progress)
-- 	end, function ( bytes )
-- 		-- body
-- 		self:log("Upload sus:")
-- 		self.UploadingMap[index] = false
-- 		ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_UPLOAD,index)
-- 		self:OriginPhotoUploadCompleteCallback1(index,time)

-- 	end, function ( errorMessage )
-- 		-- body
-- 		self.UploadingMap[index] = false
-- 		self:log("Upload error:",errorMessage)
-- 		self:OriginPhotoUploadErrorCallback1(index,time,errorMessage)
-- 	end)
-- end

-- function GuildPictureManager:tryGetOriginImage( index,time )
-- 	-- body
-- 	PhotoHelper.Ins():GetOriginImage(index,time,function ( progress )
-- 		-- body
-- 		self:OriginPhotoDownloadProgressCallback1(index,time,progress)
-- 	end,function ( bytes,timestamp )
-- 		self:OriginPhotoDownloadCompleteCallback1(index,time,bytes)
-- 		-- body
-- 	end,function ( errorMessage )
-- 		-- body
-- 		self:OriginPhotoDownloadErrorCallback1(index,time,errorMessage)
-- 	end)
-- end

GuildPictureManager.ThumbnailDownloadProgressCallback = "GuildPictureManager_ThumbnailDownloadProgressCallback"
GuildPictureManager.ThumbnailDownloadCompleteCallback = "GuildPictureManager_ThumbnailDownloadCompleteCallback"
GuildPictureManager.ThumbnailDownloadErrorCallback = "GuildPictureManager_ThumbnailDownloadErrorCallback"

GuildPictureManager.OriginPhotoDownloadProgressCallback = "GuildPictureManager_OriginPhotoDownloadProgressCallback"
GuildPictureManager.OriginPhotoDownloadCompleteCallback = "GuildPictureManager_OriginPhotoDownloadCompleteCallback"
GuildPictureManager.OriginPhotoDownloadErrorCallback = "GuildPictureManager_OriginPhotoDownloadErrorCallback"

GuildPictureManager.OriginPhotoUploadProgressCallback = "GuildPictureManager_OriginPhotoUploadProgressCallback"
GuildPictureManager.OriginPhotoUploadCompleteCallback = "GuildPictureManager_OriginPhotoUploadCompleteCallback"
GuildPictureManager.OriginPhotoUploadErrorCallback = "GuildPictureManager_OriginPhotoUploadErrorCallback"

--download thumbnail
function GuildPictureManager:ThumbnailDownloadProgressCallback1(guild,callIndex,index, time,progress )
	-- body
	self:log("GuildPictureManager ThumbnailDownloadProgressCallback",guild,index, time,progress)
	GameFacade.Instance:sendNotification(GuildPictureManager.ThumbnailDownloadProgressCallback,{callIndex = callIndex,guild = guild,index = index,time = time,progress = progress})
end

function GuildPictureManager:ThumbnailDownloadCompleteCallback1(guild,callIndex,index, time,bytes)
	-- body
	self:log("GuildPictureManager ThumbnailDownloadCompleteCallback",guild,index, time,tostring(bytes),type(index))
	local cdata = {callIndex = callIndex,guild = guild,index = index,time = time,byte = bytes};
	GameFacade.Instance:sendNotification(GuildPictureManager.ThumbnailDownloadCompleteCallback, cdata)
	EventManager.Me():PassEvent(GuildPictureManager.ThumbnailDownloadCompleteCallback, cdata);
end

function GuildPictureManager:ThumbnailDownloadErrorCallback1(guild,callIndex,index, time,errorMessage)
	-- body
	self:log("GuildPictureManager ThumbnailDownloadErrorCallback",guild,index, time,errorMessage)
	local cdata = {callIndex = callIndex,guild = guild,index = index,time = time};
	GameFacade.Instance:sendNotification(GuildPictureManager.ThumbnailDownloadErrorCallback, cdata)
	EventManager.Me():PassEvent(GuildPictureManager.ThumbnailDownloadErrorCallback, cdata);
end

-- --download
-- function GuildPictureManager:OriginPhotoDownloadProgressCallback1(index, time,progress )
-- 	-- body
-- 	self:log("OriginPhotoDownloadProgressCallback",index, time,progress)
-- 	GameFacade.Instance:sendNotification(GuildPictureManager.OriginPhotoDownloadProgressCallback,{index = index,time = time,progress = progress})
-- end

-- function GuildPictureManager:OriginPhotoDownloadCompleteCallback1(index, time,bytes)
-- 	-- body
-- 	self:log("OriginPhotoDownloadCompleteCallback",index, time,bytes)
-- 	GameFacade.Instance:sendNotification(GuildPictureManager.OriginPhotoDownloadCompleteCallback,{index = index,time = time,byte = bytes})
-- end

-- function GuildPictureManager:OriginPhotoDownloadErrorCallback1(index, time,errorMessage)
-- 	-- body
-- 	self:log("OriginPhotoDownloadErrorCallback",index, time,errorMessage)
-- 	GameFacade.Instance:sendNotification(GuildPictureManager.OriginPhotoDownloadErrorCallback,{index = index,time = time})
-- end

-- --upload
-- function GuildPictureManager:OriginPhotoUploadProgressCallback1(index, time,progress )
-- 	-- body
-- 	self:log("OriginPhotoUploadProgressCallback",index, time,progress)
-- 	GameFacade.Instance:sendNotification(GuildPictureManager.OriginPhotoUploadProgressCallback,{index = index,time = time,progress = progress})
-- end

-- function GuildPictureManager:OriginPhotoUploadCompleteCallback1(index, time)
-- 	-- body
-- 	self:log("OriginPhotoUploadCompleteCallback",index, time)
-- 	GameFacade.Instance:sendNotification(GuildPictureManager.OriginPhotoUploadCompleteCallback,{index = index,time = time})
-- end

-- function GuildPictureManager:OriginPhotoUploadErrorCallback1(index, time,errorMessage)
-- 	-- body
-- 	self:log("OriginPhotoUploadErrorCallback",index, time,errorMessage)
-- 	GameFacade.Instance:sendNotification(GuildPictureManager.OriginPhotoUploadErrorCallback,{index = index,time = time})
-- end