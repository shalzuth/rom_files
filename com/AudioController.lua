AudioController = class('AudioController')

--interval：毫秒
function AudioController:ctor(audioObj,interval,finishCallback)
	self.source = audioObj:GetComponent(AudioSource)
	self.interval = interval
	if self.interval == nil then
		self.interval = 1000
	end
	self.callback = finishCallback
end

function AudioController:SetFinishCallback(finishCallback)
	self.callback = finishCallback
end

function AudioController:Play(audioClip)

	if self.source.clip ~= nil then
		GameObject.Destroy(self.source.clip)
	end

	self.source.clip = audioClip
	self.source:Play()

	if self.timeTick == nil then
		self.timeTick = TimeTickManager.Me():CreateTick(0,self.interval,self.IsFinish,self)
	end
end

function AudioController:Pause()
	self.source:Pause()
end

function AudioController:Stop()
	self.source:Stop()

	TimeTickManager.Me():ClearTick(self)
	self.timeTick = nil
end

function AudioController:IsFinish()
	if not self.source.isPlaying then
		if self.callback ~= nil then
			self.callback()
		end
		if self.source.clip ~= nil then
			GameObject.Destroy(self.source.clip)
		end
	end
end

function AudioController:IsPlaying()
	return self.source.isPlaying
end