local baseCell = autoImport("BaseCell")
PersonalTempPictureTabCell = class("PersonalTempPictureTabCell",baseCell)

function PersonalTempPictureTabCell:Init()
	self:initView()
	self:initData()
end

function PersonalTempPictureTabCell:initView(  )
	-- body
	self.label = self:FindComponent("PersonalTabLabel",UILabel)
end

function PersonalTempPictureTabCell:initData(  )
	-- body
end

local tempColor = LuaColor(38/255,72/255,148/255)
function PersonalTempPictureTabCell:setIsSelected( isSelected )
	-- body
	if self.isSelected ~= isSelected then
		self.isSelected = isSelected
		if(isSelected)then
			self.label.effectStyle = UILabel.Effect.Outline8
			self.label.effectColor = tempColor
		else			
			self.label.effectStyle = UILabel.Effect.None
		end
	end
end

function PersonalTempPictureTabCell:SetData(data)
	self.data = data
	self.label.text = data.name
end
