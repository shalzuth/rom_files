local baseCell = autoImport("BaseCell")
ServerStCell = class("ServerStCell", baseCell)
function ServerStCell:Init()
  self.title = self:FindGO("name"):GetComponent(UILabel)
  self.state = self:FindGO("state"):GetComponent(UISprite)
  self:AddCellClickEvent()
end
function ServerStCell:SetData(data)
  self.data = data
  if data then
    self.state.color = Color(1, 1, 1, 1)
    self.title.text = data.name
    if data.id == SelectServerPanel.ServerConfig.Hot then
      self.state.color = Color(0.796078431372549, 0, 0.03137254901960784, 1)
    elseif data.id == SelectServerPanel.ServerConfig.Normal then
      self.state.color = Color(0, 0.6588235294117647, 0.18823529411764706, 1)
    elseif data.id == SelectServerPanel.ServerConfig.Crowd then
      self.state.color = Color(0.8431372549019608, 0.6862745098039216, 0.21176470588235294, 1)
    elseif data.id == SelectServerPanel.ServerConfig.Maintain then
      self.state.color = Color(0.5647058823529412, 0.5647058823529412, 0.5647058823529412, 1)
    end
  end
end
