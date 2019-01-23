EquipRepairProxy = class('EquipRepairProxy', pm.Proxy)
EquipRepairProxy.Instance = nil;
EquipRepairProxy.NAME = "EquipRepairProxy"

function EquipRepairProxy:ctor(proxyName, data)
	self.proxyName = proxyName or EquipRepairProxy.NAME
	if(EquipRepairProxy.Instance == nil) then
		EquipRepairProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function EquipRepairProxy:Init()
	
end

function EquipRepairProxy:InitDamageEuipDatas()
	self.damageEquipDatas={}
	local equipDatas=BagProxy.Instance:GetBagEquipItems()
	self:FilterDamageEquipDatas(equipDatas)
	local roleEquips=BagProxy.Instance.roleEquip:GetItems()
	self:FilterDamageEquipDatas(roleEquips)
end

function EquipRepairProxy:FilterDamageEquipDatas(datas)
	if(datas)then
		for k,v in pairs(datas)do
			local info = v.equipInfo
			if(info)then
				if(info.damage)then
					print(v.id)
					table.insert(self.damageEquipDatas,v)
				end
			end
		end
	end
end

function EquipRepairProxy:GetEquipRepairItems(itemData)
	local result = {};

	local staticID = itemData.staticData.id;
	local vid = Table_Equip[staticID] and Table_Equip[staticID].VID;
	local bagItems = BagProxy.Instance.bagData:GetItems();
	for i=1,#bagItems do
		local item = bagItems[i];
		if(item~=itemData and item.equipInfo)then
			local itemVid = item.equipInfo.equipData.VID;
			if(itemVid and math.floor(itemVid/10000) == math.floor(vid/10000) and itemVid%1000 == vid%1000)then
				table.insert(result, item);
			end
		end
	end
	return result;
end

function EquipRepairProxy:GetNormalEquipNumsByStaticID(staticID)
	local nums=0

	if(type(staticID)=="number")then
		local equipDatas = BagProxy.Instance:GetBagEquipItems()
		for k,v in pairs(equipDatas)do
			if(v.staticData.id==staticID)then
				local info = v.equipInfo
				if(info)then
					local hasCard = v.equipedCardInfo ~= nil and #v.equipedCardInfo>0;
					local enchantInfo = v.enchantInfo;
					local isEnchant = enchantInfo and #enchantInfo:GetEnchantAttrs()>0;
					if(not hasCard and not isEnchant and info.strengthlv==0 and info.refinelv==0 and not info.damage)then
						nums=nums+1
					end
				end
			end
		end
	end
	return nums
end



function EquipRepairProxy:InitEquipVIDCache()
	self.equipData_VID_map = {};

	for k,edata in pairs(Table_Equip)do
		if(edata.VID)then
			local vid_start = math.floor(edata.VID/10000);
			local vid_start_left = edata.VID%10000;
			local vid_slot = math.floor(vid_start_left/1000);
			local vid_end = math.floor(vid_start_left%1000);

			local keyId = vid_start * 10000 + 1000 + vid_end;
			local cache = self.equipData_VID_map[keyId];
			if(cache == nil)then
				cache = {};
				self.equipData_VID_map[keyId] = cache;
			end
			cache[vid_slot] = edata;
		end
	end
end

function EquipRepairProxy:GetEquipVIDCache(itemid)
	local vid = Table_Equip[itemid] and Table_Equip[itemid].VID;
	if(vid == nil)then
		return;
	end

	if(self.equipData_VID_map == nil)then
		self:InitEquipVIDCache();
	end

	local vid_start = math.floor(vid/10000);
	local vid_end = math.floor(vid%1000);
	local keyId = vid_start * 10000 + 1000 + vid_end;
	return self.equipData_VID_map[keyId];
end