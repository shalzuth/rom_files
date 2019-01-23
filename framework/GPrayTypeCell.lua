local BaseCell = autoImport("BaseCell");
GPrayTypeCell = class("GPrayTypeCell", BaseCell);

autoImport("GFaithTypeCell");

function GPrayTypeCell:Init()
	self.bg = self:FindComponent("Bg", UISprite);
	self.attriBg = self:FindComponent("AttriBg", UISprite);
	self.level = self:FindComponent("Level", UILabel);
	self.tipLabel = self:FindComponent("Label", UILabel);
	self.robLabel = self:FindComponent("ROBLabel", UILabel);
	self.contriLabel = self:FindComponent("ContriLabel", UILabel);

	self.chooseSymbol = self:FindGO("ChooseSymbol");
	self:AddCellClickEvent();
	self.effectBg = self:FindComponent("EffectContainer", ChangeRqByTex);
end

function GPrayTypeCell:SetData(data)
	self.data = data;
	if(data)then
		local sData, level = data.staticData, data.level;
		
		self.level.text = level;

		local colorCfg = Table_GFaithUIColorConfig[sData.id];
		if(colorCfg)then
			local hasc, rc = ColorUtil.TryParseHexString(colorCfg.levelEffect_Color);
			self.level.effectColor = rc;
			local hasc, rc = ColorUtil.TryParseHexString(colorCfg.iconBg_Color);
			self.attriBg.color = rc;
		end
		
		self.data.cost = {
			Money = math.floor(GuildFun.calcGuildPrayMon(sData.id, level)),
			Contribution = GuildFun.calcGuildPrayCon(sData.id, level),
		};
		self.robLabel.text = self.data.cost.Money;
		self.contriLabel.text = self.data.cost.Contribution;

		self.tipLabel.text = sData.Name..ZhString.GPrayTypeCell_Pray;
	end
end

function GPrayTypeCell:SetChoose(b)
	self.chooseSymbol:SetActive(b);
end

function GPrayTypeCell:PlayPrayEffect()
	self:PlayUIEffect(EffectMap.UI.GodlessBlessing, 
						self.effectBg.gameObject, 
						true, 
						GPrayTypeCell.PrayEffectHandle, 
						self);
end

function GPrayTypeCell.PrayEffectHandle(effectHandle, owner)
	if( effectHandle and not LuaGameObject.ObjectIsNull(effectHandle.gameObject) )then
		owner.effectBg:AddChild(effectHandle.gameObject);
	end
end













