local BaseCell = autoImport("BaseCell")
MainViewButtonCell = class("MainViewButtonCell", BaseCell)
MainViewButtonType = {
  Menu = 1,
  Activity = 2,
  Auction = 3
}
MainViewButtonEvent = {
  Exit = "MainViewButtonEvent_Exit",
  ResetPosition = "MainViewButtonEvent_ResetPosition"
}
PlatformHideMap = {
  [1] = RuntimePlatform.IPhonePlayer,
  [2] = RuntimePlatform.Android
}
function MainViewButtonCell:Init()
  self:InitUI()
end
function MainViewButtonCell:InitUI()
  self.sprite = self:FindComponent("Sprite", UISprite)
  self.label = self:FindComponent("Label", UILabel)
  self:AddCellClickEvent()
end
function MainViewButtonCell:SetData(data)
  self.data = data
  local sData = self.data.staticData
  if data.type == MainViewButtonType.Menu then
    if sData.name == "GM" then
      self.gameObject:SetActive(false)
      return
    end
    self.label.text = sData.name
    IconManager:SetUIIcon(sData.icon or "", self.sprite)
    self.sprite:MakePixelPerfect()
    local platHide = false
    local nowPlatform = ApplicationInfo.GetRunPlatform()
    if type(sData.Enterhide) == "table" then
      for i = 1, #sData.Enterhide do
        local platformType = sData.Enterhide[i]
        if platformType == 0 or nowPlatform == PlatformHideMap[platformType] then
          platHide = true
          break
        end
      end
    end
    if platHide then
      self.gameObject:SetActive(false)
      return
    end
    self.gameObject:SetActive(not self:CheckIosBranchHide())
  elseif data.type == MainViewButtonType.Activity then
    self.label.text = sData.Name
    IconManager:SetUIIcon(sData.Icon or "", self.sprite)
    self.sprite:MakePixelPerfect()
    self:UpdateActivityState()
  elseif data.type == MainViewButtonType.Auction then
    self.label.text = data.Name
    IconManager:SetUIIcon(data.Icon or "", self.sprite)
    self.sprite:MakePixelPerfect()
  end
end
local EnvChannelIndex = {
  [EnvChannel.ChannelConfig.Release.Name] = 32,
  [EnvChannel.ChannelConfig.Oversea.Name] = 32
}
function MainViewButtonCell:CheckIosBranchHide()
  return false
end
function MainViewButtonCell:UpdateActivityState()
  local aType = self.data and self.data.staticData.id
  if aType then
    local running = FunctionActivity.Me():IsActivityRunning(aType)
    self.gameObject:SetActive(running)
  else
    self.gameObject:SetActive(false)
  end
end
function MainViewButtonCell:UpdateAuction(totalSec, hour, min, sec)
  if self.data and totalSec ~= nil and hour ~= nil then
    if hour >= 24 then
      self.label.text = string.format(ZhString.Auction_CountdownDayName, hour / 24)
    else
      self.label.text = string.format(self.data.Name, hour, min, sec)
    end
  end
end
