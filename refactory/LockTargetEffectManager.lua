LockTargetEffectManager = class("LockTargetEffectManager")

--特效为异步，那么这里的逻辑也要按异步来做
function LockTargetEffectManager:ctor()
	self.friendColor = LuaColor(161.0/255.0,1,139.0/255.0,1)
	self.enemyColor = LuaColor(238.0/255.0,118.0/255.0,110.0/255.0,1)
	self._lockTargetGO = nil -- GameObject
	self._lockTargetEffect = nil -- Asset_Effect
	self._lockTargetEffectProjector = nil  -- c# unity Projector
	self._effectPath = EffectMap.Maps.LockedTarget
end

function LockTargetEffectManager:_CreateLockedTargetEffect()
	if(self._lockTargetEffect == nil and Slua.IsNull(self._lockTargetEffectProjector)) then
		self._lockTargetEffect = Asset_Effect.PlayAtXYZ(self._effectPath, 0,0,0,self.OnEffectCreated,self)
	end
end

function LockTargetEffectManager:_SetProjector(projector)
	self._lockTargetEffectProjector = projector
end

function LockTargetEffectManager:_EffectPrepared()
	return not Slua.IsNull(self._lockTargetGO) and Slua.IsNull(self._lockTargetEffectProjector) == false
end

function LockTargetEffectManager:_GetLockedTarget()
	if(self._lockedTargetID) then
		return SceneCreatureProxy.FindOtherCreature(self._lockedTargetID)
	end
	return nil
end

function LockTargetEffectManager:_SetLockTarget(creature)
	if(self:_EffectPrepared() and Slua.IsNull(self._lockTargetGO)==false) then
		if(self._lockedTargetID) then
			local preCreature = self:_GetLockedTarget()
			if(preCreature) then
				preCreature:Client_UnregisterFollow(self._lockTargetGO.transform)
			else
				Game.RoleFollowManager:UnregisterFollow(self._lockTargetGO.transform)
			end
		end
	end
	if(creature) then
		self._lockedTargetID = creature.data.id
	else
		self._lockedTargetID = nil
	end
end

function LockTargetEffectManager.OnEffectCreated( eObj,instance )
	instance._lockTargetGO = eObj.gameObject
	instance:_SetProjector(eObj:GetComponentInChildren(Projector))
	if(instance._lockedTargetID) then
		local ncreature = instance:_GetLockedTarget()
		if(ncreature) then
			instance:_DoLockTarget(ncreature)
		else
			instance:ClearLockedTarget()
		end
	else
		instance:ClearLockedTarget()
	end
end

function LockTargetEffectManager:SwitchLockedTarget(ncreature)
	if(ncreature and ncreature.assetRole) then
		self:_SetLockTarget(ncreature)
		if(self:_EffectPrepared()) then
			-- 如果当前已经有加载好的锁定特效
			self:_DoLockTarget(ncreature)
		else
			-- 加载、创建特效
			self:_CreateLockedTargetEffect()
		end
	end
end

function LockTargetEffectManager:_DoLockTarget(ncreature)
	local projector = self._lockTargetEffectProjector

	-- 预设值为1，省去代码获取
	-- local x,y,z = LuaGameObject.GetLocalPosition(projector.transform)
	local y = 1;
	local sx = ncreature.assetRole:GetScaleXYZ();
	ncreature.assetRole.complete:AdjustProjector(projector,y,sx)
	-- 效果需要
	projector.farClipPlane = 3;
	
	ncreature:Client_RegisterFollow(self._lockTargetGO.transform,nil,nil,self.OnLockedTargetLost,self)
	self:RefreshEffect()
end

function LockTargetEffectManager:ClearLockedTarget()
	self:_SetLockTarget(nil)
	if(self._lockTargetEffect) then
		self._lockTargetEffect:Destroy()
	end
	self._lockTargetGO = nil
	self._lockTargetEffect = nil
	self._lockTargetEffectProjector = nil
end

function LockTargetEffectManager.OnLockedTargetLost(transform,instance)
	instance:ClearLockedTarget()
end

function LockTargetEffectManager:GetLockedTargetID()
	return self._lockedTargetID
end

function LockTargetEffectManager:RefreshEffect()
	if(self:_EffectPrepared()) then
		local lockedTarget = self:_GetLockedTarget()
		local material = self._lockTargetEffectProjector.material
		if(lockedTarget and Slua.IsNull(material)==false) then
			local tintColor
			if(lockedTarget.data:GetCamp() == RoleDefines_Camp.ENEMY) then
				-- LogUtility.Info("lock target is Enemy")
				material:SetColor("_TintColor", self.enemyColor)
			else
				-- LogUtility.Info("lock target is not Enemy")
				material:SetColor("_TintColor", self.friendColor)
			end
		end
	end
end