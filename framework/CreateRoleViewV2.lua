local CreateRoleViewV2 = class("CreateRoleViewV2", BaseView)
CreateRoleViewV2.ViewType = UIViewType.MainLayer
CreateRoleViewV2.requestTime = 0
autoImport("MakeRole")
autoImport("HairStyleCell")
autoImport("HeadwearCell")
autoImport("FunctionMaskWord")
autoImport("UIBlackScreen")
autoImport("UIRoleSelect")
autoImport("UIModelRolesList")
autoImport("WaitEnterBord")
CreateRoleViewV2.ins = nil
PolygonColor = {
  [1] = {polygonColorOut = "FDFF51", polygonColorIn = "FFA200"},
  [2] = {polygonColorOut = "4EFF90", polygonColorIn = "00A463"},
  [3] = {polygonColorOut = "FFA800", polygonColorIn = "FF4200"},
  [4] = {polygonColorOut = "359CFF", polygonColorIn = "0740CE"},
  [5] = {polygonColorOut = "FF5B3C", polygonColorIn = "F5242B"},
  [6] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"}
}
function CreateRoleViewV2:Init()
  CreateRoleViewV2.ins = self
  self:MapViewListener()
  self:FindObj()
  self:AddButtonEvt()
  self.waitEnterBord = WaitEnterBord.new(self:FindGO("WaitEnterBord"))
  self:HideOccupationDetail()
  self:HideTitle()
  self.labNetworkTipContent.text = ZhString.StartGamePanel_WaitingLabel
  self.goNetworkTip:SetActive(false)
  self:CalibrateViewPortOfUICamera()
  local helpButton = self:LoadPreferb("cell/HelpButton", self.goNameInput)
  helpButton.transform.localPosition = Vector3(290, 8, 0)
  helpButton.transform.localScale = Vector3(1.2, 1.2, 1)
  self:AddClickEvent(helpButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CreateTipPanel
    })
  end)
end
function CreateRoleViewV2:OnExit()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    if UIManagerProxy.Instance:GetModalPopCount() > 0 then
      UIManagerProxy.Instance:PopView()
    else
      MsgManager.ConfirmMsgByID(27000, function()
        Application.Quit()
      end, function()
      end, nil, nil)
    end
  end)
  self:CloseTimeTickForFindMainCamera()
  self:CloseTimeTickForCheckTimeout()
  ServicePlayerProxy.mapChangeForCreateRole = false
  EventManager.Me():RemoveEventListener(CreateRoleViewEvent.PlayerMapChange, self.OnPlayerMapChangeForCreateRole, self)
  if self.maskFadeLeanTween ~= nil then
    self.maskFadeLeanTween:cancel()
    self.maskFadeLeanTween = nil
  end
  self.waitEnterBord:OnDestroy()
  self.waitEnterBord = nil
end
function CreateRoleViewV2:InitData()
  self.occupationID = CharacterSelectList[self.number].classID
  self.occupationIndex = self.number
  self.proDatas = {}
  for k, v in pairs(CharacterSelectList) do
    local temp = {}
    temp.createData = v
    temp.staticData = Table_Class[v.classID]
    table.insert(self.proDatas, temp)
  end
  table.sort(self.proDatas, function(a, b)
    return a.createData.classID < b.createData.classID
  end)
  self.nowPro = self:GetProData(self.occupationID)
  self.nowPro = self.nowPro or self.proDatas[1]
  self.sex = self:CurrentOccupationDefaultGender()
  if self.sex == E_Gender.Male then
    self.hairColorsID = self:CurrentOccupationHairColorSelectionsMale()
  elseif self.sex == E_Gender.Female then
    self.hairColorsID = self:CurrentOccupationHairColorSelectionsFemale()
  end
  self.hindex = self:HairColorIndex(self.hairColorSelection)
  if PlayerPrefs.HasKey(PlayerPrefsDefaultName) then
    self.name = PlayerPrefs.GetString(PlayerPrefsDefaultName)
  else
    self.name = ""
  end
