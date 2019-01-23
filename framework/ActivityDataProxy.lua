ActivityDataProxy = class('ActivityDataProxy', pm.Proxy)
ActivityDataProxy.Instance = nil;
ActivityDataProxy.NAME = "ActivityDataProxy"

autoImport("ActivityGroupData")
autoImport("ActivitySubData")

function ActivityDataProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ActivityDataProxy.NAME
	if(ActivityDataProxy.Instance == nil) then
		ActivityDataProxy.Instance = self
	end
	self.activitys = {}
end

--   optional uint32 id = 1;
--   optional string name = 2;
--   optional string iconurl = 3;
--   optional uint32 begintime = 4;
--   optional uint32 endtime = 5;
--   optional string url = 6;
--   optional bool countdowm = 7;


  -- optional uint64 id = 1;
  -- optional string name = 2;
  -- optional uint32 begintime = 4;
  -- optional uint32 endtime = 5;
  -- optional uint32 pathtype = 6;
  -- optional string pathevent = 7;
  -- optional string url = 8;
  -- optional string pic_url = 9;
  -- optional uint64 groupid = 10;

function ActivityDataProxy:InitActivityDatas( data )
	-- body
	TableUtility.ArrayClear(self.activitys)
	-- local currentTime = ServerTime.CurServerTime()
	-- currentTime = math.floor(currentTime / 1000)
	local activitys = data.activity
	if(activitys and #activitys>0)then
		for i=1,#activitys do
			local single = activitys[i]
			local data = ActivityGroupData.new(single)
			-- data.sub_activity[1].begintime = currentTime - (i-1)*3600*4
			-- data.begintime = currentTime - (i-1)*3600*3
			-- data.sub_activity[1].endtime = currentTime + (i)*3600*13
			self.activitys[#self.activitys+1] = data
		end
	end
end

function ActivityDataProxy:getActiveActivitys(  )
	if(self.activitys and #self.activitys>0)then
		local result = {}
		local currentTime = ServerTime.CurServerTime()
		currentTime = math.floor(currentTime / 1000)
		for i=1,#self.activitys do
			local single = self.activitys[i]
			if(single.begintime <= currentTime and currentTime <= single.endtime)then
				local subActs = single.sub_activity
				local valid = false
				if(subActs and #subActs>0)then
					for i=1,#subActs do
						local singleSub = subActs[i]
						if(singleSub.begintime <= currentTime and currentTime <= singleSub.endtime)then
							valid = true
							break
						end
					end
				end
				if(valid)then
					result[#result+1] = single
				end
			end
		end
		return result
	end
end

function ActivityDataProxy:getActiveSubActivitys( groupId )

	local currentTime = ServerTime.CurServerTime()
	currentTime = math.floor(currentTime / 1000)
	for i=1,#self.activitys do
		local activity = self.activitys[i]
		if(activity.id == groupId)then
			local subActs = activity.sub_activity
			if(subActs and #subActs>0)then
				local result = {}				
				for i=1,#subActs do
					local single = subActs[i]
					if(single.begintime <= currentTime and currentTime <= single.endtime)then
						result[#result+1] = single
					end
				end
				return result
			end
			break
		end
	end
end

function ActivityDataProxy:getActivitys(  )
	return self.activitys
end
