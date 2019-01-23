autoImport("GuildBuildingData");
autoImport("GuildingRankData")
GuildBuildingProxy = class('GuildBuildingProxy',pm.Proxy)
GuildBuildingProxy.Instance = nil;
GuildBuildingProxy.NAME = "GuildBuildingProxy"

GuildBuildingProxy.Type={
	EGUILDBUILDING_VENDING_MACHINE = GuildCmd_pb.EGUILDBUILDING_VENDING_MACHINE,					-- 自动贩卖机
	EGUILDBUILDING_BAR = GuildCmd_pb.EGUILDBUILDING_BAR,							-- 吧台猫老板
	EGUILDBUILDING_CAT_LITTER_BOX = GuildCmd_pb.EGUILDBUILDING_CAT_LITTER_BOX,		-- 福利猫砂盆
	EGUILDBUILDING_MAGIC_SEWING = GuildCmd_pb.EGUILDBUILDING_MAGIC_SEWING, 			-- 魔法缝纫机
	EGUILDBUILDING_HIGH_REFINE = GuildCmd_pb.EGUILDBUILDING_HIGH_REFINE,			-- 极限精炼铁砧
	EGUILDBUILDING_ARTIFACT_HEAD = GuildCmd_pb.EGUILDBUILDING_ARTIFACT_HEAD, 		-- 头饰工坊
	EGUILDBUILDING_EGUILDBUILDING_CAT_PILLOW = GuildCmd_pb.EGUILDBUILDING_CAT_PILLOW, -- 猫咪睡眠枕
}

GuildBuildingProxy.BuildAuth=
{
	EBuildAuth_OnBuild=1,
	EBuildAuth_OnCD=2,
	EBuildAuth_Success=3,
}

function GuildBuildingProxy:ctor(proxyName, data)
	self.proxyName = proxyName or GuildBuildingProxy.NAME
	if(GuildBuildingProxy.Instance == nil) then
		GuildBuildingProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:ResetData()
end

function GuildBuildingProxy:InitBuilding(nnpc,params)
	self.npc=nnpc
	self.params=params
end

function GuildBuildingProxy:GetNPC()
	return self.npc
end

function GuildBuildingProxy:GetBuildingType()
	return self.params
end

function GuildBuildingProxy:ResetData()
	self.BuildingData = {};
	self.shopBuildType={}
	self.rankArray={}
end

function GuildBuildingProxy:SetBuildingData(serviceData)
	local dataCount = #serviceData
	for i=1,#serviceData do
		local data = GuildBuildingData.new();
		data:SetData(serviceData[i])
		self.BuildingData[data.type]=data
	end
end

function GuildBuildingProxy:SetSubmitTimes(t)
	self.curSubmitTime=t
end

