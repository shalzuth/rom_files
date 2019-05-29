autoImport("ProfessionBaseView")
autoImport("BaseAttributeCell")
ProfessionInfoViewMP = class("ProfessionInfoViewMP", ProfessionBaseView)
local tempVector3 = LuaVector3.zero
ProfessionInfoViewMP.LeftBtnClick = "ProfessionInfoViewMP.LeftBtnClick"
ProfessionInfoViewMP.LeftBtnClick2 = "ProfessionInfoViewMP.LeftBtnClick2"
ProfessionInfoViewMP.LeftBtnClick3 = "ProfessionInfoViewMP.LeftBtnClick3"
ProfessionInfoViewMP.LeftBtnClick4 = "ProfessionInfoViewMP.LeftBtnClick4"
MPShowType = {
  FromSave = 1,
  FromSelf = 2,
  FromPurchasePreview = 3
}
function ProfessionInfoViewMP:Init()
  self:initView()
  self:initData()
  self:ResetData()
  self:AddCloseButtonEvent()
end
function ProfessionInfoViewMP:initData()
  self.currentPfn = nil
  local userData = Game.Myself.data.userdata
  self.sex = userData:Get(UDEnum.SEX)
  self.hair = userData:Get(UDEnum.HAIR)
  self.eye = userData:Get(UDEnum.EYE)
  self.branch = 0
end
function ProfessionInfoViewMP:initSelfObj()
  self.parentObj = self:FindGO("professionInfoView")
  self.gameObject = self:LoadPreferb("view/ProfessionInfoViewMP", self.parentObj)
  self.ProfessionInfoViewMP_UIPanel = self.gameObject:GetComponent(UIPanel)
end
function ProfessionInfoViewMP:initView()
  ProfessionInfoViewMP.super.initView(self)
  local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel)
  local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  self.ProfessionInfoViewMP_UIPanel.depth = panel.depth + 1
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
  self.gameObject.transform.localPosition = Vector3(221.79, 11, 0)
  local grid = self:FindGO("professionSkillGrid"):GetComponent(UIGrid)
  self.gridList = UIGridListCtrl.new(grid, ProfessionSkillCell, "ProfessionSkillCell")
  self.gridList:AddEventListener(MouseEvent.MouseClick, self.clickHandler, self)
  self.whitebgSP = self:FindGO("whitebgSP")
  self.SaveLoad = self:FindGO("SaveLoad")
  self.lockContent = self:FindGO("lockContent")
  self.titleBg = self:FindGO("titleBg")
  self.titleBg.gameObject:SetActive(false)
  self.titleBg_1 = self:FindGO("titleBg_1")
  self.titleBg_1.gameObject:SetActive(false)
  self.ScrollView = self:FindGO("ScrollView", self.lockContent)
  self.ScrollView_UIPanel = self.ScrollView:GetComponent(UIPanel)
  self.EquipBtn = self:FindGO("EquipBtn", self.whitebgSP)
  self.AstroBtn = self:FindGO("AstroBtn", self.whitebgSP)
  self.AstroBtn_UIButton = self:FindGO("AstroBtn", self.whitebgSP):GetComponent(UIButton)
  self.AstroBtn_UIButton.enabled = false
  self.AstroBtnUISprite = self:FindGO("AstroBtn", self.whitebgSP):GetComponent(UISprite)
  self.SkillBtn = self:FindGO("SkillBtn", self.whitebgSP)
  self.EquipBtn_UISprite = self:FindGO("Sprite", self.EquipBtn):GetComponent(UISprite)
  self.AstroBtn_UISprite = self:FindGO("Sprite", self.AstroBtn):GetComponent(UISprite)
  self.SkillBtn_UISprite = self:FindGO("Sprite", self.SkillBtn):GetComponent(UISprite)
  IconManager:SetUIIcon("equip_Details", self.EquipBtn_UISprite)
  IconManager:SetItemIcon("item_5501", self.AstroBtn_UISprite)
  self.DownLabelsGrid = self:FindGO("DownLabelsGrid", self.whitebgSP)
  self.Btn5 = self:FindGO("Btn5", self.whitebgSP)
  self.DownLabelsGrid = self:FindGO("DownLabelsGrid", self.whitebgSP)
  self.propSecGrid = self:FindGO("propSecGrid")
  self.old = self:FindGO("old")
  self:DestroyTargetAllChildren(self.propSecGrid)
  self.whitebgSP.gameObject:SetActive(false)
  self.SaveLoad.gameObject:SetActive(false)
  self.ScrollView.gameObject.transform.localPosition = Vector3(6.5, -37, 0)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateTitleInfo)
  self.whitebgSP.gameObject:SetActive(true)
  self.DownLabelsGrid.gameObject:SetActive(false)
  self.DownLabelsGrid_UIGrid = self.DownLabelsGrid:GetComponent(UIGrid)
  self.propSecGrid_UIGrid = self.propSecGrid:GetComponent(UIGrid)
  self.baseGridList = UIGridListCtrl.new(self.propSecGrid_UIGrid, BaseAttributeCell, "BaseAttrCell")
  local CloseButton = self:FindGO("CloseButton")
  CloseButton.gameObject:SetActive(false)
  self:InitMP()
  self.EquipBtnIsOpen = false
  self:AddClickEvent(self.EquipBtn.gameObject, function()
    if not self.EquipBtnIsOpen then
      self.EquipBtnIsOpen = true
      if GameConfig.SystemForbid.MultiProfession then
        MsgManager.ShowMsgByID(25413)
        return
      end
      local sdata = BranchInfoSaveProxy.Instance:GetUsersaveData(self.branch)
      local dataToDetail = {}
      if self.branch == ProfessionProxy.Instance:GetCurTypeBranch() then
        dataToDetail.showType = MPShowType.FromSelf
        self:PassEvent(ProfessionInfoViewMP.LeftBtnClick, dataToDetail)
      elseif sdata then
        dataToDetail.showType = MPShowType.FromSave
        dataToDetail.userSaveInfoData = sdata
        self:PassEvent(ProfessionInfoViewMP.LeftBtnClick, dataToDetail)
      else
        dataToDetail.showType = MPShowType.FromPurchasePreview
        self:PassEvent(ProfessionInfoViewMP.LeftBtnClick, dataToDetail)
      end
    else
      self.EquipBtnIsOpen = false
      self:PassEvent(ProfessionInfoViewMP.LeftBtnClick, nil)
    end
  end)
  self.AstroBtnIsOpen = false
  self:AddClickEvent(self.AstroBtn.gameObject, function()
    if not self:IsShenBeiOpen(true) then
      return
    end
    if GameConfig.SystemForbid.MultiProfession then
      MsgManager.ShowMsgByID(25413)
      return
    end
    if MyselfProxy.Instance:IsUnlockAstrolabe() == false then
      MsgManager.ShowMsgByID(25433)
      return
    end
    local sdata = BranchInfoSaveProxy.Instance:GetUsersaveData(self.branch)
    local dataToDetail = {}
    if self.branch == ProfessionProxy.Instance:GetCurTypeBranch() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AstrolabeView,
        viewdata = {FromProfessionInfoViewMP = true}
      })
    elseif sdata then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AstrolabeView,
        viewdata = {
          saveId = self.branch,
          saveType = SaveInfoEnum.Branch
        }
      })
    else
      MsgManager.ShowMsgByID(25433)
    end
  end)
  self.SkillBtnIsOpen = false
  self:AddClickEvent(self.SkillBtn.gameObject, function()
    if GameConfig.SystemForbid.MultiProfession then
      MsgManager.ShowMsgByID(25413)
      return
    end
    local sdata = BranchInfoSaveProxy.Instance:GetUsersaveData(self.branch)
    if sdata then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CharactorProfessSkill,
        viewdata = {
          saveId = self.branch,
          saveType = SaveInfoEnum.Branch
        }
      })
    else
      MsgManager.ShowMsgByID(25435)
    end
  end)
