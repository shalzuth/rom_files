BaseCell = autoImport("BaseCell")
CarrierWaitListCell = class("CarrierWaitListCell", BaseCell)
function CarrierWaitListCell:Init()
  self.nameLabel = self:FindGO("Name"):GetComponent(UILabel)
  self.waitSp = self:FindGO("Wait")
  self.confirmSp = self:FindGO("Confirm"):GetComponent(UIMultiSprite)
  self.summoned = self:FindGO("Summoned")
  self:Hide(self.confirmSp)
end
function CarrierWaitListCell:SetData(data)
  self.data = data
  self.nameLabel.text = self.data.name
  if self.data.summon then
    self:ActiveSummoned(true)
    return
  end
  self:ActiveSummoned(false)
  if self.data.agree ~= nil then
    self:Agree(self.data.agree)
  end
end
function CarrierWaitListCell:Agree(value)
  self:Show(self.confirmSp)
  self:Hide(self.waitSp)
  if value then
    self.confirmSp.CurrentState = 0
  else
    self.confirmSp.CurrentState = 1
  end
  ColorUtil.WhiteUIWidget(self.confirmSp)
end
function CarrierWaitListCell:Leave()
  self:Show(self.confirmSp)
  self:Hide(self.waitSp)
  self.confirmSp.CurrentState = 2
  ColorUtil.ShaderGrayUIWidget(self.confirmSp)
end
function CarrierWaitListCell:ActiveSummoned(b)
  if b then
    self.summoned:SetActive(true)
    self:Hide(self.confirmSp)
    self:Hide(self.waitSp)
  else
    self.summoned:SetActive(false)
  end
end
