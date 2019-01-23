autoImport("TaskQuestCell")
autoImport("DeathPopView")
autoImport("QuestDetailTip")
MainViewTaskQuestPage = class("MainViewTaskQuestPage",SubView)

--ZGBTODO
--  去除gameobjpool 
-- effectmap
-- 	控制人物表现 通过ncreature.client_xxx 

	-- 播放动作不再支持循环次数，只能设置是否循环
	-- Game.Config_Action
	-- Game.Config_Action["action_name"] = Table_ActionAnime[action_id]

	--人物死亡动作回调


	-- LuaGameObject新增GetProperty和GetComponent接口

	-- Game.Config_Action
-- Game.Config_Action["action_name"] = Table_ActionAnime[action_id]
-- 将以前的ID，改为项目里resources/public/effect下相对完整路径+文件名
-- 金币
	-- Mapmanager nsceneUserproxy luacolor
--photoAi -- questIcon --share --adventureture -- npcEffect

local tempVector3 = LuaVector3.zero

function MainViewTaskQuestPage:Init()		
	self:AddViewEvts()
	self:initView()
	self:initData()
	self:initQusetList()
	self.currentMapId = 0
	self.isInFuben = false
	self.isInHand = false
end

function MainViewTaskQuestPage:initData(  )
	-- body
	self.appearAmMap = {}
	self.onGoingQuestId = nil
end

function MainViewTaskQuestPage:initView(  )
	-- body	
	self.gameObject = self:FindGO("TaskQuestBord")
	self.foldSymbol = self:FindGO("taskCellFoldSymbol")
	self.taskBordFoldSymbol = self:FindGO("taskBordFoldSymbol")
	local taskCellFoldSymbolSp = self:FindComponent("taskCellFoldSymbol",UISprite)
	self:AddClickEvent(self.taskBordFoldSymbol,function (  )
		-- body
		TipManager.Instance:ShowTaskQuestTip(taskCellFoldSymbolSp,NGUIUtil.AnchorSide.Left,{-450,0})
	end)
	self:AddClickEvent(self.foldSymbol)
	-- self:AddClickEvent(self.foldSymbol,function (  )
	-- 	-- body
	-- 	local cellCtrl = self:getTraceCellByQuestId( self.onGoingQuestId )
	-- 	local panel = self.scrollview.panel
	-- 	local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform,cellCtrl.gameObject.transform)
	-- 	local offset = panel:CalculateConstrainOffset(bound.min,bound.max)
	-- 	offset = Vector3(0,offset.y,0)
	-- 	self.scrollview:MoveRelative(offset)
	-- 	self:Log("AddClickEvent",offset.y)
	-- end)

	self.playTweens =  self.foldSymbol:GetComponents(UIPlayTween)
	self.rotationTwn = self.foldSymbol:GetComponent(TweenRotation)
	self.scrollview = self:FindGO("taskQuestScrollView"):GetComponent(UIScrollView);
	self.EffectPanel = self:FindGO("EffectPanel")
	self.taskBord = self:FindChild("taskBord")
	self.taskQuestTable =  self.taskBord:GetComponent(UITable)
	self.questList = UIGridListCtrl.new(self.taskQuestTable,TaskQuestCell,"TaskQuestCell")
	self.questList:AddEventListener(MouseEvent.MouseClick,self.questCellClick,self)	
	local objLua = self.gameObject:GetComponent(GameObjectForLua)
	objLua.onEnable = function (  )
		-- body
		LeanTween.delayedCall(0.8, function ()
			self:adjustScrollView()
		end)		
	end
end

function MainViewTaskQuestPage:adjustScrollView(  ) 
	-- body
	-- self:Log("adjustScrollView RestrictWithinBounds")
	self.questList:Layout()
	self.scrollview:RestrictWithinBounds(true)
	-- self.scrollview:ResetPosition()

	-- local bound = NGUIMath.CalculateRelativeWidgetBounds(self.taskBord.transform,true)
	-- if(self.scrollview and self.scrollview.panel)then
	-- 	local panel = self.scrollview.panel
	-- 	local y = panel:GetViewSize().y
	-- 	if(bound.size.y < y)then
	-- 	end
	-- end
