RefineTypeData = class("RefineTypeData")

function RefineTypeData:ctor(equipType)
	self.equipType = equipType
	self:Init()
end

function RefineTypeData:Init()
	self.qualityMap = {}
end

function RefineTypeData:AddData(data)
	for i=1,#data.RefineCost do
		self:AddQualityData(data,data.RefineCost[i].color)
	end
end

function RefineTypeData:AddQualityData(data,Color)
	local map = self.qualityMap[Color]
	if(not map) then
		map = {}
		map.maxLevel = data.RefineLv
		self.qualityMap[Color] = map
	else
		map.maxLevel = math.max(map.maxLevel,data.RefineLv)
	end
	map[data.RefineLv] = data
end

function RefineTypeData:GetRefineMaxLevel(quality)
	local map = self.qualityMap[quality]
	if(map) then
		return map.maxLevel
	end
	return 0
end

function RefineTypeData:GetData(quality,level)
	local map = self.qualityMap[quality]
	if(map) then
		return map[level]
	end
	return nil
end
