SealItem = class("SealItem")

function SealItem:ctor(serverData, mapid)
	self:SetData(serverData, mapid);
end

function SealItem:SetData(serverData, mapid)
	if(serverData)then
		self.id = serverData.sealid;
		self.mapid = mapid;
		self.config = serverData.config;
		self.refreshtime = serverData.refreshtime;

		local pos = serverData.pos;
		if(not self.pos)then
			self.pos = LuaVector3();
		end
		self.pos:Set(pos.x/1000, pos.y/1000, pos.z/1000);
		self.ownseal = serverData.ownseal;
		self.issealing = serverData.issealing;
		
		-- SceneSeal_pb.ESEALTYPE_NORMAL
		-- SceneSeal_pb.ESEALTYPE_PERSONAL
		-- SceneSeal_pb.ESEALTYPE_ACTIVITY
		self.etype = serverData.etype;

		local updateStr = string.format("SealItem: |id:%s |mapid:%s |pos:Vector3(%s,%s,%s) |ownseal:%s |issealing:%s ",
			tostring(serverData.sealid), tostring(mapid), tostring(self.pos.x),tostring(self.pos.y),
			tostring(self.pos.z),tostring(serverData.ownseal),tostring(serverData.issealing));
		-- printOrange(updateStr);
	end
end

function SealItem:OnDestroy()
	if(self.pos)then
		self.pos:Destroy();
	end
	self.pos = nil;
end