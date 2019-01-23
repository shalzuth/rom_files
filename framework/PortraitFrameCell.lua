local baseCell = autoImport("BaseCell");
PortraitFrameCell = class("PortraitFrameCell",baseCell);

autoImport("FrameCell");

function PortraitFrameCell:Init()
	self.portraitCell = self:FindChild("PlayerFrameCell");
	self.portraitCell = FrameCell.new(self.portraitCell);
	self.lock = self:FindChild("Lock");
	self.newtag = self:FindGO("NewTag");

	self:AddEvent();
end

function PortraitFrameCell:AddEvent()
	self:SetEvent(self.gameObject, function (g)
		self:PassEvent(MouseEvent.MouseClick, {obj = self.gameObject, data = self.data});
	end);
end

function PortraitFrameCell:SetData(data)
	if(data == nil)then
		return;
	end
	self.data = data;
	local name = Table_Item[data.id] and Table_Item[data.id].Icon;
	if(name~=nil)then
		self.portraitCell:SetData(name);	
	end
	local isnew = RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_PHOTOFRAME, data.id)
	self:SetActive(self.newtag, isnew);
	self:SetActive(self.lock, data.Lock == 1);
end