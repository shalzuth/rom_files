local BaseCell = autoImport("BaseCell");
AdventureDropCell = class("AdventureDropCell", BaseCell)

function AdventureDropCell:Init()
	self:initView()	
end

function AdventureDropCell:initView(  )
	-- body
	self.Icon = self:FindComponent("Icon",UISprite)
	self.value = self:FindComponent("Value",UILabel)
	
	--todo xde
	OverseaHostHelper:FixLabelOverV1(self.value,3,290)
end

function AdventureDropCell:SetData( data )
	-- body
	local sdata = data.itemData
	IconManager:SetItemIcon(sdata.Icon,self.Icon)
	self.value.text = string.format("%sX%d",sdata.NameZh,data.num)
end
