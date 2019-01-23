MySceneryPictureManager = class("MySceneryPictureManager")
autoImport("ScenicSpotPhotoNew")
autoImport('ScenicSpotPhotoHelperNew')
function MySceneryPictureManager.Instance()
	if nil == MySceneryPictureManager.me then
		MySceneryPictureManager.me = MySceneryPictureManager.new()
	end
	return MySceneryPictureManager.me
end

function MySceneryPictureManager:ctor()

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

function MySceneryPictureManager:log( ... )
	-- body
	if(self.logEnable)then
		helplog(...)
	end
end

function MySceneryPictureManager:tryGetMySceneryThumbnail(roleId,index,time,isBelongAcc)
	self:log("tryGenThumbnail start!!!",roleId,index, time)
	self.isDownloading = true
	if(isBelongAcc)then
		ScenicSpotPhotoHelperNew.Ins():GetThumbnail_Roles(roleId,index,time,function ( progress )
				-- body
				self:MySceneryThumbnailProgressCallback(roleId,index,time,progress)
			end,function ( bytes)
				-- body
				self:log("tryGenThumbnail comple!!!",index, time)

				self:MySceneryThumbnailSusCallback(roleId,index,time,bytes)
			end,function ( errorMessage )
				-- body
				self:log("tryGenThumbnail error!!!",index, time)

				self:MySceneryThumbnailErrorCallback(roleId,index,time,errorMessage)
			end)
	else
		ScenicSpotPhotoHelperNew.Ins():GetThumbnail_Share(roleId,index,time,function ( progress )
				-- body
				self:MySceneryThumbnailProgressCallback(roleId,index,time,progress)
			end,function ( bytes)
				-- body
				self:log("tryGenThumbnail comple!!!",index, time)

				self:MySceneryThumbnailSusCallback(roleId,index,time,bytes)
			end,function ( errorMessage )
				-- body
				self:log("tryGenThumbnail error!!!",index, time)

				self:MySceneryThumbnailErrorCallback(roleId,index,time,errorMessage)
			end)
	end
end

