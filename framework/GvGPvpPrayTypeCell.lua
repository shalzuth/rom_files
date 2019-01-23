local BaseCell = autoImport("BaseCell");
GvGPvpPrayTypeCell = class("GvGPvpPrayTypeCell", BaseCell);
local csv = GameConfig.GvGPvP_PrayType
function GvGPvpPrayTypeCell:Init()
	self.bg = self:FindComponent("Bg", UISprite);
	self.attriBg = self:FindComponent("AttriBg", UISprite);
	self.level = self:FindComponent("Level", UILabel);
	self.attLab = self:FindComponent("attLab", UILabel);
	self.costImg = self:FindComponent("Cost",UISprite);
	self.costNum = self:FindComponent("CostLab", UILabel);
	self.chooseSymbol = self:FindGO("ChooseSymbol");
	self:AddCellClickEvent();
	self.effectBg = self:FindComponent("EffectContainer", ChangeRqByTex);
end

function GvGPvpPrayTypeCell:SetData(data)
	self.data = data;
	if(data)then
		if(data.type and #csv>=data.type and csv[data.type] and csv[data.type].colorID)then
			local colorCfg = Table_GFaithUIColorConfig[GameConfig.GvGPvP_PrayType[data.type].colorID];
			if(colorCfg)then
				local hasc, rc = ColorUtil.TryParseHexString(colorCfg.levelEffect_Color);
				self.level.effectColor = rc;
				local hasc, rc = ColorUtil.TryParseHexString(colorCfg.iconBg_Color);
				self.attriBg.color = rc;
			end
		end
		if(0==data.curPray.lv)then
			self.level.text=0;
			self.attLab.text=data.nextPray.staticData.AttrName
			local cost = data.nextPray.itemCost
			IconManager:SetItemIcon(cost.staticData.Icon,self.costImg)
			self.costNum.text=cost.num
			self:Show(self.costNum);
		elseif(0==data.nextPray.lv)then
			self.level.text=data.curPray.lv;
			self.attLab.text=data.curPray.staticData.AttrName
			local cost = data.curPray.itemCost
			IconManager:SetItemIcon(cost.staticData.Icon,self.costImg)
			self:Hide(self.costNum);
		else
			self.level.text=data.curPray.lv;
			self.attLab.text=data.nextPray.staticData.AttrName
			local cost = data.nextPray.itemCost
			IconManager:SetItemIcon(cost.staticData.Icon,self.costImg)
			self.costNum.text=cost.num
			self:Show(self.costNum);
		end
		self:UpdateChoose();
	end
end

function GvGPvpPrayTypeCell:SetChoose(id)
	self.chooseId = id;
	self:UpdateChoose()
end

function GvGPvpPrayTypeCell:UpdateChoose()
	if(self.data and self.chooseId and self.data.id == self.chooseId)then
		self.chooseSymbol:SetActive(true);
	else
		self.chooseSymbol:SetActive(false);
	end
end

function GvGPvpPrayTypeCell:PlayPrayEffect()
	self:PlayUIEffect(EffectMap.UI.GodlessBlessing, 
						self.effectBg.gameObject, 
						true, 
						GvGPvpPrayTypeCell.PrayEffectHandle, 
						self);
end

function GvGPvpPrayTypeCell.PrayEffectHandle(effectHandle, owner)
	if( effectHandle and not LuaGameObject.ObjectIsNull(effectHandle.gameObject) )then
		owner.effectBg:AddChild(effectHandle.gameObject);
	end
end


