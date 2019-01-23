autoImport("PetWorkSpaceItemData")

PetWorkSpaceProxy = class('PetWorkSpaceProxy', pm.Proxy)
PetWorkSpaceProxy.Instance = nil;
PetWorkSpaceProxy.NAME = "PetWorkSpaceProxy"
PetWorkSpaceProxy.ItemID = 5542;

PetWorkSpaceProxy.ESpaceStatus=
{
	EWORKSTATE_UNUSED = ScenePet_pb.EWORKSTATE_UNUSED,
	EWORKSTATE_WORKING = ScenePet_pb.EWORKSTATE_WORKING,
	EWORKSTATE_REST = ScenePet_pb.EWORKSTATE_REST,
}

PetWorkSpaceProxy.EPetStatus=
{
	EPETWORK_IDLE = 1,				--可出站
	EPETWORK_FIGHT = 2,				--派遣
	EPETWORK_REJECT = 3,			--场所拒绝
	EPETWORK_SPACE_LIMITED = 4,		--转换场所被限
	EPETWORK_Scene = 5,				--出战
}


function PetWorkSpaceProxy:ctor(proxyName, data)
	self.proxyName = proxyName or PetWorkSpaceProxy.NAME
	if(PetWorkSpaceProxy.Instance == nil) then
		PetWorkSpaceProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function PetWorkSpaceProxy:Init()
	self.petWorkSpaceData={}
	self.petExchangeMap={}
	self:InitStaticData()
end

function PetWorkSpaceProxy:InitStaticData()
	for _,v in pairs(Table_Pet_WorkSpace) do
		local spaceData = PetWorkSpaceItemData.new(v.id)
		self.petWorkSpaceData[spaceData.id] = spaceData
	end
end

function PetWorkSpaceProxy:SetPetWorkData(datas)
	for i=1,#datas do
		local spaceData = PetWorkSpaceItemData.new(datas[i].id)
		spaceData:SetServiceData(datas[i])
		self.petWorkSpaceData[spaceData.id] = spaceData
	end
	
end

function PetWorkSpaceProxy:SetExtra(data)
	self.monthCard_expiretime = data.card_expiretime
	self.maxSpace = data.max_space
	local extras = data.extras
	self:SetExchangeMap(extras)
end

function PetWorkSpaceProxy:SetExchangeMap(extras)
	TableUtility.TableClear(self.petExchangeMap)
	for i=1,#extras do
		local extraMap = {}
		local petGuid = extras[i].guid
		if(petGuid)then
			extraMap.count = extras[i].count
			extraMap.lastSpaceid = extras[i].lastspaceid
			-- helplog("lastspaceid: ",extraMap.lastSpaceid)
			self.petExchangeMap[petGuid]=extraMap
		end
	end
end

function PetWorkSpaceProxy:GetCardExpireTime()
	return self.monthCard_expiretime
end

function PetWorkSpaceProxy:GetMaxSpace()
	return self.maxSpace
end

local DAY_SEC = 86400
-- 宠物打工当天获得的奖励数量
local floor = math.floor 
function PetWorkSpaceProxy.calcPetWorkCurDayRewardCount(starttime,endtime,frequency,maxreward,lastcount)
  	local totalReward = PetFun.calcPetWorkRewardCount(starttime,endtime,frequency,maxreward,lastcount) -- 先算总奖励
  	local interval = 0  -- 隔的天数
  	local refreshTime = PetWorkSpaceProxy.GetRefreshTime(starttime)
  	if(endtime>refreshTime)then   -- 跨天了
      	if((endtime - refreshTime) / DAY_SEC>1)then
      		interval = (endtime - refreshTime) / DAY_SEC
      	-- helplog("interval: ",interval,"endtime: ",endtime)
    	end
    	endtime = refreshTime + interval * DAY_SEC 
    	-- helplog("starttime: ",starttime,"endtime: ",endtime)
    	local beforeReward = PetFun.calcPetWorkRewardCount(starttime,endtime,frequency,maxreward,lastcount)
    	-- helplog("总共的奖励： ",totalReward,"之前天数的奖励： ",beforeReward)
    	return floor(totalReward) - floor(beforeReward) , false
  	else
  		-- helplog("不跨天： ",totalReward)
    	return floor(totalReward),true
  	end
end

function PetWorkSpaceProxy.GetRefreshTime(start_time)
	local refreshTime = os.date('*t', start_time)
	refreshTime = os.time({year=refreshTime.year, month=refreshTime.month, day=refreshTime.day, hour=5})
	if(start_time>refreshTime)then
	  refreshTime = DAY_SEC+refreshTime
	end
	return refreshTime
