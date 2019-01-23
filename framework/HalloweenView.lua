HalloweenView = class("HalloweenView", ContainerView)

HalloweenView.ViewType = UIViewType.NormalLayer

autoImport("TempActivityCell");

function HalloweenView:Init()
	local obj = self:LoadPreferb("cell/TempActivityCell", self.gameObject, true)
	self.tempActivityCell = TempActivityCell.new( obj );	
	self.tempActivityCell:AddEventListener(TempActivityEvent.ClickButton1, self.CloseSelf, self);
	self.tempActivityCell:AddEventListener(TempActivityEvent.ClickButton2, self.CloseSelf, self);
end

function HalloweenView:OnEnter()
	local config = GameConfig.Activity.HalloweenActivity;
	if(config)then
		self.tempActivityCell:SetData( config );
	end
end