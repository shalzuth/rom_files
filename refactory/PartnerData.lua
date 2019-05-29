PartnerData = reusableClass("PartnerData", CreatureDataWithPropUserdata)
PartnerData.PoolSize = 10
function PartnerData:DoConstruct(asArray, npcID)
  PartnerData.super.DoConstruct(self, asArray, npcID)
  self.staticData = Table_NPCFollow[npcID]
  if self.staticData == nil then
    LogUtility.ErrorFormat("partner \229\156\168npcfollow\232\161\168\233\135\140\230\137\190\228\184\141\229\136\176,id:{0}", npcID)
  end
end
function PartnerData:DoDeconstruct(asArray)
  PartnerData.super.DoDeconstruct(self, asArray)
end
function PartnerData:ResetID(npcID)
  self.staticData = Table_NPCFollow[npcID]
end
function PartnerData:CanGetOnCarrier()
  return self.staticData.RideVehicle and self.staticData.RideVehicle == 1
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
