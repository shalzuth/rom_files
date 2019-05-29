Charactor = class("Charactor", ContainerView)
autoImport("AddPointPage")
autoImport("ProfessionPage")
autoImport("InfomationPage")
autoImport("BaseAttributeView")
autoImport("AttributePointSolutionView")
autoImport("ProfessionInfoViewMP")
autoImport("PlayerDetailViewMP")
Charactor.ViewType = UIViewType.NormalLayer
Charactor.PlayerHeadCellResId = ResourcePathHelper.UICell("PlayerHeadCell")
Charactor.TabName = {
  Infomation = ZhString.Charactor_Infomation,
  AddPoint = ZhString.Charactor_AddPoint,
  Profession = ZhString.Charactor_Profession
}
function Charactor:Init()
  self:initData()
  self:InitTitle()
  self:AddPages()
  self:InitToggle()
  self:initView()
  self:AddListenerEvts()
  self:initTitleData()
  local jobExp = self:FindGO("jobExp", self.topTitle)
  local jobLvLabel = self:FindGO("Label", jobExp):GetComponent(UILabel)
  jobLvLabel.transform.localPosition = Vector3(20, 0, 0)
  jobLvLabel.fontSize = 17
  jobLvLabel.spacingX = 0
  local baseExp = self:FindGO("baseExp", self.topTitle)
  local baseLabel = self:FindGO("Label", baseExp):GetComponent(UILabel)
  baseLabel.transform.localPosition = Vector3(14, 3, 0)
  baseLabel.fontSize = 17
  baseLabel.spacingX = 0
  self.baseLevel.fontSize = 17
  self.baseLevel.spacingX = 0
  self.jobLevel.fontSize = 17
  self.jobLevel.spacingX = 0
  self.jobLevel.transform.localPosition = Vector3(50, 0, 0)
end
function Charactor:initData()
  self.currentKey = nil
  self:UpdateHead()
end
function Charactor.effectLoadFinish(obj, self)
  self.effectObj = obj
end
function Charactor:HasMarryed()
  return WeddingProxy.Instance:IsSelfMarried()
end
function Charactor:GetCouplePortraitData()
  local headData = HeadImageData.new()
  headData:TransByMyself()
  return headData.iconData
end
function Charactor:initCouplePortrait()
  self.couplesCt = self:FindGO("couplesCt")
  local couplesBg = self:FindComponent("couplesBg", UISprite)
  if self:HasMarryed() then
    self:Show(self.couplesCt)
    self:AddClickEvent(self.couplesCt, function()
      local infoData = WeddingProxy.Instance:GetWeddingInfo()
      if infoData then
        local id = infoData:GetPartnerGuid()
        local coupleData = WeddingProxy.Instance:GetPortraitInfo(id)
        local playerData = PlayerTipData.new()
        playerData:SetByWeddingcharData(coupleData, true)
        local tip = FunctionPlayerTip.Me():GetPlayerTip(couplesBg, NGUIUtil.AnchorSide.Left, {-380, 60})
        local data = {
          playerData = playerData,
          funckeys = {
            "Wedding_CallBack",
            "Wedding_MissYou",
            "ShowDetail",
            "SendMessage",
            "InviteMember"
          }
        }
        tip:SetData(data)
      end
    end)
  else
    self:Hide(self.couplesCt)
  end
end
function Charactor:initView()
  self:AddButtonEvent("strengthBtn", function()
    self.baseAttributeView:clickShowBtn()
    if self.uiPlayerSceneInfo then
      self.uiPlayerSceneInfo:HideTitle()
    end
  end)
  local path = ResourcePathHelper.UIEffect(EffectMap.UI.FlashLight)
  Asset_Effect.PlayOn(path, self:FindGO("strengthBtn").transform, self.effectLoadFinish, self)
  self.professionInfoViewRlt = self:FindChild("professionInfoView"):GetComponent(RelateGameObjectActive)
  self.playTw = self:FindChild("strengthBtn"):GetComponent(UIPlayTween)
  local infomationLabel = self:FindChild("NameLabel", self.infomationTog):GetComponent(UILabel)
  infomationLabel.text = ZhString.Charactor_Infomation
  local addPointLabel = self:FindChild("NameLabel", self.addPointTog):GetComponent(UILabel)
  addPointLabel.text = ZhString.Charactor_AddPoint
  local professionLabel = self:FindChild("NameLabel", self.professionTog):GetComponent(UILabel)
  professionLabel.text = ZhString.Charactor_Profession
  local coupleLabel = self:FindComponent("coupleLabel", UILabel)
  coupleLabel.text = ZhString.Wedding_CharactorCoupleLabel
  function self.professionInfoViewRlt.disable_Call()
    if self.professionPage then
      self.professionPage:unSelectedProfessionIconCell()
    else
      helplog("if self.professionPage then = nil")
    end
  end
  self:RegisterRedTip()
  self:UpdateTitleInfo()
  self:initCouplePortrait()
