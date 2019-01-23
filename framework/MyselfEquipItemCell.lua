autoImport("BaseItemCell");
MyselfEquipItemCell = class("MyselfEquipItemCell", BaseItemCell);

function MyselfEquipItemCell:ctor(obj, index, isfashion)
	if(index)then
		self.index = index;
	end

	MyselfEquipItemCell.super.ctor(self, obj);

	if(isfashion == nil)then
		self.isfashion = false;
	else
		self.isfashion = isfashion;
	end

	if(self.index)then
		local spname
		if(index == 5 or index == 6)then
			spname = "bag_equip_6"
		else
			spname = "bag_equip_"..self.index;
		end
		local symbol = self:FindComponent("Symbol", UISprite);
		IconManager:SetUIIcon(spname, symbol);
		symbol:MakePixelPerfect();
	end

	self.noEffect = self:FindGO("NoEffect");
	self.offForbid = self:FindGO("OffForbid");
	self.forbidColdDown = self:FindComponent("ForbidColdDown", UISprite);

	self:AddCellClickEvent();
	self:AddCellDoubleClickEvt();
end

function MyselfEquipItemCell:SetData(data)
	MyselfEquipItemCell.super.SetData(self, data);
	self:UpdateMyselfInfo();

	if(data and data.staticData)then
		local equipType = data.equipInfo.equipData.EquipType;
		local config = GameConfig.EquipType[equipType];
		if(config)then
			local site = config.site;
			local isPosRight = false;
			for k,v in pairs(site)do
				if(v == data.index)then
					isPosRight = true;
				end
			end
			if(isPosRight == false and self.invalid)then
				self:SetActive(self.invalid, true);
			end
		end
		if(self.isfashion and self.noEffect)then
			self.noEffect:SetActive(not self:IsEffective());
		end
	end

	self:UpdateEquipUpgradeTip();
end

function MyselfEquipItemCell:IsEffective()
	if(self.data)then
		local roleEquipBag = BagProxy.Instance:GetRoleEquipBag();
		local equip = roleEquipBag:GetEquipBySite(self.index);
		if(equip)then
			return equip.equipInfo.equipData.Type == self.data.equipInfo.equipData.Type;
		end
	end
	return true;
end

function MyselfEquipItemCell:ShowStrentlv( b )
	if(self.data and self.strenglv)then
		if(self.data.equipInfo and self.data.equipInfo.strengthlv>0)then
			self.strenglv.gameObject:SetActive( b );
		end
	end
end




function MyselfEquipItemCell:GetCD()
	if(self.data == nil)then
		local stateTime = MyselfProxy.Instance:GetEquipPos_StateTime(self.index);
		if(stateTime and stateTime.offendtime)then
			local delta = ServerTime.ServerDeltaSecondTime(stateTime.offendtime * 1000);
			if(delta > 0)then
				return delta;
			end
		end
	end
	return MyselfEquipItemCell.super.GetCD(self);
end

function MyselfEquipItemCell:GetMaxCD()
	if(self.data == nil)then
		local stateTime = MyselfProxy.Instance:GetEquipPos_StateTime(self.index);
		if(stateTime and stateTime.offduration)then
			return stateTime.offduration;
		end
	end

	return MyselfEquipItemCell.super.GetMaxCD(self);
end

function MyselfEquipItemCell:RefreshCD(f)
	if(self.offForbid)then
		self.offForbid:SetActive(f > 0);
	end
	
	if(self.data == nil)then
		if(self.offForbid)then
			self.offForbid:SetActive(f > 0);
		end

		if(self.forbidColdDown)then
			self.forbidColdDown.fillAmount = f
		end
		return f == 0;
	else
		if(self.offForbid)then
			self.offForbid:SetActive(false);
		end
		if(self.forbidColdDown)then
			self.forbidColdDown.fillAmount = 0
		end
		return MyselfEquipItemCell.super.RefreshCD(self, f);
	end
end

function MyselfEquipItemCell:ClearCD()
	MyselfEquipItemCell.super.ClearCD(self);
end


