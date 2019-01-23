FunctionGuide = class("FunctionGuide",EventDispatcher)

autoImport("GuideMaskView")
autoImport("FunctionGuide_Map");

function FunctionGuide.Me()
	if nil == FunctionGuide.me then
		FunctionGuide.me = FunctionGuide.new()
	end
	return FunctionGuide.me
end

function FunctionGuide:ctor()

end

function FunctionGuide:stopGuide(  )
	-- body
	if(GuideMaskView.Instance)then
		GuideMaskView.Instance:CloseSelf()
		-- errorLog("checkIfNeedRemoveGuideView GuideMaskView.Instance:CloseSelf()")
	end
end

function FunctionGuide:skillPointCheck( value )
	-- body
	self:checkQuestGuide(3,value)
end

function FunctionGuide:buyItemCheck( value )
	-- body
	self:checkQuestGuide(2,value)
end

function FunctionGuide:attrPointCheck( value )
	-- body
	self:checkQuestGuide(1,value)
end

function FunctionGuide:checkQuestGuide(optionId,value)
	-- body
	local instance = GuideMaskView.Instance
	-- errorLog("FunctionGuide:checkQuestGuide:"..optionId..";value:"..value)
	if(instance and instance.guideData)then
		local guideData = instance.guideData
		if(guideData and guideData.optionId and guideData.optionId == optionId)then
			local optionData = Table_GuideOption[optionId]
			if(optionData)then				
				local type = optionData.content.type
				local dataValue = optionData.content.value
				-- errorLog("FunctionGuide.checkQuestGuide optionId:"..optionId..";value:"..value)
				-- errorLog("optionData:optionId:"..optionId..";value:"..dataValue)
				local complete = false
				if(type == ">")then
					if value > dataValue then
						complete = true
					end
				elseif(type == "<")then
					if value < dataValue then
						complete = true
					end
				elseif(type == "==")then
					if value == dataValue then
						complete = true
					end
				else
					--helplog("can't recognize the option type!!!")
				end
				if(complete)then
					if(instance.lastOption == optionId)then
						return
					end
					instance.lastOption = optionId
					local questData = instance.questData
					QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
				else
					--helplog("complete is false")
				end
			else
				--helplog("optionData is nil")
			end
		else
			-- --helplog("guideData or guideData.optionId is nil or optionId unequal!!!")
		end
	end
end

-- 界面关闭调用
-- 传入单个guideId or guideIdList
function FunctionGuide:checkGuideStateWhenExit( singleOrList )
	-- body
	-- --helplog("FunctionGuide:checkGuideStateWhenExit")
	local instance = GuideMaskView.Instance
	if(instance and instance.questData)then
		local questData = instance.questData
		local currentGuideId = instance.currentGuideId
		local curBtnId = instance.currentTriggerId or -1
		if(type(singleOrList) == "table")then
			for i=1,#singleOrList do
				local single = singleOrList[i]
				-- --helplog("single guideId:"..single.id)
				--如果前面已经发送了引导更新消息则认为该引导正在等待回复不认为该引导失败
				-- --helplog(instance.guideData.ButtonID)
				if(currentGuideId == single.id)then
					instance:restoreParent()
					if(curBtnId ~= instance.guideData.ButtonID)then
						--helplog("notifyQuestState FailJump")
						QuestProxy.Instance:notifyQuestState(instance.questData.id,instance.questData.staticData.FailJump)
						instance:CloseSelf()
						return
					end
				end
			end
			--helplog("current questGuideId unequal the argument by singleOrList!currentGuideId:",currentGuideId)
			return
		else
			--如果前面已经发送了引导更新消息则认为该引导正在等待回复不认为该引导失败	
			if(currentGuideId == singleOrList and curBtnId ~= instance.guideData.ButtonID)then
				QuestProxy.Instance:notifyQuestState(instance.questData.id,instance.questData.staticData.FailJump)
				instance:CloseSelf()
			else
				--helplog("current questGuideId unequal the argument!")
			end
		end
	else
		-- --helplog("instance is nil or questData is nil")
	end
