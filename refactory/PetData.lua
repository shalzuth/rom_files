PetData = reusableClass("PetData",NpcData)
PetData.PoolSize = 50

function PetData:ctor()
	PetData.super.ctor(self)
	self.ownerID = nil
end

function PetData:GetHoldScale()
	if(self.petStaticData and self.petStaticData.BeHoldScale) then
		return self.petStaticData.BeHoldScale
	end
	return 1
end

function PetData:GetHoldDir()
	if(self.petStaticData and self.petStaticData.BeHoldDir) then
		return self.petStaticData.BeHoldDir
	end
	return 0
end

function PetData:GetHoldOffset()
	if(self.petStaticData and self.petStaticData.BeHoldOffset) then
		return self.petStaticData.BeHoldOffset
	end
	return PetData.super.GetHoldOffset(self)
end

function PetData:GetCamp()
	if(self.ownerID) then
		local owner = SceneCreatureProxy.FindCreature(self.ownerID)
		if(owner) then
			return owner.data:GetCamp()
		end
	end
	return RoleDefines_Camp.NEUTRAL
end

function PetData:SetOwnerID(ownerID)
	self.ownerID = ownerID
end

function PetData:GetDynamicSkillInfo(skillID)
	return CreatureSkillProxy.Instance:GetDynamicSkillInfoByID(self.staticData.id,skillID)
end

function PetData:GetDressParts()
	local parts = PetData.super.GetDressParts(self);
	if(self.petStaticData == nil)then
		return parts;
	end
	if(self.useServerDressData) then
		--魔物变身,使用userdata
		local userData = self.userdata
		if(userData~=nil) then
			local cloned = NpcData.super.GetDressParts(self)
			local equipFake = self.petStaticData.EquipFake;
			for k,v in pairs(cloned) do
				if(v==0) then
					cloned[k] = parts[k]
				else
					if(equipFake and equipFake[v])then
						local fakeEquipData = Table_EquipFake and Table_EquipFake[equipFake[v]];
						if(fakeEquipData)then
							local etypeData = GameConfig.EquipType[fakeEquipData.EquipType];
							if(etypeData.equipBodyIndex)then
								local fakeIndex = RoleDefines_EquipBodyIndex[etypeData.equipBodyIndex];
								if(fakeIndex)then
									cloned[fakeIndex] = fakeEquipData.id;
								end
							end
						end
					end
				end
			end
			return cloned
		end
	end
	return parts
end

-- override begin
function PetData:DoConstruct(asArray, serverData)
	PetData.super.DoConstruct(self,asArray,serverData)
	self.ownerID = serverData.owner
	if(NpcMonsterUtility.IsPetByData(self.staticData)) then
		self.type = NpcData.NpcType.Pet
	end
	self.petStaticData = Table_Pet[serverData.npcID]
end

function PetData:DoDeconstruct(asArray)
	PetData.super.DoDeconstruct(self,asArray)
	self.petStaticData = nil
end
-- override end