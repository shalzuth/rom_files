autoImport("PetCombineTableCell")
autoImport("PetComposeSkillCell")
autoImport("PetInfoLabelCell")
autoImport("PetComposeDendrogram")
PetComposeView = class("PetComposeView", BaseView)
PetComposeView.ViewType = UIViewType.NormalLayer
local math_floor = math.floor
local SKIN_CFG = GameConfig.Pet.petSkin
local BTN_STSTE = {
  combine = {
    btnName = "com_btn_3s",
    content = ZhString.PetAdvance_Compose,
    color = Color(0.1607843137254902, 0.4117647058823529, 0 / 255)
  },
  phrchase = {
    btnName = "com_btn_2s",
    content = ZhString.PetAdvance_BuyCaptureItem,
    color = Color(0.6196078431372549, 0.33725490196078434, 0 / 255)
  }
}
local PET_TEXTURE_NAME = "give_bg_01"
local SortPet = function(left, right)
  if left == nil or right == nil then
    return false
  end
  return left.star > right.star
end
local PetPos = {
  position = Vector3(-2.3, 5, 5),
  rotation = Quaternion.Euler(-14, -20.7, 1)
}
local Color = LuaColor.New(1, 1, 1, 0)
PetComposeView.TabName = {
  SkillTog = ZhString.PetComposeView_SkillTogTabName,
  AttrTog = ZhString.PetComposeView_AttrTogTabName,
  SkinTog = ZhString.PetComposeView_SkinTogTabName
}
function PetComposeView:Init()
  PetComposeProxy.Instance:InitStaticData()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end
function PetComposeView:FindObjs()
  self.bgTexture1 = self:FindComponent("Bg1", UITexture)
  self.bgTexture2 = self:FindComponent("Bg2", UITexture)
  self.petName = self:FindComponent("PetName", UILabel)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnName = self:FindComponent("BtnName", UILabel)
  self.previewBtn = self:FindGO("PreviewBtn")
  self.titleDesc = self:FindComponent("TitleDesc", UILabel)
  self.petTable = self:FindComponent("PetTable", UITable)
  self.starGrid = self:FindComponent("StarGrid", UIGrid)
  self.starPrefab = self:FindGO("StarPrefab")
  self.skinGrid = self:FindComponent("SkinGrid", UIGrid)
  local table = self:FindComponent("AttrTable", UITable)
  self.attriCtl = UIGridListCtrl.new(table, PetInfoLabelCell, "PetInfoLabelCell")
  self.skillPos = self:FindComponent("SkillScrollView", UIScrollView)
  self.attrScrollView = self:FindComponent("AttriScrollView", UIScrollView)
  self.attrPos = self:FindGO("AttrPos")
  self.skinPos = self:FindComponent("SkinScrollView", UIScrollView)
  self.touchZone = self:FindGO("touchZone")
  self.modelContainer = self:FindGO("ModelContainer")
  self.dragScroll = self:FindComponent("DragScrollView", UIDragScrollView)
  self.race = self:FindComponent("Race", UISprite)
  self.nature = self:FindComponent("Nature", UISprite)
end
function PetComposeView:AddToggleChange(toggle, handler)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value and handler ~= nil then
      handler(self)
    end
  end)
end
function PetComposeView:SetStar()
  if not self.curPet then
    return
  end
  local star = Table_Pet[self.curPet].Star
  local childCount = self.starGrid.gameObject.transform.childCount
  for i = 1, childCount - 1 do
    local trans = self.starGrid.gameObject.transform:GetChild(i)
    self:Hide(trans.gameObject)
  end
  for i = 1, star do
    local obj = self.starObj[i]
    if not obj then
      local starObj = self:CopyGameObject(self.starPrefab)
      starObj:SetActive(true)
      starObj.transform:SetParent(self.starGrid.gameObject.transform)
      starObj.name = string.format("starSymbol%02d", star)
      self.starObj[i] = starObj
    else
      obj:SetActive(true)
    end
  end
  self.starGrid:Reposition()