end
function CreateRoleViewV2:FindObj()
  self.goAnchorMid = self:FindGO("Anchor_Mid", self.gameObject)
  self.goBCForDrag = self:FindGO("BCForDrag", self.goAnchorMid)
  self.bcForDrag = self.goBCForDrag:GetComponent(BoxCollider)
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.goAnchorLeft = self:FindGO("AnchorLeft", self.gameObject)
  self.goLeft = self:FindGO("Left", self.goAnchorLeft)
  self.goBG = self:FindGO("Bg", self.goLeft)
  self.goBottomBG = self:FindGO("bottomBg", self.goBG)
  self.spBGOfCustomStyle = self.goBottomBG:GetComponent(UISprite)
  self.boyToggle = self:FindGO("sexBtn_1", self.Left)
  self.girlToggle = self:FindGO("sexBtn_2", self.Left)
  self.goAnchorBottom = self:FindGO("Anchor_Bottom", self.gameObject)
  self.goBottom = self:FindGO("Bottom", self.goAnchorBottom)
  self.goNameInput = self:FindGO("NameInput", self.goBottom)
  self.nameInput = self.goNameInput:GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.nameInput, 12)
  self.nameInputLabel = self:FindGO("Label", self.nameInput.gameObject):GetComponent(UILabel)
  self.goHairColor = self:FindGO("hairColor", self.goLeft)
  self.goLabHairColor = self:FindGO("hairColorLab", self.goHairColor)
  self.hairColorLab = self.goLabHairColor:GetComponent(UILabel)
  self.goHairLeftBtn = self:FindGO("hairLeftBtn", self.goHairColor)
  self.hairLeftBtn = self.goHairLeftBtn:GetComponent(UIButton)
  self.goPanelMask = self:FindGO("PanelMask", self.gameObject)
  self.goMask = self:FindGO("Mask", self.goPanelMask)
  self.mask = self.goMask:GetComponent(UISprite)
  self.infoObjs = {}
  self.goProfDescLab = self:FindGO("profDescLab", self.goLeft)
  self.infoObjs.proDescLab = self.goProfDescLab:GetComponent(UILabel)
  local lbx = self:FindChild("AbilityPolygon")
  self.abilitypoint = self:FindChild("point", lbx)
  self.abilityline = self:FindChild("line", lbx)
  self.abilityPolygon = self:FindChild("PowerPolygo", lbx):GetComponent(PolygonSprite)
  self.abilityPolygon:ReBuildPolygon()
  local tips = self:FindChild("tips")
  self.initAttiLab = {}
  for i = 1, 6 do
    self.initAttiLab[i] = self:FindChild("Label" .. i, tips):GetComponent(UILabel)
  end
  self.transHairStyle = self:FindGO("hairStyle").transform
  self.transHairStyleRoot = self:FindGO("ProtocolRoot", self.transHairStyle.gameObject).transform
  self.transHeadwear = self:FindGO("Headwear").transform
  self.transHeadwearRoot = self:FindGO("ProtocolRoot", self.transHeadwear.gameObject).transform
  self.gridHairStyle = self.transHairStyleRoot:GetComponent(UIGrid)
  self.gridHeadwear = self.transHeadwearRoot:GetComponent(UIGrid)
  self.transLeft = self:FindGO("Left").transform
  self.transRight = self:FindGO("Right").transform
  self.transBottom = self:FindGO("Bottom").transform
  self.transAnchorTop = self:FindGO("AnchorTop").transform
  self.transTitle = self:FindGO("Title", self.transAnchorTop.gameObject).transform
  self.uiPlayAnim = self.gameObject:GetComponent(UIPlayAnimation)
  self.transReturnBtn = self:FindGO("returnBtn").transform
  self.goNetworkTip = self:FindGO("NetworkTip", self.gameObject)
  self.goBTNCloseNetworkTip = self:FindGO("BTN_Close", self.goNetworkTip)
  self.labNetworkTipContent = self:FindGO("Content", self.goNetworkTip):GetComponent(UILabel)
end
function CreateRoleViewV2:InitShow()
  self:UpdateProfessionInfo()
  if self.sex == E_Gender.Male then
    self.boyToggle:GetComponent(UIToggle).value = true
    self.girlToggle:GetComponent(UIToggle).value = false
    self.spBGOfCustomStyle.flip = 0
  elseif self.sex == E_Gender.Female then
    self.boyToggle:GetComponent(UIToggle).value = false
    self.girlToggle:GetComponent(UIToggle).value = true
    self.spBGOfCustomStyle.flip = 1
  end
  if self.listHeadwear == nil then
    self.listHeadwear = UIGridListCtrl.new(self.gridHeadwear, HeadwearCell, "HeadwearCell")
  end
  local headwearsData = {}
  local headwearsID = {}
  if self.sex == E_Gender.Male then
    headwearsID = CharacterPreview.accessories
  elseif self.sex == E_Gender.Female then
    headwearsID = CharacterPreview.accessories
  end
  for i = 1, #headwearsID do
    local headwearConf = Table_Item[headwearsID[i]]
    if headwearConf ~= nil then
      table.insert(headwearsData, {
        id = headwearConf.id,
        icon = headwearConf.Icon
      })
    end
  end
  self.listHeadwear:ResetDatas(headwearsData)
  self.headwearCellsCtrl = self.listHeadwear:GetCells()
  self:CancelHeadwearSelected()
  local defaultHairColor = 0
  if self.sex == E_Gender.Male then
    defaultHairColor = self:CurrentOccupationDefaltHairColorMale()
  elseif self.sex == E_Gender.Female then
    defaultHairColor = self:CurrentOccupationDefaltHairColorFemale()
  end
  if self.sex == E_Gender.Male then
    self.hairColorsID = self:CurrentOccupationHairColorSelectionsMale()
  elseif self.sex == E_Gender.Female then
    self.hairColorsID = self:CurrentOccupationHairColorSelectionsFemale()
  end
  self.hairColorSelection = defaultHairColor
  self.hindex = self:HairColorIndex(self.hairColorSelection)
  self:UpdateHairColorInfo()
  if self.listHairStyle == nil then
    self.listHairStyle = UIGridListCtrl.new(self.gridHairStyle, HairStyleCell, "HairStyleCell")
  end
  self:UpdateHairStyleSelectionView()
  self:CancelHairStyleSelected()
  self:JudgeAndSelectDefaultHairStyle()
  self.nameInput.value = self.name
end
function CreateRoleViewV2:InitRoleAgent()
  self:UpdateRoleAgent(self.sex)
end
function CreateRoleViewV2:MapViewListener()
  self:AddListenEvt(ServiceEvent.UserRecvRoleInfo, self.OnResponseCreateRoleSuccess)
  EventManager.Me():AddEventListener(CreateRoleViewEvent.PlayerMapChange, self.OnPlayerMapChangeForCreateRole, self)
  self:AddListenEvt(ServiceEvent.Error, self.OnResponseCreateRoleFail)
  self:AddListenEvt(CreateRoleViewEvent.HairStyleClick, self.OnHairStyleClick)
  self:AddListenEvt(CreateRoleViewEvent.HeadwearClick, self.OnHeadwearClick)
  self:AddListenEvt(FunctionSelectCharacterEvent.Entered, self.OnReceiveEnterFromFSC)
  self:AddListenEvt(FunctionSelectCharacterEvent.Selected, self.OnReceiveSelectedFromFSC)
  self:AddListenEvt(FunctionSelectCharacterEvent.Unselected, self.OnReceiveUnselectedFromFSC)
  self:AddListenEvt(FunctionSelectCharacterEvent.SelectedInvalidate, self.OnReceiveSelectedInvalidateFromFSC)
  self:AddListenEvt(FunctionNetError.BackToLogin, self.OnBackToLogin)
  self:AddListenEvt(ServiceEvent.ConnNetDown, self.OnReceiveNetOff)
  self:AddListenEvt(XDEUIEvent.CreateBack, function()
    if self.isSelecting then
      self:CancelOccupationSelected()
      self:PlayUIAnimBack()
      self:DisableModelRotation()
    else
      self:CloseSelf()
      self:ShutdownSelectCharacter()
      SceneProxy.Instance:SyncLoad("CharacterChoose")
      CSharpObjectForLogin.Ins():Initialize(function()
        self:sendNotification(UIEvent.ShowUI, {
          viewname = "StartGamePanel"
        })
      end)
    end
  end)