end
function Charactor:AddListenerEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateTitleInfo)
  self:AddListenEvt(MyselfEvent.JobExpChange, self.UpdateJobSlider)
  self:AddListenEvt(MyselfEvent.BaseExpChange, self.UpdateExpSlider)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateMyProfession)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
  self:AddListenEvt(ServiceEvent.UserEventDepositCardInfo, self.UpdateMonthCardDate)
  self:AddListenEvt(ServiceEvent.UserEventChangeTitle, self.initTitleData)
end
function Charactor:initTitleData()
  local titleData = Table_Appellation[Game.Myself.data:GetAchievementtitle()]
  if titleData then
    self:Show(self.UserTitle.gameObject)
    self.UserTitle.text = "[" .. titleData.Name .. "]"
  else
    self:Hide(self.UserTitle.gameObject)
  end
end
function Charactor:toggleStrengthBtn()
  self.playTw:Play(true)
end
function Charactor:AddPages()
  local addPointPage = self:AddSubView("AddPointPage", AddPointPage)
  self:AddListenEvt(XDEUIEvent.CloseCharTitle, function()
    if self.uiPlayerSceneInfo then
      self.uiPlayerSceneInfo:HideTitle()
    end
  end)
  self.professionPage = self:AddSubView("ProfessionPage", ProfessionPage)
  self:AddSubView("InfomationPage", InfomationPage)
  self.attrSolutionView = self:AddSubView("AttributePointSolutionView", AttributePointSolutionView)
  self.attrSolutionView:AddEventListener(AttributePointSolutionView.SelectCell, addPointPage.selectAddPointSolution, addPointPage)
  self.baseAttributeView = self:AddSubView("BaseAttributeView", BaseAttributeView)
  self.professionInfoViewMP = self:AddSubView("ProfessionInfoViewMP", ProfessionInfoViewMP)
  if self.professionInfoViewMP == nil then
    helplog("if self.professionInfoViewMP == nil then")
    return
  end
  self.professionPage:AddEventListener(ProfessionPage.ProfessionIconClick, self.professionInfoViewMP.multiProfessionInfo, self.professionInfoViewMP)
  addPointPage:AddEventListener(AddPointPage.addPointAction, self.addPointAction, self)
  self.playerDetailViewMP = self:AddSubView("PlayerDetailViewMP", PlayerDetailViewMP, "PlayerDetailViewMP_1")
  self.professionInfoViewMP:AddEventListener(ProfessionInfoViewMP.LeftBtnClick, self.playerDetailViewMP.OnClickBtnFromProfessionInfoViewMP, self.playerDetailViewMP)
end
function Charactor:InitTitle()
  self.topTitle = self:FindGO("topTitle")
  self.profeName = self:FindChild("professionNamePointPage"):GetComponent(UILabel)
  self.UserTitle = self:FindChild("UserTitle"):GetComponent(UILabel)
  self.baseLevel = self:FindChild("baseLv"):GetComponent(UILabel)
  self.baseExp = self:FindChild("baseSlider"):GetComponent(UISlider)
  self.jobLevel = self:FindChild("jobLv"):GetComponent(UILabel)
  self.jobExp = self:FindChild("jobLevelSlider"):GetComponent(UISlider)
  self.battlePoint = self:FindChild("fightPowerLabel"):GetComponent(UILabel)
  self.PlayerName = self:FindGO("PlayerName"):GetComponent(UILabel)
  self.PlayerId = self:FindGO("PlayerId"):GetComponent(UILabel)
  self.monthCardTime = self:FindGO("monthCardTime"):GetComponent(UILabel)
  local fightPowerName = self:FindGO("fightPowerName"):GetComponent(UILabel)
  fightPowerName.text = ZhString.Charactor_PingFen
  OverseaHostHelper:FixLabelOverV1(self.PlayerName, 3, 200)
  OverseaHostHelper:FixLabelOverV1(self.UserTitle, 3, 120)
  OverseaHostHelper:FixAnchor(self.UserTitle.leftAnchor, self.PlayerName.transform, 1, 10)
  OverseaHostHelper:FixAnchor(self.UserTitle.rightAnchor, self.PlayerName.transform, 1, 130)
