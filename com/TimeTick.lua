TimeTick = class('TimeTick')

--玩家背包数据管理

function TimeTick:ctor(delay,interval,func,owner,id,rawSecond)
	self.isTicking = false
	self.tickID = -1
	self:ResetData(delay,interval,func,owner,id,rawSecond)
end

function TimeTick:ResetData( delay,interval,func,owner,id ,rawSecond)
	self.func = func
	self.owner = owner
	self.id = id
	self.delay = delay
	self.interval = interval
	self.rawSecond = rawSecond
end

function TimeTick:Restart()
	self:ClearTick()
	self:StartTick()
end

function TimeTick:StartTick()
	if(not self.isTicking) then
		self.isTicking = true
		self.timeStamp = Time.unscaledTime
		if(self.tickID==-1) then
			self.tickID = LuaTimer.Add(self.delay,self.interval,function(id)
				if(self.isTicking) then
					local now = Time.unscaledTime
					-- local interval = math.floor((now-self.timeStamp)*1000)
					local interval = 0
					if(self.rawSecond) then
						interval = (now-self.timeStamp)
					else 
						interval = (now-self.timeStamp)*1000
					end
					self.func(self.owner,interval)
					self.timeStamp = now
				end
			end)
		end
	end
end

function TimeTick:StopTick()
	self.isTicking = false
end

function TimeTick:ClearTick()
	self.isTicking = false
	if(self.tickID~=-1) then
		LuaTimer.Delete(self.tickID)
		self.tickID = -1
	end
end

function TimeTick:Destroy()
	self:ClearTick()
end