end
function CreateRoleViewV2:OnRecvReconnect(note)
  if not self.enter_tryed then
    return
  end
  if self.newRoleId ~= nil then
    self:CallSelectAndEnter(self.newRoleId)
  end
end
function CreateRoleViewV2:ChangeProfEvt(proID)
  self.nowPro = self:GetProData(proID)
  self.nowPro = self.nowPro or self.proDatas[1]
  self:UpdateProfessionInfo()
  local createData = self.nowPro.createData
  if createData.body == 0 then
    self.boyToggle:GetComponent(UIButton).isEnabled = false
    self.sex = E_Gender.Female
  else
    self.boyToggle:GetComponent(UIButton).isEnabled = true
  end
  if createData.femaleBody == 0 then
    self.girlToggle:GetComponent(UIButton).isEnabled = false
    self.sex = E_Gender.Male
  else
    self.girlToggle:GetComponent(UIButton).isEnabled = true
  end
  if self.sex == E_Gender.Male then
    self.boyToggle:GetComponent(UIToggle).value = true
  elseif self.sex == E_Gender.Female then
    self.girlToggle:GetComponent(UIToggle).value = true
  end
  self:UpdateHairColorInfo()
end
function CreateRoleViewV2:getProfessionTog(parent, name)
  local pfBtn = self:LoadPreferb("view/CreateRole/Profession")
  pfBtn.transform:SetParent(parent.transform, false)
  pfBtn.name = name
  return pfBtn
end
function CreateRoleViewV2:AddButtonEvt()
  self:AddButtonEvent("returnBtn", function(go)
    GameFacade.Instance:sendNotification(XDEUIEvent.CloseCreateRoleTip)
    if self.isSelecting then
      self:CancelOccupationSelected()
      self:PlayUIAnimBack()
      self:DisableModelRotation()
    else
      self:CloseSelf()
      self:ShutdownSelectCharacter()
      SceneProxy.Instance:SyncLoad("CharacterChoose")
      CSharpObjectForLogin.Ins():Initialize(function()
        self:sendNotification(UIEvent.ShowUI, {
          viewname = "StartGamePanel"
        })
      end)
    end
  end)
  self:AddButtonEvent("createRoleBtn", function(go)
    self:TryEnterGame()
  end, {hideClickSound = true})
  self:AddButtonEvent("sexBtn_1", function(go)
    self:ChangeSexEvt(E_Gender.Male)
  end)
  self:AddButtonEvent("sexBtn_2", function(go)
    self:ChangeSexEvt(E_Gender.Female)
  end)
  self:AddButtonEvent("hairLeftBtn", function(go)
    self:ChangeHairEvt(false)
  end)
  self:AddButtonEvent("hairRightBtn", function(go)
    self:ChangeHairEvt(true)
  end)
  self:AddDragEvent(self.goBCForDrag, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self:AddClickEvent(self.goBTNCloseNetworkTip, function()
    self.timerForCheckTimeout:StopTick()
    MsgManager.ConfirmMsgByID(1028, function()
      self:OnClickForButtonBackLogin()
    end, function()
      self.timerForCheckTimeout:StartTick()
    end)
  end)
end
function CreateRoleViewV2:ToStartGamePanelEvt(go)
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "StartGamePanel"
  })
end
function CreateRoleViewV2:TryEnterGame()
  GameFacade.Instance:sendNotification(XDEUIEvent.CloseCreateRoleTip)
  if self.enter_tryed then
    return
  end
  self.enter_tryed = true
  self:DoEnterGame()
end
function CreateRoleViewV2:DoEnterGame()
  helplog("CreateRoleViewV2 DoEnterGame")
  self.name = self.nameInput.value
  if self.name == "" then
    FunctionNetError.Me():ShowErrorById(8)
    self.enter_tryed = false
    return
  end
  if string.find(self.name, " ") or string.find(self.name, "\227\128\128") then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(7)
    self.enter_tryed = false
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(self.name, GameConfig.MaskWord.PlayerName) then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(7)
    self.enter_tryed = false
    return
  end
  local length = StringUtil.Utf8len(self.name)
  if length < GameConfig.System.namesize_min or length > GameConfig.System.namesize_max then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(9)
    self.enter_tryed = false
    return
  end
  if self.timerForCheckTimeout == nil then
    self.timerForCheckTimeout = TimeTickManager.Me():CreateTick(1000, 1000, self.OnTimeTickForCheckTimeout, self, 2)
  end
  self.timerForCheckTimeout:StartTick()
  CreateRoleViewV2.requestTime = 0
  function self.requestTimeoutEvent()
    self.goBTNCloseNetworkTip:SetActive(true)
  end
  self:RequestCreateRole()
  self.flagRequestCreateRole = true
  self:DisableInput()
  self.goNetworkTip:SetActive(true)
  self.goBTNCloseNetworkTip:SetActive(false)
