FunctionQuest = class("FunctionQuest",EventDispatcher)
autoImport("GuideMaskView")
FunctionQuest.UpdateTraceInfo = "MAINVIEWTASKQUESTPAGE_UPDATETRACEINFO"
FunctionQuest.RemoveTraceInfo = "MAINVIEWTASKQUESTPAGE_REMOVETRACEINFO"
FunctionQuest.AddTraceInfo = "MAINVIEWTASKQUESTPAGE_ADDTRACEINFO"

FunctionQuest.DefaultTriggerInfinite = 99999
FunctionQuest.DefaultEffectTriggerInfinite = 20


local cmdArgs = {}

function FunctionQuest.Me()
	if nil == FunctionQuest.me then
		FunctionQuest.me = FunctionQuest.new()
	end
	return FunctionQuest.me
end

function FunctionQuest:ctor()
	self.triggerCheck = Game.AreaTrigger_Mission
	self.iconAtlas = {
		"itemIcon",
		"skillIcon",
		"uiIcon",
		"npcIcon",
	}
end

function FunctionQuest:handleCameraQuestStart( pos )
	-- body
	local temp = GameObject("Temp");
	temp.transform.position = pos
	self.go = temp
	if(not FunctionCameraEffect.Me():Bussy())then
		self.cft = CameraEffectFocusTo.new(temp.transform, CameraConfig.NPC_Dialog_ViewPort, 0.6,
			function ()
				LeanTween.delayedCall(temp,1,
					function ()
						self:handleCameraquestEnd()
					end):setDestroyOnComplete(true);
			end);
		FunctionCameraEffect.Me():Start(self.cft)
	end
end

function FunctionQuest:handleCameraquestEnd( msg )
	-- body
	FunctionCameraEffect.Me():End(self.cft);
	self.cft = nil;
	LeanTween.cancel(self.go)
	GameObject.Destroy(self.go)
	self.go = nil;
end

function FunctionQuest:test(  )
	-- body
	local datas = {}
	datas.items = {}
	local data = {}
	
-- card
-- 	data = {}
-- 	data.id = 20011
-- 	data.count = 2
-- 	table.insert(datas.items,data)

-- 	data = {}
-- 	data.id = 20015
-- 	data.count = 1
-- 	table.insert(datas.items,data)

-- 	data = {}
-- 	data.id = 20017
-- 	data.count = 1
-- 	table.insert(datas.items,data)
-- -- 2d item
-- 	data = {}
-- 	data.id = 40601
-- 	data.count = 1
-- 	table.insert(datas.items,data)

-- 	data = {}
-- 	data.id = 100
-- 	data.count = 1
-- 	table.insert(datas.items,data)

-- 	data = {}
-- 	data.id = 105
-- 	data.count = 1
-- 	table.insert(datas.items,data)

-- 	data = {}
-- 	data.id = 110
-- 	data.count = 1
-- 	table.insert(datas.items,data)

	-- data = {}
	-- data.id = 125
	-- data.count = 1
	-- table.insert(datas.items,data)

	-- data = {}
	-- data.id = 300
	-- data.count = 1
	-- table.insert(datas.items,data)

	-- data = {}
	-- data.id = 400
	-- data.count = 1
	-- table.insert(datas.items,data)

	-- data = {}
	-- data.id = 450
	-- data.count = 1
	-- table.insert(datas.items,data)

	-- data = {}
	-- data.id = 1002
	-- data.count = 1
	-- table.insert(datas.items,data)


	-- data = {}
	-- data.id = 3011
	-- data.count = 1
	-- table.insert(datas.items,data)

	-- data = {}
	-- data.id = 1002
	-- data.count = 1
	-- table.insert(datas.items,data)

	data = {}
	data.id = 40301
	data.count = 2
	table.insert(datas.items,data)

	ServiceItemProxy.Instance:RecvItemShow(datas)

	-- local str = "{icon = \'skill_35001\',text = \'icon帽\'}"

	-- data = {}
	-- data.type =2
	-- data.data = str

	-- ServiceNUserProxy.Instance:RecvModelShow(data)

	-- str = "{icon = \'113\',text = \'技能\'}"
	-- data = {}
	-- data.type = 3
	-- data.data = str

	-- ServiceNUserProxy.Instance:RecvModelShow(data)
	-- str = "{icon = \'icon_5_2\',text = \'职业\'}"
	-- data = {}
	-- data.type = 4
	-- data.data = str
	
	-- ServiceNUserProxy.Instance:RecvModelShow(data)

	-- local list =  {}

	-- for i=1,5 do
	-- 	local data = {}
	-- 	if(i%2 == 0)then
	-- 		data.type = QuestDataType.QuestDataType_INVADE
	-- 	else
	-- 		data.type = QuestDataType.QuestDataType_INVADE
	-- 	end
	-- 	data.id = 1+i
	-- 	data.questDataStepType = QuestDataStepType.QuestDataStepType_MOVE
	-- 	data.traceTitle = "物品追踪"
	-- 	data.map = 2
	-- 	data.pos = LuaVector3(-26.64,0,46)
	-- 	data.params = {pos={-26.64,0,46},distance=2}
	-- 	data.process = 0.3
	-- 	table.insert(list,data)
	-- end
	-- QuestProxy.Instance:AddTraceCells(list)
