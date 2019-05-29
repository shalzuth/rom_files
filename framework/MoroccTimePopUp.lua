MoroccTimePopUp = class("MoroccTimePopUp", BaseView)
MoroccTimePopUp.ViewType = UIViewType.PopUpLayer
local tickInstance = TimeTickManager.Me()
local moroccInstance = MoroccTimeProxy.Instance
function MoroccTimePopUp:Init()
  self:FindObjs()
  self:AddEvents()
end
function MoroccTimePopUp:FindObjs()
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  self.confirmButton = self:FindGO("ConfirmBtn")
  self.cancelButton = self:FindGO("CancelBtn")
  self.confirmButtonOriginalPos = self.confirmButton.transform.position
end
function MoroccTimePopUp:AddEvents()
  self:AddListenEvt(MoroccTimeEvent.ActivityOpen, self.HandleOpenMoroccTime)
  self:AddListenEvt(MoroccTimeEvent.ActivityClose, self.HandleCloseMoroccTime)
  self:AddClickEvent(self.confirmButton, function()
    if self.curMoroccTimeData then
      ServiceUserEventProxy.Instance:CallGoActivityMapUserEvent(self.curMoroccTimeData.ActivityID, self.curMoroccTimeData.MapID)
    end
    self:CloseSelf()
  end)
  self:AddClickEvent(self.cancelButton, function()
    self:CloseSelf()
  end)
end
function MoroccTimePopUp:UpdateShow(isOpen)
  if isOpen == nil then
    self.curMoroccTimeData = moroccInstance:GetCurrentMoroccTimeData()
    isOpen = self.curMoroccTimeData ~= nil
  end
  tickInstance:ClearTick(self)
  if isOpen then
    if not self.curMoroccTimeData then
      self.curMoroccTimeData = moroccInstance:GetCurrentMoroccTimeData()
    end
    if not self.curMoroccTimeData then
      LogUtility.Error("MoroccTimePopUp: Cannot get current MoroccTimeData when Morroc activity is open!")
      return
    end
    self.contentLabel.text = string.format(ZhString.MoroccSeal_ActivityOpenMsg, Table_Map[self.curMoroccTimeData.MapID].NameZh)
    self.cancelButton:SetActive(true)
    self.confirmButton.transform.position = self.confirmButtonOriginalPos
  else
    self.curMoroccTimeData = nil
    self.period = moroccInstance:GetPeriodFromNowToNextMoroccActStart()
    if not self.period then
      LogUtility.Warning("MoroccTimePopUp: Cannot get period from now to next Morocc activity start!")
      self.contentLabel.text = ZhString.MoroccSeal_NoNextActivityMsg
      if not moroccInstance:IsInMorrocTime() then
        self:sendNotification(MoroccTimeEvent.NoNextActivity)
      end
    else
      tickInstance:CreateTick(0, 100, self.UpdateTick, self)
    end
    self.cancelButton:SetActive(false)
    local newPos = self.confirmButtonOriginalPos
    newPos.x = 0
    self.confirmButton.transform.position = newPos
  end
end
function MoroccTimePopUp:HandleOpenMoroccTime()
  self:UpdateShow(true)
end
function MoroccTimePopUp:HandleCloseMoroccTime()
  self:UpdateShow(false)
end
function MoroccTimePopUp:OnEnter()
  MoroccTimePopUp.super.OnEnter(self)
  self:UpdateShow()
end
function MoroccTimePopUp:OnExit()
  self.cancelButton:SetActive(true)
  self.confirmButton.transform.position = self.confirmButtonOriginalPos
  tickInstance:ClearTick(self)
  MoroccTimePopUp.super.OnExit(self)
end
function MoroccTimePopUp:UpdateTick(interval)
  local h = math.floor(self.period / 3600)
  local min = math.floor((self.period - 3600 * h) / 60)
  local s = math.floor(self.period - 3600 * h - 60 * min)
  local periodStr = string.format("%02d:%02d:%02d", h, min, s)
  self.contentLabel.text = string.format(ZhString.MoroccSeal_ActivityCloseMsg, periodStr)
  self.period = self.period - interval / 1000
  if self.period < 0 then
    self.period = 0
    tickInstance:ClearTick(self)
  end
end
