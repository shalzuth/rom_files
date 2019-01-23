AELotteryBannerData = class("AELotteryBannerData")

function AELotteryBannerData:ctor(data)
	
end

function AELotteryBannerData:SetData(data)
	if data ~= nil then
		self.id = data.id
		self.begintime = data.begintime
		self.endtime = data.endtime

		local banner = data.lotterybanner
		self.type = banner.lotterytype
		self.path = self:getMultLanContent(banner,"url") --fix todo xde
	end
end

function AELotteryBannerData:IsInActivity()
	if self.begintime ~= nil and self.endtime ~= nil then
		local server = ServerTime.CurServerTime()/1000
		return server >= self.begintime and server <= self.endtime
	else
		return true
	end
end

function AELotteryBannerData:GetPath()
	helplog('AELotteryBannerData:GetPath')
	helplog(self.path)
	return self.path
end

function AELotteryBannerData:getMultLanContent( serverData,key )
	if(serverData[key] and serverData[key] ~= "")then
		return serverData[key]
	end
	local lanData = serverData.urls
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
	helplog(#lanData)
	helplog(val)
	return val
end