local baseCell = autoImport("BaseCell")
PersonalPictureCell = class("PersonalPictureCell", baseCell)

PersonalPictureCell.PhotoStatus = {
	UploadFailure = 1,
	CanReUploading = 2,
	Uploading = 3,
	DownloadFailure = 4,
	Success = 5,
	Downloading = 6,
}

function PersonalPictureCell:Init()
	PersonalPictureCell.super.Init(self);
	self:initView()
	self:initData()
	self:AddViewEvent();
end

function PersonalPictureCell:AddViewEvent(  )
	-- body
	local background = self:FindGO("background")
	self:AddClickEvent(background,function ( obj )
		-- body
		self:PassEvent(MouseEvent.MouseClick, self);
	end)

	self:AddCellClickEvent()
end

function PersonalPictureCell:initData(  )
	-- body
end

function PersonalPictureCell:initView(  )
	-- body
	self.errorCt = self:FindGO("errorCt")
	self.reUploadContainer = self:FindGO("reUploadContainer")
	self.delBtn = self:FindGO("delBtn")
	self:AddClickEvent(self.delBtn,function ( )
		-- body
		PersonalPictureManager.Instance():log("delBtn")
		self:PassEvent(PersonalPicturePanel.DelPersonPicThumbnail,self)
	end)
	self:AddClickEvent(self.reUploadContainer,function ( )
		-- body
		PersonalPictureManager.Instance():log("reUploadContainer")
		self.status = PersonalPictureCell.PhotoStatus.Uploading
		self:PassEvent(PersonalPicturePanel.ReUploadingPersonPicThumbnail,self)
		self:RefreshStatus()
	end)
	self.errorTip = self:FindComponent("errorTip",UILabel)
	self.errorTip.text = ZhString.PersonalPictureCell_PicLost
	self.pictureDesLabel = self:FindComponent("pictureDesLabel",UILabel)
	self.texture = self:FindGO("texture"):GetComponent(UITextureEx)
	self.textureCt = self:FindGO("textureCt")
	self.replaceSp = self:FindGO("replaceSp")
	self:AddClickEvent(self.replaceSp,function (  )
		-- body
		self:PassEvent(PersonalPicturePanel.ReplacePersonPicThumbnail,self)
	end)
	self.maskContainer = self:FindGO("maskContainer")
	self.maskSlider = self:FindGO("maskSlider"):GetComponent(UISlider)
	self.stateDes = self:FindComponent("stateDes",UILabel)
	self.cancelBtn = self:FindGO("cancelBtn")
	self:AddClickEvent(self.cancelBtn,function ( )
		-- body
		PersonalPictureManager.Instance():log("cancelBtn")
		self:PassEvent(PersonalPicturePanel.CancelPersonPicThumbnail,self)
	end)

--todo xde fix ui
	self.pictureDesLabel.fontSize = 14
	self.pictureDesLabel.overflowMethod = 3
	self.pictureDesLabel.width = 190
--	self.pictureDesLabel.pivot = 
end

function PersonalPictureCell:setMode( mode )
	-- body
	if(not self.data)then
		return
	end
	self.mode = mode
	self:RefreshStatus()
end

function PersonalPictureCell:RefreshStatus()
	if(not self.data)then
		return
	end
	if(self.mode == PersonalPicturePanel.ShowMode.NormalMode)then
		self:Hide(self.replaceSp)
		self:Hide(self.delBtn)
		if(self.status == PersonalPictureCell.PhotoStatus.Uploading)then
			self:Show(self.cancelBtn)
		else
			self:Hide(self.cancelBtn)
		end
	elseif(self.mode == PersonalPicturePanel.ShowMode.EditorMode)then
		self:Hide(self.replaceSp)
		self:Show(self.delBtn)
		self.Hide(self.cancelBtn)
	else
		self:Show(self.replaceSp)
		self:Hide(self.delBtn)
		self:Hide(self.cancelBtn)
	end

	if(self.status == PersonalPictureCell.PhotoStatus.Success)then
		self:Hide(self.errorCt)
		self:Hide(self.maskContainer)
	elseif(self.status == PersonalPictureCell.PhotoStatus.CanReUploading)then
		self:Hide(self.maskContainer)
		self:Show(self.errorCt)
		self:Hide(self.errorTip.gameObject)
		self:Show(self.reUploadContainer)
	elseif(self.status == PersonalPictureCell.PhotoStatus.UploadFailure)then
		self:Hide(self.maskContainer)
		self:Show(self.errorCt)
		self:Show(self.errorTip.gameObject)
		self:Hide(self.reUploadContainer)
	elseif(self.status == PersonalPictureCell.PhotoStatus.Uploading)then
		self.stateDes.text = ZhString.PersonalPictureCell_LoadingText
		self:Show(self.maskContainer)
		self:Hide(self.errorCt)
	elseif(self.status == PersonalPictureCell.PhotoStatus.Downloading)then
		self:Show(self.maskContainer)
		self.stateDes.text = ZhString.PersonalPictureCell_LoadingText
		self:Hide(self.errorCt)
		-- self:Show(self.errorTip.gameObject)
		-- self:Hide(self.reUploadContainer)
	elseif(self.status == PersonalPictureCell.PhotoStatus.DownloadFailure)then
		self:Hide(self.maskContainer)
		self:Show(self.errorCt)
		self:Show(self.errorTip.gameObject)
		self:Hide(self.reUploadContainer)
	end
