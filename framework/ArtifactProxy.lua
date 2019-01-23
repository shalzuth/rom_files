autoImport("ArtifactMakeData")
autoImport("ArtifactItemData")

ArtifactProxy = class('ArtifactProxy', pm.Proxy)
ArtifactProxy.Instance = nil;
ArtifactProxy.NAME = "ArtifactProxy"

ArtifactProxy.OptionType=
{
	Distribute = GuildCmd_pb.EARTIFACTOPTTYPE_DISTRIBUTE,
	Retrieve = GuildCmd_pb.EARTIFACTOPTTYPE_RETRIEVE, -- 取回
	RetrieveCancle = GuildCmd_pb.EARTIFACTOPTTYPE_RETRIEVE_CANCEL, -- 取消取回
	Return = GuildCmd_pb.EARTIFACTOPTTYPE_GIVEBACK,
}

ArtifactProxy.NpcIDByType=
{
	2621,2622,2623,2624,2625,2626,2627,2628,2629,2630,2631,2632
}

ArtifactProxy.Type = 
{
	WeaponArtifact = 1,		-- 主武器神器	
	HeadBackArtifact = 2,	-- 头饰背饰神器
}

local defaultProduceCount = 1

local typeCfg = GameConfig.ArtifactType

function ArtifactProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ArtifactProxy.NAME
	if(ArtifactProxy.Instance == nil) then
		ArtifactProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function ArtifactProxy:Init()
	self.memberArtData={}
	self.artifactData={}
	self.produceMap={}
	self.makeList = {}
	self.makeTable = {}
	self:InitReturnData()
end

function ArtifactProxy:InitParam(param)
	self.artifactType = param
end

function ArtifactProxy:GetArtifactType()
	return self.artifactType
end