end

--TODO 当前限制按钮只触发一次
function FunctionGuide:triggerWithTag(tag)
	-- body	
	-- --helplog("FunctionGuide:triggerWithTag:"..tag)
	local instance = GuideMaskView.Instance	
	if(instance and instance.questData and instance.guideData)then
		local guideData = instance.guideData		
		local btnId = guideData.ButtonID
		if(btnId and btnId == tag)then
			local sameButton =  (instance.currentTriggerId and  instance.currentTriggerId == btnId) or false
			local clickCauseComplete = guideData.press
			clickCauseComplete = clickCauseComplete and clickCauseComplete == 1
			if(clickCauseComplete and not sameButton)then
				local jumpId = instance.questData.staticData.FinishJump
				local questId = instance.questData.id
				--helplog("notifyQuestState questId:"..questId..";FinishJump:",jumpId)
				instance.currentTriggerId = btnId
				local questData = instance.questData
				QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
				--非强制引导先不处理
				local guideType = instance.questData.params.type
				if(guideType == QuestDataGuideType.QuestDataGuideType_force)then
					instance:restoreParent()
				end
				--提前遮挡防止下次任务执行前误操作
				instance:Show(instance.mask)
			else
				--helplog("tag unequal with quest id! or same button! or clickCauseComplete is false")
			end
		else
			--helplog("buttonId is nil")
		end
	else
		-- errorLog("questData or button is nil")
	end
end

--展示引导
function FunctionGuide:showGuideByQuestData( questData )
	-- body
	if(not questData)then
		return
	end
	--helplog("FunctionGuide:showGuideByQuestData",questData.id,questData.step)
	local instance = GuideMaskView.getInstance()
	if(instance and instance.forbid)then
		return
	end
	instance:restoreParent()
	instance:resetData()
	local guideId = questData.params.guideID
	local guideType = questData.params.type
	local guideData = Table_GuideID[guideId]
	if(guideData)then	
		local tag =guideData.ButtonID
		if(guideData.Preguide and guideData.Preguide ~= instance.currentGuideId)then
			--当前任务的前置引导未完成需要回退
			QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FailJump)
			-- errorLog("questData.staticData.FailJump:")
			-- errorLog(questData.staticData.FailJump)
			-- helplog("preguide is Error！guideData.Preguide:",guideData.Preguide,instance.currentGuideId)
			return
		end		
		if(tag)then			
			local tagObj = GuideTagCollection.getGuideItemById(tag)
			if(tagObj and not GameObjectUtil.Instance:ObjectIsNULL(tagObj) and tagObj.gameObject.activeInHierarchy)then
				-- helplog("instance:showGuideByQuestData(questData)")
				instance:showGuideByQuestData(questData)
			elseif(not tagObj and guideData.ServerEvent ~= "")then 
				--需要等待服务器事件
				-- helplog("wait ServerEvent:",guideData.ServerEvent)
				instance:waitServerEvent(guideData.ServerEvent,questData)
			else
				--未找到当前任务所需要引导的view 回退
				if(tagObj)then
					-- helplog("obj activeInHierarchy:",tagObj.gameObject.activeInHierarchy)
				end
				-- helplog("can't find obj by tag:",tag,questData.staticData.FailJump)

				local FailJump = guideData.FailJump
				if(FailJump == 1)then
					QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FailJump)
				else
					FunctionGuideChecker.Me():AddGuideCheck(questData)
				end
				return
			end
			-- if(tagObj)then
			-- 	--helplog("obj activeInHierarchy:",tagObj.gameObject.activeInHierarchy)
			-- end
		elseif(guideType == QuestDataGuideType.QuestDataGuideType_showDialog)then
			if(self:checkGuideMap(questData.map))then
				QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
				GameFacade.Instance:sendNotification(GuideEvent.ShowBubble, guideData.BubbleID)
				-- helplog("QuestDataGuideType_showDialog Show Bubble guide !FinishJump:",questData.staticData.FinishJump,guideData.BubbleID)
			else
				QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FailJump)
				-- helplog("QuestDataGuideType_showDialog Show Bubble guide !FailJump:",questData.staticData.FailJump,guideData.BubbleID)
			end
			instance:CloseSelf()
		elseif(guideType == QuestDataGuideType.QuestDataGuideType_showDialog_Repeat)then
			if(self:checkGuideMap(questData.map))then
				local bubbleId = guideData.BubbleID
				helplog("QuestDataGuideType_showDialog_Repeat Show Bubble guide !bubbleId:1",bubbleId)
				if(bubbleId and Table_BubbleID[bubbleId])then
					helplog("QuestDataGuideType_showDialog_Repeat Show Bubble guide !bubbleId:2",bubbleId)
					GameFacade.Instance:sendNotification(GuideEvent.ShowBubble, bubbleId)
					local bubbleData = Table_BubbleID[bubbleId]				
					local delayTime = bubbleData.RepeatDeltaTime or 60
					local questId = questData.id
					local step = questData.step
					self:CheckBubbleGuideRepeat(questId,step,delayTime)
					--helplog("error Guide Quest!!! can't find BubbleID in Table_BubbleID")
				end
			else
				helplog("QuestDataGuideType_showDialog_Repeat Show Bubble guide !bubbleId: FailJump",bubbleId)
				QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FailJump)
			end
			instance:CloseSelf()				
		elseif(guideType == QuestDataGuideType.QuestDataGuideType_showDialog_Anim)then
			if(self:checkGuideMap(questData.map))then
				local bubbleId = guideData.BubbleID
				helplog("QuestDataGuideType_showDialog_Anim Show Bubble guide !bubbleId:1",bubbleId)
				GameFacade.Instance:sendNotification(GuideEvent.MiniMapAnim, {questData = questData,bubbleId = bubbleId})
			else
				helplog("QuestDataGuideType_showDialog_Anim Show Bubble guide !bubbleId: FailJump",bubbleId)
				QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FailJump)
			end
			instance:CloseSelf()
		else
			--helplog("no tag find")
			QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FailJump)
			return
		end
	else
		--helplog("guideData is nil by id:",guideId)
		QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FailJump)
		return
	end
