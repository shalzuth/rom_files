MiniMapData = reusableClass("MiniMapData");

MiniMapData.PoolSize = 50;

function MiniMapData:SetPos(x, y, z)
	if(not self.pos)then
		self.pos = LuaVector3();
	end
	self.pos:Set(x, y, z);
end

function MiniMapData:SetParama( key, value )
	if(not key)then
		return;
	end

	if(not self._parama)then
		self._parama = {};
	end
	self._parama[key] = value;
end

function MiniMapData:GetParama( key )
	if(self._parama)then
		return self._parama[key];
	end
end

-- override begin
function MiniMapData:DoConstruct(asArray, id)
	self.id = id;
end

function MiniMapData:DoDeconstruct(asArray)
	self.id = nil;
	if(self.pos) then
		self.pos:Destroy()
	end
	self.pos = nil;
	if(self._parama)then
		TableUtility.TableClear(self._parama);
	end
end
-- override end
