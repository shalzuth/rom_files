ServantRecommendItemData = class("ServantRecommendItemData")

function ServantRecommendItemData:ctor(data)
	self.id = data.dwid
	self.staticData = Table_Recommend[data.dwid]
	self.finish_time = data.finishtimes
	self.status = data.status
	self.real_open = data.realopen
end

function ServantRecommendItemData:IsActive()
	if(self.staticData)then
		local typeCfg = self.staticData.PageType
		for i=1,#typeCfg do
			if(1==typeCfg[i])then
				return true
			end
		end
	end
	return false
end

function ServantRecommendItemData:isActiveOpen()
	return (self:IsActive() and self.real_open==true)
end