end
function ProfessionInfoViewMP:IsShenBeiOpen(needShowMsg)
  if FunctionUnLockFunc.Me():CheckCanOpen(5000) == false then
    return false
  end
  local thisHeadId = self.obj:GetId()
  if ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisHeadId) then
    if thisHeadId % 10 <= 1 then
      if needShowMsg then
        MsgManager.ShowMsgByID(25438)
      end
      return false
    else
      return true
    end
  else
    if needShowMsg then
      MsgManager.ShowMsgByID(25438)
    end
    return false
  end
  if thisHeadId == MyselfProxy.Instance:GetMyProfession() and thisHeadId % 10 <= 1 then
    if needShowMsg then
      MsgManager.ShowMsgByID(25438)
    end
    return false
  end
  return true
end
function ProfessionInfoViewMP:DestroyTargetAllChildren(target)
  if target == nil then
    return
  end
  for i = 0, target.transform.childCount - 1 do
    local go = target.transform:GetChild(0)
    if go == nil then
    end
    GameObject.DestroyImmediate(go.gameObject)
  end
end
function ProfessionInfoViewMP:clickHandler(target)
  local skillId = target.data
  local skillItem = SkillItemData.new(skillId)
  local tipData = {}
  tipData.data = skillItem
  TipsView.Me():ShowTip(SkillTip, tipData, "SkillTip")
  local tip = TipsView.Me().currentTip
  if tip then
    tempVector3:Set(0, 0, 0)
    tip.gameObject.transform.localPosition = tempVector3
  end
end
function ProfessionInfoViewMP:showInfo(data)
  self.currentPfn = data
  if data == nil then
    self:Hide(self.parentObj)
    return
  end
  self:Show(self.parentObj)
  self:ResetData()
