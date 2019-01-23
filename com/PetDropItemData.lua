autoImport("ItemData")
PetDropItemData = class("PetDropItemData",ItemData)

function PetDropItemData:ctor(id,staticId)
	PetDropItemData.super.ctor(self,id,staticId)
end

function PetDropItemData:SetRare(rare)
	self.Rare = rare
end

function PetDropItemData:SetlockState(locked)
	self.Locked=locked
end

function PetDropItemData:SetCount(serviceCount,count)
	if(serviceCount)then
		self.num=serviceCount
	end
	self.rewardCount=count
end