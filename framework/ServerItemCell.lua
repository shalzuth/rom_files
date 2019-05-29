local baseCell = autoImport("BaseCell")
ServerItemCell = class("ServerItemCell", baseCell)
function ServerItemCell:Init()
  self.questType = -1
  self.title = self:FindGO("name"):GetComponent(UILabel)
  self.state = self:FindGO("state"):GetComponent(UISprite)
  self.collider = self.gameObject:GetComponent(BoxCollider)
  self.newTag = self:FindGO("newTag")
  self:AddCellClickEvent()
end
function ServerItemCell:SetData(data)
  self.data = data
  if data then
    self.state.color = Color(1, 1, 1, 1)
    self.title.color = Color(1, 1, 1, 1)
    self.collider.enabled = true
    self.title.text = data.name
    if data.state == SelectServerPanel.ServerConfig.Hot then
      self.state.color = Color(0.796078431372549, 0, 0.03137254901960784, 1)
    elseif data.state == SelectServerPanel.ServerConfig.Normal then
      self.state.color = Color(0, 0.6588235294117647, 0.18823529411764706, 1)
    elseif data.state == SelectServerPanel.ServerConfig.Crowd then
      self.state.color = Color(0.8431372549019608, 0.6862745098039216, 0.21176470588235294, 1)
    elseif data.state == SelectServerPanel.ServerConfig.Maintain then
      self.state.color = Color(0.5647058823529412, 0.5647058823529412, 0.5647058823529412, 1)
      self.title.color = Color(0.3607843137254902, 0.36470588235294116, 0.3686274509803922, 1)
      self.collider.enabled = false
    end
    if data.isNew then
      self:Show(self.newTag)
    else
      self:Hide(self.newTag)
    end
  end
end