end

local questStepOnFunc = function (questId)
	helplog("quest StepOn", questId);
	QuestProxy.Instance:notifyQuestState(questId);
end
function FunctionQuest:executeQuest( questData )
	-- printRed("executeQuest content:"..questData.questDataStepType)
	-- printRed("executeQuest id:"..questData.id)
	-- if(true)then
	-- 	self:test()
	-- 	return
	-- end

	local isInHand,master= Game.Myself:IsHandInHand()
	if(isInHand and not master)then
		MsgManager.ShowMsgByID(824)
		return
	end	

	local isDead = Game.Myself:IsDead()
	if(isDead and not QuestProxy.Instance:checkCanExcuteWhenDead(questData))then
		MsgManager.ShowMsgByID(2500)
		return
	end

	if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_LEVEL)then
		return
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_WAIT)then
		return	
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDE)then
		local guideType = questData.params.type
		if(guideType == QuestDataGuideType.QuestDataGuideType_explain)then
			FunctionGuide.Me():stopGuide(  )
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.GuidePanel, viewdata = {questData = questData}})
		else
			FunctionGuide.Me():showGuideByQuestData(questData)
		end	
		return	
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_CLIENT_PLOT)then
		local plotid = questData.params.id;
		if(plotid)then
			Game.PlotStoryManager:Start( plotid, questStepOnFunc, questData.id )
		end
		return;
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_PLAY_CG)then
		local id = questData.params.id
		local video = Table_Video[id]
		if(video)then
			QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
			helplog("此处应该播一段视频:",video.Name)
			LuaUtils.PlayMovie(video.Name,true)
		else
			helplog("未找到该视频任务配置Table_View,id=",id)
		end
		return;
	else
		-- cmd
		if(self.cmdData and self.cmdData.id == questData.id)then
			if(self.cmdData.step == questData.step)then
				return
			end
		end

		local sameNpcVisit = self:handleVisitQuest(questData)
		if(sameNpcVisit)then
			return
		end

		TableUtility.TableClear(cmdArgs)
		cmdArgs.targetMapID = questData.map
		cmdArgs.targetPos = questData.pos
		cmdArgs.distance = questData.params.distance
		if(questData.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO)then
			cmdArgs.customType = AccessCustomType.Quest
			cmdArgs.custom = questData.id
		end
		cmdArgs.callback = function ( cmd,event )
			-- body
			self:missionCallback(cmd,event)
		end

		local cmdClass = nil
		local questStepType = questData.questDataStepType
		if(QuestDataStepType.QuestDataStepType_VISIT == questStepType)then
			cmdArgs.npcUID = questData.params.uniqueid
			if nil == cmdArgs.npcUID then
				if type(questData.params.npc) == "table" then
					cmdArgs.npcID = questData.params.npc[1]
				else
					cmdArgs.npcID = questData.params.npc
				end
			end
			cmdClass = MissionCommandVisitNpc
		elseif(QuestDataStepType.QuestDataStepType_KILL == questStepType)then
			cmdArgs.groupID = questData.params.groupId
			cmdArgs.npcID = questData.params.monster
			cmdArgs.npcUID = questData.params.uniqueid
			cmdClass = MissionCommandSkill
		elseif(QuestDataStepType.QuestDataStepType_COLLECT == questStepType)then
			cmdArgs.groupID = questData.params.groupId
			cmdArgs.npcID = questData.params.monster
			cmdArgs.skillID = GameConfig.NewRole.riskskill[1]
			cmdArgs.npcUID = questData.params.uniqueid
			cmdClass = MissionCommandSkill
		elseif(QuestDataStepType.QuestDataStepType_USE == questStepType)then
			cmdClass = MissionCommandMove
		elseif(QuestDataStepType.QuestDataStepType_SELFIE == questStepType)then
			cmdClass = MissionCommandMove
		elseif(QuestDataStepType.QuestDataStepType_GATHER == questStepType)then
			cmdArgs.npcID = questData.params.monster
			cmdArgs.groupID = questData.params.groupId
			cmdArgs.npcUID = questData.params.uniqueid
			cmdClass = MissionCommandSkill
		elseif(QuestDataStepType.QuestDataStepType_MOVE == questStepType)then	
			cmdClass = MissionCommandMove
		elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK)then
			if(cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil)then
				self:executeTalkQuest(questData)
			else
				cmdClass = MissionCommandMove
				self:handleAutoTrigger(questData)
			end
		elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_RAID)then
			-- helplog("ServiceQuestProxy.Instance:CallQuestRaidCmd",questData.id)
			if(cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil)then
				ServiceQuestProxy.Instance:CallQuestRaidCmd(questData.id)
			else
				cmdClass = MissionCommandMove
				self:handleAutoTrigger(questData)
			end
		elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_DAILY)then
			if(cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil)then
				return
			else
				cmdClass = MissionCommandMove
			end
		elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_ITEM)then
			if(cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil)then
				return
			else
				local creatureId = questData.params.monster
				cmdArgs.npcID = creatureId
				cmdArgs.npcUID = questData.params.uniqueid
				if( creatureId and Table_Monster[creatureId])then
					cmdArgs.groupID = questData.params.groupId
					cmdClass = MissionCommandSkill
				elseif(creatureId and Table_Npc[creatureId])then
					cmdClass = MissionCommandVisitNpc
				end
			end
		elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_SEAL)then
			if(cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil)then
				return
			else
				cmdArgs.npcUID = questData.params.uniqueid
				if nil == cmdArgs.npcUID then
					if type(questData.params.npc) == "table" then
						cmdArgs.npcID = questData.params.npc[1]
					else
						cmdArgs.npcID = questData.params.npc
					end
				end
				cmdClass = MissionCommandVisitNpc
			end
		elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER)then
			self:handleAutoTrigger(questData)
			cmdClass = MissionCommandMove
		end

		if nil ~= cmdClass then
			-- :clonePartData()
			local cmd = MissionCommandFactory.CreateCommand(cmdArgs, cmdClass)	
			Game.Myself:Client_SetMissionCommand(cmd)
		end

		TableUtility.TableClear(cmdArgs)
	end	
