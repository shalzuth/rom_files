TempActivityView = class("TempActivityView", ContainerView)

TempActivityView.ViewType = UIViewType.NormalLayer

autoImport("TempActivityCell");

function TempActivityView:Init()
	local obj = self:LoadPreferb("cell/TempActivityCell", self.gameObject, true)
	self.tempActivityCell = TempActivityCell.new( obj );	
	self.tempActivityCell:AddEventListener(TempActivityEvent.ClickButton1, self.CloseSelf, self);
	self.tempActivityCell:AddEventListener(TempActivityEvent.ClickButton2, self.CloseSelf, self);
end

function TempActivityView:OnEnter()
	local viewdata = self.viewdata and self.viewdata.viewdata;
	if(viewdata)then
		self.tempActivityCell:SetData( viewdata.Config );
	end
end