end

function PersonalPictureCell:setDownloadProgress(progress)
	PersonalPictureManager.Instance():log("setDownloadProgress:",progress)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.stateDes.text = string.format(ZhString.PersonalPictureCell_Downloading,value)
end

function PersonalPictureCell:setDownloadFailure()
	PersonalPictureManager.Instance():log("setDownloadFailure:")
	self.status = PersonalPictureCell.PhotoStatus.DownloadFailure
	self:RefreshStatus()
end

function PersonalPictureCell:setUploadFailure()
	PersonalPictureManager.Instance():log("setUploadFailure:")
	self.status = PersonalPictureCell.PhotoStatus.CanReUploading
	self:RefreshStatus()
end

function PersonalPictureCell:setUploadSuccess()
	self.status = PersonalPictureCell.PhotoStatus.Success
	self:RefreshStatus()
end

function PersonalPictureCell:setUploadProgress(progress)
	PersonalPictureManager.Instance():log("setUploadProgress:",progress)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.stateDes.text = string.format(ZhString.PersonalPictureCell_Uploading,value)
end

function PersonalPictureCell:SetData(data)
	self.data = data
	if(not data)then
		self:Hide()
		return 
	end
	self:Show()
	local time = data.time or 0
	local timeStr = os.date("%Y.%m.%d",time)
	if(time == 0)then
		timeStr = ZhString.PersonalPictureCell_PictureDesNotime
	end
	local name = ""
	if(data.type == PhotoDataProxy.PhotoType.SceneryPhotoType)then
		name = Table_Viewspot[data.index] and Table_Viewspot[data.index].SpotName or data.mapid
	else
		name = Table_Map[data.mapid] and Table_Map[data.mapid].NameZh or data.mapid
	end
	self.pictureDesLabel.text = timeStr.."  "..name
	
	self:Hide(self.textureCt)

	if(data.type == PhotoDataProxy.PhotoType.PersonalPhotoType and PersonalPictureManager.Instance():isUpLoadFailure(data.index))then
		local isUpLoading = PersonalPictureManager.Instance():isUpLoading(data.index)
		local isCanReUpLoading = PersonalPictureManager.Instance():isCanReUpLoading(data.index,data.time)
		if(isUpLoading)then
			self:PassEvent(PersonalPicturePanel.GetPersonPicThumbnail,self)
			self.status = PersonalPictureCell.PhotoStatus.Uploading
		elseif(isCanReUpLoading)then
			self:PassEvent(PersonalPicturePanel.GetPersonPicThumbnail,self)
			self.status = PersonalPictureCell.PhotoStatus.CanReUploading
		else
			self.status = PersonalPictureCell.PhotoStatus.UploadFailure
		end
	else
		self.status = PersonalPictureCell.PhotoStatus.Downloading
		self:PassEvent(PersonalPicturePanel.GetPersonPicThumbnail,self)
	end
	self:RefreshStatus()
end

function PersonalPictureCell:setTexture( texture )
	-- body
	if(texture)then
		self:Show(self.textureCt)
		self.texture.mainTexture = texture
		if(self.status == PersonalPictureCell.PhotoStatus.Downloading)then
			self.status = PersonalPictureCell.PhotoStatus.Success
		end
	else
		-- if(self.status == PersonalPictureCell.PhotoStatus.Downloading)then
		-- 	self.status = PersonalPictureCell.PhotoStatus.DownloadFailure
		-- end
		self.status = PersonalPictureCell.PhotoStatus.DownloadFailure
	end
	self:RefreshStatus()
end

function PersonalPictureCell:OnExit(  )
	-- body
	self.super.OnExit(self)
end