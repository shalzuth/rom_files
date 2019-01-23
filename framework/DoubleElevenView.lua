DoubleElevenView = class("DoubleElevenView", ContainerView)

DoubleElevenView.ViewType = UIViewType.NormalLayer

autoImport("TempActivityCell");

function DoubleElevenView:Init()
	local obj = self:LoadPreferb("cell/TempActivityCell", self.gameObject, true)
	self.tempActivityCell = TempActivityCell.new( obj );	
	self.tempActivityCell:AddEventListener(TempActivityEvent.ClickButton1, self.CloseSelf, self);
	self.tempActivityCell:AddEventListener(TempActivityEvent.ClickButton2, self.CloseSelf, self);
end

function DoubleElevenView:OnEnter()
	local config = GameConfig.Activity.DoubleEleven;
	if(config)then
		self.tempActivityCell:SetData( config );
	end
end