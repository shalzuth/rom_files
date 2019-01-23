autoImport("EventDispatcher")
WrapListCtrl = class("WrapListCtrl", EventDispatcher)

WrapListCtrl_Dir = 
{
	Vertical = 1,
	Horizontal = 2,
}

autoImport("WrapCombineCell")

local tempV3 = LuaVector3();
local tempV2 = LuaVector2();

-- 父物体 , 控制类, 预设名字 , 滑动方向（1：竖 2：横）, 每行的子cell数量 , 子cell的间隔 , 当没有填充满view时强制不可滑动
function WrapListCtrl:ctor(container, control, prefabName, dir, childNum, childInterval, disableDragIfFit)
	self.container = container.transform;
	self.wrap = container:GetComponent(UIWrapContent);

	self.prefabName = prefabName;
	self.control = control;
	self.dir = dir or WrapListCtrl_Dir.Vertical;
	
	self.scrollView = GameObjectUtil.Instance:FindCompInParents(container, UIScrollView);
	self.panel = self.scrollView:GetComponent(UIPanel);
	self.viewLength = nil;
	local size = self.panel:GetViewSize();
	if(self.dir == WrapListCtrl_Dir.Vertical)then
		self.viewLength = size.y;
	else
		self.viewLength = size.x;
	end
	if self.panel.isAnchored then
		local originalAnchor = self.panel.updateAnchors
		self.panel.updateAnchors = 0

		self.panel:ResetAndUpdateAnchors()

		self.panel.updateAnchors = originalAnchor
	end
	local numInt, numPoint = math.modf(self.viewLength/self.wrap.itemSize);
	self.cellNum = numInt + 2;
	-- if(numPoint < 0.5)then
	-- 	self.cellNum = numInt + 2;
	-- else
	-- 	self.cellNum = numInt + 1;
	-- end

	self.cellChildNum = childNum or 1;
	self.cellChildInterval = childInterval or 0;

	if disableDragIfFit then
		self.disableDragPfbNum = math.floor(self.viewLength/self.wrap.itemSize)
	end

	self.initParams = {};
	local wrapx, wrapy, wrapz = LuaGameObject.GetLocalPosition(self.container);
	self.initParams[1] = LuaVector3(wrapx, wrapy, wrapz);
	local panelx, panely, panelz = LuaGameObject.GetLocalPosition(self.panel.transform);
	self.initParams[2] = LuaVector3(panelx, panely, panelz);
	local clipOffset = self.panel.clipOffset;
	self.initParams[3] = LuaVector2(clipOffset[1], clipOffset[2]);

	self.ctls = {};
	self.datas = {};

	self:InitPreferb();

	local updatefunc = function (obj,wrapI,realI)
		local index = math.abs(realI)+1;
		if (self.ctls[wrapI]) then
			self.ctls[wrapI]:SetData(self.datas[index]);
			
			if(self.updateCall~=nil)then
				self.updateCall(self.updateCallParam);
			end
		end
	end
	self.wrap.onInitializeItem = updatefunc;

	self.pos_reseted = false;
end

function WrapListCtrl:InitPreferb()
	local p_num, c_num = self.cellNum, self.cellChildNum;
	for i=1, p_num do
		local index = i-1;
		local wrapCombineCell_go = self:LoadCellPfb("WrapCombineCell"..index);
		local wrapCombineCell = WrapCombineCell.new(wrapCombineCell_go);
		wrapCombineCell:InitCells(c_num, self.prefabName, self.control);
		wrapCombineCell:Reposition(self.dir, self.cellChildInterval);
		self.ctls[index] = wrapCombineCell;
	end

	self.cellsList_dirty = true;

	self.wrap:SortAlphabetically();
end

function WrapListCtrl:LoadCellPfb(cName)
	local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("WrapCombineCell"));
	if(cellpfb == nil) then
		error ("can not find cellpfb"..cellName);
	end
	cellpfb.transform:SetParent(self.container, false);
	cellpfb.name = cName;
	return cellpfb;
end