end
function CreateRoleViewV2:DisableInput()
  local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, false)
  for i = 1, #colliders do
    local v = colliders[i]
    if v.gameObject.name ~= "BTN_Close" then
      v.enabled = false
    end
  end
end
function CreateRoleViewV2:EnableInput()
  local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, false)
  for i = 1, #colliders do
    local v = colliders[i]
    v.enabled = true
  end
end
function CreateRoleViewV2:RequestCreateRole()
  local defaultName = self.nameInput.value
  local codeUTF8 = LuaUtils.StrToUtf8(defaultName)
  local roleSlotIndex = UIModelRolesList.Ins():GetEmptyIndex()
  roleSlotIndex = 1
  FunctionLogin.Me():createRole(codeUTF8, self.sex, self.nowPro.createData.classID, self:CurrentOccupationHairStyleSelection(), self.hairColorSelection, CurrentOccupationBodyColor, roleSlotIndex)
end
function CreateRoleViewV2:ChangeSexEvt(gender)
  self:SwitchGender(gender)
  self.sex = gender
  local defaultHairColor = 0
  if gender == E_Gender.Male then
    defaultHairColor = self:CurrentOccupationDefaltHairColorMale()
  elseif gender == E_Gender.Female then
    defaultHairColor = self:CurrentOccupationDefaltHairColorFemale()
  end
  if self.sex == E_Gender.Male then
    self.hairColorsID = self:CurrentOccupationHairColorSelectionsMale()
  elseif self.sex == E_Gender.Female then
    self.hairColorsID = self:CurrentOccupationHairColorSelectionsFemale()
  end
  self.hairColorSelection = defaultHairColor
  self.hindex = self:HairColorIndex(self.hairColorSelection)
  self:UpdateHairColorInfo()
  self:UpdateHairStyleSelectionView()
  self:CancelHairStyleSelected()
  self:JudgeAndSelectDefaultHairStyle()
  self:CancelHeadwearSelected()
  if gender == E_Gender.Male then
    self.spBGOfCustomStyle.flip = 0
  elseif gender == E_Gender.Female then
    self.spBGOfCustomStyle.flip = 1
  end
