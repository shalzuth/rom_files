AstrolabeProxy = class('AstrolabeProxy', pm.Proxy)
AstrolabeProxy.Instance = nil;
AstrolabeProxy.NAME = "AstrolabeProxy"

autoImport("Astrolabe_BordData");

local TableClear = TableUtility.TableClear

function AstrolabeProxy:ctor(proxyName, data)
	self.proxyName = proxyName or AstrolabeProxy.NAME
	if(AstrolabeProxy.Instance == nil) then
		AstrolabeProxy.Instance = self
	end

	self:Init();
end

function AstrolabeProxy:Init()
	self.curBord = Astrolabe_BordData.new();
end

function AstrolabeProxy:GetActiveStarPoints()
	local total = 0;
	for k,pointData in pairs(self:GetActivePointsMap())do
		total = total + 1;
	end
	return total;
	
end
function AstrolabeProxy:GetActivePointsMap()
	return self.curBord:GetActivePointsMap();
end

function AstrolabeProxy:GetTotalPointCount(rolelv, profession)
	if(rolelv == nil)then
		rolelv = MyselfProxy.Instance:RoleLevel();
	end
	if(profession == nil)then
		profession = MyselfProxy.Instance:GetMyProfession();
	end
	return self.curBord:GetTotalPointCount(rolelv, profession);
end

function AstrolabeProxy:InitProfessionPlate_PropData(profession)
	self.curBord:InitPlates_Prop(profession);
end

function AstrolabeProxy:GetCurBordData()
	return self.curBord;
end

function AstrolabeProxy:Server_SetActivePoints(pids)
	self.curBord:Server_SetActivePoints(pids);
end

function AstrolabeProxy:Server_ResetPoints(server_stars, noReset)
	self.curBord:Server_ResetPoints(server_stars);
end

function AstrolabeProxy:ResetPlate()
	self.curBord:Reset();
end

function AstrolabeProxy:GetEffectMap(plate)
	return self.curBord:GetAdd_EffectMap();
end

function AstrolabeProxy:GetSkill_SpecialEffect(skillid)
	return self.curBord:GetSkill_SpecialEffect(skillid);
end

function AstrolabeProxy:GetSpecialEffectCount(specialEffectId)
	return self.curBord:GetSpecialEffectCount(specialEffectId);
end

function AstrolabeProxy:SkillSetSpecialEnable(specialEffectId, enabled)
	self.curBord:SkillSetSpecialEnable(specialEffectId, enabled);
end

function AstrolabeProxy:CheckNeed_DoServer_InitPlate()
	self.curBord:CheckNeed_DoServer_InitPlate();
end


function AstrolabeProxy:CheckCanActive_AnyAstrolabePoint()

	local userdata = Game.Myself and Game.Myself.data.userdata;
	local left_slivernum = userdata:Get(UDEnum.SILVER) or 0;
	local left_contributenum = userdata:Get(UDEnum.CONTRIBUTE) or 0;
	local cost_slivernum, cost_contributenum, cost_goldawardnum = 0, 0, 0;

	local pointData, cost;

	local hasOff = false;

	local bagProxy = BagProxy.Instance
	local offMap = self.curBord:GetOffPointsIDMap();
	for guid,_ in pairs(offMap)do
		hasOff = true;

		pointData = self:GetPoint(nil, guid);
		cost = pointData:GetCost();
		for j=1,#cost do
			if(cost[j][1] == 100)then
				if(left_slivernum < cost[j][2])then
					return false;
				end
			elseif(cost[j][1] == 140)then
				if(left_contributenum < cost[j][2])then
					return false;
				end
			elseif(cost[j][1] == 5261)then
				local leftNum = bagProxy:GetItemNumByStaticID(cost[j][1]);
				if(leftNum < cost[j][2])then
					return false;
				end
			end
		end
	end

	if(hasOff)then
		return true;
	end

	return false;
end

function AstrolabeProxy:CheckPlateIsUnlock(plateid, bordData)
	bordData = bordData or self.curBord;
	return bordData:CheckPlateIsUnlock(plateid);
end




-- ?????????????????? begin
function AstrolabeProxy:GetBordData_BySaveInfo(saveInfoData, useBranch)
	if(saveInfoData == nil)then
		return;
	end
	local bordData = Astrolabe_BordData.new();

	local professionId;
	if(useBranch)then
		professionId = saveInfoData.id;
	else
		professionId = saveInfoData:GetProfession();
	end

	bordData:InitPlates_Prop(professionId);
	-- ????????????????????????????????????
	bordData:InitUnlockParam(saveInfoData:GetProfession(), 200);

	local astrolabeSaveData = saveInfoData:GetAstroble();
	if(astrolabeSaveData == nil)then
		return bordData;
	end

	local server_stars = astrolabeSaveData:GetActiveStars();
	local temp = {};
	TableUtility.ArrayShallowCopy(temp, server_stars);
	if(#temp == 0)then
		table.insert(temp, Astrolabe_Origin_PointID);
	end
	bordData:Server_SetActivePoints(temp);
	return bordData;
end


function AstrolabeProxy:GetStorageActivePointsCost(storageId)
	local server_stars = MultiProfessionSaveProxy.Instance:GetActiveStars(storageId);
	return self:GetPoints_ActiveCosts(server_stars);
end

function AstrolabeProxy:GetStorageActivePointsCost_BySaveInfo(saveInfoData)
	local server_stars = saveInfoData:GetActiveStars();
	return self:GetPoints_ActiveCosts(server_stars);
end

function AstrolabeProxy:GetPoints_ActiveCosts(active_stars)
	local resultCost = {};
	for i=1,#active_stars do
		local cost = Astrolabe_GetPointCost(active_stars[i]);
		if(cost)then
			for k,v in pairs(cost)do
				local itemid, num = v[1], v[2];
				if(resultCost[ itemid ] == nil)then
					resultCost[ itemid ] = num;
				else
					resultCost[ itemid ] = resultCost[ itemid ] + num;
				end
			end
		end
	end
	return resultCost;
end


--  !!!!!!!!! Get My ActivePoints Cost !!!!!!!!!
function AstrolabeProxy:GetStorageActivePointsCost_ByPlate()
	local activePointsMap = self:GetActivePointsMap();

	local resultCost = {};
	for k,pointData in pairs(activePointsMap)do
		local cost = pointData:GetCost();
		for k,v in pairs(cost)do
			local itemid, num = v[1], v[2];
			if(resultCost[ itemid ] == nil)then
				resultCost[ itemid ] = num;
			else
				resultCost[ itemid ] = resultCost[ itemid ] + num;
			end
		end
	end
	return resultCost;
end
--  !!!!!!!!! Get My ActivePoints Cost !!!!!!!!!

-- ?????????????????? end
