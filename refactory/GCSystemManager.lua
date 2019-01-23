
GCSystemManager = class("GCSystemManager")

local LogFormat = LogUtility.InfoFormat
local FormatSize = LogUtility.FormatSize_KB

local UpdateInterval = 1

-- KB
local LimitLevel_1 = 90*1024 
local LimitLevel_2 = 120*1024

function GCSystemManager:ctor()
	self.nextUpdateTime = 0
	self:InitData()
	self:Collect()
end

function GCSystemManager:Collect()
	local memOld = self.memCurrent or 0
	Debug_LuaMemotry.Debug()
	collectgarbage("collect")
	self.memStart = collectgarbage("count")
	self.memCurrent = self.memStart
	--打印太碍事了
	-- LogFormat("<color=orange>GC Collect: </color>{0} --> {1}", 
	-- 	FormatSize(memOld), 
	-- 	FormatSize(self.memCurrent))
	self:_SetTime()
end

function GCSystemManager:Update(time, deltaTime)
	if time < self.nextUpdateTime then
		return
	end
	self.nextUpdateTime = time + UpdateInterval

	self.memCurrent = collectgarbage("count")

	if LimitLevel_2 < self.memCurrent then
		self:Collect()
	elseif LimitLevel_1 < self.memCurrent then
		if nil == Game.Myself or not Game.Myself:IsMoving() then
			self:Collect()
		end
	end
end

function GCSystemManager:InitData()
	--gc间隔采样，采样sampleTimeGapCount次，若平均时间小于limitAverageGapTime,则增加LimitLevel_1，LimitLevel_2
	self.collectTimeGaps = {}
	self.sampleTimeGapCount = 8
	self.lastSampleTimeStamp = Time.unscaledTime*1000
	self.limitAverageGapTime = 3000
	-- kb
	self.systemSizeOfRAM = DeviceInfo.GetSizeOfRAM() * 1024
	-- 目前游戏在内存1G的iphone上，运行进去会占400-500M内存，机器人场景测试，lua内存在80M左右，缓慢上升
	local platform = ApplicationInfo.GetRunPlatform()
	
	if(ApplicationInfo.IsRunOnEditor()) then
		LimitLevel_1 = 100*1024*2
		LimitLevel_2 = 120*1024*2
	elseif(platform== RuntimePlatform.IPhonePlayer)then
		if(self.systemSizeOfRAM <= 1024 * 1024) then
			LimitLevel_1 = 95*1024 
			LimitLevel_2 = 105*1024 
		elseif(self.systemSizeOfRAM <= 1024 * 1024 * 2) then
			LimitLevel_1 = 95*1024 
			LimitLevel_2 = 105*1024 
		elseif(self.systemSizeOfRAM <= 1024 * 1024 * 3) then
			LimitLevel_1 = 95*1024 
			LimitLevel_2 = 120*1024 
		else
			LimitLevel_1 = 100*1024 
			LimitLevel_2 = 120*1024 
		end
	else
		if(self.systemSizeOfRAM <= 1024 * 1024) then
			LimitLevel_1 = 95*1024 
			LimitLevel_2 = 105*1024 
		elseif(self.systemSizeOfRAM <= 1024 * 1024 * 2) then
			LimitLevel_1 = 95*1024 
			LimitLevel_2 = 105*1024 
		elseif(self.systemSizeOfRAM <= 1024 * 1024 * 3) then
			LimitLevel_1 = 95*1024 
			LimitLevel_2 = 110*1024 
		elseif(self.systemSizeOfRAM <= 1024 * 1024 * 4) then
			LimitLevel_1 = 95*1024 
			LimitLevel_2 = 115*1024 
		else
			LimitLevel_1 = 100*1024 
			LimitLevel_2 = 120*1024 
		end
	end
	
	-- add 40m
	LimitLevel_1 = LimitLevel_1 + 40*1024 
	LimitLevel_2 = LimitLevel_2 + 40*1024 

	self:Log()
end

function GCSystemManager:_ResetTimeGap()
	TableUtility.ArrayClear(self.collectTimeGaps)
	self.collectTimeGaps[1] = self.limitAverageGapTime + 1
end

function GCSystemManager:_SetTime()
	local currentTime = Time.unscaledTime * 1000
	local gap = currentTime - self.lastSampleTimeStamp
	if(gap==0) then
		return
	end
	self.lastSampleTimeStamp = currentTime
	self.collectTimeGaps[#self.collectTimeGaps+1] = gap
	if(#self.collectTimeGaps>self.sampleTimeGapCount) then
		table.remove(self.collectTimeGaps, 1)
	end
	local count = #self.collectTimeGaps
	local total = 0
	for i=1,count do
		total = total + self.collectTimeGaps[i]
	end
	local average = total/count
	if(average <= self.limitAverageGapTime) then
		LimitLevel_1 = LimitLevel_1 + 2*1024
		LimitLevel_2 = LimitLevel_2 + 2*1024
		LogUtility.InfoFormat("gc 最近几次gc间隔平均: {0} ms,所以扩充gc 内存阙值 1:{1} kb 2:{2} kb",average,LimitLevel_1,LimitLevel_2)
		self:_ResetTimeGap()
	end
end
--如果

function GCSystemManager:Log()
	LogUtility.Info(self.systemSizeOfRAM)
end