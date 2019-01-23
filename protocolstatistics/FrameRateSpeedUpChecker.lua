FrameRateSpeedUpChecker = class('FrameRateSpeedUpChecker')

local deltaTime = 60

function FrameRateSpeedUpChecker.Instance()
	if FrameRateSpeedUpChecker.instance == nil then
		FrameRateSpeedUpChecker.instance = FrameRateSpeedUpChecker.new()
	end
	return FrameRateSpeedUpChecker.instance
end

function FrameRateSpeedUpChecker:Open()
	if self.tick == nil then
		self.tick = TimeTickManager.Me():CreateTick(0, deltaTime * 1000, self.OnTick, self, 1)
	end
end

function FrameRateSpeedUpChecker:Close()
	if self.tick ~= nil then
		self.tick:ClearTick()
		self.tick = nil
	end
end

function FrameRateSpeedUpChecker:RequestTellFrameCount()
	ServiceLoginUserCmdProxy.Instance:CallClientFrameUserCmd(Time.frameCount)
end

function FrameRateSpeedUpChecker:OnTick()
	self:RequestTellFrameCount()
end