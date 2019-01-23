local baseCell = autoImport("BaseCell")
ServerStCell = class("ServerStCell", baseCell)

function ServerStCell:Init()
	self.title = self:FindGO("name"):GetComponent(UILabel)
	self.state = self:FindGO("state"):GetComponent(UISprite)
	self:AddCellClickEvent();
end

function ServerStCell:SetData(data)
	self.data = data;
	if(data)then
		self.state.color = Color(1,1,1,1)
		self.title.text = data.name
		if(data.id == SelectServerPanel.ServerConfig.Hot)then
			--red
			self.state.color = Color(203/255,0,8/255,1)
		elseif(data.id == SelectServerPanel.ServerConfig.Normal)then
			--green
			self.state.color = Color(0,168/255,48/255,1)
		elseif(data.id == SelectServerPanel.ServerConfig.Crowd)then
			--yellow
			self.state.color = Color(215/255,175/255,54/255,1)
		elseif(data.id == SelectServerPanel.ServerConfig.Maintain)then
			--gray
			self.state.color = Color(144/255,144/255,144/255,1)
		end
	end
end