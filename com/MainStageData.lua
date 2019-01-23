autoImport("SubStageData")
MainStageData = class("MainStageData")

MainStageData.LockState = 1
MainStageData.UnLockState = 2

function MainStageData:ctor(id,staticData)
	self.id = id
	self.isServerSync = false
	self.currentNormalStep = 0
	self.currentEliteStep = 0
	self.staticData = staticData or Table_Ectype[id]
	self.currentStars = 0
	self.state = MainStageData.LockState
	self.previous = nil
	self.next = nil
	self.rewardGetList = {}
	--list
	self.normalSubStage = {}
	self.eliteSubStage = {}
	--hasMap
	self.eliteSubStageMap = {}
	self.normalSubStageMap = {}
end

function MainStageData:TryInitSubs()
	if(#self.normalSubStage==0) then
		self:FactroyCreateSubs(self.staticData.NormalStageID,SubStageData.NormalType,self.normalSubStage,self.normalSubStageMap)
	end

	if(#self.eliteSubStage==0) then
		self:FactroyCreateSubs(self.staticData.HardStageID,SubStageData.EliteType,self.eliteSubStage,self.eliteSubStageMap)
	end
end

function MainStageData:FactroyCreateSubs( ids,type,tab,map )
	local subStage = nil
	for i=1,#ids do
		subStage = SubStageData.new(ids[i],self)
		subStage.type = type
		tab[#tab+1] = subStage
		map[subStage.id] = subStage
	end
	table.sort(tab,function(l,r)
			return l.staticData.Step < r.staticData.Step
	end)
end

function MainStageData:SetState(state)
	self.state = state
end

function MainStageData:SetStar(star)
	self.currentStars = star
end

--返回参数  是否可进入,前置未解锁关卡,所需任务未完成
function MainStageData:GetAccessInfo()
	self:TryInitSubs()
	local access = true
	local previousSub = nil
	if(self.previous~=nil) then
		self.previous:TryInitSubs()
		previousSub = self.previous.normalSubStage[self.previous:MaxNormalStep()]
	end
	local questUnFinish = self.normalSubStage[1].staticData.Quest
	if(questUnFinish~=nil and QuestProxy.Instance:isMainQuestCompleteByStepId(questUnFinish)==false) then
		access = false
	else
		questUnFinish = nil
	end
	if(self.state == MainStageData.LockState) then
		access = false
	else
		previousSub = nil
	end
	return access,previousSub,questUnFinish
end

function MainStageData:GetNormalStepByID(subID)
	local subStage = self.normalSubStageMap[subID]
	if(subStage~=nil) then
		return subStage.staticData.Step
	end
	return 0
end

function MainStageData:SetNormalStep(step)
	self.currentNormalStep = step
	for i=1,step do
		self.normalSubStage[i]:SetState(SubStageData.PassState)
	end
end

function MainStageData:SetEliteStep(step)
	self.currentEliteStep = step
	for i=1,step do
		self.eliteSubStage[i]:SetState(SubStageData.ChallengeState)
	end
end

function MainStageData:SetNormalSubStars(list)
	for i=1,#list do
		self:SetNormalSubStar(list[i].stepid,list[i].star)
	end
end

function MainStageData:SetEliteSub(list)
	for i=1,#list do
		self:SetEliteSub(list[i].stepid,list[i].finish,list[i].challengeTime)
	end
end

function MainStageData:SetNormalSubStar(index,star)
	local subStage = self.normalSubStage[index]
	subStage:SetState(SubStageData.PassState)
	return subStage:SetStar(star)
end

function MainStageData:SetEliteSub(index,finish,challengeTime)
	local subStage = self.eliteSubStage[index]
	if(subStage~=nil) then
		if(finish) then
			subStage:SetState(SubStageData.PassState)
		else
			subStage:SetState(SubStageData.ChallengeState)
		end
	end
end

function MainStageData:MaxNormalStep()
	local subStage = self.normalSubStage[#self.normalSubStage]
	if(subStage~=nil) then
		return subStage.staticData.Step
	else
		error(string.format("主关卡%s未初始化子关卡",self.id))
	end
end

function MainStageData:AddGetReward(star)
	self.rewardGetList[#self.rewardGetList+1] = star
end

function MainStageData:SetGetRewards(stars)
	self.rewardGetList = {}
	for i=1,#stars do
		self.rewardGetList[#self.rewardGetList+1] = stars[i]
	end
end

function MainStageData:DebugLog()
	-- local str = string.format("主关卡{%s},状态:%s,星数:%s",self.id,self.state,self.currentStars)
	-- local subStage = nil
	-- for i=1,#self.normalSubStage do
	-- 	subStage = self.normalSubStage[i]
	-- 	str = str.."\n普通子关卡:"..subStage:DebugLog()
	-- end

	-- for i=1,#self.eliteSubStage do
	-- 	subStage = self.eliteSubStage[i]
	-- 	str = str.."\n精英子关卡:"..subStage:DebugLog()
	-- end
	-- print(str)
end