end
function ProfessionInfoViewMP:multiProfessionInfo(obj)
  if obj == nil then
    self:PassEvent(ProfessionInfoViewMP.LeftBtnClick, nil)
    self:Hide(self.parentObj)
    return
  end
  self.currentPfn = obj.data
  self.obj = obj
  if self.currentPfn == nil then
    self:Hide(self.parentObj)
    return
  end
  self:Show(self.parentObj)
  self:ResetData()
  local state = obj:GetHeadIconState() or 0
  self.branch = self.currentPfn.TypeBranch or 0
  local id = obj:GetId() or 0
  self.selectedID = self.branch
  self.jiuzhiban.gameObject:SetActive(false)
  self.old.gameObject:SetActive(true)
  self.HintLabel.gameObject:SetActive(false)
  self.NilTip.gameObject:SetActive(false)
  self.SkillColumns.gameObject:SetActive(false)
  self.NextBtn.gameObject.transform.localRotation = Vector3(0, 0, 0)
  self.HintLabel.transform.localPosition = Vector3(-204.7, -296, 0)
  self.Purchase.gameObject:SetActive(false)
  self.Purchase_zeny.gameObject:SetActive(false)
  if not self:IsShenBeiOpen(false) then
    local sprites = UIUtil.GetAllComponentsInChildren(self.AstroBtnUISprite, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    end
  else
    local sprites = UIUtil.GetAllComponentsInChildren(self.AstroBtnUISprite, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(1, 1, 1)
    end
  end
  if ProfessionProxy.Instance:IsMPOpen() then
    if id % 10 == 1 and ProfessionProxy.Instance:IsThisIdYiGouMai(id) and (state == 1 or state == 3) then
      self:ShowGouMaiBan(obj)
      self:ShowJobManJiZongJiaCheng(id)
      self.HintLabel.gameObject:SetActive(true)
      self.HintLabel.transform.localPosition = Vector3(-204.7, -244, 0)
    elseif id % 10 == 2 and ProfessionProxy.Instance:IsThisIdYiGouMai(id) and not ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) and state == 7 then
      self:ShowQieHuanBan(obj)
      self:ShowRenWuXinXi(id)
      self.currentPfn = obj:GetPreviousCell().data
      if self.currentPfn then
        self:ResetData()
      end
    else
      if state == 1 and branch ~= 0 then
        self:ShowQieHuanBan(obj)
        self:ShowRenWuXinXi(id)
      end
      if state == 2 and branch ~= 0 then
        self:ShowJieShaoBan(obj)
        self:ShowJobManJiZongJiaCheng(id)
      end
      if state == 3 and branch ~= 0 then
        self:ShowQieHuanBan(obj)
        self:ShowRenWuXinXi(id)
      end
      if state == 4 and branch ~= 0 then
        self:ShowJiuZhiBan(obj)
        self:ShowJobManJiZongJiaCheng(id)
      end
      if state == 5 and branch ~= 0 then
        self:ShowJieShaoBan(obj)
        self:ShowJobManJiZongJiaCheng(id)
      end
      if state == 6 and branch ~= 0 then
        self:ShowGouMaiBan(obj)
        self:ShowJobManJiZongJiaCheng(id)
      end
      if state == 7 and branch ~= 0 then
        self:ShowQieHuanBan(obj)
        self:ShowRenWuXinXi(id)
      end
    end
  elseif state == 4 and branch ~= 0 then
    self:ShowJiuZhiBan(obj)
    self:ShowJobManJiZongJiaCheng(id)
  else
    self:ShowJieShaoBan(obj)
    self:ShowJobManJiZongJiaCheng(id)
  end
end
function ProfessionInfoViewMP:ShowZuoXiaJiaoShuXing(jobLevel, typeBranch)
  local list = {}
  for i = 1, #GameConfig.ClassInitialAttr do
    local single = GameConfig.ClassInitialAttr[i]
    local prop = Game.Myself.data.props[single]
    local value = CommonFun.calProfessionPropValue(jobLevel, typeBranch, single)
    if value >= 0 then
      local data = {}
      data.name = prop.propVO.displayName .. prop.propVO.name
      data.value = value
      table.insert(list, data)
    else
      local data = {}
      data.name = prop.propVO.displayName .. prop.propVO.name
      data.value = 0
      table.insert(list, data)
    end
  end
  self.propertyCt_qiehuanbanList:ResetDatas(list)
  self.propertyCt_jieshaobanList:ResetDatas(list)
  self.propertyCt_goumaibanList:ResetDatas(list)
end
function ProfessionInfoViewMP:ShowJobManJiZongJiaCheng(id)
  local thisIdClass = Table_Class[id]
  self:ShowZuoXiaJiaoShuXing(thisIdClass.MaxJobLevel, thisIdClass.TypeBranch)
end
function ProfessionInfoViewMP:ShowRenWuXinXi(id)
  if id == MyselfProxy.Instance:GetMyProfession() then
    local usedAstro = AstrolabeProxy.Instance:GetActiveStarPoints(nil)
    local totalAstro = AstrolabeProxy.Instance:GetTotalPointCount()
    local usedSkill = SkillProxy.Instance:GetUsedPoints()
    local totalSkill = Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT) + usedSkill
    self.qiehuanban_jnjdKeyUILabel.text = usedSkill .. "/" .. totalSkill
    self.qiehuanban_jnjdKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
    local xpkey = 0
    if type(usedAstro) == "table" then
      xpkey = #usedAstro
    elseif type(usedAstro) == "number" then
      xpkey = usedAstro
    end
    self.qiehuanban_xpKeyUILabel.text = xpkey .. "/" .. totalAstro
    self.qiehuanban_xpKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
    self.qiehuanban_jobNameUILabel.text = "Job:"
    self.qiehuanban_jobKeyUILabel.text = "Lv." .. ProfessionProxy.Instance:GetThisJobLevelForClient(id, MyselfProxy.Instance:JobLevel())
    self.qiehuanban_jobKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
    self.qiehuanban_jnjdNameUILabel.text = ZhString.ProfessionInfoViewMP_AddSkillPointTip
    local thisIdClass = Table_Class[id]
    self:ShowCurProfessionProp()
    self:showShuXinBySelf(thisIdClass.TypeBranch)
    self.previewbg.gameObject:SetActive(true)
    self.NextBtn.gameObject:SetActive(true)
    self.NilTip.gameObject:SetActive(false)
  else
    local thisIdClass = Table_Class[id]
    local typeBranch = thisIdClass.TypeBranch
    local _BranchInfoSaveProxy = BranchInfoSaveProxy.Instance
    local saveProfession = _BranchInfoSaveProxy:GetProfession(typeBranch)
    if saveProfession ~= nil then
      local usedAstro = _BranchInfoSaveProxy:GetActiveStars(typeBranch)
      local totalAstro = AstrolabeProxy.Instance:GetTotalPointCount()
      local usedSkill = _BranchInfoSaveProxy:GetUsedPoints(typeBranch)
      local totalSkill = usedSkill + _BranchInfoSaveProxy:GetUnusedSkillPoint(typeBranch)
      local joblv = _BranchInfoSaveProxy:GetJobLevel(typeBranch)
      local job = _BranchInfoSaveProxy:GetProfession(typeBranch)
      local props = _BranchInfoSaveProxy:GetProps(typeBranch)
      local list = {}
      self.qiehuanban_xpNameUILabel.text = ZhString.ProfessionInfoViewMP_AstrolabeTip
      self.qiehuanban_jnjdKeyUILabel.text = usedSkill .. "/" .. totalSkill
      self.qiehuanban_jnjdKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
      local xpkey = 0
      if type(usedAstro) == "table" then
        xpkey = #usedAstro
      elseif type(usedAstro) == "number" then
        xpkey = usedAstro
      end
      self.qiehuanban_xpKeyUILabel.text = xpkey .. "/" .. totalAstro
      self.qiehuanban_xpKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
      self.qiehuanban_jobNameUILabel.text = "Job:"
      self.qiehuanban_jobKeyUILabel.text = "Lv." .. ProfessionProxy.Instance:GetThisJobLevelForClient(job, joblv)
      self.qiehuanban_jobKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
      self.qiehuanban_jnjdNameUILabel.text = ZhString.ProfessionInfoViewMP_AddSkillPointTip
      for i = 1, #GameConfig.SavePreviewAttrMain do
        local single = GameConfig.SavePreviewAttrMain[i]
        local test = props:GetPropByName(single)
        local data = {}
        data.name = test.propVO.displayName
        data.value = test.value
        table.insert(list, data)
      end
      self.propertyCt_qiehuanbanList:ResetDatas(list)
      self.propertyCt_jieshaobanList:ResetDatas(list)
      self.propertyCt_goumaibanList:ResetDatas(list)
      self:showShuXinBySave(thisIdClass.TypeBranch)
      self.previewbg.gameObject:SetActive(true)
      self.NextBtn.gameObject:SetActive(true)
      self.NilTip.gameObject:SetActive(false)
    else
      self.qiehuanban_xpNameUILabel.text = ZhString.ProfessionInfoViewMP_AstrolabeTip
      self.qiehuanban_jnjdKeyUILabel.text = "0/0"
      self.qiehuanban_jnjdKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
      self.qiehuanban_xpKeyUILabel.text = "0/0"
      self.qiehuanban_xpKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
      self.qiehuanban_jobNameUILabel.text = "Job:"
      self.qiehuanban_jobKeyUILabel.text = "Lv.0"
      self.qiehuanban_jobKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
      self.qiehuanban_jnjdNameUILabel.text = ZhString.ProfessionInfoViewMP_AddSkillPointTip
      local thisIdClass = Table_Class[id]
      self:ShowZuoXiaJiaoShuXing(thisIdClass.MaxJobLevel, thisIdClass.TypeBranch)
      self.baseGridList:RemoveAll()
      self.ManualGridList:RemoveAll()
      self.AutoGridList:RemoveAll()
      self.previewbg.gameObject:SetActive(true)
      self.NextBtn.gameObject:SetActive(true)
      self.NilTip.gameObject:SetActive(true)
    end
  end
  self:RefreshShortCuts()
  self:RefreshShortCutsIcon()
end
function ProfessionInfoViewMP:ShowCurProfessionProp()
  local list = {}
  local props = Game.Myself.data.props
  local ClassInitialAttr = GameConfig.ClassInitialAttr
  for i = 1, #ClassInitialAttr do
    local single = ClassInitialAttr[i]
    local prop = props[single]
    local value = prop:GetValue()
    if value >= 0 then
      local data = {}
      data.name = prop.propVO.displayName .. prop.propVO.name
      data.value = value
      table.insert(list, data)
    else
      local data = {}
      data.name = prop.propVO.displayName .. prop.propVO.name
      data.value = 0
      table.insert(list, data)
    end
  end
  self.propertyCt_qiehuanbanList:ResetDatas(list)