end

function FunctionQuest:getCurCmdData(  )
	-- body
	return self.cmdData
end

function FunctionQuest:stopCurrentCmd( questData )
	-- body
	if(self.cmdData and self.cmdData.id == questData.id)then
		if(self.cmdData.step == questData.step)then
			self.cmdData = nil
		end
	end
	
end

function FunctionQuest:missionCallback( cmd,event )
	-- body
	-- local questId = cmd.args.custom
	-- local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
	-- if(event == MissionCommand.CallbackEvent.Launch)then
	-- 	self.cmdData = questData
	-- 	GameFacade.Instance:sendNotification(MissionCommandEvent.MissionCommandEvent,{isOngoing = true,questDt = questData})
	-- else
	-- 	self.cmdData = nil
	-- 	GameFacade.Instance:sendNotification(MissionCommandEvent.MissionCommandEvent,{isOngoing = false,questDt = questData})
	-- 	self:handleMissShutdown(questId)
	-- end
end

function FunctionQuest:handleMissShutdown( questId )
	-- body
	-- if(questData)then
	-- 	if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK)then
			
	-- 	end
	-- end
end

function FunctionQuest:executeTalkQuest( questData )
	-- body
	local viewdata = {
		viewname = "DialogView",
		dialoglist = questData.params.dialog,
		callbackData = questData.id,
		questId = questData.id,
		callback = function (questId, optionid,state)
			if(state)then
				QuestProxy.Instance:notifyQuestState(questId,optionid)
			else
				local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
				if(questData)then
					QuestProxy.Instance:notifyQuestState(questId,questData.staticData.FailJump)
				end
			end
		end
	}
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata);
end

