local SingleBuildingMatData = class("SingleBuildingMatData")

function SingleBuildingMatData:ctor()
	self.materials={};
	self.rewardData={};
end

function SingleBuildingMatData:SetMaterialData(data)
	self.csvID = data.id 
	self.partsCount=data.count
	self.unitCount=data.itemcount
	self.materials.id=data.itemid
	self.materials.count=self.unitCount*self.partsCount
	self.rewardData=data.rewardid
end

function SingleBuildingMatData:SetBuildingTypeLevel(type, level)
	self.building_type = type
	self.building_level = level
end

GuildBuildingData = class("GuildBuildingData")

function GuildBuildingData.GetComId(gtype, level)
	return gtype * 1000 + level;
end

function GuildBuildingData:SetData(serviceData)
	local staticID=GuildBuildingData.GetComId(serviceData.type, serviceData.level)
	self.type = serviceData.type
	self.level = serviceData.level
	self.PartsRate = ServiceProxy.ServerToNumber(serviceData.progress)
	self.isbuilding = serviceData.isbuilding
	self.restMaterials = serviceData.restmaterials;
	--下一次建造/升级时间
	self.nextBuildTime = serviceData.nextbuildtime;
	self.staticData=Table_GuildBuilding and Table_GuildBuilding[staticID]
	self.uiMatData = {}
	if(self.restMaterials)then
		for i=1,#self.restMaterials do
			local mData = SingleBuildingMatData.new()
			mData:SetMaterialData(self.restMaterials[i]);
			mData:SetBuildingTypeLevel(self.type, self.level);
			self.uiMatData[#self.uiMatData+1]=mData;
		end
	end
end

function GuildBuildingData:LvlLimited()
	if(not self.staticData)then
		return true
	end
	local type = math.floor(self.staticData.id/1000)
	local nextLvl = self.staticData.id%1000 + 1
	return nil==Table_GuildBuilding[GuildBuildingData.GetComId(type,nextLvl)]
end

function GuildBuildingData:CanBuildByTime()
	local curTime = ServerTime.CurServerTime()/1000
	if nil~=self.nextBuildTime and ""~=self.nextBuildTime then
		return curTime >= self.nextBuildTime;
	end
	return false;
end

function GuildBuildingData:GetCondMenu()
	local lvUpCond = self.staticData.LevelUpCond
	if(lvUpCond)then
		local type = lvUpCond.buildingtype
		local lv = lvUpCond.buildinglv
		if(type and lv)then
			local typeLv = GuildBuildingProxy.Instance:GetBuildingLevelByType(type)
			if(not typeLv or typeLv<lv)then
				return lvUpCond.menuDesc
			end
		end
	end
	return nil
end

------------ 显示数据后端计算
-- function GuildBuildingData:ResetMaterialData(submitData)
-- 	self.uiMatData = {}
-- 	local material = self.staticData.Material;
-- 	if(material)then
-- 		local totalSubmitCount,totalCount = 0,0
-- 		for k,v in pairs(material) do
-- 			local submitPart = nil
-- 			totalCount=v+totalCount;
-- 			for i=1,#submitData do
-- 				if(submitData[i].id==k)then
-- 					submitPart=submitData[i].count
-- 					totalSubmitCount=submitPart+totalSubmitCount;
-- 					local parts = v-submitPart
-- 					if(parts>0)then
-- 						local mData = SingleBuildingMatData.new()
-- 						mData:SetMaterialData(k,parts);
-- 						self.uiMatData[k]=mData;
-- 						break;
-- 					end
-- 				end
-- 			end
-- 			if(not submitPart)then
-- 				local mData = SingleBuildingMatData.new()
-- 				mData:SetMaterialData(k,v);
-- 				self.uiMatData[k]=mData;
-- 			end
-- 		end
-- 		self.PartsRate=totalSubmitCount/totalCount
-- 	end
-- end




