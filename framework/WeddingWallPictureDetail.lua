autoImport("PictureDetailPanel")
WeddingWallPictureDetail = class("WeddingWallPictureDetail", PictureDetailPanel)
WeddingWallPictureDetail.ViewType = UIViewType.NormalLayer
autoImport("PictureWallCell")
local tempVector3 = LuaVector3.zero
local tempRot = LuaQuaternion.identity
WeddingWallPictureDetail.NewKeyTag = "WeddingWallPictureDetail_NewKeyTag_%s_%s"
WeddingWallPictureDetail.CheckCurrentShowPhoto = "WeddingWallPictureDetail_CheckCurrentShowPhoto"
function WeddingWallPictureDetail:Init()
  self:AddViewEvts()
  self:initView()
  self:initData()
  self:requestFrameData()
end
function WeddingWallPictureDetail:requestFrameData()
  ServicePhotoCmdProxy.Instance:CallQueryFramePhotoListPhotoCmd(self.frameId)
end
function WeddingWallPictureDetail:AddViewEvts()
  self:AddListenEvt(PictureWallDataEvent.MapEnd, self.MapEnd)
  self:AddListenEvt(PictureWallDataEvent.ShowRedTip, self.ShowRedTip)
  self:AddListenEvt(ServiceEvent.PhotoCmdFrameActionPhotoCmd, self.PhotoCmdFrameActionPhotoCmd)
  self:AddListenEvt(ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd, self.UpdateCurPhoto)
  self:AddListenEvt(ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd, self.HandleQueryFramePhotoList)
  self:AddListenEvt(WeddingWallPicManager.WallPicOriginDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(WeddingWallPicManager.WallPicOriginDownloadProgressCallback, self.photoProgressCallback)
  self:AddListenEvt(WeddingWallPicManager.WallPicThumbnailDownloadProgressCallback, self.WallhumbnailPhDlPgCallback)
  self:AddListenEvt(WeddingWallPicManager.WallPicThumbnailDownloadCompleteCallback, self.WallThumbnailPhDlCpCallback)
  self:AddListenEvt(WeddingWallPicManager.WallPicThumbnailDownloadErrorCallback, self.WallThumbnailPhDlErCallback)
end
function WeddingWallPictureDetail:WallhumbnailPhDlPgCallback(note)
  local data = note.body
  local cell = self:GetItemCellById(data.photoData)
  if cell then
    cell:setDownloadProgress(data.progress)
  end
end
function WeddingWallPictureDetail:WallThumbnailPhDlCpCallback(note)
  local data = note.body
  local cell = self:GetItemCellById(data.photoData)
  if cell then
    self:GetWallPicThumbnail(cell)
  end
end
function WeddingWallPictureDetail:WallThumbnailPhDlErCallback(note)
  local data = note.body
  local cell = self:GetItemCellById(data.photoData)
  if cell then
    cell:setDownloadFailure()
  end
end
function WeddingWallPictureDetail:ShowRedTip(note)
  local size = note.body
  if size > 0 then
    self:Show(self.redTip)
    self:ShowMsgAnim(note.body)
  else
    self:Hide(self.redTip)
  end
end
function WeddingWallPictureDetail:GetUploadSusPicture()
  return 0
end
function WeddingWallPictureDetail:ShowMsgAnim(count)
end
function WeddingWallPictureDetail:PhotoCmdFrameActionPhotoCmd(note)
  self:requestFrameData()
end
function WeddingWallPictureDetail:UpdateCurPhoto()
  local serverData = Game.WeddingWallPicManager:getServerDataByFrameId(self.frameId)
  if serverData then
    if self.serverData and Game.WeddingWallPicManager:checkSamePicture(self.serverData.photoData, serverData.photoData) then
      return
    end
    self.serverData = serverData
    local photoData = self.serverData.photoData
    self.anglez = photoData.anglez
    self:getPhoto()
  else
    local texture = self.photo.mainTexture
    self.photo.mainTexture = nil
    Object.DestroyImmediate(texture)
  end
end
function WeddingWallPictureDetail:HandleQueryFramePhotoList(note)
  local data = note.body
  local list = {}
  if data and data.frameid == self.frameId then
    local photos = data.photos
    for i = 1, #photos do
      local single = photos[i]
      local photoData = PhotoData.new(single)
      list[#list + 1] = photoData
    end
  end
  self:SetData(list)
  if #list > 0 and self.firstActivie then
    self.firstActivie = false
    self.switchCtPlay:Play(true)
  end
end
function WeddingWallPictureDetail:changePhotoSize()
  local frameData = Table_ScenePhotoFrame[self.frameId]
  local dir = 0
  if frameData then
    dir = frameData.Dir
  end
  if dir == 1 then
    self.photo.width = 400
    self.photo.height = 600
  end
end
function WeddingWallPictureDetail:photoCompleteCallback(note)
  local data = note.body
  Game.WeddingWallPicManager:log("WeddingWallPictureDetail:photoCompleteCallback", data.photoData.sourceid, data.photoData.source, data.photoData.charid)
  Game.WeddingWallPicManager:log("WeddingWallPictureDetail:photoCompleteCallback", self.serverData.photoData.sourceid, self.serverData.photoData.source, self.serverData.photoData.charid)
  Game.WeddingWallPicManager:log("WeddingWallPictureDetail:photoCompleteCallback", self.serverData.photoData.time, data.photoData.time)
  if self.serverData and Game.WeddingWallPicManager:checkSamePicture(data.photoData, self.serverData.photoData) then
    self:completeCallback(data.byte)
  end
end
function WeddingWallPictureDetail:photoProgressCallback(note)
  local data = note.body
  if self.serverData and Game.WeddingWallPicManager:checkSamePicture(data.photoData, self.serverData.photoData) then
    self:progressCallback(data.progress)
  end
end
function WeddingWallPictureDetail:showAnim()
  tempVector3:Set(0, 0, 0)
  self.gameObject.transform.localScale = tempVector3
  local sceneryData = self.viewdata.viewdata.serverData
  local trans = self.viewdata.viewdata.trans
  local gm = NGUIUtil:GetCameraByLayername("Default")
  local x, y = LuaGameObject.WorldToViewportPointByTransform(gm, trans.transform, Space.World)
  x = 1280 * (x - 0.5)
  y = 720 * (y - 0.5)
  tempVector3:Set(x, y, 0)
  local tweenPosition = self.gameObject:GetComponent(TweenPosition)
  local play = self.gameObject:GetComponent(UIPlayTween)
  tweenPosition.from = tempVector3
  self.gameObject.transform.localPosition = tempVector3
  EventDelegate.Set(play.onFinished, function()
    self:showOtherUI()
  end)
  play:Play(true)
end
function WeddingWallPictureDetail:showOtherUI()
  self:Show(self.leftSliderCt)
  self:Show(self.UpdateCt)
  self:Hide(self.scrollView)
  self:Show(self.scrollView)
  if PhotoDataProxy.Instance:checkWeddingWallSyncPermission() then
    self:Show(self.UpdateCt)
  else
    self:Hide(self.UpdateCt)
  end
end
function WeddingWallPictureDetail:MapEnd(note)
  self:CloseSelf()
end
function WeddingWallPictureDetail:OnEnter()
  self:showAnim()
  if self.photo then
    PictureManager.Instance:SetWedding("Wedding_Photo", self.photo)
  end
end
function WeddingWallPictureDetail:initData()
  self:initDefaultTextureSize()
  self.serverData = self.viewdata.viewdata.serverData
  self.frameId = self.viewdata.viewdata.frameId
  if self.serverData and self.serverData.photoData then
    local photoData = self.serverData.photoData
    self.anglez = photoData.anglez
    self.isThumbnail = false
  else
    self:changePhotoSize()
  end
  LeanTween.cancel(self.gameObject)
  LeanTween.delayedCall(self.gameObject, 0.1, function()
    self:getPhoto()
  end)
  self.firstActivie = true
  self.firstSetTexture = true
end
function WeddingWallPictureDetail:ScrollViewRevert(callback)
  self.revertCallBack = callback
  self.scrollView:Revert()
end
function WeddingWallPictureDetail:initView()
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  function self.scrollView.OnStop()
    self:ScrollViewRevert()
  end
  self.photo = self:FindGO("photo"):GetComponent(UITexture)
  self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
  self:Hide(self.progress.gameObject)
  self.leftSlider = self:FindComponent("leftSlider", TweenPosition)
  self.leftSliderCt = self:FindGO("leftSliderCt")
  self.UpdateCt = self:FindGO("UpdateCt")
  self.frameSizeLabel = self:FindComponent("frameSizeLabel", UILabel)
  self.redTip = self:FindGO("redTip")
  self.PhotoCt = self:FindGO("PhotoCt")
  self:Hide(self.redTip)
  self:Hide(self.leftSliderCt)
  self:Hide(self.UpdateCt)
  self.SusMsg = self:FindComponent("SusMsg", UILabel)
  self:Hide(self.SusMsg.gameObject)
  self.switchCtPlay = self:FindComponent("switchCt", UIPlayTween)
  local itemContainer = self:FindGO("bag_itemContainer")
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 6,
    cellName = "PictureWallCell",
    control = PictureWallCell,
    dir = 1
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(PictureDetailPanel.GetWallPicThumbnail, self.GetWallPicThumbnail, self)
  self:AddClickEvent(self.UpdateCt, function()
    if PhotoDataProxy.Instance:checkWeddingWallSyncPermission() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PicutureWallSyncPanel,
        viewdata = {
          frameId = self.frameId,
          from = PicutureWallSyncPanel.PictureSyncFrom.WeddingWall
        }
      })
      self:Hide(self.SusMsg.gameObject)
      self:Hide(self.redTip)
      PhotoDataProxy.Instance:clearToSeeDatas()
    else
      MsgManager.ShowMsgByIDTable(3643)
    end
  end)
  self:SetData({})
