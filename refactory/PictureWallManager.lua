PictureWallManager = class("PictureWallManager")
autoImport("UnionWallPhotoNew")
autoImport("UnionWallPhotoHelper")
local tempVector3 = LuaVector3.zero
local dataArray = {}


--TODO: 本次刷新清除上一次同步的照片新
function PictureWallManager:Launch()
	if self.running then
		return
	end
	self.running = true

	
	if(self.serverDataArray)then
		TableUtility.ArrayClear(self.serverDataArray)
	end
	self.serverDataArray = {}

	if(self.TextureArray_ServerData)then
		TableUtility.ArrayClear(self.TextureArray_ServerData)
	end
	self.TextureArray_ServerData = {}

	if(self.toBeDownload)then
		TableUtility.ArrayClear(self.toBeDownload)
	end
	self.toBeDownload = {}

	if(self.delayDelArray)then
		TableUtility.ArrayClear(self.delayDelArray)
	end
	self.delayDelArray = {}

	if(self.LRUTextureCache)then
		TableUtility.ArrayClear(self.LRUTextureCache)
	end
	self.LRUTextureCache = {}
	self.maxCache = 7
	self.maxThumbnailSize = 100
	self.enableLog = false
	self.isDownloading = false
end

function PictureWallManager:log(...)
	if(self.enableLog)then
		helplog(...)
	end
end
function PictureWallManager:deleteTextureByPhotoData(photoData)
	for i=1,#self.TextureArray_ServerData do
		local single = self.TextureArray_ServerData[i]
		if(self:checkSamePicture(single.photoData,photoData))then
			table.remove(self.TextureArray_ServerData,i)
			Object.DestroyImmediate(single.texture)
			self:StopDownloadAndClean(photoData)
			-- self:StopDownloadOrigin(photoData)
			break
		end
	end
end

function PictureWallManager:removeDelayArray(frameId)
	for j=1,#self.delayDelArray do
		local single = self.delayDelArray[j]
		if(frameId == single.frameId)then
			-- self:log("removeDelayArray frameId:",frameId)
			Game.GameObjectManagers[Game.GameObjectType.ScenePhotoFrame]:SetPhoto(single.frameId, nil)
			self:removeDownloadTexture(single.photoData)
			self:removeBytesBySceneryId(single.photoData)
			table.remove(self.delayDelArray,j)
			break
		end
	end 
end

function PictureWallManager:StopDownloadAndClean( photoData)
	-- body
	if(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF)then
		UnionWallPhotoNew.Ins():Clear_Personal(photoData.charid,photoData.sourceid)
	elseif(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY)then
		if(photoData.isBelongAccPic)then
			UnionWallPhotoNew.Ins():Clear_ScenicSpot_Account(photoData.charid,photoData.sourceid)
		else
			UnionWallPhotoNew.Ins():Clear_ScenicSpot(photoData.charid,photoData.sourceid)
		end
	end
end

-- function PictureWallManager:StopDownloadOrigin( photoData)
-- 	-- body
-- 	if(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF)then
-- 	if(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF)then
-- 		UnionWallPhotoNew.Ins():StopDownloadOriginImage_Personal(photoData.charid,photoData.sourceid)
-- 	elseif(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY)then
-- 		UnionWallPhotoNew.Ins():StopDownloadOriginImage_ScenicSpot(photoData.charid,photoData.sourceid)
-- 	end
-- end

function PictureWallManager:checkIfDeleteThumbnail( photoData)
	
end

function PictureWallManager:GetBytes( photoData)
	-- body
	local bytes = self:GetBytesBySceneryId(photoData,true)
	if(bytes)then
		return bytes
	end
end

function PictureWallManager:GetBytesBySceneryId( photoData,rePos )
	-- body
	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(self:checkSamePicture(single.photoData,photoData))then
			if(rePos)then
				table.remove(self.LRUTextureCache,i)
				table.insert(self.LRUTextureCache,1,single)
			end
			return single.bytes
		end
	end
end

function PictureWallManager:removeBytesBySceneryId( photoData )
	-- body
	for i=1,#self.LRUTextureCache do
		local single = self.LRUTextureCache[i]
		if(self:checkSamePicture(single.photoData,photoData))then
			table.remove(self.LRUTextureCache,i)
			break
		end
	end
