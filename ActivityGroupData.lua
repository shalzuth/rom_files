ActivityGroupData = class("ActivityGroupData")

function ActivityGroupData:ctor(serverData)
	self:updateData(serverData)
end

function ActivityGroupData:updateData( serverData )
	-- body
	self.id = serverData.id
	self.name = self:getMultLanContent(serverData,"name")
	self.iconurl = self:getMultLanContent(serverData,"iconurl")
	self.name = serverData.name
	self.name = self:getMultLanContent(serverData,"name") --todo xde
	self.iconurl = self:getMultLanContent(serverData,"iconurl") --todo xde
	self.begintime = serverData.begintime
	self.endtime = serverData.endtime
	self.url = self:getMultLanContent(serverData,"url")
	self.countdown = serverData.countdown
	local sub_activity = serverData.sub_activity
	if(#sub_activity>0)then
		local sub_activity_ = {}
		for i=1,#sub_activity do
			local singleSub = sub_activity[i]
			local subData = ActivitySubData.new(singleSub)
			sub_activity_[#sub_activity_ +1 ] = subData
		end
		self.sub_activity = sub_activity_
	end
end

function ActivityGroupData:getMultLanContent( serverData,key )
	if(serverData[key] and serverData[key] ~= "")then
		return serverData[key]
	end
	local lanData = serverData.data.lang
	if(not lanData)then
		return ""
	end
	local language = ApplicationInfo.GetSystemLanguage()
	--todo xde ????????????
	local val;
	local englishVal = ""
	for i=1,#lanData do
		local single = lanData[i]
		if(single.language == language)then
			val = single[key]
		end
		if(single.language == 10)then
			englishVal = single[key]
		end
	end
	if val == nil then
		val = englishVal
	end
	return val
end