function MySceneryPictureManager:AddMySceneryThumbnailInfos(list)
	if(list and #list > 0)then
		for i=1,#list do
			self:AddSingleMySceneryThumbnail(list[i])
		end
		self:startTryGetMySceneryThumbnail()
	end
end

function MySceneryPictureManager:AddSingleMySceneryThumbnail(data)
	
   local index = data.index
   local time = data.time
   local roleId = data.roleId
   local isBelongAcc = data:isBelongAcc()
   local texture = self:GetMySceneryThumbnailTextureById(roleId,index,time)
   if(not texture)then
   		local hasIn = self:HasInToBeDownload(roleId,index,time)
	   	if(not hasIn)then
	   		local loadData = {index = index,time = time,roleId = roleId,isBelongAcc = isBelongAcc}
	   		self.toBeDownload[#self.toBeDownload+1] = loadData
	   	end
   end
end

function MySceneryPictureManager:GetAdventureSceneryPicThumbnail( cell )
	local data = cell.data
	data = PhotoData.new(data,PhotoDataProxy.PhotoType.SceneryPhotoType)
	local index = data.index
	local time = data.time
	local roleId = data.roleId
	local texture = self:GetMySceneryThumbnailTextureById(roleId,index,time,true)
	self:log("GetAdventureSceneryPicThumbnai",index,time)
	if(texture)then		
		cell:setTexture(texture)
	else
		local hasIn = self:HasInToBeDownload(roleId,index,time)
	   	if(not hasIn)then
	   		local loadData = {index = index,time = time,roleId = roleId}
	   		self.toBeDownload[#self.toBeDownload+1] = loadData
	   		if(#self.toBeDownload>0)then
	   			self:startTryGetMySceneryThumbnail()
	   		end
	   	end
	end
end

function MySceneryPictureManager:GetMySceneryPicThumbnail( cell )
	-- body	
	local data = cell.data
	local index = data.index
	local time = data.time
	local roleId = data.roleId
	local isBelongAcc = data:isBelongAcc()
	self:log("MySceneryPictureManager:GetMySceneryPicThumbnail( cell )",index,time)
	local texture = self:GetMySceneryThumbnailTextureById(roleId,index,time,true)
	if(texture)then
		cell:setTexture(texture)
	else
		local hasIn = self:HasInToBeDownload(roleId,index,time)
	   	if(not hasIn)then
	   		local loadData = {index = index,time = time,roleId = roleId,isBelongAcc = isBelongAcc}
	   		self.toBeDownload[#self.toBeDownload+1] = loadData
	   		if(#self.toBeDownload>0)then
	   			self:startTryGetMySceneryThumbnail()
	   		end
	   	end
	end
end

function MySceneryPictureManager:HasInToBeDownload(roleId,index,time)
	for i=1,#self.toBeDownload do
		local single = self.toBeDownload[i]
		if(single.index == index and single.time == time and single.roleId == roleId)then
			return true
		end
	end
end

function MySceneryPictureManager:MySceneryThumbnailSusCallback(roleId,index,time,bytes)
	self:log("MyThumbnailSusCallback:",index,time)
	self.isDownloading = false
	local texture = Texture2D(2,2,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(texture, bytes)
	if(bRet)then
		self:addThumbnailTextureById(roleId,index,time,texture)
		self:removeOldTimeData(roleId,index,time)
		self:MySceneryThumbnailDownloadCompleteCallback1(roleId,index,time,bytes)
		self:removeDownloadTexture(roleId,index,time)
		self:startTryGetMySceneryThumbnail()
	else
		self:MySceneryThumbnailErrorCallback(roleId,index,time,"load LoadImage error!")
		Object.DestroyImmediate(texture)
	end
end

function MySceneryPictureManager:removeOldTimeData( roleId,index,time )
	-- body
	for i=1,#self.toBeDownload do
		local single = self.toBeDownload[i]
		if(single.index == index and single.roleId == roleId and single.time ~= time)then
			table.remove(self.toBeDownload,i)
			break
		end
	end

	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index and single.roleId == roleId and single.time ~= time)then
			local data = table.remove(self.LRUTextureCache,i)
			Object.DestroyImmediate(data.texture)
			break
		end
	end
end

function MySceneryPictureManager:MySceneryThumbnailErrorCallback(roleId,index,time,errorMessage)
	self:log("MySceneryThumbnailErrorCallback:",index,time,errorMessage)
	self.isDownloading = false
	self:removeDownloadTexture(roleId,index,time)
	self:MySceneryThumbnailDownloadErrorCallback1(roleId,index,time,errorMessage)
	self:startTryGetMySceneryThumbnail()
end

function MySceneryPictureManager:MySceneryThumbnailProgressCallback(roleId,index,time,progress)
	self:log("MySceneryThumbnailProgressCallback:",index,time,progress)
	self:MySceneryThumbnailDownloadProgressCallback1(roleId,index,time,progress)
end

function MySceneryPictureManager:startTryGetMySceneryThumbnail()
	if(#self.toBeDownload > 0 and not self.isDownloading)then
		local loadData =self.toBeDownload[1]
		self:tryGetMySceneryThumbnail(loadData.roleId,loadData.index,loadData.time,loadData.isBelongAcc)
	end
end

function MySceneryPictureManager:GetMySceneryThumbnailTextureById(roleId,index,time,rePos )
	-- body
	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(single.index == index and single.time == time and single.roleId == roleId)then
			if(rePos)then
				table.remove(self.LRUTextureCache,i)
				table.insert(self.LRUTextureCache,1,single)
			end
			return single.texture
		end
	end
end

function MySceneryPictureManager:addThumbnailTextureById(roleId,index,time,texture)
	-- body
	if(not self:GetMySceneryThumbnailTextureById(roleId,index,time))then
		if(#self.LRUTextureCache > self.maxCache)then
			local oldData = table.remove(self.LRUTextureCache)
			Object.DestroyImmediate(oldData.texture)
		end
		local data = {}
		data.index = index
		data.texture = texture
		data.time = time
		data.roleId = roleId
		table.insert(self.LRUTextureCache,1,data)
	else
		self:log("addThumbnailTextureById:exsit  index:",index)
	end
end

function MySceneryPictureManager:removeDownloadTexture(roleId,index,time)
	for j=1,#self.toBeDownload do
		local data = self.toBeDownload[j]
		if(index == data.index and time == data.time and data.roleId == roleId)then
			table.remove(self.toBeDownload,j)
			break
		end
	end
end

function MySceneryPictureManager:saveToPhotoAlbum( texture,index,time,anglez)
	self:log("saveToPhotoAlbum:",index,time,anglez)
	local bytes = ImageConversion.EncodeToJPG(texture)
	self.UploadingMap[index] = true

	local exsitData = AdventureDataProxy.Instance:GetSceneryData(index)
	local roleId
	if(exsitData)then
		roleId = exsitData.oldRoleId
	end

	local md5 = MyMD5.HashBytes(bytes);
	GamePhoto.SetPhotoFileMD5_Scenery(index, md5);
	local pbMd5 = PhotoCmd_pb.PhotoMd5()
	pbMd5.md5 = md5
	pbMd5.sourceid = index
	pbMd5.time = time
	pbMd5.source = ProtoCommon_pb.ESOURCE_PHOTO_SCENERY
	ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(pbMd5);

	ScenicSpotPhotoNew.Ins():Clear_Share(roleId,index)
	ScenicSpotPhotoNew.Ins():SaveAndUpload(roleId,index,bytes,time,function (progress)
		-- body
		self:log("Upload progress:",progress)
		self:MySceneryOriginUpProgressCallback1(index,time,progress)
	end, function ( bytes )
		-- body
		self:log("Upload sus:")
		self.UploadingMap[index] = false
		ServiceNUserProxy.Instance:CallUploadOkSceneryUserCmd(index,1,anglez,time)
		self:MySceneryOriginUpCompleteCallback1(index,time)
		if(AdventureDataProxy.Instance:IsSceneryUnlock(index))then
			MsgManager.ShowMsgByID(553)
		else
			local sceneData = Table_Viewspot[index]
			if(sceneData)then
				MsgManager.ShowMsgByIDTable(904, sceneData.SpotName)
			end
		end
		ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(pbMd5);
		-- local data = {sceneryid = index,anglez = anglez}
		-- FunctionScenicSpot.Me():InvalidateScenicSpot(data)

	end, function ( errorMessage )
		-- body
		self.UploadingMap[index] = false
		self:log("Upload error:",errorMessage)
		self:MySceneryOriginUpErrorCallback1(index,time,errorMessage)	
	end)
end

-- function MySceneryPictureManager:isUpLoadFailure( index )
-- 	local photoData = PhotoDataProxy.Instance:getPhotoDataByIndex(index)
-- 	if(not photoData.isupload)then
-- 		return true
-- 	end
-- end

function MySceneryPictureManager:isUpLoading( index )
	return self.UploadingMap[index] == true
end

function MySceneryPictureManager:isCanReUpLoading( index,time )
	-- local orignBytes = ScenicSpotPhotoNew.Ins():TryGetOriginImageFromLocal(index,time)
	-- if(orignBytes)then
	-- 	return true
	-- end
end

function MySceneryPictureManager:tryGetMySceneryOriginImage_Role(roleId, index,time )
	self:log("tryGetMySceneryOriginImage_Role:",roleId,index,time)
	ScenicSpotPhotoHelperNew.Ins():GetOriginImage_Roles(roleId,index,time,function ( progress )
		-- body
		self:MySceneryOriginPhotoDownloadProgressCallback1(roleId,index,time,progress)
	end,function ( bytes,timestamp )
		self:MySceneryOriginPhotoDownloadCompleteCallback1(roleId,index,time,bytes)
		-- body
	end,function ( errorMessage )
		-- body
		self:MySceneryOriginPhotoDownloadErrorCallback1(roleId,index,time,errorMessage)
	end)
end

function MySceneryPictureManager:tryGetMySceneryOriginImage(roleId, index,time )
	-- body
	self:log("tryGetMySceneryOriginImage:",index,time,roleId)
	ScenicSpotPhotoHelperNew.Ins():GetOriginImage_Share(roleId,index,time,function ( progress )
		-- body
		self:MySceneryOriginPhotoDownloadProgressCallback1(roleId,index,time,progress)
	end,function ( bytes,timestamp )
		self:MySceneryOriginPhotoDownloadCompleteCallback1(roleId,index,time,bytes)
		-- body
	end,function ( errorMessage )
		-- body
		self:MySceneryOriginPhotoDownloadErrorCallback1(roleId,index,time,errorMessage)
	end)
end

MySceneryPictureManager.MySceneryOriginUpProgressCallback = "MySceneryPictureManager_MySceneryOriginUpProgressCallback"
MySceneryPictureManager.MySceneryOriginUpCompleteCallback = "MySceneryPictureManager_MySceneryOriginUpCompleteCallback"
MySceneryPictureManager.MySceneryOriginUpErrorCallback = "MySceneryPictureManager_MySceneryOriginUpErrorCallback"

MySceneryPictureManager.MySceneryThumbnailDownloadProgressCallback = "MySceneryPictureManager_MySceneryThumbnailDownloadProgressCallback"
MySceneryPictureManager.MySceneryThumbnailDownloadCompleteCallback = "MySceneryPictureManager_MySceneryThumbnailDownloadCompleteCallback"
MySceneryPictureManager.MySceneryThumbnailDownloadErrorCallback = "MySceneryPictureManager_MySceneryThumbnailDownloadErrorCallback"

MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback = "MySceneryPictureManager_MySceneryOriginPhotoDownloadProgressCallback"
MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback = "MySceneryPictureManager_MySceneryOriginPhotoDownloadCompleteCallback"
MySceneryPictureManager.MySceneryOriginPhotoDownloadErrorCallback = "MySceneryPictureManager_MySceneryOriginPhotoDownloadErrorCallback"

--download thumbnail
function MySceneryPictureManager:MySceneryThumbnailDownloadProgressCallback1(roleId,index, time,progress )
	-- body
	self:log("MySceneryThumbnailDownloadProgressCallback",index, time,progress)
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryThumbnailDownloadProgressCallback,{roleId = roleId,index = index,time = time,progress = progress})
end

function MySceneryPictureManager:MySceneryThumbnailDownloadCompleteCallback1(roleId,index, time,bytes)
	-- body
	self:log("MySceneryThumbnailDownloadCompleteCallback",index, time,tostring(bytes))
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryThumbnailDownloadCompleteCallback,{roleId = roleId,index = index,time = time,byte = bytes})
end

function MySceneryPictureManager:MySceneryThumbnailDownloadErrorCallback1(roleId,index, time,errorMessage)
	-- body
	self:log("MySceneryThumbnailDownloadErrorCallback",index, time,errorMessage)
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryThumbnailDownloadErrorCallback,{roleId = roleId,index = index,time = time})
end

--download
function MySceneryPictureManager:MySceneryOriginPhotoDownloadProgressCallback1(roleId,index, time,progress )
	-- body
	self:log("MySceneryOriginPhotoDownloadProgressCallback",tostring(index), tostring(time),tostring(progress))
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback,{roleId = roleId,index = index,time = time,progress = progress})
end

function MySceneryPictureManager:MySceneryOriginPhotoDownloadCompleteCallback1(roleId,index, time,bytes)
	-- body
	self:log("MySceneryOriginPhotoDownloadCompleteCallback",index, time,bytes)
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback,{roleId = roleId,index = index,time = time,byte = bytes})
end

function MySceneryPictureManager:MySceneryOriginPhotoDownloadErrorCallback1(roleId,index, time,errorMessage)
	-- body
	self:log("MySceneryOriginPhotoDownloadErrorCallback",index, time,errorMessage)
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryOriginPhotoDownloadErrorCallback,{roleId = roleId,index = index,time = time})
end

--upload
function MySceneryPictureManager:MySceneryOriginUpProgressCallback1(index, time,progress )
	-- body
	self:log("MySceneryOriginUpProgressCallback",index, time,progress)
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryOriginUpProgressCallback,{index = index,time = time,progress = progress})
end

function MySceneryPictureManager:MySceneryOriginUpCompleteCallback1(index, time,bytes)
	-- body
	self:log("MySceneryOriginUpCompleteCallback",index, time,bytes)
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryOriginUpCompleteCallback,{index = index,time = time,byte = bytes})
end

function MySceneryPictureManager:MySceneryOriginUpErrorCallback1(index, time,errorMessage)
	-- body
	self:log("MySceneryOriginUpErrorCallback",index, time,errorMessage)
	GameFacade.Instance:sendNotification(MySceneryPictureManager.MySceneryOriginUpErrorCallback,{index = index,time = time})
end