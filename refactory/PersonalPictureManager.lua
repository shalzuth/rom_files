PersonalPictureManager = class("PersonalPictureManager")
autoImport("PersonalPhoto")
autoImport("PersonalPhotoHelper")

function PersonalPictureManager.Instance()
	if nil == PersonalPictureManager.me then
		PersonalPictureManager.me = PersonalPictureManager.new()
	end
	return PersonalPictureManager.me
end

function PersonalPictureManager:ctor()

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

function PersonalPictureManager:log( ... )
	-- body
	if(self.logEnable)then
		helplog(...)
	end
end

function PersonalPictureManager:tryGetMyThumbnail(index,time)
	-- self:log("tryGenThumbnail",index, time)
	self.isDownloading = true
	PersonalPhotoHelper.Ins():GetThumbnail(index,time,function ( progress )
			-- body
			self:MyThumbnailProgressCallback(index,time,progress)
		end,function ( bytes)
			-- body
			self:MyThumbnailSusCallback(index,time,bytes)
		end,function ( errorMessage )
			-- body
			self:MyThumbnailErrorCallback(index,time,errorMessage)
		end)
end

function PersonalPictureManager:AddMyThumbnailInfos(list)
	if(list and #list > 0)then
		for i=1,#list do
			self:AddSingleMyThumbnail(list[i])
		end
		self:startTryGetMyThumbnail()
	end
end

function PersonalPictureManager:AddSingleMyThumbnail(data)
	
   local index = data.index
   local time = data.time
   local texture = self:GetThumbnailTextureById(index,time)
   if(not texture)then
   		local hasIn = self:HasInToBeDownload(index,time)
	   	if(not hasIn)then
	   		local loadData = {index = index,time = time}
	   		self.toBeDownload[#self.toBeDownload+1] = loadData
	    end
   end
end

function PersonalPictureManager:GetPersonPicThumbnail( cell )
	-- body	
	local data = cell.data
	local index = data.index
	local time = data.time
	local texture = self:GetThumbnailTextureById(index,time,true)
	if(texture)then
		cell:setTexture(texture)
	else
		local hasIn = self:HasInToBeDownload(index,time)
	   	if(not hasIn)then
	   		local loadData = {index = index,time = time}
	   		self.toBeDownload[#self.toBeDownload+1] = loadData
	   		if(#self.toBeDownload>0)then
	   			self:startTryGetMyThumbnail()
	   		end
	   	end
   end
end

function PersonalPictureManager:HasInToBeDownload(index,time)
	for i=1,#self.toBeDownload do
		local single = self.toBeDownload[i]
		if(single.index == index and single.time == time)then
			return true
		end
	end
end

function PersonalPictureManager:MyThumbnailSusCallback(index,time,bytes)
	self.isDownloading = false
	local texture = Texture2D(2,2,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(texture, bytes)
	if(bRet)then
		self:addThumbnailTextureById(index,time,texture)
		self:removeOldTimeData(index,time)
		self:PersonalThumbnailDownloadCompleteCallback1(index,time,bytes)
		self:removeDownloadTexture(index,time)
		self:startTryGetMyThumbnail()
	else
		self:MyThumbnailErrorCallback(index,time,"load LoadImage error!")
		Object.DestroyImmediate(texture)
	end
end

function PersonalPictureManager:removePhotoCache( index,time )
	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index)then
			local data = table.remove(self.LRUTextureCache,i)
			Object.DestroyImmediate(data.texture)
			break
		end
	end
end

function PersonalPictureManager:removeOldTimeData( index,time )
	-- body
	for i=1,#self.toBeDownload do
		local single = self.toBeDownload[i]
		if(single.index == index and single.time ~= time)then
			table.remove(self.toBeDownload,i)
			break
		end
	end

	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index and single.time ~= time)then
			local data = table.remove(self.LRUTextureCache,i)
			Object.DestroyImmediate(data.texture)
			break
		end
	end
end

function PersonalPictureManager:MyThumbnailErrorCallback(index,time,errorMessage)
	self.isDownloading = false
	self:removeDownloadTexture(index,time)
	self:PersonalThumbnailDownloadErrorCallback1(index,time,errorMessage)
	self:startTryGetMyThumbnail()
end

function PersonalPictureManager:MyThumbnailProgressCallback(index,time,progress)
	self:PersonalThumbnailDownloadProgressCallback1(index,time,progress)
end

function PersonalPictureManager:startTryGetMyThumbnail()
	if(#self.toBeDownload > 0 and not self.isDownloading)then
		local loadData = self.toBeDownload[1]
		self:tryGetMyThumbnail(loadData.index,loadData.time)
	end
end

function PersonalPictureManager:GetThumbnailTexture( index )
	-- body
	local texture = self:GetThumbnailTextureById(index,true)
	if(texture)then
		return texture
	end
end

function PersonalPictureManager:GetThumbnailTextureById( index,time,rePos )
	-- body
	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index and single.time == time)then
			if(rePos)then
				table.remove(self.LRUTextureCache,i)
				table.insert(self.LRUTextureCache,1,single)
			end
			return single.texture
		end
	end
end

function PersonalPictureManager:addThumbnailTextureById(index,time,texture)
	-- body
	if(not self:GetThumbnailTextureById(index,time))then
		if(#self.LRUTextureCache > self.maxCache)then
			local oldData = table.remove(self.LRUTextureCache)
			Object.DestroyImmediate(oldData.texture)
		end
		local data = {}
		data.index = index
		data.texture = texture
		data.time = time
		table.insert(self.LRUTextureCache,1,data)
	else
		self:log("addThumbnailTextureById:exsit  index:",index)
	end
end

function PersonalPictureManager:removeDownloadTexture(index,time)
	for j=1,#self.toBeDownload do
		local data = self.toBeDownload[j]
		if(index == data.index and time == data.time)then
			table.remove(self.toBeDownload,j)
			break
		end
	end
end

function PersonalPictureManager:saveToPhotoAlbum( texture,index,time )
	local bytes = ImageConversion.EncodeToJPG(texture)
	self.UploadingMap[index] = true

	local md5 = MyMD5.HashBytes(bytes);
	GamePhoto.SetPhotoFileMD5_Personal(index, md5);
	local pbMd5 = PhotoCmd_pb.PhotoMd5()
	pbMd5.md5 = md5
	pbMd5.sourceid = index
	pbMd5.time = time
	pbMd5.source = ProtoCommon_pb.ESOURCE_PHOTO_SELF
	ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(pbMd5);

	PersonalPhoto.Ins():SaveAndUpload(index,bytes,time,function (progress)
		-- body
		self:log("Upload progress:",progress)
		self:PersonalOriginPhotoUploadProgressCallback1(index,time,progress)
	end, function ( bytes )
		-- body
		self:log("Upload sus:")
		self.UploadingMap[index] = false
		ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_UPLOAD,index)
		self:PersonalOriginPhotoUploadCompleteCallback1(index,time)
		ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(pbMd5);
	end, function ( errorMessage )
		-- body
		self.UploadingMap[index] = false
		self:log("Upload error:",errorMessage)
		self:PersonalOriginPhotoUploadErrorCallback1(index,time,errorMessage)
	end)
end

function PersonalPictureManager:isUpLoadFailure( index )
	local photoData = PhotoDataProxy.Instance:getPhotoDataByIndex(index)
	if(photoData and not photoData.isupload)then
		return true
	end
end

function PersonalPictureManager:isUpLoading( index )
	return self.UploadingMap[index] == true
end

function PersonalPictureManager:isCanReUpLoading( index,time )
	local exsit = PersonalPhoto.Ins():CheckExistOnLocal(index)
	if(exsit)then
		return true
	end
end

function PersonalPictureManager:removePhotoFromeAlbum( index ,time)
	ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_REMOVE,index)
end

function PersonalPictureManager:removeAndClearPhotoDataWhenDel( index,time )
	self:removePhotoDataWhenDel(index,time)
	PersonalPhoto.Ins():Clear(index)
end

function PersonalPictureManager:removePhotoDataWhenDel( index,time )
	-- body
	self:removeDownloadTexture(index,time)
	self:removeOldTimeData(index,time)
	self.UploadingMap[index] = false
	self:removePhotoCache(index,time)
end

function PersonalPictureManager:UploadPhoto( index,time )
	-- body
	self.UploadingMap[index] = true
	PersonalPhoto.Ins():Upload(index,function (progress)
		-- body
		self:log("Upload progress:",progress)
		self:PersonalOriginPhotoUploadProgressCallback1(index,time,progress)
	end, function ( bytes )
		-- body
		self:log("Upload sus:")
		self.UploadingMap[index] = false
		ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_UPLOAD,index)
		self:PersonalOriginPhotoUploadCompleteCallback1(index,time)

	end, function ( errorMessage )
		-- body
		self.UploadingMap[index] = false
		self:log("Upload error:",errorMessage)
		self:PersonalOriginPhotoUploadErrorCallback1(index,time,errorMessage)
	end)
end

function PersonalPictureManager:tryGetOriginImage( index,time )
	-- body
	PersonalPhotoHelper.Ins():GetOriginImage(index,time,function ( progress )
		-- body
		self:PersonalOriginPhotoDownloadProgressCallback1(index,time,progress)
	end,function ( bytes,timestamp )
		self:PersonalOriginPhotoDownloadCompleteCallback1(index,time,bytes)
		-- body
	end,function ( errorMessage )
		-- body
		self:PersonalOriginPhotoDownloadErrorCallback1(index,time,errorMessage)
	end)
end

PersonalPictureManager.PersonalThumbnailDownloadProgressCallback = "PersonalPictureManager_PersonalThumbnailDownloadProgressCallback"
PersonalPictureManager.PersonalThumbnailDownloadCompleteCallback = "PersonalPictureManager_PersonalThumbnailDownloadCompleteCallback"
PersonalPictureManager.PersonalThumbnailDownloadErrorCallback = "PersonalPictureManager_PersonalThumbnailDownloadErrorCallback"

PersonalPictureManager.PersonalOriginPhotoDownloadProgressCallback = "PersonalPictureManager_PersonalOriginPhotoDownloadProgressCallback"
PersonalPictureManager.PersonalOriginPhotoDownloadCompleteCallback = "PersonalPictureManager_PersonalOriginPhotoDownloadCompleteCallback"
PersonalPictureManager.PersonalOriginPhotoDownloadErrorCallback = "PersonalPictureManager_PersonalOriginPhotoDownloadErrorCallback"

PersonalPictureManager.PersonalOriginPhotoUploadProgressCallback = "PersonalPictureManager_PersonalOriginPhotoUploadProgressCallback"
PersonalPictureManager.PersonalOriginPhotoUploadCompleteCallback = "PersonalPictureManager_PersonalOriginPhotoUploadCompleteCallback"
PersonalPictureManager.PersonalOriginPhotoUploadErrorCallback = "PersonalPictureManager_PersonalOriginPhotoUploadErrorCallback"

--download thumbnail
function PersonalPictureManager:PersonalThumbnailDownloadProgressCallback1(index, time,progress )
	-- body
	self:log("PersonalPictureManager PersonalThumbnailDownloadProgressCallback",index, time,progress)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalThumbnailDownloadProgressCallback,{index = index,time = time,progress = progress})
