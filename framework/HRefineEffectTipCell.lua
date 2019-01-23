local BaseCell = autoImport("BaseCell");
HRefineEffectTipCell = class("HRefineEffectTipCell", BaseCell)

function HRefineEffectTipCell:Init()
	self.refineLv = self:FindComponent("RefineLv", UILabel);
	self.effectName = self:FindComponent("EffectName", UILabel);
	self.effectValue = self:FindComponent("EffectValue", UILabel);
end

function HRefineEffectTipCell:SetData(data)
	self.data = data;
	
	if(data)then
		self.gameObject:SetActive(true);

		self.refineLv.text = "+" .. data[1];

		local effect = data[2];
		if(effect)then
			local proKey, proValue = effect[1], effect[2];

			local nowEN_Str = GameConfig.EquipEffect[proKey] or proKey .. " No Find";
			self.effectName.text = GameConfig.EquipEffect[ effect[1] ] or effect[1] .. " No Find";
			
			local nowEV_Str = "";
			local PropNameConfig = Game.Config_PropName
			local config = PropNameConfig[ proKey ];
			if(config.IsPercent == 1)then
				nowEV_Str = proValue * 100 .. "%";
			else
				nowEV_Str = proValue
			end
			if(proValue > 0)then
				nowEV_Str = "+" .. nowEV_Str;
			end
			self.effectValue.text = nowEV_Str;
		else
			self.effectName.text = "--";
			self.effectValue.text = "";
		end
	else
		self.gameObject:SetActive(false);
	end
end