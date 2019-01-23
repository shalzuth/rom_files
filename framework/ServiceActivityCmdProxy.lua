autoImport('ServiceActivityCmdAutoProxy')
autoImport('UIModelZenyShop')
ServiceActivityCmdProxy = class('ServiceActivityCmdProxy', ServiceActivityCmdAutoProxy)
ServiceActivityCmdProxy.Instance = nil
ServiceActivityCmdProxy.NAME = 'ServiceActivityCmdProxy'

function ServiceActivityCmdProxy:ctor(proxyName)
	if ServiceActivityCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceActivityCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceActivityCmdProxy.Instance = self
	end
end

function ServiceActivityCmdProxy:RecvBCatUFOPosActCmd(data) 
	self:Notify(ServiceEvent.ActivityCmdBCatUFOPosActCmd, data)
end

function ServiceActivityCmdProxy:RecvStartActCmd(data) 
	-- helplog("Recv-->StartActCmd", data.id);
	FunctionActivity.Me():Launch(data.id, data.mapid, data.starttime, data.endtime, data.path, data.unshowmap);
	self:Notify(ServiceEvent.ActivityCmdStartActCmd, data)
end

function ServiceActivityCmdProxy:RecvStopActCmd(data) 
	-- helplog("Recv-->StopActCmd", data.id);
	FunctionActivity.Me():ShutDownActivity(data.id);
	self:Notify(ServiceEvent.ActivityCmdStopActCmd, data)
end

function ServiceActivityCmdProxy:RecvActProgressNtfCmd(data) 
	-- helplog("Recv-->ActProgressNtfCmd", data.id, data.progress);
	FunctionActivity.Me():UpdateState(data.id, data.progress, data.starttime, data.endtime);
	self:Notify(ServiceEvent.ActivityCmdActProgressNtfCmd, data)
end

function ServiceActivityCmdProxy:RecvStartGlobalActCmd(data) 
	-- helplog("Recv-->StartGlobalActCmd", data.id, data.params[2] and data.params[2]);
	BlackSmithProxy.Instance:SetEquipOptDiscounts(data.type, data.params)
	FriendProxy.Instance:SetRecallActivity(data)

	if data.open then
		if data.type == ActivityCmd_pb.GACTIVITY_CHARGE_DISCOUNT then
			local activityID = data.id
			local productConfID = data.params[1]
			local newProductConfID = data.params[2]
			local times = data.count
			local startTime = data.starttime
			local endTime = data.endtime
			local activityParamsD = {
				[1] = productConfID, -- product configure id
				[2] = times, -- discount times
				[3] = newProductConfID, -- new define product configure id
				[4] = startTime, -- discount start time
				[5] = endTime, -- discount end time
				[6] = activityID, -- activity id
			}
			UIModelZenyShop.Ins():SetActivityParams_Discount(productConfID, activityParamsD)
			UIModelZenyShop.Ins():SetActivityUsedTimes(activityID, 0)
		
		elseif data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_REWARD then
			local activityID = data.id
			local productConfID = data.params[1]
			local multipleNumber = data.params[2]
			local times = data.count
			local startTime = data.starttime
			local endTime = data.endtime
			local activityParamsG = {
				[1] = productConfID, -- product configure id
				[2] = times, -- gain more times
				[3] = multipleNumber, -- gain more multiple number
				[4] = startTime, -- gain more start time
				[5] = endTime, -- gain more end time
				[6] = activityID, -- activity id
			}
			UIModelZenyShop.Ins():SetActivityParams_GainMore(productConfID, activityParamsG)
			UIModelZenyShop.Ins():SetActivityUsedTimes(activityID, 0)
		
		elseif data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_COUNT then
			local activityID = data.id
			local productConfID = data.params[1]
			local times = data.count
			local startTime = data.starttime
			local endTime = data.endtime
			local tempActivityParamsM = {
				[1] = productConfID, -- product configure id
				[2] = times, -- more times times
				[3] = startTime, -- more times start time
				[4] = endTime, -- more times end time
				[5] = activityID -- activity id
			}
			UIModelZenyShop.Ins():SetActivityParams_MoreTimes(productConfID, tempActivityParamsM)
			UIModelZenyShop.Ins():SetActivityUsedTimes(activityID, 0)
		
		elseif data.type == ActivityCmd_pb.GACTIVITY_WEDDING_SERVICE then
			-- local weddingActivityParams = {
			-- 	activityID = data.id,
			-- 	productID = data.params[1],
			-- 	discount = data.params[2],
			-- 	times = data.count,
			-- 	startTime = data.starttime,
			-- 	endTime = data.endtime,
			-- }

			if data.params then
				local j = 1
				for i=1,#data.params/2 do
					WeddingProxy.Instance:AddDiscount(data.params[j],data.params[j+1])
					j = j+2
				end
			end

		elseif data.type == ActivityCmd_pb.GACTIVITY_COUNT_DOWN then
			FunctionActivity.Me():AddCountDownAct(
				data.id,
				data.params[1], 
				data.params[2], 
				data.params[3], 
				data.params[4]);
		end
	else
		if data.type == ActivityCmd_pb.GACTIVITY_CHARGE_DISCOUNT then
			local productConfID = data.params[1]
			UIModelZenyShop.Ins():SetActivityParams_Discount(productConfID, nil)
		end
		if data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_REWARD then
			local productConfID = data.params[1]
			UIModelZenyShop.Ins():SetActivityParams_GainMore(productConfID, nil)
		end
		if data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_COUNT then
			local productConfID = data.params[1]
			UIModelZenyShop.Ins():SetActivityParams_MoreTimes(productConfID, nil)
		end
	end

	self:Notify(ServiceEvent.ActivityCmdStartGlobalActCmd, data)
end
