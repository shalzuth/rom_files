local BaseCell = autoImport("BaseCell");
Astrolabe_PlateCell = class("Astrolabe_PlateCell", BaseCell);

autoImport("Astrolabe_PointCell");

Astrolabe_PlateCell.Prefab_Path = ResourcePathHelper.UICell("Astrolabe_PlateCell");
Astrolabe_PlateCell.Line_Path = ResourcePathHelper.UICell("Astrolabe_line");

Astrolabe_PlateCell_Event = {
	ClickPoint = "Astrolabe_PlateCell_Event_ClickPoint",
}

Astrolabe_Plate_Bg = {
	[0] = "",
	[1] = "xingpan_polygon_small",
	[2] = "xingpan_polygon_mid",
	[3] = "xingpan_polygon_big",
}

local tempV3_1, tempV3_2 = LuaVector3(), LuaVector3();
local tempRot = LuaQuaternion();
function Astrolabe_PlateCell:Init()
	self.pointMap = {};
	self.lineMap = {};

	self.texture = self.gameObject:GetComponent(UITexture);

	self.PlateId = self:FindComponent("PlateId", UILabel);
	self.PlateId.gameObject:SetActive(ApplicationInfo.IsRunOnEditor());
end

function Astrolabe_PlateCell:SetData(data, priStateMap, bordData)
	if(self.data ~= data)then
		self.data = data;
		self.bordData = bordData;
		self.plate = bordData:GetPlateMap();
		self:ReDraw();
	end

	if(self.data)then
		local pointDataMap = data:GetPointMap();

		for id, cell in pairs(self.pointMap)do
			self:UpdatePoint(id, priStateMap, bordData);
		end

		self.PlateId.text = self.data.id;
	end
end

function Astrolabe_PlateCell:Refresh()
	if(self.data)then
		self:SetData(self.data, nil, self.bordData);
	end
end

function Astrolabe_PlateCell:ClearCellMap()
	for id, cell in pairs(self.pointMap)do
		cell:RemoveEventListener(Astrolabe_PlateData_Event.ClickPoint, self.ClickPoint, self);
		AstrolabeCellPool.Instance:AddPointCellToPool(cell);
		self.pointMap[id] = nil;
	end
end

function Astrolabe_PlateCell.DeleteLine(lineCell)
	AstrolabeCellPool.Instance:AddLineCellToPool(lineCell)
end

function Astrolabe_PlateCell:ClearLines()
	TableUtility.TableClearByDeleter(self.lineMap, Astrolabe_PlateCell.DeleteLine);
end

function Astrolabe_PlateCell:ReDraw()
	self:ClearCellMap();
	self:ClearLines();

	local data = self.data;
	local pointMap = data:GetPointMap();
	for _, pointData in pairs(pointMap)do
		local pointCell = AstrolabeCellPool.Instance:GetPointCell(self.gameObject);
		pointCell:AddEventListener(Astrolabe_PlateData_Event.ClickPoint, self.ClickPoint, self);

		self.pointMap[pointData.id] = pointCell;

		local innerConnect = pointData:GetInnerConnect();
		for i=1,#innerConnect do
			local connectId = innerConnect[i];
			if(pointMap[connectId])then
				self:GetInnerline(pointData, pointMap[connectId], false);
			end
		end
	end

	self.gameObject.name = "Plate_" ..  data.id;

	tempV3_1:Set( data:GetPos_XYZ() );
	self.gameObject.transform.localPosition = tempV3_1;

	local plateWidth = data.plateWidth;
	if(plateWidth == 0)then
		self.texture.enabled = false;
	else
		self.texture.enabled = true;
		local name = Astrolabe_Plate_Bg[ plateWidth ];
		PictureManager.Instance:SetUI(name, self.texture);
		self.texture:MakePixelPerfect();
	end
end

function Astrolabe_PlateCell:ClickPoint(pointCell)
	self:PassEvent(Astrolabe_PlateCell_Event.ClickPoint, {self, pointCell});
end

function Astrolabe_PlateCell:UpdatePoint(pointid, priStateMap, bordData)
	if(self.data == nil)then
		return;
	end

	local pointMap = self.data:GetPointMap();

	local pointData = pointMap[pointid];

	local cell = self.pointMap[pointData.id];
	if(cell)then
		cell:SetData(pointData, priStateMap, bordData);
	end

	local innerConnect = pointData:GetInnerConnect();
	for i=1,#innerConnect do
		local pointData2 = pointMap[innerConnect[i]];
		local lineCell = self:GetInnerline(pointData, pointData2);
		lineCell:SetData(pointData, pointData2, priStateMap);

		local pointCell2 = self.pointMap[ pointData2.id ];
		pointCell2:SetData(pointData2, priStateMap, bordData);
	end
end

function Astrolabe_PlateCell:GetInnerline(point1, point2, noCreate)
	local lpoint, bpoint;
	if(point1.id < point2.id)then
		lpoint = point1;
		bpoint = point2;
	else
		lpoint = point2;
		bpoint = point1;
	end

	local cid = lpoint.id .. "_" .. bpoint.id;
	
	local lineCell = self.lineMap[cid];
	if(noCreate ~= true and lineCell == nil)then
		lineCell = AstrolabeCellPool.Instance:GetLineCell(self.gameObject);

		local x1,y1,z1 = lpoint:GetLocalPos_XYZ();
		local x2,y2,z2 = bpoint:GetLocalPos_XYZ();
		lineCell:ReSetPos(x1,y1,z1, x2,y2,z2);

		self.lineMap[cid] = lineCell;
	end
	return lineCell
end

function Astrolabe_PlateCell:ActiveAttriInfo(b)
	for id,pointCell in pairs(self.pointMap)do
		pointCell:ActiveAttriInfo(b);
	end
end

function Astrolabe_PlateCell:GetPointCellById(id)
	return self.pointMap[id];
end

function Astrolabe_PlateCell:SetMaskInfo(maskidMap)
	for _,pointCell in pairs(self.pointMap)do
		local guid = pointCell.data.guid;
		if(maskidMap[guid])then
			pointCell:SetMaskType(maskidMap[guid]);		
		else
			pointCell:RemoveMask(nil);		
		end
	end
	local p1_mtype, p2_mtype;
	for cid,lineCell in pairs(self.lineMap)do
		if(lineCell.point1 == nil)then
			helplog("SetMaskInfo Error", cid, self.data.id);
		end
		p1_mtype = maskidMap[ lineCell.point1.guid ];
		p2_mtype = maskidMap[ lineCell.point2.guid ];
		if(p1_mtype and p2_mtype)then
			lineCell:SetMaskType( math.min(p1_mtype, p2_mtype) );
		else
			lineCell:RemoveMask(nil);		
		end
	end
end

function Astrolabe_PlateCell:OnCreate()
	self:Show();
end

function Astrolabe_PlateCell:OnDestroy()
	self:ClearCellMap();
	self:ClearLines();

	self:Hide();
	self.data = nil;
	self.plate = nil;
	self.bordData = nil;
end