function ArtifactProxy:SetArtifactData(data)
	for i=1,#data.itemupdates do
		local cellData = ArtifactItemData.new(data.itemupdates[i]);
		-- helplog("data.itemupdates[i].guid: ",data.itemupdates[i].guid)
		self.artifactData[data.itemupdates[i].guid]=cellData
	end
	for i=1,#data.itemdels do
		local itemdel = data.itemdels[i]
		for guid,data in pairs(self.artifactData) do
			if(guid==itemdel)then
				self.artifactData[guid]=nil
			end
		end
	end
	for i=1,#data.dataupdates do
		local data = ArtifactTypeData.new(data.dataupdates[i])
		local t = data.type
		self.produceMap[t]=data
	end
	TableUtility.ArrayClear(self.makeList)
	TableUtility.TableClear(self.makeTable);
	for k,v in pairs(self.produceMap) do
		local unlockIDs= self:_getUnlockID(v.type,v.maxLv)
		if(unlockIDs)then
			for j=1,#unlockIDs do
				self.makeList[#self.makeList+1]=unlockIDs[j]
			end
		end
	end
	self:_setMakeTable()
	self:ResetGuildMemberArtifact()
end

local unlockID = {}
function ArtifactProxy:_getUnlockID(type,curMaxLv)
	TableUtility.ArrayClear(unlockID);
	for k,v in pairs(Table_Artifact) do
		if(v.Type==type and v.Level<=curMaxLv+1)then
			unlockID[#unlockID+1]=v.id
		end
	end
	return unlockID
end

function ArtifactProxy:HandleQuestUnlock(quests)
	local result = {}
	for i=1,#quests do
		for k,v in pairs(Table_Artifact) do
			if(v.QuestID==quests[i])then
				if(not self.produceMap[v.Type] and not self.makeTable[v.id])then
					self.makeList[#self.makeList+1]=v.id
				end
			end
		end
	end
	self:_setMakeTable()
end

function ArtifactProxy:_setMakeTable()
	for i=1,#self.makeList do
		local id = self.makeList[i]
		if self.makeTable[id] == nil then
			self.makeTable[id] = ArtifactMakeData.new(id)
		end
	end
end

function ArtifactProxy:_getUnlockParam()
	local buildType = self.artifactType==1 and GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE or GuildBuildingProxy.Type.EGUILDBUILDING_ARTIFACT_HEAD
	local buildingData = GuildBuildingProxy.Instance:GetBuildingDataByType(buildType)
	if(buildingData and buildingData.staticData and buildingData.staticData.UnlockParam)then
		local param = buildingData.staticData.UnlockParam
		local ownlimit = param.ownlimit or 10
		local singlelimit = param.singlelimit or 10
		return ownlimit,singlelimit
	end
	return 0,0
end

function ArtifactProxy:IsOverLimitCount(data)
	local totalLimit,singleLimit = self:_getUnlockParam()
	local isLvUp = data.Level>1
	local singleTypeCount = self:_getOwnCountByType(data.Type)
	local totalCount = self:_getTotalArtifactCount()
	local single = isLvUp and singleTypeCount-1 or singleTypeCount
	local total = isLvUp and totalCount-1 or totalCount
	if(single>=singleLimit)then
		return 1
	elseif(total>=totalLimit)then
		return 2
	end
	return 0
end

function ArtifactProxy:_getOwnCountByType(t)
	local singleTypeCount=0
	for guid,v in pairs(self.artifactData) do
		if(v.type==t)then
			singleTypeCount=singleTypeCount+1
		end
	end
	return singleTypeCount
end

function ArtifactProxy:_getTotalArtifactCount()
	local num= 0
	local buildType = self.artifactType==1 and GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE or GuildBuildingProxy.Type.EGUILDBUILDING_ARTIFACT_HEAD
	for k,v in pairs(self.artifactData) do
		if(v.staticData and v.staticData.BuildingType==buildType)then
			num=num+1
		end
	end
	return num
end

local typeFilter = {}
function ArtifactProxy:GetAreaFilter(filterData)
	TableUtility.ArrayClear(typeFilter)
	for k,v in pairs(filterData) do
		table.insert(typeFilter,k)
	end
	table.sort( typeFilter, function (l,r)
		return l < r
	end )
	return typeFilter
end

local data = {}
function ArtifactProxy:GetMakeList()
	TableUtility.ArrayClear(data)
	for i=1,#self.makeList do
		local id = self.makeList[i]
		local itemtype = Table_Item[id] and Table_Item[id].Type
		if(itemtype)then
			local typeConfig = typeCfg[self.artifactType]
			if(typeConfig[itemtype])then
				data[#data+1]=id
			end
		end
	end

	table.sort(data,function (l,r)
		return self:SortMakeList(l,r)
	end)
	return data
end

function ArtifactProxy:SortMakeList(left,right)
	if left == nil or right == nil then 
	   return false 
	end
	local lStaticData = Table_Artifact[left]
	local rStaticData = Table_Artifact[right]
	if(lStaticData.Type==rStaticData.Type)then
		return lStaticData.Level<rStaticData.Level
	else
		return lStaticData.Type<rStaticData.Type
	end
end

-- id ->staticID
function ArtifactProxy:GetMakeData(id)
	return self.makeTable[id]
end

function ArtifactProxy:GetMySelfArtifact()
	local myId = Game.Myself.data.id
	local data = {}
	for k,v in pairs(self.artifactData) do
		if(v.ownerID==myId)then
			data[#data+1]=v
		end
	end
	return data
end

function ArtifactProxy:InitReturnData()
	if(self.readyReturnData)then
		TableUtility.TableClear(self.readyReturnData)
	else
		self.readyReturnData={}
	end
end

function ArtifactProxy:SetReturnArtifact(data)
	local guid = data.guid
	if(self.readyReturnData[guid])then
		self.readyReturnData[guid]=nil
	else
		self.readyReturnData[guid]=data
	end
end

function ArtifactProxy:GetReturnArtifact()
	return self.readyReturnData
end

function ArtifactProxy:GetUnUseArtifacts()
	local result = {}
	for k,v in pairs(self.artifactData) do
		if(v.Phase==ArtifactProxy.OptionType.Distribute)then
			result[#result+1]=v
		end
	end
	return result
end

function ArtifactProxy:SetDistributeActiveFlag(v)
	self.distributeBtnSwitch=v
end

function ArtifactProxy:GetDistributeActiveFlag()
	return self.distributeBtnSwitch
end

function ArtifactProxy:ResetGuildMemberArtifact()
	self.memberArtData={}
	for _,v in pairs(self.artifactData) do 
		if(not self.memberArtData[v.ownerID])then
			self.memberArtData[v.ownerID]={}
		end
		table.insert(self.memberArtData[v.ownerID],v)
	end
end

function ArtifactProxy:GetMemberArti(memberId)
	return self.memberArtData[memberId]
end

function ArtifactProxy:GetOptionalArtifacts(memberId)
	local result = {}
	local memberArtData = self:GetMemberArti(memberId)
	if(memberArtData)then
		for i=1,#memberArtData do
			result[#result+1]=memberArtData[i]
		end
	end
	local unUseArt = self:GetUnUseArtifacts()
	if(unUseArt)then
		for i=1,#unUseArt do
			result[#result+1]=unUseArt[i]
		end
	end
	return result
end

function ArtifactProxy:ShowFloatAward(itemid)
	local itemData = ItemData.new("Temp", itemid)
	FloatAwardView.addItemDatasToShow({itemData} ,function ()
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.GuildInfoView})	
	end,ZhString.ArtifactMake_DisText)
end


function ArtifactProxy:GetProduceCount(t)
	if(self.produceMap and self.produceMap[t])then
		return self.produceMap[t].produceCount
	end
	return defaultProduceCount
end

function ArtifactProxy:ClearData()
	self.artifactData={}
	self.produceMap={}
	self.makeList = {}
	self.makeTable = {}
	self.memberArtData={}
end






