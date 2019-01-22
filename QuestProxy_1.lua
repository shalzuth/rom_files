QuestProxy = class('QuestProxy', pm.Proxy)
QuestProxy.Instance = nil;
QuestProxy.NAME = "QuestProxy"
autoImport('QuestData')
autoImport('EOtherData')
autoImport("WholeQuestData")
autoImport("TraceData")
--?????????????????????????????????????????????

local tempArray = {}
function QuestProxy:ctor(proxyName, data)
	self.proxyName = proxyName or QuestProxy.NAME
	if(QuestProxy.Instance == nil) then
		QuestProxy.Instance = self
	end
		
	if data ~= nil then
		self:setData(data)
	end

	self.questList = {}
	self.dialogMessage = {}

	self.detailList = {}
	--??????????????????
	self.DailyQuestData = {}

	-- ???????????????
	self.traceDatas = {}

	-- ????????????
	self.fubenQuestMap = {};

	--menu ??????
	self.menuDatas = {}
	self:initMenuQuestReward()
	--test
	-- self:test()
end

function QuestProxy:initMenuQuestReward(  )
	for k,v in pairs(Table_Menu) do
		if(v.Condition.quest and #v.Condition.quest >0 and v.Show == 1)then
			for i=1,#v.Condition.quest do
				local questId = v.Condition.quest[i]
				local id = self:getQuestID(questId)
				local datas = self.menuDatas[id] or {}
				datas[#datas+1] = v
				self.menuDatas[id] = datas
			end
		end
	end
end

function QuestProxy:CleanAllQuest(  )
	-- body
	for k,v in pairs(self.questList) do
		for i = #v,1,-1 do
			FunctionQuest.Me():stopTrigger(v[i])
			ReusableObject.Destroy(v[i])
			v[i] = nil
		end
	end
	GameFacade.Instance:sendNotification(ServiceEvent.QuestQuestList)
end

function QuestProxy:tryRemoveQuestId( id,type )
	-- body
	if(type == nil)then
		type = SceneQuest_pb.EQUESTLIST_ACCEPT
	end
	local list = self.questList[type]
	if(list)then
		for j=1,#list do
			local oldSingle = list[j]
			if(oldSingle.id == id)then
				FunctionQuest.Me():stopTrigger(oldSingle)
				ReusableObject.Destroy(oldSingle)
				table.remove(list,j)
				break;
			end
		end
	end
end

function QuestProxy:QuestQuestList(data)
	-- body
	local type = data.type
	-- helplog("QuestQuestList")
	local list = self.questList[type] or {}
	if(type == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
		list = {}
	end

	-- begin
	-- add:??????data.clear?????????????????????????????????????????????	2018.5.9 zhouxin 
	if(data.clear and #list>0)then
		for k,v in pairs(list) do
			self:tryRemoveQuestId(v.id,type)
		end
		TableUtility.ArrayClear(list);
	end
	-- end

	for i=1,#data.list do
		local single = data.list[i]
		if(single.id ~= 0)then
			self:tryRemoveQuestId(single.id,type)
			local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
			questData:setQuestData(single)
			questData:setQuestListType(type)
			table.insert(list,questData)
			FunctionQuest.Me():handleQuestInit(questData)		
		else
			-- helplog("quest id is 0:")
		end
	end
	self.questList[type] = list
end

function QuestProxy:getDetailDataById( id )
	-- body
	for i=1,#self.detailList do
		local single = self.detailList[i]
		if(single.questId == id)then
			return single,i
		end
	end
end

function QuestProxy:getQuestListInOrder( type ,ifNeedSort)
	-- body
	local questList = {}
	if(self.questList[type])then
		questList = {unpack(self.questList[type])}
		if(ifNeedSort)then
			if(questList ~=nil and #questList ~=0 )then
				table.sort(questList,function (t1,t2)
					if(t1.type == t2.type)then
						if(t1.type == QuestDataType.QuestDataType_WANTED)then
							return t1.time > t2.time
						else		
							return t1.orderId < t2.orderId	
						end			
					elseif(t1.type == QuestDataType.QuestDataType_WANTED)then
						return true
					elseif(t2.type == QuestDataType.QuestDataType_WANTED)then
						return false
					else
						if(t1.type == QuestDataType.QuestDataType_MAIN)then
							return true
						elseif(t2.type == QuestDataType.QuestDataType_MAIN)then
							return false
						else
							return t1.type == QuestDataType.QuestDataType_DAILY
						end
					end
				end)
			end
		end
	end
	return questList
end

function QuestProxy:QuestDialogMessage(data)
	self.dialogMessage.questid = data.questid
	self.dialogMessage.step = data.step
	local message = nil
	local single = nil
	for i=1,#data.messages do
		single = data.messages[i]
		message = DMessage.new(single.speaker,single.message)
		self.dialogMessage.messages = self.dialogMessage.messages or {}
		table.insert(self.dialogMessage.messages,message)
	end
end

function QuestProxy:QuestQuestUpdate(data)
	-- helplog("QuestQuestUpdate")
	local items = data.items
	if(items)then
		for i=1,#items do
			local item = items[i]
			local del = item.del
			local update = item.update
			local type = item.type
			local list = self.questList[type] or {}
			if(del)then
				local delList = {}
				for i=1,#del do
					local single = del[i]
					local questData ,index = self:getQuestDataByIdAndType(single,type)
					if(questData ~=nil)then				
						FunctionQuest.Me():stopTrigger(questData)
						table.remove(list,index)
						table.insert(delList,questData)
						-- printRed("QuestQuestUpdate del")
						-- print(questData.staticData.id)
						-- print(questData.staticData.Name)
					end
				end
				if(#delList ~= 0)then
					GameFacade.Instance:sendNotification(QuestEvent.QuestDelete,delList)
					for i=1,#delList do
						local data = delList[i]
						ReusableObject.Destroy(data)
						delList[i] = nil
					end
				end
			end
			if(update)then
				local addList = {}
				for i=1,#update do
					local single = update[i]
					if(single.id)then
						local oldData ,index = self:getQuestDataByIdAndType(single.id,type)
						if(oldData ~= nil)then
							FunctionQuest.Me():stopTrigger(oldData)
							table.remove(list,index)
							ReusableObject.Destroy(oldData)
						else
							table.insert(addList,single.id)
						end
						local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
						questData:setQuestData(single)
						questData:setQuestListType(type)			
						-- helplog("xxxxadd quest:",questData.id,questData.content,questData.map)
						-- if(questData.staticData)then
							-- helplog("xxxxadd quest:",questData.id,questData.staticData.QuestName)
						-- end
						table.insert(list,questData)
						if(questData.staticData ~=nil)then
							questData:setIfShowAppearAnm(true)
						end
						if(type == SceneQuest_pb.EQUESTLIST_ACCEPT)then
							FunctionQuest.Me():handleAutoQuest(questData)	
							if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_CAMERA)then
								FunctionQuest.Me():handleCameraQuestStart(questData.pos)
							end			
						end
					else
						errorLog("quset id is nil")
					end
				end
				if(#addList ~= 0)then
					EventManager.Me():DispatchEvent(QuestEvent.QuestAdd,addList)
				end
			end
			self.questList[type] = list
		end
	end
end

function QuestProxy:getGuildQuestByContentAndType( content,type )
	if(not content)then
		return
	end
	local result
	local listType = type or SceneQuest_pb.EQUESTLIST_ACCEPT
	local list = self.questList[listType]
	if(list == nil)then
		return
	end

	TableUtility.ArrayClear(tempArray)	

	for i=1,#list do
		local single = list[i]
		if(single.questDataStepType == content and single.type == QuestDataType.QuestDataType_GUILDQUEST)then
			tempArray[#tempArray +1] = tempArray
		end
	end
	
	return tempArray
end

function QuestProxy:getQuestDataByIdAndType( id,type )
	-- body
	if(not id)then
		return
	end
	local result
	local listType = type or SceneQuest_pb.EQUESTLIST_ACCEPT
	local list = self.questList[listType]
	if(list == nil)then
		return
	end
	for i=1,#list do
		local single = list[i]
		if(single.id == id)then
			return single ,i
		end
	end

	for _, questData in pairs(self.fubenQuestMap)do
		if(questData.id == id)then
			return questData
		end
	end
end

function QuestProxy:checkQuestHasAccept( id )
	-- body
	if(not id)then
		return false
	end
	local result = self:getQuestDataByIdAndType(id,SceneQuest_pb.EQUESTLIST_ACCEPT)
	if(result)then
		return true
	end
	result = self:getQuestDataByIdAndType(id,SceneQuest_pb.EQUESTLIST_SUBMIT)
	if(result)then
		return true
	end
	result = self:getQuestDataByIdAndType(id,SceneQuest_pb.EQUESTLIST_COMPLETE)
	if(result)then
		return true
	end
	return false
end


function QuestProxy:GetTraceCellCount( )
	return self.TraceCellCount
end

function QuestProxy:SetTraceCellCount( count )
	self.TraceCellCount = count
end

--???????????????????????????????????????
function QuestProxy:getDialogQuestListByNpcId( npcId ,uniqueid)
	local list = {}
	local sourceTable
	local currentMap = SceneProxy.Instance.currentScene
	--??????????????????npc????????????vist????????????
	-- printRed("getDialogQuestListByNpcId")
	-- printRed(currentMap)
	local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
	if(allData == nil)then
		return list
	end
	sourceTable = allData	

	for i=1,#sourceTable do		
		local single = sourceTable[i]
		if(single.params)then
			local npc = single.params.npc
			if(type(npc) == "table")then
				npc = npc[1]
			end
			if(single.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and npc == npcId)then
				if(single.params.uniqueid==nil or (single.params.uniqueid == uniqueid and currentMap:IsSameMapOrRaid(single.map))) then
					if(self:checkGuildQuest(single) and self:checkCountDownQuest(single))then
						table.insert(list,single)
					end
				end
			end
		else
			printRed("error !!!Quest Params is nil in id:"..single.id)	
		end	
	end

	for key,single in pairs(self.fubenQuestMap)do
		if(single.params)then
			local npc = single.params.npc
			if(type(npc) == "table")then
				npc = npc[1]
			end
			if(single.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and npc == npcId)then
				if(single.params.uniqueid==nil or (single.params.uniqueid == uniqueid)) then
					table.insert(list,single)
				end
			end
		end
	end


	for key,value in pairs(self.traceDatas)do
		for i=1,#value do		
			local single = value[i]
			if(single.params)then
				local npc = single.params.npc
				if(type(npc) == "table")then
					npc = npc[1]
				end
				if(single.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and npc == npcId)then
					if(single.params.uniqueid==nil or (single.params.uniqueid == uniqueid and currentMap:IsSameMapOrRaid(single.map))) then
						if(self:checkGuildQuest(single) and self:checkCountDownQuest(single))then
							table.insert(list,single)
						end
					end
				end
			else
				printRed("error !!!Quest Params is nil in id:"..single.id)	
			end	
		end
	end

	return list
end

function QuestProxy:checkCountDownQuest(questData)
	if(questData and questData.type == QuestDataType.QuestDataType_COUNT_DOWN)then
		local serverT = ServerTime.CurServerTime()/1000
		if(questData.time <= serverT )then
			return false
		end
	end
	return true
end

function QuestProxy:checkGuildQuest(questData)
	if(questData and questData.type == QuestDataType.QuestDataType_GUILDQUEST)then
		local serverT = ServerTime.CurServerTime()/1000
		if(not GuildProxy.Instance:IHaveGuild())then
			return false
		else
			if(questData.time <= serverT )then
				return false
			end
		end 
	end
	return true
end

function QuestProxy:getSymbolDQListByNpcId( npcId ,uniqueid,list)
	list = list or self:getDialogQuestListByNpcId(npcId, uniqueid);
	for i=#list,1,-1 do
		if(list[i] and list[i].staticData)then
			if(list[i].staticData.TraceInfo=="")then
				local right = list[i].staticData.Params and list[i].staticData.Params.symbol==1;
				if(not right)then
					table.remove(list, i);
				end
			else
				local isRaidQuest = list[i].scope == QuestDataScopeType.QuestDataScopeType_FUBEN;
				if(isRaidQuest)then
					table.remove(list, i);
				end
			end
		else
			table.remove(list, i);
		end		
	end
	return list;
end

function QuestProxy:getCollectQuestListByNpcId( npcId )
	return self:getQuestListByIdAndType(npcId, QuestDataStepType.QuestDataStepType_COLLECT);
end

function QuestProxy:getQuestListByIdAndType(npcId, qtype)
	local list = {}
	local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
	if(allData == nil)then
		return
	end
	for i=1,#allData do
		local single = allData[i]
		if(single.questDataStepType == qtype)then
			if qtype == QuestDataStepType.QuestDataStepType_COLLECT and npcId == single.staticData.Params.monster then
				table.insert(list,single)			
			end
		end
	end	
	for _, single in pairs(self.fubenQuestMap)do
		if(single.questDataStepType == QuestDataStepType.QuestDataStepType_COLLECT and npcId == single.params.monster)then
			table.insert(list,single)
		end
	end
	return list
end

--id ??????id
--subgroup ????????????
--    ?????????FinishJump
--    ?????????FailureJump 
function QuestProxy:notifyQuestState( id,subgroup)
	-- body
	local questData = self:getQuestDataByIdAndType(id)
	if(questData and questData.staticData)then
		if(questData.scope == QuestDataScopeType.QuestDataScopeType_FUBEN)then	
			helplog("notify-->QuestState", id);
			ServiceFuBenCmdProxy.Instance:CallFubenStepSyncCmd( id );
		elseif(questData.scope == QuestDataScopeType.QuestDataScopeType_CITY)then
			local questid = questData.id
			local starid = nil
			local step = questData.step
			-- LogUtility.InfoFormat("QuestProxy:notifyQuestState,questId:{0},subgroup:{1},step:{2}",questid,subgroup,step)
			ServiceQuestProxy:CallRunQuestStep(questid,starid,subgroup,step)
		end
	end
end

-- function QuestProxy:dialogQuestComplete(questId)

function QuestProxy:QuestQuestStepUpdate( data )
	-- body
	local questId = data.id
	local questData = self:getQuestDataByIdAndType(questId)
	if(questData == nil )then
		return
	end
	-- helplog("QuestQuestStepUpdate",questId,data.step)
	-- print(questData.staticData.id)
	-- print(questData.staticData.Name)

	local stepChange = false
	FunctionQuest.Me():stopTrigger(questData)	
	if(questData.step ~= data.step)then
		questData:setIfShowAppearAnm(true)
		stepChange = true
	end
	questData:updateByIdAndStep(questId,data.step,data.data)
	FunctionQuest.Me():handleAutoQuest(questData)

	if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_CAMERA)then
		FunctionQuest.Me():handleCameraQuestStart(questData.pos)
	end
	if(stepChange)then
		GameFacade.Instance:sendNotification(ServiceEvent.QuestQuestStepUpdate,data)
	else
		GameFacade.Instance:sendNotification(QuestEvent.ProcessChange,data)
	end
end

function QuestProxy:checkIfNeedStopMissionTrigger(  )
	-- body
	local index = 0
	local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
	if(allData)then
		for i=1,#allData do
			local single = allData[i]
			if(self:checkIfNeedAutoTrigger(single))then
				index = index+1
			end
		end
	end
end

function QuestProxy:checkIfNeedRemoveGuideView(  )
	-- body
	local index = 0
	local closeGuide = true
	local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
	if(allData)then
		for i=1,#allData do
			local single = allData[i]
			if(single.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDE)then
				index = index+1
				local guideId = single.params.guideID
				local guideType = single.params.type
				local guideData = Table_GuideID[guideId]
				if(guideData)then
					local instance = GuideMaskView.getInstance()
					if(guideData.id == instance.currentGuideId )then 
						closeGuide = false
					elseif( guideData.id == (instance.delayQuestData and instance.delayQuestData .params.guideID))then 
						closeGuide = false
					end
				else
					LogUtility.Info("can't find guide data by id:")
				end
			elseif(single.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDECHECK)then
				closeGuide = false
			end
		end
	end
	-- printRed(string.format("checkIfNeedRemoveGuideView index:%s",tostring(index)))
	-- printRed(string.format("checkIfNeedRemoveGuideView closeGuide:%s",tostring(closeGuide)))
	if(closeGuide)then
		-- LogUtility.Info("FunctionGuide.Me():stopGuide()")
		FunctionGuide.Me():stopGuide()
	end
end

function QuestProxy:checkIfNeedAutoExcuteAtInit( questData )
	-- body
	for i=1,#QuestData.AutoExecuteQuestAtInit do
		local single = QuestData.AutoExecuteQuestAtInit[i]
		if(single == questData.questDataStepType)then
			return true
		end
	end
end

function QuestProxy:checkIfNeedAutoTrigger( questData )
	-- body
	for i=1,#QuestData.AutoTriggerQuest do
		local single = QuestData.AutoTriggerQuest[i]
		if(single == questData.questDataStepType)then
			return true
		end
	end
end

function QuestProxy:checkIfNeedEffectTrigger( questData )
	-- body
	for i=1,#QuestData.EffectTriggerStepType do
		local single = QuestData.EffectTriggerStepType[i]
		if(single == questData.questDataStepType)then
			return true
		end
	end
end

--questId
function QuestProxy:isQuestTraceById( questId )
	-- body
	local questData = self:getDetailDataById(questId)
	-- printRed("QuestProxy:isQuestTraceById is trace:")
	-- printRed(questId)
	-- if(questData)then
	-- 	printRed(questData.trace)
	-- end
	if(questData and questData.trace)then
		return true
	elseif(not questData)then
		return true
	end
end

function QuestProxy:isQuestComplete( id )
	local type = SceneQuest_pb.EQUESTLIST_SUBMIT
	local questData ,_ = self:getQuestDataByIdAndType(id,type)
	-- printRed("isQuestComplete")
	-- printRed(id)
	-- TableUtil.Print(questData.id)
	-- print()
	return questData ~= nil
end

--TODO remove
function QuestProxy:getStaticDataById( id,step )
	-- body
	return nil
end

--????????????QuestID,GroupID?????????
function QuestProxy:getAreaTriggerIdByQuestId( id )
	-- body
	local questId = math.floor(id/GameConfig.Quest.ratio)
	local groupId = id - questId*GameConfig.Quest.ratio
	local id = questId*(GameConfig.Quest.ratio+1)+groupId
	return id
end

function QuestProxy:isMainQuestCompleteByStepId( orderid )
	-- body
	local type = SceneQuest_pb.EQUESTLIST_ACCEPT
	local list = self.questList[type]
	for i=1,#list do
		local single = list[i]
		if(single.type == QuestDataType.QuestDataType_MAIN)then
			if single.orderId > orderid then 
				return true
			else
				return false
			end
		end
	end
	return true
end

function QuestProxy:getWholeQuestDataInList( list,storyId )
	-- body
	for k,v in pairs(list) do
		for i=1,#v do
			local single = v[i]
			if(single.questId  == storyId)then
				return single
			end
		end
	end
end

function QuestProxy:checkLevelInRange( cur,min,max )
	-- body
	if(cur < min or cur > max)then
		return false
	else
		return true
	end
end

function QuestProxy:getWantedQuest(  )
	-- body
	-- body
	local list = {}
	local typeList = {	
		SceneQuest_pb.EQUESTLIST_COMPLETE,
		SceneQuest_pb.EQUESTLIST_ACCEPT,
		SceneQuest_pb.EQUESTLIST_SUBMIT,
		SceneQuest_pb.EQUESTLIST_CANACCEPT,
	}
	local userData = Game.Myself.data.userdata
	local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)

	for i=1,#typeList do
		local questType = typeList[i]
		local questList = self.questList[questType]
		if(questList)then
			for j=1,#questList do
				local single = questList[j]
				if(single.type == QuestDataType.QuestDataType_WANTED)then
					-- printRed(string.format("WantedQuest:%s,name:%s,type:%s",tostring(single.id),tostring(single.staticData.Name),tostring(questType)))
					local minLevel = 0
					local maxLevel = 9999
					if(single.wantedData)then
						minLevel = single.wantedData.LevelRange[1]
						maxLevel = single.wantedData.LevelRange[2]
					end
					if(questType == SceneQuest_pb.EQUESTLIST_CANACCEPT and self:checkLevelInRange(nowRoleLevel,minLevel,maxLevel))then
						local tmpData = self:getWantedQuestDataByIdAndType(single.id,SceneQuest_pb.EQUESTLIST_SUBMIT)						
						if(not tmpData)then
							tmpData = QuestProxy.getWantedQuestDataById(single.id,list)
							if(not tmpData)then
								table.insert(list,single)
								-- printRed(#list)
							-- elseif (tmpData.time < single.time)then
								-- table.insert(list,single)
							end
						end
						-- if(not tmpData)then				
						-- 	table.insert(list,single)
						-- elseif (tmpData.time < single.time)then
						-- 	table.insert(list,single)
						-- end
					else
						-- printRed("other",#list)
						if(questType == SceneQuest_pb.EQUESTLIST_SUBMIT and self:checkLevelInRange(nowRoleLevel,minLevel,maxLevel))then
							table.insert(list,single)
						elseif(questType ~= SceneQuest_pb.EQUESTLIST_SUBMIT)then
							table.insert(list,single)
						end
					end			
				end
			end
		end
	end
	-- local questTable = {}
	-- local questList = self.questList[SceneQuest_pb.EQUESTLIST_CANACCEPT]
	-- if(questList)then
	-- 	-- printRed(#questList)
	-- 	for i=1,#questList do
	-- 		local single = questList[i]
	-- 		if(single.type == QuestDataType.QuestDataType_WANTED)then
	-- 			-- printRed("questId"..single.id)
	-- 			local tmpData,index = QuestProxy.getWantedQuestDataById(single.id,list)
	-- 			if(tmpData)then
	-- 				table.insert(questTable,tmpData)
	-- 				table.remove(list,index)
	-- 			end
	-- 		end
	-- 	end
	-- end
	-- for i=1,#list do
	-- 	table.insert(questTable,list[i])
	-- end

	table.sort(list,function ( l,r )
		-- body
		local lAct = l.wantedData.IsActivity or 0
		local rAct = r.wantedData.IsActivity or 0
		if(lAct ==  rAct)then
			return l.id > r.id
		else
			return lAct > rAct
		end
	end)
	return list
end

function QuestProxy:getWantedQuestDataByIdAndType( id,type )
	-- body
	local questList = self.questList[type]
	if(questList)then
		for j=1,#questList do
			local single = questList[j]
			if(single.type == QuestDataType.QuestDataType_WANTED and id == single.id)then
				return single
			end
		end
	end
end

function QuestProxy.getWantedQuestDataById( id,list )
	-- body
	if(list)then
		for j=1,#list do
			local single = list[j]
			if(id == single.id)then
				return single,j
			end
		end
	end
end

function QuestProxy:getIllustrationQuest(mapId)
	local type = SceneQuest_pb.EQUESTLIST_ACCEPT
	local list = QuestProxy.Instance.questList[type]
	-- printRed("hasIllustrationQuest")
	-- printRed(mapId)
	if(list) then
		for i=1,#list do
			local single = list[i]
			-- printRed(single.questDataStepType)
			-- printRed(single.map)
			if(single.questDataStepType == QuestDataStepType.QuestDataStepType_ILLUSTRATION and single.map == mapId)then
				return single
			end
		end
	end
end

function QuestProxy:getQuestListByMapAndSymbol( mapId )
	-- body
	local type = SceneQuest_pb.EQUESTLIST_ACCEPT
	local list = QuestProxy.Instance.questList[type]
	-- printRed("hasIllustrationQuest")
	-- printRed(mapId)
	local resultList = {}
	if(list) then
		for i=1,#list do
			local single = list[i]
			-- printRed(single.questDataStepType)
			-- printRed(single.map)
			if(single.map and single.map == mapId and single.staticData)then
				if(single.params and (single.params.symbol or single.staticData.TraceInfo~=""))then
					if(self:checkGuildQuest(single) and self:checkCountDownQuest(single))then
						resultList[#resultList+1] = single
					end
				end
			end
		end
	end
	return resultList
end

function QuestProxy:getDailyQuestData( type )
	-- body
	return self.DailyQuestData[type]
end

function QuestProxy:setDailyQuestData( data )
	-- body
	local type = data.type
	local eOtherData = EOtherData.new(data.data)
	self.DailyQuestData[type] = eOtherData
end

function QuestProxy:AddTraceCells(cells)
	if(cells)then
		for i=1,#cells do
			local single = cells[i]
			self:AddTraceCell(single)
		end
	end
end

--???????????????
function QuestProxy:AddTraceCell(traceData)
	-- body
	local traceCell = self:GetTraceCell(traceData.type,traceData.id)
	if(not traceCell)then
		traceCell = TraceData.new()
		traceCell:UpdateByTraceData(traceData)
		local list = self.traceDatas[traceData.type] or {}
		table.insert(list,traceCell)
		self.traceDatas[traceData.type] = list
		FunctionQuest.Me():addTraceView(traceCell)
	else
		traceCell:UpdateByTraceData(traceData)
		FunctionQuest.Me():updateTraceView(traceCell)
	end
end

function QuestProxy:RemoveTraceCell( type,id )
	-- body
	local traceCell,index = self:GetTraceCell(type,id)
	local list = self.traceDatas[type]
	if(list and traceCell)then
		table.remove(list,index)
		FunctionQuest.Me():removeTraceView(traceCell)
	end
end

function QuestProxy:RemoveTraceCells( datas )
	-- body
	if(datas and #datas>0)then
		for i=1,#datas do
			local data = datas[i]
			local type = data.type
			local id = data.id
			self:RemoveTraceCell(type,id)
		end
	end	
end

function QuestProxy:GetTraceCell( type,id )
	-- body
	local list = self.traceDatas[type]
	if(list and #list>0)then
		for i=1,#list do
			local single = list[i]
			if(single.id == id )then
				return single,i
			end
		end
	end
end

function QuestProxy:UpdateTraceProcess( type,id,process )
	-- body
	local traceCell,index = self:GetTraceCell(type,id)
	if(traceCell)then
		traceCell.process = process
		FunctionQuest.Me():updateTraceView(traceCell)
	end
end

function QuestProxy:UpdateTraceInfo( type,id,traceInfo )
	-- body
	local traceCell,index = self:GetTraceCell(type,id)
	if(traceCell)then
		traceCell.traceInfo = traceInfo
		FunctionQuest.Me():updateTraceView(traceCell)
	end
end

function QuestProxy:hasQuestAccepted( questId )
	-- body
	local type = SceneQuest_pb.EQUESTLIST_ACCEPT
	local list = QuestProxy.Instance.questList[type]
	if(list) then
		for i=1,#list do
			local single = list[i]
			if(single.id == questId)then
				return true
			end
		end
	end
end

function QuestProxy:getTraceDatas(  )
	-- body
	local list = {}
	for k,v in pairs(self.traceDatas) do
		if(v and #v>0)then
			for i=1,#v do
				local single = v[i]
				table.insert(list,single)
			end
		end
	end
	return list
end

function QuestProxy:isInWantedQuestInActivity(  )
	-- body
	if(self.maxWantedCount and self.maxWantedCount~=0)then
		return true
	end
	-- return true
end

function QuestProxy:setMaxWanted( data )
	-- body
	local maxcount = data.maxcount
	self.maxWantedCount = maxcount
end

function QuestProxy:getMaxWanted(  )
	-- body
	if(self.maxWantedCount and self.maxWantedCount~=0)then
		return self.maxWantedCount;
	end

	local maxWantedConfig = GameConfig.Quest.maxwanted;
	if(type(maxWantedConfig) == "table")then
		for i=1,#maxWantedConfig do
			if(maxWantedConfig[i][1] == 0)then
				return maxWantedConfig[i][2];
			end
		end
	else
		return maxWantedConfig;
	end
end

function QuestProxy:getTraceDatasByType( type )
	-- body
	return self.traceDatas[type]
end

function QuestProxy:hasGoingWantedQuest(  )
	-- body
	return self.hasGoingQuest
end

function QuestProxy:setGoingWantedQuest( result )
	-- body
	self.hasGoingQuest = result
end

function QuestProxy:isQuestCanBeShowTrace( type )
	-- body
	for i=1,#QuestData.NoTraceQuestDataType do
		local single = QuestData.NoTraceQuestDataType[i]
		if(single == type)then
			return false
		end
	end
	return true
end

function QuestProxy:getWantedQuestRatio( submitCount )
	-- body
	local ratio
	
	submitCount = submitCount or MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
	if(not submitCount)then
		submitCount = 0
	end
	local ratio = GameConfig.Quest.proportion[submitCount+1]
	-- printRed("??????????????????"..submitCount)
	if(not ratio)then
		ratio = GameConfig.Quest.proportion[#GameConfig.Quest.proportion]
		printRed("can't find ratio by complete count:Var_pb.EVARTYPE_QUEST_WANTED:",submitCount)
	end
	return ratio
end

function QuestProxy:updateFubenQuestData( dataId, delete, raidConfig )
	-- helplog("updateFubenQuestData", dataId, delete, raidConfig);
	local questData = self.fubenQuestMap[dataId];
	if(delete)then
		self:removeFubenQuestData(dataId);
	else
		if(not questData)then
			questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_FUBEN);
			self.fubenQuestMap[dataId] = questData;

			questData:updateRaidData(dataId,raidConfig)
			questData.map = Game.MapManager:GetMapID()

			if(not questData.staticData)then
				errorLog(string.format("QuestProxy:updateFubenQuestData,can't find in Table_Raid by id:%s",tostring(dataId)))
			else
				FunctionQuest.Me():handleAutoTrigger(questData)
				FunctionQuest.Me():handleAutoExcute(questData)				
				if(questData.staticData and questData.staticData.WhetherTrace ~= 1
					and self:checkIsShowDirAndDisByQuestType(questData.questDataStepType))then
					local pos = questData.pos
					pos = pos and pos or FunctionQuestDisChecker.Me():getDestPostByUniqueId( questData.params.uniqueid )
					if(pos)then
						helplog("updateFubenQuestData",questData.id)
						FunctionQuestDisChecker.Me():AddQuestCheck({questData=questData})
						FunctionQuest.Me():addQuestMiniShow( questData )
					end
				end
			end
		end
	end
end

function QuestProxy:getTraceFubenQuestData()
	for _,questData in pairs(self.fubenQuestMap)do
		if(questData.staticData)then
			local traceInfo = questData.staticData.TraceInfo;
			if(traceInfo ~= nil and traceInfo ~= "")then
				return questData;
			end
		else
			-- helplog("QuestData id:",questData.id)
		end
	end
end

function QuestProxy:removeFubenQuestData( step )
	local questData = self.fubenQuestMap[step];
	if(questData)then
		FunctionQuest.Me():stopTrigger(questData);
		FunctionQuest.Me():stopQuestMiniShow( questData )
		ReusableObject.Destroy(questData)
		self.fubenQuestMap[step] = nil;
	end

end

function QuestProxy:clearFubenQuestData()
	for key, data in pairs(self.fubenQuestMap)do
		FunctionQuest.Me():stopTrigger(data);
		FunctionQuest.Me():stopQuestMiniShow(data)
		ReusableObject.Destroy(data)
		self.fubenQuestMap[key] = nil;
	end

end

function QuestProxy:checkIsShowDirAndDisByQuestType( type )
	-- body
	for i=1,#QuestData.NoDirAndDisStepType do
		local single = QuestData.NoDirAndDisStepType[i]
		if(single == type)then
			return false
		end
	end
	return true
end

function QuestProxy:checkIsShowDirAndDisByQuestId( id )
	-- body
	local questData = self:getQuestDataByIdAndType(id)
	if(questData)then
		return self:checkIsShowDirAndDis(questData)
	end
end

function QuestProxy:checkIsShowDirAndDis( questData )
	-- body
	if(questData)then
		local bRet = false
		local traceStr = questData:parseTranceInfo()
		-- LogUtility.InfoFormat("checkIsShowDirAndDis str:{0},map:{1},whether:{2}",traceStr,questData.map,questData.whetherTrace)
		if(traceStr ~= "" and self:checkIsShowDirAndDisByQuestType(questData.questDataStepType) and questData.whetherTrace == 1)then
			bRet = true
		end
		
		return bRet
	end
end

function QuestProxy:checkCanExcuteWhenDead( questData )
	-- body
	if(questData)then
		local type = questData.questDataStepType
		for i=1,#QuestData.CanExecuteWhenDeadStepType do
			local single = QuestData.CanExecuteWhenDeadStepType[i]
			if(single == type)then
				return true
			end
		end
		return false
	end
end

function QuestProxy:checkUpdateWithItemUpdate( questData )
	-- body
	if(questData)then
		local type = questData.questDataStepType
		for i=1,#QuestData.ItemUpdateStepType do
			local single = QuestData.ItemUpdateStepType[i]
			if(single == type)then
				return true
			end
		end
		return false
	end
end

function QuestProxy:addOrRemoveLockMonsterGuide( data )
	-- body
	if(not self.guideList)then
		self.guideList = {}
	end

	if data then
		self.guideList[data.questId] = data.monsterId
	end
end

function QuestProxy:checkIfShowMonsterNamePre( questData )
	-- body
	if(questData and self:checkIsShowDirAndDis(questData))then
		local type = questData.questDataStepType
		for i=1,#QuestData.ShowTargetNamePrefixStepType do
			local single = QuestData.ShowTargetNamePrefixStepType[i]
			if(single == type)then
				return true
			end
		end
	end
	return false
end

function QuestProxy:getQuestID(questId)
	return math.floor(questId/GameConfig.Quest.ratio)
end

function QuestProxy:getValidReward(questData)
	local questId = questData.id
	local id = self:getQuestID(questId)
	-- local groupId = questId - id*GameConfig.Quest.ratio
	-- local id = questId*(GameConfig.Quest.ratio+1)+groupId
	return self.menuDatas[id]
	-- local menuData = self.menuQuestData[questData].
end

function QuestProxy:getValidAcceptQuestList(isTrace)
	local questDataList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_ACCEPT)
	local list = {}
	for i=1,#questDataList do
		local single = questDataList[i]
		if(single.staticData)then
			-- local isTrace = QuestProxy.Instance:isQuestTraceById(single.staticData.QuestID)
			-- if(single.id == 311110001 or single.id == 311110002)then
			-- 	self:Log("print questData start")
			-- 	self:Log(isTrace)
				-- self:Log(single.id,single.staticData.TraceInfo,single.step,single.questDataStepType)
				-- self:Log(single.questListType)
				-- local params = single.params
				-- for k,v in pairs(params) do
				-- 	helplog(k,v)
					-- if(k == "dialog")then
					-- 	helplog("size:",#v)
					-- end

					-- if(k == "dialog")then
					-- 	for j=1,#v do
					-- 		helplog("dialog id:",v[j])
					-- 	end
					-- end
				-- end
				-- self:Log(single.step)
				-- self:Log(single.questDataStepType)
				-- self:Log(single.type)
				-- self:Log(single.staticData.QuestName)
				-- if(single.questDataStepType == "item")then
					-- for k,v in pairs(params) do
					-- 	helplog(k,v)
					-- end
				-- end
			-- 	self:Log(single.staticData.FirstClass)
			-- 	self:Log("print questData end")		
			-- end
			local questType = single.type
			local validQuest = QuestProxy.Instance:checkGuildQuest(single)
			if(questType == QuestDataType.QuestDataType_GUILDQUEST and validQuest)then
				Game.QuestGuildManager:AddQuestEffect(single)
			end

			validQuest = QuestProxy.Instance:checkCountDownQuest(single)
			if(questType == QuestDataType.QuestDataType_COUNT_DOWN and validQuest)then
				Game.QuestCountDownManager:AddQuestEffect(single)
			end
			local bFilterCt = single.staticData.TraceInfo ~= "" and validQuest
			if(isTrace ~= nil)then
				bFilterCt = bFilterCt and single.trace == isTrace
			end
			if(bFilterCt)then
				if(single.staticData.FirstClass == destProfession )then
					table.insert(list,single)
				elseif(QuestProxy.Instance:isQuestCanBeShowTrace(questType))then
					table.insert(list,single)
				end
			end
		end
	end
	if(isTrace == nil)then
		table.sort(list,function (t1,t2)
		    local lv1 = t1.staticData.Level or 0
			local lv2 = t2.staticData.Level or 0
			if(lv1 == lv2)then
				return t1.time > t2.time
			else
				return lv1 > lv2
			end
		end)
	end
	return list
end

function QuestProxy:getLockMonsterGuideByMonsterId( monsterId )
	-- body
	if self.guideList then
		TableUtility.ArrayClear(tempArray)	
		for k,v in pairs(self.guideList) do
			if(monsterId == v)then
				tempArray[#tempArray+1] = k
			end
		end
		-- helplog("getLockMonsterGuideByMonsterId ",#tempArray)
		return tempArray
	end
end

function QuestProxy:checkWantedQuestIsMarkedTeam( questId,step )
	-- body
	if self.guideList then
		TableUtility.ArrayClear(tempArray)	
		for k,v in pairs(self.guideList) do
			if(monsterId == v)then
				tempArray[#tempArray+1] = k
			end
		end
		-- helplog("getLockMonsterGuideByMonsterId ",#tempArray)
		return tempArray
	end
end