end
function ProfessionInfoViewMP:InitMP()
  self.goumaiban = self:FindGO("goumaiban")
  self.commonban = self:FindGO("commonban")
  self.jieshaoban = self:FindGO("jieshaoban")
  self.qiehuanban = self:FindGO("qiehuanban")
  self.jiuzhiban = self:FindGO("jiuzhiban", self.jieshaoban)
  self.propertyCt_GO = self:FindGO("propertyCt")
  self.propGrid_GO = self:FindGO("propGrid", self.propertyCt_GO)
  self.propGrid_UIGrid = self.propGrid_GO:GetComponent(UIGrid)
  self.propDes_GO = self:FindGO("propDes", self.propertyCt_GO)
  self.propDes_GO.gameObject:SetActive(false)
  self.Switch = self:FindGO("Switch", self.qiehuanban)
  self.SwitchBtn = self:FindGO("SwitchBtn", self.Switch)
  self.SwitchBtn_UISprite = self.SwitchBtn:GetComponent(UISprite)
  self.SwitchBtn_PriceUILabel = self:FindGO("Price", self.SwitchBtn):GetComponent(UILabel)
  self.Switch_grey = self:FindGO("Switch_grey", self.qiehuanban)
  self.SwitchBtn_grey = self:FindGO("SwitchBtn", self.Switch_grey)
  self.SwitchBtn_greyPriceUILabel = self:FindGO("Price", self.SwitchBtn_grey):GetComponent(UILabel)
  self.Purchase = self:FindGO("Purchase", self.goumaiban)
  self.PurchaseBtn = self:FindGO("PurchaseBtn", self.Purchase)
  self.Purchase.gameObject:SetActive(false)
  self.PurchaseIcon_UISprite = self:FindGO("Icon", self.Purchase):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", self.PurchaseIcon_UISprite)
  self.PurchaseBtn_PriceUILabel = self:FindGO("Price", self.Purchase):GetComponent(UILabel)
  self.Purchase_zeny = self:FindGO("Purchase_zeny", self.goumaiban)
  self.PurchaseBtn_zeny = self:FindGO("PurchaseBtn", self.Purchase_zeny)
  self.PurchaseBtn_zenyPirceUILabel = self:FindGO("Price", self.Purchase_zeny):GetComponent(UILabel)
  self.Purchase_zeny.gameObject:SetActive(false)
  self.lockContent.gameObject:SetActive(true)
  self.qiehuanban_job = self:FindGO("job", self.qiehuanban)
  self.qiehuanban_jobNameUILabel, self.qiehuanban_jobKeyUILabel = self:FindKeyAndValueUILabelUnderThis(self.qiehuanban_job)
  self.qiehuanban_jobNameUILabel.fontSize = 18
  self.qiehuanban_jobKeyUILabel.fontSize = 18
  self.qiehuanban_jobKeyUILabel.transform.localPosition = Vector3(60, 0, 0)
  self.qiehuanban_jinengjiadian = self:FindGO("jinengjiadian", self.qiehuanban)
  self.qiehuanban_jnjdNameUILabel, self.qiehuanban_jnjdKeyUILabel = self:FindKeyAndValueUILabelUnderThis(self.qiehuanban_jinengjiadian)
  self.qiehuanban_jnjdNameUILabel.fontSize = 18
  self.qiehuanban_jnjdKeyUILabel.fontSize = 18
  OverseaHostHelper:FixLabelOverV1(self.qiehuanban_jnjdNameUILabel, 3, 100)
  OverseaHostHelper:FixLabelOverV1(self.qiehuanban_jnjdKeyUILabel, 2, 100)
  self.qiehuanban_jnjdNameUILabel.transform.localPosition = Vector3(2, 1, 0)
  self.qiehuanban_jnjdKeyUILabel.pivot = UIWidget.Pivot.Left
  self.qiehuanban_jnjdKeyUILabel.transform.localPosition = Vector3(104, 0, 0)
  self.qiehuanban_xingpan = self:FindGO("xingpan", self.qiehuanban)
  self.qiehuanban_xpNameUILabel, self.qiehuanban_xpKeyUILabel = self:FindKeyAndValueUILabelUnderThis(self.qiehuanban_xingpan)
  self.qiehuanban_xpNameUILabel.fontSize = 18
  self.qiehuanban_xpKeyUILabel.fontSize = 18
  OverseaHostHelper:FixLabelOverV1(self.qiehuanban_xpNameUILabel, 2, 100)
  OverseaHostHelper:FixLabelOverV1(self.qiehuanban_xpKeyUILabel, 2, 100)
  self.qiehuanban_xpNameUILabel.transform.localPosition = Vector3(2, 0, 0)
  self.qiehuanban_xpKeyUILabel.pivot = UIWidget.Pivot.Left
  self.qiehuanban_xpKeyUILabel.transform.localPosition = Vector3(60, 0, 0)
  self.jieshaoban_zhiyetese = self:FindGO("zhiyetese", self.jieshaoban)
  self.jieshaoban_zytsNameUILabel, self.jieshaoban_zytsKeyUILabel = self:FindKeyAndValueUILabelUnderThis(self.jieshaoban_zhiyetese)
  self.jieshaoban_jiuzhitiaojian = self:FindGO("jiuzhitiaojian", self.jieshaoban)
  self.jieshaoban_jztjNameUILabel, self.jieshaoban_jztjKeyUILabel = self:FindKeyAndValueUILabelUnderThis(self.jieshaoban_jiuzhitiaojian)
  self.goumaiban_zhiyetese = self:FindGO("zhiyetese", self.goumaiban)
  self.goumaiban_zytsNameUILabel, self.goumaiban_zytsKeyUILabel = self:FindKeyAndValueUILabelUnderThis(self.goumaiban_zhiyetese)
  self.propSecGrid = self:FindGO("propSecGrid")
  self.previewbg = self:FindGO("previewbg", self.whitebgSP)
  self.NextBtn = self:FindGO("NextBtn", self.whitebgSP)
  self.SkillColumns = self:FindGO("SkillColumns", self.whitebgSP)
  self.SkillColumns.gameObject:SetActive(false)
  self.ManualGrid = self:FindGO("ManualGrid", self.SkillColumns)
  self.ManualGrid_UIGrid = self.ManualGrid:GetComponent(UIGrid)
  self.ManualGridList = UIGridListCtrl.new(self.ManualGrid_UIGrid, ShortCutSkillDragCell, "ShortCutSkillDragCell")
  self.AutoGrid = self:FindGO("AutoGrid", self.SkillColumns)
  self.AutoGrid_UIGrid = self.AutoGrid:GetComponent(UIGrid)
  self.AutoGridList = UIGridListCtrl.new(self.AutoGrid_UIGrid, ShortCutSkillDragCell, "ShortCutSkillDragCell")
  self.gou = self:FindGO("gou", self.jieshaoban)
  self.cha = self:FindGO("cha", self.jieshaoban)
  self.gou.gameObject:SetActive(false)
  self.cha.gameObject:SetActive(false)
  self.qiehuanban_mokuai = {
    self.whitebgSP,
    self.propSecGrid,
    self.previewbg,
    self.NextBtn,
    self.SkillColumns,
    self.Switch,
    self.Switch_grey
  }
  self.HintLabel = self:FindGO("HintLabel", self.old)
  self.HintLabel_name = self:FindGO("name", self.HintLabel)
  self.HintLabel_nameUILabel = self.HintLabel_name:GetComponent(UILabel)
  self.HintLabel_nameUILabel.text = ZhString.ProfessionInfoViewMP_HintLabel
  self.jiuzhiban.gameObject:SetActive(false)
  self.jiuzhiBtn = self:FindGO("jiuzhiBtn", self.jiuzhiban)
  self.propertyCt_goumaiban = self:FindGO("propertyCt_goumaiban", self.goumaiban)
  self.propertyCt_goumaibanUIGrid = self:FindGO("propGrid", self.propertyCt_goumaiban):GetComponent(UIGrid)
  self.propertyCt_goumaibanList = self.propertyCt_goumaibanList or UIGridListCtrl.new(self.propertyCt_goumaibanUIGrid, ProfessionInfoPanelCell, "ProfessionInfoPanelCell")
  self.propertyCt_qiehuanban = self:FindGO("propertyCt_qiehuanban", self.qiehuanban)
  self.propertyCt_qiehuanbanUIGrid = self:FindGO("propGrid", self.propertyCt_qiehuanban):GetComponent(UIGrid)
  self.propertyCt_qiehuanbanList = self.propertyCt_qiehuanbanList or UIGridListCtrl.new(self.propertyCt_qiehuanbanUIGrid, ProfessionInfoPanelCell, "ProfessionInfoPanelCell")
  self.propertyCt_jieshaoban = self:FindGO("propertyCt_jieshaoban", self.jieshaoban)
  self.propertyCt_jieshaobanUIGrid = self:FindGO("propGrid", self.propertyCt_jieshaoban):GetComponent(UIGrid)
  self.propertyCt_jieshaobanList = self.propertyCt_jieshaobanList or UIGridListCtrl.new(self.propertyCt_jieshaobanUIGrid, ProfessionInfoPanelCell, "ProfessionInfoPanelCell")
  self.NilTip = self:FindGO("NilTip", self.qiehuanban)
  self.NilTip_UILabel = self.NilTip:GetComponent(UILabel)
  self.NilTip_UILabel.text = ZhString.ProfessionInfoViewMP_NilTip
  self:InitSwitchShortCut()
  self:AddClickEvent(self.NextBtn.gameObject, function()
    if self.NilTip.gameObject.activeInHierarchy then
      return
    end
    if self.isShowShuXin then
      self.propSecGrid.gameObject:SetActive(false)
      self.SkillColumns.gameObject:SetActive(true)
      self.isShowShuXin = false
      self.NextBtn.gameObject.transform.localRotation = Vector3(0, 0, 180)
    else
      self.propSecGrid.gameObject:SetActive(true)
      self.SkillColumns.gameObject:SetActive(false)
      self.isShowShuXin = true
      self.NextBtn.gameObject.transform.localRotation = Vector3(0, 0, 0)
    end
  end)
  local qiehuanban_switch = self:FindGO("Switch", self.qiehuanban)
  local l = self:FindGO("Label", self:FindGO("SwitchBtn", qiehuanban_switch)):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(l, 3, 120)
