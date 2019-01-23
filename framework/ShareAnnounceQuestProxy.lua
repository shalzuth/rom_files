ShareAnnounceQuestProxy = class('ShareAnnounceQuestProxy', pm.Proxy)
ShareAnnounceQuestProxy.Instance = nil;
ShareAnnounceQuestProxy.NAME = "ShareAnnounceQuestProxy"

local tempArray = {}
function ShareAnnounceQuestProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ShareAnnounceQuestProxy.NAME
	if(ShareAnnounceQuestProxy.Instance == nil) then
		ShareAnnounceQuestProxy.Instance = self
	end
	self:initData()
	self:initListener()
	-- self:Test()
end

function ShareAnnounceQuestProxy:initListener(  )
	-- body
	EventManager.Me():AddEventListener(TeamEvent.MemberExitTeam,self.ExitTeamHandler,self)
	EventManager.Me():AddEventListener(TeamEvent.ExitTeam,self.MeExitTeamHandler,self)
end

function ShareAnnounceQuestProxy:initData(  )
	-- body
	self.questList = {}
	self.helpQuestList = {}
end

function ShareAnnounceQuestProxy:Test(  )
	-- body
	local data = MemberWantedQuest.new(4294967339,50420001,SceneQuest_pb.EQUESTACTION_ACCEPT)
	table.insert(self.questList,data)

	data = MemberWantedQuest.new(4295509080,50420001,SceneQuest_pb.EQUESTACTION_SUBMIT)
	table.insert(self.questList,data)

	data = MemberWantedQuest.new(4296409659,50050001,SceneQuest_pb.EQUESTACTION_ACCEPT)
	table.insert(self.questList,data)

	data = MemberWantedQuest.new(4300969038,50350001,SceneQuest_pb.EQUESTACTION_ABANDON_GROUP)
	table.insert(self.questList,data)

	data = MemberWantedQuest.new(4300969038,53400001,SceneQuest_pb.EQUESTACTION_ACCEPT)
	table.insert(self.questList,data)

	table.insert(self.helpQuestList,53400001)
	table.insert(self.helpQuestList,50050001)
	table.insert(self.helpQuestList,50420001)
	table.insert(self.helpQuestList,50350001)
	self:updateHelpQuestIds()
end

function ShareAnnounceQuestProxy:RecvQuestWantedQuestTeamCmd(data)
	-- helplog("ShareAnnounceQuestProxy:RecvQuestWantedQuestTeamCmd(data)")

	local quests = data.quests
	if(not quests)then
		LogUtility.ErrorFormat("ShareAnnounceQuestProxy:RecvQuestWantedQuestTeamCmd() data.quests is nil")
		return
	end
	TableUtility.ArrayClear(self.questList)
	for i=1,#quests do
		local single = quests[i]
		local data = MemberWantedQuest.new()
		data:updateByServerData(single)
		table.insert(self.questList,data)
	end
end

function ShareAnnounceQuestProxy:RecvUpdateWantedQuestTeamCmd(data)
	-- helplog("ShareAnnounceQuestProxy:RecvUpdateWantedQuestTeamCmd(data)")

	local bRet = false 
	local memberWantedQuest = data.quest
	if(not memberWantedQuest)then
		LogUtility.ErrorFormat("ShareAnnounceQuestProxy:RecvUpdateWantedQuestTeamCmd() data.quest is nil")
		return
	end
	local charId = memberWantedQuest.charid
	for i=1,#self.questList do
		local single = self.questList[i]
		if(single.charId == charId)then
			single:updateByServerData(memberWantedQuest)
			bRet = true
			break
		end
	end
	if(not bRet)then
		local data = MemberWantedQuest.new()
		data:updateByServerData(memberWantedQuest)
		table.insert(self.questList,data)
	end
	self:updateHelpQuestIds()
	GameFacade.Instance:sendNotification(QuestEvent.UpdateAnnounceQuestList,memberWantedQuest.questid)
end