end
function Charactor:InitToggle()
  local togObj = self:FindChild("toggles")
  self.addPointTog = self:FindChild("AddPoint", togObj)
  self:AddOrRemoveGuideId(self.addPointTog, 5)
  self.professionTog = self:FindChild("Profession", togObj)
  self.infomationTog = self:FindGO("Infomation", togObj)
  self:AddTabChangeEvent(self.addPointTog, self:FindChild("AddPointPage"), PanelConfig.AddPointPage)
  self:AddTabChangeEvent(self.professionTog, self:FindChild("ProfessionPage"), PanelConfig.ProfessionPage)
  self:AddTabChangeEvent(self.infomationTog, self:FindChild("InfomationPage"), PanelConfig.InfomationPage)
  local infoLongPress = self.infomationTog:GetComponent(UILongPress)
  local addLongPress = self.addPointTog:GetComponent(UILongPress)
  local profLongPress = self.professionTog:GetComponent(UILongPress)
  local longPressEvent = function(obj, state)
    self:PassEvent(TipLongPressEvent.Charactor, {
      state,
      obj.gameObject
    })
  end
  infoLongPress.pressEvent = longPressEvent
  addLongPress.pressEvent = longPressEvent
  profLongPress.pressEvent = longPressEvent
  self:AddEventListener(TipLongPressEvent.Charactor, self.HandleLongPress, self)
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  local toggleList = {
    self.addPointTog,
    self.professionTog,
    self.infomationTog
  }
  for i, v in ipairs(toggleList) do
    local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
    icon:SetActive(iconActive)
    local nameLabel = GameObjectUtil.Instance:DeepFindChild(v, "NameLabel")
    nameLabel:SetActive(nameLabelActive)
  end
  if self.viewdata.showpage then
    self:ShowPage(self.viewdata.showpage)
  elseif self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(PanelConfig.InfomationPage.tab)
  end
end
function Charactor:RegisterRedTip()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ADD_POINT, self:FindChild("Background", self.addPointTog), nil, {-11, -10})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_PROFESSION, self:FindChild("Background", self.professionTog), nil, {-11, -10})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PROFESSION_UP, self:FindChild("Background", self.professionTog), nil, {-11, -10})
end
function Charactor:OnEnter()
  self.super.OnEnter(self)
  self:CameraRotateToMe(true)
end
function Charactor:OnExit()
  self:CameraReset()
  if self.currentKey == PanelConfig.AddPointPage.tab then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_ADD_POINT)
  elseif self.currentKey == PanelConfig.ProfessionPage.tab then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_PROFESSION)
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PROFESSION_UP)
  end
  self.super.OnExit(self)
  if self:ObjIsNil(self.effectObj) then
    GameObject.Destroy(self.effectObj)
    self.effectObj = nil
  end
  FunctionPlayerTip.Me():CloseTip()
  self.professionInfoViewRlt = nil
end
function Charactor:ShowPage(key)
  if key == "addPointPage" then
    self.addPointTog:GetComponent(UIToggle).startsActive = true
  elseif key == "professionPage" then
    self.professionTog:GetComponent(UIToggle).startsActive = true
  else
    self.addPointTog:GetComponent(UIToggle).startsActive = true
  end
end
function Charactor:addPointAction(addData)
  self.baseAttributeView:showMySelf(addData)
end
function Charactor:TabChangeHandler(key)
  if self.currentKey ~= key then
    local bRet = Charactor.super.TabChangeHandler(self, key)
    self.attrSolutionView:Hide()
    if self.currentKey == PanelConfig.AddPointPage.tab then
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_ADD_POINT)
    elseif self.currentKey == PanelConfig.ProfessionPage.tab then
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_PROFESSION)
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PROFESSION_UP)
    end
    if key ~= PanelConfig.AddPointPage.tab then
      self.attrSolutionView:Hide()
      self.professionInfoViewMP:multiProfessionInfo(nil)
    end
    if key == PanelConfig.ProfessionPage.tab then
      self.professionPage:reShowGuidTextData()
      if bRet then
        self.topTitle:SetActive(false)
      end
    else
      self.professionInfoViewMP:multiProfessionInfo(nil)
      self.topTitle:SetActive(true)
    end
    if bRet and not GameConfig.SystemForbid.TabNameTip then
      if self.currentKey then
        local iconSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[self.currentKey].go, "Icon"):GetComponent(UISprite)
        iconSp.color = ColorUtil.TabColor_White
      end
      local iconSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[key].go, "Icon"):GetComponent(UISprite)
      iconSp.color = ColorUtil.TabColor_DeepBlue
    end
    if bRet then
      self.currentKey = key
    end
  end
end
function Charactor:AddCloseButtonEvent()
  Charactor.super.AddCloseButtonEvent(self)
  self:AddOrRemoveGuideId("CloseButton", 8)
end
function Charactor:UpdateTitleInfo()
  self:UpdateExpSlider()
  self:UpdateJobSlider()
  self:UpdateHead()
  self:UpdateMyProfession()
  self:UpdateMonthCardDate()
  local data = ServiceConnProxy.Instance:getData()
  self.PlayerId.text = data and data.accid or 0
  self.PlayerName.text = Game.Myself.data:GetName()
