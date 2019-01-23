autoImport("ItemCell");
DecomposeItemCell = class("DecomposeItemCell", ItemCell)

DecomposeItemCell.TestConfig = 
{
	{0, 0.1, ZhString.DecomposeItemCell_ResultTip1},
	{0.1, 0.3, ZhString.DecomposeItemCell_ResultTip2},
	{0.3, 0.6, ZhString.DecomposeItemCell_ResultTip3},
	{0.6, 1, ZhString.DecomposeItemCell_ResultTip4},
	{1, 1, ZhString.DecomposeItemCell_ResultTip5}
}

function DecomposeItemCell:Init()
	DecomposeItemCell.super.Init(self);
	self.chanceTip = self:FindComponent("ChanceTip", UILabel);

	self:AddCellClickEvent();
end

function DecomposeItemCell:SetData(data)
	DecomposeItemCell.super.SetData(self, data);
	
	if(data)then
		local minrate, maxrate = data.minrate or 0, data.maxrate or 0;
		self.numLab.text = math.floor(minrate) .. "~" .. math.ceil(maxrate)

		local rateTip = GameConfig.EquipUpgrade_ResultTip or self.TestConfig;
		local maxrateTip = rateTip[#rateTip];
		local next_maxrateTip = rateTip[#rateTip - 1];
		if(minrate >= 1)then
			self.chanceTip.text = maxrateTip[3];
		else
			local pctrate = (minrate + maxrate)/2;
			if(pctrate >= 1)then
				self.chanceTip.text = next_maxrateTip[3];
			else
				for i=1,#rateTip do
					local tip = rateTip[i];
					if(pctrate >= tip[1] and pctrate <= tip[2])then
						self.chanceTip.text = tip[3];
						break;
					end
				end
			end
		end
	else
		self.chanceTip.text = "";
	end
end