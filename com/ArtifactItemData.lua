ArtifactItemData = class("ArtifactItemData")

function ArtifactItemData:ctor(data)
	self:SetItemData(data)
end

function ArtifactItemData:SetItemData(data)
	self.guid = data.guid
	self.itemID = data.itemid
	self.staticData = Table_Artifact[self.itemID]
	self.itemStaticData = Table_Item[self.itemID]
	self.type=self.staticData.Type
	-- helplog("itemID: ",self.itemID,"type: ",self.type)
	self.distributeCount = data.distributecount
	self.retrieveTime = data.retrievetime
	self.ownerID = data.ownerid
	-- helplog("ownerID: ",self.ownerID,"mySelfID: ",Game.Myself.data.id)
	self:SetPhase() 
end

function ArtifactItemData:SetPhase()
	local unUsing = self.ownerID==0
	local retrieving = self.retrieveTime==0
	if (unUsing)then
		self.Phase=ArtifactProxy.OptionType.Distribute
	elseif(retrieving)then
		self.Phase=ArtifactProxy.OptionType.Retrieve
	else
		self.Phase=ArtifactProxy.OptionType.RetrieveCancle
	end
end

function ArtifactItemData:CanDistribute()
	local csvCount = self.staticData and self.staticData.DistributeCount
	if(csvCount)then
		return self.distributeCount<csvCount
	end
	return false
end

function ArtifactItemData:CanEquip(pro)
	local equipCsv = Table_Equip[self.itemID]
	if(equipCsv)then
		local array = equipCsv.CanEquip
		if(array)then
			for i=1,#array do
				if(0==array[i] or array[i]==pro)then -- 0 全职业
					return true
				end
			end
		end
	end
	return false
end


ArtifactTypeData = class("ArtifactTypeData")

function ArtifactTypeData:ctor(data)
	self:SetData(data)
end

function ArtifactTypeData:SetData(data)
	self.type=data.type
	self.produceCount=data.producecount
	-- helplog("ArtifactTypeData: type : ",self.type,"produceCount: ",self.produceCount)
	self.maxLv=data.maxlevel
end