end
function ProfessionInfoViewMP:SetQieHuanBanMoKuaiAcitve(b)
  if b then
    for k, v in pairs(self.qiehuanban_mokuai) do
      v.gameObject:SetActive(true)
    end
  else
    for k, v in pairs(self.qiehuanban_mokuai) do
      v.gameObject:SetActive(false)
    end
  end
  self.SkillColumns.gameObject:SetActive(false)
end
function ProfessionInfoViewMP:ConfirmSwitchButton(obj)
  local state = obj:GetHeadIconState()
  local id = obj:GetId()
  local thisIdBranch = Table_Class[id].TypeBranch
  if state == 3 then
    self.Switch.gameObject:SetActive(false)
    self.Switch_grey.gameObject:SetActive(true)
  elseif state == 1 and id % 10 ~= 1 then
    self.Switch.gameObject:SetActive(true)
    self.Switch_grey.gameObject:SetActive(false)
  elseif state == 7 then
    if thisIdBranch == ProfessionProxy.Instance:GetCurTypeBranch() then
      self.Switch.gameObject:SetActive(false)
      self.Switch_grey.gameObject:SetActive(true)
    else
      self.Switch.gameObject:SetActive(true)
      self.Switch_grey.gameObject:SetActive(false)
    end
  else
    self.Switch.gameObject:SetActive(false)
    self.Switch_grey.gameObject:SetActive(false)
  end
  if id % 10 == 1 then
    self.Switch.gameObject:SetActive(false)
    self.Switch_grey.gameObject:SetActive(false)
  end
  if Game.Myself:IsDead() then
    self.Switch.gameObject:SetActive(false)
    self.Switch_grey.gameObject:SetActive(true)
  end
  if self.Switch.gameObject.activeInHierarchy and not self.Switch_grey.gameObject.activeInHierarchy and self:CheckAmIInTransformState() then
    self.Switch.gameObject:SetActive(false)
    self.Switch_grey.gameObject:SetActive(true)
    MsgManager.ShowMsgByID(27006)
  end
end
function ProfessionInfoViewMP:CheckAmIInTransformState()
  local myselfData = Game.Myself.data
  if myselfData:GetBuffListByType("Transform") ~= nil or myselfData:GetBuffListByType("PartTransform") ~= nil then
    return true
  end
  if myselfData:IsTransformed() then
    return true
  end
  if myselfData:IsInMagicMachine() then
    return true
  end
  if myselfData:IsOnWolf() then
    return true
  end
  return false
end
function ProfessionInfoViewMP:FindKeyAndValueUILabelUnderThis(GO)
  local nameUILabel = self:FindGO("name", GO):GetComponent(UILabel)
  local keyUILabel = self:FindGO("value", GO):GetComponent(UILabel)
  return nameUILabel, keyUILabel
