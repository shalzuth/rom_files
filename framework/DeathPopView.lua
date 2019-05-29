DeathPopView = class("DeathPopView", ContainerView)
DeathPopView.ViewType = UIViewType.ReviveLayer
DeathPopView.TextureBg = "persona_bg_npc"
function DeathPopView:Init()
  self:initData()
  self:initView()
  self:handleDelay()
  self:addEventListener()
  self:AddViewEvts()
  self.bgTexture.transform.localPosition = Vector3(-530, 36, 0)
  OverseaHostHelper:FixLabelOverV1(self.title, 3, 230)
  self.title.fontSize = 18
end
function DeathPopView:handleDelay()
  if not self.mapMng:IsPveMode_PveCard() then
    return
  end
  self:Hide()
  if self.blockID then
    LeanTween.cancel(self.gameObject, self.blockID)
    self.blockID = nil
  end
  local delay = GameConfig.CardRaid.deathview_delay or 10
  local ret = LeanTween.delayedCall(self.gameObject, delay, function()
    self:Show()
  end)
  self.blockID = ret.uniqueId
end
function DeathPopView:initData()
  self.isPvpMap = SceneProxy.Instance:IsPvPScene()
  self.totalTime = GameConfig.DeathPopViewShowTime.showTime
  self.leftTime = self.totalTime
  self.costItem = GameConfig.UserRelive.deathcost2[1].id
  self.reliveCostCount = GameConfig.UserRelive.deathcost2[1].num
  self.isDaoChangMap = DojoProxy.Instance:IsSelfInDojo()
  self.currentMap = SceneProxy.Instance.currentScene
  self.mapMng = Game.MapManager
end
function DeathPopView:initView()
  self.goldIcon = self:FindGO("gold"):GetComponent(UISprite)
  self.title = self:FindGO("deathTitle"):GetComponent(UILabel)
  self.title.text = ZhString.DeathPopView_Title
  local ReliveInSituLabel = self:FindComponent("ReliveInSituLabel", UILabel)
  ReliveInSituLabel.text = ZhString.DeathPopView_ReliveInSitu
  self.ReliveInRelivePointLabel = self:FindComponent("ReliveInRelivePointLabel", UILabel)
  self.ReliveInRelivePointLabel.text = ZhString.DeathPopView_ReliveInRelivePoint
  self.ReliveInSavePointLabel = self:FindComponent("ReliveInSavePointLabel", UILabel)
  self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveInSavePoint
  local ReliveInRelivePointBtn = self:FindGO("ReliveInRelivePointBtn")
  self.timeCt = self:FindGO("timeCt")
  self.timeThumnail = self:FindGO("timeThumnail")
  self.timeSlider = self:FindComponent("timeSlider", UISlider)
  self.itemData = Table_Item[self.costItem]
  if self.itemData then
    IconManager:SetItemIcon(self.itemData.Icon, self.goldIcon)
  end
  local totalCount = BagProxy.Instance:GetItemNumByStaticID(self.costItem)
  self.ReliveInRelivePointBtnBox = self:FindComponent("ReliveInRelivePointBtn", BoxCollider)
  self.ReliveInRelivePointBtnSp = self:FindComponent("ReliveInRelivePointBtn", UISprite)
  local ReliveInRelivePointBtnCt = self:FindGO("ReliveInRelivePointBtnCt")
  self.ReliveInSavePointBtn = self:FindGO("ReliveInSavePointBtn")
  local ReliveInSavePointBtnCt = self:FindGO("ReliveInSavePointBtnCt")
  local ReliveInSavePointBg = self:FindComponent("ReliveInSavePointBtn", UISprite)
  self.ReliveInSituBtnCt = self:FindGO("ReliveInSituBtnCt")
  local DeathHint = self:FindComponent("DeathHint", UILabel)
  local userData = Game.Myself.data.userdata
  local defeat = userData:GetBytes(UDEnum.KILLERNAME)
  local base = userData:Get(UDEnum.DROPBASEEXP)
  if self.isPvpMap then
    DeathHint.text = string.format(ZhString.DeathPopView_TitleHintPvP, defeat)
  else
    DeathHint.text = string.format(ZhString.DeathPopView_TitleHint, defeat, base)
  end
  if self.isPvpMap then
    self:Hide(self.ReliveInSituBtnCt)
  elseif self.isDaoChangMap then
    self:Hide(ReliveInRelivePointBtnCt)
    self:Hide(self.timeCt)
    if totalCount < self.reliveCostCount then
      self:Hide(self.ReliveInSituBtnCt)
    end
  elseif not self.isPvpMap then
    self:Hide(ReliveInRelivePointBtnCt)
    ReliveInSavePointBg.spriteName = "com_btn_3s"
    self.ReliveInSavePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
    self.timeCt.transform:SetParent(self.ReliveInSavePointBtn.transform, false)
    if totalCount < self.reliveCostCount then
      self:Hide(self.ReliveInSituBtnCt)
    end
  end
  if Game.MapManager:IsGvgMode_Droiyan() or Game.MapManager:IsPVPMode_TeamPws() then
    self:Hide(ReliveInSavePointBtnCt)
  end
  local BoundCt = self:FindGO("BoundCt")
  local grid = BoundCt:GetComponent(UITable)
  grid:Reposition()
  local btnCt = self:FindGO("btnCt"):GetComponent(UISprite)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(BoundCt.transform, false)
  local tmp = bound.size.y + 54.0
  bound = NGUIMath.CalculateRelativeWidgetBounds(DeathHint.transform, false)
  tmp = tmp + bound.size.y
  btnCt.height = tmp
  if self.currentMap:IsInDungeonMap() then
    self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveAndLeave
  end
  self.bgTexture = self:FindComponent("Texture", UITexture)
  PictureManager.Instance:SetUI(DeathPopView.TextureBg, self.bgTexture)
  self:HandleReliveCd()