function FunctionQuest:handleAutoTrigger(questData)
	local qData = questData
	if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_USE)then
		local questParam
		for i=1,#self.iconAtlas do
			questParam = questData.params[self.iconAtlas[i]]
			-- helplog("AddQuickUseCheck QuestDataStepType_USE quest1:",questParam,self.iconAtlas[i],questData.params.button)
			if(questParam) then
				-- helplog("AddQuickUseCheck QuestDataStepType_USE quest2 id:",questData.id,tostring(questData.map),tostring(questData.pos),qData.params.name,questData.params.distance)
				self.triggerCheck:AddQuickUseCheck(questData.id,questData.map,questData.pos,questData.params.distance,self.iconAtlas[i],questParam,qData.params.name,questData.params.button,qData)
				break
			end
		end
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_SELFIE )then
		if(questData.params.itemIcon ~= nil)then
			-- helplog("AddQuickUseCheck QuestDataStepType_SELFIE quest id:",questData.id,questData.map,questData.pos,questData.params.distance)
			self.triggerCheck:AddQuickUseCheck(questData.id,questData.map,questData.pos,questData.params.distance,"itemIcon",questData.params.itemIcon,qData.params.name,questData.params.button,qData)
		end
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_MOVE )then
		-- if(questData.params.itemIcon ~= nil)then
			-- printRed("autoTrigger4")
			local func = function ( owner,questData  )
				-- body

				-- helplog("QuestDataStepType_MOVE callback QuestProxy.Instance:notifyQuestState move:",questData.id)
				if(questData and questData.staticData)then
					QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
				end
				-- printRed("self:notifyQuestState(questData.id)")
			end
			-- helplog("AddQuickUseCheck QuestDataStepType_MOVE quest id:",questData.id,questData.map,questData.pos,questData.params.distance)
			self.triggerCheck:AddCallBackCheck(questData.id,questData.map,questData.pos,questData.params.distance,qData,nil,func)
		-- end
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK )then		
		if( questData.map == nil and questData.pos ~=nil)then
			-- errorLog(" talk quest map is nil ;questId:"..questData.id)
		elseif(questData.map == nil and questData.pos ==nil)then
			-- errorLog(" talk quest map is nil ,pos is nil;questId:"..questData.id)
		else
			if(not questData.pos and questData.params.distance )then
				errorLog("pos is nil but distance is:"..questData.params.distance)
			end
			local func = function ( owner,questData  )
				-- helplog("executeTalkQuest id:",questData.id)
				if(questData and questData.staticData)then
					self:executeTalkQuest(questData)
				end
				
			end
			self.triggerCheck:AddCallBackCheck(questData.id,questData.map,questData.pos,
				questData.params.distance or FunctionQuest.DefaultTriggerInfinite,qData,nil,func)
		end
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_RAID )then		
		if( questData.map == nil and questData.pos ~=nil)then
			-- errorLog(" RAID quest map is nil ;questId:"..questData.id)
		elseif(questData.map == nil and questData.pos ==nil)then
		else
			if(not questData.pos and questData.params.distance )then
				-- errorLog("pos is nil but distance is:"..questData.params.distance)
			end
			local func = function ( owner,questData  )
				ServiceQuestProxy.Instance:CallQuestRaidCmd(questData.id)
			end
			self.triggerCheck:AddCallBackCheck(questData.id,questData.map,questData.pos,
				questData.params.distance or FunctionQuest.DefaultTriggerInfinite,qData,nil,func)
		end
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER )then
		
		local enter = function ( owner,questData  )
			if(questData)then
				local guideId = questData.params.guideID
				local guideData = Table_GuideID[guideId]
				local bubbleId = guideData.BubbleID
				if(bubbleId and Table_BubbleID[bubbleId])then		
					-- helplog("ShowAutoFightBubble: true",questData.id)	
					GameFacade.Instance:sendNotification(GuideEvent.ShowAutoFightBubble, {bubbleId = bubbleId,isShow = true})				
				end
			end
		end

		local exsit = function ( owner,questData  )
			local guideId = questData.params.guideID
			local guideData = Table_GuideID[guideId]
			local bubbleId = guideData.BubbleID
			if(bubbleId and Table_BubbleID[bubbleId])then
				-- helplog("ShowAutoFightBubble: false",questData.id)	

				GameFacade.Instance:sendNotification(GuideEvent.ShowAutoFightBubble, {bubbleId = bubbleId,isShow = false})
			end
		end
		local guideId = questData.params.guideID
		local guideData = Table_GuideID[guideId]
		local monsterId = guideData.guideLockMonster
		TableUtility.TableClear(cmdArgs)
		cmdArgs.questId = questData.id
		cmdArgs.monsterId = monsterId
		-- helplog("addOrRemoveLockMonsterGuide",questData.id)	
		QuestProxy.Instance:addOrRemoveLockMonsterGuide(cmdArgs)
		self.triggerCheck:AddCallBackCheck(questData.id,questData.map,questData.pos,
			questData.params.distance or FunctionQuest.DefaultTriggerInfinite,qData,nil,enter,exsit)
	end