end
function PetComposeView:InitView()
  self.starObj = {}
  self.choosePet = nil
  if not self.petTableCtl then
    self.petTableCtl = UIGridListCtrl.new(self.petTable, PetCombineTableCell, "PetCombineTableCell")
    self.petTableCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItemPet, self)
  end
  local starData = PetComposeProxy.Instance:GetPetsIDByStar()
  local petData = {}
  for k, v in pairs(starData) do
    TableUtility.ArrayPushBack(petData, {star = k, value = v})
  end
  table.sort(petData, function(l, r)
    return SortPet(l, r)
  end)
  self.petTableCtl:ResetDatas(petData)
  local petSkillContainer = self:FindGO("skillWrap")
  local wrapConfig = {
    wrapObj = petSkillContainer,
    pfbNum = 5,
    cellName = "PetComposeSkillCell",
    control = PetComposeSkillCell
  }
  self.petSkillWrap = WrapCellHelper.new(wrapConfig)
  if not self.petSkinCtl then
    self.petSkinCtl = UIGridListCtrl.new(self.skinGrid, PetComposeItemCell, "PetComposeItemCell")
    self.petSkinCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItemPetSkin, self)
  end
  local Cells = self.petTableCtl:GetCells()
  if #Cells > 0 then
    Cells = Cells[1]:GetCells()
    if #Cells > 0 then
      self:ClickItemPet(Cells[1])
    end
  end
  PictureManager.Instance:SetUI(PET_TEXTURE_NAME, self.bgTexture1)
  PictureManager.Instance:SetUI(PET_TEXTURE_NAME, self.bgTexture2)
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  self.toggleTabIconSp = {}
  for i, v in ipairs(self.toggleTab) do
    local iconSp = GameObjectUtil.Instance:DeepFindChild(v.gameObject, "Icon"):GetComponent(UISprite)
    iconSp.gameObject:SetActive(iconActive)
    self.toggleTabIconSp[i] = iconSp
    local label = GameObjectUtil.Instance:DeepFindChild(v.gameObject, "Label")
    label:SetActive(nameLabelActive)
  end
end
function PetComposeView:ClickItemPetSkin(cellctl)
  if not cellctl or not cellctl.data then
    local skinID
  end
  if self.curSkin ~= skinID then
    self.curSkin = skinID
  else
    self.curSkin = self.curPet
  end
  local petTable = self.petSkinCtl:GetCells()
  for _, cell in pairs(petTable) do
    cell:SetChoose(self.curSkin)
  end
  self.dragScroll.scrollView = self.skinPos
  self:UpdateModel(self.curSkin)
end
function PetComposeView:ClickItemPet(cellctl)
  local petID = cellctl and cellctl.data
  if self.curPet ~= petID then
    self.curPet = petID
    self:_setBtnState()
    PetComposeProxy.Instance:SetCurPet(petID)
    local petTable = self.petTableCtl:GetCells()
    for _, cells in pairs(petTable) do
      for k, cell in pairs(cells:GetCells()) do
        cell:SetChoose(petID)
      end
    end
    self.toggleTab[1]:Set(true)
    self.toggleTab[2]:Set(false)
    self.toggleTab[3]:Set(false)
    self:SetStar()
    self:ClickSkillTog()
    if petID then
      self.petName.text = Table_Pet[petID] and Table_Pet[petID].Name or ""
      self:UpdateModel(petID)
    end
    self.curSkin = nil
  end
end
function PetComposeView:_setBtnState()
  if Table_PetCompose[self.curPet] then
    self.btn.spriteName = BTN_STSTE.combine.btnName
    self.btnName.text = BTN_STSTE.combine.content
    self.btnName.effectColor = BTN_STSTE.combine.color
    self.previewBtn:SetActive(true)
  else
    self.btn.spriteName = BTN_STSTE.phrchase.btnName
    self.btnName.text = BTN_STSTE.phrchase.content
    self.btnName.effectColor = BTN_STSTE.phrchase.color
    self.previewBtn:SetActive(false)
  end
