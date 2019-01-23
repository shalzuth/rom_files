autoImport("ActivityData");

FunctionActivity = class("FunctionActivity")

local math_floor = math.floor;
local tempArray = {};

FunctionActivity.TraceType = {
	NeedRefresh = 0,
	Refreshed = 1,
	Update = 2,
}

local MapManager;

function FunctionActivity.Me()
	if nil == FunctionActivity.me then
		FunctionActivity.me = FunctionActivity.new()
	end
	return FunctionActivity.me
end

function FunctionActivity:ctor()
	self.activityDataMap = {};
	self.tracedActivityMap = {};
	self.delayLTMap = {};

	self.countDownDataMap = {};

	MapManager = Game.MapManager;
end

function FunctionActivity:GetMapEvents(mapid)
	TableUtility.ArrayClear(tempArray);
	for activityType, activityData in pairs(self.activityDataMap)do
		if(activityData.mapid == mapid)then
			table.insert(tempArray, activityData);
		end
	end
	return tempArray;
end

function FunctionActivity:Launch(activityType, mapid, startTime, endTime)
	
	-- if(startTime ~= endTime)then
	-- 	local logStr = "";
	-- 	logStr = "活动开启 --> ";
	-- 	local dateFormat = "%m月%d日%H点%M分%S秒";
	-- 	logStr = logStr .. string.format(" | activityType:%s | 地图Id:%s | 开始时间:%s | 结束时间:%s | 当前时间:%s | ",
	-- 		tostring(activityType),
	-- 		tostring(mapid), 
	-- 		os.date(dateFormat, startTime), 
	-- 		os.date(dateFormat, endTime),
	-- 		os.date(dateFormat, ServerTime.CurServerTime()/1000));
	-- 	helplog(logStr);
	-- end

	local nowtime = ServerTime.CurServerTime()/1000;
	if(startTime ~= endTime)then
		if(nowtime < startTime + 0.5 or nowtime > endTime - 0.5)then
			self:EndActivity(activityType);
			return;
		end
	end
	
	self:EndActivity(activityType);

	-- setData
	local activityData = self:AddActivityData(activityType, mapid, startTime, endTime);
	if( activityData:IsShowInMenu() )then
		GameFacade.Instance:sendNotification(MainViewEvent.MenuActivityOpen, activityType)
	end
	if activityType == GameConfig.MvpBattle.ActivityID then
		GameFacade.Instance:sendNotification(MainViewEvent.UpdateMatchBtn)
	end

	self:UpdateNowMapTraceInfo();
end

function FunctionActivity:UpdateState(activityType, state, starttime, endtime)
	local activityData = self.activityDataMap[activityType];
	if(activityData)then
		activityData:SetState( state, starttime, endtime );
		self:UpdateNowMapTraceInfo();
	else
		errorLog(string.format("Activity:%s not Launch when Recv StateUpdate", tostring(activityType)));
	end
end


-- activityData begin
function FunctionActivity:IsActivityRunning(activityType)
	local d = self.activityDataMap[ activityType ];
	if(d == nil)then
		return false;
	end
	return d:InRunningTime();
end

function FunctionActivity:GetActivityData( activityType )
	return self.activityDataMap[ activityType ];
end

function FunctionActivity:AddActivityData(activityType, mapid, startTime, endTime)
	local activityData = ActivityData.new(activityType, mapid, startTime, endTime);
	activityData:SetRunning(true);
	self.activityDataMap[activityType] = activityData;
	return activityData;
end

function FunctionActivity:RemoveActivityData( activityType )
	local oldData = self.activityDataMap[activityType];
	self.activityDataMap[activityType] = nil;

	if(oldData)then
		if(oldData:IsShowInMenu())then
			GameFacade.Instance:sendNotification(MainViewEvent.MenuActivityClose, activityType)
		end
		oldData:Destroy();
	end
end

function FunctionActivity:GetActivityDataMap()
	return self.activityDataMap;
end
-- activityData end



