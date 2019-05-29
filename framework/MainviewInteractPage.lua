MainviewInteractPage = class("MainviewInteractPage", SubView)
local ForbidShowReason = {
  Trigger = 1,
  AutoBattle = 2,
  Booth = 3,
  NoAct = 4
}
function MainviewInteractPage:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end
function MainviewInteractPage:FindObjs()
  self.interactBtn = self:FindGO("InteractBtn"):GetComponent(UIMultiSprite)
  self.interactBtnGO = self.interactBtn.gameObject
  self.interactLabel = self:FindGO("Label", self.interactBtnGO):GetComponent(UILabel)
end
function MainviewInteractPage:AddButtonEvt()
  self:AddClickEvent(self.interactBtnGO, function()
    Game.InteractNpcManager:MyselfManualClick()
  end)
end
function MainviewInteractPage:AddViewEvt()
  self:AddListenEvt(InteractNpcEvent.MyselfTriggerChange, self.HandleTriggerChange)
  self:AddListenEvt(InteractNpcEvent.MyselfOnOffChange, self.UpdateInteractBtn)
  self:AddListenEvt(ServiceEvent.NUserBoothReqUserCmd, self.HandleBooth)
  self:AddListenEvt(MyselfEvent.MyPropChange, self.HandleProp)
  self:AddDispatcherEvt(AutoBattleManagerEvent.StateChanged, self.HandleAutoBattle)
end
function MainviewInteractPage:InitShow()
  self.reasonMap = {}
end
function MainviewInteractPage:HandleTriggerChange(note)
  self:UpdateReason(ForbidShowReason.Trigger, not note.body and 1 or 0)
end
function MainviewInteractPage:HandleAutoBattle()
  self:UpdateReason(ForbidShowReason.AutoBattle, Game.AutoBattleManager.on and 1 or nil)
end
function MainviewInteractPage:HandleBooth()
  self:UpdateReason(ForbidShowReason.Booth, Game.Myself:IsInBooth() and 1 or nil)
end
function MainviewInteractPage:HandleProp()
  self:UpdateReason(ForbidShowReason.NoAct, Game.Myself.data:NoAct() and 1 or nil)
end
function MainviewInteractPage:UpdateReason(type, value)
  local hasReason = self.reasonMap[type]
  if hasReason ~= value then
    self.reasonMap[type] = value
    self:ShowInteractBtn()
  end
end
function MainviewInteractPage:ShowInteractBtn()
  for k, v in pairs(self.reasonMap) do
    if v == 1 then
      if self.interactBtnGO.activeSelf then
        self.interactBtnGO:SetActive(false)
      end
      return
    end
  end
  if self.reasonMap[ForbidShowReason.Trigger] == 0 then
    self.interactBtnGO:SetActive(true)
    self:UpdateInteractBtn()
  end
end
function MainviewInteractPage:UpdateInteractBtn(note)
  local isMyselfOnNpc = note and note.body or Game.InteractNpcManager:IsMyselfOnNpc()
  self.interactBtn.CurrentState = isMyselfOnNpc and 1 or 0
  self.interactLabel.text = isMyselfOnNpc and ZhString.InteractNpc_GetOff or ZhString.InteractNpc_GetOn
end
