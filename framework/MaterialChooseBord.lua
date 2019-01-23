MaterialChooseBord = class("MaterialChooseBord",CoreView)

autoImport("MaterialChooseCombineCell");

MaterialChooseBord.PfbPath = "part/MaterialChooseBord";

MaterialChooseBord.ChooseItem = "MaterialChooseBord_ChooseItem";

local temVector3 = LuaVector3.zero
function MaterialChooseBord:ctor(parent, getDataFunc)
	self.gameObject_Parent = parent;

	self.gameObject = self:LoadPreferb(MaterialChooseBord.PfbPath, parent);
	temVector3:Set(300,0,0)
	self.gameObject.transform.localPosition = temVector3;
	self:InitDepth();

	-- local itemContainer = self:FindGO("bag_itemContainer");

	self.getDataFunc = getDataFunc;

	self.title = self:FindComponent("Title", UILabel);
	self.noneTip = self:FindGO("NoneTip");
	local wrapContent = self:FindGO("ChooseGrid");
	local wrapConfig = {
		wrapObj = wrapContent, 
		pfbNum = 4, 
		cellName = "AdventureBagCombineItemCell", 
		control = MaterialChooseCombineCell, 
		dir = 1,
	}
	self.chooseCtl = WrapCellHelper.new(wrapConfig);		
	self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.ClickEvent, self)
	self.chooseCtl:AddEventListener(MaterialChooseCellEvent.LongPress, self.LongPressEvent, self)
	self.chooseCtl:ResetPosition();
	self:AddButtonEvent("ConfirmBtn", function ()
		local bagType = BagProxy.BagType.MainBag
		local chooseDatas = {};
		for i=1,#self.chooseIds do
			local data = BagProxy.Instance:GetItemByGuid(self.chooseIds[i])
			table.insert(chooseDatas, data)
		end
		if(self.chooseCall)then
			self.chooseCall(self.chooseCallParam, chooseDatas);
		end
	end);

	self:AddButtonEvent("CancelBtn", function ()
		self:Hide();
	end);
end

function MaterialChooseBord:InitDepth()
	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject_Parent, UIPanel);
	local panels = self:FindComponents(UIPanel);
	for i=1,#panels do
		panels[i].depth = upPanel.depth + panels[i].depth;
	end
end

function MaterialChooseBord:LongPressEvent(cellctl)

	local data = cellctl and cellctl.data;
	local go = cellctl and cellctl.chooseSymbol;
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

function MaterialChooseBord:ClickEvent(cellctl)	
	if(cellctl and cellctl.data )then
		local id = cellctl.data.id
		local find = false
		for i=1,#self.chooseIds do
			if(id == self.chooseIds[i])then
				table.remove(self.chooseIds,i)
				find = true
				break
			end
		end
		if(not find)then
			if(self.totalNum <= #self.chooseIds)then
				MsgManager.ShowMsgByIDTable(244)
				return
			elseif(self.checkFunc and not self.checkFunc(self.checkFuncParam, cellctl.data))then
				MsgManager.FloatMsg(nil,self.checkTip)
				return
			else
				table.insert(self.chooseIds,id)
			end
		end
		self:UpdateChooseUI()
	end
end

function MaterialChooseBord:CheckHasRfLvOrEc(data)
	local refinelv = data.equipInfo.refinelv or 0;
	local hasEc = false
	if(data.enchantInfo)then
		local attrs = data.enchantInfo:GetEnchantAttrs();
		if(#attrs > 0)then
			hasEc = true
		end
	end 
	return refinelv > 0 or hasEc
end

function MaterialChooseBord:SetTotalNum(num)
	self.totalNum = num
end

function MaterialChooseBord:GetItemCells()
	local combineCells = self.chooseCtl:GetCellCtls();
	local result = {};
	for i=1,#combineCells do
		local v = combineCells[i];
		local childs = v:GetCells();
		for i=1,#childs do
			table.insert(result, childs[i]);
		end
	end
	return result;
end

function MaterialChooseBord:UpdateChooseUI()
	local cells = self:GetItemCells();
	
	for _,cell in pairs(cells) do
		cell:SetChooseIds(self.chooseIds);
	end
	self:SetBordTitle()
end

function MaterialChooseBord:ReUnitData(datas, rowNum)
	if(not self.unitData)then
		self.unitData = {};
	else
		TableUtility.ArrayClear(self.unitData);
	end

	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/rowNum)+1;
			local i2 = math.floor((i-1)%rowNum)+1;
			self.unitData[i1] = self.unitData[i1] or {};
			if(datas[i] == nil)then
				self.unitData[i1][i2] = nil;
			else
				self.unitData[i1][i2] = datas[i];
			end
		end
	end
	return self.unitData;
end

function MaterialChooseBord:SetChoose(datas)
	self.chooseIds = {}
	if(datas)then
		for i=1,#datas do
			table.insert(self.chooseIds,datas[i])
		end
	end
	self:UpdateChooseUI()
end

function MaterialChooseBord:ResetDatas(datas,resetPos)
	self.datas = datas
	if(resetPos)then
		self.chooseCtl:ResetPosition();
	end

	local newdata = self:ReUnitData(datas, 4);
	self.chooseCtl:UpdateInfo(newdata);
	-- self.noneTip:SetActive(#datas==0);
end

function MaterialChooseBord:UpdateChooseInfo(datas)
	if(not datas and self.getDataFunc)then
		datas = self.getDataFunc();
	end
	datas = datas or {};
	self:ResetDatas(datas);
end

function MaterialChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip)
	if(updateInfo)then
		self:UpdateChooseUI();
	end
	self.gameObject:SetActive(true);

	self:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip);

	self.chooseCall = chooseCall;
	self.chooseCallParam = chooseCallParam;
end

function MaterialChooseBord:Hide()
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

function MaterialChooseBord:SetHideCall(hideCall)
	self.hideCall = hideCall;
end

function MaterialChooseBord:ActiveSelf()
	return self.gameObject.activeSelf;
end

------------------------------------------------

function MaterialChooseBord:SetBordTitle()
	if(self.totalNum)then
		local curNum = #self.chooseIds.."/"..self.totalNum
		local text = string.format(ZhString.EquipRefinePage_ChooseMaterialTip,curNum)
		self.title.text = text;
	end
end

function MaterialChooseBord:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
	self.checkFunc = checkFunc;
	self.checkFuncParam = checkFuncParam;
	self.checkTip = checkTip;
end