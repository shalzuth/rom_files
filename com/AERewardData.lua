autoImport("AERewardInfoData")

AERewardData = class("AERewardData")

AERewardData.DebugString = {
	"研究所",
	"看板",
	"裂隙",
	"工会捐赠",
	"无限塔",
}


function AERewardData:ctor()
	self.rewardMap = {}
end

function AERewardData:SetReward(data)
	if data ~= nil then
		local rewardData = data.reward
		for i=1,#rewardData do
			-- self.beginTime = data.begintime
			-- self.endTime = data.endtime
			local mode = rewardData[i].mode
			local logStr = "";
			logStr = "AERewardData  --> ";
			local dateFormat = "%m月%d日%H点%M分%S秒";
			local modeStr = AERewardData.DebugString[mode]
			logStr = logStr .. string.format(" | 功能:%s | 开始时间:%s | 结束时间:%s | 当前时间:%s | 奖励倍数：%s",
				tostring(modeStr),
				os.date(dateFormat, data.begintime), 
				os.date(dateFormat, data.endtime),
				os.date(dateFormat, ServerTime.CurServerTime()/1000),
				tostring(rewardData[i].multiplereward.multiple));
			helplog(logStr);

			self.rewardMap[mode] = AERewardInfoData.new(rewardData[i],data.begintime,data.endtime)
		end
	end
end

function AERewardData:GetRewardByType(type)
	if self.rewardMap[type] and self.rewardMap[type]:IsInActivity() then
		return self.rewardMap[type]
	end
end