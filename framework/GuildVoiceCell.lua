local baseCell = autoImport("BaseCell")
GuildVoiceCell = class("WebCell", baseCell)
function GuildVoiceCell:Init()
  self.Mic = self:FindGO("Mic")
  self.Label = self:FindGO("Label")
  self.Label_UILabel = self:FindGO("Label"):GetComponent(UILabel)
  self._TweenAlphas = self.gameObject:GetComponentsInChildren(TweenAlpha)
  self.bVoiceOpen = false
end
function GuildVoiceCell:SetData(data)
end
function GuildVoiceCell:ShowMic(name, id)
  if not self.gameObject.activeInHierarchy then
    self.gameObject:SetActive(true)
  end
  for k, v in pairs(self._TweenAlphas) do
    v.from = 1
    v.to = 1
    v.value = 1
    v:ResetToBeginning()
  end
  self.Label_UILabel.text = name
  self.bVoiceOpen = true
  self.id = id
end
function GuildVoiceCell:HideMicAndDisappear()
  self.bVoiceOpen = false
  self.id = nil
  for k, v in pairs(self._TweenAlphas) do
    v.from = 1
    v.to = 0
    v:ResetToBeginning()
    v:PlayForward()
  end
end
return GuildVoiceCell