end
function PetComposeView:ObserverDestroyed(obj)
  if obj ~= nil and obj == self.model then
    self.model:SetParent(nil)
    self.model = nil
  end
end
function PetComposeView:UpdateModel(petid)
  self:ResetModel()
  if petid and petid ~= 0 then
    self.model = Asset_RoleUtility.CreateMonsterRole(petid)
    self.model:SetParent(self.modelContainer.transform)
    self.model:SetLayer(RO.Config.Layer.UI.Value)
    local monsterData = Table_Monster[petid]
    local scale = monsterData.Scale or 1
    self.model:SetScale(scale)
    self.model:SetPosition(LuaGeometry.Const_V3_zero)
    self.model:SetEulerAngles(LuaGeometry.Const_Qua_identity)
    self.model:RegisterWeakObserver(self)
    self.model:PlayAction_Idle()
    self.model:SetShadowEnable(false)
  end
end
function PetComposeView:HandleClose()
  self:Show(self.modelContainer)
end
function PetComposeView:OnEnter()
  EventManager.Me():AddEventListener(QuickBuyEvent.CloseUI, self.HandleClose, self)
end
function PetComposeView:OnExit()
  EventManager.Me():RemoveEventListener(QuickBuyEvent.CloseUI, self.HandleClose, self)
  PictureManager.Instance:UnLoadUI()
  self:ResetModel()
  PetComposeView.super.OnExit(self)
end
function PetComposeView:ResetModel()
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
end
function PetComposeView:AddEvts()
  self:AddDragEvent(self.touchZone, function(obj, delta)
    if nil ~= self.model then
      self.model:RotateDelta(-delta.x)
    end
  end)
  self:AddClickEvent(self.btn.gameObject, function(g)
    self:OnBtn()
  end)
  self:AddClickEvent(self.previewBtn, function(g)
    self:OnPreview()
  end)
  local skillTog = self:FindGO("SkillTog"):GetComponent(UIToggle)
  local attrTog = self:FindGO("AttrTog"):GetComponent(UIToggle)
  local skinTog = self:FindGO("SkinTog"):GetComponent(UIToggle)
  self.toggleTab = {
    skillTog,
    attrTog,
    skinTog
  }
  self:AddToggleChange(skillTog, self.ClickSkillTog)
  self:AddToggleChange(attrTog, self.ClickAttrTog)
  self:AddToggleChange(skinTog, self.ClickSkinTog)
  for i, v in ipairs(self.toggleTab) do
    local longPress = v.gameObject:GetComponent(UILongPress)
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.PetComposeView, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.PetComposeView, self.HandleLongPress, self)
end
function PetComposeView:OnPreview()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PetComposePreviewPopUp,
    viewdata = self.curPet
  })
end
function PetComposeView:ClickSkillTog()
  local data = self:GetSkillData()
  if not data then
    return
  end
  self.dragScroll.scrollView = self.skinPos
  self.petSkillWrap:ResetDatas(data)
  self:Show(self.skillPos.gameObject)
  self:Hide(self.attrPos)
  self:Hide(self.skinPos.gameObject)
  self:SetCurrentTabIconColor(1)
end
local GetNatureIcon = function(petid)
  local data = Table_Monster[petid]
  if data then
    return data.Nature
  end
end
local GetRaceIcon = function(petid)
  local data = Table_Monster[petid]
  if data then
    local race = data.Race
    for _, v in pairs(Table_Pet_AdventureCond) do
      if v.TypeID == "Race" and v.Param[1] == race then
        return v.Icon
      end
    end
  end
