autoImport("MainStageData")

DungeonProxy= class('DungeonProxy', pm.Proxy)

DungeonProxy.Instance = nil;

DungeonProxy.NAME = "DungeonProxy"

--玩家背包数据管理

function DungeonProxy:ctor(proxyName, data)
	self.proxyName = proxyName or DungeonProxy.NAME
	self.lastChallengeSubStage = nil
	if(DungeonProxy.Instance == nil) then
		DungeonProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end
	-- self:Init()
end

function DungeonProxy:Init()
	self.mainStageMap = {}
	self.mainStageList = {}
	self.maxMainStageID = 0
	self.maxMainStep = 0
	local mainStage = nil
	for id,data in pairs(Table_Ectype) do
		mainStage = MainStageData.new(id,data)
		self.mainStageMap[id] = mainStage
		self.mainStageList[#self.mainStageList+1] = mainStage
	end

	table.sort(self.mainStageList,function(l,r)
			return l.id < r.id
	end)
	for i=1,#self.mainStageList do
		self.mainStageList[i].previous = self.mainStageList[i-1]
		self.mainStageList[i].next = self.mainStageList[i+1]
	end
	if(#self.mainStageList>0) then
		self.mainStageList[1]:SetState(MainStageData.UnLockState)
	end
	-- self:LocalTest()
end

function DungeonProxy:onRegister()
end

function DungeonProxy:onRemove()
end

function DungeonProxy:GetMainStage(id)
	return self.mainStageMap[id]
end

function DungeonProxy:AskForWholeMainStage()
	if(not self.initedMainStage) then
		ServiceFuBenCmdProxy.Instance:CallWorldStageUserCmd()
	else
		GameFacade.Instance:sendNotification(ServiceEvent.FuBenCmdWorldStageUserCmd)
	end
end

function DungeonProxy:AskForWholeSubStage(stageId)
	local mainStage = self.mainStageMap[stageId]
	if(mainStage~=nil) then
		if(not mainStage.isServerSync) then
			ServiceFuBenCmdProxy.Instance:CallStageStepUserCmd(stageId)
		else
			GameFacade.Instance:sendNotification(ServiceEvent.FuBenCmdStageStepUserCmd, mainStage)
		end
	end
end

function DungeonProxy:InitMainStageInfo(serverList)
	self.initedMainStage = true
	local mainStage = nil
	local data = nil
	for i=1,#serverList do
		data = serverList[i]
		mainStage = self.mainStageMap[data.id]
		mainStage:SetStar(data.star)
		mainStage:SetGetRewards(data.getList)
		mainStage:SetState(MainStageData.UnLockState)
	end
end

function DungeonProxy:SetNormalStageProgress(id,stepID)
	self.maxMainStageID = id
	self.maxMainStep = stepID
	print(string.format("当前进度%s,%s",id,stepID))
	local mainPreviousStage = self.mainStageMap[id-1]
	if(mainPreviousStage~=nil) then
		mainPreviousStage:TryInitSubs()
		mainPreviousStage:SetEliteStep(1)
	end
	if(self:HandlerCurrent(id,stepID)==false and mainPreviousStage~=nil) then
		stepID = mainPreviousStage:MaxNormalStep()
		self:HandlerCurrent(mainPreviousStage.id,stepID)
	end
end

function DungeonProxy:HandlerCurrent(id,stepid)
	local mainStage = self.mainStageMap[id]
	if(mainStage==nil) then
		return false
	end
	mainStage:TryInitSubs()
	mainStage:SetNormalStep(stepid)
	mainStage:SetState(MainStageData.UnLockState)
	return true
end

function DungeonProxy:GetReward(stageID,star)
	local mainStage = self.mainStageMap[stageID]
	mainStage:AddGetReward(star)
end

function DungeonProxy:UpdateMainStageSubs(data)
	local mainStage = self.mainStageMap[data.stageid]
	mainStage.isServerSync = true
	mainStage:TryInitSubs()
	mainStage:SetNormalSubStars(data.normalist)
	mainStage:SetEliteSub(data.hardlist)
end

function DungeonProxy:UpdateMainStageInfo(data)
	local mainStage = self.mainStageMap[data.stageid]
	if(mainStage) then
		if(data.type == SubStageData.EliteType) then
			self.lastChallengeSubStage = mainStage.eliteSubStage[data.stepid]
		else
			self.lastChallengeSubStage = mainStage.normalSubStage[data.stepid]
		end
	end
	-- TableUtil.Print(self.lastChallengeSubStage)
	if(mainStage.isServerSync) then
		if(data.type == SubStageData.EliteType) then
			mainStage:SetEliteSub(data.stepid,data.star==1)
			mainStage:SetEliteSub(data.stepid+1)
		elseif(data.type == SubStageData.NormalType) then
			local addStar = mainStage:SetNormalSubStar(data.stepid,data.star)
			print("addStar "..addStar)
			mainStage:SetStar(addStar + mainStage.currentStars)
			print(" mainStage Star "..mainStage.currentStars)
			if(mainStage.id == self.maxMainStageID and data.stepid == self.maxMainStep) then
				local nextMain = 0
				local nextSub = 0
				if(self.maxMainStep>=mainStage:MaxNormalStep()) then
					nextMain = self.maxMainStageID+1
					nextSub = 1
				else
					nextMain = self.maxMainStageID
					nextSub = self.maxMainStep+1
				end
				self:StepForward(nextMain,nextSub)
			end
		end
	end
end

function DungeonProxy:StepForward(id,step)
	self:SetNormalStageProgress(id,step)
end

function DungeonProxy:GetPreivousSub(subStage)
	if(subStage.staticData.Step == 1) then
		if(subStage.type == SubStageData.NormalType) then
			local mainPreviousStage = self.mainStageMap[subStage.mainStage.id-1]
			if(mainPreviousStage~=nil) then
				mainPreviousStage:TryInitSubs()
				return mainPreviousStage.normalSubStage[mainPreviousStage:MaxNormalStep()]
			end
			return nil
		elseif(subStage.type == SubStageData.EliteType) then
			return subStage.mainStage.eliteSubStage[#subStage.mainStage.eliteSubStage]
		end
	else
		if(subStage.type == SubStageData.NormalType) then
			return subStage.mainStage.normalSubStage[subStage.staticData.Step-1]
		elseif(subStage.type == SubStageData.EliteType) then
			return subStage.mainStage.eliteSubStage[subStage.staticData.Step-1]
		end
	end
end

function DungeonProxy:DebugLog()
	local mainStage = nil
	for i=1,#self.mainStageList do
		mainStage = self.mainStageList[i]
		mainStage:DebugLog()
	end
end

function DungeonProxy:LocalTest()
	local data =FuBenCmd_pb.WorldStageUserCmd()
	local normalInfo = FuBenCmd_pb.StageStepItem()
	normalInfo.stageid = 1
	normalInfo.stepid = 5
	table.insert(data.curinfo,normalInfo)
	local test = {{1,9},{},{}}

	for i=1,#test do
		local t = test[i]
		if(#t >0) then
			local item = FuBenCmd_pb.WorldStageItem()
			item.id = t[1]
			item.star = t[2]
			table.insert(data.list,item)
			-- data.list[#data.list+1] = item
		end
	end

	DungeonProxy.Instance:InitMainStageInfo(data.list)
	DungeonProxy.Instance:SetNormalStageProgress(normalInfo.stageid,normalInfo.stepid)

	DungeonProxy.Instance:DebugLog()

	local subdata = FuBenCmd_pb.StageStepUserCmd()
	subdata.stageid = 1
	-- subdata
	local test2 = {{1,2},{2,2},{3,2},{4,2},{5}}

	for i=1,#test2 do
		local t = test2[i]
		if(#t >1) then
			local item = FuBenCmd_pb.StageNormalStepItem()
			item.stepid = t[1]
			item.star = t[2]
			table.insert(subdata.normalist,item)
			-- data.list[#data.list+1] = item
		end
	end

	DungeonProxy.Instance:UpdateMainStageSubs(subdata)
	DungeonProxy.Instance:DebugLog()
	-- WorldStageItem
end


-- Pve Card Begin
function DungeonProxy:InitCards()
	if(self.cache_cards == nil)then
		self.cache_cards = {};
	else
		TableUtility.TableClear(self.cache_cards);
	end
end

function DungeonProxy:ReSetCardDatas(server_cards)
	self:InitCards();

	local server_card;
	for i=1,#server_cards do
		server_card = server_cards[i];

		local cache = {};
		self.cache_cards[ server_card.index ] = cache;
		TableUtility.ArrayShallowCopy(cache, server_card.cardids);
	end
end

function DungeonProxy:GetCardDatas()
	return self.cache_cards;
end

function DungeonProxy:GetCardData(index)
	if(self.cache_cards == nil)then
		return;
	end
	return self.cache_cards[index];
end


function DungeonProxy:SyncProcessPveCard(select_index, cardIds, progress)
	self.select_cardIds = {};

	for i=1,#cardIds do
		table.insert(self.select_cardIds, cardIds[i]);
	end

	self.select_index = select_index;

	self:UpdateProcessPveCard(progress);
	
	helplog("SyncProcessPveCard:", select_index, #self.select_cardIds, progress);
end

function DungeonProxy:UpdateProcessPveCard(progress)
	helplog("UpdateProcessPveCard", progress);
	self.now_progress = progress;
end

function DungeonProxy:GetNowProgress()
	return self.now_progress;
end

function DungeonProxy:GetNowPlayingIndex()
	return self.select_index;
end

function DungeonProxy:GetNextPlayingCardIds()
	if(self.select_cardIds == nil)then
		return;
	end

	local progress = self.now_progress;
	if(progress == nil or progress == 0)then
		return;
	end
	
	local result = {};
	for i=0,2 do
		local v = self.select_cardIds[progress+i];
		if(v ~= nil)then
			table.insert(result, v);
		end
	end
	return result;
end

function DungeonProxy:GetSelectCardIds()
	return self.select_cardIds;
end
-- Pve Card End



-- Altman Start
function DungeonProxy:UpdateAltManRaidInfo(lefttime, killcount, selfkill)
	self.altman_lefttime = lefttime or 0;
	self.altman_killcount = killcount or 0;
	self.altman_selfkill = selfkill or 0;
end

function DungeonProxy:GetAltManRaidInfo()
	return self.altman_lefttime, self.altman_killcount, self.altman_selfkill;
end
-- Altman End
