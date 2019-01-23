local baseCell = autoImport("BaseCell")
ServerItemCell = class("ServerItemCell", baseCell)

function ServerItemCell:Init()
	self.questType = -1
	self.title = self:FindGO("name"):GetComponent(UILabel)
	self.state = self:FindGO("state"):GetComponent(UISprite)
	self.collider = self.gameObject:GetComponent(BoxCollider)
	self.newTag = self:FindGO("newTag")
	self:AddCellClickEvent();
end

function ServerItemCell:SetData(data)
	self.data = data;
	if(data)then
		self.state.color = Color(1,1,1,1)
		self.title.color = Color(1,1,1,1)
		self.collider.enabled = true
		self.title.text = data.name;
		if(data.state == SelectServerPanel.ServerConfig.Hot)then
			--red
			self.state.color = Color(203/255,0,8/255,1)
		elseif(data.state == SelectServerPanel.ServerConfig.Normal)then
			--green
			self.state.color = Color(0,168/255,48/255,1)
		elseif(data.state == SelectServerPanel.ServerConfig.Crowd)then
			--yellow
			self.state.color = Color(215/255,175/255,54/255,1)
		elseif(data.state == SelectServerPanel.ServerConfig.Maintain)then
			--gray
			self.state.color = Color(144/255,144/255,144/255,1)
			self.title.color = Color(92/255,93/255,94/255,1)
			self.collider.enabled = false
		end
		if(data.isNew)then
			self:Show(self.newTag)
		else
			self:Hide(self.newTag)
		end
	end
end

-- function ServerItemCell:SetCurrentServer( bArg )
-- 	-- body
-- 	if(bArg)then
-- 		self.title.color = Color(1,246/255,150/255)
-- 	else
-- 		self.title.color = Color.white
-- 	end
-- end


