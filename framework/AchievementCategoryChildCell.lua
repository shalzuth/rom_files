local baseCell = autoImport("BaseCell")
AchievementCategoryChildCell = class("AchievementCategoryChildCell",baseCell)

AchievementCategoryChildCell.selectedColor = LuaColor(36/255,127/255,192/255,1)
AchievementCategoryChildCell.unselectedColor = LuaColor(60/255,60/255,60/255,1)

function AchievementCategoryChildCell:Init()
	self:initView()
	self:initData()
	self:AddCellClickEvent();
	-- self:setSelected(false)
end

function AchievementCategoryChildCell:initData(  )
	self.Name.color = AchievementCategoryChildCell.unselectedColor
end

function AchievementCategoryChildCell:initView(  )
	-- body
	-- self.icon = self:FindGO("icon"):GetComponent(UISprite)
	self.Name = self:FindGO("Name"):GetComponent(UILabel)
	-- self.selectedBg = self:FindGO("selectedBg")
	self.Value = self:FindComponent("Value",UILabel)
	self.bg = self:FindComponent("bg",UISprite)
end

function AchievementCategoryChildCell:SetData(data)
	self.data = data
	self.Name.text = data.staticData.Name

	local unlock,total = AdventureAchieveProxy.Instance:getAchieveAndTotalNum(data.staticData.SubGroup,data.staticData.id)
	self.Value.text = unlock.."/"..total
end

function AchievementCategoryChildCell:setSelected(isSelected)
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
		if(isSelected)then
			self.Name.color = AchievementCategoryChildCell.selectedColor
		else
			self.Name.color = AchievementCategoryChildCell.unselectedColor
		end
	end	
end
