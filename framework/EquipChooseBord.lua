EquipChooseBord = class("EquipChooseBord",CoreView)

autoImport("EquipChooseCell");

EquipChooseBord.PfbPath = "part/EquipChooseBord";

EquipChooseBord.ChooseItem = "EquipChooseBord_ChooseItem";

function EquipChooseBord:ctor(parent, getDataFunc)
	self.gameObject_Parent = parent;
	self.gameObject = self:LoadPreferb(EquipChooseBord.PfbPath, parent);
	self.gameObject.transform.localPosition = LuaGeometry.Const_V3_one;
	self:InitDepth();
	
	self.getDataFunc = getDataFunc;

	self.title = self:FindComponent("Title", UILabel);
	self.noneTip = self:FindGO("NoneTip");
	local wrapContent = self:FindGO("ChooseGrid");
	local wrapConfig = {
		wrapObj = wrapContent, 
		pfbNum = 6, 
		cellName = "EquipChooseCell", 
		control = EquipChooseCell, 
		dir = 1,
	}
	self.chooseCtl = WrapCellHelper.new(wrapConfig);
	self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);
	self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.ClickItemIcon, self);

	self:AddButtonEvent("CloseButton", function ()
		self:Hide();
	end);
end

function EquipChooseBord:InitDepth()
	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject_Parent, UIPanel, false);
	local panels = self:FindComponents(UIPanel);
	for i=1,#panels do
		panels[i].depth = upPanel.depth + panels[i].depth;
	end
end

function EquipChooseBord:ClickItemIcon(cellctl)
	local data = cellctl and cellctl.data;
	local go = cellctl and cellctl.itemIcon;
	local newClickId = data and data.staticData.id or 0;
	if(self.clickId~=newClickId)then
		self.clickId = newClickId;
		local callback = function () 
			self.clickId = 0 
		end
		local sdata = {
			itemdata = data,
			funcConfig = {},
			ignoreBounds = {go},
			hideGetPath = true,
			callback = callback,
		};
		local stick = go:GetComponent(UIWidget);
		self:ShowItemTip(sdata, stick, nil, {200,-200});
	else
		self:ShowItemTip();
		self.clickId = 0;
	end
end

function EquipChooseBord:HandleClickItem(cellctl)
	local data = cellctl and cellctl.data;
	self:SetChoose(data);
	self:PassEvent(EquipChooseBord.ChooseItem, data);
	
	if(self.chooseCall)then
		self.chooseCall(self.chooseCallParam, data);
	end
end

function EquipChooseBord:SetChoose(data)
	local go = cellctl and cellctl.gameObject;
	local newChooseId = data and data.id or 0;
	if(self.chooseId~=newChooseId)then
		self.chooseId = newChooseId;
	end
	local cells = self.chooseCtl:GetCellCtls();
	for _,cell in pairs(cells) do
		cell:SetChooseId(self.chooseId);
	end
end

function EquipChooseBord:ResetDatas(datas, resetPos)
	if(resetPos)then
		self.chooseCtl:ResetPosition();
	end

	self.datas = datas;
	self.chooseCtl:UpdateInfo(datas);
	self.noneTip:SetActive(#datas==0);
end

function EquipChooseBord:UpdateChooseInfo(datas)
	if(not datas and self.getDataFunc)then
		datas = self.getDataFunc();
	end
	datas = datas or {};
	self:ResetDatas(datas);
end

function EquipChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip)
	if(updateInfo)then
		self:UpdateChooseInfo();
	end
	self.gameObject:SetActive(true);

	self:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip);

	self.chooseCall = chooseCall;
	self.chooseCallParam = chooseCallParam;
end

function EquipChooseBord:Hide()
	TipManager.Instance:CloseTip()
	self.gameObject:SetActive(false);

	if(self.chooseCall)then
		self.chooseCall = nil;
	end
	if(self.chooseCallParam)then
		self.chooseCallParam = nil;
	end
	if(self.hideCall)then
		self.hideCall();
	end

	self.checkFunc = nil;
	self.checkTip = nil;
end

function EquipChooseBord:SetHideCall(hideCall)
	self.hideCall = hideCall;
end

function EquipChooseBord:ActiveSelf()
	return self.gameObject.activeSelf;
end



------------------------------------------------

function EquipChooseBord:SetBordTitle(text)
	self.title.text = text;
end

function EquipChooseBord:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
	local cells = self.chooseCtl:GetCellCtls();
	for i=1,#cells do
		cells[i]:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip);
	end
end











