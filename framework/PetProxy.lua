PetProxy = class('PetProxy', pm.Proxy)

PetProxy.Instance = nil;

PetProxy.NAME = "PetProxy"

autoImport("BeingInfoData");
autoImport("PetInfoData");

function PetProxy:ctor(proxyName, data)
	self.proxyName = proxyName or PetProxy.NAME
	if(PetProxy.Instance == nil) then
		PetProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end

	self:Init();
end

function PetProxy:Init()
	self.myPetsMap = {};

	self:Init_PetCapture_Config();

	FunctionPet.Me():MapEvent();

	self.myBeingsMap = {};
end

function PetProxy:Init_PetCapture_Config()
	if(not Table_Pet_Capture)then
		return;
	end

	self.capture_CatchNpcID_map = {};
	self.capture_GiftItemID_map = {};
	self.capture_PetID_map = {};
	self.capture_EggID_map = {};

	for k,cdata in pairs(Table_Pet_Capture)do
		if(cdata.CatchNpcID)then
			self.capture_CatchNpcID_map[cdata.CatchNpcID] = cdata;
		end
		if(cdata.GiftItemID)then
			self.capture_GiftItemID_map[cdata.GiftItemID] = cdata;
		end
		if(cdata.PetID)then
			self.capture_PetID_map[cdata.PetID] = cdata;
		end
		if(cdata.EggID)then
			self.capture_EggID_map[cdata.EggID] = cdata;
		end
	end
end

function PetProxy:Server_UpdateMyPetInfos(server_petinfos)
	for i=1,#server_petinfos do
		self:Server_UpdateMyPetInfo(server_petinfos[i]);
	end
end

function PetProxy:Server_UpdateMyPetInfo(server_petinfo)
	local petid = server_petinfo.petid;
	if(petid)then
		local petData = self.myPetsMap[petid];
		if(petData == nil)then
			petData = PetInfoData.new();
			self.myPetsMap[petid] = petData;
		end

		petData:Server_SetData(server_petinfo);

		local oldvalue = petData.rewardexp;
		FunctionPet.Me():RewardExpChange(petData, 0, petData.rewardexp);
	end
end

function PetProxy:Server_PetInfoUpdate(petid, petMemberDatas)
	local petData = self.myPetsMap[petid];
	if(petData == nil)then
		return;
	end

	local oldrewardexp = petData.rewardexp;

	petData:Server_UpdateData(petMemberDatas);
	
	local newrewardexp = petData.rewardexp

	if(oldrewardexp ~= newrewardexp)then
		FunctionPet.Me():RewardExpChange(petData, oldrewardexp, newrewardexp);
	end
end

function PetProxy:Server_UpdatePetEquip(petid, serverEquip, del)
	local petData = self.myPetsMap[petid];
	if(petData == nil)then
		return;
	end
	
	petData:Server_UpdatePetEquip(serverEquip);
	petData:Server_DeletePetEquip(del);
end

function PetProxy:Server_UpdateUnlockInfo(petid, server_equips, server_bodys)
	local petInfo = self.myPetsMap[petid];
	if(petInfo == nil)then
		return;
	end

	petInfo:Server_UpdateUnlockInfo(server_equips, server_bodys);
end

function PetProxy:Server_RemovePetInfoData(petid)
	local petData = self.myPetsMap[petid];
	if(petData ~= nil)then
		self.myPetsMap[petid] = nil;
	end
end

function PetProxy:GetMyPetInfoData(petid)
	if(petid)then
		return self.myPetsMap[petid];
	end

	local _,petData = next(self.myPetsMap);
	return petData;
end

function PetProxy:GetMySceneNpet(petid)
	local petInfo = self:GetMyPetInfoData(petid);
	if(petInfo)then
		return NScenePetProxy.Instance:Find(petInfo.guid);
	end

	-- local userMap = NScenePetProxy.Instance.userMap;
	-- for _,user in pairs(userMap)do
	-- 	local ntype = user.data.staticData.Type;
	-- 	if(ntype == NpcData.NpcDetailedType.PetNpc)then
	-- 		return user;
	-- 	endd
	-- end