-- traceInfo begin
local tempTraceCells = {};
function FunctionActivity:UpdateNowMapTraceInfo()
	for activityType,_ in pairs(self.tracedActivityMap)do
		if(not self.activityDataMap[activityType])then
			local data = {};
			data.type = ActivityData.GetTraceQuestDataType(activityType);
			data.id = ActivityData.CreateIdByType(activityType);
			table.insert(tempTraceCells, data);

			self.tracedActivityMap[activityType] = nil;
		end
	end

	local tracedCount = 0;
	local nowMapId = MapManager:GetMapID();
	for activityType, activityData in pairs(self.activityDataMap)do
		local traceInfo = activityData:GetTraceInfo(nowMapId);
		if(traceInfo == nil)then
			if(self.tracedActivityMap[activityType])then
				local data = {};
				data.type = ActivityData.GetTraceQuestDataType(activityType);
				data.id = ActivityData.CreateIdByType(activityType);
				table.insert(tempTraceCells, data);

				self.tracedActivityMap[activityType] = nil;
			end
		else
			if(activityData:IsTraceInfo_NeedUpdate())then
				self.tracedActivityMap[activityType] = FunctionActivity.TraceType.Update;
			else
				self.tracedActivityMap[activityType] = FunctionActivity.TraceType.NeedRefresh;
			end
			tracedCount = tracedCount + 1;
		end
	end

	if(#tempTraceCells > 0)then
		QuestProxy.Instance:RemoveTraceCells( tempTraceCells );
		TableUtility.ArrayClear(tempTraceCells);
	end

	if(tracedCount == 0)then
		self:RemoveTraceTimeTick();
	else
		self:AddTraceTimeTick();
	end
end

function FunctionActivity:AddTraceTimeTick()
	if(not self.traceTimeTick)then
		self.traceTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateActivityTraceInfos, self, 1);
	end
end

function FunctionActivity:RemoveTraceTimeTick()
	if(self.traceTimeTick)then
		TimeTickManager.Me():ClearTick(self, 1);
		self.traceTimeTick = nil;
	end
end

