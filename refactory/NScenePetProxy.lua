NScenePetProxy = class('NScenePetProxy', NSceneNpcProxy)

NScenePetProxy.Instance = nil;

NScenePetProxy.NAME = "NScenePetProxy"

-- autoImport("Table_RoleData")

function NScenePetProxy:ctor(proxyName, data)
	self:Reset()
	self:CountClear()
	self.proxyName = proxyName or NScenePetProxy.NAME
	NScenePetProxy.Instance = self
	if data ~= nil then
		self:setData(data)
	end
	if(Game and Game.LogicManager_Creature) then
		Game.LogicManager_Creature:SetScenePetProxy(self)
	end
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.SceneAddCreaturesHandler,self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs,self.SceneAddCreaturesHandler,self)
end

function NScenePetProxy:SceneAddCreaturesHandler(creaturesID)
	for i=1,#creaturesID do
		self:PetTryFindOwner(creaturesID[i])
	end
end

function NScenePetProxy:Reset()
	if(self.userMap==nil) then
		self.userMap = {}
	else
		TableUtility.TableClear(self.userMap)
	end
	if(self.waitForOwner==nil) then
		self.waitForOwner = {}
	else
		TableUtility.TableClear(self.waitForOwner)
	end
end

function NScenePetProxy:Add(data,classRef)
	local pet = NScenePetProxy.super.Add(self,data,NPet)
	local master = NSceneUserProxy.Instance:Find(data.owner)
	-- LogUtility.InfoFormat("NScenePetProxy:Add {0} {1}", pet.data.id, pet.data:GetName())
	if(master) then
		self:SetPetOwner(pet,master)
	else
		master = NSceneNpcProxy.Instance:Find(data.owner)
		if(master) then
			self:SetPetOwner(pet,master)
		else
			self:WaitForOwner(pet)
		end
	end
	return pet;
end

function NScenePetProxy:SetOwnerDressEnable(owner,v)
	if(owner.data and owner.data.petIDs) then
		local petIDs = owner.data.petIDs
		for i=1,#petIDs do
			local pet = self:Find(petIDs[i])
			if(pet) then
				pet:SetDressEnable(v)
			end
		end
	end
end

function NScenePetProxy:SetPetOwner(pet,owner)
	local petData = pet.data
	if(owner == nil or petData.ownerID~=owner.data.id or not pet.foundOwner) then
		local ownerData = owner.data
		if(petData.ownerID) then
			local oldOwner = SceneCreatureProxy.FindCreature(petData.ownerID)
			if(oldOwner) then
				owner.data:RemovePetID(petData.id)
			end
		end
		if(owner) then
			owner.data:AddPetID(petData.id)
			pet:SetOwner(owner)
		else
			pet:SetOwner(nil)
		end
	end
end

function NScenePetProxy:WaitForOwner(pet)
	self.waitForOwner[pet.data.ownerID] = pet.data.id
end

function NScenePetProxy:PetTryFindOwner(ownerID)
	local petID = self.waitForOwner[ownerID]
	if(petID) then
		local pet = self:Find(petID)
		if(pet) then
			local owner = SceneCreatureProxy.FindCreature(ownerID)
			if(owner) then
				self:SetPetOwner(pet,owner)
				self:RemoveWaitForOwner(owner.id)
			end
		end
	end
end

function NScenePetProxy:RemoveWaitForOwner(ownerID)
	self.waitForOwner[ownerID] = nil
end

function NScenePetProxy:Remove(guid,delay,fadeout)
	local pet = self:Find(guid)
	if (pet) then
		-- LogUtility.Info("pet remove "..pet.data.ownerID.." "..guid)
		self:RemoveWaitForOwner(pet.data.ownerID)
		if(delay~=nil and delay>0 or (fadeout ~= nil and fadeout >0 )) then
			self:DelayRemove(pet,delay,fadeout)
		else
			self:RealRemove(guid)
		end
		return true
	end
	return false
end

function NScenePetProxy:DelayRemove(pet,delay,duration)
	if(pet) then
		delay = delay or 0
		pet:SetDelayRemove(delay/1000,duration and duration/1000)
	end
end

function NScenePetProxy:RealRemove(guid, fade)
	return SceneCreatureProxy.Remove(self,guid)
end

local tmpPets = {}
function NScenePetProxy:PureAddSome(datas)
	local data
	for i = 1, #datas do
		data = datas[i]
		if data ~= nil then
			local addnpc = self:Add(data);
			tmpPets[#tmpPets+1] = self:Add(data)
		end
	end
	if(tmpPets and #tmpPets>0) then
		GameFacade.Instance:sendNotification(SceneUserEvent.SceneAddPets,tmpPets)
		EventManager.Me():PassEvent(SceneUserEvent.SceneAddPets, tmpPets)
		TableUtility.ArrayClear(tmpPets)
	end
end

function NScenePetProxy:RemoveSome(guids,delay,fadeout)
	local pets = SceneObjectProxy.RemoveSome(self,guids,delay,fadeout)
	if(pets and #pets>0) then
		GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemovePets,pets)
		EventManager.Me():PassEvent(SceneUserEvent.SceneRemovePets, pets)
	end
end

function NScenePetProxy:Clear()
	local pets = SceneCreatureProxy.Clear(self)
	if(pets and #pets>0) then
		GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemovePets,pets)
		EventManager.Me():PassEvent(SceneUserEvent.SceneRemovePets, pets)
	end
	self:Reset()
end
