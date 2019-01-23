autoImport("HurtNum");
DynamicHurtNum = reusableClass("DynamicHurtNum", HurtNum)

DynamicHurtNum.PoolSize = 50

function DynamicHurtNum:Show( parent )
	if(not self.pos or LuaGameObject.ObjectIsNull( parent ))then
		self:Destroy();
		return;
	end

	local path = nil;
	if(HurtNumType.Miss == self.type)then
		path = EffectMap.Maps.HurtNumMiss;
	else
		path = EffectMap.Maps.HurtNum;
	end
	self.effect = Asset_Effect.PlayOneShotOn( path, parent.transform, DynamicHurtNum._EffectShow, self )
	self.effect:RegisterWeakObserver(self);
end

function DynamicHurtNum._EffectShow( effectHandle, owner )
	if(owner)then
		local effectGO = effectHandle.gameObject;
		effectGO.name = "DamageNum"..owner.colorType;
		effectGO:GetComponent(StayOriginalPosition):SetPosition(owner.pos);

		local labelTrans = effectGO.transform:Find("Label");
		local labelcomp = labelTrans:GetComponent(UILabel)
		if(labelcomp)then
			labelcomp.gameObject.layer = effectGO.layer;
			local num = tonumber(owner.num);
			if(num and num ~= 0)then
				num = math.floor(num);
				labelcomp.text = num;
			else
				labelcomp.text = owner.num;
			end

			if(owner.colorType and HurtNumColorMap[owner.colorType])then
				labelcomp.color = HurtNumColorMap[owner.colorType];
			end

			if(owner.outlineColor)then
				labelcomp.effectColor = owner.outlineColor;
			end
		end

		owner.critTrans = labelTrans.transform:Find("Crit");
		if(owner.critTrans)then
			owner.critTrans.gameObject:SetActive(owner.critType == HurtNum_CritType.PAtk);
		end
		owner.magicTrans = labelTrans.transform:Find("MagicCrit");
		if(owner.magicTrans)then
			owner.magicTrans.gameObject:SetActive(owner.critType == HurtNum_CritType.MAtk);
		end

		owner:PlayAni(effectGO, owner.type);
	end
end

-- override begin
function DynamicHurtNum:DoConstruct(asArray, args)
	DynamicHurtNum.super.DoConstruct(self, asArray, args);

	self.pos = args[1]:Clone();
	self.num = args[2];
	self.type = args[3];
	self.colorType = args[4];
	self.critType = args[5];

	self:Show(SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.DamageNum));
end

function DynamicHurtNum:DoDeconstruct(asArray)
	if(self.effect)then
		self.effect:Stop();
	end

	self.effect = nil;

	if(self.pos)then
		self.pos:Destroy();
	end
	self.pos = nil;

	if(self.critTrans)then
		self.critTrans.gameObject:SetActive(false);
		self.critTrans = nil;
	end
	if(self.magicTrans)then
		self.magicTrans.gameObject:SetActive(false);
		self.magicTrans = nil;
	end
end
-- override end


function DynamicHurtNum:ObserverDestroyed(obj)
	if(obj == self.effect)then
		self.effect = nil;
		self:Destroy();
	end
end




