local BaseCell = autoImport("BaseCell");
OricalCardCell = class("OricalCardCell", BaseCell);

autoImport("Simple_OricalCardCell");

function OricalCardCell:Init()
	local cardCellGO = self:FindGO("CardCell");
	self.simpleCardCell = Simple_OricalCardCell.new(cardCellGO);

	self.name = self:FindComponent("name", UILabel);
	self.desc = self:FindComponent("desc", UILabel);

	self:AddCellClickEvent();
end

function OricalCardCell:SetData(data)
	if(data == nil)then
		self.gameObject:SetActive(false);
		return;
	end

	local id,num;
	if(type(data) == "number")then
		id,num = data, 1;
	elseif(type(data) == "table")then
		id,num = data.id, data.num;
	end
	if(id == nil)then
		self.gameObject:SetActive(false);
		return;
	end

	self.data = {id = id, num = num};
	
	local sdata = Table_PveCard and Table_PveCard[id];
	if(sdata == nil)then
		self.gameObject:SetActive(false);
		return;
	end

	self.gameObject:SetActive(true);
	
	self.name.text = string.format("%s x%s", sdata.Name, num);
	self.desc.text = sdata.Message;

	self.simpleCardCell:SetData(sdata);
end