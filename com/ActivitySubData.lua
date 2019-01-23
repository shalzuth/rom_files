ActivitySubData = class("ActivitySubData")

function ActivitySubData:ctor(serverData)
	self:updateData(serverData)
end

function ActivitySubData:updateData( serverData )
	-- body
	self.id = serverData.id
	self.begintime = serverData.begintime
	self.endtime = serverData.endtime
	self.pathtype = serverData.pathtype
	self.pathevent = serverData.pathevent
	-- todo xde fix
	self.name = self:getMultLanContent(serverData,"name")
	self.url = self:getMultLanContent(serverData,"url")
	self.pic_url = self:getMultLanContent(serverData,"pic_url")
	self.groupid = serverData.groupid
end

function ActivitySubData:getMultLanContent( serverData,key )

	if(serverData[key] and serverData[key] ~= "")then
		return serverData[key]
	end
	local lanData = serverData.data.lang
	if(not lanData)then
		return ""
	end
	local language = ApplicationInfo.GetSystemLanguage()
	--todo xde 默认英语
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