PetMakeNamePopUp = class("PetMakeNamePopUp", BaseView)
PetMakeNamePopUp.ViewType = UIViewType.PopUpLayer
function PetMakeNamePopUp:Init()
  self:InitUI()
end
function PetMakeNamePopUp:InitUI()
  self.nameInput = self:FindComponent("NameInput", UIInput)
  local limitNum = GameConfig.Pet and GameConfig.Pet.petname_max or 8
  self.nameInput.characterLimit = limitNum
  self.confirmButton = self:FindGO("ConfirmButton")
  self.modelContainer = self:FindGO("ModelContainer")
  local closeButton = self:FindGO("CloseButton")
  self.cancel_label = self:FindComponent("Label", UILabel, closeButton)
  self.confirm_label = self:FindComponent("Label", UILabel, self.confirmButton)
  self.changeRq = self.modelContainer:GetComponent(ChangeRqByTex)
  self.filterType = GameConfig.MaskWord.PetName
  self:AddClickEvent(self.confirmButton, function(go)
    self:DoHatch()
  end)
end
function PetMakeNamePopUp:DoHatch()
  local petInfoData = PetProxy.Instance:GetMyPetInfoData()
  if self.etype == 1 then
    if petInfoData ~= nil then
      MsgManager.ShowMsgByIDTable(9003)
      return
    end
    local nameValue = self.nameInput.value
    if nameValue ~= "" then
      if FunctionMaskWord.Me():CheckMaskWord(nameValue, self.filterType) then
        MsgManager.ShowMsgByIDTable(1005)
        return
      end
      local id = self.item.id
      if id == "Fake" then
        local item = FunctionPet.Me():GetNewestEgg(self.item.staticData.id)
        id = item.id
      end
      helplog("Hatch", id)
      ServiceScenePetProxy.Instance:CallEggHatchPetCmd(nameValue, id)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByIDTable(1006)
    end
  elseif self.etype == 2 then
    if petInfoData == nil then
      MsgManager.ShowMsgByIDTable(9003)
      return
    end
    local nameValue = self.nameInput.value
    if nameValue ~= "" then
      if FunctionMaskWord.Me():CheckMaskWord(nameValue, self.filterType) then
        MsgManager.ShowMsgByIDTable(1005)
        return
      end
      ServiceScenePetProxy.Instance:CallChangeNamePetCmd(petInfoData.petid, nameValue)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByIDTable(1006)
    end
  end
end
function PetMakeNamePopUp:UpdateView()
  helplog("PetMakeNamePopUp UpdateView", self.etype)
  local petid
  if self.etype == 1 then
    local item = self.item
    petid = item and item.petEggInfo and item.petEggInfo.petid
    if petid == nil then
      local petData = PetProxy.Instance:GetPetDataByEggID(item.staticData.id)
      if petData then
        petid = petData.id
      end
    end
    self.cancel_label.text = ZhString.PetMakeNamePopUp_PutInBag
    self.confirm_label.text = ZhString.PetMakeNamePopUp_Hatch
  elseif self.etype == 2 then
    petid = self.petid
    self.cancel_label.text = ZhString.PetMakeNamePopUp_Cancle
    self.confirm_label.text = ZhString.PetMakeNamePopUp_Confirm
  end
  self:UpdateModel(petid)
end
function PetMakeNamePopUp:UpdateModel(petid)
  helplog("UpdateModel", petid)
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
function PetMakeNamePopUp:OnEnter()
  PetMakeNamePopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  self.etype = viewdata.etype
  self.item = viewdata.item
  self.petid = viewdata.petid
  self:UpdateView()
end
function PetMakeNamePopUp:ObserverDestroyed(model)
  if model ~= nil and model == self.model then
    model:SetParent(nil)
    NGUIUtil.ResetRoleRenderQ(model.completeTransform, 2000)
    self.model = nil
  end
end
function PetMakeNamePopUp:OnExit()
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
  PetMakeNamePopUp.super.OnExit(self)
end