end
function CreateRoleViewV2:ChangeHairEvt(isAdd)
  local hairColorIds = self.hairColorsID
  local length = #hairColorIds
  local toIndex = self.hindex
  if isAdd then
    toIndex = toIndex + 1
    if length < toIndex then
      toIndex = toIndex - length
    end
  else
    toIndex = toIndex - 1
    if toIndex < 1 then
      toIndex = toIndex + length
    end
  end
  toIndex = math.min(#hairColorIds, toIndex)
  toIndex = math.max(1, toIndex)
  if toIndex ~= self.hindex then
    self.hindex = toIndex
    self.hairColorSelection = self.hairColorsID[self.hindex]
    self:UpdateHairColorInfo()
    self:UpdateHairStyleSelectionView()
    self:ChangeHairColor(self.hairColorSelection)
  end
end
function CreateRoleViewV2:RotateRoleEvt(go, delta)
  local deltaAngle = -delta.x * 360 / 400
  self:RotateModel(deltaAngle)
end
function CreateRoleViewV2:UpdateProfessionInfo()
  local templab = self:FindChild("profLabel"):GetComponent(UILabel)
  templab.fontSize = templab.fontSize - 2
  OverseaHostHelper:FixLabelOverV1(templab, 3, 160)
  templab.text = self.nowPro.createData.name
  local tempsprite = self:FindChild("profSprite"):GetComponent(UISprite)
  local professionType = self.nowPro.staticData.Type
  if (professionType ~= 1 or not ColorUtil.CareerFlag1) and (professionType ~= 2 or not ColorUtil.CareerFlag2) and (professionType ~= 3 or not ColorUtil.CareerFlag3) and (professionType ~= 4 or not ColorUtil.CareerFlag4) and (professionType ~= 5 or not ColorUtil.CareerFlag5) and (professionType ~= 6 or not ColorUtil.CareerFlag6) then
    local color
  end
  tempsprite.color = color
  local templab = self:FindChild("profLabelEng"):GetComponent(UILabel)
  templab.text = self.nowPro.createData.ename
  local tempsym = self:FindChild("symbol"):GetComponent(UISprite)
  color = professionType == 1 and ColorUtil.CareerIconBg1 or professionType == 2 and ColorUtil.CareerIconBg2 or professionType == 3 and ColorUtil.CareerIconBg3 or professionType == 4 and ColorUtil.CareerIconBg4 or professionType == 5 and ColorUtil.CareerIconBg5 or professionType == 6 and ColorUtil.CareerIconBg6 or nil
  tempsym.color = color
  local spriteProfessionIcon = self:FindChild("ProfessionIcon"):GetComponent(UISprite)
  local professionIconSpriteName = self.nowPro.staticData.icon
  IconManager:SetProfessionIcon(professionIconSpriteName, spriteProfessionIcon)
  self.infoObjs.proDescLab.text = self.nowPro.staticData.Desc
  if self.lps ~= nil then
    for k, v in pairs(self.lps) do
      GameObject.DestroyImmediate(v)
    end
  end
  local temp = PolygonColor[self.number].polygonColorOut
  if temp then
    local hasC, resultC = ColorUtil.TryParseHexString(temp)
    if hasC then
      resultC.a = 0.8
      self.abilityPolygon.gradientOutside = resultC
    end
  end
  temp = PolygonColor[self.number].polygonColorIn
  if temp then
    local hasC, resultC = ColorUtil.TryParseHexString(temp)
    if hasC then
      resultC.a = 0.8
      self.abilityPolygon.gradientInside = resultC
    end
  end
  local initAttris = self.nowPro.staticData.InitialAttr
  if initAttris ~= nil and #initAttris > 0 then
    local v = {}
    for i = 1, #initAttris do
      self.initAttiLab[i].text = initAttris[i].name
      v[i] = initAttris[i].value / 100
      self.abilityPolygon:SetLength(i - 1, v[i] * 112)
    end
    self.lps = NGUIUtil.DrawAbilityPolygon(self.abilitypoint, self.abilityline, 113, v)
  end
end
function CreateRoleViewV2:UpdateHairColorInfo()
  self.hairColorSelection = self.hairColorSelection or self.hairColorsID[1]
  local hairColorInfo = Table_HairColor[self.hairColorSelection]
  if hairColorInfo == nil then
    printRed("Hair color configure not found : " .. self.hairColorSelection)
  else
    if hairColorInfo.NameZh then
      self.hairColorLab.text = hairColorInfo.NameZh
    end
    if hairColorInfo.PaintColor then
      local hasC, resultC = ColorUtil.TryParseHexString(hairColorInfo.PaintColor)
      if hasC then
        self.hairColorLab.color = resultC
      end
    end
  end
end
function CreateRoleViewV2:OnResponseCreateRoleFail(note)
  if self.flagRequestCreateRole then
    self.flagRequestCreateRole = false
    if self.timerForCheckTimeout ~= nil then
      self.timerForCheckTimeout:StopTick()
    end
    self.enter_tryed = false
    self:EnableInput()
    self.goNetworkTip:SetActive(false)
    MsgManager.CloseConfirmMsgByID(1028)
    self:PlaySelectedAnim()
    if self:IsRedName(note.body) then
      self.nameInputLabel.color = ColorUtil.NGUILabelRed
    end
  end
end
function CreateRoleViewV2:IsRedName(id)
  for i = 1, #GameConfig.CreateRoleFail.RedName do
    if GameConfig.CreateRoleFail.RedName[i] == id then
      return true
    end
  end
  return false
end
function CreateRoleViewV2:addLoadingAnim()
end
function CreateRoleViewV2:OnResponseCreateRoleSuccess(note)
  redlog("OnResponseCreateRoleSuccess 1", self.newRoleId)
  if self.newRoleId then
    self:CallSelectAndEnter(self.newRoleId)
    return
  end
  local data = ServiceUserProxy.Instance:GetNewRoleInfo()
  if data == nil then
    data = self:CheckCreatedDataByIndex()
  end
  if data == nil then
    if self.retryedCount == nil then
      self.retryedCount = 1
    else
      self.retryedCount = self.retryedCount + 1
    end
    if self.retryedCount <= 5 then
      self.enter_tryed = false
      self:TryEnterGame()
      return
    end
  end
  if data == nil then
    return
  end
  OverseaHostHelper:AFTrack("\229\144\141\229\137\141\231\153\187\233\140\178")
  self.newRoleId = data.id
  self:CallSelectAndEnter(self.newRoleId)
end
function CreateRoleViewV2:CheckCreatedDataByIndex()
  local roles = ServiceUserProxy.Instance:GetAllRoleInfos()
  if roles == nil then
    return
  end
  if self.roleIndex == nil then
    return
  end
  for _, role in pairs(roles) do
    if role.id and role.id ~= 0 and self.roleIndex == role.sequence then
      return role
    end
  end
end
function CreateRoleViewV2:CallSelectAndEnter(newRoleId)
  if self.timerForCheckTimeout ~= nil then
    self.timerForCheckTimeout:StopTick()
  end
  self.enter_tryed = false
  self:EnableInput()
  self.goNetworkTip:SetActive(false)
  MsgManager.CloseConfirmMsgByID(1028)
  self.reciveData = data
  if newRoleId ~= nil and newRoleId ~= 0 then
    self:DisableInput()
    self.goNetworkTip:SetActive(true)
    self.goBTNCloseNetworkTip:SetActive(false)
    CreateRoleViewV2.requestTime = 0
    self.timerForCheckTimeout:StartTick()
    function self.requestTimeoutEvent()
      self.goBTNCloseNetworkTip:SetActive(true)
    end
    ServicePlayerProxy.mapChangeForCreateRole = true
    ServiceUserProxy.Instance:CallSelect(newRoleId)
    UIModelRolesList.Ins():SetSelectedRole(newRoleId)
    OverSeas_TW.OverSeasManager.GetInstance():TrackEvent("rt19op")
    self:addLoadingAnim()
  end
end
function CreateRoleViewV2:OnPlayerMapChangeForCreateRole(message)
  if self.timerForCheckTimeout ~= nil then
    self.timerForCheckTimeout:StopTick()
  end
  ServicePlayerProxy.mapChangeForCreateRole = false
  self.goNetworkTip:SetActive(false)
  MsgManager.CloseConfirmMsgByID(1028)
  self:PlayHappyAnim()
  if self.maskFadeLeanTween ~= nil then
    self.maskFadeLeanTween:cancel()
  end
  local tweenStart = 0
  local tweenEnd = 1
  local tweenTime = 2.5
  self.maskFadeLeanTween = LeanTween.value(self.gameObject, function(f)
    self.mask.color = Color(0, 0, 0, f)
  end, tweenStart, tweenEnd, tweenTime)
  self.maskFadeLeanTween:setOnComplete(function()
    self:EnterInGame()
    ServicePlayerProxy.Instance:MapChange(message)
    if self.waitEnterBord then
      self.waitEnterBord:Active(true)
    end
  end):setDestroyOnComplete(true)
end
function CreateRoleViewV2:EnterInGame(note)
  local goMainCamera = GameObject.Find("Main Camera")
  if not GameObjectUtil.Instance:ObjectIsNULL(goMainCamera) then
    goMainCamera:SetActive(false)
  end
  self:CloseSelf()
  FrameRateSpeedUpChecker.Instance():Open()
end
function CreateRoleViewV2:GetProData(proID)
  for i = 1, #self.proDatas do
    local proData = self.proDatas[i]
    if proData.createData.classID == proID then
      return proData
    end
  end
  return nil
end
E_Gender = {
  None = 0,
  Male = 1,
  Female = 2
}
function CreateRoleViewV2:CurrentOccupationDefaultGender()
  local occupationConf = self.nowPro
  if occupationConf == nil then
    return E_Gender.None
  end
  local gender = occupationConf.createData.gender
  if gender == CharacterGender.Male then
    return E_Gender.Male
  elseif gender == CharacterGender.Female then
    return E_Gender.Female
  end
  return E_Gender.None
end
function CreateRoleViewV2:CurrentOccupationMaleBody()
  local occupationConf = self.nowPro
  if occupationConf == nil then
    return ""
  end
  local occupationDetailConf = self.nowPro.staticData
  return occupationDetailConf.MaleBody
end
function CreateRoleViewV2:CurrentOccupationFemaleBody()
  local occupationConf = self.nowPro
  if occupationConf == nil then
    return ""
  end
  local occupationDetailConf = self.nowPro.staticData
  return occupationDetailConf.FemaleBody
end
function CreateRoleViewV2:CurrentOccupationDefaltHairColorMale()
  return RoleUtil.GetNPCHairDefaultColor(CharacterSelectList[self.occupationIndex].maleID)
end
function CreateRoleViewV2:CurrentOccupationDefaltHairColorFemale()
  return RoleUtil.GetNPCHairDefaultColor(CharacterSelectList[self.occupationIndex].femaleID)
end
function CreateRoleViewV2:CurrentOccupationDefaultHairStyleMale()
  return FunctionSelectCharacter.Me().activeRole:GetPartID(Asset_Role.PartIndex.Hair)
end
function CreateRoleViewV2:CurrentOccupationDefaultHairStyleFemale()
  return FunctionSelectCharacter.Me().activeRole:GetPartID(Asset_Role.PartIndex.Hair)
end
function CreateRoleViewV2:CurrentOccupationHairColorSelectionsMale()
  local hairColorsID = {}
  TableUtil.deepcopy(hairColorsID, CharacterPreview.hairColorList)
  local defaultHairColor = self:CurrentOccupationDefaltHairColorMale()
  local isIncluded = false
  for i = 1, #hairColorsID do
    local hairColorID = hairColorsID[i]
    if hairColorID == defaultHairColor then
      isIncluded = true
    end
  end
  if not isIncluded then
    table.insert(hairColorsID, defaultHairColor)
  end
  return hairColorsID
end
function CreateRoleViewV2:CurrentOccupationHairColorSelectionsFemale()
  local hairColorsID = {}
  TableUtil.deepcopy(hairColorsID, CharacterPreview.hairColorList)
  local defaultHairColor = self:CurrentOccupationDefaltHairColorFemale()
  local isIncluded = false
  for i = 1, #hairColorsID do
    local hairColorID = hairColorsID[i]
    if hairColorID == defaultHairColor then
      isIncluded = true
    end
  end
  if not isIncluded then
    table.insert(hairColorsID, defaultHairColor)
  end
  return hairColorsID
end
function CreateRoleViewV2:HairColorIndex(colorID)
  if self.hairColorsID == nil then
    return -1
  end
  for i = 1, #self.hairColorsID do
    if colorID == self.hairColorsID[i] then
      return i
    end
  end
  return -1
end
function CreateRoleViewV2:CancelHairStyleSelected()
  if self.hairStyleCellsCtrl == nil then
    return
  end
  for i = 1, #self.hairStyleCellsCtrl do
    local cellCtrl = self.hairStyleCellsCtrl[i]
    if cellCtrl.isSelected == true then
      cellCtrl:CancelSelected()
    end
  end
end
function CreateRoleViewV2:CancelHeadwearSelected()
  if self.headwearCellsCtrl == nil then
    return
  end
  for i = 1, #self.headwearCellsCtrl do
    local cellCtrl = self.headwearCellsCtrl[i]
    if cellCtrl.isSelected == true then
      cellCtrl:CancelSelected()
    end
  end
end
function CreateRoleViewV2:HairStyleSelection()
  if self.hairStyleCellsCtrl == nil then
    return 0
  end
  for i = 1, #self.hairStyleCellsCtrl do
    local cellCtrl = self.hairStyleCellsCtrl[i]
    if cellCtrl.isSelected == true then
      return cellCtrl.data.hairStyleID
    end
  end
  return 0
end
function CreateRoleViewV2:CurrentOccupationHairStyleSelection()
  local currentHairStyle = 0
  currentHairStyle = self:HairStyleSelection()
  if currentHairStyle == 0 then
    if self.sex == E_Gender.Male then
      currentHairStyle = self:CurrentOccupationDefaultHairStyleMale()
    elseif self.sex == E_Gender.Female then
      currentHairStyle = self:CurrentOccupationDefaultHairStyleFemale()
    end
  end
  return currentHairStyle
end
function CreateRoleViewV2:CurrentOccupationBodyColor()
  local bodyID = 0
  if self.sex == E_Gender.Male then
    bodyID = self:CurrentOccupationMaleBody()
  elseif self.sex == E_Gender.Female then
    bodyID = self:CurrentOccupationFemaleBody()
  end
  local bodyConf = Table_Body[bodyID]
  bodyID = bodyConf.DefaultColor
  return bodyID
end
function CreateRoleViewV2:UpdateRoleAgent(gender)
  self.roleAgent = nil
  if gender == E_Gender.Male then
    self.roleAgent = self.info.maleRole
  elseif gender == E_Gender.Female then
    self.roleAgent = self.info.femaleRole
  end
end
function CreateRoleViewV2:SwitchGender(gender)
  local assignGender
  if gender == E_Gender.Male then
    assignGender = CharacterGender.Male
  elseif gender == E_Gender.Female then
    assignGender = CharacterGender.Female
  end
  FunctionSelectCharacter.Me():SwitchGender(assignGender, self.occupationIndex)
end
function CreateRoleViewV2:ChangeHairColor(hairColorID)
  FunctionSelectCharacter.Me():SetHairColor(hairColorID)
end
function CreateRoleViewV2:ChangeHairStyle(hairStyleID, hairColorID)
  FunctionSelectCharacter.Me():SetHair(hairStyleID, hairColorID)
end
function CreateRoleViewV2:RevertHairStyle()
  FunctionSelectCharacter.Me():RestoreHair()
end
function CreateRoleViewV2:ChangeHeadwear(headwearID)
  FunctionSelectCharacter.Me():SetAccessories(headwearID)
end
function CreateRoleViewV2:RevertHeadwear()
  FunctionSelectCharacter.Me():RestoreAccessories()
end
function CreateRoleViewV2:CancelOccupationSelected()
  FunctionSelectCharacter.Me():UnselectRole()
  self.isSelecting = false
end
function CreateRoleViewV2:RotateModel(angle)
  FunctionSelectCharacter.Me():Rotate(angle)
end
function CreateRoleViewV2:PlayHappyAnim()
  FunctionSelectCharacter.Me():Show()
end
function CreateRoleViewV2:PlaySelectedAnim()
  FunctionSelectCharacter.Me():Unshow()
end
function CreateRoleViewV2:OnHairStyleClick(message)
  local isSelected = message.body.isSelected
  local id = message.body.id
  if isSelected then
    self:CancelHairStyleSelected()
    self:ChangeHairStyle(id, self.hairColorSelection)
  else
    self:RevertHairStyle()
  end
end
function CreateRoleViewV2:OnHeadwearClick(message)
  local isSelected = message.body.isSelected
  local id = message.body.id
  if isSelected then
    self:CancelHeadwearSelected()
    self:ChangeHeadwear(id)
  else
    self:RevertHeadwear()
  end
end
function CreateRoleViewV2:UpdateHairStyleSelectionView()
  local hairStylesID = self:CurrentOccupationHairStylesID()
  if hairStylesID == nil then
    errorLog("Local variable hairStylesID is nil.")
  else
    local hairStylesData = {}
    for _, v in pairs(hairStylesID) do
      local hairStyleID = v
      local hairStyleData = {}
      hairStyleData.hairStyleID = hairStyleID
      hairStyleData.hairColorID = self.hairColorSelection
      hairStyleData.gender = self.sex
      hairStyleData.classID = self.occupationID
      table.insert(hairStylesData, hairStyleData)
    end
    if table.IsEmpty(hairStylesData) then
      errorLog("Local variable hairStylesData(table) is empty.")
    else
      self.listHairStyle:ResetDatas(hairStylesData)
      self.hairStyleCellsCtrl = self.listHairStyle:GetCells()
    end
  end
end
function CreateRoleViewV2:CurrentOccupationHairStylesID()
  local hairStylesID
  if self.sex == E_Gender.Male then
    hairStylesID = CharacterGender.Male.hairList
  elseif self.sex == E_Gender.Female then
    hairStylesID = CharacterGender.Female.hairList
  end
  return hairStylesID
end
function CreateRoleViewV2:GetHairStyleConfFromIDs(tab_hair_styles_id)
  local hairStylesData
  if tab_hair_styles_id ~= nil then
    hairStylesData = {}
    for i = 1, #tab_hair_styles_id do
      local hairStyleConf = Table_HairStyle[tab_hair_styles_id[i]]
      if hairStyleConf ~= nil then
        table.insert(hairStylesData, {
          id = hairStyleConf.id,
          icon = hairStyleConf.Icon
        })
      end
    end
  end
  return hairStylesData
end
function CreateRoleViewV2:ShowTitle()
  self.transReturnBtn.gameObject:SetActive(true)
  self.transLeft.gameObject:SetActive(false)
  self.transRight.gameObject:SetActive(false)
  self.transBottom.gameObject:SetActive(false)
  self.goBCForDrag:SetActive(false)
  self.transTitle.gameObject:SetActive(true)
end
function CreateRoleViewV2:HideTitle()
  self.transTitle.gameObject:SetActive(false)
end
function CreateRoleViewV2:ShowOccupationDetail()
  self.transReturnBtn.gameObject:SetActive(true)
  self.transLeft.gameObject:SetActive(true)
  self.transRight.gameObject:SetActive(true)
  self.transBottom.gameObject:SetActive(true)
  self.goBCForDrag:SetActive(true)
  self.transTitle.gameObject:SetActive(false)
end
function CreateRoleViewV2:HideOccupationDetail()
  self.transReturnBtn.gameObject:SetActive(false)
  self.transLeft.gameObject:SetActive(false)
  self.transRight.gameObject:SetActive(false)
  self.transBottom.gameObject:SetActive(false)
  self.goBCForDrag:SetActive(false)
end
function CreateRoleViewV2:PlayUIAnimForward()
  local forward = true
  self.uiPlayAnim:Play(forward)
end
function CreateRoleViewV2:PlayUIAnimBack()
  local forward = false
  self.uiPlayAnim:Play(forward)
end
function CreateRoleViewV2:OnReceiveEnterFromFSC(data)
  self:ShowTitle()
end
function CreateRoleViewV2:OnReceiveSelectedFromFSC(data)
  self.number = data.body.number
  self.info = data.body.info
  self:InitData()
  self:InitShow()
  self:ShowOccupationDetail()
  self:PlayUIAnimForward()
  self:InitRoleAgent()
  self:EnableModelRotation()
  self.isSelecting = true
  if PlayerPrefs.GetString("firstCreate") == "" then
    PlayerPrefs.SetString("firstCreate", "1")
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CreateTipPanel
    })
  end
