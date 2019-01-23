ShopMallExchangeTypesData = class("ShopMallExchangeTypesData")

function ShopMallExchangeTypesData:ctor(data)
	self:SetData(data)
end

function ShopMallExchangeTypesData:SetData(data)
	self.id = data.id
	self.name = data.Name
	if data.JobOption then
		self.jobOption = data.JobOption
	end
	if data.LevelOption then
		self.levelOption = data.LevelOption
	end
	if data.RefineOption then
		self.refineOption = data.RefineOption
	end
end