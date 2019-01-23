NExpressNpc = reusableClass("NExpressNpc",NCreatureWithPropUserdata)
NExpressNpc.PoolSize = 5

local SmoothRemoveDuration = 0.3

function NExpressNpc:ctor(aiClass)
	NExpressNpc.super.ctor(self,AI_CreatureWalkFollow)
end

function NExpressNpc:GetCreatureType()
	return Creature_Type.Npc
end

-- override begin
function NExpressNpc:DoConstruct(asArray, serviceData)
	local data = ExpressNpcData.CreateAsTable(serviceData)
	NExpressNpc.super.DoConstruct(self,asArray,data)
	self:Init()
	self.sceneui = Creature_SceneUI.CreateAsTable(self)
end

function NExpressNpc:DoDeconstruct(asArray)
	NExpressNpc.super.DoDeconstruct(self,asArray)
	if(self.sceneui) then
		self.sceneui:Destroy()
		self.sceneui = nil
	end
	self.assetRole:Destroy()
	self.assetRole = nil
	self.delayRemoveTimeFlag = nil
	self.forceRemoveTimeFlag = nil
	self.smoothRemoving = false
end
-- override end

function NExpressNpc:Init()
	self:CreateWeakData()
	self:InitAssetRole()
	self:InitLogicTransform(0,0,0,nil,1)
end

function NExpressNpc:InitAssetRole()
	NExpressNpc.super.InitAssetRole(self)
	local assetRole = self.assetRole
	assetRole:SetGUID( self.data.id )
	assetRole:SetName( self.data:GetName() )
	assetRole:SetClickPriority(0)
	assetRole:SetInvisible(false)
	assetRole:SetShadowEnable( true )
	assetRole:SetColliderEnable( false )
	assetRole:SetWeaponDisplay( true )
	assetRole:SetMountDisplay( true )
	assetRole:SetRenderEnable( true )
	assetRole:SetActionSpeed(1)
end

function NExpressNpc:InitLogicTransform(serverX,serverY,serverZ,dir,scale,moveSpeed,rotateSpeed,scaleSpeed)
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

function NExpressNpc:GetDressParts()
	if(not self:IsDressEnable()) then
		return NSceneNpcProxy.Instance:GetNpcEmptyParts(),true
	end
	return self.data:GetDressParts(),true
end

local CreatureFollowTarget = "CreatureFollowTarget"
function NExpressNpc:SetMaster(master)
	self:SetWeakData(CreatureFollowTarget, master)

	self.masterId = master.data.id
	self:SetDressEnable(master:IsDressEnable())
	self.sceneui:CopyMaskFromOther(master.sceneui)

	if self.masterId == Game.Myself.data.id then
		local assetRole = self.assetRole
		assetRole:SetClickPriority(self.data:GetClickPriority())
		assetRole:SetColliderEnable( true )
	end
end

function NExpressNpc:SetPos(master, serverPos)
	if serverPos then
		self:Client_PlaceXYZTo(serverPos.x,serverPos.y,serverPos.z,1000)
	else
		local p = master:GetPosition()
		if p then
			self:Client_PlaceTo(p,true)
		end
	end
end

function NExpressNpc:GetSceneUI()
	return self.sceneui
end

local SampleInterval = 0.1
local nextSampleTime = 0

function NExpressNpc.StaticUpdate(time, deltaTime)
	if time >= nextSampleTime then
		nextSampleTime = time + SampleInterval
	end
end

function NExpressNpc:Logic_SamplePosition(time)
	if time < nextSampleTime then
		self.logicTransform:SamplePosition()
	end
end

function NExpressNpc:SetDelayRemove(delayTime)
	if nil ~= self.delayRemoveTimeFlag then
		return
	end
	self.smoothRemoving = false
	if delayTime then
		self:SetClickable(false)
		self.delayRemoveTimeFlag = Time.time + delayTime
	else
		self.delayRemoveTimeFlag = nil
	end
end

local superUpdate = NExpressNpc.super.Update
function NExpressNpc:Update(time, deltaTime)
	superUpdate(self,time,deltaTime)
	if self.delayRemoveTimeFlag~=nil then
		if time >= self.delayRemoveTimeFlag then
			if not self.smoothRemoving then
				if nil ~= self.forceRemoveTimeFlag then
					if time < self.forceRemoveTimeFlag 
						and self.ai:IsDiePending() then
						return
					end
				else
					if self.ai:IsDiePending() then
						self.forceRemoveTimeFlag = time + ForceRemoveDelay
						return
					end
				end
				self.smoothRemoving = true
				self.delayRemoveTimeFlag = self.delayRemoveTimeFlag+SmoothRemoveDuration
				self.assetRole:AlphaTo(0, SmoothRemoveDuration)
			else
				if not SceneAINpcProxy.Instance:Remove(self.data.id,true) then
					self:Destroy()
				end
			end
		end
	end
end