function WrapListCtrl:ResetWrapParama()
	self.realnum = math.max(self.cellNum, #self.datas);
	local min = self.dir == WrapListCtrl_Dir.Vertical and 1-self.realnum or 0;
	local max = self.dir == WrapListCtrl_Dir.Vertical and 0 or self.realnum-1;
	self.wrap.minIndex = min;
	self.wrap.maxIndex = max;
end

function WrapListCtrl:ResetPosition()
	self.wrap:SortBasedOnScrollMovement();

	self:SetStartPositionByIndex(1);

	if self.disableDragPfbNum ~= nil and self.scrollView.enabled == false then
		self.scrollView.enabled = true
		self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero;
		self.scrollView:ResetPosition()
		self.scrollView.enabled = false
		return;
	end
	self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero;
	self.scrollView:ResetPosition()

	self.pos_reseted = true;
end

function WrapListCtrl:SetStartPositionByIndex(index)
	self.scrollView:DisableSpring();
	
	self.container.localPosition = self.initParams[1];

	local itemSize = self.wrap.itemSize;

	index = index - 1;
	local maxNum = self.realnum or self.cellNum;
	local snum = math.ceil(self.viewLength/itemSize)
	index = math.clamp(index, 0, maxNum - snum + 1);

	local offset = itemSize * index;
	if(self.dir == WrapListCtrl_Dir.Vertical)then
		local panelInitPos = self.initParams[2];
		tempV3:Set(panelInitPos[1], panelInitPos[2] + offset, panelInitPos[3]);
		self.panel.transform.localPosition = tempV3;
		local panelInitClipOffset = self.initParams[3];
		tempV2:Set(panelInitClipOffset[1], panelInitClipOffset[2] - offset);
		self.panel.clipOffset = tempV2;
	end
end

function WrapListCtrl:ReUnitData(datas, cellNum)
	local unitData = {};
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/cellNum)+1;
			local i2 = math.floor((i-1)%cellNum)+1;
			unitData[i1] = unitData[i1] or {};
			if(datas[i] == nil)then
				unitData[i1][i2] = nil;
			else
				unitData[i1][i2] = datas[i];
			end
		end
	end
	return unitData;
end

function WrapListCtrl:ResetDatas(datas, isLayOut)
	self.datas = self:ReUnitData(datas, self.cellChildNum);
	self:ResetWrapParama();
	-- ReInit
	for index,cell in pairs(self.ctls) do
		cell:SetData(self.datas[index+1]);
	end
	self.wrap.mFirstTime = true;
	self.wrap:WrapContent();
	self.wrap.mFirstTime = false;

	if self.disableDragPfbNum then
		self.scrollView.enabled = #datas > self.disableDragPfbNum
	end

	
	if(isLayOut or not self.pos_reseted)then
		self:ResetPosition();
	end
end

function WrapListCtrl:InsertData(data, index)
	if(nil == index)then
		index = #self.datas + 1;
	end
	table.insert(self.datas, index, data);
	self:ResetWrapParama();
end

function WrapListCtrl:GetCells()
	if(self.cellsList_dirty == false)then
		return self.cellsList;
	end

	self.cellsList_dirty = false;

	if(self.cellsList == nil)then
		self.cellsList = {};
	else
		TableUtility.ArrayClear(self.cellsList);
	end

	for i=0,#self.ctls do
		local cells = self.ctls[i]:GetCells();
		for j=1,#cells do
			table.insert(self.cellsList, cells[j]);
		end
	end

	return self.cellsList;
end

function WrapListCtrl:GetDatas()
	return self.datas;
end

function WrapListCtrl:AddEventListener(eventType,handler,handlerOwner)
	for k,v in pairs(self.ctls) do
		if(v~=nil)then
			v:AddEventListener(eventType, handler, handlerOwner);
		end
	end
end

function WrapListCtrl:Destroy()
	local cells = self:GetCells();
	if(cells)then
		for i=1,#cells do
			if(cells[i].OnRemove)then
				cells[i]:OnRemove();
			end
		end
	end
end