autoImport ("Asset_Effect")
Buff = class("Buff", ReusableObject)
local CreatureHideOpt = Asset_Effect.DeActiveOpt.CreatureHide
if not Buff.Buff_Inited then
	Buff.Buff_Inited = true
	Buff.PoolSize = 200
end

local AroundRotateSpeed = 100
local AroundRadius = 1
local AroundMaxCount = 5

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero
local tempQuaternion = LuaQuaternion.identity

local function GetEffectPath(paths)
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		return paths and paths[2] or nil
	end
	return paths and paths[1] or nil
end

local function OnEffectCreated(effectHandle, self)
	self:_OnEffectCreated(effectHandle)
end

function Buff.Create( buffStateID )
	return ReusableObject.Create( Buff, false, buffStateID )
end

-- first add command
function Buff:Start(creature)
	if not self:_PlayStartEffect(creature) then
		self:_PlayEffect(creature)
	end
	if Game.Myself == creature then
		-- myself effect
		if nil == self.shakeToken then
			local myselfEffect = self.staticData.Myself
			if nil ~= myselfEffect then
				local shake = myselfEffect.shake
				if nil ~= shake then
					self.shakeToken = CameraAdditiveEffectManager.Me():StartShake(
						shake.range,
						shake.time,
						shake.curve)
				end
			end
		end
	end
	creature:RegisterBuffGroup(self)
end

-- not first add command
function Buff:Hit(creature)
	self:_PlayHitEffect(creature)
end

-- 9-screen add
function Buff:Refresh(creature)
	self:_PlayEffect(creature)
	creature:RegisterBuffGroup(self)
end

-- remove command
function Buff:End(creature)
	self:_PlayEndEffect(creature)
	creature:UnRegisterBuffGroup(self)
end

function Buff:SetEffectVisible(visible)
	if(self.visible ~= visible) then
		self.visible = visible
		if(self.effect~=nil) then
			self.effect:SetActive(self.visible,CreatureHideOpt)
		end
	end
end

function Buff:_PlayOneShotEffect(creature, effectPath, sePath)
	if nil ~= sePath and "" ~= sePath then
		creature.assetRole:PlaySEOneShotOn(sePath)
	end

	if nil == effectPath then
		return nil
	end
	if(false == self.visible) then
		return nil
	end
	return creature.assetRole:PlayEffectOneShotOn(
		effectPath, 
		self.staticData.EP)
end

