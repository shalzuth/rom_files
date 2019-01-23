
--stick true=playon / false=playat
function NCreature:PlayEffect(key,path,epID,offset,loop,stick, callback, callbackArg )
	if(loop) then
		local effect = self:GetWeakData(key)
		if (effect == nil and self.assetRole) then
			if(loop) then
				if(stick) then
					effect = self.assetRole:PlayEffectOn(path,epID,offset, callback, callbackArg )
				else
					effect = self.assetRole:PlayEffectAt(path,epID,offset, callback, callbackArg )
				end
				self:SetWeakData(key,effect)
			end
			return effect
		end
		return nil
	else
		--on shot 不需要缓存
		if(stick) then
			return self.assetRole:PlayEffectOneShotOn(path,epID,offset, callback, callbackArg )
		else
			return self.assetRole:PlayEffectOneShotAt(path,epID,offset, callback, callbackArg )
		end
	end
end

function NCreature:RemoveEffect(key)
	local effect = self:GetWeakData(key)
	if(effect) then
		effect:Destroy()
	end
end

function NCreature:GetEffect(key)
	return self:GetWeakData(key)
end

function NCreature:PlayAudio(path,epID,loop)
	if(epID) then
		self.assetRole:PlaySEOneShotAt(path,epID)
	else
		if(loop) then
			self.assetRole:PlaySEOn(path)
		else
			self.assetRole:PlaySEOneShotOn(path)
		end
	end
end

function NCreature:OnObserverEffectDestroyed(key,effect)
end

local damagePos = LuaVector3();
function NCreature:PlayDamage_Effect(damage,damageType)
	local chesetTrans = self.assetRole:GetEPOrRoot(RoleDefines_EP.Chest);
	if(chesetTrans)then
		damagePos:Set(LuaGameObject.GetPosition(chesetTrans));
		if(damage>0)then
			local color = HurtNumColorType.Player
			if(CommonFun.DamageType.Normal_Sp == damageType or CommonFun.DamageType.Treatment_Sp == damageType) then
				color = HurtNumColorType.Normal_Sp
			end
			SkillLogic_Base.ShowDamage_Single(
				damageType, 
				damage, 
				damagePos, 
				HurtNumType.DamageNum_R, 
				color, 
				self)
		elseif(damage<0)then
			if(CommonFun.DamageType.Normal_Sp == damageType or CommonFun.DamageType.Treatment_Sp == damageType) then
				SkillLogic_Base.ShowDamage_Single(
					CommonFun.DamageType.Treatment_Sp, 
					-damage, 
					damagePos, 
					nil, 
					nil, 
					self)
			else
				SkillLogic_Base.ShowDamage_Single(
					CommonFun.DamageType.Treatment, 
					-damage, 
					damagePos, 
					nil, 
					nil, 
					self)
			end
		end
	end
end