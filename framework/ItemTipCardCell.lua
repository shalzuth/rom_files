local BaseCell = autoImport("BaseCell");
ItemTipCardCell = class("ItemTipCardCell", BaseCell);

function ItemTipCardCell:Init()
	self:InitCell();
end

function ItemTipCardCell:InitCell()
	self.label1 = self:FindComponent("Label1", UILabel);
	self.label2 = self:FindComponent("Label2", UILabel);
end

function ItemTipCardCell:SetData(data)
	if(data)then
		local cardStr = "card_icon_"..data.staticData.Quality;
		self.label1.text = string.format("{uiicon=%s}%s%s[-]", cardStr, ColorUtil.TipLightColor, data.staticData.Name);
		self.label2.gameObject:SetActive(true);
		self.label2.text = data.staticData.Desc;
	else	
		self.label1.text = "{uiicon=card_icon_0}"..ColorUtil.TipDarkColor..ZhString.ItemTip_NoCard;
		self.label2.gameObject:SetActive(false);
		self.label2.text = "";
	end
end