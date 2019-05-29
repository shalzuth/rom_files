local baseCell = autoImport("BaseCell")
autoImport("QuestData")
NewServerListCell = class("NewServerListCell", baseCell)
function NewServerListCell:Init()
  self:initView()
  self:AddCellClickEvent()
end
function NewServerListCell:initView()
  self.serverName = self:FindComponent("ServerName", UILabel)
  self.serverStateText = self:FindComponent("ServerStateText", UILabel)
end
function NewServerListCell:SetData(data)
  self.data = data
  self.serverName.text = data.name
  self.serverStateText.text = FunctionLogin.GetStateText(data.state)
  self.serverStateText.color = FunctionLogin.GetStateColor(data.state)
  self.serverStateText.fontSize = FunctionLogin.GetStateTextSize(data.state)
  self.serverName.color = FunctionLogin.GetServerNameColor(data.state)
end
