local BaseCell = autoImport("BaseCell");
MapInfoCell = class("MapInfoCell", BaseCell)

MapInfoType = {
	Event = 1,
	Npc = 2,
	ExitPoint = 3,
}

function MapInfoCell:Init()
	self:InitCell();
end

function MapInfoCell:InitCell()
	self.icon = self:FindComponent("MapIcon", UISprite);
	self.name = self:FindComponent("InfoName", UILabel);
	
	self:AddCellClickEvent();
end

-- icontype, id, icon, iconScale, label
function MapInfoCell:SetData(data)
	self.data = data;

	local iconType, icon, label, iconScale = data.type, data.icon, data.label, data.iconScale;
	if(not iconType or not icon or not label)then
		return;
	end

	if(iconType == MapInfoType.Npc or iconType == MapInfoType.ExitPoint)then
		if(IconManager:SetMapIcon(icon, self.icon))then
			self.gameObject:SetActive(true);
		else
			self.gameObject:SetActive(false);
			return;
		end
	elseif(iconType == MapInfoType.Event)then
		if(IconManager:SetUIIcon(icon, self.icon))then
			self.gameObject:SetActive(true);
		else
			self.gameObject:SetActive(false);
			return;
		end
	end
	self.icon:MakePixelPerfect();
	if(iconScale)then
		self.icon.width = self.icon.width * iconScale;
		self.icon.height = self.icon.height * iconScale;
	end
	self.name.text = label;
end