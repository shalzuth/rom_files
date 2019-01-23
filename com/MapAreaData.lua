MapAreaData = class("MapAreaData")

function MapAreaData:ctor(mapid)
	self.mapid = mapid;
	self:InitData();
end

function MapAreaData:InitData()
	if(self.mapid)then
		self.staticData = Table_Map[self.mapid];
		if(self.staticData == nil)then
			helplog("MapAreaData Init Failure!!!");
		end
		if(self.staticData)then
			-- 在大地图的位置
			self.pos = {};
			self.pos.x = self.staticData.Position and self.staticData.Position[1];
			self.pos.y = self.staticData.Position and self.staticData.Position[2];
		end

		-- 子地图
		self.childMaps = {};
		for k,data in pairs(Table_Map)do
			if(data)then
				if(data.MapArea and data.ShowInList == 1 and data.MapArea == self.mapid)then
					table.insert(self.childMaps, data);
				end
			end
		end
	end
end

function MapAreaData:GetPos()
	return self.pos;
end

function MapAreaData:SetActive(b)
	self.isactive = b;
end

function MapAreaData:SetIsNew(isNew)
	self.isNew = isNew;
end