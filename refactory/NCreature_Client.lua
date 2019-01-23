
local tempVector3 = LuaVector3.zero

local TempOffsetMap = {
	[RoleDefines_EP.Top] = LuaVector3.New(0, 1.8, 0),
}

local SpEffectGuid = 1

function NCreature:Client_RegisterFollow(transform, offset, epID, lostCallback, lostCallbackArg, tempOffset)
	if nil == offset then
		tempVector3:Set(0,0,0)
		offset = tempVector3
	end
	if nil == epID then
		epID = 0
	end
	if nil == tempOffset then
		if 0 < epID then
			tempOffset = TempOffsetMap[epID]
		end
		if nil == tempOffset then
			tempOffset = LuaGeometry.Const_V3_zero
		end
	end
	Game.RoleFollowManager:RegisterFollow(
		transform, 
		self.assetRole.complete,
		offset, 
		tempOffset,
		epID, 
		lostCallback, 
		lostCallbackArg)
end

function NCreature:Client_UnregisterFollow(transform)
	Game.RoleFollowManager:UnregisterFollow(transform)
end

function NCreature:Client_RegisterFollowCP(transform, cpID, lostCallback, lostCallbackArg)
	if nil == cpID then
		cpID = 0
	end
	Game.RoleFollowManager:RegisterFollowCP(
		transform, 
		self.assetRole.complete,
		cpID, 
		lostCallback, 
		lostCallbackArg)
end

function NCreature:Client_UnregisterFollowCP(transform)
	Game.RoleFollowManager:UnregisterFollow(transform)
end

function NCreature:Client_PlayAction(name,normalizedTime,loop,fakeDead,forceDuration)
	-- LogUtility.Info("Client_PlayAction "..self.data:GetName().." "..name)
	self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name,normalizedTime,loop,fakeDead,forceDuration), self)
end

function NCreature:Client_SetDirCmd(mode,dir,noSmooth)
	self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode,dir,noSmooth), self)
end

function NCreature:Client_PlaceXYZTo(x,y,z,div,ignoreNavMesh)
	tempVector3:Set(x,y,z)
	-- local pos = LuaVector3(x,y,z)
	if(div~=nil) then
		tempVector3:Div(div)
	end
	self:Server_SetPosCmd(tempVector3,ignoreNavMesh)
	-- pos:Destroy()
end

function NCreature:Client_PlaceTo(p,ignoreNavMesh)
	self.ai:PushCommand(FactoryAICMD.GetPlaceToCmd(p,ignoreNavMesh), self)
end

function NCreature:Client_SetMoveSpeed(moveSpeed)
	self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
end

function NCreature:Client_AddSpEffect(targetGUID, effectID, duration)
	local data = Table_SpEffect[effectID]
	if data == nil then
		return
	end
	local effectType = data.Type
	local EffectClass = SpEffectWorkerClass[effectType]
	if EffectClass == nil then
		return
	end

	if self.spEffects == nil then
		self.spEffects = {}
	end

	local sb = LuaStringBuilder.CreateAsTable()
	sb:Append("Client_")
	sb:Append(SpEffectGuid)
	local key = sb:ToString()

	local effect = self.spEffects[key]
	if effect ~= nil then
		effect:Destroy()
		self.spEffects[key] = nil
	end

	effect = EffectClass.Create(effectID)
	local args = ReusableTable.CreateArray()
	args[1] = targetGUID
	args[2] = duration
	effect:SetArgs(args)
	self.spEffects[key] = effect

	sb:Destroy()
	ReusableTable.DestroyArray(args)

	SpEffectGuid = SpEffectGuid + 1
end

function NCreature:Client_RemoveSpEffect(key)
	if self.spEffects == nil then
		return
	end
	local effect = self.spEffects[key]
	if nil ~= effect then
		effect:Destroy()
		self.spEffects[key] = nil
	end
end