EquipSuitData = class("EquipSuitData");

function EquipSuitData:ctor(teamId)
	self.teamId = teamId;
	self.suitDatas = {};
	self.isactive = false;
end

function EquipSuitData:AddSuitData(suitData)
	table.insert(self.suitDatas, suitData)
end

function EquipSuitData:GetSuitNum()
	if(self.suitDatas[1])then
		return #self.suitDatas[1].Suitid;
	end
	return 0
end

function EquipSuitData:GetSuitName()
	if(self.suitDatas[1])then
		return self.suitDatas[1].EquipSuitDsc;
	end
	return ""
end

function EquipSuitData:GetEffectDesc()
	if(self.suitDatas[1])then
		return self.suitDatas[1].EffectDesc;
	end
	return ""
end

function EquipSuitData:CheckIsActive()
	for i=1,#self.suitDatas do
		local suitData = self.suitDatas[i];
		local suitDataEquip = suitData.Suitid;
		if(BagProxy.Instance:MatchEquipSuitBySuitId(suitData.id) >= #suitDataEquip)then
			return true;
		end
	end
	return false;
end

------------------------------------------------------------------------------

SuitInfo = class("SuitInfo")



local initEquipUpdate = false;
local upgradeProductKeyMap = {};
local suitIdsMap = {};
function SuitInfo.GetSuitIds(itemid)
	local ids = suitIdsMap[itemid];
	if(ids ~= nil)then
		return ids;
	end

	ids = {};
	suitIdsMap[itemid] = ids;

	local s1 = Table_Equip[itemid] and Table_Equip[itemid].SuitID;
	for i=1,#s1 do
		table.insert(ids, s1[i]);
	end

	if(not initEquipUpdate)then
		initEquipUpdate = true;

		for upgradeid, upgradeData in pairs(Table_EquipUpgrade)do
			local productId = upgradeData.Product;
			if(productId)then
				if(upgradeProductKeyMap[productId] == nil)then
					upgradeProductKeyMap[productId] = {};
				end
				table.insert(upgradeProductKeyMap[productId], upgradeData);
			end
		end
	end
	local surItems = upgradeProductKeyMap[itemid];
	if(surItems)then
		for i=1,#surItems do
			local surId = surItems[i].id;
			local suitids = BagProxy.GetSuitIds(surId);
			for i=1,#suitids do
				if(TableUtility.ArrayFindIndex(ids, suitids[i]) == 0)then
					table.insert(ids, suitids[i]);
				end
			end
		end
	end

	return ids;
end



function SuitInfo:ctor(suitIds)
	self.equipSuitDatas = {};
	local teamMap = {};
	for i=1,#suitIds do
		local sData = Table_EquipSuit[ suitIds[i] ];
		if(sData)then
			if(sData.SameTeam)then
				local equipSuitData = teamMap[sData.SameTeam];
				if(equipSuitData == nil)then
					equipSuitData = EquipSuitData.new( sData.SameTeam );
					teamMap[sData.SameTeam] = equipSuitData;

					table.insert(self.equipSuitDatas, equipSuitData);	
				end
				equipSuitData:AddSuitData(sData);
			else
				local equipSuitData = EquipSuitData.new( nil );
				equipSuitData:AddSuitData(sData);

				table.insert(self.equipSuitDatas, equipSuitData);	
			end
		end
	end
end

function SuitInfo:GetEquipSuitDatas()
	return self.equipSuitDatas;
end



