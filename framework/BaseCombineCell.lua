local baseCell = autoImport("BaseCell");
BaseCombineCell = class("BaseCombineCell", baseCell);

function BaseCombineCell:Init()
end

function BaseCombineCell:InitCells(childNum, cellName, control)
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

function BaseCombineCell:Reposition()
	self.gameObject:GetComponent(UIGrid):Reposition();
end

function BaseCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for k,v in pairs(self.childCells)do
		v:AddEventListener(eventType, handler, handlerOwner);
	end
end

function BaseCombineCell:SetData(data)
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

function BaseCombineCell:GetDataByChildIndex(index)
	if(self.data)then
		return self.data[index];
	end
end


function BaseCombineCell:GetCells()
	return self.childCells;
end