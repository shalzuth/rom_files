local baseCell = autoImport("BaseCell")
AdventureProfessionCell = class("AdventureProfessionCell",baseCell)

function AdventureProfessionCell:Init()
	self:initView()	
end

function AdventureProfessionCell:initView(  )
	-- body
	self.icon = self:FindGO("icon"):GetComponent(UISprite)
	self.level = self:FindGO("level"):GetComponent(UILabel)
end

function AdventureProfessionCell:SetData(data)
	IconManager:SetProfessionIcon(data.professionData.icon,self.icon)
	self.level.text = data:GetLevelText()
end
