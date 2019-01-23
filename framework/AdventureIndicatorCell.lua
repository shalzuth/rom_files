local baseCell = autoImport("BaseCell")
AdventureIndicatorCell = class("AdventureIndicatorCell", baseCell)
function AdventureIndicatorCell:Init()
	AdventureIndicatorCell.super.Init(self);
	self:initView()
end

local tempColor = LuaColor.white
function AdventureIndicatorCell:initView(  )
	-- body
	self.bg = self.gameObject:GetComponent(UISprite)
end

function AdventureIndicatorCell:SetData( data)
	-- body
	if(data.cur)then
		tempColor:Set(1,171/255.0,61/255.0,1)
		self.bg.color = tempColor
	else
		tempColor:Set(1,1,1,1)
		self.bg.color = tempColor
	end
end