LuaQueue = class('LuaQueue')

function LuaQueue:ctor()
	-- self.first = 1
	-- self.last = 1
	self.container = {}
end

function LuaQueue:Empty()
	-- return self.first >= self.last
	return 0 >= self:Count()
end

function LuaQueue:Count()
	-- return self.last - self.first
	return #self.container
end

function LuaQueue:Push(v)
	-- self.container[self.last] = v
	-- self.last = self.last + 1
	self.container[#self.container+1] = v
end

function LuaQueue:Pop()
	if self:Empty() then
		return nil
	end
	-- local v = self.container[self.first]
	-- self.first = self.first + 1
	local v = table.remove(self.container, 1)
	return v
end

function LuaQueue:Peek()
	if self:Empty() then
		return nil
	end
	-- return self.container[self.first]
	return self.container[1]
end