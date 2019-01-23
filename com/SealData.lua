SealData = class("SealData")

autoImport("SealItem");

function SealData:ctor(serverData)
	self.mapid = serverData.mapid;

	self.itemMap = {};
	self:SetData(serverData);
end

function SealData:SetData(serverData)
	self:UpdateSealItem(serverData.items);
end

function SealData:UpdateSealItem(upds)
	for i=1,#upds do
		local sitem = upds[i];
		if(sitem)then
			local item = self.itemMap[sitem.sealid];
			if(not item)then
				item = SealItem.new(sitem, self.mapid);
				self.itemMap[sitem.sealid] = item;
			else
				item:SetData(sitem, self.mapid);
			end
		end
	end
end

function SealData:DeleteSealItem(dels)
	local itemMap = self.itemMap;

	for i=1,#dels do
		local ditem = dels[i];
		if(itemMap[ditem.sealid] ~= nil)then
			itemMap[ditem.sealid]:OnDestroy();
		end
		itemMap[ditem.sealid] = nil;
	end
end