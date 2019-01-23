EquipChooseTip = class("EquipChooseTip", BaseTip)

autoImport("EquipChooseCell");

function EquipChooseTip:ctor(prefabName, stick, side, offset)
	BubbleTip.super.ctor(self, prefabName, stick.gameObject);
	self.side = side or NGUIUtil.AnchorSide.Top;
	self.offset = offset;

	self:Init();
end

function EquipChooseTip:Init()
	local grid = self:FindComponent("ItemGrid", UIGrid);
	self.chooseCtl = UIGridListCtrl.new(grid, EquipChooseCell, "EquipChooseShortCell");
	self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
	-- self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.ClickItemIcon, self)

	self.title = self:FindComponent("Title", UILabel);
	self.closeButton = self:FindGO("CloseButton");
	self:AddClickEvent(self.closeButton, function (go)
		self:CloseSelf();
	end);

	self.noneTip = self:FindGO("NoneTip");
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
	
	--todo xde
	local l = self:FindGO("Label",self.noneTip):GetComponent(UILabel)
	OverseaHostHelper:FixLabelOverV1(l,3,200)
end

function EquipChooseTip:CloseSelf()
	TipsView.Me():HideCurrent();
end

function EquipChooseTip:OnExit()
	if(self.closeCall)then
		self.closeCall(self.closeCallParam);
	end
	return true;
end

function EquipChooseTip:HandleClickItem(cellCtl)
	local data = cellCtl and cellCtl.data;
	if(self.clickCall)then
		self.clickCall(self.clickCallParam, data);
	end

	self:SetChooseId(data.id);
end

function EquipChooseTip:SetChooseId(id)
	local cells = self.chooseCtl:GetCells();
	for i=1,#cells do
		cells[i]:SetChooseId(id);
	end
end

function EquipChooseTip:SetClickEvent(clickCall, clickCallParam)
	self.clickCall = clickCall;
	self.clickCallParam = clickCallParam;
end

function EquipChooseTip:SetData(datas)
	self.chooseCtl:ResetDatas(datas);
	self.noneTip:SetActive(#datas == 0);
end

function EquipChooseTip:Set_CheckValidFunc(checkFunc, checkFuncParam)
	local cells = self.chooseCtl:GetCells()
	for i=1,#cells do
		cells[i]:Set_CheckValidFunc(checkFunc, checkFuncParam);
	end
end

function EquipChooseTip:SetCloseCall(closeCall, closeCallParam)
	self.closeCall = closeCall;
	self.closeCallParam = closeCallParam;
end

function EquipChooseTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function EquipChooseTip:DestroySelf()
	GameObject.Destroy(self.gameObject)
end