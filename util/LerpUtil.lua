

LerpUtil = class("LerpUtil")

function LerpUtil:ctor()
	self.callback = nil
	self.source = nil
	self.target = nil
	self.duration = 0
end

function LerpUtil:IsRunning()
	return nil ~= self.tick
end

function LerpUtil:Start(callback, source, target, duration)
	if nil ~= callback then
		self.callback = callback
	end
	if nil ~= source then
		self.source = source
	end
	if nil ~= target then
		self.target = target
	end
	if nil ~= duration then
		self.duration = duration
	end
	if nil == self.tick then
		self.tick = TimeTickManager.Me():CreateTick(0,16,self.Update,self,nil,true)
	end
	self.elapsedTime = 0
end

function LerpUtil:Update(deltaTime)
	if 0 < self.duration then
		self.elapsedTime = self.elapsedTime + deltaTime
		local progress = self.elapsedTime/self.duration
		if 1 < progress then
			progress = 1
		end
		if nil ~= self.callback then
			self.callback(self.source, self.target, progress)
		end
		if self.elapsedTime >= self.duration then
			self:End()
		end
	else
		self:End()
	end
end

function LerpUtil:End()
	if nil ~= self.tick then
		TimeTickManager.Me():ClearTick(self)
		self.tick = nil
	end
end