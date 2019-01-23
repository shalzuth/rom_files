PackageSetQuickPage = class("PackageSetQuickPage", SubMediatorView);

autoImport("SetQuickItemCell");

function PackageSetQuickPage:Init()
	self:AddViewEvts();
	self:InitUI();
end

function PackageSetQuickPage:InitUI()
	-- 初始化快捷栏
	local quickUseGrid = self:FindComponent("QuickUseGrid", UIGrid);
	self.quickUseItem = {};
	for i=1,5 do
		local obj = self:LoadPreferb("cell/SetQuickItemCell", quickUseGrid.gameObject);
		obj.name = "SetQuickItemCell"..i;
		self.quickUseItem[i] = SetQuickItemCell.new(obj);
		self.quickUseItem[i]:SetQuickPos(i);
		self.quickUseItem[i]:AddEventListener(SetQuickItemCell.SwapObj, self.SetQuickUseItem, self);
	end
	quickUseGrid:Reposition();
end

function PackageSetQuickPage:OnEnter()
	PackageSetQuickPage.super.OnEnter(self);

	self:UpdateQuickUse();
end

function PackageSetQuickPage:SetQuickUseItem(param)
	self.SetQuickUseFunc(param);
end

-- 设置快捷栏快捷键 func
function PackageSetQuickPage.SetQuickUseFunc(param)
	local surcData = param.surce.itemdata;
	local surcPos = param.surce.pos;
	local targetPos = param.target.pos;
	local keys = {};
	local key = {
		guid = surcData.id,
		type = surcData.staticData.id,
		pos = targetPos-1,
	};
	table.insert(keys, key);
	-- 如果surcPos有值 则该值是快捷栏位互换
	if(surcPos)then
		-- 在快捷栏互换情况下 目标快捷栏有数值
		local targetData = param.target.data;
		local targetId, typeId;
		if(targetData)then
			targetId = targetData.id;
			typeId = targetData.staticData.id;
		end
		local key2 = {
			guid = targetId,
			type = typeId,
			pos = surcPos-1,
		};
		table.insert(keys, key2);
	end
	for i=1,#keys do
		ServiceNUserProxy.Instance:CallPutShortcut(keys[i]);
	end
end

-- 快捷栏更新
function PackageSetQuickPage:UpdateQuickUse()
	local quickUseItems = ShortCutProxy.Instance:GetShorCutItem(true);
	for i=1,#self.quickUseItem do
		local cell = self.quickUseItem[i];
		cell:SetData(quickUseItems[i]);
	end
end

function PackageSetQuickPage:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate,self.UpdateQuickUse);
	self:AddListenEvt(ServiceEvent.NUserPutShortcut,self.UpdateQuickUse);
	self:AddListenEvt(MyselfEvent.ResetHpShortCut,self.UpdateQuickUse);
end