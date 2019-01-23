FunctionCD = class("FunctionCD")

function FunctionCD:ctor(interval)
	interval = interval or 33
	self:Reset()
	self.timeTick = TimeTickManager.Me():CreateTick(0,interval,self.Update,self,1,true)
end

function FunctionCD:Reset()
	self:SetEnable(false)
	self.objs = {}
end

function FunctionCD:SetInterval(time)
	self.interval = time
	self.passedTime = 0
end

function FunctionCD:IsRunning()
	if(self.timeTick~=nil) then
		return self.timeTick.isTicking
	end
	return self.running
end

function FunctionCD:SetEnable(val)
	if(self.timeTick~=nil) then
		if(val) then
			self.timeTick:StartTick()
		else
			self.timeTick:StopTick()
		end
	end
	self.running = val
	if(not val) then self.passedTime = 0 end
end

function FunctionCD:Update(deltaTime)
	for k,v in pairs(self.objs) do
		if(v:RefreshCD(deltaTime)) then
			self.objs[k] = nil
		end
	end
end

--所有add进来的对象，必须有RefreshCD函数进行cd刷新，并且cd时间到后返回true，否则为false
function FunctionCD:Add(obj)
	-- print(self.__cname.." add obj")
	self.objs[obj.id] = obj
end

function FunctionCD:Remove(obj)
	if(type(obj) == "table") then
		obj = obj.id
	end
	local removed = self.objs[obj]
	if(removed and removed.ClearCD) then
		removed:ClearCD()
	end
	self.objs[obj] = nil
end

function FunctionCD:RemoveAll()
	self:Reset()
end