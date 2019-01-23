ItemInfo = class("ItemInfo")

function ItemInfo:ctor(itemId)
   self.id = itemId
   self.quality = nil
   self.count = nil
   if(itemId)then
   		self:SetItemInfo(itemId)
   end
end


function ItemInfo:SetItemInfo(itemId)
	local item = Table_Item[itemId]
	if(item)then
		self.id = itemId
		self.quality=item.Quality
		self.count=0
		--print(self.id)
		--print(self.quality)
	end
end