function ShareAnnounceQuestProxy:RecvUpdateHelpWantedTeamCmd(data)
	-- helplog("ShareAnnounceQuestProxy:RecvUpdateHelpWantedTeamCmd(data)")
	local dels = data.dellist
	local adds = data.addlist
	if(dels and #dels>0)then
		for i=1,#dels do
			self:removeHelpQuestId(dels[i])
		end
	end
	
	if(adds and #adds>0)then
		for i=1,#adds do
			table.insert(self.helpQuestList,adds[i])	
		end		
	end
	self:updateHelpQuestIds(dels)
end

function ShareAnnounceQuestProxy:RecvQueryHelpWantedTeamCmd(data)
	-- helplog("ShareAnnounceQuestProxy:RecvQueryHelpWantedTeamCmd(data)")
	TableUtility.ArrayClear(self.helpQuestList)
	local questIds = data.questids
	if(questIds and #questIds > 0)then
		for i=1,#questIds do
			local single = questIds[i]
			table.insert(self.helpQuestList,single)
		end
		self:updateHelpQuestIds()
	end
end

function ShareAnnounceQuestProxy:updateHelpQuestIds(removes)
	local array = {}
	local removeArray = removes and removes or {}
	for i=1,#self.helpQuestList do
		local questId = self.helpQuestList[i]
		local ifNeedShow ,memberQuestData = self:checkHelpQuestIsNeedShow(questId)
		-- helplog("updateHelpQuestIds:",ifNeedShow)
		if(ifNeedShow)then
			local wantedData = Table_WantedQuest[questId]
			if(wantedData)then
				local targetText = QuestDataUtil.parseWantedQuestTranceInfo(memberQuestData.questData,wantedData)
				local currentComple =self:getCurrentCompleteMember(questId)
				local totalCount = self:getTotalCountMenber(questId)
				local process = currentComple.."/"..totalCount
				local traceData = {
					type = QuestDataType.QuestDataType_HelpTeamQuest, 
					questDataStepType = wantedData.Content,
					id = questId,
					traceTitle = wantedData.Name,
					whetherTrace = 1,
					map = wantedData.MapId,
					traceInfo = string.format(ZhString.MainViewAddTrace_HelpTeamTraceInfo, targetText,process)
				}
				table.insert(array,traceData)
			else
				table.insert(removeArray,questId)
			end
		else
			table.insert(removeArray,questId)
		end
	end

	if(#removeArray>0)then
		self:removeHelpQuestIds(removeArray)
	end
				
	if(#array>0)then
		QuestProxy.Instance:AddTraceCells(array)
	end
end

function ShareAnnounceQuestProxy:checkHelpQuestIsNeedShow(questId)
	local myTeam = TeamProxy.Instance.myTeam
	if(not myTeam)then
		return
	end
	for i=1,#self.questList do
		local single = self.questList[i]
		local fit = single.action == SceneQuest_pb.EQUESTACTION_ACCEPT
		local memberData = myTeam:GetMemberByGuid(single.charId);
		if(fit and memberData and single.questId == questId)then
			return true,single
		end
	end
end

function ShareAnnounceQuestProxy:getCurrentCompleteMember(questId)
	local count = 0
	for i=1,#self.questList do
		local single = self.questList[i]
		local fit = single.action == SceneQuest_pb.EQUESTACTION_ACCEPT
		local params = single.questData.params
		local isComplete = params.mark_team_wanted == 1
		if(fit and isComplete and single.questId == questId )then
			count = count +1
		end
	end
	return count
end

function ShareAnnounceQuestProxy:getTotalCountMenber(questId)
	local count = #(self:getOnGoTeamMembersByQuestIdAndAction(questId))
	return count
end

function ShareAnnounceQuestProxy:removeHelpQuestIds(dels)
	TableUtility.ArrayClear(tempArray)
	for i=1,#dels do
		local data = {}
		data.id = dels[i]
		data.type = QuestDataType.QuestDataType_HelpTeamQuest
		table.insert(tempArray,data)		
	end
	QuestProxy.Instance:RemoveTraceCells(tempArray)
end

function ShareAnnounceQuestProxy:removeHelpQuestId(questId)
	for i=1,#self.helpQuestList do
		if(self.helpQuestList[i] == questId)then
			table.remove(self.helpQuestList,i)
			break
		end
	end
end

function ShareAnnounceQuestProxy:removeTeamMemberQuest(charId)
	for i=1,#self.questList do
		if(self.questList[i].charId == charId)then
			table.remove(self.questList,i)
			break
		end
	end
end

function ShareAnnounceQuestProxy:getOnGoTeamMembersByQuestIdAndAction(questId)
	-- LogUtility.InfoFormat("getOnGoTeamMembersByQuestIdAndAction:getTeamMembersByQuestIdAndAction() questId:{0},count:{1}",questId,#self.questList)
	TableUtility.ArrayClear(tempArray)
	for i=1,#self.questList do
		local single = self.questList[i]
		local fit = single.action == SceneQuest_pb.EQUESTACTION_ACCEPT
		if(fit and single.questId == questId)then
			table.insert(tempArray,single.charId)
		end
	end
	return tempArray
end

function ShareAnnounceQuestProxy:getAllMembersQuest()
	return self.questList
end

function ShareAnnounceQuestProxy:ExitTeamHandler( note )
	-- body
	local member = note.data;
	if(member)then
		local id = member.id
		self:removeTeamMemberQuest(id)
		self:updateHelpQuestIds()
	end
	GameFacade.Instance:sendNotification(QuestEvent.UpdateAnnounceQuest)
end

function ShareAnnounceQuestProxy:MeExitTeamHandler(  )
	-- body
	TableUtility.ArrayClear(self.questList)
	
	self:updateHelpQuestIds(self.helpQuestList)
	TableUtility.ArrayClear(self.helpQuestList)
	GameFacade.Instance:sendNotification(QuestEvent.UpdateAnnounceQuest)
end

MemberWantedQuest = class("MemberWantedQuest")

function MemberWantedQuest:ctor(charId,questId,action,step)
	if(charId)then
		self:update(charId,questId,action,step)
	end
end

function MemberWantedQuest:updateByServerData(serverData)
	self:update(serverData.charid,serverData.questid,serverData.action,serverData.step,serverData.questdata)
end

function MemberWantedQuest:update(charId,questId,action,step,questDataServer)
	-- LogUtility.InfoFormat("MemberWantedQuest:update charId:{0},questId:{1} ",charId,questId)
	-- LogUtility.InfoFormat("MemberWantedQuest:update action:{0},step:{1} ",action,step)
	self.charId = charId
	self.questId = questId
	self.action = action
	self.step = step
	if(not self.questData)then
		self.questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
		self.questData.notMine = true
	end
	self.questData:updateByIdAndStep(questId,step,questDataServer)

	if(not self.questData.wantedData)then
		LogUtility.ErrorFormat("MemberWantedQuest:update can't find id:{0} in Table_WantedQuest",questId)
	end
end