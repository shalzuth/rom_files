EmbedViewSlotCell = class("EmbedViewSlotCell",BaseCell)

function EmbedViewSlotCell:Init(  )
 	-- body
 	self:initView()
end 


function EmbedViewSlotCell:initView(  )
 	-- body
 	self.icon = self.gameObject:GetComponent(UISprite)
end

function EmbedViewSlotCell:SetData( data )
	-- body
	self.data = data
	-- self.	
	if(data.staticData == nil)then
		self.icon.spriteName = "card_icon_0"
	else
		local iconStr = "card_icon_"..data.staticData.Quality
		self.icon.spriteName = iconStr
	end

	-- self.icon.spriteName = iconStr

end