end
function DeathPopView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleReliveStatus)
end
function DeathPopView:HandleReliveStatus(note)
  self:CloseSelf()
end
function DeathPopView:addEventListener()
  self:AddButtonEvent("ReliveInSituBtn", function(obj)
    ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_MONEY)
  end)
  self:AddButtonEvent("ReliveInRelivePointBtn", function(obj)
    ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
  end)
  self:AddButtonEvent("ReliveInSavePointBtn", function(obj)
    if self.isPvpMap then
      ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURNSAVE)
    else
      ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
    end
  end)
  self:AddListenEvt(ServiceEvent.UserEventDieTimeCountEventCmd, self.HandleReliveCd)
end
function DeathPopView:HandleReliveCd(data)
  if self.mapMng:IsPVPMode_GVGDetailed() or self.mapMng:IsGvgMode_Droiyan() then
    self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveInSavePoint
    local time = MyselfProxy.Instance.reliveStamp
    if not time or not time then
      time = 0
    end
    if time > 0 then
      self.ReliveInRelivePointBtnBox.enabled = false
      self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
      local currentTime = ServerTime.CurServerTime()
      currentTime = currentTime / 1000
      self.totalTime = math.floor(time - currentTime)
      self.title.text = string.format(ZhString.DeathPopView_TitleReliveHintGVG, MyselfProxy.Instance.reliveName)
      self.ReliveInRelivePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
      if 0 < self.totalTime then
        self.Show(self.timeCt)
        TimeTickManager.Me():ClearTick(self)
        TimeTickManager.Me():CreateTick(0, 1000, self.updateCdTime, self)
      end
    elseif self.mapMng:IsPVPMode_GVGDetailed() then
      self.ReliveInRelivePointBtnBox.enabled = false
      self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13"
    else
      self.ReliveInRelivePointBtnBox.enabled = true
      self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
    end
  end
end
function DeathPopView:OnEnter()
  DeathPopView.super.OnEnter(self)
  self:sendNotification(MainViewEvent.ActiveShortCutBord, false)
end
function DeathPopView:OnExit()
  self:sendNotification(MainViewEvent.ActiveShortCutBord, true)
  self.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnLoadUI(DeathPopView.TextureBg, self.bgTexture)
  MyselfProxy.Instance:ClearReliveCd()
  if self.blockID then
    LeanTween.cancel(self.gameObject, self.blockID)
    self.blockID = nil
  end
end
function DeathPopView:updateCdTime()
  local currentTime = ServerTime.CurServerTime()
  currentTime = currentTime / 1000
  local time = MyselfProxy.Instance.reliveStamp
  local leftTime = time - currentTime
  leftTime = math.floor(leftTime)
  local delta = 1 - leftTime / self.totalTime
  if leftTime <= 0 then
    leftTime = 0
    local isDead = Game.Myself:IsDead()
    if isDead then
    else
      self:CloseSelf()
      return
    end
  end
  self.ReliveInRelivePointLabel.text = string.format(ZhString.DeathPopView_ReliveHintDesGVG, leftTime)
  self.timeSlider.value = delta
  self.timeThumnail.transform.eulerAngles = Vector3(0, 0, 90 - delta * 360)
end
