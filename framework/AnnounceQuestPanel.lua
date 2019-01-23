AnnounceQuestPanel = class("AnnounceQuestPanel", ContainerView)
autoImport("AnnounceQuestPanelCell")
AnnounceQuestPanel.ViewType = UIViewType.NormalLayer

AnnounceQuestPanel.skillid = 50040001

function AnnounceQuestPanel:Init()
	self:initView()
	self:initData()			
	-- self:addViewEventListener()	
	self:addListEventListener()
end

local tempArray = {}
function AnnounceQuestPanel:OnEnter(  )
	-- body

	self.super.OnEnter(self)	
	local viewdata = self.viewdata.viewdata
	if(viewdata and viewdata.npcTarget)then
		local func = function (  )
			-- body			
			self:Show()
			local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
			manager_Camera:ActiveMainCamera(false);
			ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT,self.wantedId)
		end
		
		local trans = viewdata.npcTarget.assetRole.completeTransform
		self.announceGuid = viewdata.npcTarget.data:GetGuid()
		local viewPort = CameraConfig.Ann_ViewPort;
		local rotation = CameraController.singletonInstance.targetRotationEuler;
		rotation = Vector3(CameraConfig.Ann_ViewRotationX, rotation.y, rotation.z);
		self:CameraFaceTo(trans,viewPort,rotation,nil,nil,func)
	end
end

function AnnounceQuestPanel:OnExit()
	local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
	manager_Camera:ActiveMainCamera(true);
	self.super.OnExit(self)
	self:CameraReset()
	self.questListCtl:ResetDatas()
	LeanTween.cancel(self.gameObject)
	TimeTickManager.Me():ClearTick(self)
	if(self.bgTexture)then
		PictureManager.Instance:UnLoadUI("Rewardtask_bg_06",self.bgTexture);
	end
	MsgManager.CloseConfirmMsgByID(903)
end

function AnnounceQuestPanel:initView( )
	-- body
	-- self.titleName = self:FindGO("Label",self:FindGO("panelTitle")):GetComponent(UILabel)	

	----[[ todo 重设图片
	local img = self:FindGO("Label",self:FindGO("panelTitle")):GetComponent(UISprite)
	restoreOriginSize(img)
	--]]

	self.refreshTimeLabel = self:FindGO("refreshTimeLabel"):GetComponent(UILabel)
	-- self.currentStateLabel = self:FindGO("currentStateLabel"):GetComponent(UILabel)
	self.currentRateLabel = self:FindGO("currentRateLabel"):GetComponent(UILabel)
	self.currentRateLabelValue = self:FindGO("currentRateLabelValue"):GetComponent(UILabel)
	self:Hide()
	-- self.leftAction = self:FindGO("leftAction"):GetComponent(UISprite)
	-- self.leftActionCollider = self.leftAction.gameObject:GetComponent(BoxCollider)
	-- self.rightAction = self:FindGO("rightAction"):GetComponent(UISprite)
	-- self.rightActionCollider = self.rightAction.gameObject:GetComponent(BoxCollider)
	self.leftAction = self:FindGO("leftAction")
	self.rightAction = self:FindGO("rightAction")

	self.panelMask = self:FindGO("panelMask")
	self:Hide(self.panelMask)
	self.ScrollView = self:FindComponent("ScrollView",UIScrollView)
	self.ScrollView.onStoppedMoving = function (  )
		-- body
		self:checkBtnEnabled()
	end

	local ContentContainer = self:FindComponent("ContentContainer",UIGrid)

	-- local wrapConfig = {
	-- 	wrapObj = ContentContainer,
	-- 	pfbNum = 10, 
	-- 	cellName = "AnnounceQuestPanelCell", 
	-- 	control = AnnounceQuestPanelCell, 
	-- 	dir = 0,
	-- }
	-- self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	-- self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.questClick, self);
	local isInWantedQuestActivity = QuestProxy.Instance:isInWantedQuestInActivity()
	if(isInWantedQuestActivity)then
		self.questListCtl = UIGridListCtrl.new(ContentContainer,AnnounceQuestPanelCell,"AnnounceQuestActivityPanelCell")
	else
		self.questListCtl = UIGridListCtrl.new(ContentContainer,AnnounceQuestPanelCell,"AnnounceQuestPanelCell")
	end
	self.questListCtl:AddEventListener(MouseEvent.MouseClick,self.questClick,self)

	self.bgTexture = self:FindComponent("bgTexture",UITexture)
	if(self.bgTexture)then
		PictureManager.Instance:SetUI("Rewardtask_bg_06", self.bgTexture);
	end
