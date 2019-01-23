NHandNpc = reusableClass("NHandNpc",NCreatureWithPropUserdata)
NHandNpc.PoolSize = 5

function NHandNpc:ctor(aiClass)
	NHandNpc.super.ctor(self)
end

function NHandNpc:GetCreatureType()
	return Creature_Type.Pet
end

-- override begin
function NHandNpc:DoConstruct(asArray, serviceData)
	local data = HandNpcData.CreateAsTable(serviceData)
	NHandNpc.super.DoConstruct(self,asArray,data)
	self:Init()
	self.sceneui = Creature_SceneUI.CreateAsTable(self)
end

function NHandNpc:DoDeconstruct(asArray)
	NHandNpc.super.DoDeconstruct(self,asArray)
	self:Server_SetHandInHand(self.masterId,false)
	if(self.sceneui) then
		self.sceneui:Destroy()
		self.sceneui = nil
	end
	self.assetRole:Destroy()
	self.assetRole = nil
end
-- override end

function NHandNpc:Init()
	self:InitAssetRole()
	self:InitLogicTransform(0,0,0,nil,1)
end

function NHandNpc:InitAssetRole()
	NHandNpc.super.InitAssetRole(self)
	local assetRole = self.assetRole
	assetRole:SetGUID( self.data.id )
	assetRole:SetName( self.data.name )
	assetRole:SetClickPriority(0)
	assetRole:SetInvisible(false)
	assetRole:SetShadowEnable( true )
	assetRole:SetColliderEnable( false )
	assetRole:SetWeaponDisplay( true )
	assetRole:SetMountDisplay( true )
	assetRole:SetRenderEnable( true )
	assetRole:SetActionSpeed(1)
end

function NHandNpc:InitLogicTransform(serverX,serverY,serverZ,dir,scale,moveSpeed,rotateSpeed,scaleSpeed)
	self.logicTransform:SetMoveSpeed(CreatureData:ReturnMoveSpeedWithFactor(moveSpeed))
	self.logicTransform:SetRotateSpeed(CreatureData:ReturnRotateSpeedWithFactor(rotateSpeed))
	self.logicTransform:SetScaleSpeed(CreatureData:ReturnScaleSpeedWithFactor(scaleSpeed))
	if(scale) then
		self:Server_SetScaleCmd(scale,true)
	end
	if(dir) then
		self:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY,dir)
	end
	self:Client_PlaceXYZTo(serverX,serverY,serverZ,1000)
end

function NHandNpc:ResetData(serviceData)
	local oldID = self.data.id
	self.data:SetData(serviceData)
	local newID = self.data.id
	if oldID ~= newID then
		SceneAINpcProxy.Instance:PureRemove(oldID)
		SceneAINpcProxy.Instance:PureAdd(newID, self)
	end
	self:ReDress()
end

local tempSpEffectData = {
	id = 1,
	guid = 1,
	entity = {}
}
function NHandNpc:SetMaster(master)
	self.masterId = master.data.id
	self:SetDressEnable(master:IsDressEnable())
	self.sceneui:CopyMaskFromOther(master.sceneui)
	self:Server_SetHandInHand(self.masterId,true)

	if self.data.speffect and 0 ~= self.data.speffect then
		tempSpEffectData.id = self.data.speffect
		tempSpEffectData.entity[1] = self.masterId
		self:Server_AddSpEffect(tempSpEffectData)
	end
end

function NHandNpc:SetPos(master, serverPos)
	if serverPos then
		self:Client_PlaceXYZTo(serverPos.x,serverPos.y,serverPos.z,1000)
	else
		local p = master:GetPosition()
		if p then
			self:Client_PlaceTo(p,true)
		end
	end
end

function NHandNpc:IsMyPet()
	return true
end

function NHandNpc:GetSceneUI()
	return self.sceneui
end

function NHandNpc:SetVisible(v,reason)
	NHandNpc.super.SetVisible(self, v, reason);

	-- active hand-line
	local spEffects = self.spEffects;
	if(spEffects == nil)then
		return;
	end

	local hasReason = false;
	if(self.visibleHandler)then
		hasReason = self.visibleHandler:HasReason()
	end
	for _,effectWorker in pairs(spEffects)do
		if(effectWorker.effect and effectWorker.EffectType == 1)then
			effectWorker.effect:SetActive(not hasReason);
		end
	end
	-- active hand-line
end