function GuildBuildingProxy:PlayBuildingLvupEff(effects)
	local sendTypes = {}
	for i=1,#effects do
		local gType = effects[i].type
		local glevel = effects[i].level
		local buildingData = self:GetBuildingDataByType(gType)
		if(buildingData and buildingData.staticData)then
			local data=GuildCmd_pb.BuildingLvupEffect()
			local name = buildingData.staticData.Name
			local icon = buildingData.staticData.Icon
			self:_playEffect(icon,name,glevel)
			data.type=gType
			data.level=glevel
			sendTypes[#sendTypes+1]=data
		end
	end
	if(#sendTypes>0)then
		ServiceGuildCmdProxy.Instance:CallBuildingLvupEffGuildCmd(sendTypes);
	end
end

function GuildBuildingProxy:PlayUpdateEffect()
	local myGuildMemberData = GuildProxy.Instance:GetMyGuildMemberData();
	if(myGuildMemberData)then
		local guildings = myGuildMemberData:GetBuildingLevelup();
		local sendTypes = {}
		for i=1,#guildings do
			local gType = guildings[i].type
			local needPlay = guildings[i].levelupeffect
			if(needPlay)then
				local buildingData = self.BuildingData[gType]
				if(buildingData and buildingData.staticData)then
					local data=GuildCmd_pb.BuildingLvupEffect()
					local name = buildingData.staticData.Name
					local glevel = buildingData.staticData.Level
					local icon = buildingData.staticData.Icon
					self:_playEffect(icon,name,glevel)
					data.type=gType
					data.level=glevel
					sendTypes[#sendTypes+1]=data
				end
			end
		end
		if(#sendTypes>0)then
			ServiceGuildCmdProxy.Instance:CallBuildingLvupEffGuildCmd(sendTypes);
		end
	end
end

function GuildBuildingProxy:_playEffect(icon,name,level)
	local data = {};
	data.icontype = 0;
	data.icon = icon or 'item_150'
	data.content = string.format(ZhString.GuildBuilding_TypeLevelUp, name, level);
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "SystemUnLockView"})
	GameFacade.Instance:sendNotification(SystemUnLockEvent.CommonUnlockInfo, data);
end

function GuildBuildingProxy:GetMatData(type)
	local data = self:GetBuildingDataByType(type)
	if(data)then
		return data.uiMatData;
	end
	return nil
end

function GuildBuildingProxy:HasAuthorization()
	if(GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Guild))then
		return true
	end
	return false
end

function GuildBuildingProxy:GetTotalSubmitCount(type)
	if(self.BuildingData[type])then
		local matData = self.BuildingData[type].uiMatData
		local num =0
		for k,v in pairs(matData) do
			num=num+v.materials.count
		end
		return num
	end
end

function GuildBuildingProxy:GetBuildingDataByType(type)
	if(self.BuildingData[type])then
		return self.BuildingData[type]
	end
	return nil
end

function GuildBuildingProxy:GetBuildingLevelByType(type)
	local buildData = self:GetBuildingDataByType(type)
	if(buildData)then
		return buildData.level
	end
	return nil
end

function GuildBuildingProxy:SortRankArray (a,b)
	if(a.submitCountTotal == b.submitCountTotal)then
		return a.submitTime < b.submitTime
	else
		return a.submitCountTotal>b.submitCountTotal
	end
end

function GuildBuildingProxy:SetBuildingRank(data)
	self:ClearRankArray()
	local myGuildData = GuildProxy.Instance.myGuildData
	local items = data.items
	for i=1,#items do
		local data = GuildingRankData.new()
		local item = items[i]
		if(myGuildData)then
			local memberData = myGuildData:GetMemberByGuid(item.charid)
			if(memberData)then
				data:Server_SetData(item)
				TableUtility.ArrayPushBack(self.rankArray,data)
			end
		end
	end
	if(not self.rankArray or #self.rankArray<0)then return end 
	table.sort(self.rankArray,function (l,r)
		return self:SortRankArray(l,r)
	end)
end

function GuildBuildingProxy:ClearRankArray()
	TableUtility.ArrayClear(self.rankArray)
end

function GuildBuildingProxy:GetRankArray()
	return self.rankArray
end

function GuildBuildingProxy:GetCurBuilding()
	for k,v in pairs(self.BuildingData) do
		if(v.isbuilding)then
			return v
		end
	end
	return nil
end

function GuildBuildingProxy:GetBuildAuth()
	for k,v in pairs(self.BuildingData) do
		if(v.isbuilding)then
			return GuildBuildingProxy.BuildAuth.EBuildAuth_OnBuild
		end
		if(not v:CanBuildByTime())then
			return GuildBuildingProxy.BuildAuth.EBuildAuth_OnCD
		end
	end
	return GuildBuildingProxy.BuildAuth.EBuildAuth_Success
end

function GuildBuildingProxy:_getBuildingTypeByShopType(t)
	for k,v in pairs(Table_GuildBuilding) do
		if(v.UnlockParam and v.UnlockParam.shoptype and v.UnlockParam.shoptype==t)then
			self.shopBuildType[t]=v.Type
			return v.Type
		end
	end
	return nil
end

function GuildBuildingProxy:ShopGoodsLocked(shopType,shopId)
	local bType = self.shopBuildType[shopType]
	if(not bType)then
		bType=self:_getBuildingTypeByShopType(shopType)
	end
	if(bType)then
		local buildData = self:GetBuildingDataByType(bType)
		if(buildData and buildData.staticData and buildData.staticData.UnlockParam and buildData.staticData.UnlockParam.shopid)then
			local unlockIDs = buildData.staticData.UnlockParam.shopid
			if(unlockIDs and #unlockIDs>0)then
				for i=1,#unlockIDs do
					if(shopId==unlockIDs[i])then
						return false
					end
				end
			end
		end
	end
	return true
end

local function CfgData(type,lv)
	for k,v in pairs(Table_GuildBuilding) do
		if(v.Type==type and v.Level==lv)then
			return v
		end
 	end
 	return nil
end

local sewing = GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING
local pillow = GuildBuildingProxy.Type.EGUILDBUILDING_EGUILDBUILDING_CAT_PILLOW
function GuildBuildingProxy:GetStrengthMaxLvl()
	local sewingLvl = self:GetBuildingLevelByType(sewing)
	local pillowLvl = self:GetBuildingDataByType(pillow)
	sewingLvl = sewingLvl and CfgData(sewing,sewingLvl)
	sewingLvl =  sewingLvl and sewingLvl.UnlockParam and sewingLvl.UnlockParam.equip and sewingLvl.UnlockParam.equip.strengthmaxlv or 0
	pillowLvl = pillowLvl and pillowLvl.staticData and pillowLvl.staticData.UnlockParam and pillowLvl.staticData.UnlockParam.strengthmaxlv_add or 0
	return sewingLvl + pillowLvl
end



