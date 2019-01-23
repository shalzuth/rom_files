WrapCellHelper = class("WrapCellHelper")

autoImport("WrapCombineCell")

local tempV3 = LuaVector3();
local tempV2 = LuaVector2();
-- 父物体 , 实际预设数量, 预设名字 , 控制脚本名字 , 滑动方向（1：竖 2：横）, 当没有填充满view时强制不可滑动
-- params = {wrapObj, pfbNum, control, cellName, ctlName, dir, disableDragIfFit}
function WrapCellHelper:ctor(params)
	self.wrap = params.wrapObj:GetComponent(UIWrapContent);	
	self.control = params.control;
	self.cellName = params.cellName;
	self.pfbNum = params.pfbNum;
	self.eventWhenUpdate = params.eventWhenUpdate;

	self.rowNum = params.rowNum;
	self.colNum = params.colNum;
	self.cellWidth = params.cellWidth;
	self.cellHeight = params.cellHeight;

	self.scrollView = GameObjectUtil.Instance:FindCompInParents(params.wrapObj, UIScrollView);
	self.panel = self.scrollView:GetComponent(UIPanel);
	
	if self.panel.isAnchored then
		local originalAnchor = self.panel.updateAnchors
		self.panel.updateAnchors = 0

		self.panel:ResetAndUpdateAnchors()

		self.panel.updateAnchors = originalAnchor
	end

	local size = self.panel:GetViewSize();
	self.dir = params.dir or 1;
	if(self.dir == 1)then
		if(self.cellHeight)then
			self.wrap.itemSize = self.cellHeight;
		end
		self.viewLength = size.y;
	else
		if(self.cellWidth)then
			self.wrap.itemSize = self.cellWidth;
		end
		self.viewLength = size.x;
	end

	if(not self.pfbNum)then
		local numInt, numPoint = math.modf(self.viewLength/self.wrap.itemSize);
		if(numPoint < 0.5)then
			self.pfbNum = numInt + 1;
		else
			self.pfbNum = numInt + 2;
		end
	end

	if params.disableDragIfFit then
		self.disableDragPfbNum = math.floor(self.viewLength/self.wrap.itemSize)
	end

	self.initParams = {};
	local wrapx, wrapy, wrapz = LuaGameObject.GetLocalPosition(self.wrap.transform);
	self.initParams[1] = LuaVector3(wrapx, wrapy, wrapz);
	local panelx, panely, panelz = LuaGameObject.GetLocalPosition(self.panel.transform);
	self.initParams[2] = LuaVector3(panelx, panely, panelz);
	local clipOffset = self.panel.clipOffset;
	self.initParams[3] = LuaVector2(clipOffset[1], clipOffset[2]);

	self.ctls = {};
	self.datas = {};

	self:LoadAllPfb();
	-- self:InitPreferb();

	local updatefunc = function (obj,wrapI,realI)
		local index = math.abs(realI)+1;
		if (self.ctls[wrapI]) then
			self.ctls[wrapI]:SetData(self.datas[index]);
			
			if(self.eventWhenUpdate~=nil)then
				self.eventWhenUpdate();
			end
		end
	end
	self.wrap.onInitializeItem = updatefunc;
end

function WrapCellHelper:InitPreferb()
	local num = self.pfbNum;
	local p_num, c_num = 0,0;
	if(self.dir == 1)then
 		p_num = self.colNum or 0;
 		c_num = self.rowNum or 0;
	elseif(self.dir == 2)then
		p_num = self.rowNum or 0;
		c_num = self.colNum or 0;
	end
	for i=1,p_num do
		local wrapCombineCell_go = self:LoadCellPfb("WrapCombineCell"..i);
		local wrapCombineCell = WrapCombineCell.new(wrapCombineCell_go);
		wrapCombineCell:InitCells(c_num, self.cellName, self.control);
		wrapCombineCell:Reposition(self.cellWidth, self.cellHeight);
		self.ctls[i] = wrapCombineCell;
	end
end

function WrapCellHelper:LoadCellPfb(cName)
	local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(self.cellName));
	if(cellpfb == nil) then
		error ("can not find cellpfb"..cellName);
	end
	cellpfb.transform:SetParent(self.wrap.transform,false);
	cellpfb.name = cName;
	return cellpfb;
end

function WrapCellHelper:LoadAllPfb(pfbNum)
	local pnum = pfbNum or self.pfbNum;
	for i=1,pnum do
		local index = i-1;
		local cellGo = self:LoadCellPfb(self.cellName..index);
		local cell = self.control.new(cellGo);
		self.ctls[index] = cell;
	end

	self.wrap:SortAlphabetically();
end

function WrapCellHelper:ResetWrapParama()
	self.realnum = math.max(self.pfbNum, #self.datas);
	local min = self.dir == 1 and 1-self.realnum or 0;
	local max = self.dir == 1 and 0 or self.realnum-1;
	self.wrap.minIndex = min;
	self.wrap.maxIndex = max;
end

function WrapCellHelper:ResetPosition()
	self.wrap:SortBasedOnScrollMovement();

	self:SetStartPositionByIndex(1);

	if self.disableDragPfbNum ~= nil and self.scrollView.enabled == false then
		self.scrollView.enabled = true
		self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero;
		self.scrollView:ResetPosition()
		self.scrollView.enabled = false
	else
		self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero;
		self.scrollView:ResetPosition()
	end
end

function WrapCellHelper:SetStartPositionByIndex(index)
	self.scrollView:DisableSpring();
	
	self.wrap.transform.localPosition = self.initParams[1];

	local itemSize = self.wrap.itemSize;

	index = index - 1;
	local maxNum = self.realnum or self.pfbNum;
	local snum = math.ceil(self.viewLength/itemSize)
	index = math.clamp(index, 0, maxNum - snum + 1);

	local offset = itemSize * index;
	if(self.dir == 1)then
		local panelInitPos = self.initParams[2];
		tempV3:Set(panelInitPos[1], panelInitPos[2] + offset, panelInitPos[3]);
		self.panel.transform.localPosition = tempV3;
		local panelInitClipOffset = self.initParams[3];
		tempV2:Set(panelInitClipOffset[1], panelInitClipOffset[2] - offset);
		self.panel.clipOffset = tempV2;
	end
end

function WrapCellHelper:ResetDatas(datas)
	self:UpdateInfo(datas);
end

function WrapCellHelper:UpdateInfo(datas)
	self.datas = datas;
	self:ResetWrapParama();

	-- ReInit
	for index,cell in pairs(self.ctls) do
		cell:SetData(datas[index+1]);
	end
	self.wrap.mFirstTime = true;
	self.wrap:WrapContent();
	self.wrap.mFirstTime = false;

	if self.disableDragPfbNum then
		self.scrollView.enabled = #datas > self.disableDragPfbNum
	end
end

function WrapCellHelper:InsertData(data, index)
	if(nil == index)then
		index = #self.datas + 1;
	end
	table.insert(self.datas, index, data);
	self:ResetWrapParama();
end

function WrapCellHelper:GetCellCtls()
	local result = {};
	for i=0,#self.ctls do
		table.insert(result, self.ctls[i]);
	end
	return result;
end

function WrapCellHelper:GetDatas()
	return self.datas;
end

function WrapCellHelper:AddEventListener(eventType, handler, handlerOwner)
	for k,v in pairs(self.ctls) do
		if(v~=nil)then
			v:AddEventListener(eventType, handler, handlerOwner);
		end
	end
end