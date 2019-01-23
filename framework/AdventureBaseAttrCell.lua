local BaseCell = autoImport("BaseCell");
AdventureBaseAttrCell = class("AdventureBaseAttrCell", BaseCell)

function AdventureBaseAttrCell:Init()
	self:initView()	
end

function AdventureBaseAttrCell:initView(  )
	-- body
	self.name = self:FindComponent("Name",UILabel)
	self.value = self:FindComponent("Value",UILabel)
end

function AdventureBaseAttrCell:SetData( data )
	-- body
	self.name.text = data.name
	self.value.text = data.value
end
