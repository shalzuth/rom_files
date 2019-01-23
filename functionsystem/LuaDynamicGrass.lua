autoImport('LuaRolesOnCurrentMap')

LuaDynamicGrass = class('LuaDynamicGrass')

local gReusableLuaVector2A = LuaVector2.zero
local gReusableLuaVector2B = LuaVector2.zero
local gReusableLuaVector3A = LuaVector3.zero

local CreateArray = ReusableTable.CreateArray
local DestroyArray = ReusableTable.DestroyArray

local StateNone = 0
local StateNew = 1
local StateMoving = 2

function LuaDynamicGrass:EffectiveBodysCount()
	return #self.cachedEffectiveBodys
end

local effectSpawnFrameLimit = 40
function LuaDynamicGrass:ctor()
	self.posx, self.posy, self.posz = 0, 0, 0
	self.dirtyRemoves = {}
	self.cacheRoles = {}
	self.roleCount = 0
	self.frameCount = 0
end

function LuaDynamicGrass:AttachGameObject(go)
	self.gameObject = go
	self.transform = self.gameObject.transform
	self:SetPos()
end

--由于植物不会动所以坐标只获取一次
function LuaDynamicGrass:SetPos()
	self.posx, self.posy, self.posz = LuaGameObject.GetPosition(self.transform)
end

function LuaDynamicGrass:Initialize()
	self.grassSlope = self.gameObject:GetComponent('GrassSlopeV2')
	self.AddForce = self.grassSlope.AddForce
	self.ChangeForce = self.grassSlope.ChangeForce
	self.MinusForce = self.grassSlope.MinusForce
end

local sqrt = math.sqrt
local floor = math.floor
local LuaRolesOnCurrentMapIns = LuaRolesOnCurrentMap.Ins()
function LuaDynamicGrass:Update()
	if(self.roleCount>0) then
		for k,v in pairs(self.dirtyRemoves) do
			self:RemoveEffectiveBody(k)
		end
		for k,v in pairs(self.cacheRoles) do
			local posOfRole = NSceneUserProxy.Instance:Find(k):GetPosition()
			local grassToRoleX, grassToRoleZ = posOfRole[1] - self.posx, posOfRole[3] - self.posz
			local distance = sqrt(grassToRoleX ^ 2 + grassToRoleZ ^ 2)
			if distance <= self.effectiveDistance then
				gReusableLuaVector2A:Set(-grassToRoleX, grassToRoleZ)
				local forceDirection = gReusableLuaVector2A
				local force = floor(- 100 * distance / self.effectiveDistance + 100)
				if (forceDirection[1] ~= 0 or forceDirection[2] ~= 0) and force > 0 then
					if v[2] == StateNew then
						-- need optimize
						local id = self.AddForce(self.grassSlope, forceDirection, force, 0.5)
						v[1] = id
						v[2] = StateNone
					elseif v[2] == StateMoving then
						v[2] = StateNone
						-- need optimize
						self.ChangeForce(self.grassSlope, v[1], forceDirection, force, 0.5)
					end
				end
			end
		end
	end
	if(self.playingEffect) then
		self.frameCount = self.frameCount + 1
		if(self.frameCount>effectSpawnFrameLimit) then
			self.frameCount = 0
			self.playingEffect = false
		end
	end
end

function LuaDynamicGrass:RemoveEffectiveBody(role_id)
	local effectiveBody = self:GetEffectiveBody(role_id)
	if effectiveBody ~= nil then
		self.dirtyRemoves[role_id] = nil
		self:DoRemoveEffectiveBody(role_id,effectiveBody)
	end
end

function LuaDynamicGrass:MoveOrAdd(role_id)
	self.dirtyRemoves[role_id] = nil
	local effectiveBody = self:GetEffectiveBody(role_id)
	if(effectiveBody==nil) then
		effectiveBody = self:AddEffectBody(role_id)
		effectiveBody[1] = 0
		effectiveBody[2] = StateNew
	else
		effectiveBody[2] = StateMoving
	end
end

function LuaDynamicGrass:DirtyRemove(role_id)
	self.dirtyRemoves[role_id] = 1
end

local ArrayFindIndex = TableUtility.ArrayFindIndex
local remove = table.remove
function LuaDynamicGrass:DoRemoveEffectiveBody(role_id,effective_body)
	self.MinusForce(self.grassSlope, effective_body[1])
	self:RemoveEffectBody(role_id)
end

function LuaDynamicGrass:Launch(plant_type, effective_distance)
	self.plantType = plant_type
	self.effectiveDistance = effective_distance
end

function LuaDynamicGrass:Release()
	self.grassSlope = nil
	for k,v in pairs(self.cacheRoles) do
		DestroyArray(v)
	end
	self.cacheRoles = nil
end

function LuaDynamicGrass:GetEffectiveBody(role_id)
	return self.cacheRoles[role_id]
end

function LuaDynamicGrass:AddEffectBody(role_id)
	local cache = self.cacheRoles[role_id]
	if(cache==nil) then
		cache = CreateArray()
		self.cacheRoles[role_id] = cache
		self.roleCount = self.roleCount + 1
		if(self.roleCount == 1) then
			self:_PlayEffect()
		end
	end
	return cache
end

function LuaDynamicGrass:RemoveEffectBody(role_id)
	local cache = self.cacheRoles[role_id]
	if(cache) then
		self.roleCount = self.roleCount - 1
		DestroyArray(cache)
		self.cacheRoles[role_id] = nil
	end
end

function LuaDynamicGrass:_PlayEffect()
	if(self.playingEffect) then
		return
	end
	if self.plantType == LuaFarmland.PlantType.Wheat then
		self.playingEffect = true
		local effectPath = EffectMap.Maps.InteractionPlant_Wheat
		local assetEffect = Asset_Effect.PlayOneShotOn(effectPath, self.transform)
		-- assetEffect:RegisterWeakObserver(self)
	end
end

function LuaDynamicGrass:ObserverDestroyed(effect)
	self.playingEffect = false
end