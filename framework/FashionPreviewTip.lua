autoImport("BaseTip")
FashionPreviewTip = class("FashionPreviewTip" ,BaseTip)

FashionPreviewEvent = {
	Close = "FashionPreviewEvent_Close",
}

FashionPreviewTip.Shield_Weapon = {
	["Sword"] = 1,
	["Knife"] = 1,
	["Mace"] = 1,
	["Axe"] = 1,
	["Spear"] = 1,
}

FashionPreviewTip.ShowShield_Class = {
	[72] = 1,
	[73] = 1,
	[74] = 1,
}

FashionPreviewTip.ShowDoubleHand_Weapon = {
	["Sword"] = 1,
	["Knife"] = 1,
	["Katar"] = 1,
	["Axe"] = 1,
	['Knuckle'] = 1,
	['Staff'] = 1,
}

FashionPreviewTip.ShowDoubleHand_Class = {
	[31] = 1,
	[32] = 1,
	[33] = 1,
	[34] = 1,
	-- [92] = 1,
	-- [93] = 1,
	-- [94] = 1,
	[122] = 1,
	[123] = 1,
	[124] = 1,
}

function FashionPreviewTip:ctor(parent)
	FashionPreviewTip.super.ctor(self, "FashionPreviewTip", parent)

	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.roleTex = self:FindComponent("RoleTex", UITexture);
	self.closeButton = self:FindGO("CloseButton");
	self:AddClickEvent(self.closeButton, function (go)
		self:OnExit();
	end);
	local hideToggleGO = self:FindGO("HideToggle");
	self.hideToggle = hideToggleGO:GetComponent(UIToggle) --  self:FindComponent("HideToggle", UIToggle);
	self:AddTabEvent(hideToggleGO, function (go, value)
		-- LocalSaveProxy.Instance:SetFashionPreviewTip_ShowOtherPart(value)
		self:RefreshShow();
	end);

	self.panel=self.gameObject:GetComponent(UIPanel)
	local temp = self.gameObject.transform.parent:GetComponentInParent(UIPanel)
	if(temp)then
		self.panel.depth = temp.depth+1
	end

	self:AddDragEvent(self.roleTex.gameObject, function (go,delta) self:RotateRoleEvt(go,delta) end)

	EventManager.Me():AddEventListener(ServiceEvent.NUserTransformPreDataCmd, self.HandleTransformed, self);
end

function FashionPreviewTip:HandleTransformed(data)
	local datas = data and data.datas
	if(datas)then
		local userdata = UserData.CreateAsTable()
		for i=1,#datas do
			userdata:SetByID(datas[i].type, datas[i].value, datas[i].bytes);
		end
		self:RefreshByUserData(userdata);

		userdata:Destroy();
	end
end

function FashionPreviewTip:RotateRoleEvt(go, delta)
	if(self.model)then
		local deltaAngle = -delta.x * 360 / 400
		self.model:RotateDelta( deltaAngle);
	end
end

function FashionPreviewTip:SetData(id)
	self.id = id;
	-- self.hideToggle.value = LocalSaveProxy.Instance:GetFashionPreviewTip_ShowOtherPart(value);
	self:RefreshShow();
end

function FashionPreviewTip:RefreshShow()
	if(Game.Myself.data:IsTransformed())then
		ServiceNUserProxy.Instance:CallTransformPreDataCmd() 
	else
		self:RefreshByUserData(Game.Myself.data.userdata);
	end
end

function FashionPreviewTip:RefreshByUserData(userdata)
	local id = self.id;

	local parts = Asset_Role.CreatePartArray();
	local partIndex = Asset_Role.PartIndex;
	local partIndexEx = Asset_Role.PartIndexEx;
		
	local hideOther = self.hideToggle.value;
	local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);

	if(hideOther)then
		local sex = Game.Myself.data.userdata:Get(UDEnum.SEX);
		parts[partIndex.Body] = sex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody

		parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0;
		parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0;
		parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0;
		parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0;
	else
		parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0;
		parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0;
		parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0;
		parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0;
		parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0;
		parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0;
		parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0;
		parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0;
		parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0;
		parts[partIndex.Mount] = 0
		parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0;

		parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0;
		parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0;
		parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0;
		parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0;
	end

	local isWeapon = Table_Equip[id] and Table_Equip[id].EquipType == 1;
	local itemPartIndex = ItemUtil.getItemRolePartIndex(id);

	if(itemPartIndex)then
		if(itemPartIndex == Asset_Role.PartIndex.Body)then
			parts[itemPartIndex] = Table_Equip[id].Body;
		elseif(itemPartIndex == Asset_Role.PartIndex.Hair)then
			parts[itemPartIndex] =  ShopDressingProxy.Instance:GetHairStyleIDByItemID(id)
		else
			parts[itemPartIndex] = id;
		end
	end

	local equiptype = Table_Equip[id] and Table_Equip[id].Type;
	if(self.ShowShield_Class[class])then
		if(equiptype == "Shield")then
			isWeapon = true;

			local rightWeapon = parts[partIndex.RightWeapon];
			if(rightWeapon~=nil and rightWeapon ~= 0)then
				local rightWeaponType = Table_Equip[rightWeapon] and Table_Equip[rightWeapon].Type;
				if(not self.Shield_Weapon[rightWeaponType])then
					parts[partIndex.RightWeapon] = 0;
				end
			end
			parts[partIndex.LeftWeapon] = id;
		elseif( not hideOther and self.Shield_Weapon[equiptype] )then
			local shieldSite = GameConfig.EquipType[3].site[1];
			local shieldItem = BagProxy.Instance.roleEquip:GetEquipBySite(shieldSite);
			if(shieldItem and shieldItem.equipInfo and shieldItem.equipInfo.equipData.Type == "Shield")then
				parts[partIndex.LeftWeapon] = shieldItem.staticData.id;
			end
		end
	elseif(self.ShowDoubleHand_Class[class] and self.ShowDoubleHand_Weapon[ equiptype ])then
		parts[partIndex.LeftWeapon] = id;
		parts[partIndex.RightWeapon] = id;
	end
	self.model = UIModelUtil.Instance:SetRoleModelTexture(self.roleTex, parts);
	self.model:RegisterWeakObserver(self);
	Asset_Role.DestroyPartArray(parts);

	if(isWeapon)then
		self.model:PlayAction_AttackIdle();
	end
end

function FashionPreviewTip:ObserverDestroyed(obj)
	if(obj == self.model)then
		self.model = nil;
	end
end

local tempV3 = LuaVector3()
function FashionPreviewTip:SetAnchorPos(isright)
	if(isright)then
		tempV3:Set(0,0,0);
	else
		tempV3:Set(-320,0,0);
	end
	self.gameObject.transform.localPosition = tempV3;
end

function FashionPreviewTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function FashionPreviewTip:OnExit()
	EventManager.Me():RemoveEventListener(ServiceEvent.NUserUserTransformPreDataCmd, self.UpdateTradePrice, self)

	GameObject.Destroy(self.gameObject)
	self:PassEvent(FashionPreviewEvent.Close);
	return true	
end