end

function AnnounceQuestPanel:initData(  )
	-- body		
	self.currentQuestData = nil
	self.firstInit = true	
	if(self.viewdata.viewdata)then
		self.wantedId = self.viewdata.viewdata.wanted
	else
		printRed("can't find wantedId in viewdata!")
	end
	-- self:setQuestData()
	-- printRed(self.wantedId)	
	self.hasGoingQuest = false
	self.startIndex = 1

	self.listTime = {}
	local currentTime = ServerTime.CurServerTime()/1000
	local nextDayTime
	local timeTab = os.date("*t", currentTime)	
	for i=1,#GameConfig.Quest.refresh do
		local tmp = TableUtil.split(GameConfig.Quest.refresh[i],":")
		local tb = {year=timeTab.year, month=timeTab.month, day=timeTab.day, hour=tmp[1],min=tmp[2],sec=0,isdst=false}
		table.insert(self.listTime,os.time(tb))
		if(i == 1)then
			tb = {year=timeTab.year, month=timeTab.month, day=timeTab.day+1, hour=tmp[1],min=tmp[2],sec=0,isdst=false}
			nextDayTime = os.time(tb)
		end
	end
	table.insert(self.listTime,nextDayTime)

	self.currentRatio = 0

	self.hasPlayAudio = false
end

-- function AnnounceQuestPanel:addViewEventListener(  )
	-- body
	-- EventManager.Me():AddEventListener(QuestPanelGroupCell.Quest_Select,self.handleQuestSelect,self)
	-- self:AddClickEvent(self:FindGO("TraceBtn"),function ( obj )
	-- 	-- body
	-- 	local data = self.tabData[self.currentTab]
	-- 	ServiceQuestProxy.Instance:CallQuestTrace(data.questId,not data.trace)
	-- end)
	-- self:AddButtonEvent("rightAction",function ( obj )
	-- 	-- body
	-- 	self:rightBtnClick()
	-- end)
	-- self:AddButtonEvent("leftAction",function ( obj )
	-- 	-- body
	-- 	self:leftBtnClick()
	-- end)

	-- local dragCollider = self:FindGO("bgCt")

	-- self:AddDragEvent(dragCollider,function ( obj,delta )
	-- 	-- body
	-- 	if(math.abs(delta.x) > 20)then
	-- 		self.delta = delta.x
	-- 	end
	-- end)
	-- UIEventListener.Get(dragCollider).onDragEnd = function ( obj)
	-- 	-- body
	-- 	if(math.abs(self.delta) > 20)then
	-- 		self:handDrag(self.delta)
	-- 	end
	-- end

-- end

