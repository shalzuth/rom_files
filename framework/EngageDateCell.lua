local baseCell = autoImport("BaseCell")
EngageDateCell = class("EngageDateCell", baseCell)
function EngageDateCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end
function EngageDateCell:FindObjs()
  self.bgColor = self:FindGO("BgColor"):GetComponent(GradientUISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.date = self:FindGO("Date"):GetComponent(UILabel)
  self.pic = self:FindGO("Pic"):GetComponent(UITexture)
  self.bookedRoot = self:FindGO("BookedRoot")
  self.booked = self:FindGO("Booked"):GetComponent(UILabel)
  self.status = self:FindGO("Status"):GetComponent(UIMultiSprite)
  self.statusLabel = self:FindGO("Label", self.status.gameObject):GetComponent(UILabel)
  self.bookedCount = self:FindGO("BookedCount")
end
local weekConf = {
  [1] = "\236\155\148",
  [2] = "\237\153\148",
  [3] = "\236\136\152",
  [4] = "\235\170\169",
  [5] = "\234\184\136",
  [6] = "\237\134\160",
  [7] = "\237\134\160"
}
function EngageDateCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local config = GameConfig.Wedding.EngageDate[data.time.wday]
    if config ~= nil then
      local topColor = config.topColor
      if topColor ~= nil then
        local result, value = ColorUtil.TryParseHexString(topColor)
        if result then
          self.bgColor.gradientTop = value
        end
      end
      local bottomColor = config.bottomColor
      if bottomColor ~= nil then
        local result, value = ColorUtil.TryParseHexString(bottomColor)
        if result then
          self.bgColor.gradientBottom = value
        end
      end
      self.name.text = config.name
      local realDay = weekConf[tonumber(config.wday)]
      if realDay == nil then
        realDay = config.wday
      end
      self.date.text = string.format(ZhString.Wedding_EngageDateWday, data:GetDateString(), realDay)
      PictureManager.Instance:SetWedding(config.picName, self.pic)
    end
    local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
    if weddingInfo ~= nil then
      local time = data.time
      local isWeddingTime = weddingInfo:IsWeddingTime(time.year, time.month, time.day)
      if isWeddingTime then
        local startData = weddingInfo:GetStartTimeData()
        local endData = weddingInfo:GetEndTimeData()
        self.bookedRoot:SetActive(true)
        self.booked.text = string.format(ZhString.Wedding_EngageBookedDate, startData.hour, endData.hour)
      else
        self.bookedRoot:SetActive(false)
      end
    else
      self.bookedRoot:SetActive(false)
    end
    local _Status = EngageDateData.Status
    if data.status == _Status.None then
      self.status.gameObject:SetActive(false)
      self.bookedCount:SetActive(data.count > 0)
    elseif data.status == _Status.Hot then
      self.status.gameObject:SetActive(true)
      self.bookedCount:SetActive(false)
      self.status.CurrentState = 0
      self.statusLabel.effectColor = ColorUtil.ButtonLabelOrange
      self.statusLabel.text = ZhString.Wedding_EngageHot
    elseif data.status == _Status.Full then
      self.status.gameObject:SetActive(true)
      self.bookedCount:SetActive(false)
      self.status.CurrentState = 1
      self.statusLabel.effectColor = ColorUtil.Red
      self.statusLabel.text = ZhString.Wedding_EngageFull
    end
  end
end