end
function ProfessionInfoViewMP:ShowQieHuanBan(obj)
  self.goumaiban.gameObject:SetActive(false)
  self.commonban.gameObject:SetActive(false)
  self.jieshaoban.gameObject:SetActive(false)
  self.qiehuanban.gameObject:SetActive(true)
  self:SetQieHuanBanMoKuaiAcitve(true)
  self.propertyCt_GO.gameObject:SetActive(false)
  if obj:GetId() % 10 == 1 and ProfessionProxy.Instance:IsMPOpen() then
    self.HintLabel.gameObject:SetActive(true)
  else
    self.HintLabel.gameObject:SetActive(false)
  end
  self.currentPfn = obj.data
  local state = obj:GetHeadIconState() or 0
  self:ConfirmSwitchButton(obj)
  local branch = self.currentPfn.TypeBranch or 0
  local id = obj:GetId() or 0
  local Type = Table_Class[id].Type
  if branch == ProfessionProxy.Instance:GetCurTypeBranch() then
    self:AddClickEvent(self.SwitchBtn.gameObject, function()
    end)
    self.SwitchBtn_greyPriceUILabel.text = GameConfig.Profession.switch_zeny
  else
    self.SwitchBtn_PriceUILabel.text = GameConfig.Profession.switch_zeny
    self:AddClickEvent(self.SwitchBtn.gameObject, function()
      local mapid = Game.MapManager:GetMapID()
      local mapType = Table_Map[mapid].Type
      if mapType == 4 or mapType == 6 then
      else
        MsgManager.ShowMsgByID(25437)
        return
      end
      local needmoney = GameConfig.Profession.switch_zeny or 0
      if needmoney > MyselfProxy.Instance:GetROB() then
        local item_100 = Table_Item[100]
        MsgManager.ShowMsgByID(25400, item_100.NameZh)
        return
      else
      end
      local mapid = Game.MapManager:GetMapID()
      local mapType = Table_Map[mapid].Type
      if mapType == 4 or mapType == 6 then
        self:XinPanChongZhiTiShi(branch)
      else
        MsgManager.ShowMsgByID(25437)
      end
    end)
    self.SwitchBtn_UISprite.color = Color(1, 1, 1)
  end
end
function ProfessionInfoViewMP:XinPanChongZhiTiShi(branch)
  local saveInfoData = BranchInfoSaveProxy.Instance:GetUsersaveData(branch)
  if saveInfoData == nil then
    ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
    return
  end
  local costSelf = AstrolabeProxy.Instance:GetStorageActivePointsCost_ByPlate(nil)
  local userdata = Game.Myself and Game.Myself.data.userdata
  local thisGongXian = userdata:Get(UDEnum.CONTRIBUTE) or 0
  local thisJinZhang = BagProxy.Instance:GetItemNumByStaticID(5261) or 0
  for k, v in pairs(costSelf) do
    if k == 140 then
      thisGongXian = thisGongXian + v
    elseif k == 5261 then
      thisJinZhang = thisJinZhang + v
    else
      helplog("@@review")
    end
  end
  local costTarget = AstrolabeProxy.Instance:GetStorageActivePointsCost_BySaveInfo(saveInfoData)
  local targetGongXian = 0
  local targetJinZhang = 0
  for k, v in pairs(costTarget) do
    if k == 140 then
      targetGongXian = v
    elseif k == 5261 then
      targetJinZhang = v
    else
      helplog("@@review")
    end
  end
  if thisGongXian < targetGongXian or thisJinZhang < targetJinZhang then
    MsgManager.ConfirmMsgByID(25411, function()
      ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
    end, nil, nil, targetJinZhang, targetGongXian)
  else
    ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
  end
end
function ProfessionInfoViewMP:ShowZhiYeTeSe(id)
  local thisClassData = Table_Class[id]
  self.jieshaoban_zytsNameUILabel.text = ZhString.ProfessionInfoViewMP_ProfessionInfoSpc
  self.jieshaoban_zytsKeyUILabel.text = thisClassData.Explain
  self.jieshaoban_zytsKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
  self.goumaiban_zytsNameUILabel.text = ZhString.ProfessionInfoViewMP_ProfessionInfoSpc
  self.goumaiban_zytsKeyUILabel.text = thisClassData.Explain
  self.goumaiban_zytsKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
end
function ProfessionInfoViewMP:ShowJiuZhiTiaoJian(obj)
  local previousId = obj:GetPreviousId()
  local thisId = obj:GetId()
  local state = obj:GetHeadIconState()
  self.cha.gameObject:SetActive(false)
  self.gou.gameObject:SetActive(false)
  self.jieshaoban_jztjNameUILabel.text = ZhString.ProfessionInfoViewMP_ChangeCondition
  if previousId == nil then
    self.jieshaoban_jztjKeyUILabel.text = ""
    self.jieshaoban_jztjNameUILabel.text = ""
    self.jieshaoban_jztjKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
    return
  end
  local previousData = Table_Class[previousId]
  local tiaojianfixed = ProfessionProxy.Instance:GetThisIdJiuZhiTiaoJianLevel(thisId)
  if tiaojianfixed == nil then
    helplog("\232\175\183\231\173\150\229\136\146\230\163\128\230\159\165\233\133\141\231\189\174\232\161\168\239\188\129\239\188\129\239\188\129\239\188\129\t\229\137\141\231\171\175\230\151\160\230\179\149\230\160\185\230\141\174\231\142\176\230\156\137\232\167\132\229\136\153\230\142\168\230\181\139\229\135\186\229\141\135\231\186\167\230\137\128\233\156\128\230\157\161\228\187\182\239\188\129\239\188\129\239\188\129\239\188\129 \230\152\190\231\164\186\228\184\138\229\155\160\230\173\164\230\156\137\232\175\175\239\188\129\239\188\129")
    return
  end
  self.jieshaoban_jztjKeyUILabel.text = previousData.NameZh .. "JobLv." .. tiaojianfixed
  self.jieshaoban_jztjKeyUILabel.color = Color(1.0, 0.5411764705882353, 0 / 255)
  if state == 4 then
    self.cha.gameObject:SetActive(false)
    self.gou.gameObject:SetActive(true)
  elseif state == 2 and 2 <= thisId % 10 then
    self.cha.gameObject:SetActive(false)
    self.gou.gameObject:SetActive(true)
  else
    self.cha.gameObject:SetActive(true)
    self.gou.gameObject:SetActive(false)
  end
end
function ProfessionInfoViewMP:ShowJieShaoBan(obj)
  self.propertyCt_GO.gameObject:SetActive(false)
  local thisId = obj:GetId()
  local thisClassData = Table_Class[thisId]
  self:ShowZhiYeTeSe(thisId)
  local previousId = obj:GetPreviousId()
  self:ShowJiuZhiTiaoJian(obj)
  self.goumaiban.gameObject:SetActive(false)
  self.commonban.gameObject:SetActive(true)
  self.jieshaoban.gameObject:SetActive(true)
  self.qiehuanban.gameObject:SetActive(false)
  self:SetQieHuanBanMoKuaiAcitve(false)
  self.propDes_GO.gameObject.transform.localPosition = Vector3(-0.5, 32.8, 0)
  self.propGrid_GO.gameObject.transform.localPosition = Vector3(-2, 0.4, 0)
  self.propGrid_UIGrid.maxPerLine = 4
  self.propGrid_UIGrid:Reposition()