-- function AnnounceQuestPanel:leftBtnClick()
-- 	if(self.questList and #self.questList > 0)then
-- 		local start = self.startIndex - 3
-- 		if(start > 0)then
-- 			self.startIndex = start
-- 			local endIndex = math.min(self.startIndex+2,#self.questList)
-- 			self.announceQuestList:ResetDatas({unpack(self.questList,self.startIndex,endIndex)})				
-- 		else
-- 			-- if(#self.questList>3)then
-- 			-- 	self.startIndex = 3*math.floor(#self.questList/3)+1
-- 			-- 	local endIndex = math.min(self.startIndex+2,#self.questList)
-- 			-- 	self.announceQuestList:ResetDatas({unpack(self.questList,self.startIndex,endIndex)})
-- 			-- end
-- 		end
-- 		self:checkQuestCanAccept()
-- 	end
-- 	-- self:checkBtnEnabled()
-- end

-- function AnnounceQuestPanel:rightBtnClick()
-- 	if(self.questList and #self.questList > 0)then
-- 		local start = self.startIndex + 3
-- 		if(start > #self.questList)then
-- 			-- if(self.startIndex == 1)then
-- 			-- 	return
-- 			-- end
-- 			-- self.startIndex = 1
-- 			-- local endIndex = math.min(self.startIndex+2,#self.questList)
-- 			-- self.announceQuestList:ResetDatas({unpack(self.questList,self.startIndex,endIndex)})
-- 		else
-- 			self.startIndex = start
-- 			local endIndex = math.min(self.startIndex+2,#self.questList)
-- 			self.announceQuestList:ResetDatas({unpack(self.questList,self.startIndex,endIndex)})
-- 		end	
-- 		self:checkQuestCanAccept()		
-- 	end
-- 	-- self:checkBtnEnabled()
-- end

-- function AnnounceQuestPanel:handDrag( delta )
-- 	-- body
-- 	if(delta>0)then
-- 		self:leftBtnClick()
-- 	else
-- 		self:rightBtnClick()
-- 	end
-- end

function AnnounceQuestPanel:checkBtnEnabled(  )
	-- body
	if(self.questListData and #self.questListData>0)then
		-- if(#self.questList - self.startIndex >2 )then
		-- 	self:Show(self.rightAction)
		-- else
		-- 	self:Hide(self.rightAction)
		-- end

		-- if(self.startIndex >3 )then
		-- 	self:Show(self.leftAction)
		-- else
		-- 	self:Hide(self.leftAction)
		-- end
		local cells = self.questListCtl:GetCells()
		local panel = self.ScrollView.panel
		if(panel)then				
			local cell = cells[1]
			-- local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform,cell.gameObject.transform)
			-- local offset = panel:CalculateConstrainOffset(bound.min,bound.max)
			-- self:Log(self.ScrollView.currentMomentum)
			-- if(offset.x <=40)then
			-- 	self:Hide(self.leftAction)
			-- else
			-- 	self:Show(self.leftAction)
			-- end

			if(panel:IsVisible(cell.baseExp))then
				self:Hide(self.leftAction)
			else
				self:Show(self.leftAction)
			end
			local index = #cells
			cell = cells[index]

			if(panel:IsVisible(cell.jobExp))then
				-- self:Log("index:",index)
				-- self:Log(cell.data.staticData.Name)
				self:Hide(self.rightAction)
			else
				self:Show(self.rightAction)
			end
			-- bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform,cell.gameObject.transform)
			-- offset = panel:CalculateConstrainOffset(bound.min,bound.max)
			-- self:Log(offset)
			-- if(offset.x >= -50)then
			-- 	self:Hide(self.rightAction)
			-- else
			-- 	self:Show(self.rightAction)
			-- end
		end
	else
		self:Hide(self.rightAction)
		self:Hide(self.leftAction)
	end

	-- --TODO
	-- self:Hide(self.rightAction.gameObject)
	-- self:Hide(self.leftAction.gameObject)
end

function AnnounceQuestPanel:getStartIndexByQuestId( )
	-- body
	-- printRed("getStartIndexByQuestId")
	-- printRed(self.questId)
	-- stack("getStartIndexByQuestId")
	local questId = self.questId
	if(self.questListData and #self.questListData > 0)then
		if(questId)then
			for i=1,#self.questListData do
				local single = self.questListData[i]
				if(single.id == questId)then
					return i
				end
			end
		else
			return 1
		end
	end	
	self.questId = nil
end

function AnnounceQuestPanel:addListEventListener(  )
	-- body
	self:AddListenEvt(ServiceEvent.QuestQuestList,self.setQuestData)
	self:AddListenEvt(ServiceEvent.SessionTeamQuestWantedQuestTeamCmd,self.SessionTeamQuestWantedQuestTeamCmd)
	self:AddListenEvt(ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd,self.SessionTeamUpdateWantedQuestTeamCmd)
	-- self:AddListenEvt(ServiceEvent.QuestQuestDetailUpdate,self.setQuestData)
	self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.setQuestData)
	self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate,self.setQuestData)
	self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.VarUpdateHandler)
	self:AddListenEvt(ServiceEvent.QuestQuestCanAcceptListChange,function (  )
		-- body		
		ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT,self.wantedId)
	end)
	self:AddListenEvt(SceneUserEvent.LevelUp,function (  )
		-- body		
		ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT,self.wantedId)
	end)
	self:AddListenEvt(QuestEvent.UpdateAnnounceQuest,self.setQuestData)

	self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs,self.removeNpcHandle)
end

function AnnounceQuestPanel:removeNpcHandle( note )
	local body = note.body
	if(body and #body>0)then
		for i=1,#body do
			if(self.announceGuid ==  body[i])then
				self:CloseSelf()
				break
			end
		end
	end
end

function AnnounceQuestPanel:VarUpdateHandler()
	-- LeanTween.cancel(self.gameObject)
	self.varupdated = true
	local submitCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
	-- printRed("VarUpdateHandler",submitCount,"VarUpdateHandler end ")
	LeanTween.delayedCall(self.gameObject,0.5,function ()
	  	if(self.varupdated)then
	  		self:setQuestData()
	  	end
	end)
end

function AnnounceQuestPanel:SessionTeamQuestWantedQuestTeamCmd()
	self:Log("AnnounceQuestPanel:SessionTeamQuestWantedQuestTeamCmd()")
	self:setQuestData()
end

function AnnounceQuestPanel:SessionTeamUpdateWantedQuestTeamCmd()
	self:Log("AnnounceQuestPanel:SessionTeamUpdateWantedQuestTeamCmd()")
	self:setQuestData()
end

function AnnounceQuestPanel:checkQuestCanAccept()
	-- local cells = self.questListCtl:GetCells()
	-- self.CellState = false 
	-- if(self.hasGoingQuest)then
	-- 	self.CellState = false	
	-- else
	-- 	self.CellState = true
	-- end
	-- -- printRed(string.format("checkQuestCanAccept state:%s",tostring(state)))
	-- for i=1,#cells do
	-- 	local single = cells[i]
	-- 	single:setEnableAccept(state)
	-- end
end

function AnnounceQuestPanel:setQuestData( note )
	-- body
	-- printRed("setQuestData")
	self.varupdated = false
	-- if(data and data.type == SceneQuest_pb.EQUESTLIST_SUBMIT)then
	-- 	return 
	-- end
	self.hasGoingQuest = false
	self.questListData = QuestProxy.Instance:getWantedQuest()
	local index = self:getStartIndexByQuestId()
	local unAccept = false
	-- local submitIds = {}
	for i=1,#self.questListData do
		local single = self.questListData[i]:getQuestListType()
		-- printRed("setQuestData:",self.questList[i])
		if(single == SceneQuest_pb.EQUESTLIST_ACCEPT or single == SceneQuest_pb.EQUESTLIST_COMPLETE)then
			self.hasGoingQuest = true
			if(self.firstInit)then
				index = i
			end
			-- if(single ==SceneQuest_pb.EQUESTLIST_COMPLETE)then
			-- 	table.insert(submitIds,self.questListData[i].id)
			-- end
			break
		elseif(single == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
			unAccept = true
		end

	end	

	QuestProxy.Instance:setGoingWantedQuest(self.hasGoingQuest)


	-- if(index)then
	-- 	self.startIndex = math.floor((index-1)/3)*3+1
	-- else
	-- 	self.startIndex = 1
	-- end	
	local extraCount = self:setQuestList(index)

	self.submitCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
	if(not self.submitCount)then
		self.submitCount = 0
	end
	-- self.currentStateLabel.text = ZhString.AnnounceQuestPanel_DaiLyWanted..self.submitCount.."/"..QuestProxy.Instance:getMaxWanted()
	self.nextTime = self:getNextRefreshTime()

	TimeTickManager.Me():CreateTick(0,1000,self.refreshTime,self,1)

	-- self.currentRateLabel.text = ZhString.AnnounceQuestPanel_RewardRatio
	-- self.currentStateLabel.text = ZhString.AnnounceQuestPanel_DaiLyWanted..self.submitCount.."/"..QuestProxy.Instance:getMaxWanted()
	
	local ratio = QuestProxy.Instance:getWantedQuestRatio( self.submitCount )
	self.currentRatio = (ratio*100)

	if(not self.hasPlayAudio)then
		self.hasPlayAudio = true
		if(unAccept or self.hasGoingQuest)then
			AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Normal)
		else
			AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_AllCommit)
		end
	end

end

function AnnounceQuestPanel:checkIfNeedExtraQuest( questId )
	if(self.questListData and #self.questListData > 0)then
		for i=1,#self.questListData do
			local single = self.questListData[i]
			local result = single.id == questId and single:getQuestListType() ~= SceneQuest_pb.EQUESTLIST_SUBMIT
			if(result)then
				return false
			end
		end
	end
	return true
end

function AnnounceQuestPanel:checkIsAllQuestCommited(  )
	if(self.questListData and #self.questListData > 0)then
		for i=1,#self.questListData do
			local single = self.questListData[i]
			if(single.id == questId and single:getQuestListType() ~= SceneQuest_pb.EQUESTLIST_SUBMIT)then
				return false
			end
		end
	end
	return true
end

function AnnounceQuestPanel:checkIfHasExsit( questId ,array)
	if(array and #array > 0)then
		for i=1,#array do
			local single = array[i]
			if(single.id == questId)then
				return true
			end
		end
	end
	return false
end

function AnnounceQuestPanel:setQuestList( index )
	-- body
	local extraCount = 0
	local extraQuests = ShareAnnounceQuestProxy.Instance:getAllMembersQuest()
	local tempArray = {}
	for i=1,#extraQuests do
		local single = extraQuests[i]
		local totalMember = ShareAnnounceQuestProxy.Instance:getTotalCountMenber(single.questId)
		local bRet = totalMember > 0 and self:checkIfNeedExtraQuest(single.questId) and not self:checkIfHasExsit(single.questId,tempArray)
		local params = single.questData.params
		local isComplete = params.mark_team_wanted == 1
		bRet = bRet and not isComplete
		if(bRet)then
			-- local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
			-- questData:update(single.questId,1)
			-- questData.notMine = true
			table.insert(tempArray,single.questData)
			extraCount = extraCount +1
		end
	end

	if(self.questListData and #self.questListData>0)then
		for i=1,#self.questListData do
			table.insert(tempArray,self.questListData[i])
		end
	end
	if(not index)then
		self.startIndex = 1 + extraCount
	else
		self.startIndex = index + extraCount
	end
	if(tempArray and #tempArray > 0)then
		-- local start = self.startIndex
		-- local endIndex = math.min(self.startIndex+2,#self.questListData)
		-- self.announceQuestList:ResetDatas({unpack(self.questListData,start,endIndex)})
		self.questListCtl:ResetDatas(tempArray)
		self:moveScrView()
		-- self:Log("self.ifNeedPlayRatioUp",self.ifNeedPlayRatioUp)
		-- self.ifNeedPlayRatioUp = true
		if(self.ifNeedPlayRatioUp)then
			local cells = self.questListCtl:GetCells()
			for i=1,#cells do
				local single = cells[i]
				local panel = self.ScrollView.panel
				if(panel and panel:IsVisible(single.publishName))then
					single:playRatioUpAnm() 
				end
			end
			self.ifNeedPlayRatioUp = false
		end
		-- self:checkQuestCanAccept()
	else
		-- self:Log("UpdateInfo2")
		self.questListCtl:ResetDatas()
	end
end

function AnnounceQuestPanel:moveScrView()
	if(self.startIndex and self.startIndex ~= 1)then
		local cells = self.questListCtl:GetCells()	
		local cell = cells[self.startIndex]
		-- self:Log("AnnounceQuestPanel:moveScrView",self.startIndex,tostring(cell))
		if(cell)then
			-- printRed("moveScrView",self.startIndex)			
			-- LeanTween.cancel(self.gameObject)
			LeanTween.delayedCall(self.gameObject,1,function (  )
				-- body
				local panel = self.ScrollView.panel
				if(panel)then
					local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform,cell.gameObject.transform)
					-- printRed(bound)
					local offset = panel:CalculateConstrainOffset(bound.min,bound.max)
					-- printRed(offset)
					offset = Vector3(offset.x,0,0)
					self.ScrollView:MoveRelative(offset)
				end
			end)
		end
	else
		self.questListCtl:Layout()
	end
end

function AnnounceQuestPanel:refreshTime()
	local deltaTime = math.abs(self.nextTime - ServerTime.CurServerTime()/1000)
	local hour = math.floor(deltaTime/3600)
	local timeStr
	if(hour == 0)then
		timeStr = "00"
	elseif(hour<10)then
		timeStr = "0"..hour
	else
		timeStr = hour
	end
	timeStr = timeStr..":"
	local minute = math.floor((deltaTime - hour*3600)/60)
	if(minute == 0)then
		timeStr = timeStr.."00"
	elseif(minute<10)then
		timeStr = timeStr.."0"..minute
	else
		timeStr = timeStr..minute
	end
	timeStr = timeStr..":"
	local second = math.floor(deltaTime - hour*3600 - minute*60)
	if(second == 0)then
		timeStr = timeStr.."00"
	elseif(second<10)then
		timeStr = timeStr.."0"..second
	else
		timeStr = timeStr..second
	end

	local curSmit = self.submitCount and self.submitCount or 0
	local str = curSmit.."/"..QuestProxy.Instance:getMaxWanted(  )
	self.refreshTimeLabel.text = string.format(ZhString.AnnounceQuestPanel_BottomLabel,self.currentRatio,str,timeStr)
end

function AnnounceQuestPanel:getNextRefreshTime(  )
	-- body
	local currentTime = ServerTime.CurServerTime()/1000
	-- printRed(os.date("%X",currentTime))
	-- printRed("size:"..#self.listTime)
	for i=1,#self.listTime do
	--printRed(self.listTime[i])
		if(currentTime < self.listTime[i])then
			return self.listTime[i]
		end
	end
end

function AnnounceQuestPanel:playQuestCompleteAnim( cell )
	-- body
	-- printRed(#submitIds)
	local ratio = QuestProxy.Instance:getWantedQuestRatio( self.submitCount)
	local nextRatio = QuestProxy.Instance:getWantedQuestRatio( self.submitCount +1 )
	if(ratio ~= nextRatio)then
		self.ifNeedPlayRatioUp = true
	end
	self:PlayUISound(AudioMap.UI.stamp)
	self:Show(self.panelMask)
	cell:playAnim()	
	LeanTween.delayedCall(self.gameObject,3,function (  )
	   if(not self:ObjIsNil(self.panelMask))then
		   self:Hide(self.panelMask)
		end
	end)
	ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT,cell.data.id)
end

function AnnounceQuestPanel:checkLevelCross( qMinLv,qMaxLv,rMinLv,rMaxLv )
	if(qMaxLv>=rMinLv and qMinLv <=rMaxLv)then
		return true
	end
end

function AnnounceQuestPanel:checkWantedTick( data )

	if(not data or not data.wantedData or data.wantedData.IsActivity == 1)then
		return
	end

	local questConfig = GameConfig.Quest.quick_finish_board_quest or {}
	local wantedData = data.wantedData
	local questMinLimit,questMaxLimit = wantedData.LevelRange[1],wantedData.LevelRange[2]
	local dont = LocalSaveProxy.Instance:GetDontShowAgain(55)
	local single
	local itemId
	local minLv
	local maxLv
	if(dont == nil)then
		for i=1,#questConfig do
			single = questConfig[i]
			itemId = single[1] or nil
			minLv = single[2] or 1
			maxLv = single[3] or 999999
			itemData = BagProxy.Instance:GetItemByStaticID(itemId)
			if(self:checkLevelCross(questMinLimit,questMaxLimit,minLv,maxLv) and itemData )then
				MsgManager.DontAgainConfirmMsgByID(55,
				 function ()
					AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
					ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD,self.questId)
				 end,
				 function (  )
				 	AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
				 	ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT,self.questId)
				 end, nil, itemData:GetName(true,true))
				return true
			end
		end
	else
		for i=1,#questConfig do
			single = questConfig[i]
			itemId = single[1] or nil
			minLv = single[2] or 1
			maxLv = single[3] or 999999
			itemData = BagProxy.Instance:GetItemByStaticID(itemId)
			if(self:checkLevelCross(questMinLimit,questMaxLimit,minLv,maxLv) and itemData)then
				AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
				ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD,self.questId)
				return true
			end
		end
	end
end

function AnnounceQuestPanel:start( obj )

end

function AnnounceQuestPanel:questClick( obj )
	-- body
	if(obj)then
		self.questId = obj.data.id
	-- 	self:playQuestCompleteAnim(obj)
	-- 	return
	end
	if(obj.data.notMine)then
		helplog("MainViewTaskQuestPage:CallAcceptHelpWantedTeamCmd(  ):",obj.data.id)
		ServiceSessionTeamProxy.Instance:CallAcceptHelpWantedTeamCmd(obj.data.id,false)
	elseif(obj and obj.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE)then
			-- printRed("领取")		
		self:playQuestCompleteAnim(obj)
		AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Commit)
	elseif(obj and obj.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
		-- printRed("接取")
		if(self.submitCount >= QuestProxy.Instance:getMaxWanted())then
			MsgManager.ShowMsgByIDTable(901)
			return
		elseif(self.hasGoingQuest)then
			MsgManager.ShowMsgByIDTable(900)
			return
		elseif(self:checkWantedTick(obj.data))then
			return
		end
		AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
		ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT,self.questId)
	else
		-- printRed("放弃")
		if(self.questId)then
			MsgManager.ConfirmMsgByID(903, function ()
				local npcs =  NSceneNpcProxy.Instance:FindNpcs(1016)
				if(npcs and #npcs >0)then
					ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ABANDON_GROUP,self.questId)
					ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT,self.wantedId)							
				end
			end, nil)
		end
	end
end