HireCatInfoView = class("HireCatInfoView", ContainerView)

HireCatInfoView.ViewType = UIViewType.NormalLayer

autoImport("HireCatTip");

function HireCatInfoView:Init()
end

function HireCatInfoView:OnEnter()
	local viewdata = self.viewdata.viewdata
	if(viewdata)then
		local catid = viewdata.catid;
		if(catid)then
			self.catTip = HireCatTip.new("HireCatTip", self.gameObject);
			local data = {
				staticData = Table_MercenaryCat[catid];
			};
			self.catTip:SetData(data);
			self.catTip:ActiveGoButton(false);
			self.catTip:SetCloseCall(self.CloseSelf, self);
		end
	end
end

function HireCatInfoView:OnExit()
	if(self.catTip)then
		self.catTip:OnExit();
	end
	self.catTip = nil;

	HireCatInfoView.super.OnExit(self);
end