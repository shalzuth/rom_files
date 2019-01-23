local BaseCell = autoImport("BaseCell");
PropTypeCell = class("PropTypeCell", BaseCell);

local selectedSp= Color(215.0/255.0,239.0/255.0,254.0/255.0,1)
local selectedLabel = Color(0.0/255.0,116/255.0,188/255.0,1)

function PropTypeCell:Init()
	self:initView()
	self:AddCellClickEvent();
	self.isSelected = true
	self:SetIsSelect(false)
end

function PropTypeCell:initView()
	self.name =self:FindComponent("name",UILabel)
	self.bg =self:FindComponent("bg",UISprite)
end

function PropTypeCell:SetIsSelect(ret)
	if(self.isSelected ~= ret)then
		if(ret)then
			self.name.color = selectedLabel
			self.bg.color = selectedSp
		else
			self.name.color = LuaColor.black
			self.bg.color = LuaColor.white
		end
		self.isSelected = ret
	end
end

function PropTypeCell:SetData(data)
	self.data = data
	if(self.data.name)then
		self.name.text = self.data.name
	end
end


