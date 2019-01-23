local BaseCell = autoImport("BaseCell");
AdventureAppendCell = class("AdventureAppendCell", BaseCell)
autoImport("AdventureAppendView")

function AdventureAppendCell:Init()
	self:initView()	
end

function AdventureAppendCell:initView(  )
	-- body
	self.appendView = AdventureAppendView.new(self)
	self.isComplete = self:FindGO("isComplete")
	if(self.isComplete)then
		self:Hide(self.isComplete)
	end
	self.bg = self:FindComponent("bg",UISprite)
end

function AdventureAppendCell:SetData( data )
	-- body
	self.data = data
	self.appendView:SetData(data)
	if(data:isCompleted() and self.isComplete)then
		self:Show(self.isComplete)
	end
	local normalGrid = self:FindGO("normalGrid")
	local bound = NGUIMath.CalculateRelativeWidgetBounds(normalGrid.transform,true);
	local height = (bound.size.y)+120
	self.bg.height = height
end
