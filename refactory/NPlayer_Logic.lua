
local SampleInterval = 0.1
local nextSampleTime = 0

function NPlayer.StaticUpdate(time, deltaTime)
	if time >= nextSampleTime then
		nextSampleTime = time + SampleInterval
	end
end

function NPlayer:Logic_SamplePosition(time)
	if time < nextSampleTime then
		self.logicTransform:SamplePosition()
	end
end