end
function Charactor:UpdateExpSlider()
  local userData = Game.Myself.data.userdata
  local roleExp = userData:Get(UDEnum.ROLEEXP)
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)
  self.baseLevel.text = string.format("Lv%s", tostring(nowRoleLevel))
  local referenceValue = Table_BaseLevel[nowRoleLevel + 1]
  if referenceValue == nil then
    referenceValue = 1
  else
    referenceValue = referenceValue.NeedExp
  end
  self.baseExp.value = roleExp / referenceValue
  self.battlePoint.text = tostring(userData:Get(UDEnum.BATTLEPOINT))
end
function Charactor:UpdateMonthCardDate()
  local leftDay = UIModelMonthlyVIP.Instance():GetMonthCardLeftDays()
  if leftDay then
    self:Show(self.monthCardTime.gameObject)
    self.monthCardTime.text = string.format(ZhString.Charactor_MonthCardTime, leftDay)
  else
    self:Hide(self.monthCardTime.gameObject)
  end
end
function Charactor:UpdateJobSlider()
  local nowJob = Game.Myself.data:GetCurOcc()
  if nowJob == nil then
    return
  end
  local professionid = MyselfProxy.Instance:GetMyProfession()
  local nowJobLevel = nowJob:GetLevelText()
  local userData = Game.Myself.data.userdata
  local cur_max = userData:Get(UDEnum.CUR_MAXJOB) or 0
  local curlv = MyselfProxy.Instance:JobLevel()
  helplog("Server professionid:" .. professionid)
  helplog("Server nowJobLevel:" .. nowJobLevel)
  helplog("Server cur_max:" .. cur_max)
  helplog("Server curlv:" .. curlv)
  self.baseLevel.fontSize = 17
  self.baseLevel.spacingX = 0
  self.jobLevel.fontSize = 17
  self.jobLevel.spacingX = 0
  if professionid == 1 then
  elseif professionid ~= 1 then
    if professionid % 10 == 1 then
      cur_max = cur_max - 10
      curlv = curlv - 10
    elseif professionid % 10 == 2 then
      cur_max = cur_max - 50
      curlv = curlv - 50
    elseif professionid % 10 == 3 then
      cur_max = cur_max - 90
      curlv = curlv - 90
    elseif professionid % 10 == 4 then
      cur_max = cur_max - 160
      curlv = curlv - 160
    else
      helplog("\230\156\141\229\138\161\229\153\168\229\143\145\228\186\134\233\148\153\232\175\175\231\154\132\228\184\156\232\165\191\239\188\129\239\188\129")
    end
  end
  if curlv <= 0 or cur_max <= 0 then
    helplog("\231\173\150\229\136\146\229\161\171\233\148\153\228\186\134\232\161\168\229\175\188\232\135\180\230\152\190\231\164\186\228\184\141\229\175\185 \232\175\183\231\173\150\229\136\146\230\163\128\230\159\165Table_Class\232\161\168\239\188\129\239\188\129\239\188\129")
  end
  self.jobLevel.text = string.format("Lv%s/%s", tostring(curlv), cur_max)
  local referenceValue = Table_JobLevel[nowJob.level + 1]
  if referenceValue == nil then
    referenceValue = 1
  else
    referenceValue = referenceValue.JobExp
  end
  self.jobExp.value = nowJob.exp / referenceValue
end
local tempVector3 = LuaVector3.zero
function Charactor:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    tempVector3:Set(0, 0, 0)
    self.headCellObj.transform.localPosition = tempVector3
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self:AddClickEvent(self.headCellObj, function()
      if #ChangeHeadProxy.Instance:GetPortraitList() < 1 then
        MsgManager.ShowMsgByID(80)
      else
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ChangeHeadView
        })
      end
    end)
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByMyself()
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end
function Charactor:clickHeadIcon()
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "PortraitPopUp"
  })
end
function Charactor:UpdateMyProfession()
  local nowOcc = Game.Myself.data:GetCurOcc()
  if nowOcc ~= nil then
    local prodata = Table_Class[nowOcc.profession]
    if prodata and prodata.NameZh then
    else
      helplog("Table_Class \230\178\161\230\156\137 id \232\175\183\231\173\150\229\136\146\230\163\128\230\159\165" .. nowOcc.profession)
      return
    end
    self.profeName.text = prodata.NameZh
  end
end
function Charactor:HandleMapChange(note)
  if note.type == LoadSceneEvent.FinishLoad and note.body then
    self:CameraRotateToMe()
  end
end
function Charactor:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    if isPressing then
      local backgroundSp = GameObjectUtil.Instance:DeepFindChild(go, "Background"):GetComponent(UISprite)
      TipManager.Instance:TryShowHorizontalTabNameTip(Charactor.TabName[go.name], backgroundSp, NGUIUtil.AnchorSide.Left)
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