end
function ProfessionInfoViewMP:ShowGouMaiBan(obj)
  self.propertyCt_GO.gameObject:SetActive(false)
  local thisId = obj:GetId()
  local thisClassData = Table_Class[thisId]
  self:ShowZhiYeTeSe(thisId)
  self.goumaiban.gameObject:SetActive(true)
  self.commonban.gameObject:SetActive(true)
  self.jieshaoban.gameObject:SetActive(false)
  self.qiehuanban.gameObject:SetActive(false)
  self:SetQieHuanBanMoKuaiAcitve(false)
  self.propGrid_GO.gameObject.transform.localPosition = Vector3(-2, -22, 0)
  self.propGrid_UIGrid.maxPerLine = 4
  self.propGrid_UIGrid:Reposition()
  self.lockContent.gameObject:SetActive(true)
  self.lockContent.gameObject.transform.localPosition = Vector3(-205, -114, 0)
  if GameConfig.SystemForbid.OpenJapanMultiJobs then
    helplog("\230\178\161\230\168\170\229\178\151 \230\137\147\229\188\128")
    local moneynumber, moneytype = ProfessionProxy.Instance:GetRightMoneyNumberAndMoneyTypeForThisId(thisId)
    if moneytype.id == 100 then
      self.Purchase.gameObject:SetActive(false)
      self.Purchase_zeny.gameObject:SetActive(true)
    elseif moneytype.id == 151 then
      self.Purchase.gameObject:SetActive(true)
      self.Purchase_zeny.gameObject:SetActive(false)
    end
    self:AddClickEvent(self.PurchaseBtn_zeny.gameObject, function()
      local Id = obj:GetId()
      ProfessionProxy.Instance:PurchaseFunc(Id)
    end)
    self:AddClickEvent(self.PurchaseBtn.gameObject, function()
      OverseaHostHelper:GachaUseComfirm(GameConfig.Profession.price_gold, function()
        local Id = obj:GetId()
        ProfessionProxy.Instance:PurchaseFunc(Id)
      end)
    end)
    self.PurchaseBtn_zenyPirceUILabel.text = moneynumber
    self.PurchaseBtn_PriceUILabel.text = moneynumber
  else
    helplog("\230\156\137\230\168\170\229\178\151 \229\133\179\233\151\173")
    if ProfessionProxy.Instance:isOriginProfession(thisId) then
      self.Purchase.gameObject:SetActive(false)
      self.Purchase_zeny.gameObject:SetActive(true)
      self:AddClickEvent(self.PurchaseBtn_zeny.gameObject, function()
        local Id = obj:GetId()
        ProfessionProxy.Instance:PurchaseFunc(Id)
      end)
      self.PurchaseBtn_zenyPirceUILabel.text = GameConfig.Profession.price_zeny
    else
      self.Purchase.gameObject:SetActive(true)
      self.Purchase_zeny.gameObject:SetActive(false)
      self:AddClickEvent(self.PurchaseBtn.gameObject, function()
        OverseaHostHelper:GachaUseComfirm(GameConfig.Profession.price_gold, function()
          local Id = obj:GetId()
          ProfessionProxy.Instance:PurchaseFunc(Id)
        end)
      end)
      self.PurchaseBtn_PriceUILabel.text = GameConfig.Profession.price_gold
    end
  end
  if ProfessionProxy.Instance:IsThisIdYiGouMai(thisId) then
    self.Purchase.gameObject:SetActive(false)
    self.Purchase_zeny.gameObject:SetActive(false)
  end
end
function ProfessionInfoViewMP:ShowJiuZhiBan(obj)
  if obj == nil then
    helplog("if obj == nil then")
    return
  end
  local state = obj:GetHeadIconState() or 0
  if state == 2 then
    self.jiuzhiban.gameObject:SetActive(false)
    return
  else
    self:ShowJieShaoBan(obj)
    self.jiuzhiban.gameObject:SetActive(true)
    self:AddClickEvent(self.jiuzhiBtn.gameObject, function()
      local Id = obj:GetId()
      local thisIdData = Table_Class[Id]
      FuncShortCutFunc.Me():CallByID(thisIdData.AdvancedTeacher)
      self:sendNotification(UIEvent.CloseUI, self.container)
    end)
  end
end
function ProfessionInfoViewMP:showShuXinBySave(branch)
  local props = BranchInfoSaveProxy.Instance:GetProps(branch)
  if props == nil then
    self.baseGridList:RemoveAll()
    self.ManualGridList:RemoveAll()
    self.AutoGridList:RemoveAll()
    return
  end
  local showDatas = {}
  for i = 1, #GameConfig.SavePreviewAttrSec do
    local single = GameConfig.SavePreviewAttrSec[i]
    local test = props:GetPropByName(single)
    if props[single] ~= nil then
      local data = {}
      data.name = test.propVO.displayName
      if test.propVO.name == "AtkSpd" then
        data.value = string.format("%.1f", tonumber(props[single].value) / 10) .. "%"
      else
        data.value = props[single].value
      end
      table.insert(showDatas, data)
    end
  end
  self.baseGridList:ResetDatas(showDatas)
  self.propSecGrid_UIGrid.cellWidth = 170
  self.propSecGrid_UIGrid:Reposition()
  local baseCells = self.baseGridList:GetCells()
  for k, v in pairs(baseCells) do
    v:HideLine()
    v:ChangeValueFontSize(18)
    v:ChangeNameFontSize(18)
    v:ChangeValueDepth(10)
    v:ChangeNameDepth(10)
    v:ChangeValueLocalPos(Vector3(162.9, 0, 0))
    v:ChangeValueColor(Color(1.0, 0.5411764705882353, 0 / 255))
  end
  self.isShowShuXin = true
  self.shortcutSwitchID = ShortCutProxy.ShortCutEnum.ID1
  local savedata = BranchInfoSaveProxy.Instance.recordDatas[branch]
  if not savedata then
    helplog("savedata nil")
    return
  end
  local skillDatas = savedata:GetSkillData()
  if skillDatas == nil then
    helplog("\tif skillDatas== nil then")
  end
  local equipskills = skillDatas:GetCurrentEquipedSkillData(true, self.shortcutSwitchID)
  self.ManualGridList:ResetDatas(equipskills)
  local skills2 = savedata:GetEquipedAutoSkills()
  skills2 = self:GetSortEquipedAutoSkills(skills2)
  if skills2 then
    self.AutoGridList:ResetDatas(skills2)
  end
  self.AutoGrid.transform.localPosition = Vector3(-126, -210.6, 0)
