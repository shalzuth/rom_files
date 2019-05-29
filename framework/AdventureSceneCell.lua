local baseCell = autoImport("BaseCell")
AdventureSceneCell = class("AdventureSceneCell", baseCell)
AdventureSceneCell.InvisibleHelpId = 1
function AdventureSceneCell:Init()
  AdventureSceneCell.super.Init(self)
  self:initView()
  self:initData()
  self:AddViewEvent()
end
function AdventureSceneCell:AddViewEvent()
  local background = self:FindGO("background")
  self:AddClickEvent(background, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddButtonEvent("infoTip", function(g)
    local data = Table_Help[AdventureSceneCell.InvisibleHelpId]
    if data then
    else
    end
  end)
  self:AddDragEvent(background, function(obj, delta)
    if math.abs(delta.x) > 20 then
      self.delta = delta.x
    end
  end)
  UIEventListener.Get(background).onDragEnd = function(obj)
    if math.abs(self.delta) > 20 then
      EventManager.Me():PassEvent(AdventureSceneList.ViewPageDrag, self.delta)
    end
  end
end
function AdventureSceneCell:initData()
  self.delta = 0
end
function AdventureSceneCell:initView()
  self.unlockClient = self:FindGO("unlockClient"):GetComponent(UISprite)
  self.sceneryName = self:FindGO("sceneryName"):GetComponent(UILabel)
  self.mask = self:FindGO("mask")
  self.expNum = self:FindGO("expNum"):GetComponent(UILabel)
  self.extCt = self:FindGO("exp")
  self.coinNum = self:FindGO("coinNum"):GetComponent(UILabel)
  self.coinIcon = self:FindGO("coinIcon"):GetComponent(UIMultiSprite)
  self.coinIcon.isChangeSnap = false
  self.texture = self:FindGO("texture"):GetComponent(UITextureEx)
  self.textureCt = self:FindGO("textureCt")
  self.newTag = self:FindGO("newTag")
  local errorTip = self:FindGO("errorTip"):GetComponent(UILabel)
  errorTip.text = ZhString.AdventureSceneCell_PicLost
  self.scoreCt = self:FindGO("scoreCt")
  self.score = self:FindComponent("score", UILabel)
  self.error = self:FindGO("errorCt")
  self.infoTip = self:FindGO("infoTip")
  self.noPhoto = self:FindGO("noPhoto")
  self.closeTipCt = self:FindGO("closeTipCt")
  self.rewardCt = self:FindGO("rewardCt")
  local closeTipLabel = self:FindComponent("closeTipLabel", UILabel)
  closeTipLabel.text = ZhString.AdventureSceneCell_ViewSpotCloseTip
end
function AdventureSceneCell:SetData(data)
  self.data = data
  self:Hide(self.unlockClient.gameObject)
  if not data then
    self:Hide()
    return
  end
  self.occurError = false
  self.loadFinish = false
  self:Show()
  self.sceneryName.text = data:GetName()
  self:isInvisible()
  self:setItemIsLock()
  local coinNumL = 0
  self:Show(self.coinIcon.gameObject)
  self:Hide(self.error)
  self:Hide(self.newTag)
  self.extCt.transform.localPosition = Vector3(33.7, 0, 0)
  if data.staticData.AdventureReward.AdvPoints then
    self.coinIcon.CurrentState = 0
    self.coinIcon.spriteName = "Adventure_icon_06"
    coinNumL = data.staticData.AdventureReward.AdvPoints
  elseif data.staticData.AdventureReward.item then
    self.coinIcon.CurrentState = 1
    local id = data.staticData.AdventureReward.item[1]
    if id then
      local itemData = Table_Item[id[1]]
      if itemData then
        self.coinIcon.spriteName = itemData.Icon
        coinNumL = id[2]
      else
        printRed("can find item by id:")
        printRed(id)
      end
    end
  else
    self:Hide(self.coinIcon.gameObject)
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.extCt.transform)
    self.extCt.transform.localPosition = Vector3(-bound.size.x / 2 * 0.8, 0, 0)
  end
  self.expNum.text = "x" .. data.staticData.AdventureValue
  self.coinNum.text = "x" .. coinNumL
  self.score.text = data.staticData.AdventureValue
  if data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY then
    self:PassEvent(PersonalPicturePanel.GetPersonPicThumbnail, self)
  end
  self:checkNewTag()
end
function AdventureSceneCell:isInvisible()
  local type = self.data.staticData.Type
  if type == 2 then
    self:Show(self.infoTip)
  elseif type == 1 then
    self:Hide(self.infoTip)
  end
end
function AdventureSceneCell:setTexture(texture)
  if texture then
    self:Show(self.textureCt)
    self:Hide(self.error)
    self.texture.mainTexture = texture
    self.loadFinish = true
  end
end
function AdventureSceneCell:setDownloadFailure()
  self.occurError = true
  self:Show(self.error)
  self:Hide(self.textureCt)
end
function AdventureSceneCell:checkNewTag()
  local key = string.format(PhotographResultPanel.SceneryKey, self.data.staticId)
  local isNew = FunctionPlayerPrefs.Me():GetBool(key)
  if isNew then
    FunctionPlayerPrefs.Me():SetBool(key, false)
    self:Show(self.newTag)
  end
end
function AdventureSceneCell:OnExit()
  self.super.OnExit(self)
end
function AdventureSceneCell:setDownloadProgress(progress)
end
function AdventureSceneCell:ShowViewSpotCloseUI()
  self.unlockClient.spriteName = "Adventure_icon_prohibit"
  self.unlockClient:MakePixelPerfect()
  self:Show(self.closeTipCt)
  self:Hide(self.rewardCt)
end
function AdventureSceneCell:ShowViewSpotOpenUI()
  self.unlockClient.spriteName = "com_icon_lock"
  self.unlockClient:MakePixelPerfect()
  self:Hide(self.closeTipCt)
  self:Show(self.rewardCt)
end
function AdventureSceneCell:setItemIsLock()
  local data = self.data
  self:Hide(self.mask)
  self:Hide(self.unlockClient.gameObject)
  self:Show(self.scoreCt)
  self:Hide(self.closeTipCt)
  if data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY then
    self:Show(self.mask)
    self:Show(self.unlockClient.gameObject)
    self:Show(self.noPhoto)
    self:Hide(self.scoreCt)
    if data.staticData.noopen == 1 then
      self:ShowViewSpotCloseUI()
    else
      self:ShowViewSpotOpenUI()
    end
  elseif data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
    self:Show(self.mask)
    self:Hide(self.noPhoto)
    self:Hide(self.scoreCt)
    self:Show(self.unlockClient.gameObject)
    self.unlockClient.spriteName = "com_icon_add2"
    self.unlockClient:MakePixelPerfect()
  elseif data:canBeClick() then
    self:Show(self.unlockClient.gameObject)
    self.unlockClient.spriteName = "com_icon_add3"
    self:Hide(self.scoreCt)
  end
  self:Hide(self.textureCt)
end
