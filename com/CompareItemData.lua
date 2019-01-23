autoImport("ItemData")
CompareItemData = class("CompareItemData",ItemData)

function CompareItemData:ctor(id,staticId)
	CompareItemData.super.ctor(self,id,staticId)
end

function CompareItemData:SetComparedSite(site)
	self.site = site
end