end
local PETINFOLABELCELL_TYPE = PetInfoLabelCell.Type.Attri
local LABEL_POSITION_X = 300
function PetComposeView:ClickAttrTog()
  if not self.curPet then
    return
  end
  local attrData = PetComposeProxy.Instance:GetPetAttr(Table_Monster[self.curPet].ClassType)
  local attdata = {}
  for k, v in pairs(attrData) do
    local data = {}
    data[1] = PetInfoLabelCell.Type.Attri
    data[2] = Table_RoleData[k].PropName
    data[3] = math_floor(v)
    data[4] = LABEL_POSITION_X
    attdata[#attdata + 1] = data
  end
  self.dragScroll.scrollView = self.attrScrollView
  self.attriCtl:ResetDatas(attdata)
  self.attrScrollView:ResetPosition()
  self:Hide(self.skillPos.gameObject)
  self:Show(self.attrPos)
  self:Hide(self.skinPos.gameObject)
  self:SetCurrentTabIconColor(2)
  local natureIcon = GetNatureIcon(self.curPet)
  local raceIcon = GetRaceIcon(self.curPet)
  IconManager:SetUIIcon(natureIcon, self.nature)
  IconManager:SetUIIcon(raceIcon, self.race)
end
function PetComposeView:ClickSkinTog()
  self:Hide(self.skillPos.gameObject)
  self:Hide(self.attrPos)
  self:Show(self.skinPos.gameObject)
  self:SetCurrentTabIconColor(3)
  if not self.curPet then
    return
  end
  if not SKIN_CFG or not SKIN_CFG[self.curPet] then
    self.petSkinCtl:ResetDatas()
    return
  end
  self.dragScroll.scrollView = self.skinPos
  self.petSkinCtl:ResetDatas(self:GetValidPetSkin())
  local petTable = self.petSkinCtl:GetCells()
  for _, cell in pairs(petTable) do
    cell:SetChoose(self.curSkin)
  end
end
function PetComposeView:GetValidPetSkin()
  local skin = {}
  local skinArray = SKIN_CFG[self.curPet]
  for i = 1, #skinArray do
    local itemid = PetComposeProxy.Instance.staticActivePet[skinArray[i]]
    if itemid then
      if ItemUtil.CheckDateValidByItemId(itemid) then
        TableUtility.ArrayPushBack(skin, skinArray[i])
      end
    else
      TableUtility.ArrayPushBack(skin, skinArray[i])
    end
  end
  return skin
end
function PetComposeView:GetSkillData()
  local skillData = {}
  local petData = self.curPet and Table_Pet[self.curPet]
  if not petData then
    return
  end
  for i = 1, 5 do
    local skillConfig = petData["Skill_" .. i]
    if skillConfig[1] and skillConfig[2] then
      local fullSkillid = skillConfig[1] - skillConfig[1] % 10 + skillConfig[2]
      TableUtility.ArrayPushBack(skillData, fullSkillid)
    end
  end
  return skillData
end
function PetComposeView:OnBtn()
  if not self.curPet then
    return
  end
  local isCompose = nil ~= Table_PetCompose[self.curPet]
  if isCompose then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PetComposePopUp,
      viewdata = self.curPet
    })
  else
    local petData = Table_Pet[self.curPet]
    if nil ~= petData and #petData.HobbyItem > 0 then
      local lackItem = {
        id = petData.HobbyItem[1],
        count = 1
      }
      QuickBuyProxy.Instance:TryOpenView({lackItem})
      self:Hide(self.modelContainer)
    end
  end
end
function PetComposeView:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function PetComposeView:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    if isPressing then
      local backgroundSp = GameObjectUtil.Instance:DeepFindChild(go, "Background"):GetComponent(UISprite)
      TipManager.Instance:TryShowHorizontalTabNameTip(PetComposeView.TabName[go.name], backgroundSp, NGUIUtil.AnchorSide.Left)
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
function PetComposeView:ResetTabIconColor()
  for i, v in ipairs(self.toggleTabIconSp) do
    v.color = ColorUtil.TabColor_White
  end
end
function PetComposeView:SetCurrentTabIconColor(index)
  if not self.toggleTabIconSp or not index then
    return
  end
  self:ResetTabIconColor()
  local iconSp = self.toggleTabIconSp[index]
  if not iconSp then
    return
  end
  iconSp.color = ColorUtil.TabColor_DeepBlue
end
