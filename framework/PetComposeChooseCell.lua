local BaseCell = autoImport("BaseCell")
PetComposeChooseCell = class("PetComposeChooseCell", BaseCell)
function PetComposeChooseCell:Init()
  self:FindObjs()
  self:AddEvts()
end
function PetComposeChooseCell:FindObjs()
  self.content = self:FindGO("Content")
  self.bg = self:FindGO("bg"):GetComponent(UISprite)
  self.headTipStick = self:FindGO("headTipStick"):GetComponent(UIWidget)
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.level = self:FindGO("petLv"):GetComponent(UILabel)
  self.name = self:FindGO("petName"):GetComponent(UILabel)
  self.limitLab = self:FindGO("limitLab"):GetComponent(UILabel)
end
function PetComposeChooseCell:AddEvts()
  self:AddButtonEvent("icon", function(obj)
    self:PassEvent(PetEvent.ClickPetAdventureIcon, self)
  end)
end
function PetComposeChooseCell:SetData(data)
  self.data = data
  if data then
    self.content:SetActive(true)
    self.name.text = data.name
    local face = data:GetHeadIcon()
    IconManager:SetFaceIcon(face, self.icon)
    self.level.text = string.format(ZhString.PetAdventure_Lv, data.lv)
    self.limitLab.text = string.format(ZhString.PetAdventure_Lv, data.friendlv)
    if data.unlocked then
      self:AddCellClickEvent()
      self:Show(self.limitLab)
      ColorUtil.WhiteUIWidget(self.bg)
    else
      ColorUtil.ShaderLightGrayUIWidget(self.bg)
      self:Hide(self.limitLab)
    end
  else
    self.content:SetActive(false)
  end
end