end

function MainViewTaskQuestPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.QuestQuestUpdate)
	self:AddListenEvt(ServiceEvent.QuestQuestList, self.setQuestData)
	self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate,self.QuestQuestStepUpdate)
	self:AddListenEvt(ServiceEvent.QuestQueryOtherData,self.QuestQueryOtherData)
	self:AddListenEvt(ItemEvent.ItemUpdate,self.ItemUpdate)
	self:AddListenEvt(MyselfEvent.MyDataChange,self.ItemUpdate)
	self:AddListenEvt(ServiceEvent.PlayerMapChange,self.handlePlayerMapChange)
	self:AddListenEvt(QuestEvent.QuestDelete,self.questDelete)
	self:AddListenEvt(MyselfEvent.DeathBegin,self.handleDeathStatus)
	self:AddListenEvt(ServiceEvent.FuBenCmdTrackFuBenUserCmd,self.FuBenCmdTrackFuBenUserCmd)
	self:AddListenEvt(QuestEvent.ProcessChange,self.ProcessChange)
	self:AddListenEvt(QuestEvent.RemoveHelpQuest,self.RemoveHelpQuest)
	self:AddListenEvt(QuestEvent.UpdateAnnounceQuestList,self.UpdateAnnounceQuestList)
	self:AddListenEvt(QuestEvent.RemoveGuildQuestList,self.RemoveGuildQuestList)
	self:AddListenEvt(QuestEvent.UpdateGuildQuestList,self.UpdateGuildQuestList)
	-- self:AddListenEvt(MissionCommandEvent.MissionCommandEvent,self.handleMissionCommand)
	

	local eventManager = EventManager.Me()
	eventManager:AddEventListener(MyselfEvent.SceneGoToUserCmdHanded, self.SceneGoToUserCmd, self)
	eventManager:AddEventListener(FunctionQuest.UpdateTraceInfo,self.updateTraceInfo,self)
	eventManager:AddEventListener(FunctionQuest.RemoveTraceInfo,self.RemoveTraceInfo,self)
	eventManager:AddEventListener(FunctionQuest.AddTraceInfo,self.AddTraceInfo,self)
	eventManager:AddEventListener(HandEvent.MyStartHandInHand,self.MyStartHandInHand,self)
	eventManager:AddEventListener(HandEvent.MyStopHandInHand,self.MyStopHandInHand,self)
	eventManager:AddEventListener(MyselfEvent.MissionCommandChanged,self.handleMissionCommand,self)
end

function MainViewTaskQuestPage:UpdateGuildQuestList( note )
	local upQuests = note.body
	for k,v in pairs(upQuests) do
		-- helplog("UpdateGuildQuestList remove taskcell:",k,v.staticData.TraceInfo)
		local cell,index = self:getTraceCellByQuestId(k)
		if(cell)then
			resetPos = true
			cell:SetData(cell.data)
		end
	end
	if(resetPos)then
		self.questList:Layout()
	end
	self:selectShowDirQuest(self.onGoingQuestId,true)
end

function MainViewTaskQuestPage:RemoveGuildQuestList( note )
	
	local rmQuests = note.body
	for k,v in pairs(rmQuests) do
		-- helplog("RemoveGuildQuestList remove taskcell:",k,v.staticData.TraceInfo)
		local cell,index = self:getTraceCellByQuestId(k)
		if(cell)then
			resetPos = true
			self.questList:RemoveCell(index)
		end
	end
	if(resetPos)then
		self.questList:Layout()
		self.scrollview:InvalidateBounds() 
		self.scrollview:RestrictWithinBounds(true)
	end
