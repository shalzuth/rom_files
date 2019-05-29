autoImport("PetComposePreviewCell")
autoImport("PetComposeChooseCell")
PetComposePopUp = class("PetComposePopUp", ContainerView)
PetComposePopUp.ViewType = UIViewType.PopUpLayer
PetComposePopUp.CellResID = ResourcePathHelper.UICell("PetComposePreviewCell")
local CFG_FIELD = "MaterialPet"
local tempVector3 = LuaVector3.zero
local packageCheck = GameConfig.PackageMaterialCheck.pet_workspace
local SortPet = function(a, b)
  if a == nil or b == nil then
    return false
  end
  if a.unlocked and b.unlocked then
    return a.petid < b.petid
  end
  if a.unlocked or b.unlocked then
    return a.unlocked
  end
  if a.unlocked == false and b.unlocked == false then
    return a.petid < b.petid
  end
  return a.petid < b.petid
end
function PetComposePopUp:Init(parent)
  local petID = self.viewdata.viewdata
  self.staticData = Table_PetCompose[petID]
  self:FindObjs()
  self:AddEvts()
  self:InitView()
  self:SetData()
end
function PetComposePopUp:FindObjs()
  self.rootIcon = self:FindComponent("Root", UISprite)
  self.composeBtn = self:FindComponent("ComposeBtn", UISprite)
  self.composeLab = self:FindComponent("ComposeLab", UILabel)
  self.costLab = self:FindComponent("CostLab", UILabel)
  self.petChoosePanel = self:FindGO("PetChoosePos")
  self.closePetChoose = self:FindGO("closePetChoose")
  self.effContainer = self:FindGO("EffContainer")
  self.closecomp = self.petChoosePanel:GetComponent(CloseWhenClickOtherPlace)
end
function PetComposePopUp:AddEvts()
  self:AddClickEvent(self.composeBtn.gameObject, function(g)
    self:OnCompose()
  end)
  self:AddClickEvent(self.closePetChoose, function(g)
    self:Hide(self.petChoosePanel)
  end)
end
function PetComposePopUp:InitView()
  PetComposeProxy.Instance:ResetComposeGuilds()
  local PetWrapObj = self:FindGO("PetWrap")
  local petConfig = {
    wrapObj = PetWrapObj,
    pfbNum = 6,
    cellName = "PetComposeChooseCell",
    control = PetComposeChooseCell,
    dir = 1
  }
  self.petlist = WrapCellHelper.new(petConfig)
  self.petlist:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenPetCell, self)
  self.petlist:AddEventListener(PetEvent.ClickPetAdventureIcon, self.ShowPetHeadTips, self)
  self:SetComposeBtnState()
end
function PetComposePopUp:SetData()
  if self.staticData then
    IconManager:SetNpcMonsterIconByID(self.staticData.id, self.rootIcon)
    self.costLab.text = self.staticData.ZenyCost or 0
    local obj = Game.AssetManager_UI:CreateAsset(PetComposePopUp.CellResID, self.gameObject)
    tempVector3:Set(0, -77, 0)
    obj.transform.localPosition = tempVector3
    self.root = PetComposePreviewCell.new(obj, self.staticData.id, false)
    self.root:SetClickEvent(self.ShowPetChooseView, self)
  end
end
function PetComposePopUp:ClickChoosenPetCell(cellctl)
  local data = cellctl and cellctl.data
  if data and data.unlocked then
    local guid = cellctl.data.guid
    PetComposeProxy.Instance:AddComposeGuid(self.curIndex, guid)
    self:Hide(self.petChoosePanel)
    self.root:ResetDatas()
    self:SetComposeBtnState()
  end
end
function PetComposePopUp:ShowPetHeadTips(cellctl)
  if cellctl then
    local stickPos = cellctl.headTipStick
    local tipData = cellctl.data
    TipManager.Instance:ShowPetAdventureHeadTip(tipData, stickPos, NGUIUtil.AnchorSide.Right, {205, -120})
  end
end
function PetComposePopUp:GetPets()
  local allPets = {}
  local bagPet = BagProxy.Instance:GetMyPetEggs()
  if bagPet then
    for i = 1, #bagPet do
      local pet = bagPet[i].petEggInfo
      pet.guid = bagPet[i].id
      pet.unlocked = self:IsUnlock(pet)
      allPets[#allPets + 1] = pet
    end
  end
  return allPets
end
function PetComposePopUp:IsUnlock(pet)
  if not pet or not self.curCfg then
    return false
  end
  if pet.petid ~= self.curCfg.id then
    return false
  end
  if self.curCfg.friendlv and self.curCfg.friendlv > pet.friendlv then
    return false
  end
  return true
end
function PetComposePopUp:ShowPetChooseView(data)
  self.curIndex = data.index
  local mat = CFG_FIELD .. self.curIndex
  self.curCfg = self.staticData[mat]
  local pets = self:GetPets()
  if not pets or #pets <= 0 then
    MsgManager.ShowMsgByID(25715)
    return
  end
  self:Show(self.petChoosePanel)
  table.sort(pets, function(a, b)
    return SortPet(a, b)
  end)
  self.petlist:UpdateInfo(pets)
  self.petlist:ResetPosition()
end
function PetComposePopUp:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function PetComposePopUp:SetComposeBtnState()
  local c = PetComposeProxy.Instance:CanCompose()
  if c then
    ColorUtil.WhiteUIWidget(self.composeBtn)
    ColorUtil.WhiteUIWidget(self.composeLab)
  else
    ColorUtil.ShaderLightGrayUIWidget(self.composeBtn)
    ColorUtil.ShaderLightGrayUIWidget(self.composeLab)
  end
  self.composeLab.effectStyle = c and UILabel.Effect.Outline or UILabel.Effect.None
end
function PetComposePopUp:OnCompose()
  if self.forbiddenFlag then
    return
  end
  local canCompose = PetComposeProxy.Instance:CanCompose()
  if not canCompose then
    return
  end
  if self.staticData.ZenyCost > MyselfProxy.Instance:GetROB() then
    MsgManager.ShowMsgByID(1)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25713)
  if nil == dont then
    MsgManager.DontAgainConfirmMsgByID(25713, function()
      self:_CloseUI()
    end)
  else
    self:_CloseUI()
  end
end
function PetComposePopUp:_CloseUI()
  self.root:PlayComposeEffect()
  self:PlayUIEffect(EffectMap.UI.NewPet, self.effContainer, false)
  self.forbiddenFlag = true
  LeanTween.cancel(self.gameObject)
  LeanTween.delayedCall(self.gameObject, 3, function()
    local guids = PetComposeProxy.Instance:GetGuids()
    ServiceScenePetProxy.Instance:CallComposePetCmd(self.staticData.id, guids)
    MsgManager.ShowMsgByID(25714)
    self:CloseSelf()
    self.forbiddenFlag = false
  end)
end
