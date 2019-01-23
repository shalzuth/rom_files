autoImport("TimeTick")
TimeTickManager = class("TimeTickManager")

function TimeTickManager.Me()
	if(TimeTickManager.me == nil) then
		TimeTickManager.me = TimeTickManager.new()
	end
	return TimeTickManager.me
end

function TimeTickManager:ctor()
	self.timeTickMap = {}
	-- setmetatable(self.timeTickMap, { __mode = 'kv' })
end

--delay延迟时间 ,interval频率ms ,func回调,owner回调的所有者,id标识（可防止重复tick）
function TimeTickManager:CreateTick(delay,interval,func,owner,id,rawSecond)
	id = id or 1
	local ownerTicks = self.timeTickMap[owner]
	if(ownerTicks==nil) then
		ownerTicks = {}
		self.timeTickMap[owner] = ownerTicks
	end
	local tick = ownerTicks[id]
	if(tick==nil) then
		tick = TimeTick.new(delay,interval,func,owner,id,rawSecond)
		ownerTicks[id] = tick
	else
		tick:ResetData( delay,interval,func,owner,id ,rawSecond)
	end
	tick:Restart()
	return tick
end

function TimeTickManager:ClearTick(owner,id)
	local ownerTicks = self.timeTickMap[owner]
	if(ownerTicks~=nil) then
		if(id~=nil) then
			local tick = ownerTicks[id]
			if(tick~=nil) then
				tick:ClearTick()
				tick = nil
				ownerTicks[id] = nil	
				local stillHasOne = false	
				for id,tick in pairs(ownerTicks) do
					stillHasOne = true
					break
				end
				if(not stillHasOne) then
					self.timeTickMap[owner]=nil
				end
			end
		else
			for id,tick in pairs(ownerTicks) do
				tick:ClearTick()
				tick = nil
			end
			 self.timeTickMap[owner]=nil
		end
	end
end

function TimeTickManager:HasTick(owner,id)
	local ownerTicks = self.timeTickMap[owner]
	if(ownerTicks) then
		if(id) then
			return ownerTicks[id]~=nil
		end
		return true
	end
	return false
end

function TimeTickManager:Clear()
	printRed("清除所有计时器，慎用")
	for owner,ticks in pairs(self.timeTickMap) do
		for id,tick in pairs(ticks) do
			tick:ClearTick()
			tick = nil
		end
	end
	self.timeTickMap = {}
end