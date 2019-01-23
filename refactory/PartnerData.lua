PartnerData = reusableClass("PartnerData",CreatureDataWithPropUserdata)
PartnerData.PoolSize = 10

-- override begin
function PartnerData:DoConstruct(asArray, npcID)
	PartnerData.super.DoConstruct(self,asArray,npcID)
	self.staticData = Table_NPCFollow[npcID]
	if(self.staticData==nil) then
		LogUtility.ErrorFormat("partner 在npcfollow表里找不到,id:{0}",npcID)
	end
end

function PartnerData:DoDeconstruct(asArray)
	PartnerData.super.DoDeconstruct(self,asArray)
end

function PartnerData:ResetID(npcID)
	self.staticData = Table_NPCFollow[npcID]
end

--是否能坐载具
function PartnerData:CanGetOnCarrier()
	return self.staticData.RideVehicle and self.staticData.RideVehicle==1
end

function PartnerData:GetFollowEP()
	return self.staticData.FollowEP
end

function PartnerData:GetFollowType()
	return self.staticData.FollowType
end

function PartnerData:GetInnerRange()
	return self.staticData.FollowDistance_Stop
end

function PartnerData:GetOutterRange()
	return self.staticData.FollowDistance_Start
end

function PartnerData:GetOutterHeight()
	return self.staticData.FollowHighly
end

function PartnerData:GetDampDuration()
	return self.staticData.FollowEasingTime
end
-- override end