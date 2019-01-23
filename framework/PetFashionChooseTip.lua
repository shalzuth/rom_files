autoImport("BaseTip");
PetFashionChooseTip = class("PetFashionChooseTip", BaseTip)

autoImport("WrapListCtrl");
autoImport("PetFashionCell");

function PetFashionChooseTip:Init()
	self.cellContainer = self:FindGO("FashionGrid");
	self.fashionCtl = WrapListCtrl.new(self.cellContainer, PetFashionCell, "PetFashionCell", WrapListCtrl_Dir.Horizontal);
	self.fashionCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);

	self.closeButton = self:FindGO("CloseButton");
	self:AddClickEvent(self.closeButton, function (go)
		self:CloseSelf();
	end);

	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end

	self.preButton = self:FindGO("PreButton");
	self.nextButton = self:FindGO("NextButton");

	self.fashionWrap = self.cellContainer:GetComponent(UIWrapContent);
	self.scroll =self:FindComponent("PetFashionScrollView", UIScrollView);
	self.panel = self.scroll:GetComponent(UIPanel);

	self.scroll.onMomentumMove = function ()
		self:UpdateCenterScreen();
	end
end

function PetFashionChooseTip:UpdateCenterScreen()
	self.preButton:SetActive(false);
	self.nextButton:SetActive(false);

	if(self.hideTipButton)then
		return;
	end

	local x_offset = self.panel.clipOffset.x;

	local itemSize = self.fashionWrap.itemSize;
	local x_max = itemSize * (self.fashionWrap.maxIndex - 1.5);
	local x_min = itemSize * 0.5;
	self.nextButton:SetActive(x_offset <= x_max);
	self.preButton:SetActive(x_offset >= x_min);
end

function PetFashionChooseTip:CloseSelf()
	TipsView.Me():HideCurrent();
end

function PetFashionChooseTip:OnExit()
	if(self.closeCall)then
		self.closeCall(self.closeCallParam);
	end
	PetFashionChooseTip.super.OnExit(self);
	return true;
end

function PetFashionChooseTip:HandleClickItem(cell)
	local data = cell and cell.data;
	if(self.clickCall)then
		self.clickCall(self.clickCallParam, data);
	end
end

function PetFashionChooseTip:SetData(datas)
	self.hideTipButton = #datas <= 2; 

	self.fashionCtl:ResetDatas(datas);

	self:UpdateCenterScreen()
end

function PetFashionChooseTip:SetClickEvent(clickCall, clickCallParam)
	self.clickCall = clickCall;
	self.clickCallParam = clickCallParam;
end

function PetFashionChooseTip:SetCloseCall(closeCall, closeCallParam)
	self.closeCall = closeCall;
	self.closeCallParam = closeCallParam;
end

function PetFashionChooseTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function PetFashionChooseTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end
end