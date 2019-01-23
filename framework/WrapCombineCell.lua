local baseCell = autoImport("BaseCell");
WrapCombineCell = class("WrapCombineCell", baseCell);

function WrapCombineCell:Init()
end

function WrapCombineCell:InitCells(childNum, cellName, control)
	if(not self.childCells)then
		self.childCells = {};
	else
		TableUtility.ArrayClear(self.childCells);
	end

	local rid = ResourcePathHelper.UICell(cellName)
	for i=1, childNum do
		local go = Game.AssetManager_UI:CreateAsset(rid, self.gameObject);
		go.name = "child"..i;
		table.insert(self.childCells, control.new(go));
	end
	self:Reposition();
end

function WrapCombineCell:Reposition(dir, interval)
	if(not self.grid)then
		self.grid = self.gameObject:GetComponent(UIGrid);
	end
	if(not self.grid)then
		return;
	end
	
	if(dir == WrapListCtrl_Dir.Vertical)then
		self.grid.cellWidth = interval;
		self.grid.maxPerLine = 0;
	elseif(dir == WrapListCtrl_Dir.Horizontal)then
		self.grid.cellHeight = interval;
		self.grid.maxPerLine = 1;
	end

	self.grid:Reposition();
end

function WrapCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for k,v in pairs(self.childCells)do
		v:AddEventListener(eventType, handler, handlerOwner);
	end
end

function WrapCombineCell:SetData(data)
	if(not self.childCells)then
		return;
	end

	self.data = data;
	for i = 1,#self.childCells do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childCells[i]
		cell:SetData(cData)
	end
end

function WrapCombineCell:GetDataByChildIndex(index)
	if(self.data)then
		return self.data[index];
	end
end

function WrapCombineCell:GetCells()
	return self.childCells;
end