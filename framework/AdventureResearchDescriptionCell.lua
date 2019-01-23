local baseCell = autoImport("BaseCell")
AdventureResearchDescriptionCell = class("AdventureResearchDescriptionCell",baseCell)

function AdventureResearchDescriptionCell:Init()
	self:initView()	
end

function AdventureResearchDescriptionCell:initView(  )
	-- body
	self.title = self:FindComponent("title",UILabel)
	self.level = self:FindComponent("level",UILabel)
	self.descriptionText = self:FindComponent("descriptionText",UILabel)
	self.icon = self:FindComponent("icon",UISprite)
	self.mask = self:FindGO("mask")
	self.goToCt = self:FindGO("goToCt")
	self:AddClickEvent(self.goToCt,function (  )
		-- body
		self:PassEvent(MouseEvent.MouseClick, self);
	end)
end

function AdventureResearchDescriptionCell:SetData(data)
	if(data)then
		self.data = data
		self.title.text = data.Name
		local menuData = Table_Menu[data.MenuID]
		if(menuData and menuData.Condition and menuData.Condition.level)then
			self.level.text = "LV."..menuData.Condition.level
		else
			self:Hide(self.level.gameObject)
		end

		if(data.GotoMode and #data.GotoMode >0 and FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID))then
			self:Show(self.goToCt)			
		else
			self:Hide(self.goToCt)
		end

		if( not FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID))then
			self:Show(self.mask)
		else
			self:Hide(self.mask)
		end

		self.descriptionText.text =data.des
		self.icon.spriteName = data.icon
	end
end
