FunctionRepairSeal = class("FunctionRepairSeal")

function FunctionRepairSeal.Me()
	if nil == FunctionRepairSeal.me then
		FunctionRepairSeal.me = FunctionRepairSeal.new()
	end
	return FunctionRepairSeal.me
end

function FunctionRepairSeal:ctor()
end

function FunctionRepairSeal:AccessTarget(target)
	if(target and target:GetCreatureType() == Creature_Type.Npc)then
		if(target.data.staticData.Type == "SealNPC")then
			self:ActiveSeal(target.data.id);
		end
	end
end

function FunctionRepairSeal:ActiveSeal(targetId)
	local nowMapId = Game.MapManager:GetMapID();
	local nowSealItem = SealProxy.Instance:GetSealItem(nowMapId, targetId)
	if(not nowSealItem)then
		printRed(string.format("cannot find map:%s target:%s", tostring(nowMapId), tostring(targetId)));
		return;
	end
	if(nowSealItem.etype == SceneSeal_pb.ESEALTYPE_NORMAL)then
		-- 只有没有开启的封印 修复才需要弹出2次确认窗口，正在修复的不需要弹出
		local sealingItem = SealProxy.Instance:GetSealingItem();
		if(sealingItem)then
			if(nowSealItem.issealing)then
				if(SealProxy.Instance.curvalue<SealProxy.Instance.maxvalue)then
					self:DoConfirmRepair(nowSealItem.id);
				else
					printRed("进度已经到头了 不让点击！");
				end
			else
				MsgManager.ShowMsgByIDTable(1604);
			end
		else
			if(TeamProxy.Instance:IHaveTeam())then
				-- 施放修复封印技能
				self:DoConfirmRepair(nowSealItem.id);
			else
				MsgManager.ShowMsgByIDTable(1607,{confirmHandler = function ()
					GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamFindPopUp, goalid = TeamGoalType.RepairSeal});
				end,cancelHandler = function ()
					RClickFunction.CreateTeam();
				end})
			end
		end
	elseif(nowSealItem.etype == SceneSeal_pb.ESEALTYPE_PERSONAL)then
		-- 个人封印没有限制
		if(nowSealItem.issealing)then
			if(SealProxy.Instance.curvalue<SealProxy.Instance.maxvalue)then
				ServiceSceneSealProxy.Instance:CallBeginSeal(nowSealItem.id);
			else
				printRed("进度已经到头了 不让点击！");
			end
		else
			MsgManager.ConfirmMsgByID(1606, function ()
				ServiceSceneSealProxy.Instance:CallBeginSeal(nowSealItem.id);
			end, nil,nil);
		end
		
	end
end

function FunctionRepairSeal:DoConfirmRepair(sealid)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.RepairSealConfirmPopUp, viewdata = {sealid = sealid} });
end

function FunctionRepairSeal:EnterSealArea()
	-- if(not self.isRepairing)then
	-- 	return;
	-- end
	if(self.isInSealArea)then
		return;
	end
	self.isInSealArea = true;

	UIUtil.EndSceenCountDown(1603)
end

function FunctionRepairSeal:ExitSealArea(isRemove)
	-- if(not self.isRepairing)then
	-- 	return;
	-- end
	if(not self.isInSealArea)then
		return;
	end
	self.isInSealArea = false;

	if(not isRemove)then
		UIUtil.SceneCountDownMsg(1603, {5}, true);
		ServiceSceneSealProxy.Instance:CallSealUserLeave();
	end
end

function FunctionRepairSeal:BeginRepairSeal()
	if(self.isRepairing)then
		return;
	end

	self.isRepairing = true;
	self:RefreshTraceInfo();

	-- FloatingPanel.Instance:ShowMidAlphaMsg(ZhString.MainViewSealInfo_BeginRepairSeal);
end

function FunctionRepairSeal:RefreshSealTimer()
	self:BeginRepairSeal();
	self:RefreshTraceInfo();
end