end

function MainViewTaskQuestPage:RemoveHelpQuest( note )
	-- body
	local ids = note.body;
	if(type(ids)=="number")then
		ids = {ids};
	end
	for i=1,#ids do
		-- helplog("MainViewTaskQuestPage:RemoveHelpQuest(  ):",ids[i])
		ServiceSessionTeamProxy.Instance:CallAcceptHelpWantedTeamCmd(ids[i],true)
	end
end

function MainViewTaskQuestPage:UpdateAnnounceQuestList( note )
	-- body
	local questId = note.body;
	local cell = self:getTraceCellByQuestId(questId)
	local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
	if(cell and data)then
		cell:SetData(data)
		local updateList = cell.bgSizeChanged
		if(updateList)then
			self.taskQuestTable.repositionNow = true
		end
	end
	self:selectShowDirQuest(self.onGoingQuestId,true)
end

function MainViewTaskQuestPage:removeAppearAnm( id )
	-- body
	self.appearAmMap[id] = nil
end

function MainViewTaskQuestPage:checkCellIsVisible( widget )
	-- body
	local panel = self.scrollview.panel
	if(panel)then
		return panel:IsVisible(widget)
	end
end

function MainViewTaskQuestPage.effectLoaded(effectObj, pos )
	-- body
	if(not LuaGameObject.ObjectIsNull(effectObj))then
		effectObj.transform.localPosition = pos
	end
end

function MainViewTaskQuestPage:playTaskAppearAnm( cell )
	-- body
	-- printRed("playTaskAppearAnm")
	if(cell.data.getIfShowAppearAnm and cell.data:getIfShowAppearAnm() and not self.appearAmMap[cell.data.id])then
		if(self:checkCellIsVisible(cell.title))then
			-- LogUtility.Info("playTaskAppearAnm")
			self.appearAmMap[cell.data.id] = true
			--ZGBTODO
			tempVector3:Set(LuaGameObject.InverseTransformPointByTransform(self.EffectPanel.transform,cell.title.transform, Space.World))
			self:PlayUIEffect(EffectMap.UI.Refresh,self.EffectPanel,true,MainViewTaskQuestPage.effectLoaded,tempVector3)
			
			LeanTween.delayedCall(0.5, function ()
				self:removeAppearAnm(cell.data.id)
				cell.data:setIfShowAppearAnm(false)
			end)
		else
			-- printRed("widget is invisible")
		end
	end
end

function MainViewTaskQuestPage:ItemUpdate(  )
	-- body
	--item quest
	local cells = self.questList:GetCells()
	-- printRed("ItemUpdate",id,step)
	for j=1,#cells do
		local cell = cells[j]
		local data = cell.data
		-- printRed(cell.data:getIfShowAppearAnm())
		if(QuestProxy.Instance:checkUpdateWithItemUpdate(data))then
			local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id,SceneQuest_pb.EQUESTLIST_ACCEPT)
			if(questData)then
				cell:SetData(questData)
			end
		end		
	end	
	self:selectShowDirQuest(self.onGoingQuestId,true)
end


function MainViewTaskQuestPage:QuestQueryOtherData(  )
	-- body
	--daily quest
	local cells = self.questList:GetCells()
	-- printRed("QuestQueryOtherData",id,step)
	for j=1,#cells do
		local cell = cells[j]
		local data = cell.data
		-- printRed(cell.data:getIfShowAppearAnm())
		if(QuestDataType.QuestDataType_DAILY == data.type)then
			local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id,SceneQuest_pb.EQUESTLIST_ACCEPT)			
			if(questData)then
				cell:SetData(questData)
			end
		end
	end
	self:selectShowDirQuest(self.onGoingQuestId,true)
end