end
function WeddingWallPictureDetail:GetWallPicThumbnail(cellCtl)
  if cellCtl and cellCtl.data then
    Game.WeddingWallPicManager:GetPicThumbnailByCell(cellCtl)
    if self.serverData and Game.WeddingWallPicManager:checkSamePicture(cellCtl.data, self.serverData.photoData) then
      cellCtl:IsCurrent(true)
      local panel = self.scrollView.panel
      if panel then
        local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtl.gameObject.transform)
        local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
        offset = Vector3(0, offset.y, 0)
        self.scrollView:MoveRelative(offset)
      end
    else
      cellCtl:IsCurrent(false)
    end
  end
end
function WeddingWallPictureDetail:GetIndexByCellData(data)
  local cells = self:GetItemCells()
  for i = 1, #cells do
    local single = cells[i]
    if single.data and Game.WeddingWallPicManager:checkSamePicture(single.data, data) then
      return i
    end
  end
end
function WeddingWallPictureDetail:SetData(datas, noResetPos)
  local totalUpSize = GameConfig.Wedding and GameConfig.Wedding.MaxFramePhotoCount or 10
  self.frameSizeLabel.text = string.format(ZhString.PersonalPictureCell_CurFrameShowState, #datas, totalUpSize)
  self.wraplist:UpdateInfo(datas)
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
  self.scrollView:ResetPosition()
end
function WeddingWallPictureDetail:initDefaultTextureSize()
  self.originWith = self.photo.width
  self.originHeight = self.photo.height
end
function WeddingWallPictureDetail:setTexture(texture)
  local orginRatio = self.originWith / self.originHeight
  local textureRatio = 0
  textureRatio = texture.width / texture.height
  local wRatio = math.min(orginRatio, textureRatio) == orginRatio
  local height = self.originHeight
  local width = self.originWith
  if wRatio then
    height = self.originWith / textureRatio
  else
    width = self.originHeight * textureRatio
  end
  self.photo.width = width
  self.photo.height = height
  if self.firstSetTexture then
    self.firstSetTexture = false
  else
    Object.DestroyImmediate(self.photo.mainTexture)
  end
  self.photo.mainTexture = texture
end
function WeddingWallPictureDetail:getPhoto()
  if self.serverData then
    local photoData = self.serverData.photoData
    local bytes = Game.WeddingWallPicManager:GetBytes(photoData)
    if bytes then
      self:completeCallbackBytes(bytes)
    else
      local tBytes
      local thumbnail = true
      if photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY then
        if photoData.isBelongAccPic then
          tBytes = UnionWallPhotoNew.Ins():TryGetThumbnailFromLocal_ScenicSpot_Account(photoData.charid, photoData.sourceid, photoData.time)
        else
          tBytes = UnionWallPhotoNew.Ins():TryGetThumbnailFromLocal_ScenicSpot(photoData.charid, photoData.sourceid, photoData.time)
        end
      elseif photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF then
        tBytes = UnionWallPhotoNew.Ins():TryGetThumbnailFromLocal_Personal(photoData.charid, photoData.sourceid, photoData.time)
      end
      if tBytes then
        self:completeCallback(tBytes, thumbnail)
      elseif serverData and serverData.texture then
        self:completeCallbackThumbnailTexture(serverData.texture)
      end
      Game.WeddingWallPicManager:tryGetOriginImage(photoData)
    end
  end
end
function WeddingWallPictureDetail:completeCallbackBytes(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:setTexture(texture)
  else
    Object.DestroyImmediate(texture)
  end
end
function WeddingWallPictureDetail:completeCallbackThumbnailTexture(texture)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  texture:LoadRawTextureData(texture:GetRawTextureData())
  texture:Apply()
  self:setTexture(texture)
end
function WeddingWallPictureDetail:progressCallback(progress)
  self:Show(self.progress.gameObject)
  if progress >= 1 then
    progress = 1 or progress
  end
  local value = progress * 100
  value = math.floor(value)
  self.progress.text = value .. "%"
end
function WeddingWallPictureDetail:completeCallback(bytes, thumbnail)
  if not thumbnail then
    self:Hide(self.progress.gameObject)
  end
  self.isThumbnail = thumbnail
  if bytes then
    local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
    local bRet = ImageConversion.LoadImage(texture, bytes)
    if bRet then
      self:setTexture(texture)
      if not thumbnail then
        Game.WeddingWallPicManager:addOriginBytesBySceneryId(self.serverData.photoData, bytes)
      end
    else
      Object.DestroyImmediate(texture)
    end
  end
end
function WeddingWallPictureDetail:OnExit()
  LeanTween.cancel(self.gameObject)
  Object.DestroyImmediate(self.photo.mainTexture)
  PhotoDataProxy.Instance:clearToSeeDatas()
  if not self.firstSetTexture then
    Object.DestroyImmediate(self.photo.mainTexture)
  end
  if self.photo then
    PictureManager.Instance:UnLoadWedding("Wedding_Photo", self.photo)
  end
end
function WeddingWallPictureDetail:GetItemCellById(photoData)
  local cells = self:GetItemCells()
  if cells and #cells > 0 then
    for i = 1, #cells do
      local single = cells[i]
      if single.data and Game.WeddingWallPicManager:checkSamePicture(single.data, photoData) then
        return single
      end
    end
  end
end
function WeddingWallPictureDetail:GetItemCells()
  return self.wraplist:GetCellCtls()
end