end

function PersonalPictureManager:PersonalThumbnailDownloadCompleteCallback1(index, time,bytes)
	-- body
	self:log("PersonalPictureManager PersonalThumbnailDownloadCompleteCallback",index, time,tostring(bytes),type(index))
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalThumbnailDownloadCompleteCallback,{index = index,time = time,byte = bytes})
end

function PersonalPictureManager:PersonalThumbnailDownloadErrorCallback1(index, time,errorMessage)
	-- body
	self:log("PersonalPictureManager PersonalThumbnailDownloadErrorCallback",index, time,errorMessage)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalThumbnailDownloadErrorCallback,{index = index,time = time})
end

--download
function PersonalPictureManager:PersonalOriginPhotoDownloadProgressCallback1(index, time,progress )
	-- body
	self:log("PersonalOriginPhotoDownloadProgressCallback",index, time,progress)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalOriginPhotoDownloadProgressCallback,{index = index,time = time,progress = progress})
end

function PersonalPictureManager:PersonalOriginPhotoDownloadCompleteCallback1(index, time,bytes)
	-- body
	self:log("PersonalOriginPhotoDownloadCompleteCallback",index, time,bytes)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalOriginPhotoDownloadCompleteCallback,{index = index,time = time,byte = bytes})
end

function PersonalPictureManager:PersonalOriginPhotoDownloadErrorCallback1(index, time,errorMessage)
	-- body
	self:log("PersonalOriginPhotoDownloadErrorCallback",index, time,errorMessage)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalOriginPhotoDownloadErrorCallback,{index = index,time = time})
end

--upload
function PersonalPictureManager:PersonalOriginPhotoUploadProgressCallback1(index, time,progress )
	-- body
	self:log("PersonalOriginPhotoUploadProgressCallback",index, time,progress)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalOriginPhotoUploadProgressCallback,{index = index,time = time,progress = progress})
end

function PersonalPictureManager:PersonalOriginPhotoUploadCompleteCallback1(index, time)
	-- body
	self:log("PersonalOriginPhotoUploadCompleteCallback",index, time)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalOriginPhotoUploadCompleteCallback,{index = index,time = time})
end

function PersonalPictureManager:PersonalOriginPhotoUploadErrorCallback1(index, time,errorMessage)
	-- body
	self:log("PersonalOriginPhotoUploadErrorCallback",index, time,errorMessage)
	GameFacade.Instance:sendNotification(PersonalPictureManager.PersonalOriginPhotoUploadErrorCallback,{index = index,time = time})
end