function MainViewTaskQuestPage:QuestQuestUpdate( note )
	-- body
	self:setQuestData()
	local data = note.body
	local items = data.items
	-- self:Log("MainViewTaskQuestPage:QuestQuestUpdate( note )1:")
	if(items)then
		-- self:Log("MainViewTaskQuestPage:QuestQuestUpdate( note )2:")
		local topIndex = 99999
		local topCell
		for i=1,#items do
			local item = items[i]
			local del = item.del
			local update = item.update
			local type = item.type
			if(type == SceneQuest_pb.EQUESTLIST_ACCEPT)then
				if(update)then
					for i=1,#update do
						local single = update[i]
						local cell,index = self:getTraceCellByQuestId(single.id)
						-- self:Log("MainViewTaskQuestPage:QuestQuestUpdate( note )1:",index,single.id)
						if(cell and QuestProxy.Instance:checkIsShowDirAndDis(cell.data))then
							-- self:Log("MainViewTaskQuestPage:QuestQuestUpdate( note )2:",QuestProxy.Instance:checkIsShowDirAndDis(cell.data))
							if(index < topIndex)then
								topIndex = index
								topCell = cell
							end
						end
					end
				end
				break
			end
		end
		if(topCell)then
			-- self:Log("MainViewTaskQuestPage:QuestQuestUpdate( note ):",topCell.data.id,self.onGoingQuestId)
			self:stopShowDirAndDis(self.onGoingQuestId)
			self:ShowDirAndDis(topCell)
			return
		end
	end
	-- self:Log("MainViewTaskQuestPage:QuestQuestUpdate( note ) selectShowDirQuest:",self.onGoingQuestId)
	self:selectShowDirQuest(self.onGoingQuestId)
end

function MainViewTaskQuestPage:QuestQuestStepUpdate( note )
	-- body
	self:setQuestData()
	-- self:Log("MainViewTaskQuestPage:QuestQuestStepUpdate( note ):",questId)
	local data = note.body
	local questId = data.id
	if(questId ~= self.onGoingQuestId)then
		local cell = self:getTraceCellByQuestId(questId)
		if(cell and QuestProxy.Instance:checkIsShowDirAndDis(cell.data))then
			self:stopShowDirAndDis(self.onGoingQuestId)
			self:ShowDirAndDis(cell)
			return
		end
	end

	self:selectShowDirQuest(self.onGoingQuestId)
end

function MainViewTaskQuestPage:ProcessChange( note )
	-- body
	-- self:Log("MainViewTaskQuestPage:QuestQuestStepUpdate( note ):",questId)
	local data = note.body
	local questId = data.id
	local cell = self:getTraceCellByQuestId(questId)
	if(cell)then
		local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId,SceneQuest_pb.EQUESTLIST_ACCEPT)
		if(questData)then
			cell:SetData(questData)
			local updateList = cell.bgSizeChanged
			if(updateList)then
				self.taskQuestTable.repositionNow = true
			end
		end
	end
	if(questId ~= self.onGoingQuestId)then
		if(cell and QuestProxy.Instance:checkIsShowDirAndDis(cell.data))then
			self:stopShowDirAndDis(self.onGoingQuestId)
			self:ShowDirAndDis(cell)
			return
		end
	end

	self:selectShowDirQuest(self.onGoingQuestId,true)
end

function MainViewTaskQuestPage:initQusetList(  )
	-- body
	self:setQuestData(true)
	local id = LocalSaveProxy.Instance:getLastTraceQuestId()
	self:selectShowDirQuest(id)
end

function MainViewTaskQuestPage:selectShowDirQuest( id ,noMove)
	-- body
	local result  = self:ShowDirAndDisByQuestId(id,noMove)
	if(not result)then
		local cells = self.questList:GetCells()
		for j=1,#cells do
			local cell = cells[j]
			local data = cell.data
			local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(data)
			if(isShowDirAndDis)then
				self:ShowDirAndDis(cell,noMove)
				break
			end
		end
	end
end