function FunctionActivity:UpdateActivityTraceInfos()
	local needUpdate, activityData;
	for traceAType,traceType in pairs(self.tracedActivityMap) do
		needUpdate = false;
		if(traceType == FunctionActivity.TraceType.NeedRefresh)then
			self.tracedActivityMap[traceAType] = FunctionActivity.TraceType.Refreshed;
			needUpdate = true;
		elseif(traceType == FunctionActivity.TraceType.Update)then
			needUpdate = true;
		end

		activityData = self.activityDataMap[traceAType];
		if(activityData)then
			if(activityData.running and activityData:IsEnd())then
				self:ShutDownActivity(traceAType);
			else
				if(needUpdate)then
					-- time end	shutdown
					local traceInfo = activityData:GetTraceInfo( MapManager:GetMapID() );
					if(traceInfo)then
						table.insert(tempTraceCells, traceInfo)
					end
				end
			end
		end
	end

	if(#tempTraceCells > 0)then
		QuestProxy.Instance:AddTraceCells(tempTraceCells);
		TableUtility.ArrayClear(tempTraceCells);
	end
end
-- traceInfo end


-- DelayStay begin
function FunctionActivity:AddDelayEndActivity( activityType, delayTime )
	self:RemoveDelayEndActivity(activityType);
	self.delayLTMap[activityType] = LeanTween.delayedCall(delayTime, function ()
		self:EndActivity(activityType);
	end)
end

function FunctionActivity:RemoveDelayEndActivity( activityType )
	local lt = self.delayLTMap[activityType];
	self.delayLTMap[activityType] = nil;
	if(lt)then
		lt:cancel();
	end
end
-- DelayStay end


function FunctionActivity:ShutDownActivity( activityType )
	local activityData = self.activityDataMap[activityType];
	if(activityData == nil)then
		return;
	end
	activityData:SetRunning(false);
	
	local endStaySec = activityData:GetEndStaySec();
	if(endStaySec > 0 and MapManager:GetMapID() == activityData.mapid)then
		self:AddDelayEndActivity(activityType, endStaySec);
	else
		self:EndActivity( activityType );
	end

	if activityType == GameConfig.MvpBattle.ActivityID then
		GameFacade.Instance:sendNotification(MainViewEvent.UpdateMatchBtn,activityType)
	end
end

function FunctionActivity:EndActivity(activityType)
	self:RemoveDelayEndActivity(activityType);
	self:RemoveActivityData(activityType);

	self:UpdateNowMapTraceInfo();
end

function FunctionActivity:Reset()
	for activityType, activityData in pairs(self.activityDataMap)do
		self:EndActivity(activityType);
	end
end

function FunctionActivity:GetOperativeActivity()
end

------------ CountDown Msg Begin ------------
function FunctionActivity:AddCountDownAct(id, startTime, endTime)
	local countDownData = self.countDownDataMap[id];

	if(countDownData == nil)then
		countDownData = {};
		self.countDownDataMap[id] = countDownData;
	end

	countDownData.id = id;
	countDownData.startTime = startTime;
	countDownData.endTime = endTime;
	local effectConfig = GameConfig.ActivityCountDown and GameConfig.ActivityCountDown[id];
	if(effectConfig)then
		countDownData.effectPath = effectConfig.effectPath;
		countDownData.finalEffectPath = effectConfig.finalEffectPath;
	end
	
	self:UpdateCountDownAct();
end

function FunctionActivity:RemoveCountDownAct(id)
	local countDownData = self.countDownDataMap[id];

	if(countDownData == nil)then
		return;
	end

	self.countDownDataMap[id] = nil;
	self:UpdateCountDownAct();
end

function FunctionActivity:UpdateCountDownAct()
	local nowServerTime = ServerTime.CurServerTime()/1000;

	local neetUpdate = false;
	for id, countDownData in pairs(self.countDownDataMap)do
		if(countDownData.endTime > nowServerTime)then
			needUpdate = true;
		end
	end

	if(needUpdate)then
		if(self.countDownTick == nil)then
			self.countDownTick = TimeTickManager.Me():CreateTick(0, 
				33, 
				self._UpdateCountDown, 
				self, 
				2)
		end
	else
		self:RemoveCountDownTick();
	end
end

function FunctionActivity:_UpdateCountDown()
	local nowServerTime = ServerTime.CurServerTime()/1000;
	TableUtility.ArrayClear(tempArray);

	local leftSec;
	for id, data in pairs(self.countDownDataMap)do
		if(nowServerTime >= data.startTime)then
			leftSec = math_floor(data.endTime - nowServerTime);
			if(leftSec < 0)then
				table.insert(tempArray, id);
			else
				if(data.leftSec ~= leftSec)then
					data.leftSec = leftSec;
					self:PlayCountDownEffect(id, leftSec, data.effectPath, data.finalEffectPath);
				end
			end
		end
	end
end

function FunctionActivity:RemoveCountDownTick()
	if(self.countDownTick == nil)then
		return;
	end
	TimeTickManager.Me():ClearTick(self, 2);
end

function FunctionActivity:PlayCountDownEffect(id, leftSec, effectPath, finalEffectPath)
	helplog("PlayCountDownEffect:", effectPath, leftSec);
	if(finalEffectPath and leftSec == 0)then
		FloatingPanel.Instance:PlayMidEffect(finalEffectPath);
		return;
	end

	local callBack = function (effectHandle)
		helplog("callBack:", effectHandle);
		local timeNum = UIUtil.FindComponent("Num", UITexture, effectHandle.gameObject);
		if(timeNum)then
			PictureManager.Instance:SetUI("time_text_" .. leftSec, timeNum)
		end
	end
	FloatingPanel.Instance:PlayMidEffect(effectPath, callBack);
end
------------ CountDown Msg End ------------
