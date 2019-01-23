NPartner = reusableClass("NPartner",NCreature)
NPartner.PoolSize = 5

local MyMaster = "MyMaster"
function NPartner:ctor(aiClass)
	NPartner.super.ctor(self,AI_CreatureFlyFollow)
	self.skill = ServerSkill.new()
end

function NPartner:GetCreatureType()
	return Creature_Type.Pet
end

function NPartner:InitAssetRole()
	NPartner.super.InitAssetRole(self)
	local assetRole = self.assetRole
	assetRole:SetGUID( 0 )
	assetRole:SetName("Partner")
	assetRole:SetClickPriority(0)
	assetRole:SetInvisible(false)
	assetRole:SetShadowEnable( false )
	assetRole:SetColliderEnable( false )
	assetRole:SetWeaponDisplay( true )
	assetRole:SetMountDisplay( true )
	assetRole:SetRenderEnable( true )
	assetRole:SetActionSpeed(1)
	-- assetRole:SetActionConfig(Game.Config_NPCAction)
	-- assetRole:PlayAction(name, defaultName, speed, normalizedTime, force)
end

function NPartner:InitLogicTransform(serverX,serverY,serverZ,dir,scale,moveSpeed,rotateSpeed,scaleSpeed)
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

function NPartner:Init(npcID)
	self:InitAssetRole()
	self:InitLogicTransform(0,0,0,nil,nil)
	self:UpdateScale();
end

function NPartner:SetDressEnable(v)
	if(v~= self.dressEnable) then
		self.dressEnable = v
		self:ReDress()
	end
end

function NPartner:IsDressEnable()
	return self.dressEnable
end

function NPartner:GetDressParts()
	if(self.npcConfig and self.dressEnable) then
		return NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.npcConfig),true
	end
	return NSceneNpcProxy.Instance:GetNpcEmptyParts(),true
end

function NPartner:ResetID(npcID)
	if(self.npcID ~= npcID) then
		self.npcID = npcID
		self.npcConfig = Table_Monster[npcID] or Table_Npc[npcID]
		self:ReDress(self:GetDressParts())

		self.data:ResetID(npcID)
		self:UpdateScale();
	end
end

function NPartner:UpdateScale()
	local npcID = self.npcID;

	local scale = 1;

	local npcData = Table_Npc[npcID];
	if(npcData)then
		scale = npcData.Scale or 1;
	end
	self:Server_SetScaleCmd(scale,true)
end

local CreatureFollowTarget = "CreatureFollowTarget"
function NPartner:SetMaster(master)
	self:SetWeakData(CreatureFollowTarget, master)
	local p = master:GetPosition()
	if(p) then
		-- LogUtility.Info(p)
		self:Client_PlaceTo(master:GetPosition(),true)
	end
	self:SetDressEnable(master:IsDressEnable())
end

-- override begin
function NPartner:DoConstruct(asArray, npcID)
	local data = PartnerData.CreateAsTable(npcID)
	NPartner.super.DoConstruct(self,asArray,data)
	self.dressEnable = false
	self.npcConfig = Table_Monster[npcID] or Table_Npc[npcID]
	self:CreateWeakData()
	self.npcID = npcID
	self:Init(npcID)
end

function NPartner:DoDeconstruct(asArray)
	NPartner.super.DoDeconstruct(self,asArray)
	self.assetRole:Destroy()
	self.assetRole = nil
end
-- override end

-- logic 
function NPartner:Logic_PlayAction_Move()
	local name = self:GetMoveAction()
	local moveActionScale = 1
	local staticData = self.npcConfig
	if nil ~= staticData and nil ~= staticData.MoveSpdRate then
		moveActionScale = staticData.MoveSpdRate
	end

	-- local fastForwardSpeed = self.logicTransform:GetFastForwardSpeed()
	local actionSpeed = moveActionScale * 1-- * fastForwardSpeed
	self.assetRole:PlayAction_Simple(name, nil, actionSpeed)
	return true
end