function MainViewTaskQuestPage:RemoveTraceInfo( traceData )
	if(traceData)then
		local id = traceData.id
		local type = traceData.type
		local cell,index = self:getTraceCellByQuestId(id,type)
		local resetPos = false
		if(cell)then
			resetPos = true
			self.questList:RemoveCell(index)
		end
		if(resetPos)then
			self.questList:Layout()
			self.scrollview:InvalidateBounds() 
			self.scrollview:RestrictWithinBounds(true)
		end
	end
end

function MainViewTaskQuestPage:AddTraceInfo( traceData )
	if(traceData)then
		local id = traceData.id
		local type = traceData.type
		local list =  QuestProxy.Instance:getValidAcceptQuestList(true)	
		local traceDatas = QuestProxy.Instance:getTraceDatas()
		if(traceDatas)then
			for i=1,#traceDatas do
				local single = traceDatas[i]
				table.insert(list,single)
			end
		end
		QuestProxy.Instance:SetTraceCellCount(#list)
		self:sortTraceDatas(list)

		local index = 1
		for j=1,#list do
			local data = list[j]
			if(id == data.id and type == data.type)then
				index = j
				break
			end
		end
		local cell = self.questList:AddCell(traceData,index)
		cell.gameObject.transform:SetSiblingIndex(index-1)
		self.questList:Layout()
		self.scrollview:InvalidateBounds() 
		self.scrollview:RestrictWithinBounds(true)
	end
end

function MainViewTaskQuestPage:updateTraceInfo( traceData )
	-- body
	if(traceData)then
		local id = traceData.id
		local type = traceData.type
		local cell = self:getTraceCellByQuestId(id,type)

		local resetPos = false
		if(cell)then
			cell:SetData(traceData)
			resetPos = cell.bgSizeChanged
		end
		if(resetPos)then
			self.questList:Layout()
		end
	end
end

function MainViewTaskQuestPage:MyStartHandInHand( isSelf )
	-- body
	-- printRed("receive HandEvent.MyStartHandInHand")
	local handed,handowner = Game.Myself:IsHandInHand();
	self.isInHand = true
	if(handed and not handowner)then
		self:folderSymbol(false)
	end
end

function MainViewTaskQuestPage:MyStopHandInHand( isSelf )
	-- body
	-- printRed("receive HandEvent.MyStopHandInHand")
	self.isInHand = false	
	if(not self.isInFuben)then
		local handed,handowner = Game.Myself:IsHandInHand();
	    if(handed and not handowner)then
			self:folderSymbol(true)
		end
	end
end

function MainViewTaskQuestPage:questCellClick( cellCtrl )
	-- body
	-- helplog("questCellClick!!!")
	if(cellCtrl and cellCtrl.data )then
		local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data)
		-- helplog("questCellClick!!!:",cellCtrl.data.id,cellCtrl.data.step,isShowDirAndDis,self.onGoingQuestId)
		if(isShowDirAndDis)then
			if(cellCtrl.data.id ~= self.onGoingQuestId)then
				self:stopShowDirAndDis(self.onGoingQuestId)
				self:ShowDirAndDis(cellCtrl)
				Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.data.id)
			else
				self:ShowDirAndDis(cellCtrl)
				Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.data.id)
			end
		else
			FunctionQuest.Me():executeQuest(cellCtrl.data)
		end

		FunctionGuide.Me():AddMapGuide(cellCtrl.data.map)
	end
end