end

function PetWorkSpaceProxy:CheckNeedCountDown()
	for _,v in pairs(self.petWorkSpaceData) do
		if(v:IsWorking())then
			return true
		end
	end
	return false
end

function PetWorkSpaceProxy:IsPetExchangeCountLimited(guid,spaceID)
	if(self.petExchangeMap[guid])then
		if(spaceID == self.petExchangeMap[guid].lastSpaceid )then
			return false
		end
		return self.petExchangeMap[guid].count>=GameConfig.PetWorkSpace.pet_work_max_exchange
	end
	return false
end

function PetWorkSpaceProxy:SortPet(left,right)
	local spaceid = self.chooseSpaceID
	local lFre = PetFun.calcPetWorkFrequency(left.petid,left.lv,left.friendlv,spaceid,left.petWorkSkillID)
	local rFre = PetFun.calcPetWorkFrequency(right.petid,right.lv,right.friendlv,spaceid,right.petWorkSkillID)
	local lIdle = left.state==PetWorkSpaceProxy.EPetStatus.EPETWORK_IDLE
	local rIdle = right.state==PetWorkSpaceProxy.EPetStatus.EPETWORK_IDLE
	if(lIdle and rIdle)then
		if(lFre==rFre)then
			if(left.friendlv==right.friendlv)then
				if(left.lv==right.lv)then
					return left.petid > right.petid
				else
					return left.lv>right.lv
				end
			else
				return left.friendlv>right.friendlv
			end
		else
			return lFre>rFre
		end
	end
	if(lIdle or rIdle)then
		return lIdle==true
	end
	if(lIdle==false and rIdle==false)then
		return left.state < right.state
	end
	return false
end