end

function PetProxy:CheckIsMyPetByGuid(guid)
	for _, petInfoData in pairs(self.myPetsMap)do
		if(petInfoData.guid == guid)then
			return true;
		end
	end
	return false;
end

function PetProxy:CheckCanGetReward()
	
end

function PetProxy:GetCaptureDataByCatchNpcID(id)
	if(self.capture_CatchNpcID_map)then
		return self.capture_CatchNpcID_map[id];
	end
end

function PetProxy:GetCaptureDataByPetID(id)
	if(self.capture_PetID_map)then
		return self.capture_PetID_map[id];
	end
end

function PetProxy:GetCaptureDataByGiftItemID(id)
	if(self.capture_GiftItemID_map)then
		return self.capture_GiftItemID_map[id];
	end
end

function PetProxy:GetCaptureDataByEggID(id)
	if(self.capture_EggID_map)then
		return self.capture_EggID_map[id];
	end
end



-- Being npc
function PetProxy:Server_SetMyBeingNpcInfos(server_BeingInfos)
	if(server_BeingInfos == nil)then
		return;
	end

	for i=1,#server_BeingInfos do
		self:Server_SetMyBeingNpcInfo(server_BeingInfos[i]);
	end

	EventManager.Me():PassEvent(PetEvent.BeingInfoData_SummonChange, beingInfo);
	EventManager.Me():PassEvent(PetEvent.BeingInfoData_AliveChange, beingInfo);
end

function PetProxy:Server_SetMyBeingNpcInfo(server_BeingInfo)
	if(server_BeingInfo == nil)then
		return;
	end

	local beingid = server_BeingInfo.beingid;
	if(beingid == nil)then
		return;
	end

	local beingInfo = self.myBeingsMap[beingid];
	if(beingInfo == nil)then
		beingInfo = BeingInfoData.new();
		self.myBeingsMap[beingid] = beingInfo;
	end

	beingInfo:Server_SetData(server_BeingInfo);
end

function PetProxy:Server_UpdateMyBeingInfo(beingid, server_BeingMemberDatas)
	local beingInfo = self:GetMyBeingNpcInfo(beingid);

	if(beingInfo == nil)then
		return;
	end

	local oldSummon = beingInfo.summon;
	local oldLive = beingInfo.live;

	beingInfo:Server_UpdateData(server_BeingMemberDatas);

	if(oldSummon ~= nil and beingInfo.summon ~= oldSummon)then
		EventManager.Me():PassEvent(PetEvent.BeingInfoData_SummonChange, beingInfo);
	end
	if(oldLive ~= nil and beingInfo.live ~= oldLive)then
		EventManager.Me():PassEvent(PetEvent.BeingInfoData_AliveChange, beingInfo);
	end
end

function PetProxy:Server_RemoveBeingInfoData(beingid)
	local beingData = self.myBeingsMap[beingid];
	if(beingData ~= nil)then
		self.myBeingsMap[beingid] = nil;
	end
end

function PetProxy:ClearMyBeingMap()
end

function PetProxy:GetMyBeingNpcInfo(beingid)
	if(beingid == nil)then
		return nil;
	end
	return self.myBeingsMap[beingid];
end

function PetProxy:GetMySummonBeingInfo()
	if(self.myBeingsMap == nil)then
		return nil;
	end
	for _, beingInfo in pairs(self.myBeingsMap)do
		if(beingInfo:IsSummoned())then
			return beingInfo;
		end
	end
end

function PetProxy:GetSceneBeingNpc(beingid)
	local beingInfo = self:GetMySummonBeingInfo(beingid);
	if(beingInfo == nil)then
		return;
	end

	return SceneCreatureProxy.FindCreature(beingInfo.guid);
end
-- Being npc
