local baseCell = autoImport("BaseCell")
MainViewChatCell = class("MainViewChatCell", baseCell)
function MainViewChatCell:Init()
  self:FindObjs()
  self.label.fontSize = 20
end
function MainViewChatCell:FindObjs()
  self.label = self.gameObject:GetComponent(UILabel)
end
function MainViewChatCell:SetData(data)
  self.label.text = data
end