end

function FunctionQuest:handleEffectTrigger(questData)
	if(questData and questData.whetherTrace ~= 1 )then
		return
	end
	local qData = questData
	if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_USE 
		or questData.questDataStepType == QuestDataStepType.QuestDataStepType_SELFIE 
		or questData.questDataStepType == QuestDataStepType.QuestDataStepType_MOVE)then

		local id = QuestProxy.Instance:getAreaTriggerIdByQuestId(questData.id)
		self.triggerCheck:AddShowAreaEffectCheck(id,questData.map,questData.pos,
			FunctionQuest.DefaultEffectTriggerInfinite,qData)
		
	elseif(questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK )then

		if(questData.map and questData.pos )then
			local id = QuestProxy.Instance:getAreaTriggerIdByQuestId(questData.id)
			self.triggerCheck:AddShowAreaEffectCheck(id,questData.map,questData.pos,
				FunctionQuest.DefaultEffectTriggerInfinite,qData)
		end
	end
end

function FunctionQuest:handleAutoExcute( questData )
	-- body
	-- LogUtility.Info("handleAutoExcute start")
	-- LogUtility.Info(questData.staticData.orderId)
	-- LogUtility.Info(questData.staticData.id)
	-- LogUtility.Info(questData.staticData)
	-- LogUtility.Info(questData.staticData.Auto)
	-- LogUtility.Info("handleAutoExcute end")
	if(questData.staticData)then
		if(questData.staticData.Auto == 1 )then
			self:executeQuest(questData)
		end
	end
end

function FunctionQuest:handleAutoQuest( questData )
	-- body
	self:handleAutoExcute(questData)
	self:handleAutoTrigger(questData)
	-- self:handleEffectTrigger(questData)
end

function FunctionQuest:handleQuestInit( questData )
	-- body
	if(questData.questListType == SceneQuest_pb.EQUESTLIST_ACCEPT and QuestProxy.Instance:checkIfNeedAutoTrigger(questData))then
		self:handleAutoTrigger(questData)			
	end

	if(questData.questListType == SceneQuest_pb.EQUESTLIST_ACCEPT and QuestProxy.Instance:checkIfNeedEffectTrigger(questData))then
		-- self:handleEffectTrigger(questData)			
	end

	if(questData.questListType == SceneQuest_pb.EQUESTLIST_ACCEPT and QuestProxy.Instance:checkIfNeedAutoExcuteAtInit(questData))then
		self:handleAutoExcute(questData)
	end