end

function PictureWallManager:addOriginBytesBySceneryId( photoData ,bytes)
	-- body
	if(not self:GetBytesBySceneryId(photoData))then
		if(#self.LRUTextureCache > self.maxCache)then
			table.remove(self.LRUTextureCache)
		end
		local data = {}
		data.photoData = photoData
		data.bytes = bytes
		table.insert(self.LRUTextureCache,1,data)
	else
		self:log("addOriginBytesBySceneryId:exsit ")
	end
end

function PictureWallManager:removeDownloadTexture(photoData)
	for j=1,#self.toBeDownload do
		local data = self.toBeDownload[j]
		if(self:checkSamePicture(photoData,data))then
			table.remove(self.toBeDownload,j)
			break
		end
	end
end

function PictureWallManager:checkSamePicture( exsitData,serverData )
	-- body
	if( exsitData and serverData)then
		if(exsitData.charid == serverData.charid and exsitData.sourceid == serverData.sourceid 
			and exsitData.source == serverData.source and exsitData.time == serverData.time )then
			return true
		end
	else
		self:log("checkSamePicture data is nil!!!!!!!!")
	end
end

function PictureWallManager:AddPictureInfos(list)
	-- list = {{charid = 4294992297,sceneryid = 14,frameid = 108},{charid = 4294992297,sceneryid = 55,frameid = 109}}
	local tempTable = {}
	for i=1,#self.serverDataArray do
		local single = self.serverDataArray[i]
		local find = false
		local delayDel = false
		local removeTexture = false
		for j=1,#list do
			local data = list[j]
			if(self:checkSamePicture(single.photoData,data.photo))then
				find = true
			elseif(single.photoData.charid == data.photo.charid and single.photoData.sourceid == data.photo.sourceid 
				and single.photoData.source == data.photo.source and single.photoData.time ~= data.photo.time )then
				removeTexture = true
			end

			if(single.frameId == data.frameid)then
				delayDel = true
			end
		end
		if(find)then
			-- self:log("exsitData",single.charId,single.sceneryId,single.frameId)
			tempTable[#tempTable+1] = single
			if(not delayDel)then
				Game.GameObjectManagers[Game.GameObjectType.ScenePhotoFrame]:SetPhoto(single.frameId, nil)
			end

		elseif(delayDel)then
			-- self:log("delayDelArray",single.charId,single.sceneryId,single.frameId)
			self.delayDelArray[#self.delayDelArray+1] = single
		else
			-- self:log("delete:",single.charId,single.sceneryId,single.frameId)
			Game.GameObjectManagers[Game.GameObjectType.ScenePhotoFrame]:SetPhoto(single.frameId, nil)
			self:removeDownloadTexture(single.photoData)
			self:removeBytesBySceneryId(single.photoData)
		end
		if(removeTexture)then
			self:deleteTextureByPhotoData(single.photoData)
		end
	end
	self.serverDataArray = tempTable
	for i=1,#list do
		self:AddPictureInfo(list[i])
	end
	self:startTryGenThumbnail()
end

function PictureWallManager:getServerData(photoData)
	for i=1,#self.serverDataArray do
		local single = self.serverDataArray[i]
		if(self:checkSamePicture(single.photoData,photoData))then
			return single
		end
	end
end

function PictureWallManager:getTextureByPhotoData(photoData,rePos)
	for i=1,#self.TextureArray_ServerData do
		local single = self.TextureArray_ServerData[i]
		if(self:checkSamePicture(single.photoData,photoData))then
			if(rePos)then
				table.remove(self.TextureArray_ServerData,i)
				table.insert(self.TextureArray_ServerData,1,single)
			end
			return single.texture
		end
	end
end

function PictureWallManager:getServerDataByFrameId(frameId)
	for i=1,#self.serverDataArray do
		local single = self.serverDataArray[i]
		if(single.frameId == frameId)then
			return single
		end
	end
end

function PictureWallManager:AddPictureInfo(serverData)
	-- local charId = tonumber(data.charid)
 --    local sceneryId = tonumber(data.sceneryid)
    local frameId = tonumber(serverData.frameid)
	self:log("AddPictureInfo",frameId,serverData.photo.sourceid,serverData.photo.source,serverData.photo.time,serverData.photo.anglez)
    self:log(serverData.photo.charid,serverData.photo.accid)
    if(frameId == 0)then
    	return
    end
    local exsitData = self:getServerData(serverData.photo)
	if(exsitData)then
		if(frameId == exsitData.frameId)then
			self:trySetThumbnailTexture(exsitData.photoData)
			return
		else
			exsitData.frameId = frameId
		end
    	self:trySetThumbnailTexture(exsitData.photoData)
    else
    	local photoData = PhotoData.new(serverData.photo)
	    local data = {photoData = photoData,frameId= frameId}
		self.serverDataArray[#self.serverDataArray+1] = data
		self:trySetThumbnailTexture(photoData)
    end
end

function PictureWallManager:GetPicThumbnailByCell( cell)
	-- body	
	local data = cell.data
	local index = data.index
	local time = data.time
	local texture = self:getTextureByPhotoData(data,true)
	if(texture)then
		cell:setTexture(texture)
	else
		local hasIn = self:HasInToBeDownload(data)
	   	if(not hasIn)then
	   		self.toBeDownload[#self.toBeDownload+1] = data
	   		-- todo xde 不再下载工会图片
	   		-- printData('工会图片数据', data)
	   		TableUtility.ArrayClear(self.toBeDownload)
	   		if(#self.toBeDownload>0)then
	   			self:startTryGenThumbnail()
	   		end
	   	end
	end
end

function PictureWallManager:HasInToBeDownload(photoData)
	for i=1,#self.toBeDownload do
		local single = self.toBeDownload[i]
		if(self:checkSamePicture(single,photoData))then
			return true
		end
	end
end

function PictureWallManager:trySetThumbnailTexture( photoData)
	-- body
	local texture = self:getTextureByPhotoData(photoData,true)
	if(texture)then
		self:trySetScenePhoto(photoData,texture)
	else
		local exsit = false
		for i=1,#self.toBeDownload do
			local single = self.toBeDownload[i]
			if(self:checkSamePicture(photoData,single))then
				exsit = true
				break
			end
		end
		if(not exsit)then
			self.toBeDownload[#self.toBeDownload+1] = photoData
			-- todo xde 不再下载工会图片
			-- printData('工会图片数据', photoData)
			TableUtility.ArrayClear(self.toBeDownload)
		end
	end
end

function PictureWallManager:addTextureByPhotoData( photoData,texture)
	-- body

	if(not self:getTextureByPhotoData(photoData))then
		if(#self.TextureArray_ServerData > self.maxThumbnailSize)then
			local textureData = table.remove(self.TextureArray_ServerData)
			Object.DestroyImmediate(textureData.texture)
		end
		local data = {}
		data.photoData = photoData
		data.texture = texture
		table.insert(self.TextureArray_ServerData,1,data)
	else
		self:log("addTextureByPhotoData:exsit ")
	end
end

function PictureWallManager:startTryGenThumbnail()
	if(#self.toBeDownload > 0 and not self.isDownloading)then
		local loadData = self.toBeDownload[1]
		self:tryGenThumbnail(loadData)
	end
end

function PictureWallManager:tryGenThumbnail(photoData)
	self:log("tryGenThumbnail",photoData.charid,photoData.sourceid,photoData.time)
	self.isDownloading = true
	if(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF)then
		UnionWallPhotoHelper.Ins():GetThumbnail_Personal(photoData.charid,photoData.sourceid,photoData.time,function ( progress )
			-- body
			self:thumbnailProgressCallback(photoData,progress)
			
		end,function ( bytes )
			self:thumbnailCompleteCallback(photoData,bytes)
			-- body
		end,function ( errorMessage )
			-- body
			self:thumbnailErrorCallback(photoData,errorMessage)
		end)
	elseif(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY)then
		if(photoData.isBelongAccPic)then
			UnionWallPhotoHelper.Ins():GetThumbnail_ScenicSpot_Account(photoData.charid,photoData.sourceid,photoData.time,function ( progress )
				-- body
				self:thumbnailProgressCallback(photoData,progress)
				
			end,function ( bytes )
				self:thumbnailCompleteCallback(photoData,bytes)
				-- body
			end,function ( errorMessage )
				-- body
				self:thumbnailErrorCallback(photoData,errorMessage)
			end)
		else
			UnionWallPhotoHelper.Ins():GetThumbnail_ScenicSpot(photoData.charid,photoData.sourceid,photoData.time,function ( progress )
				-- body
				self:thumbnailProgressCallback(photoData,progress)
				
			end,function ( bytes )
				self:thumbnailCompleteCallback(photoData,bytes)
				-- body
			end,function ( errorMessage )
				-- body
				self:thumbnailErrorCallback(photoData,errorMessage)
			end)
		end
	else
		self:log("unknown source")
	end	
end

function PictureWallManager:thumbnailProgressCallback(photoData,progress )
	self:log("thumbnailProgressCallback",charId, sceneryId,progress)
	self:WallPicThumbnailDownloadProgressCallback1(photoData,progress)
end

function PictureWallManager:thumbnailErrorCallback(photoData,errorMessage)
	-- body
	self.isDownloading = false
	self:removeDownloadTexture(photoData)
	self:log("thumbnailErrorCallback",photoData.charid, errorMessage)
	local serverData = self:getServerData(photoData)
	if(serverData and serverData.frameId)then
		self:removeDelayArray(serverData.frameId)
	end
	self:WallPicThumbnailDownloadErrorCallback1(photoData,errorMessage)
	self:startTryGenThumbnail()
end

function PictureWallManager:thumbnailCompleteCallback(photoData, bytes)
	-- body
	self:log("thumbnailCompleteCallback:",charId,sceneryId)
	self.isDownloading = false
	local serverData = self:getServerData(photoData)
	if(serverData and serverData.frameId)then
		self:removeDelayArray(serverData.frameId)
	end
	local texture = Texture2D(200,100,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(texture, bytes)
	if(bRet)then
		self:trySetScenePhoto(photoData,texture)
		self:addTextureByPhotoData(photoData,texture)
		self:WallPicThumbnailDownloadCompleteCallback1(photoData,bytes)
		self:removeDownloadTexture(photoData)
		self:startTryGenThumbnail()
	else
		self:thumbnailErrorCallback(photoData,"load LoadImage error!")
		Object.DestroyImmediate(texture)		
	end	
end

function PictureWallManager:trySetScenePhoto(photoData, texture)
	local serverData = self:getServerData(photoData)
	if(serverData and serverData.frameId)then
		-- self:log("GameObjectManagers:trySetScenePhoto sus",serverData.frameId,texture,texture.width,texture.height,serverData.anglez)
		-- self:log("GameObjectManagers:trySetScenePhoto sus",texture.width,texture.height)
		Game.GameObjectManagers[Game.GameObjectType.ScenePhotoFrame]:SetPhoto(serverData.frameId, texture, texture.width, texture.height,photoData.anglez)
	else
		-- self:log("GameObjectManagers:trySetScenePhoto noData")
	end
end

function PictureWallManager:tryGetOriginImage( photoData )
	-- body
	self:log("tryGetOriginImage",photoData.charid, photoData.sourceid,progress)
	if(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF)then
		UnionWallPhotoHelper.Ins():GetOriginImage_Personal(photoData.charid,photoData.sourceid,photoData.time,function ( progress )
			-- body
			self:originProgressCallback(photoData,progress)
			
		end,function ( bytes )
			self:originCompleteCallback(photoData,bytes)
			-- body
		end,function ( errorMessage )
			-- body
			self:originErrorCallback(photoData,errorMessage)
		end)
	elseif(photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY)then
		if(photoData.isBelongAccPic)then
			UnionWallPhotoHelper.Ins():GetOriginImage_ScenicSpot_Account(photoData.charid,photoData.sourceid,photoData.time,function ( progress )
				-- body
				self:originProgressCallback(photoData,progress)
				
			end,function ( bytes )

				self:originCompleteCallback(photoData,bytes)
				-- body
			end,function ( errorMessage )
				-- body

				self:originErrorCallback(photoData,errorMessage)
			end)
		else
			UnionWallPhotoHelper.Ins():GetOriginImage_ScenicSpot(photoData.charid,photoData.sourceid,photoData.time,function ( progress )
				-- body
				self:originProgressCallback(photoData,progress)
				
			end,function ( bytes )

				self:originCompleteCallback(photoData,bytes)
				-- body
			end,function ( errorMessage )
				-- body

				self:originErrorCallback(photoData,errorMessage)
			end)
		end
	else
		self:log("tryGetOriginImage unknown source")
	end
end

function PictureWallManager:originProgressCallback(photoData,progress )
	-- body
	self:log("originProgressCallback",photoData.charid, photoData.sourceid,progress)
	GameFacade.Instance:sendNotification(PictureWallDataEvent.PhotoProgressCallback,{photoData = photoData,progress = progress})
end

function PictureWallManager:originCompleteCallback(photoData,bytes)
	-- body
	self:log("originCompleteCallback",photoData.charid, photoData.sourceid,tostring(bytes))
	GameFacade.Instance:sendNotification(PictureWallDataEvent.PhotoCompleteCallback,{photoData = photoData,byte = bytes})
end

function PictureWallManager:originErrorCallback(photoData,errorMessage)
	-- body
	self:log("originErrorCallback",photoData.charid,photoData.sourceid,errorMessage)
end

function PictureWallManager:Shutdown()
	GameFacade.Instance:sendNotification(PictureWallDataEvent.MapEnd)
	if not self.running then
		return
	end
	self.running = false
	self:_DestroyDatas()
end

function PictureWallManager:_DestroyDatas()

	for i=1,#self.TextureArray_ServerData do
		local single = self.TextureArray_ServerData[i]
		if(single and single.texture)then
			Object.DestroyImmediate(single.texture)
		end
	end

	TableUtility.ArrayClear(self.TextureArray_ServerData)
	TableUtility.ArrayClear(self.serverDataArray)
	TableUtility.ArrayClear(self.delayDelArray)
	TableUtility.ArrayClear(self.toBeDownload)
	TableUtility.ArrayClear(self.LRUTextureCache)
	PhotoDataProxy.Instance:clearToSeeDatas()
	PhotoDataProxy.Instance:clearSelectedData()
	PhotoDataProxy.Instance:clearRemoveData()
	PhotoDataProxy.Instance:clearUpPhotos()
	PhotoDataProxy.Instance:clearCurFrameList()
end

function PictureWallManager:ShowDetailPicure(frameId,frameObj)
	-- todo xde 不再显示照片墙
	do return end
	-- local
	local serverData = self:getServerDataByFrameId(frameId)
	local viewData = {view = PanelConfig.PictureDetailPanel,viewdata = {serverData = serverData,frameId = frameId,trans = frameObj.transform}}
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel,viewData)
end

function PictureWallManager:ClickFrame(frameId,frameObj)
	self:ShowDetailPicure(frameId,frameObj)
end

PictureWallManager.WallPicThumbnailDownloadProgressCallback = "PictureWallManager_WallPicThumbnailDownloadProgressCallback"
PictureWallManager.WallPicThumbnailDownloadCompleteCallback = "PictureWallManager_WallPicThumbnailDownloadCompleteCallback"
PictureWallManager.WallPicThumbnailDownloadErrorCallback = "PictureWallManager_WallPicThumbnailDownloadErrorCallback"

--download thumbnail
function PictureWallManager:WallPicThumbnailDownloadProgressCallback1(photoData,progress )
	-- body
	self:log("WallPicThumbnailDownloadProgressCallback",index, time,progress)
	GameFacade.Instance:sendNotification(PictureWallManager.WallPicThumbnailDownloadProgressCallback,{photoData = photoData,progress = progress})
end

function PictureWallManager:WallPicThumbnailDownloadCompleteCallback1(photoData,bytes)
	-- body
	self:log("WallPicThumbnailDownloadCompleteCallback",index, time,tostring(bytes))
	GameFacade.Instance:sendNotification(PictureWallManager.WallPicThumbnailDownloadCompleteCallback,{photoData = photoData,byte = bytes})
end

function PictureWallManager:WallPicThumbnailDownloadErrorCallback1(photoData,errorMessage)
	-- body
	self:log("WallPicThumbnailDownloadErrorCallback",index, time,errorMessage)
	GameFacade.Instance:sendNotification(PictureWallManager.WallPicThumbnailDownloadErrorCallback,{photoData = photoData,errorMessage = errorMessage})
end