end
function CreateRoleViewV2:OnReceiveUnselectedFromFSC(data)
  self:ShowTitle()
end
function CreateRoleViewV2:OnReceiveSelectedInvalidateFromFSC(data)
  MsgManager.ShowMsgByIDTable(1002)
end
function CreateRoleViewV2:EnableModelRotation()
  self.bcForDrag.enabled = true
end
function CreateRoleViewV2:DisableModelRotation()
  self.bcForDrag.enabled = false
end
function CreateRoleViewV2:OnBackToLogin()
  self:PlayUIAnimBack()
end
function CreateRoleViewV2:ShutdownSelectCharacter()
  FunctionSelectCharacter.Me():Shutdown()
end
function CreateRoleViewV2:JudgeAndSelectDefaultHairStyle()
  local iDefaultHairStyle = 0
  if self.sex == E_Gender.Male then
    iDefaultHairStyle = self:CurrentOccupationDefaultHairStyleMale()
  elseif self.sex == E_Gender.Female then
    iDefaultHairStyle = self:CurrentOccupationDefaultHairStyleFemale()
  end
  local hairStylesID = self:CurrentOccupationHairStylesID()
  for i = 1, #hairStylesID do
    if hairStylesID[i] == iDefaultHairStyle then
      table.remove(hairStylesID, i)
      table.insert(hairStylesID, 1, iDefaultHairStyle)
      break
    end
  end
  local hairStylesData = {}
  for _, v in pairs(hairStylesID) do
    local hairStyleID = v
    local hairStyleData = {}
    hairStyleData.hairStyleID = hairStyleID
    hairStyleData.hairColorID = self.hairColorSelection
    hairStyleData.gender = self.sex
    hairStyleData.classID = self.occupationID
    table.insert(hairStylesData, hairStyleData)
  end
  self.listHairStyle:ResetDatas(hairStylesData)
  self.hairStyleCellsCtrl = self.listHairStyle:GetCells()
  iDefaultHairStyle = iDefaultHairStyle or 0
  self:SelectHairStyle(iDefaultHairStyle)
