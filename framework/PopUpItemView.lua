PopUpItemView = class("PopUpItemView", BaseView);

PopUpItemView.ViewType =  UIViewType.Popup10Layer;

function PopUpItemView:Init()
	local grid = self:FindComponent("ItemGrid", UIGrid);
	self.ctl = UIGridListCtrl.new(grid, ItemCell, "ItemCell");

	self.icon = self:FindComponent("TitleIcon", UISprite);

	self.bgClick = self:FindGO("BgClick");
	self:AddClickEvent(self.bgClick, function (go)
		self:CloseSelf();
	end);

	self.effectMap = {};

	self.effectMap[1] = self:FindGO("TitleEffect");
	self.effectMap[2] = self:FindGO("TitleEffect2");
end

function PopUpItemView:OnEnter()
	PopUpItemView.super.OnEnter(self);
	self.gameObject:SetActive(true);

	local viewdata = self.viewdata.viewdata;
	if(viewdata)then
		local icon, datas, effectIndex = viewdata.icon, viewdata.datas, viewdata.effectIndex;
		self:UpdateData(icon, datas, effectIndex);
	end
end

function PopUpItemView:UpdateData(icon, datas, effectIndex)
	self.icon.spriteName = tostring(icon);
	self.icon:MakePixelPerfect();
	self.ctl:ResetDatas(datas);

	effectIndex = effectIndex or 1;
	for i=1,#self.effectMap do
		self.effectMap[i]:SetActive(i == effectIndex);
	end
end

function PopUpItemView:OnExit()
	PopUpItemView.super.OnExit(self);
	self.gameObject:SetActive(false);
end