end

function FunctionGuide:setGuideUIActive( tag,bRet )
	-- body
	local instance = GuideMaskView.Instance	
	if(instance and instance.questData and instance.guideData)then
		local guideData = instance.guideData

		local btnId = guideData.ButtonID
		-- --helplog("FunctionGuide:setGuideUIActive，tag:"..tag..";bRet:",bRet)
		if(btnId)then
			if(btnId == tag)then
				instance:setGuideUIActive(bRet)
			else
				--helplog("removeGuideUI:tag unequal with quest id!")
			end
		else
			--helplog("removeGuideUI:current questData buttonId is nil")
		end
	else
		-- --helplog("removeGuideUI:questData or button is nil")
	end
end

function FunctionGuide:checkGuideMap( map )
	-- body
	local currentMapID = Game.MapManager:GetMapID()
	if(currentMapID == map)then
		return true
	else
		return false
	end
end

function FunctionGuide:CheckBubbleGuideRepeat( questId,step,delayTime )
	-- body
	LeanTween.delayedCall(delayTime,function (  )
		-- body
		local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
		local count = QuestProxy.Instance:GetTraceCellCount()
		local noTraceCells = not count or count <=0
		-- --helplog(data.step,step,noTraceCells)
		if(data and data.step == step and noTraceCells )then
			QuestProxy.Instance:notifyQuestState(questId,data.staticData.FailJump)
			-- --helplog("QuestDataGuideType_showDialog_Repeat Show Bubble guide !FailJump:",data.staticData.FailJump)
		else
			if(data)then
				QuestProxy.Instance:notifyQuestState(questId,data.staticData.FinishJump)
				-- --helplog("QuestDataGuideType_showDialog_Repeat Show Bubble guide !FinishJump:",data.staticData.FinishJump)
			end
		end
	end)
	
end