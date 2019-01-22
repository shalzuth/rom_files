NPet = reusableClass("NPet",NNpc)
NPet.PoolSize = 10

function NPet:ctor(aiClass)
	NPet.super.ctor(self,AI_CreatureLookAt)
end

function NPet:GetCreatureType()
	return Creature_Type.Pet
end

function NPet:IsMyPet()
	return self.data.ownerID == Game.Myself.data.id
end

function NPet:InitAssetRole()
	NPet.super.InitAssetRole(self)
	local assetRole = self.assetRole
	assetRole:SetGUID( self.data.id )
	assetRole:SetName( self.data:GetOriginName() )
	assetRole:SetClickPriority(self.data:GetClickPriority())
	assetRole:SetShadowEnable( self.data.staticData.move ~= 1 )
	assetRole:SetInvisible(false)
	if(self.data:IsCatchNpc_Detail()) then
		--???????????????????????????????????????
		assetRole:SetColliderEnable( true )
	else
		assetRole:SetColliderEnable( self.data:IsPet() and self:IsMyPet() )
	end
	assetRole:SetWeaponDisplay( true )
	assetRole:SetMountDisplay( true )
	assetRole:SetRenderEnable( true )
	assetRole:SetActionSpeed(1)
	-- assetRole:SetActionConfig(Game.Config_NPCAction)
	-- assetRole:PlayAction(name, defaultName, speed, normalizedTime, force)
end

function NPet:Server_SetHandInHand(masterID, running)
	local func = self.ai.HandInHand
	if(self.data:GetFeature_BeHold()) then
		func = self.ai.BeHolded
	end
	if running then
		func(self.ai , masterID, self)
	else
		func(self.ai , 0, self)
	end
end

function NPet:Logic_LookAt(creatureGUID)
	if(creatureGUID==nil) then
		creatureGUID = 0
	end
	self.ai:LookAt(creatureGUID)
end

function NPet:SetDressEnable(v)
	if(self.data) then
		if(v~= self.data.dressEnable) then
			self.data:SetDressEnable(v)
			self:ReDress()
		end
	end
end

function NPet:SetOwner(owner)
	if(owner) then
		self.data:SetOwnerID(owner.data.id)
		self:SetDressEnable(owner:IsDressEnable())
		-- LogUtility.Info(owner:IsDressEnable())
		if(self.data:IsCatchNpc_Detail()) then
			--???????????????????????????????????????
			self.assetRole:SetColliderEnable( true )
		else
			self.assetRole:SetColliderEnable( self.data:IsPet() and self:IsMyPet() )
		end
	else
		self.data:SetOwnerID(nil)
		self:SetDressEnable(true)
	end
	self.foundOwner = true
	self:CatchNpcTryLookAt()
end

function NPet:ParseServerData(serverData)
	return PetData.CreateAsTable(serverData)
end

function NPet:CatchNpcTryLookAt()
	if(self.data:IsCatchNpc_Detail()) then
		self:Logic_LookAt(self.data.ownerID)
	end
end

function NPet:_DelayDestroy()
	if(not NScenePetProxy.Instance:RealRemove(self.data.id,true)) then
		self:Destroy()
	end
end


-- ??????Body?????? Begin
function NPet:ReDress()
	--??????????????????
	if(self._changeJobTimeFlag) then
		return
	end
	NPet.super.ReDress(self)
end
function NPet:PlayChangeJob()
	FunctionSystem.InterruptCreature(self)
	self:_PlayChangeJobBeginEffect()
end
function NPet:_PlayChangeJobBeginEffect()
	self._changeJobTimeFlag = Time.time + 3
	-- effect 1
	self.assetRole:ChangeColorFromTo(
			LuaGeometry.Const_Col_whiteClear,
			LuaGeometry.Const_Col_white, 
			3)
	self:PlayEffect(nil,EffectMap.Maps.JobChange,0,nil,false,true)
end
function NPet:Update(time, deltaTime)
	NPet.super.Update(self,time,deltaTime)
	self:_UpdateEffect(time, deltaTime)
end
function NPet:_UpdateEffect(time, deltaTime)
	if(self._changeJobTimeFlag) then
		if(self._changeJobTimeFlag<=time) then
			self._changeJobTimeFlag = nil
			self:_PlayChangeJobFireEffect()
		end
	end
end
function NPet:_PlayChangeJobFireEffect()
	-- helplog("_PlayChangeJobFireEffect ReDress");
	self:ReDress()
	FunctionSystem.InterruptCreature(self)
	-- effect 2
	self.assetRole:ChangeColorFromTo(
			LuaGeometry.Const_Col_white, 
			LuaGeometry.Const_Col_whiteClear,
			0.3)
end
-- ??????Body?????? End



-- override begin
function NPet:DoConstruct(asArray, serverData)
	self.foundOwner = false
	NPet.super.DoConstruct(self,asArray,serverData)
	self:CatchNpcTryLookAt()
end

function NPet:DoDeconstruct(asArray)
	NPet.super.DoDeconstruct(self,asArray)
end
-- override end