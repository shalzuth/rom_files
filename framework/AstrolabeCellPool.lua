AstrolabeCellPool = class("AstrolabeCellPool");

autoImport("Astrolabe_PointCell");
autoImport("Astrolabe_LineCell");

PointCell_PoolSzie = 100;

AstrolabeCellPool.Instance = nil;

function AstrolabeCellPool:ctor()
	self.pointCellPool = {};
	self.lineCellPool = {};

	self:InitContainer();

	AstrolabeCellPool.Instance = self;
end

function AstrolabeCellPool:InitContainer()
	if(self.container == nil)then
		self.container = GameObject("AstrolabeCellPool");
   		GameObject.DontDestroyOnLoad(self.container);
   		
		self.container = self.container.transform;
	end
end

function AstrolabeCellPool:GetPointCell(parent)
	local pointCell = table.remove(self.pointCellPool, 1);
	if(pointCell == nil)then
		pointCell = Astrolabe_PointCell.new();
	end
	pointCell:OnAdd(parent);

	return pointCell;
end

function AstrolabeCellPool:AddPointCellToPool(pointCell)
	if(pointCell)then
		if( #self.pointCellPool < PointCell_PoolSzie )then
			pointCell:OnRemove();
			self.pointCellPool[ #self.pointCellPool+1 ] = pointCell;
		else
			pointCell:OnDestroy();
		end
	end
end

function AstrolabeCellPool:ClearPointCellPool()
	for i=#self.pointCellPool,1,-1 do
		self.pointCellPool[i]:OnDestroy();
		self.pointCellPool[i] = nil;
	end
end

function AstrolabeCellPool:PrintPointPoolSize()
	helplog("pointCellPool Size:", #self.pointCellPool);
end



function AstrolabeCellPool:GetLineCell(parent)
	local lineCell = table.remove(self.lineCellPool, 1);
	if(lineCell == nil)then
		lineCell = Astrolabe_LineCell.new();
	end
	lineCell:OnAdd(parent);

	return lineCell;
end

function AstrolabeCellPool:AddLineCellToPool(lineCell)
	if(lineCell)then
		if( #self.lineCellPool < PointCell_PoolSzie )then
			lineCell:OnRemove();
			self.lineCellPool[ #self.lineCellPool+1 ] = lineCell;
		else
			lineCell:OnDestroy();
		end
	end
end

function AstrolabeCellPool:ClearLineCellPool()
	for i=#self.lineCellPool,1,-1 do
		self.lineCellPool[i]:OnDestroy();
		self.lineCellPool[i] = nil;
	end
end



function AstrolabeCellPool:AddToTempPool(obj)
	obj.transform:SetParent(self.container, false);
end