end
function CreateRoleViewV2:SelectHairStyle(i_hair_style_id)
  if self.hairStyleCellsCtrl ~= nil then
    for _, hairStyleCellCtrl in pairs(self.hairStyleCellsCtrl) do
      if hairStyleCellCtrl.data.hairStyleID == i_hair_style_id then
        hairStyleCellCtrl:Selected()
        break
      end
    end
  end
end
function CreateRoleViewV2:CloseMainCamera()
  local gameObjectMainCamera = GameObject.FindGameObjectWithTag("MainCamera")
  if gameObjectMainCamera then
    local mainCamera = gameObjectMainCamera:GetComponent("Camera")
    mainCamera.enabled = false
  end
end
function CreateRoleViewV2:OnReceiveNetOff()
  self:CloseMainCamera()
  self:Hide()
end
function CreateRoleViewV2:CalibrateViewPortOfUICamera()
  if self.tickForFindMainCamera == nil then
    self.tickForFindMainCamera = TimeTickManager.Me():CreateTick(0, 1000, self.OnTimeTickForFindMainCamera, self, 1)
  end
end
function CreateRoleViewV2:OnTimeTickForFindMainCamera()
  local goMainCamera = GameObject.Find("Main Camera")
  if goMainCamera ~= nil then
    local transCameraUsedForDebugBlink = goMainCamera.transform:Find("CameraUsedForDebugBlink")
    if transCameraUsedForDebugBlink ~= nil then
      local camera = transCameraUsedForDebugBlink:GetComponent(Camera)
      if camera ~= nil then
        local viewPort = camera.rect
        viewPort.x = 0
        viewPort.y = 0
        viewPort.width = 1
        viewPort.height = 1
        camera.rect = viewPort
      end
    end
    self:CloseTimeTickForFindMainCamera()
  end