function MainViewTaskQuestPage:ShowDirAndDis( cellCtrl,noMove )
	-- body
	-- self:Log("ShowDirAndDis:",cellCtrl.data.id,cellCtrl.data.step,noMove)
	local args = ReusableTable.CreateTable()
	local questData = cellCtrl.data
	args.questData = questData
	args.owner = cellCtrl
	args.callback = cellCtrl.Update	
	FunctionQuestDisChecker.Me():AddQuestCheck(args)
	ReusableTable.DestroyAndClearTable(args)
	
	FunctionQuest.Me():addQuestMiniShow(questData)
	FunctionQuest.Me():addMonsterNamePre(questData)	

	cellCtrl:setISShowDir(true)
	self.onGoingQuestId = cellCtrl.data.id
	LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
	if(not noMove)then
		if(not self:ObjIsNil(self.gameObject))then
			LeanTween.cancel(self.gameObject)
			LeanTween.delayedCall(self.gameObject,1,function (  )
				-- body
				if(not self:ObjIsNil(cellCtrl.gameObject))then
					local panel = self.scrollview.panel
					local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform,cellCtrl.gameObject.transform)
					local offset = panel:CalculateConstrainOffset(bound.min,bound.max)
					offset = Vector3(0,offset.y,0)
					self.scrollview:MoveRelative(offset)
				end
				-- self:Log("LeanTween.delayedCall:",tostring(offset))
			end)
		end
	end
end


function MainViewTaskQuestPage:getTraceCellByQuestId( id ,type)
	-- body
	if(id)then
		local cells = self.questList:GetCells()
		for j=1,#cells do
			local cell = cells[j]
			local data = cell.data
			if(data and id == data.id and not type)then
				return cell,j
			elseif(data and id == data.id and type == data.type)then
				return cell,j
			end
		end
	end
end

function MainViewTaskQuestPage:ShowDirAndDisByQuestId( id ,noMove)
	-- body
	if(id)then
		local cellCtrl = self:getTraceCellByQuestId(id)
		if(cellCtrl and QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data))then
			self:ShowDirAndDis(cellCtrl,noMove)
			return true
		end
	end
	self.onGoingQuestId = nil
	return false
end

function MainViewTaskQuestPage:stopShowDirAndDis( id )
	-- body
	if(id)then
		-- body
		FunctionQuest.Me():stopQuestMiniShow(id)
		local cells = self.questList:GetCells()
			-- printRed("ItemUpdate",id,step)
		for j=1,#cells do
			local cell = cells[j]
			local data = cell.data
			-- printRed(cell.data:getIfShowAppearAnm())
			if(data and id == data.id)then
				FunctionQuestDisChecker.RemoveQuestCheck(id)
				cell:setISShowDir(false)
				break
			end
		end
	end
end

-- function MainViewTaskQuestPage:handleMissionCommand( note )
-- 	-- body
-- 	local body = note.body
-- 	local isOngoing = body.isOngoing
-- 	self:setQuestIsOngoing(body.questDt,isOngoing)
-- end

function MainViewTaskQuestPage:handleMissionCommand( note )
	-- body
	local data = note.data
	local oldCmd = data[1]
	local newCmd = data[2]
	local oldQuestId
	local newQuestId
	if(oldCmd)then
		oldQuestId = oldCmd.args.custom
	end

	if(newCmd)then
		newQuestId = newCmd.args.custom
	end

	if(oldQuestId and oldQuestId ~= newQuestId)then
		local cell = self:getTraceCellByQuestId(oldQuestId)
		if(cell)then
			cell:setIsOngoing(false)
		end
	end

	if(newQuestId and oldQuestId ~= newQuestId)then
		local cell = self:getTraceCellByQuestId(newQuestId)
		if(cell)then
			cell:setIsOngoing(true)
		end
	end
end

-- function MainViewTaskQuestPage:setQuestIsOngoing( questData,isOngoing )
-- 	-- body
-- 	if(not questData)then
-- 		-- printRed("setQuestIsOngoing questData is nil")
-- 		return
-- 	end
-- 	-- LogUtility.Info("setQuestIsOngoing id:"..questData.id.."step:"..questData.step)
-- 	-- printRed(isOngoing)
-- 	-- local questId = math.floor(questData.id/GameConfig.Quest.ratio)
-- 	local cells = self.questList:GetCells()
-- 	for i=1,#cells do
-- 		local single = cells[i]
-- 		-- printRed(single.data.id)
-- 		-- printRed(single.data.step)
-- 		-- local singQuestId = math.floor(single.data.id/GameConfig.Quest.ratio)
-- 		if(single.data and single.data.id == questData.id and single.data.step == questData.step)then
-- 			single:setIsOngoing(isOngoing)
-- 		else
-- 			single:setIsOngoing(false)
-- 		end
-- 	end
-- end