-- 出战中的宠物
function PetWorkSpaceProxy:GetBattlePet(petData)
	self.battlePet={}
	for i=1,#petData do
		local itemInfo = petData[i].base
		local item = ItemData.new(itemInfo.guid,itemInfo.id)
		local PetInfo = PetEggInfo.new(item.staticData)
		PetInfo:Server_SetData(petData[i].egg)
		PetInfo.guid=itemInfo.guid
		PetInfo.state = PetWorkSpaceProxy.EPetStatus.EPETWORK_Scene
		self.battlePet[#self.battlePet+1]=PetInfo
	end
end

function PetWorkSpaceProxy:_getUnlockSpace()
	local result = {}
	for _,v in pairs(self.petWorkSpaceData) do
		if(v.unlock and v.unlock==true)then
			result[#result+1]=v
		end
	end
	return result;
end

local function _basePetUnLimited(spaceID,pet)
	local limitedLvl = Table_Pet_WorkSpace[spaceID].Level
	local limitedFriendLvl = GameConfig.PetWorkSpace.pet_work_manual_unlock.friendlv
	if(pet.lv>=limitedLvl and pet.friendlv>=limitedFriendLvl)then
		return true
	end
	return false
end

function PetWorkSpaceProxy:_getWorkingPets()
	local result = {}
	for _,v in pairs(self.petWorkSpaceData) do
		local petEggs = v.petEggs
		if(petEggs)then
			if( v:IsWorking() or v:IsResting())then
				for i=1,#petEggs do
					petEggs[i].state=PetWorkSpaceProxy.EPetStatus.EPETWORK_FIGHT
					result[#result+1]=petEggs[i]
				end
			end
		end
	end
	return result
end


function PetWorkSpaceProxy:GetTotalPetsData(spaceID)
	local allPets = {}
	if(self.battlePet)then
		for i=1,#self.battlePet do
			local pet = self.battlePet[i]
			if(_basePetUnLimited(spaceID,pet))then
				allPets[#allPets+1]=self.battlePet[i]
			end
		end
	end
	local petCfg = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.pet_workspace or {1,7,9}
	for j=1,#petCfg do
		local bagPet = BagProxy.Instance:GetMyPetEggs(petCfg[j])
		if(bagPet)then
			for i=1,#bagPet do
				local pet = bagPet[i].petEggInfo
				if(_basePetUnLimited(spaceID,pet))then
					pet.guid=bagPet[i].id
					local spaceData = self:GetWorkSpaceDataById(spaceID)
					if(self:IsPetExchangeCountLimited(pet.guid,spaceID))then
						pet.state = PetWorkSpaceProxy.EPetStatus.EPETWORK_SPACE_LIMITED
					else
						if(spaceData:IsSpacePetRejected(pet.petid))then
							pet.state = PetWorkSpaceProxy.EPetStatus.EPETWORK_REJECT
						else
							pet.state = PetWorkSpaceProxy.EPetStatus.EPETWORK_IDLE
						end
					end
					allPets[#allPets+1]=pet
				end
			end
		end
	end
	local workingPets = self:_getWorkingPets()
	for i=1,#workingPets do
		allPets[#allPets+1]=workingPets[i]
	end
	table.sort(allPets,function (l,r)
		return self:SortPet(l,r)
	end)
	return allPets
end

function PetWorkSpaceProxy:GetWorkSpaceData()
	return self.petWorkSpaceData
end

function PetWorkSpaceProxy:GetWorkSpaceDataById(id)
	return self.petWorkSpaceData[id]
end

function PetWorkSpaceProxy:GetWorkingSpace()
	local result={}
	for _,v in pairs(self.petWorkSpaceData) do
		if(v:IsWorking())then
			result[#result+1]=v
		end
	end
	return result
end

function PetWorkSpaceProxy:GetRestSpace()
	local result = {}
	for k,v in pairs(self.petWorkSpaceData) do
		if(v.state == PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST) then
			result[#result+1]=v
		end
	end
	return result
end


function PetWorkSpaceProxy:SetPetSpaceFuncUnlock(manual)
	self.FuncUnlock = manual.unlock
end

function PetWorkSpaceProxy:IsFuncUnlock()
	return self.FuncUnlock and self.FuncUnlock == true
end


function PetWorkSpaceProxy:GetlockSpace()
	local result = {}
	for _,v in pairs(self.petWorkSpaceData) do
		if(v.unlock==false)then
			result[#result+1]=v
		end
	end
	return result;
end

local MONTH_CARD = 1902
local introduceData = {}
function PetWorkSpaceProxy:GetIntroduceDescData()
	TableUtility.ArrayClear(introduceData)
	local descData = {}
	descData.type = "single";
	descData.desc = ZhString.PetWorkSpace_Introduce 
	TableUtility.ArrayPushBack(introduceData,descData)

	-- unlockDesc
	local unlockDescData = {} -- 解锁的信息
	local unlockData = self:_getUnlockSpace()
	for _,v in pairs(unlockData) do
		local tabSingle = {}
		local name = v.staticData.Name
		local fre = v.staticData.Frequency
		tabSingle.desc = string.format(ZhString.PetWorkSpace_UnlockDesc,name,fre)
		
		local rewardArray = v:GetRewardArray()
		if(rewardArray and#rewardArray>0)then	
			tabSingle.rewards = rewardArray
		end
		table.insert(unlockDescData,tabSingle)
	end
	unlockDescData.type="table";
	TableUtility.ArrayPushBack(introduceData,unlockDescData)


	local lockDescData = {}
	local lockData = self:GetlockSpace()
	for _,v in pairs(lockData) do
		local menuID = v:GetMenuID()
		local name = v.staticData.Name
		if(menuID)then
			local menCsv = Table_Menu[menuID]
			if(menCsv)then
				local tabSingle = {}
				local param,content
				local Condition = menCsv.Condition
				local value = Condition.manualunlock
				if(value)then
					local type = value[1][1]
					param = AdventureDataProxy.Instance:getUnlockNumByType(type)
					content = string.format(menCsv.text,param)
					tabSingle.desc = string.format(ZhString.PetWorkSpace_LockDesc,name,content)
				elseif (Condition.title)then
					-- param = MyselfProxy.Instance:GetCurManualAppellation()
					-- param = param and param.staticData.Name or ZhString.PetWorkSpace_DefaultAppellation
					-- content = string.format(menCsv.text,param)
					tabSingle.desc = string.format(ZhString.PetWorkSpace_LockDesc,name,menCsv.text)
				elseif(Condition.cooklv)then
					local userData = Game.Myself.data.userdata
					if(userData)then
						param = userData:Get(UDEnum.COOKER_LV) or 1
						content = string.format(menCsv.text,param)
						tabSingle.desc = string.format(ZhString.PetWorkSpace_LockDesc,name,content)
					end
				elseif(menuID==MONTH_CARD)then
					tabSingle.desc = string.format(ZhString.PetWorkSpace_LockDesc,name,menCsv.text)
				else
					content = menCsv.text
					tabSingle.desc = string.format(ZhString.PetWorkSpace_LockDesc,name,content)
				end
				table.insert(lockDescData,tabSingle)
			end
		end
	end
	lockDescData.type="table";
	TableUtility.ArrayPushBack(introduceData,lockDescData)

	return introduceData
end