end

function FunctionQuest:handleVisitQuest( questData )
	-- body
	if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT)then
		local target = FunctionVisitNpc.Me():GetTarget()
		local npcId = questData.params.npc
		local uniqueid = questData.params.uniqueid
		local targetData = target and target.data or nil
		local staticData = targetData and targetData.staticData or nil
		if(staticData)then
			local isSameNpc = false
			local targetId = staticData.id
			if(uniqueid == targetData.uniqueid)then
				isSameNpc = true
			elseif(type(npcId) == "table" )then
				for i=1,#npcId do
					local single = npcId[i]
					if(single == targetId)then
						isSameNpc = true
						break
					end
				end
			elseif(targetId == npcId )then
				isSameNpc = true
			end
			if(isSameNpc)then
				FunctionVisitNpc.Me():AccessTarget(target,questData.id,AccessCustomType.Quest)
				return true
			end
		end
	end
end

function FunctionQuest:stopTrigger( questData )
	-- body
	self:stopMisstionTrigger(questData)
	self:stopQuestCheck(questData)
	self:stopQuestMiniShow(questData.id)
	self:stopAutoFightGuideQuest(questData)
	self:stopGuideChecker(questData)
	self:stopGuildChecker(questData)
	self:stopCountDownChecker(questData)
	self:removeMonsterNamePre(questData)
	-- self:stopEffectTrigger(questData)
	-- self:stopCurrentCmd(questData)
end

function FunctionQuest:stopCountDownChecker( questData )
	Game.QuestCountDownManager:RemoveQuestEffect(questData.id)
end

function FunctionQuest:stopGuildChecker( questData )
	Game.QuestGuildManager:RemoveQuestEffect(questData.id)
end

function FunctionQuest:stopQuestCheck( questData )
	-- body
	FunctionQuestDisChecker.RemoveQuestCheck(questData.id)
end

function FunctionQuest:stopGuideChecker( questData )
	-- body
	FunctionGuideChecker.RemoveGuideCheck(questData.id)
end

function FunctionQuest:removeMonsterNamePre( questData )
	-- body
	if(QuestProxy.Instance:checkIfShowMonsterNamePre(questData))then
		if(self.currentShowQuest and self.currentShowQuest.id == questData.id)then
			GameFacade.Instance:sendNotification(SceneUIEvent.RemoveMonsterNamePre,questData)
			self.currentShowQuest = nil
		end
	end
end

function FunctionQuest:addMonsterNamePre( questData )
	-- body
	if(self.currentShowQuest)then
		self:removeMonsterNamePre(self.currentShowQuest)
	end
	if(QuestProxy.Instance:checkIfShowMonsterNamePre(questData))then		
		GameFacade.Instance:sendNotification(SceneUIEvent.AddMonsterNamePre,questData)
		self.currentShowQuest = questData
	end
end

function FunctionQuest:checkShowMonsterNamePre( creature )
	-- body
	if(self.currentShowQuest)then
		local groupID = self.currentShowQuest.params.groupId
		local npcID = self.currentShowQuest.params.monster
		local npcUID = self.currentShowQuest.params.uniqueid
		if(npcID and creature.data.staticData.id == npcID)then
			return true
		end
		if(groupID and creature.data:GetGroupID() == groupID)then
			return true
		end
		if(npcUID and creature.data.uniqueid== npcUID)then
			return true
		end
	end
end

function FunctionQuest:stopAutoFightGuideQuest( questData )
	-- body
	if(questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER )then
		local guideId = questData.params.guideID
		local guideData = Table_GuideID[guideId]
		local bubbleId = guideData.BubbleID
		local monsterId = guideData.guideLockMonster
		if(bubbleId and Table_BubbleID[bubbleId])then			
			GameFacade.Instance:sendNotification(GuideEvent.ShowAutoFightBubble, {bubbleId = bubbleId,isShow = false})
		end	
		TableUtility.TableClear(cmdArgs)
		cmdArgs.questId = questData.id
		QuestProxy.Instance:addOrRemoveLockMonsterGuide(cmdArgs)
	end
