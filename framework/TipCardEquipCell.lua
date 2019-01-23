local BaseCell = autoImport("BaseCell");
TipCardEquipCell = class("TipCardEquipCell", BaseCell);

TipCardEquipCell.LightColor = "[FFC514]";
TipCardEquipCell.DarkColor = "[B8B8B8]";

function TipCardEquipCell:Init()
	self:FindObjs();
end

function TipCardEquipCell:FindObjs()
	self.symbol = self:FindChild("Symbol"):GetComponent(UISprite);
	self.name = self:FindChild("Name"):GetComponent(UILabel);
	self.desc = self:FindChild("Desc"):GetComponent(UILabel);
end

function TipCardEquipCell:SetData(data)
	if(data and data.staticData)then
		self.symbol.spriteName = "card_icon_"..data.staticData.Quality;

		self.name.text = self.LightColor..data.staticData.Name.."[-]";
		self.desc.text = data.staticData.Text;

		self.desc.gameObject:SetActive(true);
	else
		self.symbol.spriteName = "card_icon_0";

		self.name.text = ZhString.TipCardEquipCell_EmptySlot;
		
		self.desc.gameObject:SetActive(false);
	end
end