local BaseCell = autoImport("BaseCell");
CostInfoCell = class("CostInfoCell", BaseCell)

function CostInfoCell:Init()
	self.label = self:FindComponent("Label", UILabel);
	self.symbol = self:FindComponent("Symbol", UISprite);
end

function CostInfoCell:SetData(id)
	if(id)then
		if(id == 100)then
			local userdata = Game.Myself and Game.Myself.data.userdata;
			if(userdata)then
				local num = userdata:Get(UDEnum.SILVER) or 0;
				self.label.text = StringUtil.NumThousandFormat( num );
			end
		elseif(id == 140)then
			local userdata = Game.Myself and Game.Myself.data.userdata;
			if(userdata)then
				local num = userdata:Get(UDEnum.CONTRIBUTE) or 0;
				self.label.text = StringUtil.NumThousandFormat( num );
			end
		else
			self.label.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(id));
		end

		local icon = Table_Item[id].Icon;
		IconManager:SetItemIcon(icon, self.symbol);
	end
end

function CostInfoCell:SetSize(w,h)
	self.symbol.width = w;
	self.symbol.heigth = h;
end