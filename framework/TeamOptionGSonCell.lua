local BaseCell = autoImport("BaseCell");
TeamOptionGSonCell = class("TeamOptionGSonCell", BaseCell);

function TeamOptionGSonCell:Init()
	self:InitCell();
end

function TeamOptionGSonCell:InitCell()
	self.label = self:FindComponent("Label", UILabel);
	self.tog = self:FindComponent("Toggle", UIToggle);
	self:SetEvent(self.gameObject, function ()
		self.tog.value = true;
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
	
	--todo xde fix ui
	self.label.overflowMethod = 3
	self.label.width = 230
end

function TeamOptionGSonCell:SetData(data)
	self.data = data;
	if(data and data.SetShow==1)then
		self.label.text = data.NameZh;
		self.gameObject:SetActive(true);
	else
		self.gameObject:SetActive(false);
	end
end

function TeamOptionGSonCell:SetChoose(b)
	self.tog.value = b;
end