end
function ProfessionInfoViewMP:GetSortEquipedAutoSkills(skills)
  local equipedSkillData = {}
  for i = 1, ShortCutData.CONFIGAUTOSKILLNUM do
    local item = SkillItemData.new(0, 0, i)
    equipedSkillData[i] = item
  end
  local equipedAutoSkills = skills
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  for k, v in pairs(equipedAutoSkills) do
    equipedSkillData[v:GetPosInShortCutGroup(shortCutAuto)] = v
  end
  local sproxy = ShortCutProxy.Instance
  return equipedSkillData
end
function ProfessionInfoViewMP:showShuXinBySelf(branch)
  local GeneraData = ProfessionProxy.Instance:GetGeneraData()
  local iwantshowDatas = {}
  for i = 1, #GeneraData do
    local data = GeneraData[i]
    if data.prop.propVO.name == "Hp" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Sp" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Cri" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "AtkSpd" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Atk" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "MAtk" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Def" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "MDef" then
      table.insert(iwantshowDatas, data)
    end
  end
  self.baseGridList:ResetDatas(iwantshowDatas)
  self.propSecGrid_UIGrid.cellWidth = 170
  self.propSecGrid_UIGrid:Reposition()
  local baseCells = self.baseGridList:GetCells()
  for k, v in pairs(baseCells) do
    v:HideLine()
    v:ChangeValueFontSize(18)
    v:ChangeNameFontSize(18)
    v:ChangeValueDepth(10)
    v:ChangeNameDepth(10)
    v:ChangeValueLocalPos(Vector3(162.9, 0, 0))
    v:ChangeValueColor(Color(1.0, 0.5411764705882353, 0 / 255))
  end
  self.isShowShuXin = true
  self.shortcutSwitchID = ShortCutProxy.ShortCutEnum.ID1
  local equipDatas = SkillProxy.Instance:GetCurrentEquipedSkillData(true, self.shortcutSwitchID)
  self.ManualGridList:ResetDatas(equipDatas, self.shortcutSwitchID)
  equipDatas = SkillProxy.Instance:GetEquipedAutoSkillData(true)
  self.AutoGridList:ResetDatas(equipDatas)
  self.AutoGrid.transform.localPosition = Vector3(-126, -210.6, 0)
end
function ProfessionInfoViewMP:TryGetNextSwitchID()
  self.shortcutSwitchIndex = self.shortcutSwitchIndex + 1
  if self.shortcutSwitchIndex > #ShortCutProxy.SwitchList then
    self.shortcutSwitchIndex = 1
  end
  local id = ShortCutProxy.SwitchList[self.shortcutSwitchIndex]
  local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(id)
  if funcEnable then
    self.shortcutSwitchID = id
  else
    self:TryGetNextSwitchID()
  end
end
function ProfessionInfoViewMP:InitSwitchShortCut()
  self.shortcutSwitchIndex = 1
  self.skillShortCutSwitchIcon = self:FindChild("SwitchIcon"):GetComponent(UIMultiSprite)
  self.skillShortCutSwtichBtn = self:FindChild("SkillShortCutSwitch")
  self:AddClickEvent(self.skillShortCutSwtichBtn, function()
    self:TryGetNextSwitchID()
    self:SwitchShortCutTo(self.shortcutSwitchID)
  end)
  self:HandleShortCutSwitchActive(nil)
end
function ProfessionInfoViewMP:SwitchShortCutTo(id)
  if not self.skillShortCutSwitchIcon then
    self.skillShortCutSwitchIcon = self:FindChild("SwitchIcon"):GetComponent(UIMultiSprite)
  end
  if not self.skillShortCutSwtichBtn then
    self.skillShortCutSwtichBtn = self:FindChild("SkillShortCutSwitch")
  end
  if id ~= nil then
    self.shortcutSwitchID = id
    if self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID1 then
      self.skillShortCutSwitchIcon.CurrentState = 0
      self.skillShortCutSwitchIcon.width = 35
      self.skillShortCutSwitchIcon.height = 35
    elseif self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID2 then
      self.skillShortCutSwitchIcon.CurrentState = 1
      self.skillShortCutSwitchIcon.width = 35
      self.skillShortCutSwitchIcon.height = 35
    elseif self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID3 then
      self.skillShortCutSwitchIcon.CurrentState = 2
      self.skillShortCutSwitchIcon.width = 35
      self.skillShortCutSwitchIcon.height = 35
    elseif self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID4 then
      self.skillShortCutSwitchIcon.CurrentState = 3
      self.skillShortCutSwitchIcon.width = 35
      self.skillShortCutSwitchIcon.height = 35
    end
    self:RefreshShortCuts()
  end
end
function ProfessionInfoViewMP:RefreshShortCuts()
  self:HandleShortCutSwitchActive()
  local savedata = BranchInfoSaveProxy.Instance.recordDatas[self.selectedID]
  if savedata then
    local skillDatas = savedata:GetSkillData()
    local equipskills = skillDatas:GetCurrentEquipedSkillData(true, self.shortcutSwitchID)
    self.ManualGridList:ResetDatas(equipskills)
    self:RefreshShortCutsIcon()
  else
    helplog("savedata nil self.selectedID:" .. self.selectedID)
  end
end
function ProfessionInfoViewMP:RefreshShortCutsIcon()
  local skillcellsTable = self.ManualGridList:GetCells()
  for k, v in pairs(skillcellsTable) do
    v.level.text = ""
    v:HideLock()
    v:AddDepth(10)
    v:SetScale(Vector3(0.6, 0.6, 0.6))
    v:SetDragEnable(false)
    v:HideBg()
  end
  skillcellsTable = self.AutoGridList:GetCells()
  for k, v in pairs(skillcellsTable) do
    v.level.text = ""
    v:HideLock()
    v:AddDepth(10)
    v:SetScale(Vector3(0.6, 0.6, 0.6))
    v:SetDragEnable(false)
    v:HideBg()
  end
end
function ProfessionInfoViewMP:HandleShortCutSwitchActive(note)
  local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(ShortCutProxy.ShortCutEnum.ID2)
  if funcEnable then
    self:SetActive(self.skillShortCutSwtichBtn, true)
    tempVector3:Set(-121, -145)
    self.skillShortCutSwtichBtn.transform.localPosition = tempVector3
    tempVector3:Set(-71, -145)
    self.ManualGrid.gameObject.transform.localPosition = tempVector3
  else
    self:SetActive(self.skillShortCutSwtichBtn, false)
    tempVector3:Set(-121, -145)
    self.ManualGrid.gameObject.transform.localPosition = tempVector3
    if self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID2 then
      self:SwitchShortCutTo(ShortCutProxy.ShortCutEnum.ID1)
    end
  end
end
