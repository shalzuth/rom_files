autoImport("HurtNum");
StaticHurtNum = reusableClass("StaticHurtNum", HurtNum)

StaticHurtNum.PoolSize = 20

function StaticHurtNum:Show(num, pos)
	if(self.hide)then
		return;
	end

	local parent = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.DamageNum);
	if(LuaGameObject.ObjectIsNull(parent))then
		return;
	end

	self.num = math.floor(self.num + num);
	if 0 >= self.num then
		return
	end

	if(self.pos)then
		self.pos:Destroy();
		self.pos = nil;
	end
	self.pos = pos:Clone();

	if(not self.effect)then
		self.effect = Asset_Effect.PlayOn(EffectMap.Maps.HurtNum, 
									parent.transform, 
									StaticHurtNum._EffectShow, 
									self);
		self.effect:RegisterWeakObserver(self);
	else
		self:UpdateEffect();
	end
end

function StaticHurtNum._EffectShow( effectHandle, owner )
	if(effectHandle and owner)then
		local effectGO = effectHandle.gameObject;
		owner.UpdateEffect(owner, effectGO);
	end
end

function StaticHurtNum:UpdateEffect(effectGO)
	if(effectGO and self.effectGO ~= effectGO)then
		self.effectGO = effectGO;
		effectGO.name = "DamageNum"..self.colorType;
		self.originalPos = effectGO:GetComponent(StayOriginalPosition);
		self.labelcomp = effectGO.transform:Find("Label"):GetComponent(UILabel)
		self.labelcomp.gameObject.layer = effectGO.layer;
	end

	if(not LuaGameObject.ObjectIsNull(self.effectGO))then
		if(self.originalPos)then
			self.originalPos:SetPosition(self.pos);
		end

		if(self.labelcomp)then
			self.labelcomp.text = self.num;
			self.labelcomp.color = HurtNumColorMap[ HurtNumColorType.Combo ];
		end

		self:PlayAni(self.effectGO, HurtNumType.DamageNum_U);
	end
end

function StaticHurtNum:Hide()
	if(self.effect)then
		self.effect:Stop();
	end

	self.hide = true;
end

function StaticHurtNum:AddRef()
	self.ref = self.ref + 1;
end

function StaticHurtNum:SubRef()
	self.ref = self.ref - 1;
	if(self.ref <= 0)then
		self:End();
	end
end

function StaticHurtNum:End()
	if(not self.effect or Slua.IsNull(self.effectGO))then
		self:Destroy();
		return;
	end

	self:PlayAni(self.effectGO, HurtNumType.DamageNum);

	self:RemoveTween();
	self.ltd = LeanTween.delayedCall(2.5, function ()
		self:Destroy();
	end)
end

function StaticHurtNum:RemoveTween()
	if( self.ltd ~= nil )then
		self.ltd:cancel();
	end
	self.ltd = nil;
end

-- override begin
function StaticHurtNum:DoConstruct(asArray, colorType)
	self.hide = false;

	self.colorType = colorType;
	self.num = 0;
	self.ref = 0;	
end

function StaticHurtNum:DoDeconstruct(asArray)
	self:RemoveTween();
	
	if(self.effect)then
		self.effect:Destroy();
	end
	
	if(self.pos)then
		self.pos:Destroy();
	end
	self.pos = nil;
end
-- override end

function StaticHurtNum:ObserverDestroyed(obj)
	if(obj == self.effect)then
		self.effect = nil;
		self.effectGO = nil;
	end
end


