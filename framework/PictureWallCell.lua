local baseCell = autoImport("BaseCell")
PictureWallCell = class("PictureWallCell", baseCell)

PictureWallCell.PhotoStatus = {
	DownloadFailure = 4,
	Success = 5,
	Downloading = 6,
}

function PictureWallCell:Init()
	PictureWallCell.super.Init(self);
	self:initView()
	self:initData()
	self:AddViewEvent();
	self:AddCellClickEvent();
end

function PictureWallCell:AddViewEvent(  )
	-- body
end

function PictureWallCell:initData(  )
	-- body
end

function PictureWallCell:initView(  )
	-- body
	self.errorCt = self:FindGO("errorCt")	
	self.errorTip = self:FindComponent("errorTip",UILabel)
	self.errorTip.text = ZhString.PersonalPictureCell_PicLost
	self.pictureDesLabel = self:FindComponent("pictureDesLabel",UILabel)
	self.texture = self:FindGO("texture"):GetComponent(UITextureEx)
	self.textureCt = self:FindGO("textureCt")
	self.maskContainer = self:FindGO("maskContainer")
	self.stateDes = self:FindComponent("stateDes",UILabel)
	self.selectedBg = self:FindGO("selectedBg")
	self.star = self:FindGO("star")
	self.newTag = self:FindGO("newTag")
	self:Hide(self.newTag)
end

function PictureWallCell:setMode( mode )
	-- body
	if(not self.data)then
		return
	end
	self.mode = mode
	self:RefreshStatus()
end

function PictureWallCell:RefreshStatus()
	if(not self.data)then
		return
	end

	if(self.status == PictureWallCell.PhotoStatus.Success)then
		self:Hide(self.errorCt)
		self:Hide(self.maskContainer)
	elseif(self.status == PictureWallCell.PhotoStatus.Downloading)then
		self:Show(self.maskContainer)
		self.stateDes.text = ZhString.PersonalPictureCell_LoadingText
		self:Hide(self.errorCt)
	elseif(self.status == PictureWallCell.PhotoStatus.DownloadFailure)then
		self:Hide(self.maskContainer)
		self:Show(self.errorCt)
		self:Show(self.errorTip.gameObject)
	end
end

function PictureWallCell:setDownloadProgress(progress)
	PersonalPictureManager.Instance():log("setDownloadProgress:",progress)
	progress = progress >=1 and 1 or progress
	local value = progress*100
	value = math.floor(value)
	self.stateDes.text = string.format(ZhString.PersonalPictureCell_Downloading,value)
end

function PictureWallCell:setDownloadFailure()
	PersonalPictureManager.Instance():log("setDownloadFailure:")
	self.status = PictureWallCell.PhotoStatus.DownloadFailure
	self:RefreshStatus()
end

function PictureWallCell:SetData(data)
	self.data = data
	if(not data)then
		self:Hide()
		return 
	end
	self:Show()
	local timeStr = os.date("%Y.%m.%d",data.time)
	if(data.time == 0)then
		timeStr = ZhString.PersonalPictureCell_PictureDesNotime
	end
	local mapName = Table_Map[data.mapid] and Table_Map[data.mapid].NameZh or data.mapid
	self.pictureDesLabel.text = mapName
	-- self.pictureDesLabel.text = ""

	self.status = PictureWallCell.PhotoStatus.Downloading
	self:PassEvent(PictureDetailPanel.GetWallPicThumbnail,self)
	-- self:PassEvent(PictureDetailPanel.PictureDetailPanel.CheckCurrentShowPhoto ,self)
	if(self.data.isMyself)then
		self:Show(self.star)
	else
		self:Hide(self.star)
	end
	self:RefreshStatus()
	self:checkNewTag()
end

function PictureWallCell:IsCurrent( bRet )
	if(bRet)then
		self:Show(self.selectedBg)
	else
		self:Hide(self.selectedBg)
	end
end

function PictureWallCell:setTexture( texture )
	-- body
	if(texture)then
		self:Show(self.textureCt)
		self.texture.mainTexture = texture
		self.status = PictureWallCell.PhotoStatus.Success
	else
		self.status = PictureWallCell.PhotoStatus.DownloadFailure
	end
	self:RefreshStatus()
end

function PictureWallCell:OnExit(  )
	-- body
	self.super.OnExit(self)
end


function PictureWallCell:checkNewTag(  )
	local key = string.format(PictureDetailPanel.NewKeyTag,self.data.source,self.data.sourceid)
	local isNew = FunctionPlayerPrefs.Me():GetBool(key)
	if(isNew)then
		FunctionPlayerPrefs.Me():SetBool(key,false)
		self:Show(self.newTag)
	end
end