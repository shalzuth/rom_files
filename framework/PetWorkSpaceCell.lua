local BaseCell = autoImport("BaseCell")
autoImport("PetWorkSpaceEmoji")
PetWorkSpaceCell = class("PetWorkSpaceCell", BaseCell)
local path = ResourcePathHelper.UICell("PetWorkSpaceEmoji")
function PetWorkSpaceCell:Init()
  self:FindObjs()
  self:AddEvt()
  self:AddCellClickEvent()
end
function PetWorkSpaceCell:FindObjs()
  self.emojiRoot = self:FindGO("emojiRoot")
  self.emoji = self:LoadPreferb_ByFullPath(path, self.emojiRoot)
  self.emoji.transform.localPosition = Vector3.zero
  self.spaceEmoji = PetWorkSpaceEmoji.new(self.emoji)
  self.spaceEmoji:AddEventListener(MouseEvent.MouseClick, self.OnReward, self)
  self.icon = self:FindComponent("icon", UISprite)
  self.lockImg = self:FindGO("locked")
  self.unlockImg = self:FindGO("unlocked")
  self.name = self:FindComponent("name", UILabel)
  self.content = self:FindGO("Content")
  self.effectContainer = self:FindGO("EffectContainer")
  self.workingEffContainer = self:FindGO("WorkingEffContainer")
  self.activeImg = self:FindGO("ActiveImg")
end
function PetWorkSpaceCell:AddEvt()
  self:AddClickEvent(self.icon.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function PetWorkSpaceCell:OnReward(cellCtl)
  if self.data then
    local data = PetWorkSpaceProxy.Instance:GetWorkSpaceDataById(self.data.id)
    if data and data.activeForbiddenFlag then
      MsgManager.ShowMsgByID(25716)
      return
    end
    ServiceScenePetProxy.Instance:CallGetPetWorkRewardPetCmd(self.data.id)
  end
end
function PetWorkSpaceCell:SetData(data)
  self.data = data
  if data then
    self.content:SetActive(true)
    self:UpdateUI()
  else
    self.content:SetActive(false)
  end
end
function PetWorkSpaceCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function PetWorkSpaceCell:PlayChooseEffect()
  self.chooseEff = self:PlayUIEffect(EffectMap.UI.Selected, self.effectContainer, false)
end
function PetWorkSpaceCell:UpdateChoose()
  if self.id and self.id == self.chooseId then
    if nil == self.chooseEff then
      self:PlayChooseEffect()
    end
    self:Show(self.effectContainer)
  else
    self:Hide(self.effectContainer)
  end
end
function PetWorkSpaceCell:UpdateUI()
  local staticData = self.data.staticData
  self.name.text = staticData.Name
  if self.activeImg then
    self.activeImg:SetActive(nil ~= staticData.ActID)
  end
  self:_setStatus()
  self:UpdateChoose()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.Update, self)
end
function PetWorkSpaceCell:Update()
  if Slua.IsNull(self.gameObject) then
    self:ClearTick()
    return
  end
  local data = self.data
  if data then
    if data:MaxRewardLimited() and data.petEggs and #data.petEggs > 0 then
      self.spaceEmoji:SetData("rest")
      return
    end
    local reward = data:GetUIReward()
    if data.state == PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_WORKING and not data.activeForbiddenFlag then
      self.spaceEmoji:SetData(reward)
    elseif data.state == PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST then
      if reward then
        self.spaceEmoji:SetData(reward)
      else
        self.spaceEmoji:SetData("rest")
      end
    end
  end
end
function PetWorkSpaceCell:_refreshWorkingEff()
  local data = self.data
  local isWorking = data:IsWorking()
  if data:IsUnlock() and isWorking and not data:IsOverCfgTime() and not data:MaxRewardLimited() then
    if nil == self.workingEff then
      self.workingEff = self:PlayUIEffect(EffectMap.UI.PetWork, self.workingEffContainer, false)
    end
    self:Show(self.workingEffContainer)
  else
    self.Hide(self.workingEffContainer)
  end
end
local tempColor = LuaColor.white
function PetWorkSpaceCell:_setStatus()
  local data = self.data
  self.id = data.id
  IconManager:SetUIIcon(data.staticData.Gate, self.icon)
  ColorUtil.WhiteUIWidget(self.icon)
  self:_refreshWorkingEff()
  if not data:IsOpen() then
    self:Hide(self.lockImg)
    self:Hide(self.unlockImg)
    self.name.text = ZhString.PetWorkSpace_unLockSpaceName
    tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
    self.icon.color = tempColor
    self:Hide(self.emoji)
  elseif not data:IsUnlock() then
    self:Show(self.lockImg)
    self:Hide(self.unlockImg)
    self:Hide(self.emoji)
  elseif data.state == PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_UNUSED then
    self:Show(self.unlockImg)
    self:Hide(self.lockImg)
    self:Hide(self.emoji)
  elseif data.state == PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_WORKING then
    self:Show(self.emoji)
    self:Hide(self.lockImg)
    self:Hide(self.unlockImg)
  elseif data.state == PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST then
    self:Show(self.emoji)
    self:Hide(self.lockImg)
    self:Hide(self.unlockImg)
  end
end
function PetWorkSpaceCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
  end
end
function PetWorkSpaceCell:OnDestroy()
  self:ClearTick()
end
