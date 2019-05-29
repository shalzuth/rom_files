autoImport("WarnPopup")
UIWarning = class("UIWarning", BaseView)
UIWarning.ViewType = UIViewType.WarnLayer
UIWarning.Instance = nil
UIWarning.txt = ZhString.UIWarning_ReconnectLabel
function UIWarning:Init()
  UIWarning.Instance = self
  self.warnPopupsData = {}
  self.warnPopup = nil
  self:FindObjs()
  self:HideBord()
end
function UIWarning:FindObjs()
  self.bords = {
    WaitingBord = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "WaitingBord")
  }
  self.bgCollider = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "bgCollider")
  local waitLabel = self:FindGO("waitLabel"):GetComponent(UILabel)
  waitLabel.text = ZhString.UIWarning_ReconnectLabel
end
function UIWarning:ShowBord(key)
  for k, v in pairs(self.bords) do
    v:SetActive(k == key)
  end
  self.bgCollider:SetActive(true)
end
function UIWarning:HideBord()
  for k, v in pairs(self.bords) do
    v:SetActive(false)
  end
  self.bgCollider:SetActive(false)
end
function UIWarning:RestartEvt(note)
  self:HideBord()
  FunctionNetError.Me():ShowErrorById(4)
end
function UIWarning:WaitEvt(note)
  LogUtility.Info("WaitEvt")
  self:ShowBord("WaitingBord")
end
function UIWarning:ReConnEvt(note)
  LogUtility.Info("ReConnEvt")
  self:HideBord()
end
function UIWarning:AddWarnPopUp(data)
  self.warnPopupsData[#self.warnPopupsData + 1] = data
  self:TryPopupWarning()
end
function UIWarning:TryPopupWarning()
  if #self.warnPopupsData > 0 then
    local data = table.remove(self.warnPopupsData, 1)
    if self.warnPopup == nil then
      self.warnPopup = WarnPopup.new(data, self.gameObject)
      self.warnPopup:AddEventListener(UIEvent.CloseUI, self.HandleCloseWarnPopup, self)
    else
      self.warnPopup:ResetData(data)
    end
  elseif self.warnPopup ~= nil then
    self.warnPopup:RemoveEventListener(UIEvent.CloseUI, self.HandleCloseWarnPopup, self)
    self.warnPopup:Destroy()
    self.warnPopup = nil
  end
end
function UIWarning:HandleCloseWarnPopup()
  self:TryPopupWarning()
end
