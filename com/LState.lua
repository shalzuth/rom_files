LState = class('LState')

function LState:ctor()
	self:ReInit()
end

function LState:ReInit()
	self.running = false
end

function LState:AllowInterruptedBy(other)
	return self:DoAllowInterruptedBy(other)
end

function LState:DoAllowInterruptedBy(other)
	if(not self.running) then
		return true
	end
	return false
end

function LState:Reset()
end

function LState:Enter()
	if(self.running) then
		return false
	end
	self.running = true
	return true
end

function LState:Exit()
	self:ReInit()
end