end
function CreateRoleViewV2:CloseTimeTickForFindMainCamera()
  TimeTickManager.Me():ClearTick(self, 1)
  self.tickForFindMainCamera = nil
end
function CreateRoleViewV2:GoToSelectRole()
  self:CloseSelf()
  self:ShutdownSelectCharacter()
  SceneProxy.Instance:SyncLoad("CharacterChoose")
  CSharpObjectForLogin.Ins():Initialize(function()
    local cameraController = CSharpObjectForLogin.Ins():GetCameraController()
    cameraController:GoToSelectRole()
    UIRoleSelect.Ins():Open()
  end)
end
function CreateRoleViewV2:OnTimeTickForCheckTimeout()
  CreateRoleViewV2.requestTime = CreateRoleViewV2.requestTime + 1
  if CreateRoleViewV2.requestTime >= GameConfig.LoginRole.requestOuttime then
    self.timerForCheckTimeout:StopTick()
    if self.requestTimeoutEvent ~= nil then
      self.requestTimeoutEvent()
    end
  end
end
function CreateRoleViewV2:CloseTimeTickForCheckTimeout()
  TimeTickManager.Me():ClearTick(self, 2)
  self.timerForCheckTimeout = nil
end
function CreateRoleViewV2:OnClickForButtonContinueWait()
  self.timerForCheckTimeout:StartTick()
  CreateRoleViewV2.requestTime = 0
end
function CreateRoleViewV2:OnClickForButtonBackLogin()
  Game.Me():BackToLogo()
end
function CreateRoleViewV2:OnEnter()
  CreateRoleViewV2.super.OnEnter(self)
  self.roleIndex = self.viewdata.index
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    if self.isSelecting then
      self:CancelOccupationSelected()
      self:PlayUIAnimBack()
      self:DisableModelRotation()
    else
      self:GoToSelectRole()
    end
  end)
end
return CreateRoleViewV2
