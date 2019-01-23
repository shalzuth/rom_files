autoImport("AdventureItemData")
AdventureCollectionGroupData = class("AdventureCollectionGroupData",AdventureItemData)

function AdventureCollectionGroupData:ctor(staticId)
	self.staticId = staticId
	self:initData()
end

function AdventureCollectionGroupData:initData(  )
	self.collections = {}
	self.isUnlock = false
	self:initStaticData()
end

function AdventureCollectionGroupData:setIsSelected( isSelected )
	-- body
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
	end
end

function AdventureCollectionGroupData:initStaticData()
	self.staticData = Table_Collection[self.staticId]
end

function AdventureCollectionGroupData:addCollectionData(adventureData)
	if(adventureData.IsValid and adventureData:IsValid())then
		self.collections[#self.collections+1] = adventureData
	end
end

local temp = {}
function AdventureCollectionGroupData:getCollectionData()
	TableUtility.ArrayClear(temp)
	for i=1,#self.collections do
		local single = self.collections[i]
		if(single.IsValid and single:IsValid())then
			temp[#temp+1] = single
		end
	end	
	return temp
end

function AdventureCollectionGroupData:hasToBeUnlockItem(  )
	if(self.staticData.RedTip and not self:isTotalComplete() and not self:isTotalUnComplete())then
		if(self.collections and #self.collections>0)then
			for j=1,#self.collections do
				local singleColl = self.collections[j]
				if(singleColl.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
					return true
				end
			end
		end
	end
end

function AdventureCollectionGroupData:getCurrentUnlockNum(  )
	local count = 0
	for i=1,#self.collections do
		local single = self.collections[i]
		if(single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK)then
			count = count + 1
		end
	end
	return count
end

function AdventureCollectionGroupData:isTotalUnComplete(  )
	for i=1,#self.collections do
		local single = self.collections[i]
		if(single.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY)then
			return false
		end
	end
	return true
end

function AdventureCollectionGroupData:IsUnlock(  )
	return self.isUnlock
end

function AdventureCollectionGroupData:setUnlock( unlock )
	self.isUnlock = unlock
end

function AdventureCollectionGroupData:isTotalComplete(  )
	-- body
	for i=1,#self.collections do
		local single = self.collections[i]
		if(single.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK)then
			return false
		end
	end
	return true
end