function FunctionRepairSeal:EndRepairSeal()
	if(not self.isRepairing)then
		return;
	end

	self.isRepairing = false;
	self:RefreshTraceInfo();
	-- FloatingPanel.Instance:ShowMidAlphaMsg(ZhString.MainViewSealInfo_EndRepairSeal);
end

function FunctionRepairSeal:ResetRepairSeal()
	self.isRepairing = false;
	self:CheckSealTraceInfo();
end






-- Seal TraceInfo begin
function FunctionRepairSeal:CheckSealTraceInfo()
	self:RemoveSealTrace();
	
	local sealId = SealProxy.Instance.nowAcceptSeal;
	if(sealId and Table_RepairSeal[sealId])then
		self:AddSealTrace(sealId);
	end
end

function FunctionRepairSeal:AddSealTrace(sealId)

	self.traceInfoData = {
		type = QuestDataType.QuestDataType_SEALTR, -- 任务类型（itemTr sealTr and so on）
		questDataStepType = QuestDataStepType.QuestDataStepType_MOVE,   -- 任务类型（visit kill and so on）
		traceTitle = ZhString.MainViewSealInfo_TraceTitle,   --追踪信息标题
	};

	local sealData = Table_RepairSeal[sealId];

	self.traceInfoData.id = sealId;
	self.traceInfoData.map = sealData.MapID;
	self.mapName = Table_Map[sealData.MapID].NameZh;
	self.traceInfoData.pos = SealProxy.Instance.nowSealPos;

	QuestProxy.Instance:AddTraceCells({ self.traceInfoData });

	self:RefreshTraceInfo();
end

function FunctionRepairSeal:RefreshTraceInfo()
	if(not self.traceInfoData)then
		return;
	end

	local sealProxy = SealProxy.Instance;
	self.sealValue = sealProxy.curvalue/sealProxy.maxvalue;
	self.sealSpeed = sealProxy.speed/sealProxy.maxvalue;

	if(self.isRepairing)then
		if(self.sealSpeed == 0)then
			self:RemoveSealTimer();
			-- self:_UpdateProgress();
		else
			self.timeTick_1 = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateProgress, self, 1);
		end
	else
		self:RemoveSealTimer();
		self.traceInfoData.traceInfo = self.mapName.."\n"..ZhString.MainViewSealInfo_GoRepairPct;
		QuestProxy.Instance:UpdateTraceInfo(self.traceInfoData.type, self.traceInfoData.id, self.traceInfoData.traceInfo);
	end
end

function FunctionRepairSeal:_UpdateProgress()
	if(not self.traceInfoData)then
		self:RemoveSealTimer();
		return;
	end

	local lastTime = self.lastTime or RealTime.time;
	local deltaTime = RealTime.time - lastTime;

	self.sealValue = self.sealValue + self.sealSpeed * deltaTime;
	self.sealValue = math.max(self.sealValue, 0);
	self.sealValue = math.min(self.sealValue, 1);

	local sealPct = math.floor(self.sealValue * 100);
	if(sealPct == 100)then
		self.traceInfoData.traceInfo = self.mapName.."\n"..ZhString.MainViewSealInfo_FinishRepair;
	else
		self.traceInfoData.traceInfo = self.mapName.."\n"..string.format(ZhString.MainViewSealInfo_RepairPct, sealPct);
	end

	QuestProxy.Instance:UpdateTraceInfo(self.traceInfoData.type, self.traceInfoData.id, self.traceInfoData.traceInfo);

	self.lastTime = RealTime.time;
end

function FunctionRepairSeal:RemoveSealTimer()
	if(self.timeTick_1)then
		TimeTickManager.Me():ClearTick(self, 1)
	end
	self.timeTick_1 = nil;
end

function FunctionRepairSeal:RemoveSealTrace()
	self:RemoveSealTimer();

	if(self.traceInfoData)then
		QuestProxy.Instance:RemoveTraceCell( self.traceInfoData.type, self.traceInfoData.id );
	end
	self.traceInfoData = nil;
end
-- Seal TraceInfo end




