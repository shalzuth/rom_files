local baseCell = autoImport("BaseCell")
EngageDayCell = class("EngageDayCell", baseCell)
function EngageDayCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end
function EngageDayCell:FindObjs()
  self.time = self:FindGO("Time"):GetComponent(UILabel)
  self.booked = self:FindGO("Booked")
  self.myBooked = self:FindGO("MyBooked")
  self.choosed = self:FindGO("Choosed")
  self.disabled = self:FindGO("Disabled")
end
function EngageDayCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local startData = data:GetStartTimeData()
    self.time.text = string.format(ZhString.Wedding_EngageDay, startData.hour)
    self.booked:SetActive(false)
    self.myBooked:SetActive(false)
    self.choosed:SetActive(false)
    self.disabled:SetActive(false)
    if data.status == EngageDayData.Status.Booked then
      local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
      if weddingInfo ~= nil then
        local isWeddingTime = weddingInfo:IsWeddingTime(startData.year, startData.month, startData.day, startData.hour)
        if isWeddingTime then
          self.booked:SetActive(false)
          self.myBooked:SetActive(true)
          return
        end
      end
      self.booked:SetActive(true)
      self.myBooked:SetActive(false)
    elseif data.status == EngageDayData.Status.Ban then
      self.booked:SetActive(false)
      self.myBooked:SetActive(false)
      self.disabled:SetActive(true)
    else
      self.booked:SetActive(false)
      self.myBooked:SetActive(false)
    end
    self.choosed:SetActive(false)
  end
end
function EngageDayCell:Refresh()
  if self.data ~= nil then
    self:SetData(self.data)
  end
end
function EngageDayCell:SetChoose(isChoose)
  if self.data.status ~= EngageDayData.Status.Ban then
    self.choosed:SetActive(isChoose)
  end
end