end

function FunctionQuest:stopQuestMiniShow( id )
	-- body
	Game.QuestMiniMapEffectManager:RemoveQuestEffect(id)
end

function FunctionQuest:addQuestMiniShow( questData )
	-- body
	if(questData)then
		Game.QuestMiniMapEffectManager:AddQuestEffect(questData.id)
	end
end

function FunctionQuest:stopMisstionTrigger( questData )
	-- body
	if(QuestProxy.Instance:checkIfNeedAutoTrigger(questData))then
		local triggerCheck = Game.AreaTrigger_Mission
		if(triggerCheck ~=nil)then
			triggerCheck:RemoveQuestCheck(questData.id)
		end	
	end
end

function FunctionQuest:stopEffectTrigger( questData )
	-- body
	if(QuestProxy.Instance:checkIfNeedEffectTrigger(questData))then
		local id = QuestProxy.Instance:getAreaTriggerIdByQuestId(questData.id)
		local triggerCheck = Game.AreaTrigger_Mission
		if(triggerCheck ~=nil)then
			triggerCheck:RemoveQuestCheck(id)
		end	
	end
end

function FunctionQuest:playMediaQuest( mapId )
	local quest,video = self:getMediaQuest(mapId)
	if(quest) then
		QuestProxy.Instance:notifyQuestState(quest.id,quest.staticData.FinishJump)
		helplog("此处应该播一段视频:",video.Name)
		-- GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.MediaPanel});
		-- GameFacade.Instance:sendNotification(MediaPanel.PlayVideo, video.Name);
		LuaUtils.PlayMovie(video.Name,true)
		return true
	end
	return false
end

function FunctionQuest:getMediaQuest(mapId)
	local type = SceneQuest_pb.EQUESTLIST_ACCEPT
	local list = QuestProxy.Instance.questList[type]
	-- printRed("playMediaQuest")
	-- printRed(mapId)
	if(list) then
		for i=1,#list do
			local single = list[i]
			if(single.questDataStepType == QuestDataStepType.QuestDataStepType_MEDIA and single.map == mapId)then
				local id = single.params.id
				local table = Table_Video[id]
				if(table)then
					return single,table
				end
			end
		end
	end
	return nil
end

function FunctionQuest:updateTraceView( traceData )
	-- body
	EventManager.Me():PassEvent(FunctionQuest.UpdateTraceInfo,traceData)
end

function FunctionQuest:removeTraceView(traceData  )
	-- body
	EventManager.Me():PassEvent(FunctionQuest.RemoveTraceInfo,traceData)
end

function FunctionQuest:addTraceView( traceData )
	-- body
	EventManager.Me():PassEvent(FunctionQuest.AddTraceInfo,traceData)
end

function FunctionQuest:getIllustrationQuest( mapId )
	-- body
	-- printRed("getIllustrationQuest")
	-- printRed(mapId)
	local questData = QuestProxy.Instance:getIllustrationQuest(mapId)
	if(questData)then
		QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
		return questData.params.id
	else
		return nil
	end
end

function FunctionQuest:checkIfShowMonsterNamePreFix( creature )
	-- body

end

function FunctionQuest:TestEquip(  )
	-- body
	-- printRed("getIllustrationQuest")
	-- printRed(mapId)
	for k,v in pairs(Table_GM_CMD) do		
		local func = loadstring(v.Cmd.."Func")
		if(func)then
			func()
		end
	end
end

function additemFunc(  )
	-- body
	local cmd = v.Cmd.." "
	local params = v.Param
	local symbol = "({(.-)})"
	for str,param in string.gmatch(params, symbol) do	
		local split = string.split(param,",")
		local input = ""
		local result = split[2].."="..input
		cmd = cmd..result
	end
	ServiceGMProxy.Instance:Call(cmd)
end