function MainViewTaskQuestPage:setQuestData(resetPos,noAppearAm)
	local list =  QuestProxy.Instance:getValidAcceptQuestList(true)
	local myself = Game.Myself;
	local currentProfession = MyselfProxy.Instance:GetMyProfession()
	local destProfession = myself.data.userdata:Get(UDEnum.DESTPROFESSION);

	if(not myself or not myself.data)then
		self.questList:RemoveAll()
		return
	end
	local traceDatas = QuestProxy.Instance:getTraceDatas()
	if(traceDatas)then
		for i=1,#traceDatas do
			local single = traceDatas[i]
			table.insert(list,single)
		end
	end
	QuestProxy.Instance:SetTraceCellCount(#list)
	if(list == nil or #list == 0)then
		-- self:folderSymbol(false)
		-- self.foldSymbol:SetActive(false)
	else
		-- self:folderSymbol(true)
		-- self.foldSymbol:SetActive(true)
	end
	QuestProxy.Instance:checkIfNeedStopMissionTrigger()
	QuestProxy.Instance:checkIfNeedRemoveGuideView()
	if(not list or #list == 0)then
		self.questList:RemoveAll()
		return 
	end

	self:sortTraceDatas(list)
	self.questList:ResetDatas(list)
	self.taskQuestTable.repositionNow = true
	-- self.scrollview:InvalidateBounds()
	self.scrollview:RestrictWithinBounds(true);	
	-- self.questList:Layout()
	if(resetPos)then
		self.scrollview:ResetPosition();
	end
	local curCmdData = FunctionQuest.Me():getCurCmdData(  )
	if(curCmdData)then
		self:setQuestIsOngoing(curCmdData,true)
	end
	if(not noAppearAm)then
		self:playAppearAnm()
	end
end

function MainViewTaskQuestPage:playAppearAnm(  )
	-- body
	local cells = self.questList:GetCells()
	for i=1,#cells do
		local single = cells[i]
		-- printRed(single.data.id)
		local data = single.data
		if(data)then
			self:playTaskAppearAnm(single)
		end
	end
end

local func = function (t1,t2)
	if(t1.type == t2.type)then
		if(t1.type == QuestDataType.QuestDataType_WANTED)then
			return t1.time > t2.time
		else
			return t1.orderId < t2.orderId	
		end			
	elseif(t1.type == QuestDataType.QuestDataType_INVADE)then
		return true
	elseif(t2.type == QuestDataType.QuestDataType_INVADE)then
		return false
	elseif(t1.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO)then
		return true
	elseif(t2.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO)then
		return false
	else
		if(t1.type == QuestDataType.QuestDataType_WANTED)then
			return true
		elseif(t2.type == QuestDataType.QuestDataType_WANTED)then
			return false
		elseif(t1.type == QuestDataType.QuestDataType_MAIN)then
			return true
		elseif(t2.type == QuestDataType.QuestDataType_MAIN)then
			return false
		elseif(t1.type == QuestDataType.QuestDataType_SEALTR)then
			return true
		elseif(t2.type == QuestDataType.QuestDataType_SEALTR)then
			return false
		elseif(t1.type == QuestDataType.QuestDataType_DAILY)then
			return true
		elseif(t2.type == QuestDataType.QuestDataType_DAILY)then
			return false
		elseif(t1.type == QuestDataType.QuestDataType_BRANCH)then
			return true
		elseif(t2.type == QuestDataType.QuestDataType_BRANCH)then
			return false
		else
			return t1.type == QuestDataType.QuestDataType_ITEMTR
		end
	end
end

function MainViewTaskQuestPage:sortTraceDatas( questList)
	-- body
	if(questList ~=nil and #questList ~=0 )then
		table.sort(questList,func)
	end	
end

function MainViewTaskQuestPage:addItemTraces( list,itemTrs )
	-- body
	if(itemTrs)then
		for i=1,#itemTrs do
			local single = itemTrs[i]
			table.insert(list,single)
		end
	end
end

function MainViewTaskQuestPage:questDelete( note )
	local data = note.body
	for i=1,#data do
		local single = data[i]		
		self:removeAppearAnm(single.id)
	end
end

function MainViewTaskQuestPage:handleDeathStatus( note )
	-- body
	-- self:sendNotification(UIEvent.CloseUI,DeathPopView.ViewType)
end

function MainViewTaskQuestPage:FuBenCmdTrackFuBenUserCmd( note )
	-- body	
	self.isInFuben = true
	-- if(self.isInHand)
	self:folderSymbol(false)
end

function MainViewTaskQuestPage:folderSymbol( state )
	-- body
	-- AnimationOrTween.Direction.Reverse
	if(self.playTweens)then
		if(not state and self.rotationTwn.tweenFactor == 0)then
			for i=1,#self.playTweens do
				local single = self.playTweens[i]
				single:Play(true)
			end
		elseif(state and self.rotationTwn.tweenFactor == 1)then
			for i=1,#self.playTweens do
				local single = self.playTweens[i]
				single:Play(true)
			end
		end
	end
end

function MainViewTaskQuestPage:OnExit(  )
	-- body
	MainViewTaskQuestPage.super.OnExit(self)
	EventManager.Me():RemoveEventListener(FunctionQuest.UpdateTraceInfo,self.updateTraceInfo,self)
	EventManager.Me():RemoveEventListener(FunctionQuest.RemoveTraceInfo,self.RemoveTraceInfo,self)
	EventManager.Me():RemoveEventListener(FunctionQuest.AddTraceInfo,self.AddTraceInfo,self)
	EventManager.Me():RemoveEventListener(HandEvent.MyStartHandInHand,self.MyStartHandInHand,self)
	EventManager.Me():RemoveEventListener(HandEvent.MyStopHandInHand,self.MyStopHandInHand,self)
	EventManager.Me():RemoveEventListener(HandEvent.SceneGoToUserCmdHanded,self.SceneGoToUserCmd,self)
	EventManager.Me():RemoveEventListener(MyselfEvent.MissionCommandChanged,self.handleMissionCommand,self)
	TimeTickManager.Me():ClearTick(self)
end

function MainViewTaskQuestPage:handlePlayerMapChange( note )
	-- body
	if(note.type == LoadSceneEvent.StartLoad) then
		return
	end

	self:MapChange()	

	local data = note.body
	if(self.currentMapId ~= 0 and  data.dmapID == 0)then
		if(not self.isInHand)then
			self:folderSymbol(true)
		end
		self.isInFuben = false
		self:sendNotification(UIEvent.CloseUI,DeathPopView.ViewType)
	end
	self.currentMapId = data.dmapID
	if(note.type == LoadSceneEvent.StartLoad)then
		local cells = self.questList:GetCells()
		for i=1,#cells do
			cells[i]:setIsSelected(false)
		end
	end
end

function MainViewTaskQuestPage:MapChange( )
	-- body
	-- LeanTween.cancel(self.gameObject)
		-- body
	local cellCtrl =  self:getTraceCellByQuestId(self.onGoingQuestId)
	if(cellCtrl and cellCtrl.data)then
		FunctionQuest.Me():addQuestMiniShow(cellCtrl.data)
	end
end

function MainViewTaskQuestPage:SceneGoToUserCmd(  )
	-- body
	self:MapChange()
end