function Buff:_PlayStartEffect(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return false
	end
	if not creature:IsCullingVisible() 
		or 1 < creature:GetCullingDistanceLevel() then
		return false
	end
	self:CreateWeakData()
	if nil == self:GetWeakData(1) then
		self:SetWeakData(1, creature)
	end
	if nil ~= self:GetWeakData(2) then
		return true
	end
	local effect = self:_PlayOneShotEffect(
		creature, 
		GetEffectPath(self.config.Effect_start), 
		self.staticData.SE_start)
	if nil == effect then
		return false
	end
	self:SetWeakData(2, effect)
	return true
end

function Buff:_PlayHitEffect(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return
	end
	if not creature:IsCullingVisible() 
		or 1 < creature:GetCullingDistanceLevel() then
		return
	end
	self:_PlayOneShotEffect(
		creature, 
		GetEffectPath(self.config.Effect_hit), 
		self.staticData.SE_hit)
end

function Buff:_PlayEffect(creature)
	if nil ~= self.effect then
		return
	end
	if Game.HandUpManager:IsInHandingUp() then
		return
	end
	self:CreateWeakData()
	if nil == self:GetWeakData(1) then
		self:SetWeakData(1, creature)
	end
	if nil ~= self:GetWeakData(3) then
		return
	end
	local effectPath = GetEffectPath(self.config.Effect)
	if nil == effectPath then
		return
	end
	self.effect = creature.assetRole:PlayEffectOn(
		effectPath, 
		self.staticData.EP,
		nil,
		OnEffectCreated,
		self)
	if nil ~= self.effect then
		self:SetWeakData(3, self.effect)
		if(false == self.visible) then
			self.effect:SetActive(self.visible,CreatureHideOpt)
		end
	end
end

function Buff:_PlayEndEffect(creature)
	if Game.HandUpManager:IsInHandingUp() then
		return
	end
	if not creature:IsCullingVisible() 
		or 1 < creature:GetCullingDistanceLevel() then
		return
	end
	self:_PlayOneShotEffect(
		creature, 
		GetEffectPath(self.config.Effect_end), 
		self.staticData.SE_end)
end

function Buff:_DestroyEffect()
	self:_DestroyAroundEffects()
	if nil ~= self.effect then
		self.effect:Destroy()
		self.effect = nil
	end
end

function Buff:_ApplyLayerEffects()
	if 0 >= self.layer then
		self:_DestroyLayerEffects()
		return
	end
	self:_ApplyAroundEffects()
end

function Buff:_DestroyLayerEffects()
	if nil == self.layerEffects then
		return
	end
	TableUtility.ArrayClearByDeleter(self.layerEffects, ReusableObject.Destroy)
	ReusableTable.DestroyArray(self.layerEffects)
	self.layerEffects = nil
end

function Buff:_ApplyAroundEffects()
	if 0 >= self.layer or nil == self.effect or nil == self.effect:GetEffectHandle() then
		self:_DestroyLayerEffects()
		return
	end
	local parent = self.effect:GetEffectHandle().transform:GetChild(0)
	-- parent.gameObject:GetComponent(RotateSelf).rotateSpeed = AroundRotateSpeed
	if nil ~= self.config.Effect_around then
		local effectPath = GetEffectPath(self.config.Effect_around)
		if nil ~= effectPath then
			self:_AdjustAroundEffects(effectPath, parent, self.layer)
		else
			self:_DestroyLayerEffects()
		end
	else
		self:_DestroyLayerEffects()
	end
end

function Buff:_AdjustAroundEffects(effectPath, parent, count)
	if nil == self.layerEffects then
		self.layerEffects = ReusableTable.CreateArray()
	end
	local layerEffects = self.layerEffects
	
	local limitPath, lastLimitPath = self:_GetLimitAroundEffectPath(self.staticData.Logic.effectaround, count)
	if limitPath == nil and lastLimitPath == nil then
		for i=1, count do
			self:_PlayValidLayerEffect(i, effectPath, parent)
		end
	else
		local limitCount = count % AroundMaxCount
		if lastLimitPath ~= nil then
			lastLimitPath = GetEffectPath(lastLimitPath)
		else
			lastLimitPath = effectPath
		end

		count = AroundMaxCount

		local path
		for i=1, count do
			if i <= limitCount then
				path = GetEffectPath(limitPath)
			else
				path = lastLimitPath
			end

			self:_PlayValidLayerEffect(i, path, parent)
		end
	end

	local effectCount = #layerEffects
	if effectCount > count then
		for i=effectCount, count+1, -1 do
			layerEffects[i]:Destroy()
			layerEffects[i] = nil
		end
	end

	local pieceAngle = 360/count
	local radius = AroundRadius

	local effect = layerEffects[1]
	local p0 = tempVector3
	p0:Set(0, 0, radius)
	effect:ResetLocalPosition(p0)
	if 1 < count then
		local r = tempQuaternion
		for i=2, count do
			effect = layerEffects[i]
			tempVector3_1:Set(0, pieceAngle*(i-1), 0)
			r.eulerAngles = tempVector3_1
			local p = tempVector3_1
			LuaQuaternion.Better_MulVector3(r, p0, p)
			effect:ResetLocalPosition(p)
		end
	end
end

function Buff:_DestroyAroundEffects()
	self:_DestroyLayerEffects()
end

function Buff:_OnEffectCreated(effectHandle)
	if nil == self.effect or self.effect:GetEffectHandle() ~= effectHandle then
		return
	end
	if nil ~= self.config.Effect_around then
		effectHandle.transform.rotation = LuaGeometry.Const_Qua_identity
	end
	self:_ApplyAroundEffects()
end

function Buff:_ProcessLimitAroundEffectPaths(config)
	if self.aroundEffectPaths == nil then
		self.aroundEffectPaths = ReusableTable.CreateArray()

		local PreprocessEffectPaths = Game.PreprocessEffectPaths
		for i=1,#config do
			local path = PreprocessEffectPaths(StringUtil.Split(config[i], ","))
			self.aroundEffectPaths[#self.aroundEffectPaths + 1] = path
		end
	end
end

function Buff:_GetLimitAroundEffectPath(config, count)
	if config == nil then
		return nil
	end

	local index = math.floor(count / AroundMaxCount)
	if index < 1 then
		return nil
	end

	self:_ProcessLimitAroundEffectPaths(config)

	return self.aroundEffectPaths[index], self.aroundEffectPaths[index - 1]
end

function Buff:_PlayValidLayerEffect(index, path, parent)
	if index == nil then
		return
	end

	if path == nil then
		return
	end

	local effect = self.layerEffects[index]
	if effect == nil then
		effect = Asset_Effect.PlayOn(path, parent)
		self.layerEffects[index] = effect
	else
		if effect:GetPath() ~= path then
			effect:Destroy()

			effect = Asset_Effect.PlayOn(path, parent)
			self.layerEffects[index] = effect
		end
	end
end

function Buff:SetLayer(layer)
	self.layer = layer
	self:_ApplyLayerEffects()
end

function Buff:GetLayer()
	return self.layer
end

function Buff:SetLevel(level)
	-- self.level = level or 0
	--TODO now we dont need 
end

function Buff:GetLevel()
	-- return self.level
	--TODO now we dont need
end

-- override begin
function Buff:DoConstruct(asArray, buffStateID)
	self.visible = true
	self.staticData = Table_BuffState[buffStateID]
	self.config = Game.Config_BuffState[buffStateID]
	if(self.staticData == nil or self.config == nil)then
		error(buffStateID .. " is nil")
	end
	self.shakeToken = nil
end

function Buff:DoDeconstruct(asArray)
	self.staticData = nil
	self.config = nil
	self.layer = 0
	-- self.level = 0
	if nil ~= self.shakeToken then
		CameraAdditiveEffectManager.Me():EndShake(self.shakeToken)
		self.shakeToken = nil
	end
	self:_DestroyEffect()
	self:_DestroyLayerEffects()
	if self.aroundEffectPaths ~= nil then
		ReusableTable.DestroyAndClearArray(self.aroundEffectPaths)
		self.aroundEffectPaths = nil
	end
end

function Buff:OnObserverDestroyed(k, obj)
	if 2 == k then
		-- start finished
		local creature = self:GetWeakData(1)
		if nil ~= creature then
			self:_PlayEffect(creature)
		end
	elseif 3 == k and self.effect == obj then
		self.effect = nil
		self:_DestroyAroundEffects()
	end
end
-- override end