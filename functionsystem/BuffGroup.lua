BuffGroup = class("BuffGroup", ReusableObject)

BuffGroup.PoolSize = 5

local CreatureHideOpt = Asset_Effect.DeActiveOpt.CreatureHide

local AroundRadius = 1

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero
local tempQuaternion = LuaQuaternion.identity
local tempList = {}

local function GetEffectPath(paths)
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		return paths and paths[2] or nil
	end
	return paths and paths[1] or nil
end

local function OnEffectCreated(effectHandle, args)
	args:_OnEffectCreated(effectHandle)
end

function BuffGroup.Create()
	return ReusableObject.Create(BuffGroup, false)
end

function BuffGroup:RegisterBuff(creature, buff)
	self.buffCount = self.buffCount + 1
	if self.buffCount == 1 then
		self:_Start(creature, buff)
	end
	local buffID = buff.staticData.id
	if self.effect == nil or self.effect:GetEffectHandle() == nil then
		if self.waitBuffs == nil then
			self.waitBuffs = ReusableTable.CreateTable()
		end
		self.waitBuffs[buffID] = buff.config.EffectGroup_around
	else
		self:_ApplyAroundEffects(buffID, buff.config.EffectGroup_around)
	end
end

function BuffGroup:UnRegisterBuff(creature, buff)
	self.buffCount = self.buffCount - 1
	if self.buffCount == 0 then
		self:_End()
	else
		local buffID = buff.staticData.id
		if self.waitBuffs ~= nil then
			self.waitBuffs[buffID] = nil
		end
		self:_ApplyAroundEffects(buffID)
	end
end

function BuffGroup:SetEffectVisible(visible)
	if self.visible ~= visible then
		self.visible = visible
		if self.effect ~= nil then
			self.effect:SetActive(self.visible, CreatureHideOpt)
		end
	end
end

function BuffGroup:_Start(creature, buff)
	self:_PlayEffect(creature, buff)
end

function BuffGroup:_End()
	self:_DestroyAroundEffects()
	self:_DestroyEffect()
	self:_DestroyWaitBuffs()
end

function BuffGroup:_PlayEffect(creature, buff)
	if self.effect ~= nil then
		return
	end
	if Game.HandUpManager:IsInHandingUp() then
		return
	end
	self:CreateWeakData()
	if self:GetWeakData(1) ~= nil then
		return
	end
	local effectPath = GetEffectPath(buff.config.EffectGroup)
	if effectPath == nil then
		return
	end

	self.effect = creature.assetRole:PlayEffectOn(
		effectPath, 
		buff.staticData.EP,
		nil,
		OnEffectCreated,
		self)
	if nil ~= self.effect then
		self:SetWeakData(1, self.effect)
		if false == self.visible then
			self.effect:SetActive(self.visible, CreatureHideOpt)
		end
	end
end

function BuffGroup:_OnEffectCreated(effectHandle)
	if self.effect == nil or self.effect:GetEffectHandle() ~= effectHandle then
		return
	end

	effectHandle.transform.rotation = LuaGeometry.Const_Qua_identity

	if self.waitBuffs ~= nil then
		for k,v in pairs(self.waitBuffs) do
			self:_ApplyAroundEffects(k, v)
		end
		self:_DestroyWaitBuffs()
	end
end

function BuffGroup:_ApplyAroundEffects(buffID, effectAround)
	if self.effect == nil or self.effect:GetEffectHandle() == nil then
		self:_DestroyAroundEffects()
		return
	end

	if buffID == nil then
		return
	end

	if effectAround ~= nil then
		local parent = self.effect:GetEffectHandle().transform:GetChild(0)
		local effectPath = GetEffectPath(effectAround)
		if effectPath ~= nil then
			self:_AddAroundEffect(buffID, effectPath, parent)
		else
			self:_DestroyAroundEffect(buffID)
		end
	else
		self:_DestroyAroundEffect(buffID)
	end	
end

function BuffGroup:_AddAroundEffect(buffID, effectPath, parent)
	if self.aroundEffects == nil then
		self.aroundEffects = ReusableTable.CreateTable()
	end

	local effect = self.aroundEffects[buffID]
	if effect == nil then
		effect = Asset_Effect.PlayOn(effectPath, parent)
		self.aroundEffects[buffID] = effect

		self:_AdjustAroundEffects()
	end
end

function BuffGroup:_DestroyAroundEffect(buffID)
	if self.aroundEffects == nil then
		return
	end

	local effect = self.aroundEffects[buffID]
	if effect ~= nil then
		effect:Destroy()
		self.aroundEffects[buffID] = nil

		self:_AdjustAroundEffects()
	end
end

function BuffGroup:_AdjustAroundEffects()
	TableUtility.ArrayClear(tempList)
	for k,v in pairs(self.aroundEffects) do
		tempList[#tempList + 1] = v
	end

	local count = #tempList
	if count > 0 then
		local pieceAngle = 360/count
		local radius = AroundRadius

		local effect = tempList[1]
		local p0 = tempVector3
		p0:Set(0, 0, radius)
		effect:ResetLocalPosition(p0)
		if count > 1 then
			local r = tempQuaternion
			for i=2, count do
				effect = tempList[i]
				tempVector3_1:Set(0, pieceAngle*(i-1), 0)
				r.eulerAngles = tempVector3_1
				local p = tempVector3_1
				LuaQuaternion.Better_MulVector3(r, p0, p)
				effect:ResetLocalPosition(p)
			end
		end
	end
end

function BuffGroup:_DestroyEffect()
	if self.effect ~= nil then
		self.effect:Destroy()
		self.effect = nil
	end
end

function BuffGroup:_DestroyAroundEffects()
	if self.aroundEffects == nil then
		return
	end
	TableUtility.TableClearByDeleter(self.aroundEffects, ReusableObject.Destroy)
	ReusableTable.DestroyAndClearTable(self.aroundEffects)
	self.aroundEffects = nil	
end

function BuffGroup:_DestroyWaitBuffs()
	if self.waitBuffs ~= nil then
		ReusableTable.DestroyTable(self.waitBuffs)
		self.waitBuffs = nil
	end
end

function BuffGroup:GetBuffCount()
	return self.buffCount
end

function BuffGroup:DoConstruct(asArray)
	self.visible = true
	self.buffCount = 0
end

function BuffGroup:DoDeconstruct(asArray)
	self:_End()
end

function BuffGroup:OnObserverDestroyed(k, obj)
	if k == 1 and self.effect == obj then
		self.effect = nil
		self:_DestroyAroundEffects()
	end
end